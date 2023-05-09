Return-Path: <netdev+bounces-1104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3CE6FC338
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27A3428128A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2A1AD3C;
	Tue,  9 May 2023 09:51:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC83F8C06
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:51:49 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2096.outbound.protection.outlook.com [40.107.220.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00D910E74;
	Tue,  9 May 2023 02:51:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwxG1prstP6fg4Zvm33wh+QaQ6IaL/O+K16qLHaHHrvacejkoPr0o1iooQ5QPT38RObdJ66urQL9gbN1vun0b7wy4nCRhMzc/2cY8yNyybDTXpYsJfZaxCWbxvlaPCFE8Y2Pr98hdbfo7vcYCwJQeYXZNSri/UZyjChczG74VSqvM55JDMCcflM6+YOm25G1jbdpAKST/UUQIJeR66yXG13bCmzcgLa24q4Xyx1M2FKLPC4CC0HH6KgxHpmvoHHXFG3sRdBUDj2oes0VCiBMcyoOwmlaznlgOW77Eja80VRre+E+Umy7bd/JZBCVa2dUurh9RxTUdgL7s+Jy7jPP0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOYKRIxStMcmfzMwZQQvpRY+OjKi6yWngsWlnFVu0fA=;
 b=T4ptn8dNqGzlriU6CJK4TLLhsPEhzrb+mFwhJ/qN/OuK12C3oaz7ryMDXR3uHXazoddYkOAJ/S24nZYr6bLXfwn+XiV6L/WcDA3eZSktpTpCCJHC0ZiUCnUS6hm5nbc3qlKYoOg/a4i7/3mwlB9hOwHEQ7Na6DTiVy9DUZwoPn/ieQTIYvejYv2xv2iQqewul2Ovzh6TB8kAkGLnt8h804kicN2jQT3Ad/19ifA7S800/CL3IO73L+22ux6+X962RtD0N/kLSmemBOI8TNq6YotpWres0M1D+HAsbueDWy5zxRKSkb4m7zoWOSmVaohlhPbyG1kl1IbR5bBRiQ1L4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOYKRIxStMcmfzMwZQQvpRY+OjKi6yWngsWlnFVu0fA=;
 b=BzlWB/Sz1vtb3gylUN/QpvS7qTM2QgxWtNyN98gD4GAezhUHgoumMc7ZXtZA6Mq3daxYpJo2ttt3NiOGLKIMMGFE2X91nSmySuB30xNPmy7XdZCNBgTOzGHDR6iLPQHYeVlcwO1kNQqKH1Ng9pzUY/7IzAG5GwjlVq1ptgiGxJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6177.namprd13.prod.outlook.com (2603:10b6:806:2e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 09:51:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 09:51:24 +0000
Date: Tue, 9 May 2023 11:51:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Lorenz Brun <lorenz@brun.one>
Cc: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: log clock enable errors
Message-ID: <ZFoXlEJ4l9SZjSEZ@corigine.com>
References: <20230507214035.3266438-1-lorenz@brun.one>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230507214035.3266438-1-lorenz@brun.one>
X-ClientProxiedBy: AS4PR10CA0011.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f5eaf6-eb00-40b0-d31f-08db5072f31c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4XwftaVEBmwefY9HXtQRt67PeUBUlwA0LPr8LI9KCCfQFR5k7NsNJx3z4Y2Jtrdx/bQEh4Uj+C0oxFSKQ313APsDJQXna0XvVU3WHbKE4wjvAe3gjregCHmcEcdmWEi/a4DGYIY6VGU0joGTWTp05nQHYGzV2+Cl2IhSLg1FILBzVq7tN6B6gRFp1+SN738eHWkGVch1uAEaTThAHJoaWg7UvhRr52ZbRVyyS2VZ+ml4J6zEk9eiNYZpbbDrtV8W4WVM1GR6w9lsj4X6DFAKsDgWT/URtvaKanR0IVxhJqASJcx+s630Tq/gfx9XlzawqI4wl2jGwHTyQ+0BSWJviQ0uSA1+3wOv/cXNWpnxOkv9z7ZlOe09z8D9SR8lVcL7rxwveLFyTnh/0x/B2qXtFkuOtn6whvEaVxSktfjOIvH2vQZ99bWtHBBbnDag6Fv4D1lkdR3Shu28GF0daJhJ0j0VIZvANljutJwQ1AwW/JhoisPGIeOrx6efMFCQ/olbzRwVyN2RDk5STknmjgZJWVF9YNh4SOXFVhxEtsvp08U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199021)(966005)(66556008)(6916009)(4326008)(316002)(478600001)(66946007)(6486002)(54906003)(86362001)(66476007)(36756003)(83380400001)(2616005)(6506007)(6512007)(6666004)(2906002)(5660300002)(41300700001)(8936002)(7416002)(8676002)(38100700002)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lsb5n3io9Bu+04JSJ9oZuWISgKB+9ZEqiRye7D94KRp8XpebZy1Mexly73Nw?=
 =?us-ascii?Q?evOEMxPgSkOsPEFg+1oQjcvzrxP2BNfoOgM9V5BTlCZP72dr4osl0x0iuKlY?=
 =?us-ascii?Q?MPR+Da3q02JrOtE6CYTGt1ZiXmeTo6zkTJYmkyJPM9MIH4gspkUwiTbAdvZw?=
 =?us-ascii?Q?4U6H1HBTQgeoXcByO/TS0/55gg4iB6DPgcnvUcfMQS9SkpTiZ8ybhluchZVU?=
 =?us-ascii?Q?Ryw9p2swgdX3qJz46iBbR69TdiDay91xfJ8tqSGnEqYGyIxlCRZmKGip26gt?=
 =?us-ascii?Q?Y4MRdgcG3UX98FDWjJdw22bHDTN3ooKg7H6QVQBIYQRkynBPl2OaulilaPTd?=
 =?us-ascii?Q?hfyTf1Ngch5l4p7NsSd7spZi7KywA66rufxeGDHMiPmZTP2W2hR2OVjq8Pk9?=
 =?us-ascii?Q?5y+9god8mHAN3gJVnpDIdM8aCvPKzUiKJ7PzJkJoHqq2FaDceYLeGAmiK88F?=
 =?us-ascii?Q?qjyzBIuJyZ1b8sBMnzQbTlK+/3gsxGG5cCVr88PDqiFN6mkWkRzGe7kEIdiq?=
 =?us-ascii?Q?aoaJ4z4aLBVeYwGrNEO+m1YpGNqQ3uwyvkxx23NYY97v5D2+lihg0HUyhlbu?=
 =?us-ascii?Q?lT65iEjsszNwME+ckYLmQy14BDjUMu2u7GUNSKbsiU2jgFK0vkCS3Qu57Thy?=
 =?us-ascii?Q?q6hmoe+bVNYuKlP7t9ZoX0B0QW70Sy6mKIBTfNAxSArrDIO1uCJtvrTFyAVb?=
 =?us-ascii?Q?0bGFIOUk05uhLY8rZQtSFpSTkCr/5bvAy5syyChrduLQ0z68asz8aHg2c1SL?=
 =?us-ascii?Q?cnmLOIq5l5pSMtjkfGqNtL2OuousjByZiAvTYntLN+QPPbRfTeAbq61bEjAr?=
 =?us-ascii?Q?1aLQE+2Lia7O4fDs3x2Gy3Yq2G3tW0djTUDUGKKA8ZYl7FyQ4yjrfHWEy5lT?=
 =?us-ascii?Q?v1Aoo0fjP1tQOlPacRQ2rCTMBcjIImN0QJwDihZN8HGPZhutlHpZiSwtmBTk?=
 =?us-ascii?Q?zqcFJqmZENCQYjaOzsF8Obrh+jBzMLDUGIllAyJAkMY+izZz1uApPgtSzljw?=
 =?us-ascii?Q?TwxHdMX8+6vQfPhnPOHe/tNQ8msINyvh3/pE5BxnGOiirwY2xS+zivu+hGkE?=
 =?us-ascii?Q?uTi0XcectpZncB7hq9f/wYqEPwXHaIuvPP1z9ibJYYcoyzymCYBCqfap7VjP?=
 =?us-ascii?Q?rcECNqoVrPO3GvXf0vhMWF4NPIRrswAH79P7tinPnYyPwHHVEerBz2kKe9Vq?=
 =?us-ascii?Q?Ty9H24ca7KTQ3MI09u6Ajktyv4KC+u/iA4kgZg4wd8rXRnypMSjXOkZKZAKA?=
 =?us-ascii?Q?Wht4GhyJndQgW1uxt2057Zx6VV0umfCul/11z2Bd9ndHJjkKOUfBgv0zAeNQ?=
 =?us-ascii?Q?0+gmwsLn7Vu44ycLR8kZCKnred6O5a9nImcRcJ8tPN4mXOhD4xBtxY4kj5I7?=
 =?us-ascii?Q?Db3q4wX1kdIWj4bjxyrv7Ryzdh/lajZP8rvdGEqnQw2N4EljQEAbY4pmMGVu?=
 =?us-ascii?Q?XE5zpghIAsGfgCMw+cavHlNUXATRpmX3r/ldNSke8h7LXRD5McXsdW1ZOu7U?=
 =?us-ascii?Q?/1RzHjxm4DiJPqy3lSrFfcUv9ph0ZrTYefXuKgLWelZANLEWBlU3YxEJ1os+?=
 =?us-ascii?Q?V59pY+ELQJnLmSf0KllwnA/ngwj8lIiBWLMsmOYAdI6WGumcTeNKRYX08uwP?=
 =?us-ascii?Q?g2OCN70Ij4rWPqclQtIUNp/g68C2NiTAs4Z+T9lHh5gSi7PIKpwFvQLbT3qa?=
 =?us-ascii?Q?gWY4YA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f5eaf6-eb00-40b0-d31f-08db5072f31c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 09:51:24.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pml78bjzF8tsLvTWS/lmIIuDZSwaYQMd620gneNelUVLg0y5aKYDMMvjFRnQjJdaRps6rz/5mxkCBEJOFq1cbc4tI6hu0UCKbwfydRESCG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6177
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 11:40:35PM +0200, Lorenz Brun wrote:
> Currently errors in clk_prepare_enable are silently swallowed.
> Add a log stating which clock failed to be enabled and what the error
> code was.
> 
> Signed-off-by: Lorenz Brun <lorenz@brun.one>

Hi Lorenz,

I think this would be targeted at net-next, and thus that should be noted
in the subject.

	[PATCH net-next] ...

Link: https://kernel.org/doc/html/latest/process/maintainer-netdev.html

> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index e14050e17862..ca66a573cfcb 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3445,8 +3445,10 @@ static int mtk_clk_enable(struct mtk_eth *eth)
>  
>  	for (clk = 0; clk < MTK_CLK_MAX ; clk++) {
>  		ret = clk_prepare_enable(eth->clks[clk]);
> -		if (ret)
> +		if (ret) {
> +			dev_err(eth->dev, "enabling clock %s failed with error %d\n", mtk_clks_source_name[clk], ret);

I see that some error logs are generated by clk_prepare_enable().
Is it common practice to also log in the caller, as you are doing above?
(Genuine question, I don't know.)

>  			goto err_disable_clks;
> +		}
>  	}
>  
>  	return 0;

