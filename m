Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E3766D175
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbjAPWJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbjAPWJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:09:42 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B82686E;
        Mon, 16 Jan 2023 14:09:40 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GGRBoc011355;
        Mon, 16 Jan 2023 17:09:26 -0500
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2235.outbound.protection.outlook.com [104.47.75.235])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3n3rd222fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:09:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV2ypfOUh7iK9vifY5fmUYYplzFijUD4JGnhEEAYtLMavL4uUOGOFRJf2gO3DuL3JbF4/1IoBLGQhsbmLchtAKlEhZu0USO78++8Byp42yCB2hSOJYbg0WN8ZuytVCWhKIdJszxPMQHeKC+Rojfs9xKLp4HUCnQVB1Dphrl8g2hz/sv+4M/zjsLkHcxzYqGqiLbpXCcasr+rUjvBmjVnluurBPsTTMdQMVtyI8h7g3wZdIuTwneM5oSMlbmsn0nLjkaYpW5RvTWSf1t2hljKF419x8+L661QICYeYs+X0k9zVo0+WhXhpMMqeczx6+PQUDmoytBDLOp/u86+Z+iN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPD//HD0HMj0ZK4P9Z8Kd1Zv6D9utqkPp1QBFCiBv9U=;
 b=oTtRe+IMDQkkH8Cyyn1ubwvC+Ei/WKTRIDwEaonr2pt6Xva2z32wqHrbRjkoxh/1qqZKc+JzZgkX1HxRrL7+upe5c2SJBhjCS5QzsryfgJtqbSI3K2Aw61R/k8lHKd30TT0Ly0S/LTlfPB9qOWhKS0TpSVtIem5mHjYQD3DI7HHqob+5qY39dXe6WKhjGGJ8BDUUgjSFloK31tBxFpkhMLAsUJia4+YUO8U2xnoesmBVWEMtnvmEPSqtvzNJSJeOqDbW0o1ADYCHujgezOy7fb0+ZX2x+pdG5sM8JgRBfQRzvD0CZ92N90/oSWpTqEXWJ6+MhYKxVEqw3VwTlqxHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPD//HD0HMj0ZK4P9Z8Kd1Zv6D9utqkPp1QBFCiBv9U=;
 b=fVDtQF7RPZ+30Q6cmJwckLvNqxpCss9jCxYumrKJoxJPbROjjJ/9u2DDoI5B+ow58JD/QJN4ZAr1165vwUGQaOYMONaCgY4CMpt9AIawEW7LWsmA2XG66gUaeJYIpIw1qU4F5+BSo+XR5UikVf/SBYoKyQQq9cJM58aa0EJw6ns=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YQBPR0101MB5524.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:47::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 22:09:24 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cc30:d469:e7a2:f7c1]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cc30:d469:e7a2:f7c1%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 22:09:24 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: macb: simplify TX timestamp handling
