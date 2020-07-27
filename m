Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9FD22EAC4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgG0LGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:53 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:15790
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728583AbgG0LGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:06:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5l7E11jBA43HHwlN449Xk6pzz1QxqNjUE1C9u5Oz9ReOoJpUZYCGWO4sLMWGZ4/44VzirI3ZOkPV7DDtblbES4qbraqbDLNz0cTHIvlP0UoEGAPHkrudCC9lX2Xb59LfGf2vXTF5T6+3vEbik0Pt/6AT4AjMs3vHOYIZUSFSxGnprvUsUSqW/ScF9fnGIGQAAN85aHX05+GlbLVV4TAH8xtZVooIISEK24Yzn0BjTPmilLv5HBZrKRd17nBZwyT8NTaK9msK+a/NLcGxjGyPPojnChuY/eobtsjUBKysoJ2IgmfYm1s0eOhL1Hc0s6AtwiuuNnurYJWWiyL3D8Dmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w944Htg95YfE0hHG/4QqkEUSMcsGD+kPSMFL8I5s3lk=;
 b=MizY83tQkIQVZjq4B101BfDCZYH6yud6mPW35eKANhHt5BNjSVpukgVWoefS/cIrPgqJDaOjO9mEoaxYwhIkQue/d2b7b/damCn68F4eugOWuhodFHovkDdExELXmEkCcKXDDzWC58OTjWi7SwT31rZy5eWJvYddElGdk//X6P7GVQL1FTGdqsUZb0YSchJJ+4WFi2KPalH1zhZxzm8sKt1FfzGCLtpxS7haudhBBWLWa82vNIaBrmErlLXBfDqLeBt7SRYKFWZkCGsZLPCIA7BC0kjpkZGNGLbpKL/Qr5YUoPm57C8ISwruX9O1nU1rv4gYZU2rKZGePi9Ms/4PIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w944Htg95YfE0hHG/4QqkEUSMcsGD+kPSMFL8I5s3lk=;
 b=HwsMcz09e/NG4btckVAIsQDTj8jwoQ98WnLFAB6auiwF7eujQEvCn2ADE/1h9Rt31f0fn00eSiJV1sOCJ7r6ILj1+3/huPt73Xq+STLCtmnr9vhSBmFAQMMaT2pgdyOeBeruT9BjZeBfxBuhNqMB8Lp7J28rWw9D/fz3XOlyEec=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4198.namprd03.prod.outlook.com (2603:10b6:a03:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Mon, 27 Jul
 2020 11:06:47 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:06:47 +0000
Date:   Mon, 27 Jul 2020 19:03:09 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] net: stmmac: Support WOL with phy
Message-ID: <20200727190309.644912fe@xhacker.debian>
In-Reply-To: <20200727190045.36f247cc@xhacker.debian>
References: <20200727190045.36f247cc@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR01CA0012.jpnprd01.prod.outlook.com
 (2603:1096:404:a::24) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR01CA0012.jpnprd01.prod.outlook.com (2603:1096:404:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:06:44 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88ade9aa-1159-466b-4034-08d8321d273f
X-MS-TrafficTypeDiagnostic: BYAPR03MB4198:
X-Microsoft-Antispam-PRVS: <BYAPR03MB419825171EFC86C8D72CCEC6ED720@BYAPR03MB4198.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52y4KrKXRl87rC7skqdQRlPhcmR7OaSucYluUAK7BoLuEvjUHc/Ye0LP5iIJ7wFlFKlOp57x88cUbLatCq+MfJKCJvJfihDGL8kLGGRmmMoFDYVyBCG7UBAM3NNDYL5TwgpSPogZ3WFDsrY/4osNrb/QRldVVDjriH4iwmWTSxRISTyf0ivTLwmkKhnDHCnNdeT4bHALqfMK45Xn7DCVfF1VOHCrABf7VVXULJkKRn7aDT1M5MP1nKM+2XRx+1cf2YN1t95yC5OpKYV8qZ6Pcb5691zOpFuiwuz5Qb7GEELEZ3Qq96kW3zXbEQd5V9tQoTap3mnRg704QXatj8ANepM8YuXtpu2T4iP4v6hserv14qJ5wsfRGxJeItuHGxvK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(66946007)(66476007)(66556008)(5660300002)(6506007)(55016002)(86362001)(52116002)(9686003)(8676002)(478600001)(110136005)(7696005)(316002)(1076003)(4326008)(16526019)(8936002)(26005)(956004)(83380400001)(2906002)(6666004)(7416002)(186003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ri1mOHwAOFDUPsFIOIK20PTZu8bBq8ZT2JGTmhdMEVi8MpzCLsiUXFGVanpplxWn9hwX2PQhgCpPvg1hVWHvnuL5qVyDPOte0egti2FcarZUVp+YJCdSTL++E/r2LuyrubAtlMVLfzXamh9i3zQbG5u+Px7qTKnNA6OtY1ffH8UtJy0gdpjue5B1iaD8vCTAAIz+3BeCdIAhAsk61BffDlx/5YdgRfINpm/1kewXbWL7cvcILp9RZjUDYWgm0aYov6Ocj5yMzJZxkNdUVFX5JQcRjpUpEgT48/jDsxnzlPUGpNHcLYLiQ9zDYmeRFEshZsXA/QMU1vXwIG+URnt2AhUvbw+PqOFzQsB1trHFa/xvwLBTFizwRjBDNuj9J3MDzqAggcIjg9o3phawnpG9EESaZ9NR2323QoXtHDokrR3GR4NwDWL6c4IeZ1jt6yPtpIfN8MF3o8aAO0b0x9OIhmj+tiM+aFRqlGl4KWiMMBE=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ade9aa-1159-466b-4034-08d8321d273f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:06:46.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOMLkyTmQsfyWxD9oK9Yj9nv3JyFDVt+WuFUxk+GjvuFPMxux5ZmqhZ28E/FgUAZvQKVUihSdtkm+KUog9jHkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the stmmac driver WOL implementation relies on MAC's PMT
feature. We have a case: the MAC HW doesn't enable PMT, instead, we
rely on the phy to support WOL. Implement the support for this case.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 79795bebd3a2..05d63963fdb7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -600,6 +600,9 @@ static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	if (!priv->plat->pmt)
+		return phylink_ethtool_get_wol(priv->phylink, wol);
+
 	mutex_lock(&priv->lock);
 	if (device_can_wakeup(priv->device)) {
 		wol->supported = WAKE_MAGIC | WAKE_UCAST;
@@ -618,6 +621,14 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (!device_can_wakeup(priv->device))
 		return -EOPNOTSUPP;
 
+	if (!priv->plat->pmt) {
+		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
+
+		if (!ret)
+			device_set_wakeup_enable(&dev->dev, !!wol->wolopts);
+		return ret;
+	}
+
 	/* By default almost all GMAC devices support the WoL via
 	 * magic frame but we can disable it if the HW capability
 	 * register shows no support for pmt_magic_frame. */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 358fd3bf9ef5..32c0c9647b87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1075,6 +1075,7 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
+	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1100,6 +1101,9 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
+	phylink_ethtool_get_wol(priv->phylink, &wol);
+	device_set_wakeup_capable(priv->device, !!wol.supported);
+
 	return ret;
 }
 
-- 
2.28.0.rc0

