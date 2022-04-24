Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C3E50D05A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 09:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiDXH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 03:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDXH7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 03:59:32 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2091.outbound.protection.outlook.com [40.107.117.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417D1541A6;
        Sun, 24 Apr 2022 00:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVGyh9Y7XsBjkQCLV08YuFjAXNPqbYDtVYvYyX75rz25loN6OtVQ3BMkeyCRvFC+xpE7Maynb27HwG+cB0+SSiyWP+jkzAS8XeMw62OQM20rnQ6QWmtSJknhg0VCmvdku1KYQD8Rpr0CG/9V7UdvpykXWUxDbDGzdY6wyzTEBFHdVDCVLWdMDt+53KNErJPxbW4RzHosCeskcRuIAR/Yxo5rC5ugGhpMCMh7vKI9yyO4FiOjWOBa+hYxF+9HRPS93PQ082SEMttTRwwlUssUysBjTdD7ESHh0TpxcVFn/UOq8gT7J1ku6fCBu9U2RoYR2Ketak3CQPm3MeW920PgiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nv8HDgP6Yo/iVSvn4myTnf66fmYLevVkUlk257lf4v0=;
 b=mGqri7i03i+91yeyvumMAVZAPyWaCor27i36hRVRmDtD1X1WLdKnVSdd0HK373lxImKvznNviYT5+IhzWQKZJuczq+gEN0cm5Ce2+7Dc42NdssS6F6fiKRssyC262+ZRg4k0Uj+sB5W8l6Z+6J/S79ccu8WVrXiCsYo+rARANACy3pmKkLDAcd503uycMJEu/YF68jlXDiLQG+JWjCy6WQpDafh3+5UQcjo7lN2hUej4XUJStSnzDIGyXHrmhuXAcXlslJUOKWBtTGf8fAy4RzAffxaqFSSUAIo4d295tXEm1D83dTrINIbSVYraGJS01jCxJj4/y5FFHK0PHpy0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nv8HDgP6Yo/iVSvn4myTnf66fmYLevVkUlk257lf4v0=;
 b=VwTTMSUOlBoHVwTCmryhDqJemwfQNDPCW4/FwZTvCS7wnoXn4oQjYeJkN+OKJB9WKRH1P4gL3Zx+wrSbdwrO+fvbMkxPucy3lSZ07IQV7VePJq88hR3MxGtxk3hWKG+TWo94lPl/stQycqsZb0pZzQ5QfBXRvoCiARvXoI0LAPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SI2PR06MB4347.apcprd06.prod.outlook.com (2603:1096:4:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Sun, 24 Apr
 2022 07:56:25 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5186.020; Sun, 24 Apr 2022
 07:56:25 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtlwifi family)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH] rtlwifi: btcoex: fix if == else warning
