Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5764B754A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbiBORCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242104AbiBORCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:46 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAD311ACDB
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXqer6gTrxeXmwrUt3kgU9W+FOJEdHeWV1c0ms59RC8CIPRgvB2wWuMvNlEkaerOpanwWVS6YfCfaf8Ap2rRRbUECRbkJtgcnUTM5WeFZtZDasNlQkKAKItL9rarV0N9DHc1hUcpgd8AsqRVwKDXBjl+VF4LyUf9f6YIULtPsEoJ3o8VGMlYGBhf1Wnw4Ubht6qbsvQKqF7uibmmjk3uSonPOWWLWNM5x4cHtKMdnrkZhhuddTVlGKcGAMTaibVWbF0Gmfj3CLWT/D+Q9Kr/kb2odStEfaf2ynq13kD7cAhzvnXtuhFh1LZhWn7rLmPI7vXlc3YA64AuegkLI6xrGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ngof7NGVzIgPHuVbnuBFJJd+haHGG1GQkOYkURq9eQQ=;
 b=ixo2qspAxgkpV5JQM+YRLWaJBAaApZPcrE0n/NktiNziWeV6e5B/0eSwbnQeGOYR4092fgilhN/dLEqzQNo92ZwtW8FYHhRq31A+UZYVgwkrsYEVdUDwuNZs8flFFQDyo9WWtBePgPvS0E2UCeRS+untmgniPxG188OVAB9GLCXW3tlU4VjaOJidY269sR2ysJSiI6mxjhFqi/b1pj4dc7drYbztDqHYA6BIISAu2kkL+HIk2H2uPy01WvuxUgwjTAa8ePj/6jmntP7xFGJCJ9aEe9XNho59LbNdwtqxNN4rW/pM9HGtYk1CnQg30eqrWXwHpqOrdk5mHB9B4MP6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ngof7NGVzIgPHuVbnuBFJJd+haHGG1GQkOYkURq9eQQ=;
 b=XWMVQage5WnfnvhOM9tUovmb9MF9AOifSYERY80T0Jweuqc/9OIAZl9uqs0Xi7SWSeZ1d6Sm2/9gxDkFDpapIsT8LiUT90IJrP5Bv3ihP/6uQrBda6l2e91Ldkj4kwjWyH9BELH/U2P5AuoJD72F8KOKRq87lN7GXDkGU51KZtc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 02/11] net: bridge: vlan: don't notify to switchdev master VLANs without BRENTRY flag
