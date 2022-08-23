Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED31459CCFC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbiHWALm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiHWALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:35 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E66857228;
        Mon, 22 Aug 2022 17:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL8sPHG7lbrSxRksosphwrIuAgb2DZAw2SR3E+AhOPFoBCxQqhqN/+/DM7T0/wGOlDakniCn5VTFjg3arX4jPVL3GbGpPk4+B0HqJxIid59YmeeJpxVLuEloQlpmJS3ImtXQBVg8f9/yUxYXbfQWuTsd/tUJvKayYPi+2+6k1lvaAx+Rxi5VZubyaOaXJEw8AumYAlvgd609kUOdKScxzoxNAzNSCm+oRv+rCZCcxSv2plJiLrOJKzBVo5WA0EzaldjazXczdqIntMwLgehIiqm+IS+fkBxPzVLJrvo72nikgfnDKXf7op5eUYUKccJzzn5rCB+9E6WbJZi4HhoH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=FJCdD5ue85LwlmlvdY2O+Hl1EcHjPBku2bQ14mQXkzY490Ax0JmRRHhCRJAcUuSt8vr2MlGs9AMFv6bbySspTKhjMb8EzJhNreMCj4LHYP2TYItVOsxstGM91RZ0wjS5TjGNa3PWRWvLi9yyrSEhGsM0AWxsD5xStTy2xHuvmD92rbmPtS5i9lcmXgpGMUXW8JYJKb1MA/3o2qcaOW3Gk8p1+otmSSc11ebBPnJWkoYusvpcwsLD4WHbyIjGZ6XMIyLnthKWEymGzDFLKLubgX6a93bj+xlx13yMyc34Kisx9ttjPzp5vbrcVDhS2h/3vqQ0muvIDgZrDuc+rU2sXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=eR0SEaOkkhLXz8bKd5FvzuzHCFTwGdpLICEGLYGZuRMr4tU7UIXU/HJISBXBUKydu6HMv1LvcOQQ77GnZMFDB0GMM2py+agVUp1mTrQzwIgMA8RilgBZCJ/77X+CYHPgoYLAe171JEYCYrmdYdls5hi44WOpymBTzWT34C21Op4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:30 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:29 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v3 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Tue, 23 Aug 2022 03:10:41 +0300
