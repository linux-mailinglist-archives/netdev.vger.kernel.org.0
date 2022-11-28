Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D131E63A0F3
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiK1Fux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiK1Fuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:50:32 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2067.outbound.protection.outlook.com [40.107.6.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED413FA2;
        Sun, 27 Nov 2022 21:50:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayFqnaSbW659vP5nxAGbf+jLQT/tG96zWkorNhQ2E9RE59P9kKeagVGcIIDn4hVgwuXmTVimqBvVjFJxZAScg2WjNrry7VDuAguyYsFnwhrLlObtcspozZRl4PABkKpFgvsQrXLrnc/TxS2H6u92tOaNU7DQyVllRnzan67irVoIwM3bNo5PjWqc9IrirAAGvEIoXAT8oqGeG0ORqsaq7v99kYEfeQRflPPfXQYzqE5k0eYLVr8bo1dobx8cEO6XzePYLuq/b7ZpQMNfkIQFCpfK8CSXUmafrdbc81bxAu3/lGXzRl5nlVo6X95aKttcE+RYfJFkFPrczdF73emc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkDOhglruLbaI4B2k6tVB0L289fbs1TQ/155LSXUMgs=;
 b=GUhZn5O9XVSuIL5NLBESsgKIfGx6cwNzrI5N6hOdcNtOHJcLUjtuo0O6/ID2ht2RV7ng7dy96Z7kaXhs6nwX/B2fl7pwJQen17Jp6b8Clrba7NGzSQm+PiWJKqpzIagHcDDt+u1qr27VlWUQHWWlaS0E21RFUPBYutdgaHaXAe22Ekhp9W/MIJn/s0rWZ+TTDdWBJ8xiIHIsc04bmuJC9jsF1ntoSj7nL6yQEn1qPZrxaUIBYBzhh7wed/xRvCQHsDnmxz3wtOppjZABn0kRizSN8rRZ1pgkW0jt4c0GT6FhrZZfMpOZnTCtkEm88vGwcok1yNAFItZqBDYdXITbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkDOhglruLbaI4B2k6tVB0L289fbs1TQ/155LSXUMgs=;
 b=qA50qQ4xDFdGw+4ku6//ABSx3YXv14WMsVgzTv2xrSWvOUh5UU4XgFC7VufrFmAwGGVaISfozajOybDTy/Hc8ucnNXmCFYQt1ux5Ql0Dqv0Rk/yUsocqf5pG8mjh3SBgx7QRFpq1I6yM4XuMMkRJn/NV2YUcZvREn4+9IJNfgv+Edh0LNs0jGdZG4NC4Bn3CpjDGQeihn4V50ok1aNgbpxd59tV4PLgINFecVLruiKi6oOytd9aE/4HlG9Hz/IgOISPyH17m90z5oKEFS/UPjhDJBup0F+UCdI4fapMFR7QBx1KHSfmMfQYRnrr4JXoa3dFYtOnRNYlrtlU5jR6oKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by DB9PR04MB8478.eurprd04.prod.outlook.com (2603:10a6:10:2c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 05:50:09 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:50:09 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Petrous <jan.petrous@nxp.com>,
        Ondrej Spacek <ondrej.spacek@nxp.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH v2 4/5] net: stmmac: Add AXI4 ACE control support
