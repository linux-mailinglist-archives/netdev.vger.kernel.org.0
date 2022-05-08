Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19C51EF54
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiEHTG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382591AbiEHS57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407DBA1B1;
        Sun,  8 May 2022 11:54:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmSCxyH6SAKFowbNHvTzujO3kOpPdQ97h1LQBMubWaLJu6zSYJOXMF1ZBm0mouSbA6huUJZ9iBGKlHdBacUcqMBhtDrRKADACbt0uLj82ETz6gYGzMkNE+2W9i0sXCtiVyvNvcfkqUuG0xSfB8n2AhabL8niuK8VpmN0+ckPyXmcjEmfMtjhXp1D2+3+DnIuvCV+1h/PdXoz3dg8GNYzjG32U72ojxTZczBQQvq/RrEGtHypbi0ciCy4CZhI2HSWNJ1BxQvO2FdPgWwc7XDyxCzJLMVfST3daX5h8fOOzMNcc9DtuKdQ5vF1yN2aG9/6RIJexOcMj0uGF3psW5Y07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCWAhC6QRoHQ/yJ+qJzgN3nd8Njt4/Dh5tMExpj7Ch0=;
 b=G+iHqWmc5DuYFloPeIfFJVCw/jutPj0eTdY8Rv+9q3McsbJLmWBLBgaT/rQkv1l8zSM7Fsfi3Y33SdccaYUKVSG54gK8dvzlQ+i62fib+0EwLpHXeIYHWPkCdsWX7ImazLvkXQDrqhmXDrMS1LpUzOK5ShojNx7zLclXhus18Pk/InPDbBmBf50OKxJG5XQKHSE3O2I3eLzQbxqvl7qO8ZGBQKYuzSS1FUVMYe2G7QQkfH4n2eb9gbPEkROJytzn/aR01rg2zHzIIs2jgxqLQfxuw7GJNshU0q+bKfb1s/2jHLb9RN0Cq6usczqv+Csed1A3RyGQxLe1g6YpBRjrHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCWAhC6QRoHQ/yJ+qJzgN3nd8Njt4/Dh5tMExpj7Ch0=;
 b=VFsgmw+mObROryC2WCfhLBxXTz1SFJeHNQ6tqHnDgJXkHGL0QOyNpvC2hYxA8EfrPBPNG93p00L07FvboHCSG6qHBeBVVIOhh8lkAdi7oPaVxCi3y7srcWtJS/x0jk3cqHzm/DCI3vTHGSgXm1ltpRuktWB88QuKE6zayDHblV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:54:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:54:06 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 16/16] net: dsa: ocelot: utilize phylink_generic_validate
