Return-Path: <netdev+bounces-1871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 196716FF5FD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3690281725
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E48641;
	Thu, 11 May 2023 15:30:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980C863B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:30:39 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2117.outbound.protection.outlook.com [40.107.93.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289A5E64;
	Thu, 11 May 2023 08:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpAyOfz2FzTC11bF7n12cInDsY4QIQiq5yriL39CGxkCw/HiZJmiduk6TPQBmsBVUYL50EXDCQRRq9+uFgAOy9gUQJ2gQSv2RKwpnDWr3uVBG9dvX56UOflAYoKn9TwcYS2u/nUyVhqWWQNC7V4wTXZjzjlZpLFMzC0OKn7fusvARPZaLCeG0HPPQqCb7NukXJGcDYE7RQ6pij8Trj3cIk18CM48Nab0zAIhq+SQlMY+QxcTTDXFGQ5kD7ns0xZL0yj+71YeCpca5zf2CrjcXPVluCqofSipAzVHVwNY1k28QYe2ybBX5lr2jBDZZrWKJ2pIL+r4vLCo3jdA86cElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPCDsr2aHXgl9cUNSqCYc4P40ekWRhIvFN5M/tusm5g=;
 b=SSvuz6MoUKNCT69skYwFQmD7WcZpXJEeel8ew1ABotzL6H9RxbW0PgnxeDDM9x1NjeWQx93iZNrecVYrr0ttAjR26PfpxeQUO/+AKgW8ClpsQiouTH9wF4bvYwlfFM5ozukm92t5tBc8DTfwLxzRerW2jmsjkSQ3EOd2c30KIoe3owIoN3WbZGMdEmZPIEmtFl6YYJwzwdtjQ+D3cVCRx/PE4KUVzI5hzyPXK6QBuxoCnzlgbk+U2qjMh1fjoFM+AlF8RGDDEuMRRUTyyKv0bsKnu3GLLXhhtnj1zcsx22mDYek34WEIF4tQHvKx/Sh2kF/QfNo2Tjs9OYl2+VHMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPCDsr2aHXgl9cUNSqCYc4P40ekWRhIvFN5M/tusm5g=;
 b=TR0KlBuLUrS6L2Mc0c2tXVc4nZjtll4Oa+a9k4PUlvNMYrOJslCQOIBA5Sk4dKO+7EiIuIHYT7HW28EtrdtM4gMjdEgzeFLblgazVvbPYmXMfOAHpBGDlccj1ZOmx+pjyqoJrXM0S+klntYFBIyaMX4+z0KnYHB4CSvnOdXqKzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6281.namprd13.prod.outlook.com (2603:10b6:806:301::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 11 May
 2023 15:30:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 15:30:31 +0000
Date: Thu, 11 May 2023 17:30:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH v3 net-next] net: fec: using the standard return codes
 when xdp xmit errors
Message-ID: <ZF0KD/3mHX7tyN46@corigine.com>
References: <20230511152115.1355010-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511152115.1355010-1-shenwei.wang@nxp.com>
X-ClientProxiedBy: AS4P195CA0053.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: 287cf58b-9ac7-492c-324a-08db5234a7e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FaPgVxpdPrCk2y44TEMFbNxQckF7N0wYIygazQy7swLNiGDiQJAyM+wvgdIznschDfPFmDGszMlaJU52/m3eOzywO4bUi6dmznriWiMiNYzCB2q/xs35HbwVe/qzfoki4d/SuqWuFgAFe/vwC9eMw6k+s4PbbkivdbWaQkk1zheuz5uhuzOuehA4XkEiWvQdXkJek8fxgbQVdDtBcoUYgioC8Lar7bqGV+hXX0UzkOW5ItwQ++ahfJuVT+aXtyWG3tzUz78A4X3gLZ42BmGURUUOiA+JdQ/s3stGBsxqCBFINHo820007KDE2fe+3RrwLpVeirh8gGT/ItVwDVRbuxFupnz6IMck5GVzNCX1PcqX5Du9P20RvOMIw1kriTCYSlmE5xeHpi3+mGfCP0sagFyGZyBUW0yyojFin9tkkaDrLOYSAPnaSUDw4sAVPyRAC4P08K9mOn+1kfqFTs9bK3goJG4WiqLEHqHuDbiwX9GKOClFQjDBAOWgsuGmauhXmPH3emzSSGv8PK4Szw3PqlAObnTpLjbH3okH07k+Qh7rPHngyibQmgLyNFQ+bG2u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39850400004)(136003)(346002)(451199021)(2906002)(6666004)(478600001)(4744005)(54906003)(8936002)(8676002)(5660300002)(4326008)(36756003)(7416002)(316002)(66946007)(6916009)(66476007)(44832011)(66556008)(6506007)(86362001)(2616005)(186003)(38100700002)(41300700001)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5z4liIt9kAcPjd751VSDC7lAFXWLVg9n+DeUyh+r7YoYmamKe/6ahZj9X44L?=
 =?us-ascii?Q?DOTgygmNJ7ExHF/G8rJvxbO1M2t4TygOEHH0t0Bp4q5YlNP9g1z8qqcHH+gR?=
 =?us-ascii?Q?iwhpM48L5+saOtPj1LqtBMAzZLNjNT8f0YRUBQK/fTXUK8Ph/xU0nvJlFVfQ?=
 =?us-ascii?Q?MBq7UzG8sxLIILfeEXQ+qF0IKPJOAaAMGhII+5f3fRzK07gARxa0Ba2gtaX0?=
 =?us-ascii?Q?JGkvinLrJ/lClSH4/tnUjaBGpOx2/31gnbUfTOw0Jg8KQvSv8EI/S9Ua9GvR?=
 =?us-ascii?Q?VUGnxbhkN0RtWa9tK/rwrBjs+wu46Y7s7G7PflK9278DmDIo0dYEIgnNxUq5?=
 =?us-ascii?Q?k7WlvV6RpIkNG9h7Qk79PS1xLEmG5kCW0wGE+Cd9AhiU6TAx202lyqHYdqt3?=
 =?us-ascii?Q?0SyBvFKTSJXh3V9hFUznTdyHJwLchvu6ReciMYx8vuqTh7aV6zUlMDARMlVB?=
 =?us-ascii?Q?WNnRRFisfbuznExD60WH6L3E9/yL8ZC9HoOtlCemDK4jcjtiQfQRV7cOT4++?=
 =?us-ascii?Q?Fx7XACjcmnrKDwrVaL8uo4bntagnWlZwWKHzG3oBscPKF2KPDMRGRfBBjSnD?=
 =?us-ascii?Q?uR5PWt/i/bxFWJ4Lq+cdMCqobJHJW0onKnB9rj15yugbarDC0AkWiS1sLlu6?=
 =?us-ascii?Q?de8CFO7k5MpBn49nAepI9cl/huUtaAQZCtPbiVFe1bUBxU/6er25aFxC8EKb?=
 =?us-ascii?Q?oWs10N3jBLHcJFYArn5a97DfB4j0AzGu3kR9SsPpthjpHgeh8s956Ml2u09c?=
 =?us-ascii?Q?NI27xm32vxPWRkbw2NZ5420fOUS+oXAzGtFvjQQxNG0RWzf5usQz8ybjn0dg?=
 =?us-ascii?Q?DyOnKYOOfDb0UI3qycGu9Y3+qZ6F1j0Wpu/oyfFMLwXvsnUmvagJZNI0e2v1?=
 =?us-ascii?Q?II/Q8KjlgIfoFm6xrV3bO7mRSbf/Lv7wf7zuEq37oode6NcfEXnHwJBmjg0k?=
 =?us-ascii?Q?vO3W68D0GnCsBG6Gr2Z5ZEt16A8M/4Mj8/jjt0ANZiumjIeSKLM5b9hFIxwp?=
 =?us-ascii?Q?7uMM72YxxwtTl/6pKOfBQaz2j09rzolgQ3vljlWWt55xLf5Xh3iBxkD0YSed?=
 =?us-ascii?Q?4+ZzTNUuuHXNkA5GvmnIhFhD0FvNtFvFaVEtI1vOOoqC+1aN/bXTGbYaxnbs?=
 =?us-ascii?Q?6zPe65XEWE1hlqUjv4BVq7Q6Nt04mfawhzpX8jRzCvap+oGEc3/KIPm+vu+I?=
 =?us-ascii?Q?NLdoO9cO5iYxkkTeMhQM9CSkJxHVIQB2mCRRnzthGIuNjhJ/7TfYdAhvU5wi?=
 =?us-ascii?Q?7mBuu00hfjLXrJoEq+D3ABPnb5WutR9xEKI3ojiJniGmK7tcUZY+R58QaofP?=
 =?us-ascii?Q?QdqyyfXRB07M4wRVApVgZTj/5gx9sh/ktE7UJZTX2Q/2Bk4pbT/oVS7vMg4G?=
 =?us-ascii?Q?u65/9XHzileJlPGg8BjCdmClwjEl7+SAAMFN+YoSdX+p5xaA0fVXtD4WnUV3?=
 =?us-ascii?Q?fv38gM+7U29V0lfbrkZ+DhGrbdtPrsQGdx+9Wl/ohm8igZbs/kdBYAFDaC37?=
 =?us-ascii?Q?cTV7h0PKAz9SS/jfaBJgMplNf8AdqC5SCH+I8rhU0zeOBMi0YBarpmD+Pxwk?=
 =?us-ascii?Q?No3T/gx9szBVlfQqEzianczgsX71xm/fUYSy7ksgXCqmuXkk4AIVEl5gjb9b?=
 =?us-ascii?Q?YLi0YD1R0mY7UyocMLDAksHu6PlsohtJznH8k1ZGbsTdFvgIEDjBGVHW7inn?=
 =?us-ascii?Q?QAO6Cw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287cf58b-9ac7-492c-324a-08db5234a7e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 15:30:31.4812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7TEjyd5jM0HpK+LBe8g2pABhIqHgHUSY+Iecmu/PvOqUycKav+CiQ4IY08DbTYm1DAq03/Guf8KWLV56m2kSYZ0NG6xx72MKaylD+0JckM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6281
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 10:21:15AM -0500, Shenwei Wang wrote:
> This patch standardizes the inconsistent return values for unsuccessful
> XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