Message-Id: <20220823001047.24784-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dea2c98d-b469-4925-be41-08da849c0745
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5kkrTqHRtguUK0CmJmtAJHO9WvEMslir4zTkeHEYKx1fATxJFNSx1fKkdpY2U4tA76pjeSJKm5+UoXEKUf2SBnfSdQBHOI8tU8yF7Wbap3Ag6SWDD7NDv+eIfiE7XhoLSAGrQnplzdsJdIEPCu5HvHHtGGCORKiTFouzpl0mSITyx+raaLHIA2X4bkRDMq+NzlQFgb3gFuW0ce4y8QTgf+l9bDpP6lJ3PDaz5QEBrSmsP0cGXsrxp76vCaMss/BwegMjRgW17k/Z6z50sQmIdnW4WACmBuq7QbrU4R2hzafxyt7iU0HUC5UBdnVAVYB/Zwh7ZvbAJcVLKVhQMi3SFFIcmeZlQjMYsZvYqvtdU1slwLwBgDAyvZUKB+qsFKocLsGjCjDsvotTS0OOa9k65FOpfeyD2kfi/IheG6w++g1GJJ0qBA7y3l01TpjBpedKiJWIiZMC3GQbge13UfDSBIl9oIe2J+k09KQD22podlmzm9FSNnjzgepZ2LUrW4ADFDx4466bAuIpZ2KhEa143f/pL7OJ3y8a5fLEIvjPbB8OFRVn366awESixzD0PX6DMDqTyL0SOJuJBczcGq32tYIpwc8b4l+bacHVRIkPJiv4oNb/kExVCK42WHD9RG6TK5CJiYUbBRSTz3WZg1WB4cDQi7E20lrzsgYyg7iSNZL6/DFs+74vR4B/OqIDxcq0gsdAc6kXTgcNtuBkqHLz0x30XW0LNk4vMW000E8DTN8n0zpNI8cNrr3kn5ZY1qT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5+7Jn1PnqVAtWRpJpiUlFspJBTBRCcmIxtWLjcxS8ssyo+K7BGlEUaNTQNta?=
 =?us-ascii?Q?kwvFVId5VmQW2CVQNNlPvjC3Kh/n2VOrVoJ9beLdYh3UWJCNp47HplLW8yeu?=
 =?us-ascii?Q?f84fNzY6o+mRwowg4lLLp+1uK6Y4dQRmLEIh2crwOTCBr9Pjrxkh6fZn/hos?=
 =?us-ascii?Q?BNJc4s2TMsLrcTiQLSPltJbDnproYGT0n4Lpyx4eI09dj8/1OUx9qG0A55hS?=
 =?us-ascii?Q?ZQTG6P3YYqgtq7OfWPgYxL8lanpTiUk6B6tiXlrT9gKUsHdVGlWKD9ATXhyz?=
 =?us-ascii?Q?bSDXDTXlw4y3bYq4S6YDpBqBW1LHPypcXXWUEZDCTTXO7g3KlwE6mpA+yT4M?=
 =?us-ascii?Q?D96Luv5SpLsWD6V6pYNujjsSDmyLD+K4MXyJv8lqi8RJuFT8ea1J8No+73Pl?=
 =?us-ascii?Q?xFY0ECAiwnXd5ibE09umoI7xOMbedRPR66wDaSYetZvpTVUyQGGK0WjH4ejz?=
 =?us-ascii?Q?YF6v/OUsM8OPE0kz9MVnrtfcB4G/wLTUbDH3rbsSzilWiIOWpvgoDr8/E2QQ?=
 =?us-ascii?Q?X6q+jrjClBiZhXtAtjelUTDGiX8+PbWeXn0ZmfaRfwJSVVrVdd+zF5wF7ysb?=
 =?us-ascii?Q?wzcSxumYp8m67cNHfP5VpSiDSYg9vQ1RQAffOv+FVw6fl/zc/TuUORsWZUUe?=
 =?us-ascii?Q?H+0AULYo1zutQiCA9Yl4LSNS19tuaCfuSBWKvQSM6plhIHXadT58HnHt0hO+?=
 =?us-ascii?Q?q23pAgSzR3UCeMzoy0g19dg8E64Z1FQS59uErp3pyD1MR3CPt2K+L0NFEEtr?=
 =?us-ascii?Q?7jPTdy2eTXil5NvWQ5fCZkM7S73dMI1K8Gvki3uk9K5o6uEfCwxfHsTvsNLq?=
 =?us-ascii?Q?sAtem3Nhf+OBTZIdQMi+Llgi1zfdU0hGCoodkVAVTYJD/2hoRKN50B2UrM5m?=
 =?us-ascii?Q?P71vuYz5EQjdTBoNfHzn5cOu3PuXIEJoGbjiCiDt/nQtZYPZ3va4I/HG/5ox?=
 =?us-ascii?Q?r9EZHUJLwX2BUkCcdNqJrkoWUS2nQ3hSw3WVJvZSWXcfYaMDXgi8Bfmj+wZ4?=
 =?us-ascii?Q?Z/pyOJxDrQtt2BFlnh68WCLUCPI1TCGiuCjJ4xh7wLzDSBdkvn949VLpvHyE?=
 =?us-ascii?Q?kEamWyDBf4qwtdAz4oH6plLCq0mau4M9jvP2SOWIAxM35SlUw1s+HVlTQjbf?=
 =?us-ascii?Q?3in6oQ9HAv6VokpuHWCIymP5MzPYG2+088ogMSYFPDVEHECfvnmU24AfbOYi?=
 =?us-ascii?Q?+rYCh59McvavP87K/JxntPEcS+gG9UXFJrQvXun8dEMLyH0HIUtoxe/hUB8d?=
 =?us-ascii?Q?K8CvDW12Ymxoas2RW5gP7UZTpzUQqELmBRdP65yutqwkJR53buUPyMFZNFJ/?=
 =?us-ascii?Q?/BbxrtUzSXumKDqhk0RfLCFZidltsg0aIgdlAO9jyb+fuOHFgMEMugnlxPBv?=
 =?us-ascii?Q?WJXTwZGGpGNPsjtYHtHs69UosOSzvjuirgdyJkZEYTpioWfao0eDP0XptIce?=
 =?us-ascii?Q?8Fkw38JbcI4c3Q/Hx5R9Pvg/7Z9tjpcqrpPeuKAsK9qfjJ9Wo3zgalByzq/u?=
 =?us-ascii?Q?KpDqBDPguMbshJFSjKqKcmU1ylxwFFK5VORnV6z1BLwjlmIU9ZDGKsI8PytH?=
 =?us-ascii?Q?O+okDJMNCyh5L8tz3LTRfEIdn0QWWzvB+alTmJMEllQ8SYd+7T8zZJkLNwbO?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dea2c98d-b469-4925-be41-08da849c0745
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:29.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+XoYcgyNZ9lbiXltqcaPe/nTg+M4AuQas5wscgHgzFVyNzVLvUjv9XoKxBAiy2qSZPklLgLdG14nr49vSC3fNY3u+cTiZyGCb5dshcwz9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will, ensure, that there is no more, preciously allocated fib_cache
entries left after deinit.
Will be used to free allocated resources of nexthop routes, that points
to "not our" port (e.g. eth0).

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index e9b08b541aba..41955c7f8323 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -334,6 +334,49 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	return 0;
 }
 
+static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_fib_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		fib_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!fib_cache) {
+			break;
+		} else if (IS_ERR(fib_cache)) {
+			continue;
+		} else if (fib_cache) {
+			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
+							     false, false,
+							     false);
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			prestera_kern_fib_cache_destroy(sw, fib_cache);
+		}
+	}
+}
+
+static void prestera_k_arb_abort(struct prestera_switch *sw)
+{
+	/* Function to remove all arbiter entries and related hw objects. */
+	/* Sequence:
+	 *   1) Clear arbiter tables, but don't touch hw
+	 *   2) Clear hw
+	 * We use such approach, because arbiter object is not directly mapped
+	 * to hw. So deletion of one arbiter object may even lead to creation of
+	 * hw object (e.g. in case of overlapped routes).
+	 */
+	__prestera_k_arb_abort_fib(sw);
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -600,6 +643,9 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+
+	prestera_k_arb_abort(sw);
+
 	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
-- 
2.17.1

