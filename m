Return-Path: <netdev+bounces-11144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79855731B7B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE91F28150B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C468BEE;
	Thu, 15 Jun 2023 14:37:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D216920E2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:37:31 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640E9E52;
	Thu, 15 Jun 2023 07:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbS5Bw+3panGUx3yY+kdQrnEei/zSq0Z46ryBs32aqLKXZsWysR6SgUpflfgv+8hxDSpA/yJKG32n2LzTAjKlP+cvrIm3qp9hiRZtw3zQOXMhKT61IKGrR2HENB8Uh4tlS0C7tDcMKmHdKbG9wJR1Bbi8B5ARNAvTJ3kVUQMjyolV10tkUbsyiKssZs7xt0+Dbw569t2JMvnfVNXF4CAk2JSJA21XbQkI65TYnVoYfAesuun5eQM4ghXjJ9LFTjvFd6douIUd19wLU5GIuyduuJcqHIgH2Mi+I/FjOTnSwIQLT7YTwJcXohXykQMYg6lmj714ED5qgKe7MbuMO45nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBxIk0RPMphWDHzgyBN6RXL1XAlbpm5odqZj4xEjyxs=;
 b=OQjZ8ly26pbnIPJkoN5AlsDWL2TXKCsliWK2Xl69xJKADKgZUT/ngPi7h9XrtlkcVN5yRQAScOPX9pW7bWCfNiaFzQRvPDA4T6s/CWdmpcE8Mz3Lult0+8uq9YbUgromJGUvdYxw2l4JJaZ17rt3ebgeNzeCaLwC/b8qcDJZRT2TP0b9zK1ctkYxoOOgQbJuu5ErCuOnXwDoILrj+aws0BOUjwuZah7Z34O1lbOqJurbLN17R0i+/ZzIrNXDiebkdkK0+mlGsUR7a3LulpvlQsLBL7NqVX69CmP12BAwlnjOJFasRQ01vRobP661ydc++2rMqBpQRznJKpz1t2cuWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBxIk0RPMphWDHzgyBN6RXL1XAlbpm5odqZj4xEjyxs=;
 b=TK5AT+ucy/vrqMcFQJwZ3shng9vCCON8GN3/RSmFtrt+hEtcAC7DhrVGU5/rvUP+r7qbjRkpnCaZHglazUg4lLz4gPLH6cCRfqDNkBWdJD7ShhXbzESuMbvlL/ipXrxHZtBQPDFsJjxlfYRQdyNDNnhgwK8C+ZrzqMiTf/obJjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4139.namprd13.prod.outlook.com (2603:10b6:303:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 14:37:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:37:26 +0000
Date: Thu, 15 Jun 2023 16:37:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: Remove unused qdisc_l2t()
Message-ID: <ZIsiH6sg6BLfixcJ@corigine.com>
References: <20230615124810.34020-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615124810.34020-1-yuehaibing@huawei.com>
X-ClientProxiedBy: AM4PR05CA0005.eurprd05.prod.outlook.com (2603:10a6:205::18)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da3464c-57b9-467e-39a0-08db6dae0a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2BhOhmQwcIWOZVW81KP3a7i2Fr5uV6C2UX9H6BeYxU43f2A0J3V4s7rsoYG7E74vJgjfuepqeCP28Gbq0OdNnVMWGWbFxsq+pYl4BA5iqMo3ARHhn8cviiUFJeod9L+h//JIl3n1Ot08tq5uxOllrEvdRRx4qRIObMX1JSX11GHJ32sRwD0+dzGgq0+1wgHY3pCnRknV9PJCWN5Rq2Mkfiz4cRkiNPk9YhvugXqXiBB6SNTkSLb9kCgIHz/I9i69N2QKFeHKNi68Ha1muTx0UhvNGTB/I+JtksbTek8UJg/YfpILPRlZvOj9g88RVKvH2OwxbatdRp1ola/bvxRztWXjHycXbGUlIVAed991UiPrOU2Fu9NzKg3sA5YTB1IImG+FDev9hOlnHl9GpsYkpnHmLgR8CqRLchA3vy6njYv8vBRgxeIkYQLi3e3Zz6shlnwEOgpx55n8AsjO4E/vQ1DP2yOd04Nvbr1Gc1AC8jgCE3HFA/Z6Od8Y2eOoNwYxhETapqdScdz2Ix8W8+fCp0wnpZzM//PJzS8+7fuYqjpgst23FvOlxNZm4J84pdcRuJ6Yj7qEBzliiFxDV7RF7lJpZwbiSAs8z2EKcgaCS24=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39840400004)(366004)(376002)(136003)(451199021)(8676002)(8936002)(2906002)(558084003)(5660300002)(66556008)(316002)(66476007)(66946007)(4326008)(6916009)(38100700002)(41300700001)(36756003)(2616005)(186003)(478600001)(6512007)(6666004)(6506007)(6486002)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F0RNBX6mweCSXIARzpsLPhjGfTEAQ0lS5AfXkBzBI1ujpwJXSDdZuZPzNEnz?=
 =?us-ascii?Q?3xPFVxekyJ1cilARPNK5zgSwL7m4cYyyUWpy/1mgPk8jeQMxenF4MDNyLaVJ?=
 =?us-ascii?Q?TPnViBtkU1FUtI++9rjkOA8iACC891z7ovAzfE3soaJacpqgFvG0zmmRrkPO?=
 =?us-ascii?Q?coUbchX+6bCIH7d/mGgh68Rbg6ceqVS0dC6APug/xxO3l7avfOQP57lm92w6?=
 =?us-ascii?Q?aKE9Cd0D5B6uAAPKHqleXUVQkxn6dx5qiQJlHwVXOjEEXS0o+BaZP5Gp1qyY?=
 =?us-ascii?Q?41X6/P2X/VoK+7JNC5YEjptdOIs8KLtPIzb0eP2ysn1EqMNLqdr0/MEdjieo?=
 =?us-ascii?Q?DXavFBiAIdLeuPRVk72Obd4gLGTFol96kXAyrc1AvFO+q81sc9d1LP7cg7iw?=
 =?us-ascii?Q?zch/AR12XKvhIsMRCH7PjQtxSRbScXajlUxEQIVLV6sKg6HcyTLpoSxgCs66?=
 =?us-ascii?Q?h2HXPqZyn6vR9LkMc59RXPu+UXPkDR9Jo5rAi1Hesx8pLFg1M1+rgSiKZfU3?=
 =?us-ascii?Q?6I1jGbB84Tb59LkfC3AYpo5bW1TtuRFVAp5gJn/y1UBgIHuT2ok32YkSchDI?=
 =?us-ascii?Q?iHJpuTiKAv/MYu75qezzzb7I+UFx3hWahx26NzS2HyJeObDturQmKQikm2z2?=
 =?us-ascii?Q?gGstFsgp2yv2f53qL579SypnenkwomKe6XbMoYnbN40/IZp+vPw1kfqn2GSg?=
 =?us-ascii?Q?QjjUzEoY7i7s05JEFWjgpGlR5azg96GSqBBL23Hwb+FwqM2rhgTgL5UUBhnu?=
 =?us-ascii?Q?5VGgLwr6eRmTzpFHGii8pHCpN4d+SO+b1pAVKhuv6ZG6n7XAnOerHMyqMNS1?=
 =?us-ascii?Q?fhPWCqRv7uNHFYUVJnvnAFHpBrHXQ4PuRChYS8oYdtX7Xp6UnN1zZsuCG+vr?=
 =?us-ascii?Q?dEtmfFI/eDNqWGH6cjpFnHYWh+uw12JPHUDG5RA8i78vF7haBQbjsX/4SypB?=
 =?us-ascii?Q?Me+f+qflhHwD4NRRUZ3j+QkKKxyzoPq2nNCtO2Qho3knTFpMLhd9H/RlEfOU?=
 =?us-ascii?Q?/USsP39qMAAHh/kJ8aNlGHmWT4R/kZLyXexWSx2/QgRE0xPZ3ODt1cJ5t8AB?=
 =?us-ascii?Q?TmWnhPgkOjj4UGeIBa/hTeW0s2Rm3Q+MPBjosoHyqd7bivstRQn8wtNW+stG?=
 =?us-ascii?Q?ZJtbFpsgm0oxHgRQJTtJEJInDhQAS0JWCquBqfsM1kTVB07sE0/ZFirXCxC0?=
 =?us-ascii?Q?V2dSRCfWUTsCzY86hZrct79gLf4F8/FpFRP0hCdt1NqhqmJIbgQgA6/raHa3?=
 =?us-ascii?Q?GCEY+5EPq7u78jUsqR1I/ffoKL1TQKK/mdrSHSXgR1pNlrfoPog8o2OErkrG?=
 =?us-ascii?Q?0sZ04e+0Q6p/HlTo436tRSu35qLTZi1UdV4uenUmS2naqc2376BUjHMDSMsS?=
 =?us-ascii?Q?Aq0J0HTeBgPyOXbVPk9qm36gA9gt9hrcqiAwKT4Z26x4+nceFZL+JNAaBv6G?=
 =?us-ascii?Q?BltqmpW3L1MMZnVymArc/+yjPZh+Vt2Drn091AnLV86GUmG3NMs84VU6kdTf?=
 =?us-ascii?Q?3d0tx9wurLC2kMHmt+RdWuX0U0jDg+DhwbEDGxp4Vq5Qlk6/NXik55BnDDfi?=
 =?us-ascii?Q?NSOral2NzjS00ni3FBsPLFyRqr10K/vUl5lIrMF466LhE7iYShbgT3pXH6Mz?=
 =?us-ascii?Q?QYDIruds29h0bze5O9EHtc0BKmux/eqEU6xXkb5Z/KQX6cOfklEOSXqNEDf4?=
 =?us-ascii?Q?77QI2w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da3464c-57b9-467e-39a0-08db6dae0a28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:37:26.6573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xLiMKfuWtsGOrI47/qC6+KJImqaF+zeErVutAOYg3m7dhl37yjGFFqVC9ku34GTgNzVSSVHMR2GQ5aWFVgx0CRdg+tvoeMeU3FwONAibJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 08:48:10PM +0800, YueHaibing wrote:
> This is unused since switch to psched_l2t_ns().
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


