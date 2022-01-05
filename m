Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7F7485378
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbiAENV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:21:59 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235186AbiAENV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:21:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgSRq5umjdKmb3zESq34POGbhfe6ZF/I6yImtg9VOvFVNsf5aA5wxfxdGLZ/vql3pAT79s/YKr3JFvFupd9PEpMUwODxqmwGgp5lidmPOUvceFBre2ZCsj7t7pUduLkX1nfh7fDtbjwsDcshbCchIIYTgrWR3w6kqJxmies/qmpUiaPj6iK7wRsEOAA2yv+6PKFee4WQMnJsXkSl5E//c54q6YXeI5KYqtHhawmNqNMAltABaJSvrND9EGXVANDwvOtZdXRzC+u/iek47Wiwx/6JdX1ix1yTGYWBgo3iJpHwCAdHEzFEYEwPxUsVe3UBA6MZZvBhCwprSfCRFW/zNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v78TTxDRv5KP48eXVu+ERE5yLA062w4etMoW1ObC4v4=;
 b=fp19wscdI+xzP6om9cV71TSkfBZ9cigjTtkrcu6KiSP50/zdozaMF8d1RqsaN6dyFdphspBrblgwFz23qHU0LSgXGn/R+HSETDGWMXSuETky3CAFDQCQw6etFxDgiFxg9YwyRLRsj5JHRP4FSgdZ1mLNcOCkvDsVOxn4IZNEU/NH5Iug5+A2o3eOqELID0G5QXgATDFTEUWohuxFs6u5Ss4nYM91RGBKBqT2OX5DEkRcRS1RrhfmwY0idDmSlk4iM95S8aZfwumonn4z8XcXMnTWQcpQMwwCiAbiIPxq4omIUy2+za9ZX8Rr37HMm65dpj1b7wD8k/qyTPQ7JCV5Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v78TTxDRv5KP48eXVu+ERE5yLA062w4etMoW1ObC4v4=;
 b=Iw4e4EM57h7yNx+n4moOIfhDv3qJt2EpHriMbEoksZrPyOPZS4I+8uv0cEKxhG4ZWd2BeQx4FeCLWTUBIqzWHLDMhgcVmCCJItUHZ7hceX9vDLrwbGjH8ZXjzUl896PjkQ3jurWFoqiARY9gNCs9F+ypU9u6PoP9nGnvP9yyxNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 3/7] net: dsa: move dsa_port :: type near dsa_port :: index
