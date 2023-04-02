Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF46D37E1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjDBMi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjDBMiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:22 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2071.outbound.protection.outlook.com [40.107.247.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E787686B8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4qXoneJSmV7LEqsjsQkE67ipbur3Gcr7zq5p8rrL/11DhFaLMEiorKfHwV8d9Rp1aj0hZcycbZ57erVeG6yE94sNXE7qV/S1pWJF2AJe3xGKZVdnm0S8x0aWOivWBe4WrJM6Zpo+jLkfB7LmTnP1yWrzXg4bVdLj+n3pSVgndL12BBNFyW2mlx2x4IVkVj3GwrsYXlSe9hv7sdXK1VXckJMKdP+XwJtBTmbJRDgzC8FLWIjy8lScwQ7mEFgi8CFbwLjU1GZZ0w2eWyTDkhymZ2SQfy7rP8b+LgE0H82at3ulDQZtpwgZyr0nd5dL/p5G4/lOU+byh5A+HwyNV4Shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAhilcWHRxdfbLLXmeHgRlfEUm6xL+cotOezIssLQT0=;
 b=PKjOy7RiWTURbpVVvm0Qag/hiMDYhZTnOchghjWilDXYZRAfLc0XRBx2zc0UYeGFiIbdqiKXRooK/5qLxNVaqt174vOr50EChvFL2UbEh4PwP/G7ySjRv6YRhfy++QZpQxPxlfSCwfm5/dlfULh+Xe8F0R3zxu+03YKhOC4fgelDCEhHYN1m4hShdCcoPOZaONx34rwjrWRxd4Vqyid4qgAl9MoSnRppnALf2simnQLwLiM14vt0iBrDdBsc1nZKdtzmk9k5g1jkvPhKo9EJ+EyIU8Hb5GUr7FSLS0KWB0TwxJmu16Z3ANqv8DxhdXxgLGvbUwlb2sUMh0DQbSpmCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAhilcWHRxdfbLLXmeHgRlfEUm6xL+cotOezIssLQT0=;
 b=nosbxF4TKh+9dXss2YoWN/sei6jnqr6j/KEXysUYi4Ehm8d8bvuSbDsL+lLMeGy47LVjPwDFuqPQWj5CV3kr/phEZOx41giUjGxwKhanV7hEC56SnEOzM4GogzsKaL23MZ17sHjW0TTR6kKvtxCokpJ7yyh0h0iHz6PGTqobeLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 5/7] net: add struct kernel_hwtstamp_config and make net_hwtstamp_validate() use it
