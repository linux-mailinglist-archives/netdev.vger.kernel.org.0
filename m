Return-Path: <netdev+bounces-8737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC47725761
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67A5928113A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666347499;
	Wed,  7 Jun 2023 08:21:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A576FA8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:21:00 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D131FD6;
	Wed,  7 Jun 2023 01:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDQHR1+GnozoCIBHJImy4X/oFimfO4dePCowKt3kKcR2ccw8G46KpNe/nnxQDaCoolaCli1nocLSsyuxrIigZmDEKDMM2YQ71o+ox9qxwu12i+czbSC8l4SnrHGmVFVtA6Erf/Xt+j/TX1yc1zg4162rhrFTcNQYyWd1YEKmE6j/jP3C/yK3xxwPev7/ksXUDGGNDkqM4aIZ1dhxxitVSPSimymRQoXsAaaV6kXAsradzBrrvYsxRXoytLBE/40okot3OhV4Ch0D2Du562xg/OQEOXWK58snUEesQt4XHYjsx02lLy8jiH3tZk1ySleTbRyU9TTMcLkxQB0HD5PjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YR/ZmXNy/SilguqtFWQXjZgn1W/8DWp7dYFHP5xioq4=;
 b=kQF0TlFEWMZ2Q53xQ0ZDlxRQ7Xb4iDTPzH/5Vf6OcNRRW2N3CDX7RKQ7YIlckYovFGbgtoALHs1MP/fra72Xy+vywG/rqocfsLAPL1vkJ+1L3mwRJYg+mDVbm5D1OHAS0maD70yopgh+cTJbdkU8mXFSZAdOvsy3scIp6e6tdWnXgO6nqeSf3vvoz0l4VVTcKEVEnQB4BLn5gUQVjJIYOJBNnCj3yJKjysMYxzsZ/lBBKg2OE95zBh1FNliEIGkMZ13hKorZL9sCNTk2lhskqh/pqHeEZbsyZkhfIyozxxjGtZ0ya0owd335D1mL02k5sHMcOgbk9QYUn+eCrS0c3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YR/ZmXNy/SilguqtFWQXjZgn1W/8DWp7dYFHP5xioq4=;
 b=EoHTZVoknMfkpeu1FvrawMmh7Kzs0EHHTPFSRR3nYxVxW0SLGTfV+UyyPYsJMBMzyZA+2RolAs4ploHcMbxp/posiTkpFwwiCoSdDwIrTr/Zu65rNR7PedOLMlawtas3Jtq2Hw2O6EJlUKX8qCBJ+RhqrEbSX8B+CD1edR2bq/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6053.namprd13.prod.outlook.com (2603:10b6:806:33a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 08:20:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 08:20:47 +0000
Date: Wed, 7 Jun 2023 10:20:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH 1/3] net: Add MHI Endpoint network driver
Message-ID: <ZIA910jCjl+dxc/a@corigine.com>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <20230606123119.57499-2-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606123119.57499-2-manivannan.sadhasivam@linaro.org>
X-ClientProxiedBy: AS4P189CA0033.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6053:EE_
X-MS-Office365-Filtering-Correlation-Id: 24af3d82-f628-488c-ec8c-08db673017fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ovgVlFcOt6n9d7ucc2CehBBSpEDR4DpeB2555ltUHide8lH1+p84XfwiFkDvgyR4FqMBYBiod8X1qc9Ww/zRIulSZaeJ0bNv/iwoymrRCHwnY0ZBsycpQZoMZx+bbil59zYUgqz2rcLRy41jHABOpvw6S+pG0rr7cZfbSG7ArvMfK/R5v9RiPXzKsoefUoKRHjR2YY8uZ7xJsayPOKDBuSU0x1NyyX+GgSAMBt/Uj0r0PIGew0lunnHWm1vD66/CvVmfIoBP3qR0UsZUpt20vGVqlbqbP8ds4RngM9GxOxM/7TmhWyArSK03rZb0K/Iq6ApPCilJYn/k2ZW0+xTihZPM34EGaukjNigTYU59VyOLpoxgvuCTqfga8O7iIqPJvxDuKikKz2oWdgysIeUtjeXdtMLX3abTY6giBSdrZ+9lvrTFZXWPSGOaMinKCw6fKxeMtfuzpBJbU5Tomc/FRM8fDK1AHFHExfTVz1r6TftFlqwWMQoXXtCZ6TQuY4/CCvGH12QPVyPzPUIG9/MDm3RnZ9+CILbEx82/NcLYO8qrV4wtLdZSExME0vDaTf+V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(2906002)(8676002)(8936002)(7416002)(44832011)(5660300002)(6666004)(66476007)(4326008)(66556008)(6916009)(38100700002)(316002)(6486002)(66946007)(36756003)(41300700001)(83380400001)(86362001)(2616005)(478600001)(186003)(4744005)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9DXySo02p3/mMLv26QWkW9qZIWshdOVAUEJPsr5Mc1wRsVnYAOiBgO+fBu+H?=
 =?us-ascii?Q?gOWdTLniF3Wc3FLbVrwwQ+MnNvLuCnkJhrwr17PbIG+bKFv2N5FFz83VqTva?=
 =?us-ascii?Q?RcawPyea5X0Mcn0UcrzNGrk3UVuyyiM6gnKb199CMqPy9ACcZRoVW8RDoFX+?=
 =?us-ascii?Q?4PQi/pZk2SmWVueYLlTO0v93gFySuwoHnbMCJ7KBV8T1eWxkDHs7udJg+FcL?=
 =?us-ascii?Q?arqCbTOYPSLkJ2b1H/VvsA1FPbwnm9vB7DErHXBTUNhnZstkACtfqoU05YAl?=
 =?us-ascii?Q?aFAiOsLYCtgFevqEuSlxPSCY3n/vdCOkfAgCxRA2suQByUT2sPrHi2qyR61M?=
 =?us-ascii?Q?67rUzsSB05eTPL1Pq6yFtdiwpVV+tf+d4jdnCTaPV+s5r+JRq75eBwFzN60H?=
 =?us-ascii?Q?RIy1AsslbJQDiJy2q+0OXRR7k9JHrjWTvKhKtz70MtSIhmhbudKR544oVF0D?=
 =?us-ascii?Q?dQVxTA28V6fB6seVo0/Zez7A+pys0kaThmyDau8eGeq5Ny5gljjTaGQ1m85r?=
 =?us-ascii?Q?19Fr3aqbbh0O0zHWydEyuV1XupHkdaaADXvHMtikyQHbnggGZ5XayRRM+bdv?=
 =?us-ascii?Q?Bkh50hMUXakQXFAdqzOY6YyL97glfEdDZaigeu+0Q8cvQxIN7s5kzBOqCpnr?=
 =?us-ascii?Q?PtE78AOhM+INDn10Evu79I/fbRoRpMfg9JKhXZgaz89g1bLUBOMfDad6oxw/?=
 =?us-ascii?Q?uk5jiz0Q7MgMXlr9DEcH30BLTuDsu6ElTJQDFP2cgL/R/7m9TLoy9SKV8+iD?=
 =?us-ascii?Q?qU88TCYjJWrzazj/1W8ZnglQxAAM7KKqb3qRsCkwJeggFu6N6R7uIZZFmBMl?=
 =?us-ascii?Q?ZoBVmd8CxwfOGq3ICOdl5nm+NrE0p8smGu3ZPMAExdXF+ODleA+9a37WKRaj?=
 =?us-ascii?Q?yIEw77sJNM/LqE1IIEBGYS9MqtcyS27xT9P7Fk2Jmm4ezwuE8CKpeIojrDmJ?=
 =?us-ascii?Q?qFAdaJV68tCFvVGg7BGVkoYwD7DBXihBUbMpK1mXT+/IiphSfoKCkg0ZHc1W?=
 =?us-ascii?Q?QhNTmH/6zEJdQL0EvaemGH4eRhK7acVMtP5f+IBt+eRfAiX0ufHJ8xUtipGn?=
 =?us-ascii?Q?dhrerB1aPoIPqbulRqf8NqmKmU8PSblFPchC5Qz3AEFOiKroLj7U/ZPt8evy?=
 =?us-ascii?Q?fJmIC18BLO1AOPmHWcGJnYpjEqZL/u20UGsB9C5Dc+LQc2w12Ikgz7edt60S?=
 =?us-ascii?Q?N6V1evqJ1m/CHF5C8h9JzcyXWwpZljQ7946WDZUnh+qAuESlM6oKV1Ln63tN?=
 =?us-ascii?Q?Ir3jEZSZp9UpBMpUdC2xGy9NiS2C3WWd/v+2+5KAUx8NFc6RnnNWSY2y1tcu?=
 =?us-ascii?Q?PIYXpSI/qmCWJ1WNus98QdtzARQ42YfBgnZMJ2aJ3jYZFvl+UqiPwOiTXq8m?=
 =?us-ascii?Q?PRHkwRvzK1eGqcn64qJlQcXKS7YyzVZ3+605HcvUWgANCPOHvBecABeSxfRc?=
 =?us-ascii?Q?oh1ISfHUXm+gQok9f/akRaPYaBv4L2+sfhxjRlp8LL4otPkZkwfu+bLEgM2g?=
 =?us-ascii?Q?phTsXyTNBTrBWLHTm6iz5nnN/+UDlMdpVxM3pDRnMRbnXqGSXg5MR2j+Ps/v?=
 =?us-ascii?Q?8XsVqDHFIabLy6fWhDyLlC7VvW/+BIr9hJ5rjeIYD1VBk1tnxc/8nSdpUCi5?=
 =?us-ascii?Q?hC41/D/jnoyAGUHZSNk9iw+DCkuu0Sub0NTURfRstFQ4DG3MJLIiceD93SdZ?=
 =?us-ascii?Q?zJOY+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24af3d82-f628-488c-ec8c-08db673017fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:20:47.5901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erylb27CsLmvN2mJr1xfPoNhflm2moEkVUvKRUSn8SECa2GNqpdyhpjsKjvIC6/6kEJ0K+opP0Wd5EvaVeCaME7hkWsCL2XGnSyOE7XQJUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6053
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:01:17PM +0530, Manivannan Sadhasivam wrote:

...

> +static void mhi_ep_net_dev_process_queue_packets(struct work_struct *work)
> +{
> +	struct mhi_ep_net_dev *mhi_ep_netdev = container_of(work,
> +			struct mhi_ep_net_dev, xmit_work);
> +	struct mhi_ep_device *mdev = mhi_ep_netdev->mdev;
> +	struct sk_buff_head q;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	if (mhi_ep_queue_is_empty(mdev, DMA_FROM_DEVICE)) {
> +		netif_stop_queue(mhi_ep_netdev->ndev);
> +		return;
> +	}
> +
> +	__skb_queue_head_init(&q);
> +
> +	spin_lock_bh(&mhi_ep_netdev->tx_lock);
> +	skb_queue_splice_init(&mhi_ep_netdev->tx_buffers, &q);
> +	spin_unlock_bh(&mhi_ep_netdev->tx_lock);
> +
> +	while ((skb = __skb_dequeue(&q))) {
> +		ret = mhi_ep_queue_skb(mdev, skb);
> +		if (ret) {

Hi Manivannan,

I wonder if this should be kfree_skb(skb);

> +			kfree(skb);
> +			goto exit_drop;
> +		}

...