Date:   Mon, 16 Jan 2023 16:08:34 -0600
Message-Id: <20230116220835.1844547-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::21) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YQBPR0101MB5524:EE_
X-MS-Office365-Filtering-Correlation-Id: 72229127-1408-4dab-8d0b-08daf80e5398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQTeB0whAY0UpGCUFGiuOsLxdKuZuvQxzUDQH90p178hPKgPXY5cjREY2po9f/wGwUPSdsvUlQs5zoKSwlK6+eL8MuOFXKKJb3CsKvmCURjZrQGPxt6OD/N6wP4B+Hm2F0e8VY6ynW2CVqzDEvo9w8HMsWe4CZrXcoRt07j4kQtyicVG323GHY+yGTG9ZgXkkx3S0ZtRTgTwfKNhI76AhCW3Dd2wlywkhsQ+6ZmccT3n7L9gsb02qaAe5Sn8rPP8wt/mCLJ4y0kZ3+AdNp8VEYaWe4ik3EL4Ur2cY/KH5WjISsU5ZBIw0gQeIvRTzXZUWjFBlGp9/Xk4pYBc9y2/ulqEXkFJznmTI5sAft96EMqFZ60SoL+uKUBNsjWt1/8vDLHxJhmJ+bxoQwVxvfpXbdzkrTrUIZ44ybYb2TZMjEezGxJY9lYhAUIJxDlKn0sjJuFNshAKFvVkPtL9gX1FgfB6GQO4ELurBFJa0NLcu6i5SlOl4kXNwjPRWgduzHwOfck3VULuzBiV05BL6Poxaf6IThFWsfFZ6y+nZmUug9DVrIXPZQyBBizFYoDxuixIg4VKhfMfX8hQSLGB1xEXxxcNUnQJD4U2csggIqV8xE5kFoFabhIf/9hq0gQhFe09YD0kgsEfR+zg+r5i/9Mgy0/CDVipTJZt6sLztC95apP06SDiDLlZ7Yj9BXcyUPihHXlBlgzg6BWAc0QjTlnHFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(38350700002)(36756003)(86362001)(6486002)(66556008)(66946007)(4326008)(26005)(66476007)(8676002)(186003)(6512007)(478600001)(1076003)(52116002)(2616005)(110136005)(83380400001)(316002)(6506007)(8936002)(41300700001)(6666004)(44832011)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?roJK+4/0LdlcmakIKCYiTo5Uz8zhsnMXQOJuLO9Pdz8k1Dtt0cE4rdV/cPzP?=
 =?us-ascii?Q?DcADJ0Smqo7tcj07OnMDiqEZmhtBA9L/78sGk604CM4TRdReKqlgX4JOV8vq?=
 =?us-ascii?Q?fBqCL8Nb6z+9epm6WLO0xw1t9cP17tfeRhL+UW+4I9/MOhBKwh5BrovQgjs8?=
 =?us-ascii?Q?HTisneqSrnhpY3Oj4PWJVMygbZxNKAuKWlSAoey4g/v0XguaqOEJwWsXi/A/?=
 =?us-ascii?Q?FfPfGA0f5ZfrSio4KTQyn284dGTt5gdgRH17UksuALQSJmQTRdtvV/TjmRuy?=
 =?us-ascii?Q?FkkWgj2lvXVRAeDDcOPoktho2l4LgBlT1SrfkvUzHbEaew7fAB/rxozMCvkM?=
 =?us-ascii?Q?wk2Nhv8JvwijvWPq50YUIGgakiyyAvKcWbsiHYzH7Jyvzs4KBJ/evGlgeYa5?=
 =?us-ascii?Q?bxnHpV78cQkMz4IgfoH7SXh1qVgkEi30V36DERRiv1d/qWcA5ME39OhbkC4l?=
 =?us-ascii?Q?lYlnbJcoXPCzVQATmKjmf6tdtTDxiyB+W3CW6vrUhFfAR+3eaEM8NFE7R4Ko?=
 =?us-ascii?Q?LgjjUZLje0ZpV8UCGPI0eefPO9ihXQGrlOp8Pqrjrgu4pnmaGLMR/BpgTGeV?=
 =?us-ascii?Q?RB2z9xoVQ91ZO83rUfH/hkydQbjRS0uRRAP2mVsOhymzQcOch1/Vxdo5QfxU?=
 =?us-ascii?Q?BRgzqSA6Pv02H/elujEic6MW+0csNlATa2SyzyrdZtT87tLNlaYDoYWmfNQc?=
 =?us-ascii?Q?tuJLZwHkxV8DMvhTtgZS/jg82YsHTEphe8pwLBkXEsyRbD9GYY/O8Qqj0S9r?=
 =?us-ascii?Q?RXQCLifRmWgC8ugySBPNjKlbkVxJK5ZAOY8Wd7LWXQdcYf8gHvugcBOGNSAb?=
 =?us-ascii?Q?6DGQgSYBILm9D5MNH3LVrR3HkDhDtUfIuFNq1NW3R3GY3snQ14O1DqB9bR2I?=
 =?us-ascii?Q?8UyuJJVgFqu+Cp/8ffvLVGr6PBw91Eyb0fkrxuQ2rpBeh1zaAYi2bBwNIkUh?=
 =?us-ascii?Q?FKmnM206f4YyyEpmsGqw2jzOs7+tjhnyi4wGOiGZi0TxWpz7n8QCwdgF6J5H?=
 =?us-ascii?Q?0MP1RuypESwv3k32qQrVUhfCGbQGhOiri3QZzHJoBpPWXOl1du2DMczl8+7A?=
 =?us-ascii?Q?znBb+TBYoEZp8QcaS15gLnvgYH1xk/nJT3KmWpOFmffe7zL4VkmVt3U8w4Ln?=
 =?us-ascii?Q?ONXC/YngkHYM26czLMpllmuYF0+ed3CjrPMZ1rPzxciD25QmU49AakB+xh+T?=
 =?us-ascii?Q?DenGNOJMtomxZQV59E8eV9mxrh7tut2WwdPAgb8jdHAob5BV6zXrUS3WKoKO?=
 =?us-ascii?Q?Ov5q/qBBt0RuE/2q9wr64+6QDbX4MWOfaFA9LBh/dir0+H+Pz2WXD0TQdxOk?=
 =?us-ascii?Q?G0VPgMPRaEZAHN25h9AJHrHed9d1C3XEGO0l+7tX93FaPuTf2VkWDJrqNrPc?=
 =?us-ascii?Q?Dmi+yFMc/UeBGExizXQq4gcaH79vIPbbGXo1+1rt92VRj34Bp5DSilGJr4tk?=
 =?us-ascii?Q?vicP9XXk0AyTHtg2M0eEfyp9EkPpxjlcR5yLgmNdhGIb+QlxIGs1JHgcc+9O?=
 =?us-ascii?Q?KN2+m2g8INYIIfofR4DxtpwDJ6Y+ga0m4h4kbDtPSWtty2QxbtOnHJWqT+BQ?=
 =?us-ascii?Q?JzLN7B3LHNRs9kFa/tYvv1ti1J+UGCsEjqzWRhrv4mLgqA+FtivgOMamFB8P?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?v2yvtVd8F0nniHuJ3M967nCWgftLcAa57y9n334nWGreGIxH4r/A1l8LWjxf?=
 =?us-ascii?Q?I775ypbtxwXOnYAeudxhwMim755Ml47VQ3GyD86PFRX8mmpCdy1OrtLzxFIP?=
 =?us-ascii?Q?bQfupmo0Po7Hgm0oX99o2QPwauRTtpUttHGXW5OvqqWfVaJdbpn/1vYZImN6?=
 =?us-ascii?Q?ol5DZ0MPyz5HVW78zwttSbKhcZu0KmGG6aI/2Yl5decRkMKgOvjDhAOMdYGF?=
 =?us-ascii?Q?4wGvVJdrRrNjpfF2XOSlKoeWcV5I/CiRubLy6tq7uVy+Fm7PrTPpqDARtcEX?=
 =?us-ascii?Q?cVa4IpDWH+dlTwT03PX4yMFtUE67roOr8KdOUcllMdE6G82ljWZw++5ALRrO?=
 =?us-ascii?Q?TSyCWwA42cim9+1ZO1JtBomcZhwI9wCac21uHAdQsqNAih43LaO614kk+Y1X?=
 =?us-ascii?Q?4cXZvx8zDaz1Yw39xXUEuGYBA+be/9Uj/6yUwPr4RyF5InsaS1Sh/mIZfIoE?=
 =?us-ascii?Q?jKIPs83MaIqBOkP69PiP4lGmNS6ZjULp1UZZlB3yxaelL8bQplQbUwIiZI/Q?=
 =?us-ascii?Q?PJ0Iomsr5mGlVk5FMo9L0YuInlKQdFvnr/GOnTE305/gJoePoySFDneZHnK4?=
 =?us-ascii?Q?ZX0531FwNZyfa6pKshJRrlk+kCj3X1M6FMr340NAwJpTK7mHQXUQKYyY/C8o?=
 =?us-ascii?Q?Q6Hu/ZvNDpJkPU9PzRYCWdjuuF/hyPUoTo+GEjHKWMcimVs+SRF6kOoLnA+2?=
 =?us-ascii?Q?oxCUizN0iAAPslHb4gana3II26ia8kj6HZHLKyS7i/pL6EG/7bU+4pv4LAKz?=
 =?us-ascii?Q?S3x/DaAMWLcL+e/uYhniWbUHonQWNUk/Mp9LHcKnTyrNPLUvynwzMNmCkrUV?=
 =?us-ascii?Q?k3c4gKnipn83DhAw5qxDWJ4Bt9qcDDwCD7s8ZogFoqp340xGFn8bt17CKLsq?=
 =?us-ascii?Q?fc2hQbfnwrmxAoQ9dm8Df4rv4FID5xyYlWhVuqzyQngIX4oSuRfMPrL+jbjV?=
 =?us-ascii?Q?/C0yvR+cuPBvAZo14JkNNQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72229127-1408-4dab-8d0b-08daf80e5398
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 22:09:24.3645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVjpsdHxkyqhPFpZVIaEvBWweJgPpttFxNuQ9UYsdOHX8nbk/gAAMwpfbhfQqVAcvU0FbC7Ik6YC/89aT9PJwyd9OtNwRtNUxX8WLhKdqTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5524
X-Proofpoint-ORIG-GUID: tGlGCUzpM1N1GwV4gXgy_-BnEB5-0_Kv
X-Proofpoint-GUID: tGlGCUzpM1N1GwV4gXgy_-BnEB5-0_Kv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_16,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160162
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was capturing the TX timestamp values from the TX ring
during the TX completion path, but deferring the actual packet TX
timestamp updating to a workqueue. There does not seem to be much of a
reason for this with the current state of the driver. Simplify this to
just do the TX timestamping as part of the TX completion path, to avoid
the need for the extra timestamp buffer and workqueue.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb.h      | 29 ++-------
 drivers/net/ethernet/cadence/macb_main.c | 16 +++--
 drivers/net/ethernet/cadence/macb_ptp.c  | 83 ++++++------------------
 3 files changed, 34 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9c410f93a103..14dfec4db8f9 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -768,8 +768,6 @@
 #define gem_readl_n(port, reg, idx)		(port)->macb_reg_readl((port), GEM_##reg + idx * 4)
 #define gem_writel_n(port, reg, idx, value)	(port)->macb_reg_writel((port), GEM_##reg + idx * 4, (value))
 