Date:   Tue, 15 Feb 2022 19:02:09 +0200
Message-Id: <20220215170218.2032432-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71916e06-33a0-4d1b-1313-08d9f0a4f26a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342FEC56BFDF81EA562BD00E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IK1cRHAvd0WKXJOOXfBrCNcjQEsFAmqcExiokuSTBM/sUeSaVZFYi0xbYyxOJFzbHjhDWQgz/29/w+ITNFIeJONNDngLLk0Fwk67wS0aacLYdfFFxbRxcIoCsiA3rGKiBGu4XwLM9amGtYHhPm4ThZ19bfWNfJEPq5QG7tigyphw7uP4IraBexp3O/dFONnKSoT/fRoz6jncAhiiBZclLdPHk46I3BUbD/vO2bS/RYeoubaMEI2P+rQm2zHpW+Ii+80Ek4/6+WtWt4JHOxJgPlb2PtX0x278DjQVgS/rB4+yVvV0ekcbGme7oSZ9HTtkZSSANfvXb1Nk3xvkkA7UPuts6e0uEdtAZhXSmaYWDbEHHCvf+7XImha+roYv1RelnoboHfV7sCH5Z9swa3W7p/fys4MqVkqGvV5pLGG0JKmRBjWVYYFwH2PvgM2dJvIbyLuc9GM8db1+Y/uHd0ojEpaIPeeA5OGZtH5Fpv5mtUoztyrZ9ikd6dMQ0yjOrQigLUW7Akit9Tn4oKCxHL4977x1WfeIM1kmPfdcZKQkUn+lp8jkZWU6lYbYeOS/Il/5YFJww6KvCmadniqlWF5K3qMPbgZRKRIT0qX2CdJqnHOKr8BU3I5uahm6bzOM4WvnzAkFlqzIohlReF23LDmYxVF4rp/7PcHfKH1qXubHxDKkVdP6oQ399DjF2QjoXA0OrepCDaAvVcw30CSFaA09dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1NSE3ouy6ZLNpSCuQJBJNvo6txpSpyMT4313oFIcw1Nkbi+2q0EaHJ98kJuL?=
 =?us-ascii?Q?vkfXATQyjIcdJbqSivpcpFsemiWDQ8FlyKATNhJQgE7KRR3AZrIX8jbQsE9X?=
 =?us-ascii?Q?ivuLg+p9VU1I/WFnwLeyjTqSbIQDmKAuRrUM7cqMsGNhRFAViEYGeoL1WYzb?=
 =?us-ascii?Q?QpOdYdTL3+v3VetfVU7yirgTkYfle2L1oCFztZhTItYiQFDZC9pY7sKx1a1l?=
 =?us-ascii?Q?IRvlZt2PN7k9TX7QLYR8PvckJqICdk5kpjDdQqXWln6lYjtMjZ3Cbco2sv3a?=
 =?us-ascii?Q?o5RHlqNlrSkjrWgg2BMv/Yh3yph9BFUEmqzy4HWc9xHIVabmJy6Cp7A7BKmq?=
 =?us-ascii?Q?RD3eLRP9BIsFvpHiB6JXkhJB/V3hmzjCQCtUsyOrLLRaFfO1oNniQDXy2EXH?=
 =?us-ascii?Q?gtvGLcmq5i+RfOrDX1dn+uAyPXEYCwnQe7j87UwCbNjlEZHo56YJuB2STRH+?=
 =?us-ascii?Q?Mxs3x2p1kNv2rHGO9K9MqWI38rbGMjAL69Xu4+E+ssjGpwC995mZOUv2dZ25?=
 =?us-ascii?Q?cMo6TLbDyANanmw4eHiJfbi5dCL4YHfq6TNxH6GA401L0otCK1cWz1RX21rx?=
 =?us-ascii?Q?SVX3/j8cnsHBAjk6zBMgxIMHRa+GkGAzpG+w+CpTdEz8z0eHJy6io7CyDy2+?=
 =?us-ascii?Q?8fpFA1wFv4G1DARR8A7fipJW/ulu5pR52UHIRXyqhLdbc5ur2FZ1eKMSZfWp?=
 =?us-ascii?Q?nDimVTC1DfGMUxcEaGOx9cMGvms95Fj3foR3lzuOEx2kAgCQmMLcww1DDCrR?=
 =?us-ascii?Q?pet/ATJTELb1weSZglfeRAlZmRZqbtNpI/9iPpZV6cCyRnGFLslRiQDiowwT?=
 =?us-ascii?Q?gU5V3BCbGEmFkD3Njkr9ilHb6KvR46KfjUhtKjzQw2tLJaOQKZhCenenw8iF?=
 =?us-ascii?Q?6mwjGVjIPMrIHVth849YCYjosIcpOOe7pJU+whIQWJg12ogifRqVYtBmFgX3?=
 =?us-ascii?Q?QQsMw+uaGLfNXeL7f6nJQTKmC+goDBCl+jDo+ac0YXXuLK505yMI2UIjHERv?=
 =?us-ascii?Q?z+2Vx8UhEPzs7moa/nk70nA6zC8BKYAzeW6VKMY8U9jVCTpzG2tuq3SlXScH?=
 =?us-ascii?Q?+Wxe/S1/UEIt5NBsVByebTxVsPUKAks2tI7XqUM513w3SduVF+ckCkdT0Sci?=
 =?us-ascii?Q?xYJ6srXTWhkbgWJ8ttw7Z+aBiApdcgwulRd28fCIUSAPqWMNiJfpLtZw46Cb?=
 =?us-ascii?Q?xoCRb7WpuXyFpAxq1t4bUm3F19Xu96Hj/txcl2gtCwd1rp0FTNDtabX9Ul8R?=
 =?us-ascii?Q?WDtHZWHdDkb52/hR89zl5y97eCFqc/DFxKIUArgQC+uK1kSdQzFwtyzMQT9f?=
 =?us-ascii?Q?mholKoeUq67RapzhGvkow+eOt6cWgUxlZdtClmJsBjpJjoYWpn6bdXyszMti?=
 =?us-ascii?Q?zZ5TDwj6sBluS7OFK1kaDfni8rwt/21TB3nxDtxP21/oEKoqmg7y2X98UFFw?=
 =?us-ascii?Q?LcNCLxeimyq+dctxCXWgRAFmdc1M1RBliO99DbKhXwKhOXpe2aroYzDxXSHd?=
 =?us-ascii?Q?T4ORNpZI71IYzLadz5Zv8n4ODsDUJfV5bKySuA3g7+SXj9xXqP15aD6M4RWD?=
 =?us-ascii?Q?EcH8DN0tZUZWSiII8DEZY0siEdB6Zd1GQ+ib2P+O7LIIKgbDgqIht10UCRmw?=
 =?us-ascii?Q?Co7nr3mk+MyKN/Oxm6bBwXc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71916e06-33a0-4d1b-1313-08d9f0a4f26a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:28.3538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xu79bcNaRm7TWGV4jmxeBUT1f1lW2gRqbimtww34dNLPaLAh8zxINO37u+09q/Z73RAuzaRGjETG7DzdFW+8bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN is added to a bridge port and it doesn't exist on the bridge
device yet, it gets created for the multicast context, but it is
'hidden', since it doesn't have the BRENTRY flag yet:

ip link add br0 type bridge && ip link set swp0 master br0
bridge vlan add dev swp0 vid 100 # the master VLAN 100 gets created
bridge vlan add dev br0 vid 100 self # that VLAN becomes brentry just now

All switchdev drivers ignore switchdev notifiers for VLAN entries which
have the BRENTRY unset, and for good reason: these are merely private
data structures used by the bridge driver. So we might just as well not
notify those at all.

Cleanup in the switchdev drivers that check for the BRENTRY flag is now
possible, and will be handled separately, since those checks just became
dead code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 net/bridge/br_vlan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index efefeaf1a26e..498cc297b492 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -284,9 +284,12 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		}
 		br_multicast_port_ctx_init(p, v, &v->port_mcast_ctx);
 	} else {
-		err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
-		if (err && err != -EOPNOTSUPP)
-			goto out;
+		if (br_vlan_should_use(v)) {
+			err = br_switchdev_port_vlan_add(dev, v->vid, flags,
+							 extack);
+			if (err && err != -EOPNOTSUPP)
+				goto out;
+		}
 		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
 		v->priv_flags |= BR_VLFLAG_GLOBAL_MCAST_ENABLED;
 	}
-- 
2.25.1

