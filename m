Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CAB2D8AF5
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbgLMCmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:42:45 -0500
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:19174
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728741AbgLMCmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:42:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtytTR8DC6kPY55RqVok+Z9bwqBWvNHW3m6VtcC7SV3TskjX1EtrXtmGsACm//L81wFKUt6X1El7UH5aNU2dW0ogARuqT0kVUfeLG7LWbbK1EyfZNj8M9pbTMjglvc8rtc9G/tYhKEw/pgHNRo02VIns8nLwG1UktyhQZ0gDmaEo88mupEIyA6HFJI9ehGCrAjkAW/KZbtd7A/zeGYNnobSYb+/j5jCmjxZDUVTyWAhD58S6cHOmbOQd0tUHW6LwVmcGOszxyaChOwDHU/u3TEX9jsBF6GqhHjZFiWQYfz4jhpVN9K8pOXAMdZ3E3THf/2j772u+0pFevtmcCvlWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjIfc9bVDqxAkQp9AJV0erU3JosOeU8GAFNxw3Wmv8U=;
 b=VOIuq5O73dytuAsAFwCnMN4hhlWovloadhNBMDOzHm9RAQUkPrWjYKXl8SV2Nj8BBUVACUafwBLFfpVhhFBmDix4TNlunYLtr0MWDV6Q04gc2JZKfkJ0nvyn4UIwsGekQKAVY59LC12NX5gl5dY9SGu6xkV8ItTmOBQFumfWPns4u/48yhcSe4tLrHUdUDryvkMxl5fLvn8uSw+euqx+gWvygJHiH3X6c+OFfhs3uyp39QxqeKQuuTb3hSlACZRhMsScRwz3ZMqXxbYlMDDZXOpABO1FFMGhl1e4Qa4udk1FxmyY5X6xSHrQ04NA00AyhEdHPSwNyD2QVOgEP4OW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjIfc9bVDqxAkQp9AJV0erU3JosOeU8GAFNxw3Wmv8U=;
 b=QI2ZUxtKlQJc/unHeIg8qibj3msuG831pc5liMUiqxfPmFpNcyV1R9HICkDvF/JC/Ajwg4xGi2s6BAGQ9cTpsjMGo5nOe2DgdEPmUMCXGAdeio9Yi0AA/yzYQ/tXwZUgLaZGUjnqTVQiE43ZH8i7Zu1QV4qH+4ImHWiakbvLQ4g=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:14 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 4/6] net: dsa: exit early in dsa_slave_switchdev_event if we can't program the FDB