-#define PTP_TS_BUFFER_SIZE		128 /* must be power of 2 */
-
 /* Conditional GEM/MACB macros.  These perform the operation to the correct
  * register dependent on whether the device is a GEM or a MACB.  For registers
  * and bitfields that are common across both devices, use macb_{read,write}l
@@ -819,11 +817,6 @@ struct macb_dma_desc_ptp {
 	u32	ts_1;
 	u32	ts_2;
 };
-
-struct gem_tx_ts {
-	struct sk_buff *skb;
-	struct macb_dma_desc_ptp desc_ptp;
-};
 #endif
 
 /* DMA descriptor bitfields */
@@ -1224,12 +1217,6 @@ struct macb_queue {
 	void			*rx_buffers;
 	struct napi_struct	napi_rx;
 	struct queue_stats stats;
-
-#ifdef CONFIG_MACB_USE_HWSTAMP
-	struct work_struct	tx_ts_task;
-	unsigned int		tx_ts_head, tx_ts_tail;
-	struct gem_tx_ts	tx_timestamps[PTP_TS_BUFFER_SIZE];
-#endif
 };
 
 struct ethtool_rx_fs_item {
@@ -1340,14 +1327,14 @@ enum macb_bd_control {
 
 void gem_ptp_init(struct net_device *ndev);
 void gem_ptp_remove(struct net_device *ndev);
-int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *des);
+void gem_ptp_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc);
 void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc);