Date:   Mon, 28 Nov 2022 13:49:19 +0800
Message-Id: <20221128054920.2113-5-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221128054920.2113-1-clin@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0149.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::12) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|DB9PR04MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e70168-8010-4e0d-8305-08dad10468c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: es0T2H5hZI1uNxP68OcqR4kOeO5PdnkXbvwPCNJUap1gcUnBNgjtiWcWxOEEfFW+YXnm0XfmJOXGH62z3zJHAnPwG9omXUPeq5vwdjGDjVTsHJUGywuPdaleGLG/gPI1uk0jAhCCbd0jdSbfiah12Tko1wdTWDXZZ4/kLpkInwwCe+TOWepKXQZH/o9vXHrsjtAxTqjnn0WhnNkdMlmOxWEUqsGog8Iww6WdUzOQ6U5YBY04YcQ5F/B7Vbb/xpDpNtHJYNC9liRkkSJscsy7ckz4VRwVV5xjeAGJZd6k5yVzi7vlwdTBse9LoZpsxF9EpT3tR/jk3D220uaqY2dWLxn6uBvzaKBE6gVrOlF8dq3rNOca0NV0u+MZAzm4IIcBdOen7up19erURkLsKZuBfZrhyHXigXypXB0ac1aQkIWzpkdD9uSZFz6rRuo/YO4+lZG7tv3R015x56kcDHrcMs15wxR6RbOgPPXSvietol4EdxNdnydkYI0wO4p9PxdzlkDTy2WVxwqNUoNkWwieKhgOWb5veMr+kowW+rdnUqDg5cK/wDsmvi2TgsqiTNWg75lMLK8NbaWLBuhTb5mAOPMiOcw726JM4bgCAKpsitJcsmGpMyQWjko0haQw2OTP8ccZu38/rGkhQol/pyMbTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(107886003)(2906002)(186003)(6486002)(6506007)(36756003)(478600001)(6666004)(6512007)(1076003)(38100700002)(86362001)(83380400001)(2616005)(41300700001)(66556008)(66476007)(8676002)(66946007)(5660300002)(4326008)(7416002)(8936002)(54906003)(316002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g/2SbFArYs7ZHsJR1Jr1g+YyvNTYcZtfc64Zndr0ETMp8mJJIucYQ/mhRG/f?=
 =?us-ascii?Q?VNggn+f9vw479X4wlfIInJin9YPkLEQO0hRw67xJ1rSynElvowhVqo6/aJZj?=
 =?us-ascii?Q?kxBCzrmp8N9OfgyP0Qz+iZqGdjrXnkVnnkzX2LH7z4JNVNKLjKA+0RBBRvCC?=
 =?us-ascii?Q?Ajrth57OkjGP1tMrG4PnBJ5rZ+pDzkPwyN7ZMe69+HncJStMA37jcIL6oMYi?=
 =?us-ascii?Q?8MyXdlRkIJ00MjjAdXJog7mffdSmEzoFmOgD6EG74YC+/UWnVDcO/hU19PcT?=
 =?us-ascii?Q?mH7stm60d3mb6tykSSO6WO3TC2aSRwEWJibqGIS4AnJz6WwiHiK6SP8FccV+?=
 =?us-ascii?Q?wxwXOuneiMnJEX4mWFRXvLUXX2JeCac7jQoEbNGBNdMPBj04L0VBSfC1EFix?=
 =?us-ascii?Q?07Y8BWLb3dyd4onpPuyWyFPTYjZddk7l8Y0iuUBfPuCUMBbTe9ld11h4FEeJ?=
 =?us-ascii?Q?9ZS7azTDO57yPuBavCIELY8LD+Cv204Kksm0EdCD2Wsi/z9D9FogDeRX25y2?=
 =?us-ascii?Q?J5aD9aOGDOq9hBHhr2FR6rFZ77aVBGCWRm2OH4lHBvAy445R4FOlrEAyEkxC?=
 =?us-ascii?Q?V3DjMmSAVhHjH1c3cPJ2Fw8hOL8FgezkE2QFWF4F9VkJVa6A05A0nQ+MCXZ9?=
 =?us-ascii?Q?OZAaN7qO5wwxIAj5AXP4bkp8PqNJwbBBuxFDarZGC4hn+c5J9SsY8OdrSsif?=
 =?us-ascii?Q?Uf0XG/yPlw900whih0ZBzaFDNaC17IWgglzgUUvlWUzDIatZ/XnBwnT7Xmq3?=
 =?us-ascii?Q?MrPUphAtT5AG2rsdqYhJXcjg3eWewaU/VNFYrl/pcbYrWDMELBaF2Au6h9HX?=
 =?us-ascii?Q?1xe2lbZpzVWqP/903QAYiZkLSx2NaDYiBl1kwF6ri5blYMLGDfoD808hcBvI?=
 =?us-ascii?Q?Z6KTNc1TIQ1CcWnckk20Ptfk3Gj9Y2CNr1fUi7VpoTA63DUosCN68VXXP+Al?=
 =?us-ascii?Q?VmQxin9Uqp4rxNtAU92scC2Bg9zaz9/k6LqqpXgvXBbD5sDC0tAlBUaiMLcp?=
 =?us-ascii?Q?OhjcgOlXrru4XLwhrcyT5zRCsZ3tpRFfUHnl6LdN+WZXSnQuixOl2Jv/Inal?=
 =?us-ascii?Q?MlvVkuVw2fzH6nhtnl7rZqGVDDEeq+8B0T4jqBedrasRrM5/Ijz0SQyPO2mS?=
 =?us-ascii?Q?Jem8o2r2pBfSsPn/HRfltm6ODA2tNPE5yfVWjKiyaJ+kRIPkFg/KM4hdHYkd?=
 =?us-ascii?Q?8QpmjxIOW/X8ic4rH/+2NJMHQpngBj1pkIPAS/LQweaEpjAKShgQ3AVdX1Ew?=
 =?us-ascii?Q?Mfhiov89lZQvvKsdmR69GxvW85adZ9mVq9KFhMoZDry4uCcw4oHMqCzeBo4s?=
 =?us-ascii?Q?B43DNTtT8f+ewOvZCnCUvUbyDLZ8d4tbuyK+vqA3xcg/B5NLe3mmQx88ez55?=
 =?us-ascii?Q?9SJLbrE0RZlcOZwUADWNmjOvC7syUcZ4l3PnzNC2C/2todlpoSKxqZjHXrA/?=
 =?us-ascii?Q?bJRQEYosIZMoT5P1jBvV8CI/QyrjVq51OcnTJpuytahv89g50w8GstTtnblE?=
 =?us-ascii?Q?/Jb8zrm7YlW1lnO+WaHokDImDODiYDeK5iHPlwllxZEnVoKPWpekw7jgjh8K?=
 =?us-ascii?Q?ldeqvaEvrtqtj6mHCJgmz1KrPynsztxDzEzRao6AHAcg28z/oDy4VXCPk5/U?=
 =?us-ascii?Q?n4ogIV0Hu/o0xdDBiJ1fo8qfMA02ZWIs4a3eiHPnfgXx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e70168-8010-4e0d-8305-08dad10468c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:50:09.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85FTrveBljd6zONY/cRkKhhGcqMwri8Nbf6XhHA/z6ftzY1+svbJJjt5HN0WrK9z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add AXI4 cache coherency control in dwmac4 DMA core.

Signed-off-by: Ondrej Spacek <ondrej.spacek@nxp.com>
Signed-off-by: Chester Lin <clin@suse.com>
---

No change in v2.

 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  4 +++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  5 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +++
 include/linux/stmmac.h                            |  7 +++++++
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index d99fa028c646..4e6e2952abfd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -517,6 +517,15 @@ static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
 	return 0;
 }
 
