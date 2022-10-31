Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3021661335C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJaKMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiJaKLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:11:55 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2072.outbound.protection.outlook.com [40.107.104.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B95DFB8;
        Mon, 31 Oct 2022 03:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNbit3hs/eE7oaxktX+kdWRPRVpABCR1Gf25oG0G7Fm2tbr+z/JV+Vmep24gkPWL/oC5KRCvDrOQkFk5vWfR38OGzG9UvYK12Gs2q7OJpFOgPR9SgYQGV7vvzXLv1CAJ/LbYEm2skVj5ab0gVcdOoa+Kq1g8NzL920N8IXu0BBwo3V9+B2Q2an4ajyk8QwQOmvhvHjicfr/IkutA0mSBKHFMQfL+BrKRfzCIjCxt9PkRCocq3ZwEYnddQAN8s8QIn/tHK+UKbdUSugM0JdgnHuk5R6pMAGR1428hQ8NkSqS2Y3RgDvQ/hkv9KIQIXU91kag661L+Zfw6YnMncxcZoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMtB4KtZB4Fsq/+xbQpsPfW0AA+ilMnSEmgLWMsfEmo=;
 b=Co/MY9hn7syP4y0FG/Iy/SjOyl8pSbtHYAyCXuoGOGNDOxCpJADe8Hp/H6Lsh4Zf30FgPm2ouxeu+wBpyA3ywYQZZXfjDgJfqoWUylINkCMwSw1xi3j+p7HlHW1XiZH17Jkh7iQW8zCJafJrSq3tMT+VMr3fgyFKr5+5Sv1ZfuTmub+jeh3Swm49QQK9pbZk2NkolFNbu8s+XQkR6rC0XgPqffO949jpVVhrzGsZzbJS6UTW0XQqV0EgZTIgpfKwT4bWvTAtrjZ7tGNDZc4C7szB4f7fDWs823TYdW0pXjYMYjZm/mTHpwlf0hXRH1kRV/SO7WPQR1tHQNz5MBXUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMtB4KtZB4Fsq/+xbQpsPfW0AA+ilMnSEmgLWMsfEmo=;
 b=ayUa16REoqAc7K9QHzOAP6W9/oFAz8SkKbpuLC6qgrG4sg9sbr0hyjv2n/naWA5rdDG8SAMJwM1Xr8A0m2xPQpS6wRXa/KMRbpQnxu7AYGztN2kq3sNgbsCWZLHTWymIPl2NEfmsfSiIYQS795Fo1cxQR27d9XmzWKtdgKPIgsJ5i+hxgeD6EcN8YWOPOlAPoPC4o+tdHFKj9AvA1SI4WQ6ablVZNL7GH+U7XDwQZS9emQL1Vmpa5ghR6Q/jFYROfEfnIYI1DDUrIZ8YzPFMZp0J7+/wvvj08N8iT/wP/AkTXTJvOfk1aWBtMt1mJieFLd798UGA5jmB28cD0Pfz9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by VE1PR04MB7261.eurprd04.prod.outlook.com (2603:10a6:800:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 10:11:48 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:48 +0000
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
Subject: [PATCH 4/5] net: stmmac: Add AXI4 ACE control support
Date:   Mon, 31 Oct 2022 18:10:51 +0800
Message-Id: <20221031101052.14956-5-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031101052.14956-1-clin@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0204.jpnprd01.prod.outlook.com
 (2603:1096:404:29::24) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|VE1PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 7de1a7a1-48e4-46a0-2ffb-08dabb285228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zCxcI4+xZ4rL6KyFsgRWh0ZekHkLaYBYv26VCB0cyOXQiTZdDelBCCWHJ2bl0D10V4EYk+BYmH10FVCLTrhe+9RdZ0BUByx38IfITKSAAJXL2jYGmXv7yIRbJOUaffeuGT43Nx44G483WFU3r1wMvug6OzhZQajjH9YFxhUZuFoSXbEF4uPUPjo6JY//tUax9rbf4Ei0OkOqY1wyokGGgTd2WTiug48QaMaWdL4+GaM55C/GwBjde0KgB86L57lUiTIbdXGmAmqUAmnAzOcdLZdPXaEPQlIaBKFA+0K+YXhmsc0Evnj7gnIKgrk3Cmi9ofp5OH8Svs5fjYOKphygBjy5XZsslevYqi5XzMN2XP/5V2S66IsmMGXy+hXDTDAUiL2qb3i2SpI4dlsyW2aDW+WhMW6rkJxllFZgAWYflrYVZE4I+ehJtZY5zlzEc8ssNL+JJdJWSGOMK1NMHYp56dVorGpZ6Ee4bUoiQl6+1PBrG3tMtN+osihhDcnnpHynFwQbdr935JDUk2nK/3pXHX8yWs3SAwXzoR/KSg5kodQecw9ALco0kVCPQyoCTU0upNmdlq45t2k782zExgIuWTfUDpzSnEbqMcaKiwqJeswhbeTKWXqzCfUYIhbhx/BFss+CeFfaBMEV/juVIxSZtxjgVIxAO3Xib+hACjKHtPHDzDPsouRUw4s4xSkXwGFRPyRBxbDrQqw2mKAUFheiAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39850400004)(376002)(366004)(346002)(451199015)(6486002)(107886003)(478600001)(110136005)(54906003)(316002)(6666004)(86362001)(8676002)(6506007)(4326008)(66476007)(66946007)(66556008)(2906002)(26005)(38100700002)(41300700001)(6512007)(2616005)(186003)(1076003)(83380400001)(8936002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QBei5nV3/AmNokC9CM325LlTcLVCseXblMyZg0thdGGFtsZyDg7j5CtqHCGu?=
 =?us-ascii?Q?guL5pO5nYxKHwqtbeQdl3VUgLG1QEiWAdERiO74RcZGTZ7C0NNFjq5FxFYbV?=
 =?us-ascii?Q?ymZWKvm4rYAdv2oUhq6gSoot8eeDDhLQ8FQXUkdE5cchWZ5WYN5C9dDJw76l?=
 =?us-ascii?Q?r4kYR2bkewKUGLeMpGuDydB7H3khlacRUAOstkgpNDT2ssEeBJ8bJjW+558b?=
 =?us-ascii?Q?peceVZBKLsmbvh7OobgbinsdzyieRmGtktCOrYGw9AJs2X7WIAbq41lJt2jU?=
 =?us-ascii?Q?NpiPpmAkHdqkjqmSW6fcOjy6FargBKa2JbqwjUYV9mRwKamoJs5YTNmZBdgX?=
 =?us-ascii?Q?KcEqmq6QCXfcoV3Rv7cOolZCcKg2LtaNgEJ0PnXLi8og0heTeqRODvyWr2Rx?=
 =?us-ascii?Q?wnYxxXbBasRxofuO66+YnXKv24qrN7bpHCA8TvUbWz0BD2n2DkrmhVsvE04a?=
 =?us-ascii?Q?4VkBtTDYSsOr1Awz1v40i32hZfS/YbshrF1wstiBlXeuXSBup5zCIFGEtL63?=
 =?us-ascii?Q?hiKQyhotZ3Aqit8cKCAFn83As0TffECbORfQuiIlfOZWAxy4gPBOANeXXkkk?=
 =?us-ascii?Q?LP9kNOWxwCyFYNHVT4G3FYqNj+xCnF2fEWCAJ+zbxt0Cyy0hE5aJQKJa6FtN?=
 =?us-ascii?Q?BCpq8Py6xfJ74QPxFRkrjTEKZszqLPDusocaDHlRnIC2TNlySHOD2c2z1XNf?=
 =?us-ascii?Q?S7tledYkJU4JWXvHYw3qtF/WmiliLeci3NCVxag7bZrZKZJ/TMOEvsapanyn?=
 =?us-ascii?Q?XuSTuXmBWd2IOJsm3+Q2tjyrgLU2nmIMoIKsd/dLioxMHINDSGeC7jD+7Dwl?=
 =?us-ascii?Q?ZXKu7oB480RbrD1Vd3ERWfSACHgu/NIiWj01WwOPYrez4My+oQnqkHILmX5I?=
 =?us-ascii?Q?nvg+QfFpWxuEL8AbyChnQP+BiTWCrIGm/0FNiJDlAz0FLGVphSkufcGdEO1y?=
 =?us-ascii?Q?m/NO5q5NxuD7VlH+lABEd26dqrvPGx6LaaxtkTysUNsz4gE4p12FTCPxXiEq?=
 =?us-ascii?Q?ahkoq41tSRqi2jeyLhQ5ojfFySzRrxseYT+gZi6ULQ/C7OFQqJGu3+K2cs6+?=
 =?us-ascii?Q?NUaPUBaVsPN5PPMU2Cguw3V5m6pXvbQ1ayUaLzmEu2Hncz4qWkG1Lz3jVmHN?=
 =?us-ascii?Q?+4mbNqYvDZm2WFhrCGI+bkaJW/tfxnOtXK5vkJ6ddbGIDt5ZYzbJabOvlJsZ?=
 =?us-ascii?Q?rW7lzuStpmZp2z1z1fWnE2SjIuFHiNWBZqIQvet77kgY7bCSl0salLUAwWP7?=
 =?us-ascii?Q?4eXiDJz2B0bb2sHO3ppP1d/WebonbclLEd3CgXOAQfciGSN5V2qnOkI3oTvq?=
 =?us-ascii?Q?4vFOl+Bn1DRFu8ninpgukD6D2tWpc45wXbrgRJmAvh/4LGGjAMGH649XXaol?=
 =?us-ascii?Q?vWtHxGve7TZ2SNLSBgtqzMXp0bif6MZDVrT2OdlsDU+HJh3xeJYI7JY2rFZT?=
 =?us-ascii?Q?LXcP0V8XMW5uZpyLp1wuMQE5+E6r/F6fgZ5CO2Y/LxgjkFuhyD8QFdwd+xZo?=
 =?us-ascii?Q?kSPb3scWYam3BW/jnHrdw+tZJpwYJa7kziyPNJRwq/qCvIpzPGSmjI8bv+j3?=
 =?us-ascii?Q?2GdXVmRysRprCboRu+o=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de1a7a1-48e4-46a0-2ffb-08dabb285228
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:48.0766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcqKnGrzMk0XUbPlwh918LDkJu8gq2B3v17lxbt4zi/3ej1gL0BzL3gqe3LVCr5g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
index 68ac3680c04e..1325d5425daf 100644
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

