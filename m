Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E4F63C230
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiK2OOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiK2ONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:37 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBA56204D;
        Tue, 29 Nov 2022 06:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZPevIPJcUFUmzb6YIuOrgeGxBxKvpZQqOXXCKvaCa0XtZUMWj3eCSp3KNxAjZG1RG3T9Ezhj3oowBxoAHLb8lMlmlQr4IyvnsmG1zDfCFedtwYIo42MtKzq72BHzFkT18bwzXNbGtxh+Kge8xjlUroxluAhwCVDqCvu2uLDLdFNjAudAKfZ5Sjnx/V8iH8e5ly5MpcSMIWK/dNYOAXiHU08QB7YO32UpkqNYJLk14WTpWXSKz4QPG+u45hzcKtQXTXvVsQWh/7qjYqBT8BTgmVO5+5ySib38Rb6/V8xgKAFBFwxhhX9WuGtcCV5Vn1nHApBF5T0GBkTCW53nlQRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJ/jt7Mm97BZYBWJAmBVw0WtcNQ5mi3mBhavRRfv6PA=;
 b=Ti5YKVL4vMXx/gsqmHX0A/Ii2CsSEDbwJOzCGNYZ4c4zEWxipUfNEbZ+MkFL6Jf0/7d4QNbakWb6YBP4zYDFyRBhBtCSu8uQYY+KDJFfedZHCi6x8Ckg7Fg0ca99Mjt5v3AKPhMsgBjnF0MSO5YfaTw27z65QlmvHG0MHXn2bzrsfO07HtWP38hDxbiktnF6iZpiopNTkvMcUkrQ+6NB+AWCLtml7PfyCCc8UPVjzCjhcyvOp50RrL47c9yvWQKxLEZ9gMr4IvNHKbs94BkSNdNzww4SzXC5RqXHrfKsLNFEWFSYb/hVK8xHQDqnX3aXYtD+fjLMCq+Qkb1W5Oh3zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJ/jt7Mm97BZYBWJAmBVw0WtcNQ5mi3mBhavRRfv6PA=;
 b=MyIHNM9Hkez9XBygxWbmbnhMDcrwwEZ3wy/mOyt3BLVeUe38jTrVJmVbCChO+Wn70Tc7bf2WRq+lQiNCfmIO87OIj9xLn/iZLHql24MpkQ7kYIqkNMUNO99vd7IAs09f7hJIKQR/5r2AVCYRSTYe10DzdacZhm/fLIAiCOqntfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/12] net: dpaa2-switch: serialize changes to priv->mac with a mutex