Date:   Sun,  2 Apr 2023 15:37:53 +0300
Message-Id: <20230402123755.2592507-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: ed014770-67f7-41fa-afb1-08db33771ff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGYixuRfTHNQjun9flqWGGWkeKm1AD2am8yXwUCd/NYMCkh3RV8uOruc9PIH5382TOonOHIIajB9Mi2UopszTYeiRb90QLmn3EZ9sEh5HMa+K3ecIcTrXecC5lAi3LkIkb0EwlF1q51Pu8QVpdo8kWjmeEMKC+4QWRkO3Y2QNAcOeycxQk4zlx4Zo9NJ2BvD04VLpR8kniEOBUB7tGrItRdTD1dP039tpalk8E5YCJyTn5bVW5TBn6J9/1g4Xwu2szfWhsP0OCa9w4a6t0sf72zeNsdVsoSVt7OjmB6vJLgsp/63yKu57HppAMMmb/vn1KZGaNuxZ+jtnR3ykbKOLGQ20aPgvQXfJNF8vxLEpJ5AHYb1B0XoEIwhaqQbkyROcP0uIIlqdghwSp8t8rbW0rp3z7qsziPzPrdk1zvkwVLCqPYNkIcNN/xFltbvtX8qfFxmuAMMzIrX97qLQIgvcriiE4K6WlhLxShWrbkh9t/vAKVOpqeh2S31bxP7HftXeqAvsUtnKYDpZwdFtIWDN3TxuLFU3aNOzFF6WP8FWurspxMQC/2NmhXwvsN8SlqCnPppkuPwE5kJ1sktKztS42HrjnK9hSD9SjDxgn9uW4V+RRXI9R+OG1NiY44YRUsk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(966005)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GO1/JFIQq+VOXD6HVVDjr9iT3bYjgpQ9qeteapYnVR8ZowazsCcBVZUT0rqN?=
 =?us-ascii?Q?4WVjFASqEgkDduvvsitY2BqAvJWUKi9JaeTl5HA+FsKoru9yWlBiFA5mi9Ll?=
 =?us-ascii?Q?G0UrYc2ScolOs2xo2vQ6w3ZXVjuRAYtGaJjTNgSWj65xvr/bTgK2Sp5Qn6T4?=
 =?us-ascii?Q?vDFxFtoJD0Z5jnSiQreHRV0VCdQ+URh1ucVvIQwXkHzyzyaKtdUbNEQNEkt+?=
 =?us-ascii?Q?HoWH3ihbAO5srUApmRA4nPY6yovlfdPnTVllIHpM2Y4tJSieTCebmd6+E29k?=
 =?us-ascii?Q?3BX1sPlDPgTLs71DpkI44ltETffBI6H8wOPQUelSPZUL+url1pVK54h5JnMV?=
 =?us-ascii?Q?qdeDnuNuoMC27x4O2jJZxfNAanUYnGeSXltmzMwpEqRaM0Lkqlu0VTl4z6qU?=
 =?us-ascii?Q?2nAdCkFGGTYKcTcBuRs80ndLU0V9Slg1+XNHeCw/DcU7UiJl3tOS9fcBdsXn?=
 =?us-ascii?Q?ppb75GI4blRuHASEKtIxh/b5imPMfav3yWxWDamHgt9Idvjqjzv4gizD35vf?=
 =?us-ascii?Q?YgW2UlEzHwBoJ8lW1rAodgtnVl5rpmvP8JyPq5xOX+LqCjfUFgRHmtBEUIl8?=
 =?us-ascii?Q?6b38O1ol7Dzsi1AfOLze8ydrtN2vRb0OuGp3r3tgOoJB/X5xlYM+A4I16SO0?=
 =?us-ascii?Q?BOwxsZoQHPeE7V9gWMS1baqk1lU9KShovi/yqew07606qhe5UUL2Sg3D3K0H?=
 =?us-ascii?Q?yDfhINpT1yNOJ8r8h3uSArUC4HsrSnlhpGsREhAWXMf/c77/XWiOEvsO4dt/?=
 =?us-ascii?Q?egiTDbEzn1Bgz6+GIOAyiv31dhCuK3M6DqILrQjoXfpH2BW1z/X2Z4kHqa8d?=
 =?us-ascii?Q?sP7DyNBfH5OOrurFUS02LcOqV0XTlH/dlDFJJMbT7J2GdLYxwKyFxZTPHgIk?=
 =?us-ascii?Q?yCksmYhTL3HuJE2orIgjNYJXAAerGvRO7ZGkpBIDyJMqhIRsohuH2EoYr8x3?=
 =?us-ascii?Q?onUHxszeV6U9LOIEQRdB3TilEgugZQm07sKHYd509jq4EU91DPcmkwygvgI+?=
 =?us-ascii?Q?0GKSL2SXwQXOdIZx9h5PYUGPcoUXaIHY2tdUCQq90ywdI3VGMhB+FHniMo9n?=
 =?us-ascii?Q?pi9DqhJbMhA4mGFFCt7Jk8TMrzHeUhy6bPX6K97JOGVNARw8MHx1xieJ6IfA?=
 =?us-ascii?Q?TBMEB1XurpCPLL81hJrF2wP6LLNRQuRK1yupY8D8OuwRIb8D/OVFHwfdt1qu?=
 =?us-ascii?Q?zBKMsyCqv0LzDmsm9TNO+IjdyTqN33rwb/L2Ak2GkNtzagdxJJCiQkHDb7qS?=
 =?us-ascii?Q?1TDG8WlSb4E8daDBhaEj+d5gc5J8ZqCTskOUHbw1B+77vKd3LuOxtbJWY6NM?=
 =?us-ascii?Q?Nv4Xm1cb8kUPaJOhIfvI0m1qaoZdhuS17uDHElJqWj7OYsVY2xvyBwC49vK3?=
 =?us-ascii?Q?3eLlJX8BngsCP/9o4b9I+MvtxhA3aCdnkhN7PmXOtdO9I1YN3v91xPSEtbPJ?=
 =?us-ascii?Q?asF9z/l9WtOc+XVRmwsDdJVjj7ueWVNVI/pdM4wudHCcZ1jXsJsqqFI9IjKH?=
 =?us-ascii?Q?79BPnPYewSc3TFKzrZ6xPpcGoc2O+vcRb1HrA8CojvPCXlx85c6Nmis2Om+H?=
 =?us-ascii?Q?9TNO5JvuQ3pkrkpm+7GYye1lHdvcGilscMV3o/JkEUCci5LTLgFsHNt2GvCQ?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed014770-67f7-41fa-afb1-08db33771ff3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:13.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HwL0htoKVTWp3oQmSHnU0oir8iQdDoRv0uXga7YUwDdyw4ERNETvjH7ttz+f8r5gxkDykDBqS7m8FE+Urml9Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski suggested that we may want to add new UAPI for