-static inline int gem_ptp_do_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *desc)
+static inline void gem_ptp_do_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc)
 {
-	if (queue->bp->tstamp_config.tx_type == TSTAMP_DISABLED)
-		return -ENOTSUPP;
+	if (bp->tstamp_config.tx_type == TSTAMP_DISABLED)
+		return;
 
-	return gem_ptp_txstamp(queue, skb, desc);
+	gem_ptp_txstamp(bp, skb, desc);
 }
 
 static inline void gem_ptp_do_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc)
@@ -1363,11 +1350,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd);
 static inline void gem_ptp_init(struct net_device *ndev) { }
 static inline void gem_ptp_remove(struct net_device *ndev) { }
 
-static inline int gem_ptp_do_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *desc)
-{
-	return -1;
-}
-
+static inline void gem_ptp_do_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc) { }
 static inline void gem_ptp_do_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc) { }
 #endif
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..6a0419acac9d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1191,13 +1191,9 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 			/* First, update TX stats if needed */
 			if (skb) {
 				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-				    !ptp_one_step_sync(skb) &&
-				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
-					/* skb now belongs to timestamp buffer
-					 * and will be removed later
-					 */
-					tx_skb->skb = NULL;
-				}
+				    !ptp_one_step_sync(skb))
+					gem_ptp_do_txstamp(bp, skb, desc);
+
 				netdev_vdbg(bp->dev, "skb %u (data %p) TX complete\n",
 					    macb_tx_ring_wrap(bp, tail),
 					    skb->data);
