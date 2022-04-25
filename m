Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B354650D772
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbiDYDVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiDYDVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:21:01 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2096.outbound.protection.outlook.com [40.107.215.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEA96304;
        Sun, 24 Apr 2022 20:17:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmwFvTr+NLnIV0GMSvj22Mw2FaxEih92Ek9MQ64BdiG/ISjUbmXtXS8W5Hh98H/47Idi0B4AwLcoUkhbulLhYyGnHb1r2Nvshr6LwWeUP5RzPAorFzIwpA9kOKU94T94VZB4QcxDHdSiG6h08uj/sNfGyAGeHcYKFDMh/zXnYzYDbbP7lyVJ+S5k8E2FBTWWppNnrvlSpeUy4VthCQoyBY40cGv4tXWdsjGVohAnb5D+IXU8qJVbODhAAq38oSkf9fzsL72Axav6kkiIM1emPpgNCCCLQC79zCqJgqFCRpQLGw/nWjckFrm1JcmjDKj1QTSeeDz4iAwLgvCX+5z7zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJEdo0VkmkV5vHpoDP7Q2zzYbzzSaXa0yV9RQ/WMbiA=;
 b=Td/XtG6HQra2yKqVtquPyRYcdk7rVQ1ESEwTvAWjGRszHwHPPOdbFZVvSmRu/aT5LceXzfDjFzzh3zR1Q7L9bCMYBfHa4WQCPvFQFIoh5002fBSXkdAbst062BavsemRxda0ZXj7BxcxhiNkwQoGUG/UsaDBCqT8r2OrmbKvWF/I0kOAlnoftAgQSuMbPhPafGOYU9tmB8PkQhF2SeQK6RTOd62tcTGwTOuOY3A1xuZL9aVrlY2oTnI3K8UTqO7ydYd7xuVfBuvRTktCscYC43iFll6YfUjpAA1j5uD9xpT6MD98ksk4OOEmGJf1KGYUAztCONvwI6quVDXt9KZotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJEdo0VkmkV5vHpoDP7Q2zzYbzzSaXa0yV9RQ/WMbiA=;
 b=XxUiv5wTeya1blkuo8V2iuOJfpmlA1SdmgqInjY4NFuELlO9GEdm/pyn4WQJ0AtDPRh19O+J+fciGB1G6tWVe981IKj+4iigicyGV98dKFjLGQyMbYPU5UA2Lkt+HlQMxA5VNPBNRg1ClBZqfV/rVC545vxS4nFu9djtdfMQwbw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SI2PR06MB3897.apcprd06.prod.outlook.com (2603:1096:4:f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:17:53 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:17:53 +0000
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
Subject: [PATCH v2] rtlwifi: btcoex: fix if == else warning
Date:   Mon, 25 Apr 2022 11:17:23 +0800
Message-Id: <20220425031725.5808-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0355f52ad7bf46454af4d5cb28fd6d59f678c25f.camel@realtek.com>
References: <0355f52ad7bf46454af4d5cb28fd6d59f678c25f.camel@realtek.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0069.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::33) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e1e904-b3ce-4f1c-1d5f-08da266a2f67
X-MS-TrafficTypeDiagnostic: SI2PR06MB3897:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB38977A6FBB82AB8A054D9708C7F89@SI2PR06MB3897.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dw8KRBUaDRjesv4Dx+bNPQus+IMlWdbm5ydeFo926D/rR6UCSWGyF8Fp/hwMT7762LSgdoMClU9Fi9XnfVBcD6VRlyF6jqPPysOLhKWF87H9XMd0B+efvDnV3BIxbzUJL35XzylEr2GxaCsddNvQyAhFSEAeslgS1jECJsVRFA8Ozd/JYsRAyxOwQnPOXGh4fo1ZZO8BWUzUmQqRX1FzCKmZycpNGTgiIMqJkf/zzGGz50Ih+4Hj8LQ7P1zY3XZpkWoNOD9+HRxaIhAOF5F4kgy2O00dilGJFJXRzVrJrdG+GmaZ1os23OfuBIrmtk8j7mg4use/F6Hq4NrGHFL8rjoUIIYdS8d4W2sGT61ypMSOfZcj+PnUpr8J1i9RkyNQaCWVbFRIfNH9nADOtzkDowQjsV8Qdn17PwQRl2AjbLqnhMWcwmrSZFURYrXDarmYe/3/jwgC7aWASqba2ebAfGJKcJ2gr3p8d4vcd5RegH5upnWulouSx3tr6MLyX4AxoA98UEmaBGR8KycJ+dyrK+F2arGsnYliUqbVgf8wXOFV0k2rAGkmzn446ExowXZw+in/eO8qjCsQMcY5T1UFis0mdv/4HWCHSHheboPU6GO0pNZf796KVPk83mjyFi1NMZ4qjFeBn1edz2WpJjojYpBxmfKu0Bg2NFTDrFTaPb7kB9EJLlSPIGFv10R5GepJfBTHpw7zdi/FEmt6+7vfOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6666004)(6512007)(52116002)(38350700002)(38100700002)(86362001)(26005)(316002)(110136005)(8676002)(508600001)(66476007)(66946007)(66556008)(2906002)(4326008)(36756003)(6486002)(8936002)(5660300002)(66574015)(2616005)(1076003)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pm/LAZVTmrW3cgP7UxwGPmJEH56oX9v5eDKvRCtbydb3ZXvLAHR6IEcsevAI?=
 =?us-ascii?Q?sz61vD9WVxjkbYkCRYN5V4zqCZy75uD/Dox/IiFid8XH4j24SWjhEYd8yOBN?=
 =?us-ascii?Q?2UfKVN8HA6ESJSbvojtGVsyQAJ6FSm2vEvsL/lrOPEiIvNfI5y5J2yxeh4aJ?=
 =?us-ascii?Q?ns0kolcj5jJIonoEi0xJTcRJjpb93cxxtRiylfFoOGcM581751IHNvvE02we?=
 =?us-ascii?Q?vdsBJ3PoGz+Wtg30xCc+gxG5UtC8pnjufLkZrpA96n7XQ1UMVRJZnKL8FhwP?=
 =?us-ascii?Q?jauHChs97OG0CHgpC5fzev4M0NjuN0AJu6ZjudcW2Pa8LrW0vVMkLDrnI8c+?=
 =?us-ascii?Q?7R6JVyoYDbb3RsHjzqR/iRlP14IK8BtHpq6d3ooAKS8g4OtXXFMr7Nct7Kow?=
 =?us-ascii?Q?ykgFIXWIaOJ2RIxpnf5e9FxvOOZtAbKk60OoLs2f5mfzmRIxIexjnB70mgqL?=
 =?us-ascii?Q?QkCoDuACXKs+kKaTu7736oz20ZyRgqWdlBPCR9csKe8rVeZVSiPPdLNx0+18?=
 =?us-ascii?Q?hSR8pT38+zFcN9CjMP5qnFMxK+/dReyAwIplZdcfR3GKrtmRg5+Rqy6MSsct?=
 =?us-ascii?Q?TT6FeohUUDx6mHQNS2qkYWIeukGw3HtecWNwraw+FH4O2s8P2ZEpv+EEqkq3?=
 =?us-ascii?Q?YXIOlIuAGdXjPGCbQhtjlCPODdzsaCaN3HlJeHp8uU9jutQykZS68pP2VsTr?=
 =?us-ascii?Q?DRiLHUSJeVsQWEBPhSzpgzQ/E11Rapihk9IbSMQF7gNrsT5vYUM8bugJIkrJ?=
 =?us-ascii?Q?K8E1odlqVKd9Pd5TyWh3/aYUpCmYN/W8z3vOA9wwkvfn9KK8sRCw+NDxNLNr?=
 =?us-ascii?Q?WCbn6xuV1dVu3ZIuIQm8lKYfyfYFDQ6MLlCyZnYBruEOAM8p2GOXu5RgXHFD?=
 =?us-ascii?Q?kDHY/q0p25ePoEF1ATAN7CoLrascCbWT4RXEuXG7LpXtljy4N/cwonMMqE+D?=
 =?us-ascii?Q?Dejl6ovTobrcFHZjCjXOvpN701/+Q8rVPxah74g9hB3I8fNOb1XjKCkG1gkf?=
 =?us-ascii?Q?ugcPL/P6MaCf2sVsw4zBtX3QBcH4uNGp5G9FYVn7rGVYqdcPB7AIpO09yLr6?=
 =?us-ascii?Q?uaJjVddGyIjq6WOkBRFXHjbF7qKj2qBajwRMzfFhhIhNyUOYzr+oUE/EelHz?=
 =?us-ascii?Q?FLT2rYSPlGqY9YFAg3ZSao/YEtUro+pajLA1v+HYcpnlQCMtHXH7ol1WSnPu?=
 =?us-ascii?Q?ClEPZayRGXNEMorEXe8mhMBOaifnKfzDnyo8CnDll6zsCvKuZO/T3q9bnNYJ?=
 =?us-ascii?Q?ldlwx8W53JQs0Cef6mAg6TLUCMGTnHhfD476zag9Cc77AOPLcWFea4UYsuDx?=
 =?us-ascii?Q?RvO+5umSZ1B57NlW4yx2cmQq3eSKXueJdMlGNVV5HYrcyhjXw9fCIXARBHXg?=
 =?us-ascii?Q?i1JjHDTabQugvU5E2VTchwgBmo7q7nM9nOC8T+icx8UfDDEqaGW0dFvfKyiP?=
 =?us-ascii?Q?dHTiQzEYJ5v1yOJr4MVLRgQmG2NUp66pU8FEJCT94SwXgt+ybROMjy5U+WJt?=
 =?us-ascii?Q?eKVunzPB++rC55b5LAMAglBewuEqc9/T9i2HLNxb0mv8PByq1t39k7RNZvq0?=
 =?us-ascii?Q?IFUPdIA8aMuhguvU+TmY0QwBdK7TWVCfSlML8uqp8PgNpvaULEOdpooAwrnI?=
 =?us-ascii?Q?zZYjpT9JpHp8x8D2mwGVL6Sm8AX3dWYlV4OsTapC6NbROY1el9dZxzad+Zb9?=
 =?us-ascii?Q?eHUEj3QjaSiDlYuyj2fqxJb/SE0iOJ89a1FgDhqfa6ujgns975hom0jMw03i?=
 =?us-ascii?Q?DTbUYOtjzQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e1e904-b3ce-4f1c-1d5f-08da266a2f67
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:17:53.2365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYOvYXyD6uXEnpuK31BSwDZVuU6XR0Wc7NrWOytHZIoBt8D5TeW5aSxx2rsjL3XEtQekkAnIcjWDE7SacypsdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB3897
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
v1 -> v2: Modify the comment according to Ping-Ke's suggestion.

 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c  | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index a18dffc8753a..67d0b9aee064 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1600,18 +1600,10 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 			coex_dm->auto_tdma_adjust = false;
 		}
 	} else if (bt_link_info->hid_exist && bt_link_info->a2dp_exist) {
-		/* HID+A2DP */
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
+		/* HID+A2DP (no need to consider BT RSSI) */
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+				     true, 14);
+		coex_dm->auto_tdma_adjust = false;
 
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if ((bt_link_info->pan_only) ||
-- 
2.20.1

