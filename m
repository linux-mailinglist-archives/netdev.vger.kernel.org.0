Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670A33F75B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhCQRpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:33 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:14215
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232502AbhCQRpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6t0tNczol0Y/O1jjR+Dxytpr3cQZYKzmfAj7BBGz/b35VQ34XPgIhmUWibZMV68VCRt0nhi57uEoW7ELgwOQlaXKPAWKdd1uCeQz/vRmZV3f49Dwx2Kghun5coKISm7RDTK7T0FDGzDGxP8t7Q+jOWPYsKNO9mUmYIaosxjec8JiapY1oeT4g9V6oyS3EljDMN6uWAsehw1mUXkCEhkkh8QestCiIRnJbfVTqfxiLs5yvBv8zvGijVk59S8PTMpH6KOnbSnkP9+aiYhqJ3hNxHQ0zyVdMSI3ksk8txYkHg6K/b90LMmbb8rV3k8E/WWiwzqKr0nJNy5f/OKg/ci7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s341QlzRYOtdIvGZ2jG9BJQVHHZaOqelliAvD/fhO2k=;
 b=ecdC+yM+l/hwCiF15W8dTM7qi5f3rJQmBkJJ5Lsaj8rswDWODJsYqLbeS8vu8u1FYiIDfy4XM/8S4M6ElXIPR8a+Dgp3nDZOSjQAxgOKMIOrspRE6CMQrLdV22ajKLxeQMvHMh1JUPru3GL5Ry8at9sJIqyrz+gij4CwQD62xYNMzyjtns8q8PVg7v0JXhz32VAAjvIM38vVgAKgipNecovuHokDwdoK4lDzcH0u3nTBt7KVPfYsCLmZzwb1AAU9Q4O1JYAgIp5RKVr6c61kxfvP7b3i0ki3WRTNTsr1XGcfFGHY6Qz8PmAyrjQQ9OMLMg9DR8MTtYwo9P+tT2vHZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s341QlzRYOtdIvGZ2jG9BJQVHHZaOqelliAvD/fhO2k=;
 b=Uv1vaqEgw1XoB2wUXQhNNh2boaoZ0M+LaXWNnVsSKfrtygF9aDT8kddkIOuxNDc5xpUXvypmZhDTaFhavVutZholQjxp2udp0QEe4R7FkzpimTm2BRy0+jgH3+yHP/nD8BPXHIGUhCQgxxyP3594ScWSG0L7khGz6sysyOIO4GA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 5/5] Documentation: networking: dsa: mention that the master is brought up automatically
