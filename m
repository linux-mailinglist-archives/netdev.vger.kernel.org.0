Return-Path: <netdev+bounces-11079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F637317EB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E53181C20E6B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32EA13AD6;
	Thu, 15 Jun 2023 11:55:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF95EF9DF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:55:17 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2135.outbound.protection.outlook.com [40.107.237.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A24728F;
	Thu, 15 Jun 2023 04:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hawYRPs0rccdqLpAXIS41omNyQBwcqqDkG7jy34uEdTEY44kRSt1/6UVtKfGiXiU5xmNXtv6QxmhqP/4V+Tpb1imCq0nqdnxHamjOFnbeSKgp06FUeNfoWmPSCYBxCizA22bzt3qTJwbDCS9rfxPB8O8HIP95cp2AzlslEUVokw6F0Gju4CFK8yBaSOWjm9gOJ/todD00Ecc9xK6hmiWQBomyvZhuMOs31JpIDQy6Ipnq6J5PAhwc6DdDWA5WnsFdrEq6fFUn2SXlVDMl4rbSesiwwg6DQkiit1B6Sra2S2ejLGGpmqEE1G2C3tUYIa5i9Re+dBbFwd8Zgf5PzyQ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM6ZTKuDrAm84phO7//Vzlp+6b+MexkWVFuXA+YR4hc=;
 b=LuhEqq6kvl8eBgtAB7vA6zYd4XDEZAgAgwoQ5aum6cjoX6UVs1eIJcBExleB/25SYszQ5BtX04yxRR7CjdYd8xQ7SZ7/1dViCZiGY9knBDB2GA/oB4AAh7QYoZkmFQNFFy5LIwhUYqDuxwZuJA3HXWdgq80vIr+5aDdUO5O5ay+5dljXEoYsdURFj8reFcxbknNB+MXBBoKifXmUe7+kNp4mPBVuAGUkuj5gHArOWbXH1Vc7AVtP1Ql5hgTvhh0N7oWrEos9PT2niGWTky56KXrpTkgucCQSmNK8Z1BGiEIP6o1Q6Xi0YZjYvp1l9jwnEVUgjTh5DBnD7ziEbBGSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM6ZTKuDrAm84phO7//Vzlp+6b+MexkWVFuXA+YR4hc=;
 b=WEVGHYd54zpUU46t4y5tmHKe/NVY2gRM/yUls3kDghgByg8+2tj3D0sZvu6LkJySIiPGckzhOQ2pH7yFbLZGyprPi/UnsM9Xflv3QEhU9qHwJ1fsbw1FP7XWGWH9IR/gyJOR17JtEwSNm5iKeDI/BKKyPX0gCyeYAKzV0GQzlDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5990.namprd13.prod.outlook.com (2603:10b6:303:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 11:54:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 11:54:46 +0000
Date: Thu, 15 Jun 2023 13:54:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Karol Gugala <kgugala@antmicro.com>,
	Mateusz Holenko <mholenko@antmicro.com>,
	Gabriel Somlo <gsomlo@gmail.com>, Joel Stanley <joel@jms.id.au>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: litex: add support for 64 bit stats
Message-ID: <ZIr7/5IJbPjOt0Kd@corigine.com>
References: <20230614162035.300-1-jszhang@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614162035.300-1-jszhang@kernel.org>
X-ClientProxiedBy: AM0PR02CA0139.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fe1b880-d25d-4ba7-793b-08db6d975065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OwsnCDX1bPrRMZTva7TGQYnbXaoO2rnG4n/3jqjp7Tr+EzhSJqosreA6h8BzOjJScoJFjiEgWOg0lX85iXN/gnA0FP3dafXJBZNxUdSyueVssioY2Ngj5n95Ga0IDfM9y4tItw7o+7ajBJb1XAEcq4kgBJRo5CHIMS7jQqXfzqvmRQ6UJ6WESSFijMY6CSiQKhDcZ9jR+KKQ3lA/oAKGXDsaieT2n3zZwxdEAzg/Ff4y/XU9VXRO7pZXGbTmNUqy5khY0e6BeQyqvXjpN7Jcd/x7XbYUBkPqOLBI8buvXVc3FKRG1dfK2789rSzkv1mO1KRIxMYdWUBLYhPgJVxcarijf3nk9MCmqJA/TfS54pE4fXTRJr2iMWltXVtjgfbs53W03B8V+GiSVmydN6cglAAvXFD7tvtgyFwkCzo7bc0UhO/vgRQ9UepHkqPVcdx7iYSvMdJqu538B9B8qxEtAK1F5mZEA57h/JxykoaxerLBdevFFpeOUQ13IZaksdvacMIV+qktFN4iWwYEwZTsGsQGg8fMnmVneNPGbTYXO7RanFXyYWQnnjDD6ppmDcPKzH09sJpZLesekqlLRQLL5DzZ66LIo2hk3bhuMlQBqIU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(136003)(39840400004)(376002)(451199021)(5660300002)(186003)(6506007)(44832011)(2906002)(4744005)(7416002)(2616005)(6512007)(41300700001)(8936002)(8676002)(6486002)(316002)(54906003)(6666004)(36756003)(478600001)(4326008)(66556008)(66476007)(86362001)(38100700002)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vS7dDwBdh9Xl1PHoow7HQMEA8TE4IsYQcypxq6E0lWP31RQlsky01KmdtHwg?=
 =?us-ascii?Q?+KM0nraSVlTFX278bFIzcKEGq03PG03/l6P+p7IF8Rbm1OPP8v4RvFKBIAbr?=
 =?us-ascii?Q?HgsteETwM+AilwxcX67ZU17ZXV4eS1wTwX9AFPa5irrR1A1haQlsHMY5r2gv?=
 =?us-ascii?Q?CtD/tYv3dJVkzy6fWyLFCFJimWDou+y6xC2/rxtP3T7AxU2NQKps4CHIJzNe?=
 =?us-ascii?Q?hS6gMLX9zM6DzoRmBnVy7vuUhJFhDiQc0mM3sOjnsHa0GgRvINTeTTRKTTp/?=
 =?us-ascii?Q?rL6RKaXA1IRcQQClmaYte29wIYY6zysGpnLDB6mMhkGzY+HISnKbYSlDms2q?=
 =?us-ascii?Q?MRV0o/6lWTW264k7YV18QW4aEEiWYJP/Tznspz0e9o442Owmeq6AoMhFpq1B?=
 =?us-ascii?Q?Gc5rIv1Wz5TG07rXL2ZKkQCZE2bzSrz0dflkmSkV7oSkUM3nAvIw5RGxySPJ?=
 =?us-ascii?Q?wgSjBHbb2d86AGe9zZtnJLEL1zl9niCSiP+JeQJpKtgstLFFSofvFLnIv8ju?=
 =?us-ascii?Q?5aP/VMcDyjy8a7oFSrRZ8a0PoiIhiJv+D6cThEDEPwRCUYy49M0tuf+dXklH?=
 =?us-ascii?Q?evhexfH+PgkGGZRNJ/mPT4bA32yp1BG8NMSGelVEYhfKgQGHn0Bb1v4TmknO?=
 =?us-ascii?Q?sRTHry7DSMSmwpINn9p7MbVHyNWFPJkEKRWafR1Vq+KZCF3v6OmIlF2kRsan?=
 =?us-ascii?Q?fbm+26yKPb4+S5fd+cPmvfwl/TV62O1x/O+M8uJ+lhVWSFDmbtpaDlZ84LUY?=
 =?us-ascii?Q?lv8CTEW0scituEYKoD80/2Yj2qxmv9c70qsrvJXEvXmFjujecj8KYLOvvdln?=
 =?us-ascii?Q?5uiHQYMSB88JUtSx8Bf605/g1p/J2CbC8FOxol03tGuFFVmdyvKQRqprd/Ja?=
 =?us-ascii?Q?OebgqezFJhCstHxi68902tqDgc6TpRJaQt2C2FUbC4YUPTugc6L1NQg6VowO?=
 =?us-ascii?Q?r0EIZx+ptAwQ4/SC9bljHER+jaOPul33aB+OMJLTTQvIHX4TLf9fI2aLB5Nk?=
 =?us-ascii?Q?j7/MgTiA9NFA3G4NgfIXq7xsy45kA/Ra3icAiJahcHJaMk+QfxX3ja+Xt8sO?=
 =?us-ascii?Q?Yjr6EzQMvRtcUBUcYLzDhScDMnWaY3NNdTis+4kQYs8Salpm5jfR5BUu4rfY?=
 =?us-ascii?Q?pAj5tzGtocP5LHCDlcIr4IwS5rQVQTndBBI5L2lVqhCPcXOY/PtvSCX2LAdg?=
 =?us-ascii?Q?FZdI912zWVZoqosjCZWaFW7saEbA9E4x6EO9yL/pCGmjizxuqA8Dw+OBwSaH?=
 =?us-ascii?Q?Mf1GRzXveC07sfPE5WthKT+K0fpsdT9PxgTEP2S/pbuffOgf3PPYM7admMip?=
 =?us-ascii?Q?x+XA5nCUV/B3+OX8eU0fdepoNMMddyMjo3FzjNKQzZUTisuyWRA/igncLZGx?=
 =?us-ascii?Q?yEwpbhmYZmXFN4cgEt3wqSyiDtzUysNj8ZhN63bgXpDYOnLj33rx0aNdNr/H?=
 =?us-ascii?Q?v0/LCQMYOEGYEdfIt17rrjEZDDzzLALDvnYKgDPAlNIu4XOzUk2fan7n/1v+?=
 =?us-ascii?Q?rRgAGORGbE0z4vJHPG6ge0deH/Dd6FklLhsPQ2agakcvmO0BCyK/grMMVfEw?=
 =?us-ascii?Q?GRUoluxbRLlZGc/1nztI47jW6CkJACYqH4v/qjxBjsURS4BSDhy71bmd0THk?=
 =?us-ascii?Q?UKaK6v5wMFWT68nLlO+0XOR7LaSzsge9oB48SwM2h7CaQTAkrf4mMTQntzKn?=
 =?us-ascii?Q?wp6OVA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe1b880-d25d-4ba7-793b-08db6d975065
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:54:46.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vU2dr1oaI3S1pgmcklaAlXkfrTazWPqyg+odXkwV82IsvacwLApA7VdKENxQHGahW2/vBkNsqgfdjWI5zJ5YVr6x59lWiyT55J6Xv2HBfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:20:35AM +0800, Jisheng Zhang wrote:
> Implement 64 bit per cpu stats to fix the overflow of netdev->stats
> on 32 bit platforms. To simplify the code, we use net core
> pcpu_sw_netstats infrastructure. One small drawback is some memory
> overhead because litex uses just one queue, but we allocate the
> counters per cpu.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


