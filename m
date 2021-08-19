Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075D23F1E5A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhHSQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:50:58 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:55457
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229642AbhHSQuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:50:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaMVkv7rNLUqy1BfDPdXRhGf9aVG5XYv/pQwCpB+dZ2ap/Afo5rHUzJUiqHyIesZf/SJ6q4PO4RnvQdpUfmixd9FQr8JJGPIDYDGYu+K6KbOiYTYXMg9IR0/Zc/Faimk4lPZPRY4/fYQcTq0z6Zvjkt8VNuw6+ukFPsvCozJVZw40+wM5U/JflzH1NkqDdgqOLzfrJnWB3SUAmA4wSy2ddTBaYoBnnApJ5p0fnTqhwmmYMI00XITk/IXMhuaA66dkzuRZwHkFoAcPdg1rEFYqJVnLBrkcLAFjzyFKn8oLSAfZGTl1T4zbPF56xgiVWsJ98DJEI/Rp3hJ2/Q7DZ7XiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPnr8KaO1KAvSsG5ccoEfMiakUhO0PKHjFRzWLQxktw=;
 b=ZB3mYwP7TdJg+9TkYh8IFeGtn9HNrpD6bZ4GWvVu5RDPoR4j5jlq2i8nftliQNCqX2DWA3/d0+SyWYm9nG1ZeKF99xFxJ6MC+fbDSpgr+h+snzkP/ZWgq1ZT9uh9nKsulruVEXKA8vTOkkrAJZdAgxoCy78ZmhEmV1tmG06nCQF2SUbQRrxxAVxgteNgwnFG0JDrxTMW/v5l/GwTVBE811fMuO9OMn4OV/sMRk2lS91EWbTpotamXEtkCrVjpFTwGGeJuWN0xS1f0k1b8D0wM2FyWA8sw6z4tcu7cx7M3Wr/XvJISG5jW89zdJujknr9GIoPxfH8ern/F2f5kHcnVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPnr8KaO1KAvSsG5ccoEfMiakUhO0PKHjFRzWLQxktw=;
 b=ZgmuwU+QyLoFhFlG4CcyiBTa+baDQDLp5DvrMKdqDWFl8EPe8Cqzb8kSYSB/BCG5/6AKoIFq7vACer6U1Ocjo7PfOOQI79Ej+u/BEygN8HH8qdlgPczBURtnBw3mrxIW3P3FZTKm1+/4LOL2BPvzg16CXNdL/WUGW+FWw5LzkmY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.24; Thu, 19 Aug
 2021 16:50:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:50:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 2/2] net: mscc: ocelot: allow probing to continue with ports that fail to register