Date:   Sun, 24 Apr 2022 15:55:45 +0800
Message-Id: <20220424075548.1544-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f64a9c5c-4ee0-4725-747a-08da25c7ee72
X-MS-TrafficTypeDiagnostic: SI2PR06MB4347:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB4347CEFD9931DDB1C02DB566C7F99@SI2PR06MB4347.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSnLbRg72tiRwwdSrqGdcvEuQJdCfc71vRWSTGXacN63qZ3ndGW6N6SgGw5y5vkE4ggUhBjXVYWoviHb1KSkW2gIhLHqRJ9fl+Z/awV20+8GjCy/svVZgniAPhLuheE8l0aIcfWKdD0k5QQUa67JwK7ljnyhGpZFbh7W7qbFwoWqMRg5VFvDbnMnmmTjGRjkcXuZ3xGERxZKnyWkCfGCHxrjYL/w0nJE2bRTNI2W5ST8tf63NYh55LW6eFd0ED6avH/wWn6GK6MAZk5r/+DfGKH4lF4jYv5FpdMjRWgxOQEp67ffuptnwn6MEywRC5XuWrrqXLtl2rIfQKZ8pdZhZmYIYrDBqMgcivLQbXD9JpjsWWql2SlvtRQV5bgOg94yUhbouFWvpUtx2XGR08klykPFarFybkxGh22bA+MWQ6iqO8lnTg7PtClvbBN/uLBNIZ3m6u2n/+wxFVmvMf2z6qfqLhWhg2fPIEyYiJmZMWfAfzN6D91DP4STtT/Dsiu4o/CSLQU7fgG8E6is22VicEBQyXXZlPyOoE7SZwWORH98R/v0Zob3EpGR5pxwehbs7G1Aequ0lYXq2mb/e5YVbrgvDLkxsXtOYjKP10UIXMYoQ+aV/GksczpBHF0n6WUC3YZIb0ZU2wJs5vgeXwL37oSTf0sxWQPvQLUgzUxuzyAj7j4eANH3Nh06cYx9kLVR2P6+RED0QWu0zSRNrJQmCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(110136005)(2906002)(2616005)(66574015)(1076003)(6486002)(6666004)(5660300002)(52116002)(38100700002)(38350700002)(186003)(26005)(508600001)(8936002)(6506007)(6512007)(86362001)(36756003)(66556008)(66946007)(66476007)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfoYWKynT0O16N5ksVq0qPciVreqzDWMUDyyRjEqVqRWB1GzD1ksjxIHyhju?=
 =?us-ascii?Q?QgQYbgoG0W3SD0y0K5jVu1Jq69JkPVOjmEqjkLTY20/LwuEWqTpYOpZOFTZR?=
 =?us-ascii?Q?QiOkQ/QvQKRrgG9wedxRPYwmWub77JPFld/HqtjruSNrAGt+51xPvg8tzIhL?=
 =?us-ascii?Q?gOSicJUvo2cJy7kgppwA9YNe81LJpsjbbJtFTv9hm5kCA+cSRbhTHlIFq0O4?=
 =?us-ascii?Q?pdw5VvlWAL1rhfFC6sbbX93cVdqWYtV7OUGywfkVDZhZRwpyOpBneRHdh+oe?=
 =?us-ascii?Q?9ym3NCDyGpXk6G6mUenODLc+bjLspm6hrdE9+arsQtJ0Q6bTZSL6gEiU5BVa?=
 =?us-ascii?Q?mI53aufFC9UHs6G8GFmf87p7pnD5tK4/pMiRU5cTfjnJ+GBeBthKB/HLS9s8?=
 =?us-ascii?Q?13BqFTeDWOMam/nBq1mZ0aGqEVwGScCUZ4zOQIGol+g7Udq6MCmoENA3OP4K?=
 =?us-ascii?Q?moQzHiQ5mwvFYRuINbTeBFORAWS2yOQY0poJ9TFA2WCWLyR/ZpIXWhAtpmGu?=
 =?us-ascii?Q?ShdaxtqgKmzDeAVMj7+VKhG//tumf1X+NpJccwMDAyB4lqql+cgWo72XErST?=
 =?us-ascii?Q?Pmx0+LgJUqhlP/DCUh2NiswdjRLgNf5tprm3a8nozY7EsZaqRRJcgFLECb5Z?=
 =?us-ascii?Q?5CBXTHdDpn5FB3b2YiMZkvvL6eOzyAVh4k/ctfpX2mfbYn3DC/ad7EuMn3J+?=
 =?us-ascii?Q?Mpu9fz6e08j9h7dSP8On5JHClcUqRuIwqL6IJO+IvFMyGbWPnil2ZhQ8Rn8P?=
 =?us-ascii?Q?W7OTzHEwEZJGMVT4fd7v/UbNS/stgcmA1jv0gb6lWDIBNA5j72xMmhsEliJe?=
 =?us-ascii?Q?uzKz70T6Qw91uNEz4l807nok1x7d9rjQiW8jMmbo6g7ZI8mUsmaMU/FrFs54?=
 =?us-ascii?Q?uZXUGM+Z0IYTBCj2MxFFk3CUDmCc9BCkCmZoIm3rKR46vCfQ3aypmXRMr7z2?=
 =?us-ascii?Q?1Rshk4MnHXs1gTDshlZ7lPBe3WI5gTpPfn8WiAMqO+O1TWGTMP1rlUqEeH3K?=
 =?us-ascii?Q?LBkIG4bI1kwScU1hfEMdOOQtHkDH5PHy1ulfNkr63EcK6UggsIxNn1+5VSip?=
 =?us-ascii?Q?7DoQTj69tApk+VSdmJcuWpragC8E4j9CXnzFjSAzBMFrbUs5OEYWyhclDIwq?=
 =?us-ascii?Q?yQBIcaJZ8CLSlCueILm4xuV6K5ZHoxDblXClny3ypB7eWIPyUsrldrV+aMok?=
 =?us-ascii?Q?AsmT++ndszGbvrj+AFq+TQq1HSYnRenVw+b+mVVFl/ekci99+rSl1tLro09t?=
 =?us-ascii?Q?ygSX1/GMTfSjJuoQYdH5tba7XxLtrYctNzpGk9awMirpDewEZ9oYmx7odJiu?=
 =?us-ascii?Q?e8+IKq82UZMfhTX+bS8d6/5GTW5uIa5z+srP7IKVNysw35CgPjB7QKfHMwRk?=
 =?us-ascii?Q?8Lz6gxTA8anqb3b4a0PC19LswqOMudC7tv9pRWuUA4E08Z/ee7n2F2uA3Ln9?=
 =?us-ascii?Q?upr4zIxpm4dnn++fu909aG9Tmj46FG+WRpKZqc4Ylz1DvXi9RVz3VEgCJrx9?=
 =?us-ascii?Q?kDMBsQmiqkpRFpghB9n8uJZblFggZmNsfTY86asA7day+RfgjNIvxVYS7tiZ?=
 =?us-ascii?Q?b46iq3uuujvfMLNpyJiEc0eN9AjmJG2x0k2bOB6WD2P6Pc3czvpjYhlmRjeN?=
 =?us-ascii?Q?vkSUQ33ebu9RKY8No1GPu/qbjIf3IeNEp6UjX2kIfiEwQ3e6y+2bIWrzDYDd?=
 =?us-ascii?Q?9WBBfM6Ax70EdMz/NzaCBKp4bYHuNX3BICHN7h74gUnQffhUVQr5zs3xej0L?=
 =?us-ascii?Q?apbV1PGbEg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64a9c5c-4ee0-4725-747a-08da25c7ee72
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 07:56:25.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCYIocPYHKjPFoJ/y1vqxT9tIQg2987HwDtrxO2QoKHZxYBIf+V/eyLVRgEagOFYLV1CUe0P0VSox59+BPOoBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4347
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c:1604:2-4:
WARNING: possible condition with no effect (if == else).

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c   | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index a18dffc8753a..2f4c6a37a2e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1601,17 +1601,10 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 		}
 	} else if (bt_link_info->hid_exist && bt_link_info->a2dp_exist) {
 		/* HID+A2DP */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 14);
-			coex_dm->auto_tdma_adjust = false;
-		} else {
-			/*for low BT RSSI*/
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 14);
-			coex_dm->auto_tdma_adjust = false;
-		}
+		/* for low BT RSSI */
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+				     true, 14);
+		coex_dm->auto_tdma_adjust = false;
 
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if ((bt_link_info->pan_only) ||
-- 
2.20.1

