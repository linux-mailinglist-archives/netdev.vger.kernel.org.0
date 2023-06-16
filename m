Return-Path: <netdev+bounces-11374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DA5732D12
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67A941C20319
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E33517FE2;
	Fri, 16 Jun 2023 10:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5E579D3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:06:30 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706D630D4;
	Fri, 16 Jun 2023 03:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeN4YTKTyGsjlRtNq7uQbSoc6Uti0Ft19I0xOTH/ODL/rPmO4l8eoD2+Za2R1UT1gKVHBYe//TV6Zd+sg+n1KUzeUv4ymlwRvB+pcVqMC62Oajn03MVm6NAhiWyghf2DYzTdtIEu+mV+seiDR5tFgJn7OfBEMG/n9cFEXgeRy8Z8Rb/pVY/s0dx/P2H5AgLUK8vDxOQdRKrD9gIbo7C/alMwYZQ8wvjYXzbrXst4rFEG+wYbuYDaUFUnLHjaw/0UI9f1titZH5B0RA23ltykl2Xe9nab314IJKtdHdeSjIKyLkkYm5MMbEVf2ic5nkwzmPltFr5fNasuMwxGzyWSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrPESDAkmlSBr/DP4H12mIHO9tZhLUc+YryZWvPUvaA=;
 b=UaWaQcDseNHuYzLz+V3Zga83QWbultngkfww4yEY80sbM3zpfMp8DYeMyi/L/SU3lYzh94oB2BTDWmXLELctFQ25OPdMBCIiaj7zXd8zpc93nowsUh+N9trgiAN/sObAmtBNvWfKzd7ESXaOXv1bpMCuMXwRbfOwxSRCNf6PlqsqrIM9gGlMmCJgLV2aeZPR0tPuFWhB9JvIymbCo7SxzjHFmcPqxJy2J4i6g5Tt5EVgDVjW8HB/DD8t9DYk6EB7HtJF2/h82LaYQHbpOFJ2XTXKJNluqSKDpQFdrQEDkbMlf4HIZJl6qW/4O5eDiwMHurpd3hUL76i/lgxZYh6xsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrPESDAkmlSBr/DP4H12mIHO9tZhLUc+YryZWvPUvaA=;
 b=YABimtzX9l+XQA+aYkJuVMapRDouOIGIz3t3u/zankqvxljDlT3xyX9ZivtGHG9uELn1iqshyoBmX0SG3VrL3ulZ9Wxwejdi+J/4nPbfBL27bkzyaAFibPNBlInVlVTKPj9ygysNG1q4xBd8pT+up8157Lz4tfqZgSj8UgpgGZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5860.namprd13.prod.outlook.com (2603:10b6:8:49::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 10:06:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 10:06:09 +0000
Date: Fri, 16 Jun 2023 12:06:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	netdev@vger.kernel.org, linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sfc: fix uninitialized variable use
Message-ID: <ZIw0CHsQncwRb0Km@corigine.com>
References: <20230616090844.2677815-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616090844.2677815-1-arnd@kernel.org>
X-ClientProxiedBy: AS4PR10CA0004.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: b5821558-b8f4-410c-33d3-08db6e514e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hZKzEGsZHJ4bvEAU6cYodjyR4KHfItBKSyDOKq6/eIHm+pI0QKDSg67GgBk+xNOHrtJaOOWMEqMzCyN/8CFfGSA3sQV3/jyPc2T8CTk9J9035YL0mYvM1RzZECghd71DoDKnoH8aswTSncGFkP+SmVWAYO0V+wFbcgz+LglBi9IfP3TeSGnpgZfpBUUKaQO/HSzF8Je62P3PsPOJRyM8OzhR4IePNkkRbFGkMnaJqb9Y2EPWyAoFkfy85htEkqqgcjRxoSlv8W8M1M1PV3BbRMccbTVZrLCGOOCDUf0c3+ekdwLAeQ9bac5cBO2KbjPhrZinqteZ0xaVqoTxSNWB9bAmDitNSLXx0WILYTQ2py7VPUg9CWKL05dS34IpeftfxqJRVTCMBXhZR/gptErirCmu4ax+2EQGtKWKO4mBe1p+hdOgODOMdvYjGsC8BdmyPvi9FR5w5bwHncuJh1wYPbRXpSiLbYtS6Hzz3B3dz1R0ecyeAYEIm+K+qFgI1uw/i9LJB5BFV4VwXPwuXjthMlEwPOhe/4iHRRf9RmFSiSepEChToeWKhhFmI2xo5ofirMemorhFSBdb3+/c1YyzCFUCtcaWB8RnSE6KraHVgZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199021)(5660300002)(2616005)(38100700002)(83380400001)(186003)(2906002)(6506007)(6512007)(44832011)(7416002)(478600001)(6916009)(66476007)(6666004)(8936002)(316002)(6486002)(66556008)(66946007)(8676002)(41300700001)(86362001)(36756003)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8nzCsPXl9b9eDSUu0BUiDb06q1mhQVqEjZIuHBbJAPIYdQFdGG8PGDaz4dwn?=
 =?us-ascii?Q?pR4en3eXMlCucLwrS2uaBn6MK3fS2Khwo3dtBejzv9nITvX5FYQQt3lc+9tZ?=
 =?us-ascii?Q?jMNcYmDYE0Zmk56E8pVM/H2r5D1hMOAXHuUca82/QeWRF8P59vhK+zOG1MtN?=
 =?us-ascii?Q?mEmXGLEmIlQ8C1GvVB6no7iVmgubPjYFX5J0DFs9bNKAabOwIoWuJ4SYL4sa?=
 =?us-ascii?Q?KxrSL3gXLZ7SWpQ+ptq9unSnVqgILKF3EWCh6++2s7rS60kWllZr7YLdmDXj?=
 =?us-ascii?Q?rIaq2YOqQv7aJGTwYcLWal+10B2JJbHofczF7McP5epR8OamKdv6YpmHO/lU?=
 =?us-ascii?Q?besjIMhINYC+184jNqwBA5l4TiamSvJ+yABzWIbJvLDWUF7sidXX7VIN+6ph?=
 =?us-ascii?Q?No52xJBfxHepLK/sJObkQVT0dBczlSYJK7Fn1uLhUOyiRjCCucOMwdtnvLjP?=
 =?us-ascii?Q?CsHqR3YeQ87ycgmSBK66/5l1MVSnOHHJFSj8vPGdlt3qJ8z8LfjTIN3yYmDe?=
 =?us-ascii?Q?dRHYIzNa0yz1EJypMqm9paNw0IGlpz9XLIaYZ2fHg8TQmePx+vKZyEpeNop1?=
 =?us-ascii?Q?ortY60mo4f7M+qb4evIXRCCXnQXx8+ts/LsegLXFjkwpIiiNfk4taOgX5vj9?=
 =?us-ascii?Q?XKn+0gDfQJT+BFtirCgB5HeCVxvw/5RVbOiMe8LehW8E18O4QmZBXrKlrG4T?=
 =?us-ascii?Q?kPtF//OABjA81nz8L0kPbqLf9L5fvyWjUBdpZtJGFQMWkeLY3zRhqCLYazzB?=
 =?us-ascii?Q?cDjy/oWn4DwzOb/p3X/+TvhfrxVSb8KBkaC/C8ny87CF4PM61UNhSEdS7uRU?=
 =?us-ascii?Q?hM38KZVulCPPlruyhJuVubMxyyfKVIn1SbylJMoK4OMR/yiXqN7SM7AiSmTm?=
 =?us-ascii?Q?q69m0LdTH6sQqwF8xFTv929fBLYIVA0rbSGRuMAb95pO74sDOahU19gRVqS6?=
 =?us-ascii?Q?JfG4PqPSTkaJPpcUNwnjvlgmIhY5aiaAPJ+M7UJEtxNBW3t0C5sPMm5W55xS?=
 =?us-ascii?Q?0xOdMbgZG317aKjb7VC71lDx7NQ9FG6ZaGTGt3WXkKTJpICe7sjT5EgbU7ow?=
 =?us-ascii?Q?Q8Rb6iJ8kMF/6XXQBhupUb5GDjDWNMAW5+XztaLwdBdWSqZI5/f2+YwH4ucH?=
 =?us-ascii?Q?cFzNDxTqob1WMeyi6Qz9CNyEgXiWN4+8rva2Mvpf97PYRFUUNLGJTRtjOPQB?=
 =?us-ascii?Q?2EeK3FCFFr9LKsy2RadQnOnzfudf9FU8CaBYvKRhNbQPjkIN6Yx3pC+fnQ/G?=
 =?us-ascii?Q?ou6H0FGJHDdNdxgGSa1HaUeuhsajP5rnsLTDsAtuIgJriQc565KSYlE2bn2o?=
 =?us-ascii?Q?4aBGaDwF+pIy0X6uEvfiHzA+IWUnCfqMibQid/fKDjFbpatt314eT3gk5pYl?=
 =?us-ascii?Q?UETKoztS4P4gUwd6cZxYnx8ZHAdHzo6b4YUhJbKSxhGut0N7YcEy8Jpb5Cv9?=
 =?us-ascii?Q?fKV8QXwsUa+7ihI/2NYMmkHyVcFYPG7V8EEoPfQtgFyvcwdIgbj8KEutdqGh?=
 =?us-ascii?Q?ke7MRfPL73Hkq8QHVD87HfpObgS5JtGpu05IHc2hz0pWwrH5UO3OpOImsQM0?=
 =?us-ascii?Q?ugeUodSYnZxRjyhpS7blSvgYQR/UkB+MwevHIYRUty+N5gGt6BvmnF68rTTH?=
 =?us-ascii?Q?Ylj3fxYB1jeMst2ygQYKbkOnxTZL0Ll8sJdcaBhlHLRDmXoCs4Qhqem2GITZ?=
 =?us-ascii?Q?215mtA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5821558-b8f4-410c-33d3-08db6e514e6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 10:06:09.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVQBVAX87oHAjMoBT7fbTK8Yh3sPwTj7cvEinYdQ+vSXwkhKDuXKyf6NhndFKr3OdNO5UcWxHAZ5rit+wTKD/gwe7NZqLAxNE9OQiHX3l5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5860
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:08:18AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new efx_bind_neigh() function contains a broken code path when IPV6 is
> disabled:
> 
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:7: error: variable 'n' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:184:8: note: uninitialized use occurs here
>                 if (!n) {
>                      ^
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:3: note: remove the 'if' if its condition is always false
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:141:22: note: initialize the variable 'n' to silence this warning
>                 struct neighbour *n;
>                                    ^
>                                     = NULL
> 
> Change it to use the existing error handling path here.
> 
> Fixes: 7e5e7d800011a ("sfc: neighbour lookup for TC encap action offload")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


