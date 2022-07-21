Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E94357D6A2
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiGUWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiGUWMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B9A951DB;
        Thu, 21 Jul 2022 15:12:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWnmkCh7SqZQgNYLr0A4sNVGTmGot1xOKgpVeMrn35HQLIaBOcuejjctp2qoLu197LEFBrxLO+XI0JSiZ4Xo0LCLKMa5tZE5gUwi2BbS/McyU2G6jO5wna9t0xB/KqMFnWFibWT0zV+5jH1g+8HyDzj5gSJ19OAWYXhpkORnWlEyXbXhz+nAuQ1GdJoTrB/+8bEbiYXLFEHF3XmH7N/vgsEvaTVGvydJSTzfAAKYDvlmu/0G5aZcErSusWrAGe6iwDjbK1IBYCKj/vMjk7rtU/kOmuRJLEP58Txta2giyt+TO3JJR//3+L2i/1jA9c2zt/lBxjRnMcKJc9ixyeBvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=AA1fJqhE+aaAb6W6OqNBD3dpLoTT7VnVqJhc46cAHPSb6X4R19KdzjuPZ/57N9i96YDixjGQ4Y4R4c0oG7E0OY/78Ja1PRLWpgLTXCwOXoWAA1qO+a/gzHphER1glnu4aiv8kbbYtLw2/MIxLglkVCHq/mCvBhcSD3rb6nOTmNEerg+iIS5o7kYOzyeeZybZJaSl/uLpkRIWvK4JxcZDrzxYZagN3yB2tH+1a3ouAokuFv6L+7oP484n2T5LoZhPAuC+sElH/SPWufsIZOicEDzM/Peul+5q8eZZ0szza26fqq9TbTfbzCQT3TbAv6ssiC+q+FROHxh1LQOYULEL/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=mNxcz0LUP28n99hwc7M0JeC+ZN54A0S94NCzjAuSnEJebui0Q0Y/RirSSU3x1VYbTbTFTLG7Dq3TG9Gjyw/Xaaw4ikbHiDglCf6O7kE6I4U544TxSEQBjziFSHGiJPX7p1GkNqvXM/g6Frj2bbSe5I4pVK5geV0BPOgkabHCjs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:09 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:09 +0000
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
Subject: [PATCH net-next v2 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Fri, 22 Jul 2022 01:11:42 +0300
Message-Id: <20220721221148.18787-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc77d1ef-790f-4de2-4b67-08da6b660df5
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7GKZ9um+VJzi6jdXy0cnh6v82ABtBQUkxK/haqiX9mkosii6U4VygXay0slOplHT887KR9jL0T/SLXJgbG6L3S5zx+RZfp3WVE9vKuqY5SAc8FZQgiwif08pk+hXcbRbLbDm4yzvRb3OmYXY8Qji5yZA6DbCnK928pk7viEj3wJWdWA9+BefVzbq4/JdI8yufrWxFapwebN3V2RamrjQ65wM5Jb8Mpw5hrtP0IbOu3KB8LJI+mhr9vqEWPEyvqOKFkG2W0EvosnJpjZ1NiL5D1vCRAXYVceM+pILEXI9HMx8qmc2U/cM77vN3rgHXI2c03cC7LuJ3XNLmmKd0KchePlBtUL9bXikNx79vnfWv0d1iUsdlvpHms6ng1aSKwr2j6xrqZ5WodK6kyMUVtNY0Vv233n+nCqMz34OVwnq7amFE6fPeeLiE4/rteSLAm5w2bSLMLmCGJL2cj6MOQONG3d38awU66fE51I4C+GKW6eIx0mA6mQw6hzXTIn4/FN32tjKMaGuO0wLVBE6HSMbkwYc1Gfy60ksbTHQtwL6ve9g77cUZ6hToJk4ej2D2TcXRr+11TaXFAHXUTpaQWTvtLaQH7zeTZcnLk5i/6gYSZCS8k6JBupAk6BpCvvC9eo6bTKxqDhnv/Qx1+S1zMO7DGnxdC00bpEAUMnP4juWZbNY/rouYXNjq2K9x8N0QB8y1hvC4qRWwIiCfB9NUrYGogczqSeVgktmz5Y/xOJfdAuKlCBqeFzUc9lv1qa1Natf/2zV0B1DOTUqSreoMP5J5kyrB6ewwALqAItzsalBEOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7NZkzGAoZyI8rjsZovSwIg51mP2VBUeGEGThLQNUIi0z1FUheSSakfX4JYxS?=
 =?us-ascii?Q?K8fWAQW0TDF6/lnmwl0u18f3OmaXjrdj1+DqEgW4we4D8wm1eQRTEydCw4xo?=
 =?us-ascii?Q?5f0OTBZ+84BXxj0jYhqtPijyhbvMDPbLCc2E3Ei91zTjDBaOadk4++4tpodK?=
 =?us-ascii?Q?puhgb5dyp+BmMP0rsYjHev2y23tLJ1Q7JywCfYpiNJ56HW86vGeyg2WWmFQx?=
 =?us-ascii?Q?5nbvXIOXUZQAVCVGQNa8fIpneeTMQI1pjPj/FeLCExTijL7ZeQnpDJeEl5mH?=
 =?us-ascii?Q?kj6P7F40SqgR2OtUGM2cCg9sggOk+OnptUM7c+MgY374+KMXEoA2OROvHyGy?=
 =?us-ascii?Q?61xJVzwcdVhgHFS4/BWN1PYwvm9g3NYGs/LpvOjp6hux9YbmU4zV2iI0erjE?=
 =?us-ascii?Q?L1dfcQPft0f9HOWY1Gd+c2uVUyDF6LYVWj3yJ+wDQqmv4DDSsKxErUPDBsQv?=
 =?us-ascii?Q?+6wgeCGdUGeVVm7PpGo5VijNJc3VOoaz/p9cabn8/219jJ/Kg3HYhPHcn6kO?=
 =?us-ascii?Q?XjkInTYgRVvR8iT6VaP7tOM+8ukpaB220bRdj9kFWZs0KRI46HxpZqIGVuz/?=
 =?us-ascii?Q?PGFK5m4TxpIW7tMJTyLsVufEoCqu0j9vhi+kN/X92VAKXWK+uzqRGkazUntD?=
 =?us-ascii?Q?lUOwOKG257hf9T5bz8HgXC7OT9UmnhTNKgMQGp46k1CBStiNBcGTo06l5p8t?=
 =?us-ascii?Q?LzNMGgAGJ9shNLIH3hbby32FE1xVSi85y01T09v6vx4AbqW5coecQPCiSOIq?=
 =?us-ascii?Q?FDp7HHSUjLSDlZFPj0dVWerU6zSgU7elVSnOzjfCapA4qlShwiOE0KKJy5EF?=
 =?us-ascii?Q?H0JcLxDqarmRdf/huOZ3TwKlhlU8BLqOqPi9Rmgnb47PDsegGZ/3TyhDS2rW?=
 =?us-ascii?Q?FcUQrp3WS1Q4Pp7zGMdaSXNv519NMsfZK0upC1eb3khcguGCYu3e6Coj+tF+?=
 =?us-ascii?Q?h+DbBXDwdzdX3HhRtSu0I1VaWY4kwDasQ26QNPOA8tepn6JjcyoM8VopUEoZ?=
 =?us-ascii?Q?uz6mURPCMWx+fPE2KPX1FFnwcNJtJ6GjsxoUpcjemAueWL0Ct5SZTtjfKg5J?=
 =?us-ascii?Q?4FBquLospi4uw7jxXuMv1hHfawyewmtlFUx/vHiiUtc0oJWcVuczADnOfUJg?=
 =?us-ascii?Q?Ao2T6cdwpRPP7EhRXet7CnbOsftGXNTMbG/qQpzud0anbQQDNBLUjQF/uJEH?=
 =?us-ascii?Q?dlqPAKZyCpYlDc5kVcexswpVUFXiOSXXXCEGmesdz5VI83aHJw279azNy4wY?=
 =?us-ascii?Q?CRCHy8tsl0VMic110k+TtUbwwcup/uHEeDv/E8Pb6jyhXAUoVograDwIu9Pt?=
 =?us-ascii?Q?+3JiE8RNO1FdwDID+ILjDtk6jIvG+alLty/TW5u8fSsktXYTI2daP05Necgc?=
 =?us-ascii?Q?gE8qDCjhRFyHt+t8SXSMXl0a3GSDYr+vzi8llAS7FNRx9o8mkBmwntlNuazL?=
 =?us-ascii?Q?wPbXaeBH+NUabCaDJkzRIwFoPRBPICd/8sJxqds2nhUCILHZdsRpQUZvV2I5?=
 =?us-ascii?Q?nidveBDXEfiVuyDdwEQ0FOKcHC/70Bz81AXX9k8pyU8kJrBG+6O8mbb8qKyJ?=
 =?us-ascii?Q?0O8HrYGEUMg/NiLv+qmFT0dXSKao6Z+ksj1ykyjcVgNhTS/v9CmC/5FNkFS6?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dc77d1ef-790f-4de2-4b67-08da6b660df5
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:09.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlFIDT+kFFn5zx+AR+BAv2cM+ogJ9AoUnd0kYafT3cbPfUVPfAQ3cfuvoR110qYHOV/ozNqVAMtfNcWo7XDOdZD5huFp/DAFDvdBaVsu4tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