Date:   Wed,  5 Jan 2022 15:21:37 +0200
Message-Id: <20220105132141.2648876-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0150.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54dfb5a0-5963-45f2-4d3a-08d9d04e5785
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB740804AB5D34DC6715F72ECCE04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKc8d72s0cQy9Yt/024xUSxq4iWR/Lj4Ghoq4MT6YcBnZFxbOuXj778a7j6500W8HHLv7bQ6Qs/wae4yUSGv3DFHtdddZL/fe4OsosfGIYe2A1ZcZPSRV9piTyuxX8J63EujA3FUAt4Wu+wUgSDokuok4j+D+bXmWNYRFHvwnavt/hqlR2yxVE9rZ2Mh5pB8rQeHOioXSK7Z9f8SzMR8r0qiH49gBzvH+ltVVh7cQI/3rbgZZ/DRYP8s8y/w6hNnHxX1CWV3IMGzMsdsGDW1ODMvlduOFci3CF9M/QWkfjc+m7GkCaL05zZ8JsMDPYQU5aInA14uIR0JZA+/0uGy6B3AbDxUFGOUEJ9ioVUvUMuEF9KfEFAM2+rOTz6xpXZ6mi5oYmB1AT7gx4lw29+u8cDszr1pCA0U1uL+t7UMAE+CcFqCDj2AQsaT+CmVi/3u+XKH7hv7x/aOcfxstXf74vZNGvw4xmG0oZQ5q0UHCBPfpl2BI3qZ6IvlnntnKzUSwwfjUE1XX8FrWfKlEEDXco39VHkHKr1X4DmSoP/eVmeC/gLUHr8xu9TJd913cHzZwi/Xj9oJsQtKCcWpng+qfRUBRkpzOd6n58bzVJWx82pXGNqzYaKYOQ31B8IZ2Z0BrwT/1kj58jR/ufdn9VAXWLkAEOU4wU2GtdxuDopFyiSdWf29a0nhshyo5rRKNYh7yXtnHiUqqRfdcTrdE757NemNl2LmLRLog66S1Z+JnPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4KvCFOsMOgYeWmJ9tmJHhp1pNpyU6a2eh8ALlMqJ9frRUv2uwBw77P+9bb55?=
 =?us-ascii?Q?0EB6SGarnk4ScEpkF6Uvh5XVZ9LXyRlFH1acHKNd/10LTJLJ33w59W7PTGZy?=
 =?us-ascii?Q?wSScQdlJP4QytueyXRqkfymoABT54cR8zzKaPpmslquRQbQyAL4Do8x3AyKw?=
 =?us-ascii?Q?uXQ0g7axlwNW90GkTL2hojAp36QwW4giF1yUAh4MAmcdsvXUhBKL44NiNoeX?=
 =?us-ascii?Q?hUkI+hZ9FyXQAXvZClLxMna6AaKSYuMvDeF5T1tTdP1rAIM//ss74XI5lSh6?=
 =?us-ascii?Q?3nhLB3HrR8nBiHoUwaRPbtfrufM2mJoyWMIBcr+IwJ+2G71/zKBi8NbM4YNY?=
 =?us-ascii?Q?9Ll0JEn7JrdK5amQ10TpDAmMV+UwxOkM0wThqqiYvOAor+WxTk88Ub0reKsF?=
 =?us-ascii?Q?UW/eZFRvt2NJAIze3T7yxdhTujy6N0ufVAw2p/AcF4KbIkPIFIPir+mYIOwm?=
 =?us-ascii?Q?Eda2POzjGXXfqc8i2qfU2PTpRTWSahMCiR2rF0NwKzYjTkrOQRQfdslgGY8b?=
 =?us-ascii?Q?rB+XsMUt3G7+bkcaKwCFdv6ByLh5VGV8F4x6CTYMeRUCpc3onDfigUx5yVBY?=
 =?us-ascii?Q?tSNjzBxA0UCOEe7bjtwTFyJDVfSE/dbUkuS7vH70+D0PtEygO2GHasBxizOb?=
 =?us-ascii?Q?qIsht18MuGppOgy2kpbQJrZal+33+WPs7ABBr/TlTum56B92pAKaPVW7Tb3y?=
 =?us-ascii?Q?ub0McbSEuGPpYp+tt8uMjeu5nc3jcT+Qr7omGlvNbmROU1vyeC69Uu5JuKkL?=
 =?us-ascii?Q?ssUxgARkY3zUg8ljGB4PpYba/ox0VLuIAo/pXjUBeA0s9LqW1851sTGhq8q3?=
 =?us-ascii?Q?CH+Dp/K/3TRE2mUAzpbSEe0Q3VvQudvYx+23BbsDaqx2fzk0L4ZYMe2nLaZ9?=
 =?us-ascii?Q?WbZogiaSzwMjkOgNilVFz7yaHbjU83IXtV/qbq07mA/7wQG3zbDM/o6ehtol?=
 =?us-ascii?Q?2v5Shnn7vQKhhLvaIDHAaMCITkmMJ0zSQXJaVTOZ0IDG9Lfv4BIfRv6M/XD9?=
 =?us-ascii?Q?mlKRZN94ugoUlzIWzHBqcIyXDQjhAzo3IWcz13wxazkb4fBqHEdO3C/OAx7x?=
 =?us-ascii?Q?BMfwK4Zo0ZFZI8ZFVOhpZJIJXOT8Be2wqYOdEQsXLLe6Kjk8d8yhqZdpAS/P?=
 =?us-ascii?Q?o1FL+G9KToK4rPXZwq0IiU1r/BKm4SPhWeL20jnIgu9aQheSXk3EMZyuPmpv?=
 =?us-ascii?Q?fVq5wOaMIytU1ngqUqO96ce37tysjk1t8vRsVuxv+6iyuQJHHBhE+1vl681b?=
 =?us-ascii?Q?jiwjb/7UmEI51zJ4STczWi5CaOvf6sskIgS+eVDKodXlZwlWxl14stbrYU7Z?=
 =?us-ascii?Q?b9hYW6Wlw8e7QvWGUwwg+V6W7J2y4xl1D7aEX1/6ZDsGe2iXcumIpZrUL4m4?=
 =?us-ascii?Q?74+LYDiUOEA5IrsWJX4v5nd8KoTTIuPfoATOht/+QiXm2/me7ypPv6v3eoKk?=
 =?us-ascii?Q?Gh1G47zSFXimvKqza2tb1pfXRm3SamWiXycjQ0tTpIb9JtkMd6GFaXHoFoef?=
 =?us-ascii?Q?Je9gu6n7KxJ2WjAOpx0RfLOVdtWo6FNoMKSGMNWaJ5lZFSIVm2eutZgf96nP?=
 =?us-ascii?Q?Nh5WVwC71RfRXEM8sxW8zcBXXVgFMg3JjgBqJN1L+PSdNoBr96DvnRoE6Ncf?=
 =?us-ascii?Q?x4u1J+9d4NRyiXsK+qlcWkw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54dfb5a0-5963-45f2-4d3a-08d9d04e5785
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:54.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cd80f5Sw4rLAPZNFb9xgYSHC1oSDHlU2+uQ4hfv7vSwAK+RXYbfUofbVjX5kYvMikYq9RG48bzeA0HidC2zT+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both dsa_port :: type and dsa_port :: index introduce a 4 octet hole
after them, so we can group them together and the holes would be
eliminated, turning 16 octets of storage into just 8. This makes the
cpu_dp pointer fit in the first cache line, which is good, because
dsa_slave_to_master(), called by dsa_enqueue_skb(), uses it.

