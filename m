Return-Path: <netdev+bounces-7793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E631721871
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAF881C20A40
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A166101CC;
	Sun,  4 Jun 2023 16:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E098DDAB
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:08:11 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2127.outbound.protection.outlook.com [40.107.96.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8E5B3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWM8hAuwtqsppa8lO5/ac5w4wz0hTt5J22cq4kd9Ea82oaHCHhhr5p3+KGw8ErrOGJ+0ESN1cMZtXWbqharinQQJiTY/qerDH9j8BnZZBst7eOnQjh/OoSWpFkR4QtTrQKOsBdu9Iprr0JIVk+W8slxDrNr0B7KvsDyan0coldL+yDdabrtdQwCm7pdABI+gMf3uQ6WiXj4d9Z5fUj3t2IyT3p4CnKE5cQoUN9vDCadjzKy+pq7K/BwIap9fY3G9wwuyDxtIe6Bhk38CMnt0U/s2lgyga1hvkGB0iOgUfXpqNH9mIj1ikEzQnwGtE4x2y+E0t6/dgikD59CLCyHP3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSen1C+cclMdseqEhoIdjh7NwF34MaNMB+zOKnsNkOY=;
 b=TagsPNjBDDF83grV3i5xFtSG7F30pdMlUtiFLygdZf0iUyyspaTlNZM3IEbC7ZmMOBT3377EjESYKqbCp783dVJZf4jzxn0LqYd1Ffehn0yv8B7NkMHl/P+mp8azSediBjP9shbkGuMvQO+IyCdkbmJG6B62NATlFwddlsRJEHijSv71v5k6XmYErT/QBHJb/bmVBTFxl6HzQHEUFvsDgnrHRnKskSsOVdrBwbQVjNy+01+KQpWAp/XLZiYpcE+Ko6wnCOT0h/CdMvUbBZ4kvkVQAVpcPc8L40C06XoEQ29ooeSsrNmgJO3VYCY2Q06ZKl6cNnaKQCc5c/zrHuqWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSen1C+cclMdseqEhoIdjh7NwF34MaNMB+zOKnsNkOY=;
 b=uQHKMrKtq7537uq3UGBvRgq4MVRUCgpuB07NQss/Uof9+w3uJstLeBI7/CHx/S6TLNqvoCQ6Vq5RTvTh1kUj0vu7hsBuKW2mjiPTPvDhJMjnZ+v8woKyuiy0FvHCr+zHHTzOFCWKk+xFjrJ4h4TO1pPCrsON6huotk1ZayUquIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5356.namprd13.prod.outlook.com (2603:10b6:303:14c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 16:08:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 16:08:06 +0000
Date: Sun, 4 Jun 2023 18:08:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 08/13] ice: Add guard rule when creating FDB
 in switchdev
Message-ID: <ZHy24EDbl+zyIjsU@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-9-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-9-wojciech.drewek@intel.com>
X-ClientProxiedBy: AS4P190CA0058.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 66f10414-b25f-4b53-aa4f-08db6515e1e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JcHT8UDOriFV0dF4KRQdv1McpgntUhL4eJzqxz7gUTDHKZCcTOkkmIxfc/mLFKx/UQt/lFF1M5NQFMojX4u8yr6Ow5BVEQavZP7QHmrOw5It2g1r1pAljP6Rist2KXJAsLjAp4gEilLJ9MauhWFxVinRujVdNuT7y6l876ylpRKii7zvHI0Y2azOxtJEa5Zznq9yia1yujyapI7NDSJGXsMqFBB0Z5KDPCygt8TbRUkHbOqbw6MDKri7gQc2mIQkfkhPp4/M4gvFmFUru31wLYHVrh1RoLjuXXQVmm8D4Dzlgt1z0l5ZJZx+kAJvSi1srdMWnAicfJfcwQ/yGsdpRqF/XY2SxvpW0n//Sr13GvWFZmnGxJ6/HQtbiwFI83PBILzd3omqUM49045fHgdQ6V6BZuW52jAycoRxYa40HEtcaxmh+kIP5vs/wUBgAHW6e55RHXNsT/qV3HB9ePNeIEzd4V7JcHEYZT5jJ8vNz+hXvI5HxLgeESEEKXkYPvrWmjjUEgEixUk/c11k098QUaEnV86ECjoBZ85U/gQFdvOCB3csEUgj+Ln7VvR4mnHKsDT2SVg64fPUlnLtFkDeqQEaG85cdELQG3JPDsV7rJ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(396003)(366004)(451199021)(41300700001)(8936002)(8676002)(5660300002)(7416002)(44832011)(6916009)(66946007)(316002)(66556008)(66476007)(4326008)(2906002)(478600001)(38100700002)(6512007)(6506007)(86362001)(186003)(36756003)(6486002)(2616005)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J4PjWYO9qAYj7Kb4zbi4L00xlGLc0TCCca/PaWJPU1X0F9x4KsiqNA3CULY1?=
 =?us-ascii?Q?tLz/ULjG3VhAeJNyXO0soGsyLkb/HpCUiTQB5K6vjII8f9CX66snTUVlf2It?=
 =?us-ascii?Q?Muldg+hHH1CxqHBol8tr9O9gT/mbBEZAsoPsp/JDF4DkQvK7/SkDjV02UDgm?=
 =?us-ascii?Q?vqVVtjQoISsxEqsBL5AWjOcQt0KV889SCiLHjf4WV1j3OvXtUoaU0EuxELAx?=
 =?us-ascii?Q?p6Ey4wlxJYOyoFZ7/dUoVoatF8Y+15AHZALXrtIS8wW1TbFlSw0ayKzdMPlo?=
 =?us-ascii?Q?JAsPrOOgIMTUEuc8mqR3HFCb+uxx2GKyfFt0TeHlzSG7mRxArMPXRpNk3zC1?=
 =?us-ascii?Q?nrZ24HPgmP2juD340cDl+oJrc2Wq+7GNAj+vID82zMyzdne8oVDmJkg2O1SK?=
 =?us-ascii?Q?7Uj+TAmADf6MicN9EwO4d4OoT22gEC/0S1it7czoMwHTmySfys28ZRBrpVXC?=
 =?us-ascii?Q?dounr+gMyXSDv9zC0kmxL0dCTcJVCgS0kn+TOXHI8QOLX1n6K7bLQfuMr4hb?=
 =?us-ascii?Q?vVNfx3uE1uL1Yg4QkDSZGSQ+TNCoJudsxixWOwUT9+wO45V5c+Qx1rqpGqQ8?=
 =?us-ascii?Q?Z3hIPkOl052rXtkqHsXvnBlHjmmzujY92sSDDzZGvhx0//G2Rj/bJ9RxJM1e?=
 =?us-ascii?Q?m8aRRV3Ks7N76o/1GWVfbWYvB0kGDpBKR3W/MQ6+nilq6hrqlJYnUGEb9EFL?=
 =?us-ascii?Q?4cqx212PrHW1abjIXvP5kdtnWA6Rt6Q/+XnKHxUajJ1JWXfP92yRI9P+GOoj?=
 =?us-ascii?Q?PjlpI06pQwWK12nHVzTEvMtdHMPc8/pRG+GHB/yVBEVeB010lta/syEuAjMu?=
 =?us-ascii?Q?4yqZq1V77RYfsdPrGzk/WXOlyTmehn9/flZW/J9zbDb4L/jZihCc73pb2QT/?=
 =?us-ascii?Q?x8QvGy7iz8wb40yiTt/HLzu7iwlWd4EA9mPgr4Q2T0q1PT42X8crqX6fTRR4?=
 =?us-ascii?Q?BKxYuuqaIfWg+rnluqIF2T5WK6xbH7obTmCGPS6q2imThy6gI7MHXFLjfqsX?=
 =?us-ascii?Q?E7K50ubeMjifCV4wQbuRHlICY3w69o2NqSdTt0/YVk92Jp5T37Fqoak/uKB3?=
 =?us-ascii?Q?XOGK9Yz+Kgqoojm0yWJhN6PUkR5O4p566kWicp+Rbwh+eDV0tqqVBgWXxxGZ?=
 =?us-ascii?Q?EbBS90ETZQ61y3eewZuxbIROvRa4XaLBHquD/8itil0r22edBXjFLVDrSTTu?=
 =?us-ascii?Q?g6KooRBKwCXwrurtpnLVJREmCrn+7jnhJPYo1TvUKVCP2P6MMZCEefKywCnT?=
 =?us-ascii?Q?9LTuqI01lSc9zjt7SM2HTJ3G4yd8GiA8P2JPoo3Calp2qO8tyjCTMnKVOZiP?=
 =?us-ascii?Q?V+7ka7rjsGzg9RoYFebvciZluQcflovpAnnHVgOFbXFiubAxltPkinhU0QIP?=
 =?us-ascii?Q?ZuMOPBbYjDTwWN2/VQ/W6etzUtxCod788aznMJP7VWyH6vHicJq31s0NvBkO?=
 =?us-ascii?Q?KMaqgn0yQ1CsMT6WHfeQAyfejP9dj4UOlmgSecx6Y8NNTO420DVcNwA7qCcq?=
 =?us-ascii?Q?kJ579VznwNNUDiEONgGXVjkGDth/6FwjaqmAwYIC2d5lAH29EFOaH85tDVlA?=
 =?us-ascii?Q?mG9gDv6e/ge9cZpkxUMIg2Z9dggbAxiqpRaodNKv6ciqr7pbRC0SXlQtRTHF?=
 =?us-ascii?Q?fXF2TbXM6XiG0yFtm8v9mg+FUwJBPcTF4ykI5pixFNvEcWWeWnEG7J722DBr?=
 =?us-ascii?Q?eBrcSw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f10414-b25f-4b53-aa4f-08db6515e1e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 16:08:06.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/pHaEnGeyXlDwlkYTt6HAPSrhwqls8/TY7h0RQR8H6lDYp7n6EbRVa9kT5m4jD0P+Ep9yDhzzoV8vLbZm910N+u4g09/0dlxZGpP/fAMo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5356
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:16PM +0200, Wojciech Drewek wrote:
> From: Marcin Szycik <marcin.szycik@intel.com>
> 
> Introduce new "guard" rule upon FDB entry creation.
> 
> It matches on src_mac, has valid bit unset, allow_pass_l2 set
> and has a nop action.
> 
> Previously introduced "forward" rule matches on dst_mac, has valid
> bit set, need_pass_l2 set and has a forward action.
> 
> With these rules, a packet will be offloaded only if FDB exists in both
> directions (RX and TX).
> 
> Let's assume link partner sends a packet to VF1: src_mac = LP_MAC,
> dst_mac = is VF1_MAC. Bridge adds FDB, two rules are created:
> 1. Guard rule matching on src_mac == LP_MAC
> 2. Forward rule matching on dst_mac == LP_MAC
> Now VF1 responds with src_mac = VF1_MAC, dst_mac = LP_MAC. Before this
> change, only one rule with dst_mac == LP_MAC would have existed, and the
> packet would have been offloaded, meaning the bridge wouldn't add FDB in
> the opposite direction. Now, the forward rule matches (dst_mac == LP_MAC),
> but it has need_pass_l2 set an there is no guard rule with
> src_mac == VF1_MAC, so the packet goes through slow-path and the bridge
> adds FDB. Two rules are created:
> 1. Guard rule matching on src_mac == VF1_MAC
> 2. Forward rule matching on dst_mac == VF1_MAC
> Further packets in both directions will be offloaded.
> 
> The same example is true in opposite direction (i.e. VF1 is the first to
> send a packet out).
> 
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


