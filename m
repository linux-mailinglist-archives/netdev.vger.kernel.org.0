Return-Path: <netdev+bounces-9192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E04727D42
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9048528159D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4724C2F3;
	Thu,  8 Jun 2023 10:52:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A1A3D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:52:16 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9248271B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3qoyl38h3uOsEgimC1S+GdY+brdeAfTSqNIlhRG2Du/Xj42bSjGUFdI7fPuhCeG1FQ+wCSZyO7jW+4ZKgWI1ERlipdAW1Kv6Z+QDeyW/zDSZ8mx4uYk0hxVXx4t89pYfcg35t0npmsimE/A+5vIopAlVf6nmGA660Plu4NAXwVrabSsg1W+GOey11YfhcZiJwOraOecSZ7PlKPH/dARjPMx5MaeyoHZynXtT8/U5hQ1qYozHouLaUNAuM1MR78SMIOp5rv+sd4X7FYan4VDOF0MubszihvS5FWDadIiVnQCFjnp9aVqVgSKD02cxjTrFxcezanFhK8hev+TFq4GSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hilW77sTNVYRVr8/JivmpfVak8a69xVjdwQK05aFjEw=;
 b=J1EOMGBdP7gN+WXT8b2M9TN0s0fJQsb5ByQmRmPqLnn2cAWqqBY8p2fScy7EjpFaYjt9HUyZ5Uu6rMn2EW358ffBcfOuvHVn0YScmnQy/oG82+U8XCVmAPQf1RJU5TAM+LeucfaPW5x+Ylk5dD0d1/gquKQWljiTbgnUyGac6U8D0exIcHKqTUY49u5si/3u89P4/j7JJ5+rO1KI+8jiOctpOyCwCdVJYPxY5ERLXn29b6e0cmOrajteevxgbEcfu6Zy5za+RnvpVdxnNYoHRgWzLqQHX64/o18Ny9e28NNZ8rCqhMoEMtQy8eXy9F2tmErMmi3GvhsiDwWGC0sdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hilW77sTNVYRVr8/JivmpfVak8a69xVjdwQK05aFjEw=;
 b=TIGzuJ8bNVDpzrawUMBhG3DRdsgniugQgV3RBg0GnyaJcNuPgyvPXMWKKy/Khr+qOfyUSIuHa0DNJ6Ad/8ymK4gwhAk3P2tDXqOkH6hCgbGUQiDvrC/cTJpy5PJa421q1z2y6U2ICuU0D+ujk3jvkzng88Ex4OA/pQhhduT0HzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4997.namprd13.prod.outlook.com (2603:10b6:303:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:51:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:51:57 +0000
Date: Thu, 8 Jun 2023 12:51:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Yuezhen Luan <eggcar.luan@gmail.com>, kernel.hbk@gmail.com,
	richardcochran@gmail.com, Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net] igb: Fix extts capture value format for
 82580/i354/i350