Date:   Wed, 17 Mar 2021 19:44:58 +0200
Message-Id: <20210317174458.2349642-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb193765-ce14-4ef6-3da2-08d8e96c6d1f
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119B905225E6E9862215025E06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5aADx31OlW0KlOYPjva4cEHbh3tFb+TPoWjfCejgbT3Zhpzipey4MPLHWmi4fM0v571nCy7UFj9gdfeYPOZj/U+O+O2BlcoKaQ1JS32TUXbz2yKjaWFkBIRIO8o9puqCLAwAUSwwiOKegwayr8zQC+GTZVaGHcASo3mgzFsl4PQf7OO7dL8QrTwPUZHSxX1uGlcYqTtGSkrOSOxrDwm/z9C3XCZKnb4+iZUa6mej95VYzCfmbEB3ATPMpp1NifqWeuDMIV1fb/f6oUhs7bsRohNpIvWadFs7vkN916WzAj7CQKWXrCUJtZLEm8pCUs0qFNvnZtDejnJkvxlXOaGKNX8wXmSFH/buUuMZnEHlSExyMUqsyEdhlxoOPaTfMX9X/1awyyCgFUzVTvyq1YqXTl0StbZEZMAeCYLiYnwp1hlWrL7NFnmgrZ3M+DFMWdSftELlGElKx8vlcF+aUPe5F8J4ZqGwSIB/QSfaAiZKaLjgjTUGq0WYQhL/1sNX4ns04UsIRdcyIYbJ3S5LCbZRehTnrY8cU5cn3wor7Wb6fXccpCCs1hU0UYPJCHDmkNXrm/r8ASU3IhwBlbmTACnxpAwFB7rniKQH8qq3sqsvQXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(8676002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ga5zAVzsamQSm6Nm3oKet0lpPpN7CqS/DDts70K9z3xvl8Kv5nIxnSJZ2PVa?=
 =?us-ascii?Q?rX8S3sNpzAxjMuPGknjBmKCpY4k5Ix6JQZvDAe41ga1WpdUjz2IXvEMp2WIn?=
 =?us-ascii?Q?GLyol8KA/5elv9fySanXUW5eAPJUhCJArKgMQcifA+7fzC9UUNFaYGeeMyoV?=
 =?us-ascii?Q?VPaTFKjcQTiuQUPb2u54BvL/DKKoD7GubhwD9O6i6C+r7LfqAHt+Crq23VR9?=
 =?us-ascii?Q?sgW3K2m0pcBtdjHOGp2L9/yFa+Y0wpUrEpNTBqldjVqx+21V3V8G/bDR2wIP?=
 =?us-ascii?Q?ROfBUMPkKcpLQzKT96pk1Yq20kIRzSPs6lAUvBIorQcLlYRed4CDPY0h6ruU?=
 =?us-ascii?Q?zDxzwm9s2LuvB2aEeRkWJtNxlU7qss5sITvhh06m4LOflAlEWVGjHrNrXaCb?=
 =?us-ascii?Q?NvAmPlhoq14lfDR7KwNn7jo+AG5pq/TQRp5SowrzHpseQaMc6Qbvx4ek5zpj?=
 =?us-ascii?Q?cMtEgfPHTH/sS11NvzBfL+be0YoGvamLtKn6SS5Dho1zxV9wwYz80DBSfH9D?=
 =?us-ascii?Q?FnitaWZmHROY+D222qVnEeqpuFxPSAnvpMMYPEW6aJayv49nqbLM6FYB9CaT?=
 =?us-ascii?Q?NfHRyaYzQfF1IU/tN6RwLIK6maa2vCzCxTCqQv0lhBycA/bLVVNamzlP+KaL?=
 =?us-ascii?Q?25par1TuRZEEq/vZSHnDFkGaMR/rrhSEJZsc4pEGwGwakLX/jWx8Kh/vPwef?=
 =?us-ascii?Q?/vnDxEO4uf/7MmHSnYGSw5uJTi2KaGj3+EQM/5+D6HvC6N6OZ2vo3kT5xLYQ?=
 =?us-ascii?Q?eT9lXvr1ahOS8Bjfbow5wiUDJp8AFmCzMayO764burEFCrFKfiRqfaVaGDQL?=
 =?us-ascii?Q?QNkG4DUH7AxBP+T+6vtByKUKrRFa1MadatrEEM0bRp+C4Gutfa7BYnXE0CtP?=
 =?us-ascii?Q?yTbDJ4LweOWVu+4hajwdcxsmzUC5r9lflppKI+Sp+AMPfsA1i4v4W/piAmrc?=
 =?us-ascii?Q?a88bG4v0roBpRBqAE5wWd+KWpcj+J1aFH45NCGiwAM8j8k6o8rnubwZfFooB?=
 =?us-ascii?Q?kF2Q2sKEzsBFnzBjsBAbzWKSlZ+Y8B0/pFKNTILD14NQu5s6ulCHPXg+29p4?=
 =?us-ascii?Q?iBe8mDHFsgFg9VIgaXnBB+Kyz92L/6q1JYKpNztfcTxDbH9P/V8z58OS5Kpx?=
 =?us-ascii?Q?sgm7Cedr0syVjxAT80oip/W0PqyuXcGGxrzjAX+VC94dpPA+HLce17q+xIWl?=
 =?us-ascii?Q?V7jxAnBshFBSZy7xH0NgUEdcpil+6f9hs49Lcbem64NL6cEh8vxrerSH7HQv?=
 =?us-ascii?Q?j5NrCvcQVDKFzqm1F8IVY2pjZl6bdoxxsl2KWFvLgEAhx3uiyqnd7ZLG0elY?=
 =?us-ascii?Q?YzfIMj6gaYf+eQCCYAog1ifp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb193765-ce14-4ef6-3da2-08d8e96c6d1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:17.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TstHPhrySrYaDbSxmwBUW+nPCbiEPfAdbRCkf9pzWK63h5QyVLbqKxHKpPdDMW/Xls5G2Wx1lqIw/9jByUnmow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 9d5ef190e561 ("net: dsa: automatically bring up DSA master
when opening user port"), DSA manages the administrative status of the
host port automatically. Update the configuration steps to reflect this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../networking/dsa/configuration.rst          | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
index d20b908bd861..774f0e76c746 100644
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -34,8 +34,15 @@ interface. The CPU port is the switch port connected to an Ethernet MAC chip.
 The corresponding linux Ethernet interface is called the master interface.
 All other corresponding linux interfaces are called slave interfaces.
 
-The slave interfaces depend on the master interface. They can only brought up,
-when the master interface is up.
+The slave interfaces depend on the master interface being up in order for them
+to send or receive traffic. Prior to kernel v5.12, the state of the master
+interface had to be managed explicitly by the user. Starting with kernel v5.12,
+the behavior is as follows:
+
+- when a DSA slave interface is brought up, the master interface is
+  automatically brought up.
+- when the master interface is brought down, all DSA slave interfaces are
+  automatically brought down.
 
 In this documentation the following Ethernet interfaces are used:
 
@@ -86,7 +93,8 @@ without using a VLAN based configuration.
     ip addr add 192.0.2.5/30 dev lan2
     ip addr add 192.0.2.9/30 dev lan3
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
 
     # bring up the slave interfaces
@@ -97,7 +105,8 @@ without using a VLAN based configuration.
 *bridge*
   .. code-block:: sh
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
 
     # bring up the slave interfaces
@@ -122,7 +131,8 @@ without using a VLAN based configuration.
 *gateway*
   .. code-block:: sh
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
 
     # bring up the slave interfaces
@@ -165,7 +175,8 @@ configuration.
     ip link add link eth0 name eth0.2 type vlan id 2
     ip link add link eth0 name eth0.3 type vlan id 3
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
     ip link set eth0.1 up
     ip link set eth0.2 up
@@ -207,7 +218,8 @@ configuration.
     # tag traffic on CPU port
     ip link add link eth0 name eth0.1 type vlan id 1
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
     ip link set eth0.1 up
 
@@ -246,7 +258,8 @@ configuration.
     ip link add link eth0 name eth0.1 type vlan id 1
     ip link add link eth0 name eth0.2 type vlan id 2
 
-    # The master interface needs to be brought up before the slave ports.
+    # For kernels earlier than v5.12, the master interface needs to be
+    # brought up manually before the slave ports.
     ip link set eth0 up
     ip link set eth0.1 up
     ip link set eth0.2 up
-- 
2.25.1