Date:   Sun,  8 May 2022 11:53:13 -0700
Message-Id: <20220508185313.2222956-17-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa5037e0-1617-4e36-3660-08da312420d4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB567217381F71BBB1DD1910E2A4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ma2jcAIxKTs+pGDH12EmsuFa0XWhrlEuSKsTyNCFRh1zSyBacMIQozDXGUdTv4sYJ0Ujw1rHakX1m9zmT9TzEL/sD3dx0TSYTmNRnYg0zX7l242z4/tLMTt/g/ph2zdosUfDIes8nr9ks6N09JJbSUkOKDQM46iMCLTopHeMhLjdeVt+WQ3/p4cYe1V46TD2VLf8pz2OHTsyKkgz0uzY6QmfKlwGKZplGFgRxbRJMrvaZM2XKoYC9tSNJb50983YWDkbpNy1f5CaACDgNQ8eWhfi23oMwlcYsne38XL/kH5jI43UMvr6NuP2a48LhhCDMlD9WM0oeQQmIcIcwH7gQlbZORgonMKMQDK29QwO8hiPakC2XpdGC/lbocCprqTHJkA86DGNMe8PWDyb+A6rWp7nrjJMUjCVN265Tuz/bh2Id3IfI/gxKHBDCyhpp7PCCJDfPvC0Hzt69Wc++NQ/+qD4OH1oPnNmElSzDrvCnK5HK2fvuf4bx/krm4bkR/YyfNzEwidvkgQ6ZJ7pBax+hIidhQ8Js4WlLQiKDNhIl9gyHbzvE1gxZKOyZW2djWpyzLDl/yHECuK3QvgdJmZMImHW40G051kCCUvLH10hqoRSRgFnyGDEMPxfVUG6G56Anxa/HGKQsgu6yO+2y9CdFOwdJCUueAySsaiDdxLJh/iKbTJmMazqUo3hmB11GeySS6M6BHexFjqm+QIep+C2vMv8GIwZC8mQj8ZN9lnPnMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJnnNJ8n1EVk0hU37BRH0t8EpYvtCtkWkFe7I0RsCtCxB7NqqerZgqhIEPKV?=
 =?us-ascii?Q?Gr87zkZvWaLX13+7w5XWlTO7RJoZhFnm6kgkI9c4VJfEe5AiJuBFO1qZ3sk9?=
 =?us-ascii?Q?NuM8bm5N+oPtTuEKwevWdAnBEIotyU17m9c1JNM+vLglLQHOHS9kJUc8yES4?=
 =?us-ascii?Q?D63sUst7s0HozkM2zr+LwJCFy72WtNMzD4YR0JKosriPRzLmkqlhqHx30+uD?=
 =?us-ascii?Q?RQxI9lUAbcH6eB0OLpVGq2FTANlhDdFxQS4Fl12bKflWAcnqw1oCLeJWBRf0?=
 =?us-ascii?Q?QjdJKwqpD7Et8/HmHVNxiBcXfgCOaOFNllcN+bnoHglUAzkmR54lXcViLa2T?=
 =?us-ascii?Q?z160/b1no8adymRIDzJ1b8i8drYYTTu/1y+FhM2xs/rtw/2tY5xzVf2Tcxkz?=
 =?us-ascii?Q?+o8Q9wxgl2kFtkkvljnCc4/JEnDHQhbn9aSs04phnk8nC9LiiXiy4QdHQUiF?=
 =?us-ascii?Q?LN7TVMCv10/Ok9DrIImvPVyn8facIaddlnmgiX+2yuDdpU4hQQIzkmOQPjTh?=
 =?us-ascii?Q?bAzRU0GNDQelcdzbdhb+qHnhCYUiouBiUeNm+ckSVQWr5xQvpWHGH+BJtM3U?=
 =?us-ascii?Q?j4a1g0eJZqqtPsF1f4tny54t3viLKGJv3TxGEDnlviKY726OpUgrHY00xPi2?=
 =?us-ascii?Q?I9pRlJzVj5CgS1uDUMPSGnXHp/QHTwAVB0XxYAYyn/e4bxzKZD1Ry0cYvLpg?=
 =?us-ascii?Q?tfgXgQKBjqBoBH3o+3yKOsD4a/4zqYyWKx5hlD/sHQVWfTdATIvrTFP4qW2z?=
 =?us-ascii?Q?IEywWgoWDm7QYQoBlGSSsQ0ITa890aV4Rk212rfoVIUPzYm2laeuULsPC+JQ?=
 =?us-ascii?Q?xwaA2IfiM1dgKXkpaXhQ3zFKoNxR0RD0I15aPQYkdjQc1WCbftxnN23UwQUw?=
 =?us-ascii?Q?68fyXSCDESapmwhepNUva3qoVfx2V2Jj0IJMhyuwqnhBga3SjhFTkewUf7UN?=
 =?us-ascii?Q?N9HGZC+W4KbTC8KVbWev/+IH8kAZ4hMrS8IWp0qcCt3i9r0w7YjtdpLHrcmL?=
 =?us-ascii?Q?sdAVLGIVo+1+RhMjujR+2CB/+Qiia/uBn+8V6UhwoBX4HLyncPuInm5BPi0L?=
 =?us-ascii?Q?plDtRN8i7gYXw7m56JsJQ859DVYwY0zFtupzZTPVfrpGEoUx+APEtlXnWAtY?=
 =?us-ascii?Q?B+5z1c6bWMLe+zaZEKYCT1u4ZaE2k6z9R+RoSuAt+Aeei5SwnprKzMrguGg7?=
 =?us-ascii?Q?ngL2Ve18UIpO/xvsNpCuGe1kX/V4BZHwl6Fhm/BMUr4/Q/gx8vNJIuPT34pL?=
 =?us-ascii?Q?ZMFEWXWhPn1CmRQ+sz9tUWF8AoiRQXNvhX5EGSUrY+5OKm3K3+BECb2AXJGQ?=
 =?us-ascii?Q?Emoy0PpVedHx8KKLQODpSCVA74oqDfHDmUABBg3xW6i92ABptzjpoHh5HA0b?=
 =?us-ascii?Q?lSiNPu5TIs+EE+uuvkj5gKJpuBNMmnlKf2SmuuM8uMmohRKzoUwJBdD5iinq?=
 =?us-ascii?Q?7IQhHUOCQBRf0Oo90jm+JABwqnm/NF66/0zpUcg04nE5Pr4GMdPpBMcaK6+O?=
 =?us-ascii?Q?h7y9kSxBYR5+WhhQL3YtxyRn+w3SRLd2LSf5ivb/I1/G2o6hQdBSyJOaaJ9+?=
 =?us-ascii?Q?369xXd5HGgymYAAqWsqa8RqcR9aMp7NH29na8my1J662e2Xjs9R56+HKEQIg?=
 =?us-ascii?Q?0rKELhyvuFbUjPHW2M3ER1ASyOkD0HIQoZS85U0AaKUgIji/z7tCMyqV+U+M?=
 =?us-ascii?Q?pNYxaGEXsc+j8l0yDtT+34ZfrG/h2XOAOaK2H9N2oDIWcnplJoZd7yFnmd4c?=
 =?us-ascii?Q?H00t88tWqyhhqpqJawzBcLwPhjV8yvfS141KMCEWhX7xTJd66oHZ?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5037e0-1617-4e36-3660-08da312420d4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:54:06.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jS3wv6iAeli+5bj+77iTvoc6MpckfMVri4IsKjYRtj7GArX7LqVmlbh9gTv8mcMOUpyjkBBv3L7V5Ah1R/LQYfObEXJS3KTrlvOKRLefuQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the phylink_generic_validate function to validate port interfaces