+static void dwmac4_axi4_cc(void __iomem *ioaddr,
+			   struct stmmac_axi4_ace_ctrl *acecfg)
+{
+	/* Configure AXI4 cache coherency for Tx/Rx DMA channels */
+	writel(acecfg->tx_ar_reg, ioaddr + DMA_AXI4_TX_AR_ACE_CONTROL);
+	writel(acecfg->rx_aw_reg, ioaddr + DMA_AXI4_RX_AW_ACE_CONTROL);
+	writel(acecfg->txrx_awar_reg, ioaddr + DMA_AXI4_TXRX_AWAR_ACE_CONTROL);
+}
+
 const struct stmmac_dma_ops dwmac4_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
@@ -574,4 +583,5 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.set_bfsize = dwmac4_set_bfsize,
 	.enable_sph = dwmac4_enable_sph,
 	.enable_tbs = dwmac4_enable_tbs,
+	.axi4_cc = dwmac4_axi4_cc,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 9321879b599c..7f491f2651b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -21,7 +21,9 @@
 #define DMA_DEBUG_STATUS_0		0x0000100c
 #define DMA_DEBUG_STATUS_1		0x00001010
 #define DMA_DEBUG_STATUS_2		0x00001014
-#define DMA_AXI_BUS_MODE		0x00001028
+#define DMA_AXI4_TX_AR_ACE_CONTROL	0x00001020
+#define DMA_AXI4_RX_AW_ACE_CONTROL	0x00001024
+#define DMA_AXI4_TXRX_AWAR_ACE_CONTROL	0x00001028
 #define DMA_TBS_CTRL			0x00001050
 
 /* DMA Bus Mode bitmap */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 592b4067f9b8..bffe2ec36bb3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -212,6 +212,9 @@ struct stmmac_dma_ops {
 	void (*set_bfsize)(void __iomem *ioaddr, int bfsize, u32 chan);
 	void (*enable_sph)(void __iomem *ioaddr, bool en, u32 chan);
 	int (*enable_tbs)(void __iomem *ioaddr, bool en, u32 chan);
+	/* Configure AXI4 cache coherency for Tx and Rx DMA channels */
+	void (*axi4_cc)(void __iomem *ioaddr,
+			struct stmmac_axi4_ace_ctrl *acecfg);
 };
 
 #define stmmac_reset(__priv, __args...) \
@@ -272,6 +275,8 @@ struct stmmac_dma_ops {
 	stmmac_do_void_callback(__priv, dma, enable_sph, __args)
 #define stmmac_enable_tbs(__priv, __args...) \
 	stmmac_do_callback(__priv, dma, enable_tbs, __args)
+#define stmmac_axi4_cc(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, axi4_cc, __args)
 
 struct mac_device_info;
 struct net_device;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ff0b32c9e748..c689723c7d93 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2917,6 +2917,9 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 	if (priv->plat->axi)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
+	if (priv->plat->axi4_ace_ctrl)
+		stmmac_axi4_cc(priv, priv->ioaddr, priv->plat->axi4_ace_ctrl);
+
 	/* DMA CSR Channel configuration */
 	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 307980c808f7..23e740c6c7b8 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -115,6 +115,12 @@ struct stmmac_axi {
 	bool axi_rb;
 };
 
+struct stmmac_axi4_ace_ctrl {
+	u32 tx_ar_reg;
+	u32 rx_aw_reg;
+	u32 txrx_awar_reg;
+};
+
 #define EST_GCL		1024
 struct stmmac_est {
 	struct mutex lock;
@@ -248,6 +254,7 @@ struct plat_stmmacenet_data {
 	struct reset_control *stmmac_rst;
 	struct reset_control *stmmac_ahb_rst;
 	struct stmmac_axi *axi;
+	struct stmmac_axi4_ace_ctrl *axi4_ace_ctrl;
 	int has_gmac4;
 	bool has_sun8i;
 	bool tso_en;
-- 
2.37.3