@@ -2260,6 +2256,12 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return ret;
 	}
 
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    (bp->hw_dma_cap & HW_DMA_CAP_PTP))
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+#endif
+
 	is_lso = (skb_shinfo(skb)->gso_size != 0);
 
 	if (is_lso) {
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index e6cb20aaa76a..f962a95068a0 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -292,79 +292,39 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 	}
 }
 
-static void gem_tstamp_tx(struct macb *bp, struct sk_buff *skb,
-			  struct macb_dma_desc_ptp *desc_ptp)
+void gem_ptp_txstamp(struct macb *bp, struct sk_buff *skb,
+		     struct macb_dma_desc *desc)
 {
 	struct skb_shared_hwtstamps shhwtstamps;
-	struct timespec64 ts;
-
-	gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
-	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-	shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-	skb_tstamp_tx(skb, &shhwtstamps);
-}
-
-int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
-		    struct macb_dma_desc *desc)
-{
-	unsigned long tail = READ_ONCE(queue->tx_ts_tail);
-	unsigned long head = queue->tx_ts_head;
 	struct macb_dma_desc_ptp *desc_ptp;
-	struct gem_tx_ts *tx_timestamp;
-
-	if (!GEM_BFEXT(DMA_TXVALID, desc->ctrl))
-		return -EINVAL;
+	struct timespec64 ts;
 
-	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
-		return -ENOMEM;
+	if (!GEM_BFEXT(DMA_TXVALID, desc->ctrl)) {
+		dev_warn_ratelimited(&bp->pdev->dev,
+				     "Timestamp not set in TX BD as expected\n");
+		return;
+	}
 
-	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	desc_ptp = macb_ptp_desc(bp, desc);
 	/* Unlikely but check */
-	if (!desc_ptp)
-		return -EINVAL;
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-	tx_timestamp = &queue->tx_timestamps[head];
-	tx_timestamp->skb = skb;
+	if (!desc_ptp) {
+		dev_warn_ratelimited(&bp->pdev->dev,
+				     "Timestamp not supported in BD\n");
+		return;
+	}
+
 	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
 	dma_rmb();
-	tx_timestamp->desc_ptp.ts_1 = desc_ptp->ts_1;
-	tx_timestamp->desc_ptp.ts_2 = desc_ptp->ts_2;
-	/* move head */
-	smp_store_release(&queue->tx_ts_head,
-			  (head + 1) & (PTP_TS_BUFFER_SIZE - 1));
-
-	schedule_work(&queue->tx_ts_task);
-	return 0;
-}
+	gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 
-static void gem_tx_timestamp_flush(struct work_struct *work)
-{
-	struct macb_queue *queue =
-			container_of(work, struct macb_queue, tx_ts_task);
-	unsigned long head, tail;
-	struct gem_tx_ts *tx_ts;
-
-	/* take current head */
-	head = smp_load_acquire(&queue->tx_ts_head);
-	tail = queue->tx_ts_tail;
-
-	while (CIRC_CNT(head, tail, PTP_TS_BUFFER_SIZE)) {
-		tx_ts = &queue->tx_timestamps[tail];
-		gem_tstamp_tx(queue->bp, tx_ts->skb, &tx_ts->desc_ptp);
-		/* cleanup */
-		dev_kfree_skb_any(tx_ts->skb);
-		/* remove old tail */
-		smp_store_release(&queue->tx_ts_tail,
-				  (tail + 1) & (PTP_TS_BUFFER_SIZE - 1));
-		tail = queue->tx_ts_tail;
-	}
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+	skb_tstamp_tx(skb, &shhwtstamps);
 }
 
 void gem_ptp_init(struct net_device *dev)
 {
 	struct macb *bp = netdev_priv(dev);
-	struct macb_queue *queue;
-	unsigned int q;
 
 	bp->ptp_clock_info = gem_ptp_caps_template;
 
@@ -384,11 +344,6 @@ void gem_ptp_init(struct net_device *dev)
 	}
 
 	spin_lock_init(&bp->tsu_clk_lock);
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		queue->tx_ts_head = 0;
-		queue->tx_ts_tail = 0;
-		INIT_WORK(&queue->tx_ts_task, gem_tx_timestamp_flush);
-	}
 
 	gem_ptp_init_tsu(bp);
 
-- 
2.39.0

