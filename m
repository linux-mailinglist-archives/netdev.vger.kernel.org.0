Return-Path: <netdev+bounces-2763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBB2703E0D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA837281346
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2EA1952D;
	Mon, 15 May 2023 20:01:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C6AD2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:01:16 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2091.outbound.protection.outlook.com [40.107.237.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86027D7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:01:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP/Y7QusqUP59UnvhYCtN/slKN4NfA8gZVfLs372frY8WJcV1EnbNJ3NMrbalUADEXP9f2qM/XWkwMETLTqMIhwjssCQj3H0d9pQqRlaBWhoR2YswHnyWn6Nh/D9K03W41FohTgItuTSdk022IreVyp7+KAKVeLAKU/otTdl3XeJeGa57mSXMOWjTBcb9CgwgKbEt8gIDabD1jLbjQJL0BKc2OjYIOSrNMTAYCQJEcs1vljlBrXS5rLYIKdnFExGvFUFYWZmcCozWW8OZXce7uDZCaz6vtCPPGZVYrFcCDbdVjsgznx9lGLNR4GevKfL5ife++6e0M7sbhy5MoU40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yILuzILZQSHEfnxsBg1O5vXvpLQt28C7ZzlHmLpMgg=;
 b=RlLxJJOGnsckUle3szCQ/KCFzCNvNGXvrprviz3e8eTV2MvRu8eV8220RSiP/ABqsWzLARMn95lxNuHjfu7q70BXcoYgd5/ZRgvMvqfLE5BI2Q27VC3/3tQd2Saj09gpD2o/OW5dVoJAP6RM3PVjPx7Lb9Qte4k8uFijbGnE0Omk3e8R3xqcMQ2Pzk3Yz6gMElcf+/HJScLpQULSsN3Gu8CxNa/geaR6/V0HNWyuRdGATMtO1bZwAi1z3Yxg4T67ch0nc6HAy/p/R5Ly+SLX2OtwLUcIJb0kWZm8VJ/IVMn3VMVbPo2+aGaEdTvKxYpLrJ/3o8vwSkr5wNC7cSkWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yILuzILZQSHEfnxsBg1O5vXvpLQt28C7ZzlHmLpMgg=;
 b=ndjNFJbhoCb1/bADvOfq20uKzki2Yo9vu50Tjkk6HD8hgFv4HzjIhlqpnIREbVb+4NGtHkOqypHQoQHGObHV5pXPjtg/smAZXP/sfoUe/YPHvkL8R27Xf3utDCJURfF7X0rd++/DKrNfUTK2wtZqF06PRdHjOE76BXz01qzwcp0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6250.namprd13.prod.outlook.com (2603:10b6:8:122::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 20:01:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 20:01:08 +0000
Date: Mon, 15 May 2023 22:01:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 4/4] net: hns3: clear hns unused parameter alarm
Message-ID: <ZGKPfM5ctobTcguU@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-5-lanhao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515134643.48314-5-lanhao@huawei.com>
X-ClientProxiedBy: AS4P192CA0039.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 271d9a68-058a-426e-68e1-08db557f1fb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SZxMk/E/9Kvdw8/54f7zh4lVXAdlYYC30vKpbv6ySEN3adVDGBornTYRGQqQQjmaV/fdYVFucrUE+Nw2Rpl316+HGJ77JyOukLsxJnoMvhw9H3ipu2ERjhPKwQNdU0furHPYjrv9J2QZyTKZA/87QZK1hGVlrRlEgm2MUQoCO2c/Z+gGUVJQBGGDqbLYOOnAhAarTj5e6u+OrEnST8GmFEzWMgGeouHBGplyfncPlqKEDf3i+iIk3WaAqqadgF+Sbn4hHZwE4DmYd+SgQ1eDGx/s55HfUUuY5kdATUMrjmk3loukZLyY9pKoh1apVga0MvLa2vL+JJTYLUZ0vu5BsLi631O87wfm68R76KNOlTgQpBM44gSjJDpy09XIBg17PzJRn0V9qYVAjk/XMWwWGmgBnmb2KVVjWJeo4CKnQ2HnJ07KGE+E2kYLLqeuKgq5pPgNtZ5BKIAW4HHrJTISHaACfT5lYvhnkBfNKX5kklTNMwtmQLHJNDHj+K6Xcq1qezA0jEFi1ajbSK7cNbXC/ozL8sxYM3yvQfvK91/CZe455Snajh+jnRf4OOIjwofs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39840400004)(346002)(376002)(396003)(451199021)(6506007)(6512007)(83380400001)(2616005)(38100700002)(41300700001)(6486002)(6666004)(186003)(478600001)(6916009)(66556008)(66476007)(4326008)(66946007)(316002)(8676002)(7416002)(8936002)(5660300002)(44832011)(86362001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LY92BwTr71lWJZFGCfAEKIAMATw1d3oH6A9DTM0q5CMYPylvrSFqd4TgGutk?=
 =?us-ascii?Q?NYUJ47gktYvcguaLYDu03UyLNqE2//1PJE0EjHFoM6m71EOLEbTxkHmpDPrU?=
 =?us-ascii?Q?ud8vkKcskzLfKSWrtEAdcT1dW55ZLiK6uhgeO6eoUPcSjxyxdd6/1Oe+gCoi?=
 =?us-ascii?Q?z5lZbNgh1b1SzX7fNUcSJiiuxG8Ikq4e6HRgOXKTvPjYI6zzbRO6gzeCnjYy?=
 =?us-ascii?Q?BJqKAuAOfiQ2TC6t3Ope5iCjacgVOmqhptYcQdMfgySHxWRpi6vpIYdbpftM?=
 =?us-ascii?Q?ggHQHQhAVxTd3swBUETJoIptBCWXA9Dd0aT4vaR6Cgp8QxQWE/ZIzSbMAIaI?=
 =?us-ascii?Q?nTxDrNqNZ+DJ2faGwNBDiGIAiUJG4tyWbwpXQP1jS/15TecK7zesVpAq29ve?=
 =?us-ascii?Q?lsODfzxVn/XDykULIm79STa7Ztl/W01ykVtQSXT1zgSFFHh1DrKD16dhHO2s?=
 =?us-ascii?Q?Lp7EM/e70v8QkUyb9dyV+a6LIaALG0pgU160q3TQh04AOgawx4bT4ovZSSol?=
 =?us-ascii?Q?rRHPm3JYMSBmUysUSagCsJLRAaxSS9tXnCBpiV96lHDW187KMwEtZXYGNOaE?=
 =?us-ascii?Q?NRXbXgXwLv9Kdws6ZTwZImKVf+R4tVv0+CGJUML3AADcJKTLQ+9IIXaTAjQI?=
 =?us-ascii?Q?PKHdwv/VvQ9XqlG4y3njZraLj2gc9djko8TtLCwBmikIbOnr2/jNbCiWtL1w?=
 =?us-ascii?Q?EbdZVYzGfzwwkCNOJzJo2UeF0T/gb6u5L0fv/XiGfI56Dz98P69L5Lwwl+4I?=
 =?us-ascii?Q?0RSbEiTyf6h+uy7AddLO1arZeofIXYQOihhzRB6hXKkyhbRY5f8O9fcK0GYg?=
 =?us-ascii?Q?7yiKdikRqiWanE0/gwHKabF7N3IyPxYZNRR0mEwrgZ3lap0bTR59MQt7fBaw?=
 =?us-ascii?Q?BpVx1+X4pCzMKp9BbxsTTFDO2VYtlaCR7aceyQx7z9SsGafKCkN0clw8uRbf?=
 =?us-ascii?Q?W+Z+vgwiXaM5mVcX50B32RvImm81C3uhVdVxBMnbc3cZJ/6FWzm2ioHdY4rM?=
 =?us-ascii?Q?sAsuqfJSlCj5VfTHoGIS2uxl/8+N1qWPVpc/QDkW9NPacHk7dqD0JZjEkkpq?=
 =?us-ascii?Q?d6dBld8mWgxbhN9TuQHHlD65IQF2Gcri8C94c4ZS0mAIaltVeEtW9/xec2d8?=
 =?us-ascii?Q?nV1y6ckPkdcc/a1I2A6vEQX4gfcqFeCv40QFP/mmrQBpD53NFUK7BHIF7SyI?=
 =?us-ascii?Q?jU3RuZpXz46XRVejR9kQ7jydw8rpPId0W1MT0Jb4HyBZZv56+h7AhnqpTDWk?=
 =?us-ascii?Q?m24Gcl1AiU/d4UTf24Ho3hM3pVcWmoI4MK47UjeXnuxhcUKaXHvOXcY3TiJb?=
 =?us-ascii?Q?dWXnc59Hw1XYI9U4Ba3LjqOHmmqMNdFRFy4JtKCcS/0f87pi1mXv1LUmwBfg?=
 =?us-ascii?Q?s7C6rviPKq0vbkxbK93/W1zf/hJI3Ke+OAQpUyfeF5Qx4xhYSR/nFuyH88MW?=
 =?us-ascii?Q?5I8yyRo1ivsqqCOF3xuy430fkNc4m2c31CYwO2GLC0PZgPrJLbIgLzpz86M7?=
 =?us-ascii?Q?s4EB3i2v6NftAEhfayWxDrUhZlWCQVENS5y0GB1baKB0wT4pXAZMoNPNQB1r?=
 =?us-ascii?Q?1TaPGXPs4SVnq5UXyUnIolOhov9tTlI5RLHgU7zIF6Ott/pos973+vhJj/I7?=
 =?us-ascii?Q?VnaZDOxKUqsCCziqHcs98BJQACO6oOY44wd6EGnT13/wmEn0dqVg6DK4TWYA?=
 =?us-ascii?Q?25PtFQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271d9a68-058a-426e-68e1-08db557f1fb4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 20:01:08.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aeUW4nBx5l6LsTT9GLa/2cqhrgg9hOVgtr+KDkiqiHmGE0bFihM0H2hAeM9F76T5wOrOAbNTEfrmhWWNTwNsNYOCMRGCJK+cDeMa2aWHkiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6250
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:46:43PM +0800, Hao Lan wrote:
> From: Peiyang Wang <wangpeiyang1@huawei.com>
> 
> Several functions in the hns3 driver have unused parameters.
> The compiler will warn about them when building
> with -Wunused-parameter option of hns3.
> 
> Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>

...

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 1b360aa52e5d..8c0016b359b7 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -693,7 +693,7 @@ static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
>  
>  /* iterator for handling rings in ring group */
>  #define hns3_for_each_ring(pos, head) \
> -	for (pos = (head).ring; (pos); pos = (pos)->next)
> +	for ((pos) = (head).ring; (pos); (pos) = (pos)->next)

Hi,

A minor nit from my side.

This hunk does not seem related to the topic of this patch.

>  
>  #define hns3_get_handle(ndev) \
>  	(((struct hns3_nic_priv *)netdev_priv(ndev))->ae_handle)

...

