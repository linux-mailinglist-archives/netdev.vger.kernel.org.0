Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1939D5B4B1C
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiIKBI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIKBIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:34 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05F94DB74;
        Sat, 10 Sep 2022 18:08:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrnIE/MIBturAXmL6k4M8mNvwrHJ0iVURr4y/H9SQQkR4oYWntPOuFXNW/2iN60dFwGpxggzZ96DxIUG9QlbkdEcw61XdjqvvvFbkhathnlthzyb1/kOq9f/l+l3+NcraGK3l0KYBT9CjwAINWsYcEaLjl4FS5kGPcaEdQK3bA85EUG6dDfkWseVe9LtWrQAXvKIyHrBIxHV4mfBR+cOe/6hoB4VtBl+puUH5exkg4hj6PqNZRLlrtz9YyvgGRo1SfE59B1G1V0friGWN8oPGZ5GNTCtBKrwLyUPQrU9ejWBCHDeS9pAtAuqT/JVw3eijd9hCwixbSznrToGqe1J0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYcKeotYWpTIb/Z/ZihOIJ95bBlQiOjDJrpLdvaXHkU=;
 b=edKmBs/y0iP4mIpWCXrDyYe2EdYIAFOQQakXW7jAhwx7fvKGwi4BmRsWYWm/b36Pu5vUbZZPp42MHsVNxET0ENunw6KH4uuQvwlxTXVCCJIYteHy4ezPibSugXeyoiG/+sXBwKuFp5mj6OLH2d9najfFn7FG08O6Bg3A/wTSzQXS5BSK4vsi3OBldMpaKCIYKk36OZ1K6HUcxBPfvSA8YbZVQJw0OwscVUchihh9aUQs1Ti7533BF8B92RL5kNFHe80hcCptsFdvhosqcvCYgZ60ue1MU2+rnTsUu0ILHsIJPAJxu6CTpVhWbvdjP789+PQERtv6p0isQobFGN6PIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYcKeotYWpTIb/Z/ZihOIJ95bBlQiOjDJrpLdvaXHkU=;
 b=YwHnrjFEd1zWM+RBEQbHE/fvvrxxh4MxcytV00L5/P0tOhcBMJHKaKxD9hGvZWYNGr0cRqiYjfRFCozA3Li6ibEfwcNIQGoRs1lDlU8xpnw1bXwQukYy3EXL95nfrLgc5zhRdW5pHUyemXznY89x0dxm9rL4XuGilaCwyC10i80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:56 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 05/10] net: dsa: suppress appending ethtool stats to LAG DSA masters