Date:   Tue, 29 Nov 2022 16:12:20 +0200
Message-Id: <20221129141221.872653-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 85db525f-a338-454e-c933-08dad213c736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPouyqnKQkCqtKQvEc7AaC/7w7lF4yMV5TMZKlBFokH/9skmJTnkj7JaFuc/vQo2yFMqaZa7U1RtoyIkqtLw3JpUuPnS04EjYB2V6rrPWy7RVx1YZK4X2FjxpqRTds7dPYmFJNoNzPjZi/7fJPQfUpaNbc2kZRO5xe1GhirX+C9QbrDEYuadJJsaxzab6Dls/TPgC6gK9/DDWO3gngyMlS2/mmxS1YGxpPNn66TqfrQUIPO8JtRadnTjSR6n/IlqnnP3pxZe+HYmjQUA1wKS8ZbTdhCFvcb/uroLq6SqtAPzknB+wBBvxD3p/B65IZ6X03Jti6XUzeLtPdyaXJr1iRyjgNXrufy+Oqe7yTZWff71UOlU/81ljOuhywNlMk+TyAMYVw00lNXXz6KZ+y54IXtaPBWnuTM+KljDpi7lAqX/Ui7jTHz1a7TkvfQcncUnT3KaJebO1HrcW9Nk0/LrHrUX4iCi/DXYEEvSscbKbzdieeDyVryDtpEHXle+wf+gSJ3EuDUXx9MmEaHQQr2V97YOust7sFactEIMgZOxPWuEGkmIsyTcYG9ulNH/W8qxxrbA2VxqmbjASIPNw67q3oq1StMYD+Bbedu2kI3F7ueMZRGRbsx1kWEejq19hjApcVqDmBk20KwFwiORfHd7dqHgyGeMBE5AbciOKgmQH9ycR71R1p2CnBR6FWM2/bnK7CHFtrowoNk4U4nP8G3VdWZH63doCxa9baJ4fTkpTz0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r04gQeWFTjJhbHEJPUYPoLmEcNp1Ch8kB5SdFGev9sRbrHPAjhuN6Gfa4fVv?=
 =?us-ascii?Q?O603KHLwUyyGy2v4Y0Ck+CQSImATqP7cW7dNGuy7Pv1IRcoGgj6L+0kH+Tzf?=
 =?us-ascii?Q?z350DJHaktChIMKPsyJ7h8fSJtVuRJQ1sP5+PfCLt9Bgp81hi4qlhrN2YQIW?=
 =?us-ascii?Q?ztKgYB21/rrr0OLf5djYBBbvymeO5jTUlBDBtQMlbnc6XA1jdb52t/tUJMck?=
 =?us-ascii?Q?7cfsi0x2HK7PSPu6WiOltqP6zrP4raPlJSiH2Z524K5wBgq6wu1PdCPxjp22?=
 =?us-ascii?Q?6vOQf5tC98D3hnScZU10VJ6Gdp+BHG5mEv3rtQHOLijf3i8yXv6wN2sbIHM5?=
 =?us-ascii?Q?nOsxebSRp/nM2KpVnsMnojHYAku6fOhdlGEDl9t9EfOTR3AaEg5yDCKt2/Rb?=
 =?us-ascii?Q?gA5Neb9ZghvK4cphEWZW9I6jP2EalMibBOXXftLzc6ovdgmclohVve3/+1O3?=
 =?us-ascii?Q?6MCWPMC/uARer0tJXnJTvkaAgeohgqX4d1vWx/DcOq8i1MndfGPKJFE0Kv7Z?=
 =?us-ascii?Q?EsQYUTpOEtMIGp2v2M6QdbhO16hY7uwBTV0smuwZ59mQBrFIfY9exyKgXmq8?=
 =?us-ascii?Q?3JcH3CfDsZs6gmaAD8n1EHKAaSNqFAFwH8xSMRcnimWRjG1ZSpkneBXkV8Na?=
 =?us-ascii?Q?NVmu4+yDdIg+xogRLmRvEvgg0kXlboOFkWzwM0u77b7tkcGOUwi8+09OLJuy?=
 =?us-ascii?Q?Sa5r5EWG0i4UZ2rhQ/DfxI5vKwkdJmmCL0WVo7D9hOV78MtITx5XnPpPCl99?=
 =?us-ascii?Q?cNM6x+sIacOAk2EYhY97SF7+dOc8FpQH9YChKWm3KXW/7R62TIF9YYzYl5qS?=
 =?us-ascii?Q?6HYYzld0R3UA5eZ9y0ONwGQL9/9//eJhBGvcLwMCDMINVf2hiPOgwbn4Ikqs?=
 =?us-ascii?Q?bhhb9KyzAbWErQVs3lvIHEWaGYs78W68TgVpQB3yhapBIxW//tM1V3UAhOlO?=
 =?us-ascii?Q?rcWjQjH5l8Mj+jVG5Dl5LJmFEyGVytQrBIIx7vIvQiEB67ykRdInZsT/oCah?=
 =?us-ascii?Q?wHhlUofc5pB3DIrZzJ8XFNaKjnJn7cmcxT+oU2LXZdOjb8AgD68QBsmw/oPH?=
 =?us-ascii?Q?6FMuvZHGigPz/ruddXEX4RpSsPVAZmpLxk1kiF4Ml5zYAGXx/fhrhMDDV5Vk?=
 =?us-ascii?Q?/IHzSAWv9yyYlgMRcXZMxmtxTel5lJeO/BN4H6b7IeOr16RY7DKywXT1TJkM?=
 =?us-ascii?Q?cMxrEjoAB+FWlROYM8f61K0FVFSuaFz4uwmsaMb5DtfkII2MIZzD5KVrJlMy?=
 =?us-ascii?Q?Xp/kevRX6O2qHXEMm5DpFVJFRb/379EoR2CBefOltNniu1bXhcDgtbcOkafp?=
 =?us-ascii?Q?13/f7P1s4jUp4AaeVMzDH62f1PAkp+KWhdMkmMS9zXdQgTkrAaAXlmubo6Jh?=
 =?us-ascii?Q?6t5gqALPSTQtMSQ++V5YY9kgRNYjpE4wOh3fvxlflkUAjcgGwLFNvxSmhl+C?=
 =?us-ascii?Q?kVVwH26LOTYnMOXKl3OIrRiHgc2go6VbpGYAz4QkOADhDIx800pb8DTtbgO8?=
 =?us-ascii?Q?ga1+6kfazr8oGPlOLurVuABJIl3mwNOw/N9z2BZgdWg5/YwFQ7Qx3C7u3kwD?=
 =?us-ascii?Q?S0+huACs/gdAFL0EBOFKM6vaCDhe7XI8yUtAgAwIMFtMxRX6XYhpZldDdqWL?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85db525f-a338-454e-c933-08dad213c736
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:41.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGWDX1pXTflaRFji6oCsldaunp7sEFWcIp9cQXz63NcfjUuqNQI9GLPxne+weFV9AX6fo8KbjXQlfe/cePAx9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-switch driver uses a DPMAC in the same way as the dpaa2-eth
driver, so we need to duplicate the locking solution established by the
previous change to the switch driver as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 32 +++++++++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 31 ++++++++++++++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  2 ++
 3 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 76a4b09e2854..6bc1988be311 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -60,11 +60,18 @@ dpaa2_switch_get_link_ksettings(struct net_device *netdev,
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct dpsw_link_state state = {0};
-	int err = 0;
+	int err;
+
+	mutex_lock(&port_priv->mac_lock);
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
-		return phylink_ethtool_ksettings_get(port_priv->mac->phylink,
-						     link_ksettings);
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		err = phylink_ethtool_ksettings_get(port_priv->mac->phylink,
+						    link_ksettings);
+		mutex_unlock(&port_priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&port_priv->mac_lock);
 
 	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
 				     port_priv->ethsw_data->dpsw_handle,
@@ -99,9 +106,16 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 	bool if_running;
 	int err = 0, ret;
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
-		return phylink_ethtool_ksettings_set(port_priv->mac->phylink,
-						     link_ksettings);
+	mutex_lock(&port_priv->mac_lock);
+
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		err = phylink_ethtool_ksettings_set(port_priv->mac->phylink,
+						    link_ksettings);
+		mutex_unlock(&port_priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&port_priv->mac_lock);
 
 	/* Interface needs to be down to change link settings */
 	if_running = netif_running(netdev);
@@ -189,8 +203,12 @@ static void dpaa2_switch_ethtool_get_stats(struct net_device *netdev,
 				   dpaa2_switch_ethtool_counters[i].name, err);
 	}
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (dpaa2_switch_port_has_mac(port_priv))
 		dpaa2_mac_get_ethtool_stats(port_priv->mac, data + i);