Date:   Sun, 13 Dec 2020 04:40:16 +0200
Message-Id: <20201213024018.772586-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213024018.772586-1-vladimir.oltean@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e37b5d07-adb4-44bb-3c0a-08d89f108f61
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407F02177DAAF4C199DF434E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQuO5k6ntrd9DQphGhqiG+ttz91+D4MfAlKlnEK6yp1bFemW+InrN3pPQDdNm+/5JFvn/0MZdAUe5OBiMfWKjVgqHSyO6m7yaAobUO1rQgzvYppR8jgWEqQDjd7oqW2yYgCVvaAJqkIH+LAfPg2oeAxIr1KLy0VgHD6NLG5HWXV1l/fJTqDKLUpYYrH5dPsOUS/E6TiAV5fgDnFox7ZVke8Jp6iJD7xalbOl0CPlsYhY1SkpEQ+IYUxnZXwrScIZv8EldaTIBi0lxxYFS5Kz9vzdmCE9x/EO0KcdR0XJeJThCrmXxWbvJ1CfAOUr7CIMJBEBeqA50s7KpAlbtYUxedmCLMpv4/7G9xXHAogZfJXpPqEz1E/45SmmRXn4+0i53kQgiV9LqOw6wA1BIfVO1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QlbBRye2HPDvpiZe6TVpUHVGeFAWCFJQNrt5OvPcumqXuH53wzhTVpVnUc3t?=
 =?us-ascii?Q?zqyFajZ7dv9edX/daiRrsYfn9wucWQPTU3gpMjPDrLrbDr+wvFBlsg68GwuH?=
 =?us-ascii?Q?6UvEu1AtbZBGCUFImHQ9GXbt+geW84UDU3FIg5QOEOH6WeKEF/uZr7+fdUBD?=
 =?us-ascii?Q?OVnkx7LdqXzCz9oCRMRz95uRYwjdkTUSDkkETur1sy98OG+uZxgvojJgL7hT?=
 =?us-ascii?Q?PK4pD+ElApybBpnba2NwDqjxirSAFzHbK8oA5gkX4NG9rirWwKSvt8Acn0LT?=
 =?us-ascii?Q?Y2+qL6YP6KGdToQRJOPeuWKeVXr5jOX2x9kQaWVxfHTLpENKWJ0QpVVWnidc?=
 =?us-ascii?Q?AQXqr80y5YL2g3RLEYytpzI2InlSM/Uh1dUlS4Yrzs4BJCJMKRYeKm5+bxrK?=
 =?us-ascii?Q?wI9rFVScUN5WwmruMDvsegPzLCjoANINtYnNzvan71Am4vEUKPQNNZ/yO/Va?=
 =?us-ascii?Q?JaKPwM9mL5573eNC6cvxfDACs/Jz/E7pc8PVvtRRX5vSZxjVYjD2u17ESDSZ?=
 =?us-ascii?Q?gOT9Rc2FzEmnW//pkNCpoxJbW1DrVkaZdVZtKeTRP6t14ZrwStVc3FCbv5qH?=
 =?us-ascii?Q?cF38iXFljyJmtJ0ypvLUKgL+bJE2IT2TRldluVKMSH6RbsCfDGwdjLozsl6g?=
 =?us-ascii?Q?lO2KcmxS0x0zSkX9wIaW8CiBgN59Q5p5M2xRljvUS3WfuP+tUjZXKOg4YnPe?=
 =?us-ascii?Q?H+6LL94W1HB4steBdpIR3GE+x9rzfQxm85wK9tMX7cMhehtkEde/KsUF3QyP?=
 =?us-ascii?Q?iM69+2L1kmZkNTTQoe1a3k8KRhZpy0HYN/bqtyW3642fHcx1eSaWmgulzyH/?=
 =?us-ascii?Q?VJ6mOCiabcq9Enxyutv32/2geT1Hnm26TLkNnBVhymYG10rgMRXNkNWUDr9B?=
 =?us-ascii?Q?z8wRrOSlXNqFZLDmjMIUmxm+HVeZw/tVA7Dg4jNJS2ZpH+2LUxZ+Y5dAp2gO?=
 =?us-ascii?Q?WfxqPtOysuVehGBiLMWK//skBJmeE3pKSB84359kzQBn3bSw9+YQo4rF7hjw?=
 =?us-ascii?Q?qwws?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:14.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: e37b5d07-adb4-44bb-3c0a-08d89f108f61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbfFtpHNxEE/qA63Tu6O1OZbBzeLXxCgj/RlcOmAM4UzH6FXfFGuensPSziNwHrD3B4iIdtFfxnoYYnuJyzkaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, the following would happen for a switch driver that does not
implement .port_fdb_add or .port_fdb_del.

dsa_slave_switchdev_event returns NOTIFY_OK and schedules:
-> dsa_slave_switchdev_event_work
   -> dsa_port_fdb_add
      -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
         -> dsa_switch_fdb_add
            -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
   -> an error is printed with dev_dbg, and
      dsa_fdb_offload_notify(switchdev_work) is not called.

We can avoid scheduling the worker for nothing and say NOTIFY_OK.
Because we don't call dsa_fdb_offload_notify, the static FDB entry will
remain just in the software bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 99907e76770b..53d9d2ea9369 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2129,6 +2129,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 		dp = dsa_slave_to_port(dev);
 
+		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+			return NOTIFY_DONE;
+
 		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 		if (!switchdev_work)
 			return NOTIFY_BAD;
-- 
2.25.1