and speeds.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/ocelot_ext.c | 42 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index ba924f6b8d12..21a85e95c217 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -215,31 +215,28 @@ static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
 					unsigned long *supported,
 					struct phylink_link_state *state)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	struct phylink_config *pl_config;
+	struct dsa_port *dp;
 
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	dp = dsa_to_port(ds, port);
+	pl_config = &dp->pl_config;
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
+	phylink_generic_validate(pl_config, supported, state);
+}
+
+static void ocelot_ext_phylink_get_caps(struct ocelot *ocelot, int port,
+					struct phylink_config *pl_config)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->port_modes[port] & OCELOT_PORT_MODE_INTERNAL)
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  pl_config->supported_interfaces);
 
-	phylink_set_port_modes(mask);
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	pl_config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
+				      MAC_100 | MAC_1000FD;
 }
 
 static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
@@ -262,6 +259,7 @@ static const struct felix_info vsc7512_info = {
 	.phylink_validate		= ocelot_ext_phylink_validate,
 	.port_modes			= vsc7512_port_modes,
 	.init_regmap			= ocelot_ext_regmap_init,
+	.phylink_get_caps		= ocelot_ext_phylink_get_caps,
 };
 
 static int ocelot_ext_probe(struct platform_device *pdev)
-- 
2.25.1