+
+	mutex_unlock(&port_priv->mac_lock);
 }
 
 const struct ethtool_ops dpaa2_switch_port_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 3b0963d95f67..0472e24191ad 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -602,8 +602,11 @@ static int dpaa2_switch_port_link_state_update(struct net_device *netdev)
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
+	 * We can avoid locking because we are called from the "link changed"
+	 * IRQ handler, which is the same as the "endpoint changed" IRQ handler
+	 * (the writer to port_priv->mac), so we cannot race with it.
 	 */
-	if (dpaa2_switch_port_is_type_phy(port_priv))
+	if (dpaa2_mac_is_type_phy(port_priv->mac))
 		return 0;
 
 	/* Interrupts are received even though no one issued an 'ifconfig up'
@@ -683,6 +686,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (!dpaa2_switch_port_is_type_phy(port_priv)) {
 		/* Explicitly set carrier off, otherwise
 		 * netif_carrier_ok() will return true and cause 'ip link show'
@@ -696,6 +701,7 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 			     port_priv->ethsw_data->dpsw_handle,
 			     port_priv->idx);
 	if (err) {
+		mutex_unlock(&port_priv->mac_lock);
 		netdev_err(netdev, "dpsw_if_enable err %d\n", err);
 		return err;
 	}
@@ -705,6 +711,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	if (dpaa2_switch_port_is_type_phy(port_priv))
 		dpaa2_mac_start(port_priv->mac);
 
+	mutex_unlock(&port_priv->mac_lock);
+
 	return 0;
 }
 
@@ -714,6 +722,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (dpaa2_switch_port_is_type_phy(port_priv)) {
 		dpaa2_mac_stop(port_priv->mac);
 	} else {
@@ -721,6 +731,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 		netif_carrier_off(netdev);
 	}
 
+	mutex_unlock(&port_priv->mac_lock);
+
 	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
 			      port_priv->ethsw_data->dpsw_handle,
 			      port_priv->idx);
@@ -1460,7 +1472,9 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 		}
 	}
 
+	mutex_lock(&port_priv->mac_lock);
 	port_priv->mac = mac;
+	mutex_unlock(&port_priv->mac_lock);
 
 	return 0;
 
@@ -1473,9 +1487,12 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 
 static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 {
-	struct dpaa2_mac *mac = port_priv->mac;
+	struct dpaa2_mac *mac;
 
+	mutex_lock(&port_priv->mac_lock);
+	mac = port_priv->mac;
 	port_priv->mac = NULL;
+	mutex_unlock(&port_priv->mac_lock);
 
 	if (!mac)
 		return;
@@ -1494,6 +1511,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	struct ethsw_port_priv *port_priv;
 	u32 status = ~0;
 	int err, if_id;
+	bool had_mac;
 
 	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				  DPSW_IRQ_INDEX_IF, &status);
@@ -1512,7 +1530,12 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 
 	if (status & DPSW_IRQ_EVENT_ENDPOINT_CHANGED) {
 		rtnl_lock();
-		if (dpaa2_switch_port_has_mac(port_priv))
+		/* We can avoid locking because the "endpoint changed" IRQ
+		 * handler is the only one who changes priv->mac at runtime,
+		 * so we are not racing with anyone.
+		 */
+		had_mac = !!port_priv->mac;
+		if (had_mac)
 			dpaa2_switch_port_disconnect_mac(port_priv);
 		else
 			dpaa2_switch_port_connect_mac(port_priv);
@@ -3255,6 +3278,8 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_priv->netdev = port_netdev;
 	port_priv->ethsw_data = ethsw;
 
+	mutex_init(&port_priv->mac_lock);
+
 	port_priv->idx = port_idx;
 	port_priv->stp_state = BR_STATE_FORWARDING;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 9898073abe01..42b3ca73f55d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -161,6 +161,8 @@ struct ethsw_port_priv {
 
 	struct dpaa2_switch_filter_block *filter_block;
 	struct dpaa2_mac	*mac;
+	/* Protects against changes to port_priv->mac */
+	struct mutex		mac_lock;
 };
 
 /* Switch data */
-- 
2.34.1