Date:   Thu, 19 Aug 2021 19:49:58 +0300
Message-Id: <20210819164958.2244855-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
References: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0009.eurprd02.prod.outlook.com (2603:10a6:208:3e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e0ae91b-354b-4849-f9d5-08d963316ae6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5133E81140EE425610D85329E0C09@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZcvMjSti5aqW+lviqEzYAOqGXPCwRvJe/udoCc+qdAKizXKm8csy9CiLJuHbZ5kPq1F8jvBb3Li3XmxeVfHVmwJ83Wr0LRsJFDsC06/GbwwN4aJvQil4OyOyt8MddKxeRBeZb9GD7AZNOSPAkakT4swCpNZnEQOw2b3ww83qRaRfUqvV4sGbMFLLu+HT6Q9TjTfPXy84t05qPHcAJ4lxNigIMftJ1tHulBMxcu0ptyzRvn3dmGYYqjlyNzr6GMjFk2KeMt2/fcO04Cm9OUNF+swkX25Aq7CU5IogbphjsuPcrRQVGzy15NWOT7mJoyuSNYB6U3K/XLLVMQ4NJ1FYYMsrvw9DVhIqAzZSXB14I2IT0FB+wJVXYxZ6TnEwprKg6nh25jBDl0d19hfbzr0CBB55gS18DmLEIaVHqI5RUyQTsrf3KrhgF9mzKMPQ3v2BkKdyawCgt4znB6XGBPw3kttgS8lQpxZUC7VKS4wctu2PaoZTBR60/7mtMuJC7b/4ExoL9ff2Z8KelR9waEYnMtcI1Imtiis2uJTRkbj5BT8+M6zHJqrWuu61fxRumJLdWieP6Lhnc2zeOY8adhPPCQEjJ4EEEAT7/aHq+kD5Tey8UaBs8yg3lf5/pTSwyDOrV5KvDesQFVzlItvIfyrL1Yrc+lUGENE1NCaF3r0zcyQtVA/w0kP8OV9AGsZ3nSwTkxx2rUE1iPqx3ruYRMCYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(83380400001)(316002)(8676002)(54906003)(5660300002)(2616005)(956004)(4326008)(86362001)(110136005)(66476007)(6506007)(6512007)(2906002)(6666004)(52116002)(44832011)(66946007)(6486002)(1076003)(36756003)(186003)(26005)(38350700002)(38100700002)(66556008)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VIIhlmMB/xO2h+hrb2BTWD66/HovpaP6XiWsUynpG3PuH+sjV42+LILd7pCj?=
 =?us-ascii?Q?SgUrFHBjQIhOAh0yTEFKUzFafIlVSlGEqfCoa0tja12+oO8RX1/dlmkToiIW?=
 =?us-ascii?Q?hS2UMLBzZYEk2TxV2EKf3HpfIfuvjUCHAywHGj0qnNCzTQGnvj5SM3AAT8rH?=
 =?us-ascii?Q?zWtFpHyAmrfESMuHHqa6afNgMuaA6HettIZP30yr0Azg5a78uZbCLyW11p2z?=
 =?us-ascii?Q?ZeUN8dkTVKVpuhy9m3ToEeTkjo0rJzrIsqWsCiDl717lUcG//DJ5CO9i0vmN?=
 =?us-ascii?Q?Ad4fygNKZ2ommWkgiJNg3C5a0m/hf/iTRYPoC3svxB6E+Qew1fuEgdD2qx1Q?=
 =?us-ascii?Q?yTugSPnky6AK+zZ+t9QtP/2RBq+K4d/ZqA+mOrE6vnGte8dD+XS7JlG9xsyS?=
 =?us-ascii?Q?rbY7iXDFBeujoQ4qiazSPUQ9c6oBdreYYM5vdltrP2kRvajMfLg0ULJJUIo+?=
 =?us-ascii?Q?3zkE05GQtKKphaj76yCUOcEJ+aTogtVq2xK8IWjt6eQpuScCp2EFB9xY8fyX?=
 =?us-ascii?Q?1SaEhLFF4yttHUUVrP7a0/rqxYXv00N2ocXLGPp57kI3RCbu/rAQ9ND1usQl?=
 =?us-ascii?Q?gcp/MTcTOy8ERysaFHfUlKVh/TptjLC9h2nQrjRN2bj32L9TTlMca8u2xKAG?=
 =?us-ascii?Q?7M3Sj4vnj57qAMz5sx91mYF/4O0SHn7vPBJsSUiiiK10/yRrBhI/y3zlp2Md?=
 =?us-ascii?Q?CPXGEUPO3GaeYBvO2uVm6axnp+pP/FfHsUzezhBlzuNmU5BLAfjEgGBtg6Lb?=
 =?us-ascii?Q?m9WfPl2pV7KtuctIHE/43jmUAjnQPXtm8nk0c5hNoNWfJoP8ccjN4LPZ/m9s?=
 =?us-ascii?Q?7W/M+DV7r+3yrShjOVAPptVMqoQRfjaUj3RIpCdWNt/uMeFzlrfWDQ6kHUGp?=
 =?us-ascii?Q?Vkt06kredSfBMBA41mDzKa5YsA1A9YvkKxHl1HaxnL1/EjeCbBjQw7t0OR7k?=
 =?us-ascii?Q?EKW9GD5cYykeMjWH8VgJY6YdIJhplURRxq/q0GN+K2Okfb6PU1oGv81JJ70f?=
 =?us-ascii?Q?j+ngDOFND+VNP46ttaQxboxvkX4aTWqYJaQmaYrJoqkc7HhdovLJTXadbL9d?=
 =?us-ascii?Q?fDk3Rb7y7ozWW+4aCznn/60KLHyzANVt4U2AQ1VrDlCnVGGz9NcFh32CfVFf?=
 =?us-ascii?Q?qyHTog8c9nwW0JksLeZhMCdoaUrOh7VgDlfZmRAScgfOQsBNgdkShofqS45F?=
 =?us-ascii?Q?W3uVdYt3lqQFo4smxjOnruDNXcTTUd4vP/ZRwnc1lT3ICuwZJ2S3AYlp/dWw?=
 =?us-ascii?Q?UQXq/P22RpKNHdvv5Lhpv04FvZB60LNnYJaDje+Zr4JtCzhEV7TKHnLqzJCe?=
 =?us-ascii?Q?Tbd8wlNyCaw6TWoo8EbkGcau?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0ae91b-354b-4849-f9d5-08d963316ae6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:50:14.9144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGp774mB+e/cLJMArZXDHojcMpTHnK6xNHxyf1VZ7/EfG5hket8PBKJG8yTLp1uD+KqNzjpPXaShEdYJ8OZEuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing ocelot device trees, like ocelot_pcb123.dts for example,
have SERDES ports (ports 4 and higher) that do not have status = "disabled";
but on the other hand do not have a phy-handle or a fixed-link either.

So from the perspective of phylink, they have broken DT bindings.

Since the blamed commit, probing for the entire switch will fail when
such a device tree binding is encountered on a port. There used to be
this piece of code which skipped ports without a phy-handle:

	phy_node = of_parse_phandle(portnp, "phy-handle", 0);
	if (!phy_node)
		continue;

but now it is gone.

Anyway, fixed-link setups are a thing which should work out of the box
with phylink, so it would not be in the best interest of the driver to
add that check back.

Instead, let's look at what other drivers do. Since commit 86f8b1c01a0a
("net: dsa: Do not make user port errors fatal"), DSA continues after a
switch port fails to register, and works only with the ports that
succeeded.

We can achieve the same behavior in ocelot by unregistering the devlink
port for ports where ocelot_port_phylink_create() failed (called via
ocelot_probe_port), and clear the bit in devlink_ports_registered for
that port. This will make the next iteration reconsider the port that
failed to probe as an unused port, and re-register a devlink port of
type UNUSED for it. No other cleanup should need to be performed, since
ocelot_probe_port() should be self-contained when it fails.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Reported-and-tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index f553eb871087..bfb540591c1f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -978,14 +978,15 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			of_node_put(portnp);
 			goto out_teardown;
 		}
-		devlink_ports_registered |= BIT(port);
 
 		err = ocelot_probe_port(ocelot, port, target, portnp);
 		if (err) {
-			of_node_put(portnp);
-			goto out_teardown;
+			ocelot_port_devlink_teardown(ocelot, port);
+			continue;
 		}
 
+		devlink_ports_registered |= BIT(port);
+
 		ocelot_port = ocelot->ports[port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
-- 
2.25.1