Date:   Sun, 11 Sep 2022 04:07:01 +0300
Message-Id: <20220911010706.2137967-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d111ed1-84c9-49f9-aa9e-08da93920f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: luheTqy2eIM3LcVD1z0LWMQPiT305nkuYQYtJhL2omRGvrMiWXz9x87hPbF+ZdjJsFFH0HpSB+IRRkPk6MDC/T3QwpVXjb2iaQFnj/CZpXoIk4UkPs+l7+fOO9ecSn6jtEs5OviMygsFWaq1OUlRmzboSiVKu6Ec4uji37vWkr0W07rJKBRY5JlCTWWWAlxV52T3ls0lyMYlmRNi5SYdYXWCcehGt+yacJLC6rLOQ8qpbP5T1ZX3PGWvXyJvpw2Y1Kk2OwjV4oEFTX8UCc6EUwSEFE38hF9XvoiLyRfFBRiMipOZfXWGFEuoTuS7dCIJb5kPLkrd1D6ZzBwzrdfi1kl64U5fAfhTEcFPDkCcokvIqRbYIkiK+LZ/ueCFQuZNEDzTiVjweL4pbSLqv9nBhej/BFoST9VDaXNwga1PI4qs16J1q21rlCL7Ofhnqg+fDmdv63/5VQ3ibmfjB27PpxaEozxuz/FSlajnvvOhROGJuUd3w3Ia9/EcdaPFIKYvcJHTysgN6y0kPNTU95VVl+UOFaQMIX+6K/jo2MYuwGKn9KQiqZZ60yqSJt1pSefeTWDI08OAaiSThZ3KD2sqp88GqqA6EKMb7Qo3n4KEpDMwiViwXShPTrV7jNAPcAswge9d8KmvEk5GWHLPhcgNlW5c3g4P3kY5WG9y5SEuMTINAjl6OeNBQDt0K3ysjKxL0TA+WuCcfJ+tY3XSRDasCxQKHU6qkvIWMNG0WATjvF1C7hDaHwthJ+W2jTTLm51W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ONVgpCRybybu8cLHXAtJeoiP9h/FaN31ByedFkA4cWyXgH1igMafmYzc0M58?=
 =?us-ascii?Q?2DKwH0puTffXgUXfgnBVY+JOJSuMw98+RNZgbFp6BKfzTqN+GQCbpkZvUIbG?=
 =?us-ascii?Q?UJBwZO1ICcDdefhyvOyxY0snj01Cw+YWeftT+JZeDmgckEjgChkmHOTj+61L?=
 =?us-ascii?Q?1/kbwJCnaDkDx73ZUxzcK3FCmuQ8tauco0wN/MFVvU9tgyiDVVEMXL5ZC0Lo?=
 =?us-ascii?Q?xyStQJ+FpzvyTTwpUEBWfORhr9BWhO7Ky165L/8nmgRgrVPUUeFVsvosP2wl?=
 =?us-ascii?Q?nDWay1BAitwFqK2TsU9xvZr/eC3jnwwONoTAc+vvo9TZAKAdXV9WS5kgDHdj?=
 =?us-ascii?Q?zZqAG9bZm/QFYvechRaomp5MvsnngTIsJYX03sToIatI0OeBOEx78c/050rh?=
 =?us-ascii?Q?goAEPbtVQRysg68YAijXwTSj7j4EaQ7imbq0EmecvgRAAAx4ibPRzt3eTI4a?=
 =?us-ascii?Q?t/HWbATouqEfz2vXWkibS6ke499v4kX8o/sucBT1S1mHwAUT/3GNKEd2Z6dj?=
 =?us-ascii?Q?Xvn41h2TM1J/B/WhFjbgqDK5FX1UrHiKYr8Bh2+6uFFGnMGc46folYBmb+Wr?=
 =?us-ascii?Q?js+RsrCrLbw9mvMMx28sq2uoffcLrEfzp0RXKTkmqzWbDVztCucdtOrCHimS?=
 =?us-ascii?Q?/7/LZRwfl+4o2h7Otvw4Um3vI2l0M/A1/n4AFNMv7DWBuaQ0tAlR5rjNVkFc?=
 =?us-ascii?Q?dm3bbr/BRqyM/PcWbL5VRiKj/8WnUqEVMzLCDGy1mL619WY4yVCIROO43Gd+?=
 =?us-ascii?Q?eKJQZmjZF+i0pTUDZ3a8pJL87tT92YUYo95QH7KhDuhRQwl6J4ahukWwCilF?=
 =?us-ascii?Q?J/1N0QsMrTiJK7WvfcLYhtk8M6jZgy1Y0E8V3xfsBcnJmZfuDArAI/aQ2L78?=
 =?us-ascii?Q?RtAzfwezbgJgoAwx7AR2rOdADGUh4+ZvWci9FizL45MVB7JcKVteKeVbXhk1?=
 =?us-ascii?Q?HzcSgkg4kBhON7S3XIld+L3BHuuKGIYT7T/scsBkGC1lNF4epQ+pDKSFNLcj?=
 =?us-ascii?Q?wHbUh9aYLodwr3SC8U4KlAu933Om0P2xxxkRWqKxhIyeof2aYUOqbpkDyptW?=
 =?us-ascii?Q?lNA27RwvUyT12QmJAaRw3G+f2hXzlPJHk6ELjpJeD94vhTODlG576mKKqZaM?=
 =?us-ascii?Q?tPSNvSlFD/oh9dr/SjWmVsepnemcQN2Sp7mwAoL6w00ZZ/4cfUNHYT9uJ945?=
 =?us-ascii?Q?qmdduRBEXRUURtOXK8VwLrHlyLtWBNg7K/y5xACQOuvOrakWAHyN7WulMdYs?=
 =?us-ascii?Q?MKnn19CBHGT14SRaJOlW/tCb0EY/HS8Qxopv9NFQOMuWGaqgkzJR+2D8qUqO?=
 =?us-ascii?Q?TvXZ92zHrvo4G/9FM2FlBXSxzig8Um9ZGIhKe2V/AU92PJjpHolc2G7+Egv4?=
 =?us-ascii?Q?yanxKo0p1w9F1C5VPKpjD9yRTPpFiyqEgxDOgfp+XbNj6odqE0CuVSKBQe6n?=
 =?us-ascii?Q?eUuSTOkdmmODpT989hh5zdpsc/67bI6Jegm3dAE+Q6Kx+jZM0lM1rDEmJED6?=
 =?us-ascii?Q?RXt0cVkGKVGWp4s/SvRa6EAvf80GEKtD+UkGQPD4X6iIRBjrJVmC6r17uGxo?=
 =?us-ascii?Q?0V4WPViGZ0uvrtgJ8zzmltXk0rGK1lQ96TxZfal8ZMKtFPIvzm5ZdtGMcvpo?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d111ed1-84c9-49f9-aa9e-08da93920f73
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:56.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +06XHSo/SdLQfTt7+n8P5XwJW4f3aZcTb2MITDuqv+Mtbx1H5DJThvbdUHBu+jxGb8sPqBzCst88+GZwYlVkZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the discussion about tracking the admin/oper state of LAG DSA
masters, we have the problem here that struct dsa_port *cpu_dp caches a
single pair of orig_ethtool_ops and netdev_ops pointers.

So if we call dsa_master_setup(bond0, cpu_dp) where cpu_dp is also the
dev->dsa_ptr of one of the physical DSA masters, we'd effectively
overwrite what we cached from that physical netdev with what replaced
from the bonding interface.

We don't need DSA ethtool stats on the bonding interface when used as
DSA master, it's good enough to have them just on the physical DSA
masters, so suppress this logic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index fb810edc8281..99d773b24223 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -226,6 +226,9 @@ static int dsa_master_ethtool_setup(struct net_device *dev)
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct ethtool_ops *ops;
 
+	if (netif_is_lag_master(dev))
+		return 0;
+
 	ops = devm_kzalloc(ds->dev, sizeof(*ops), GFP_KERNEL);
 	if (!ops)
 		return -ENOMEM;
@@ -250,6 +253,9 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 
+	if (netif_is_lag_master(dev))
+		return;
+
 	dev->ethtool_ops = cpu_dp->orig_ethtool_ops;
 	cpu_dp->orig_ethtool_ops = NULL;
 }
@@ -257,6 +263,9 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 static void dsa_netdev_ops_set(struct net_device *dev,
 			       const struct dsa_netdevice_ops *ops)
 {
+	if (netif_is_lag_master(dev))
+		return;
+
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
-- 
2.34.1