controlling hardware timestamping through netlink in the future, and in
that case, we will be limited to the struct hwtstamp_config that is
currently passed in fixed binary format through the SIOCGHWTSTAMP and
SIOCSHWTSTAMP ioctls. It would be good if new kernel code already
started operating on an extensible kernel variant of that structure,
similar in concept to struct kernel_ethtool_coalesce vs struct
ethtool_coalesce.

Since struct hwtstamp_config is in include/uapi/linux/net_tstamp.h, here
we introduce include/linux/net_tstamp.h which shadows that other header,
but also includes it, so that existing includers of this header work as
before. In addition to that, we add the definition for the kernel-only
structure, and a helper which translates all fields by manual copying.
I am doing a manual copy in order to not force the alignment (or type)
of the fields of struct kernel_hwtstamp_config to be the same as of
struct hwtstamp_config, even though now, they are the same.

Link: https://lore.kernel.org/netdev/20230330223519.36ce7d23@kernel.org/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/net_tstamp.h | 33 +++++++++++++++++++++++++++++++++
 net/core/dev_ioctl.c       |  7 +++++--
 2 files changed, 38 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/net_tstamp.h

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
new file mode 100644
index 000000000000..fd67f3cc0c4b
--- /dev/null
+++ b/include/linux/net_tstamp.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_NET_TIMESTAMPING_H_
+#define _LINUX_NET_TIMESTAMPING_H_
+
+#include <uapi/linux/net_tstamp.h>
+
+/**
+ * struct kernel_hwtstamp_config - Kernel copy of struct hwtstamp_config
+ *
+ * @flags: see struct hwtstamp_config
+ * @tx_type: see struct hwtstamp_config
+ * @rx_filter: see struct hwtstamp_config
+ *
+ * Prefer using this structure for in-kernel processing of hardware
+ * timestamping configuration, over the inextensible struct hwtstamp_config
+ * exposed to the %SIOCGHWTSTAMP and %SIOCSHWTSTAMP ioctl UAPI.
+ */
+struct kernel_hwtstamp_config {
+	int flags;
+	int tx_type;
+	int rx_filter;
+};
+
+static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,
+					     const struct hwtstamp_config *cfg)
+{
+	kernel_cfg->flags = cfg->flags;
+	kernel_cfg->tx_type = cfg->tx_type;
+	kernel_cfg->rx_filter = cfg->rx_filter;
+}
+
+#endif /* _LINUX_NET_TIMESTAMPING_H_ */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 34a0da5fbcfc..c532ef4d5dff 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -183,7 +183,7 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 	return err;
 }
 
-static int net_hwtstamp_validate(const struct hwtstamp_config *cfg)
+static int net_hwtstamp_validate(const struct kernel_hwtstamp_config *cfg)
 {
 	enum hwtstamp_tx_types tx_type;
 	enum hwtstamp_rx_filters rx_filter;
@@ -259,13 +259,16 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
+	struct kernel_hwtstamp_config kernel_cfg;
 	struct hwtstamp_config cfg;
 	int err;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	err = net_hwtstamp_validate(&cfg);
+	hwtstamp_config_to_kernel(&kernel_cfg, &cfg);
+
+	err = net_hwtstamp_validate(&kernel_cfg);
 	if (err)
 		return err;
 
-- 
2.34.1