Before:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*    40     8 */
        unsigned int               index;                /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              name;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_port *          cpu_dp;               /*    64     8 */
        u8                         mac[6];               /*    72     6 */
        u8                         stp_state;            /*    78     1 */
        u8                         vlan_filtering:1;     /*    79: 0  1 */
        u8                         learning:1;           /*    79: 1  1 */
        u8                         lag_tx_enabled:1;     /*    79: 2  1 */
        u8                         devlink_port_setup:1; /*    79: 3  1 */
        u8                         setup:1;              /*    79: 4  1 */

        /* XXX 3 bits hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    96     8 */
        struct devlink_port        devlink_port;         /*   104   288 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        struct phylink *           pl;                   /*   392     8 */
        struct phylink_config      pl_config;            /*   400    40 */
        struct net_device *        lag_dev;              /*   440     8 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct net_device *        hsr_dev;              /*   448     8 */
        struct list_head           list;                 /*   456    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   472     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   480     8 */
        struct mutex               addr_lists_lock;      /*   488    32 */
        /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
        struct list_head           fdbs;                 /*   520    16 */
        struct list_head           mdbs;                 /*   536    16 */

        /* size: 552, cachelines: 9, members: 30 */
        /* sum members: 539, holes: 3, sum holes: 12 */
        /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
        /* last cacheline: 40 bytes */
};

After:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        struct dsa_switch *        ds;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    44     4 */
        const char  *              name;                 /*    48     8 */
        struct dsa_port *          cpu_dp;               /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u8                         mac[6];               /*    64     6 */
        u8                         stp_state;            /*    70     1 */
        u8                         vlan_filtering:1;     /*    71: 0  1 */
        u8                         learning:1;           /*    71: 1  1 */
        u8                         lag_tx_enabled:1;     /*    71: 2  1 */
        u8                         devlink_port_setup:1; /*    71: 3  1 */
        u8                         setup:1;              /*    71: 4  1 */

        /* XXX 3 bits hole, try to pack */

        struct device_node *       dn;                   /*    72     8 */
        unsigned int               ageing_time;          /*    80     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    88     8 */
        struct devlink_port        devlink_port;         /*    96   288 */
        /* --- cacheline 6 boundary (384 bytes) --- */
        struct phylink *           pl;                   /*   384     8 */
        struct phylink_config      pl_config;            /*   392    40 */
        struct net_device *        lag_dev;              /*   432     8 */
        struct net_device *        hsr_dev;              /*   440     8 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct list_head           list;                 /*   448    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   464     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   472     8 */
        struct mutex               addr_lists_lock;      /*   480    32 */
        /* --- cacheline 8 boundary (512 bytes) --- */
        struct list_head           fdbs;                 /*   512    16 */
        struct list_head           mdbs;                 /*   528    16 */

        /* size: 544, cachelines: 9, members: 30 */
        /* sum members: 539, holes: 1, sum holes: 4 */
        /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
        /* last cacheline: 32 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a8f0037b58e2..5e42fa7ea377 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -246,6 +246,10 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 
+	struct dsa_switch	*ds;
+
+	unsigned int		index;
+
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
 		DSA_PORT_TYPE_CPU,
@@ -253,8 +257,6 @@ struct dsa_port {
 		DSA_PORT_TYPE_USER,
 	} type;
 
-	struct dsa_switch	*ds;
-	unsigned int		index;
 	const char		*name;
 	struct dsa_port		*cpu_dp;
 	u8			mac[ETH_ALEN];
-- 
2.25.1