Message-ID: <ZIGyxlOyR4Jxum0u@corigine.com>
References: <20230607164116.3768175-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607164116.3768175-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AS4P192CA0009.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b3ee754-5ab1-4b1b-7d4c-08db680e613a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ify1qj/pK6VOl+TbcOcKHON1lHRFJWKX5bIsr5QYcSI+hmUlQnPVRcLkwasMLmSEJihON54XIo2iVuLufa/7N/XlCzI4KLfbn8i4Q1AD1BSFPyafM3M12+uJqfJkIloWiHDKvQ/FH763qeVaUW6pJ66mLfgaBXPCSGBZ/2SmeZMhHZnHQtQa8bmPvo5HYZDaTcrNDh1DfdIlTa3lhKgQqH3ADbXOIc3gvayOWQ0bB4VoD8ABJ66oJKOA983heJYI0z3D66G8VTKxlASC3Y6M9qZSOZTPySRpjYNnJ+eaoLyNUWDdW219N2QDmKuBlKDXZFjlsuHOsRSECT50iG4g65SGFTxTFX4f4JVkzfHNweewwcRg4Z2C2QQHbhBXlt8xN1s4G+EuVVG8noq3GOAIl+WG/JHUpm/B9+M0tZz5r3PpmmnRSYWhOvcp7Bw4ZTKjUwPwAf7bTZIPNg3XgMS0Au5fwxYpixeW90l58B/SQwDkjlGO9DjLWgUTD3E9Ky8dBcrY+Dtw/BVD+cJ3zK7eAJoPLmGgqW957f6cOppcudvwyIgc1Kt94HLD5+VRmGBe/LcRHf0jSpiZWSjGoYCR24Hkx2Ha8X4MOEvCNv9Pglw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39840400004)(376002)(346002)(451199021)(2616005)(6506007)(6512007)(44832011)(6916009)(316002)(66556008)(4326008)(66476007)(66946007)(6486002)(6666004)(186003)(478600001)(36756003)(54906003)(2906002)(5660300002)(8676002)(8936002)(86362001)(7416002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0/LhM7Jm9sBAPFAJPLO37iWkZbZtr47FAjYPYjHzljSK4rS5tX2RoqTmbrGu?=
 =?us-ascii?Q?RkDE8OYhpyp3MSYu/iT+WS8dMjb8O3DUQv9fNeY6ELZWeRiOgoDSKqVu71Ir?=
 =?us-ascii?Q?xfXBFNdGxKWty3KulBsDxvkJ1VEK+qdqsLn9VI+sFK+M1QpQH3Y6/0OXgQ9x?=
 =?us-ascii?Q?vRG04hC6FPkrg2aTxbpjmferdzdpJ9gQsE1aT4YJnmr+XXm8Iao05LecOaAt?=
 =?us-ascii?Q?MISGsL5U+pw1jtRNiNel8l3df99I++NHZfaFQ5hNiqzQnXBQL8A+bj7EzMpG?=
 =?us-ascii?Q?Nq8/ekzVbQOgay4GQQKCHHzCvlNQHh+GQ767V3J4DJJlQBschxF/SujW6amM?=
 =?us-ascii?Q?/lLxETWEBmY0BThgbI1PvmbrWi99RTbAXHqpVFGtK0pCBeMDk4JgOzyPa1U6?=
 =?us-ascii?Q?z/6DtKWu5XEHWrrupZbSCW0hR0boIxDITW/SpTXyLcnc+S+50fCoe4DUyFI9?=
 =?us-ascii?Q?h0NbziKsV4wXlWQYNClJTUh8SiNHjaeAYCMArsXfFUgS42/riX4VqSUrHK4O?=
 =?us-ascii?Q?H2FpQ8kMReTqe+LFCdTtMY6eePW/ZhApMqBl+P8v54GETW+YDSE6qYG3yFLe?=
 =?us-ascii?Q?993y0qubtc74xbvBSyRECFZ158iF3FUOGBx7NOiw7hbgLAHKCzZZLH8dtCPj?=
 =?us-ascii?Q?7EAMZYqiieV7CoBaI4Xb5BV0/m5Yc3jS30DjwRLdkwhk0EaZDeV68yZJepby?=
 =?us-ascii?Q?ax1mj2szFK+SRaZVtPI8H5UFi83FU0pUK/V0fAvMNmU9Y0jZxwCrvDzG0+wM?=
 =?us-ascii?Q?Se64TPr073OXi82BbhpnqEKYD2BW+i8CKP+vMfYss/f0VPcvfn9sAW+RGE7J?=
 =?us-ascii?Q?WPerULXzBDPWFQBTo+fcaCZeoKRUEk+P0YFb75qW1mT/Gj30luPJ28Qa1oef?=
 =?us-ascii?Q?zJ/3DhEcIwqg9kn6biB8si5tupyI3ozuFxRB6G0IbP/GjW0FlBoKrDNS0eYY?=
 =?us-ascii?Q?jZQjzyoeHX0c+U3kcsr5Jx8T9MJrwyr1BVw4XvSzyNYmxt43SxHYiCKw4mwb?=
 =?us-ascii?Q?q/1r4oFnW4jVvOMrvfbbeghcJszrVelqLJBLYyZ+PwClqGyVrUZLwC3EA78F?=
 =?us-ascii?Q?LMWZYmWOKzCBg723Et6tCOK4sdh+pIjdEjG9iZArP1+s/+bn4Ul9SPzAUpbq?=
 =?us-ascii?Q?8UfzupqCU8ZpG6729lGIRg/g9dR8Rkcpdf/ht8kC6/u7ZyibVcay/Hy2sHRl?=
 =?us-ascii?Q?m3Hj7y01txoHn6ZUB7I3LHPSniuoePmvtYlV4xSTY53z/2f4NWSi+O/0pCDT?=
 =?us-ascii?Q?vp6xzOUTkxc8hSbOPlIPo8OfiNC+WWrhjIPaR5y6Oj7Ie1+7nYHcoOYV6NIw?=
 =?us-ascii?Q?citkQfF9xDlz0Fn9zv3fXnoPMeN3GYEQg18uwhgyhp80s49yey4YEdE8Q2RT?=
 =?us-ascii?Q?xPYECxi41CtpV+S3T+iA8MtX9er53PLoqfyCOwaxGQCajuaPIAYx8SSCm0z6?=
 =?us-ascii?Q?obFL2421dvgsneLIdLfPHRWfIP/P2MVY3kkECqupciTyNqrsqXywJbRM+qe9?=
 =?us-ascii?Q?qy9ZB9IRn50o9iHAEj6HGAxbi5V7h2y7RW56pR3PdVcbvCiSEfA+ldr9/ifz?=
 =?us-ascii?Q?DBmo4+xMIClBSKp5bcf6+/FB2aKF/xh2PULO0V2vEsByFZ8cHTsv4c6q0ev6?=
 =?us-ascii?Q?R1ql7+2n6UoKhZGBJEgNLnUm/5KonVx3wlqcIBsRqKjQX/t3BNhzl4Mz0ov3?=
 =?us-ascii?Q?8/LyKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3ee754-5ab1-4b1b-7d4c-08db680e613a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:51:57.4236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4OFkt1V9hGz+bLb9X5unoBZBnOC5qQvFfSUydLcunCAItH2SQAbjnxtmmWBqFnC80BzwMdT/T0ya67lpp9afIXGnGMgSPev1SpDXmaa8pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4997
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:41:16AM -0700, Tony Nguyen wrote:
> From: Yuezhen Luan <eggcar.luan@gmail.com>
> 
> 82580/i354/i350 features circle-counter-like timestamp registers
> that are different with newer i210. The EXTTS capture value in
> AUXTSMPx should be converted from raw circle counter value to
> timestamp value in resolution of 1 nanosec by the driver.
> 
> This issue can be reproduced on i350 nics, connecting an 1PPS
> signal to a SDP pin, and run 'ts2phc' command to read external
> 1PPS timestamp value. On i210 this works fine, but on i350 the
> extts is not correctly converted.
> 
> The i350/i354/82580's SYSTIM and other timestamp registers are
> 40bit counters, presenting time range of 2^40 ns, that means these
> registers overflows every about 1099s. This causes all these regs
> can't be used directly in contrast to the newer i210/i211s.
> 
> The igb driver needs to convert these raw register values to
> valid time stamp format by using kernel timecounter apis for i350s
> families. Here the igb_extts() just forgot to do the convert.
> 
> Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
> Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


