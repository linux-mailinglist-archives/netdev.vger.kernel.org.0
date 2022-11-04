Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64226195DD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiKDMIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiKDMIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:08:46 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8F32D763
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:08:37 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221104120835epoutp04ab3a57d25ca88585113675f9c744c19d~kYF1Otg6A0796707967epoutp04N
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:08:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221104120835epoutp04ab3a57d25ca88585113675f9c744c19d~kYF1Otg6A0796707967epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667563715;
        bh=gWvumClwLh3eNt5+I81qtQmvmemuNRTWHvi94SK/Qr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPr9jBkEJd/MzqqFmv+PIMmJWLwx+kYXu/78Qpvkrcut1BCU9S1OVzRZAJL0lhRK/
         eevLKGLkZpzNBFwqFb2MQ9RGJPFvmt7anFA20N/QNShj0DY4jwZW+zfwVQ0MFDOG8k
         YvsxjUyB6VkQjWVzWBOl9FAkCkoqrq/g/lZLtCAU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221104120835epcas5p1ade291408cf7aea6d70ff39ffd814690~kYF0nKeud2977529775epcas5p1a;
        Fri,  4 Nov 2022 12:08:35 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3fXx0rfbz4x9Pv; Fri,  4 Nov
        2022 12:08:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.43.39477.EB005636; Fri,  4 Nov 2022 21:08:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061~kX9X6PGNk0452004520epcas5p4Y;
        Fri,  4 Nov 2022 11:58:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221104115854epsmtrp2ac11cc6144fd5234a4b62fe73fa8d39a~kX9X5aIkj1549915499epsmtrp29;
        Fri,  4 Nov 2022 11:58:54 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-d0-636500be1e68
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.B5.18644.E7EF4636; Fri,  4 Nov 2022 20:58:54 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115852epsmtip2a2bcad69ac78381e6447ceeedb64e40e~kX9Vn354a2474124741epsmtip2I;
        Fri,  4 Nov 2022 11:58:52 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>,
        Chandrasekar R <rcsekar@samsung.com>,
        Suresh Siddha <ssiddha@tesla.com>
Subject: [PATCH 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
Date:   Fri,  4 Nov 2022 17:35:15 +0530
Message-Id: <20221104120517.77980-3-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104120517.77980-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmhu4+htRkg9MbZSx+vpzGaDHnfAuL
        xdNjj9gt7i16x2pxYVsfq8Wmx9dYLS7vmsNm0XXtCavFvL9rWS2OLRCz+Hb6DaPF/9dbGS1m
        XdjBanHkzAtmi9tv1rFaLHqwgNVBwGPLyptMHk/7t7J77Jx1l91jwaZSj02rOtk8Ni+p93i/
        7yqbR9+WVYweB/cZejz9sZfZY8v+z4we/5rmsnt83iQXwBuVbZORmpiSWqSQmpecn5KZl26r
        5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JeSQlliTilQKCCxuFhJ386mKL+0JFUh
        I7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj1rNmloL24IqWP2uZGhh/uXQx
        cnJICJhIfPnxgK2LkYtDSGA3o8TZc4/ZIZxPjBKbLuxmBqkSEvjMKHHpAxdcx4J5zBBFuxgl
        7v+ZC9XRyiSxcNYBNpAqNgFdidZrn5lAEiIC1xklHk6+AVbFLNDAJPH+zkR2kCphAXuJW8uW
        g3WwCKhKHH96C2wfr4CtxP+trawQ++QlVm84ABTn4OAUsJNYuUIaZI6EwBEOibvPNrBD1LhI
        fJu+nhnCFpZ4dXwLVFxK4vO7vWwQdrrE5iOboWbmSHQ0NUPV20scuDKHBWQ+s4CmxPpd+hBh
        WYmpp9YxgdjMAnwSvb+fMEHEeSV2zIOx1SQWP+qEsmUk1j76BDXeQ+L50q2skKCbyCixaAvf
        BEa5WQgbFjAyrmKUTC0ozk1PLTYtMMpLLYfHWnJ+7iZGcNrV8trB+PDBB71DjEwcjIcYJTiY
        lUR4P21LThbiTUmsrEotyo8vKs1JLT7EaAoMvonMUqLJ+cDEn1cSb2hiaWBiZmZmYmlsZqgk
        zrt4hlaykEB6YklqdmpqQWoRTB8TB6dUA1Pdei7htbsinj9edE1dMEDcMeTu4w6mNbXFPbqG
        UpdPHX3HNFspdOe8J/oPGLpdT2ZEqu8rN1teFsZfPHnRVos9S9h3bz7tEXf5c/3duKTVrdre
        /w5obd+15Mw6htNRM1j9f/xuWdo0U9ysOuYGj8QC2bfWOVIhcfMWrn3E+eqRXvvkLJXLGj/O
        STgGaQe/Vqhc0LDhVvie2zcFloQ+5Ji06uI0/qQUhe2Jvz1/hE1QqJ96adNF4R36pUsXTDpy
        4ue1CbFiOcseyfinfNBbYzwrilFY4VbXZNYtKzdtqk4Jt33Km1dqzyOY82uy/k/3fctS6lvc
        hGZ8F1lbtmeW8+u3HHqZhmsvLL6XaMm0pfqSEktxRqKhFnNRcSIADltmWUQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvG7dv5Rkg57ZChY/X05jtJhzvoXF
        4umxR+wW9xa9Y7W4sK2P1WLT42usFpd3zWGz6Lr2hNVi3t+1rBbHFohZfDv9htHi/+utjBaz
        LuxgtThy5gWzxe0361gtFj1YwOog4LFl5U0mj6f9W9k9ds66y+6xYFOpx6ZVnWwem5fUe7zf
        d5XNo2/LKkaPg/sMPZ7+2MvssWX/Z0aPf01z2T0+b5IL4I3isklJzcksSy3St0vgypj1rJml
        oD24ouXPWqYGxl8uXYycHBICJhJfFsxj7mLk4hAS2MEo0T9pPwtEQkbi5IMlzBC2sMTKf8/Z
        IYqamSQuX5wLlmAT0JVovfaZCSQhIvCQUeL8505WEIdZoI1JYtGVe+wgVcIC9hK3li1nA7FZ
        BFQljj+9BdbNK2Ar8X9rKyvECnmJ1RsOAMU5ODgF7CRWrpAGMYWASubO15jAyLeAkWEVo2Rq
        QXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwZGhp7WDcs+qD3iFGJg7GQ4wSHMxKIryftiUn
        C/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cBkoia4MMhL
        0WThi7iZzE0JPrut2N6E/WZ6oy7gs+mhcBLnuuo43ux0xw9sAcf7hLYVPrn/4qXXov8cfp25
        Ah+T5bZkO8VzbS2Vrpo0+ZjSCZsw8V0eB8oDtzfvyFNOm1/9Wqs5lfsD5zZlw8b4H8ad77VP
        KMVMNp7Z981h4pVbDbvepD1ae//6jvtMJo9qXm9/7Hno8xZDI/6FAv0hJo715x7GXhCvmmhm
        Fte9z8mNRyqT47laxcFyqXUrOva+O6i9sfXulQUOXsxPjhfXZH77frIv4t/c97ZyPKv3sTBo
        d73XtXV5zzr9vVaNfmTxUd1vby962Ae23fzf67Jz36+0RdEdj3rMYi7t+x8UdEGJpTgj0VCL
        uag4EQCD4ubq+wIAAA==
X-CMS-MailID: 20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FSD SoC contains two instance of the Synopsys DWC ethernet QOS IP core.
The binding that it uses is slightly different from existing ones because
of the integration (clocks, resets).

For FSD SoC, a mux switch is needed between internal and external clocks.
By default after reset internal clock is used but for receiving packets
properly, external clock is needed. Mux switch to external clock happens
only when the external clock is present.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Signed-off-by: Suresh Siddha <ssiddha@tesla.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 229 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +
 include/linux/stmmac.h                        |   1 +
 3 files changed, 242 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 80efdeeb0b59..0a60fe3e1909 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/stmmac.h>
+#include <linux/regmap.h>
 
 #include "stmmac_platform.h"
 #include "dwmac4.h"
@@ -37,6 +38,44 @@ struct tegra_eqos {
 	struct gpio_desc *reset;
 };
 
+enum fsd_rxmux_clk {
+	FSD_RXCLK_MUX = 7,
+	FSD_RXCLK_EXTERNAL,
+	FSD_RXCLK_INTERNAL
+};
+
+struct fsd_eqos_plat_data {
+	const struct fsd_eqos_variant *fsd_eqos_instance_variant;
+	struct clk_bulk_data *clks;
+	struct device *dev;
+	int instance_num;
+};
+
+struct fsd_eqos_variant {
+	const char * const *clk_list;
+	int num_clks;
+};
+
+static const char * const fsd_eqos_instance_0_clk[] = {
+	"ptp_ref", "master_bus", "slave_bus", "tx", "rx"
+};
+
+static const char * const fsd_eqos_instance_1_clk[] = {
+	"ptp_ref", "master_bus", "slave_bus", "tx", "rx", "master2_bus",
+	"slave2_bus", "eqos_rxclk_mux", "eqos_phyrxclk", "dout_peric_rgmii_clk"
+};
+
+static const struct fsd_eqos_variant fsd_eqos_clk_info[] = {
+	{
+		.clk_list = fsd_eqos_instance_0_clk,
+		.num_clks = ARRAY_SIZE(fsd_eqos_instance_0_clk)
+	},
+	{
+		.clk_list = fsd_eqos_instance_1_clk,
+		.num_clks = ARRAY_SIZE(fsd_eqos_instance_1_clk)
+	},
+};
+
 static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 				   struct plat_stmmacenet_data *plat_dat)
 {
@@ -267,6 +306,190 @@ static int tegra_eqos_init(struct platform_device *pdev, void *priv)
 	return 0;
 }
 
+static int dwc_eqos_rxmux_setup(void *priv, bool external)
+{
+	struct fsd_eqos_plat_data *plat = priv;
+
+	/* doesn't support RX clock mux */
+	if (!plat->clks[FSD_RXCLK_MUX].clk)
+		return 0;
+
+	if (external)
+		return clk_set_parent(plat->clks[FSD_RXCLK_MUX].clk,
+				      plat->clks[FSD_RXCLK_EXTERNAL].clk);
+	else
+		return clk_set_parent(plat->clks[FSD_RXCLK_MUX].clk,
+				      plat->clks[FSD_RXCLK_INTERNAL].clk);
+}
+
+static int dwc_eqos_setup_rxclock(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+
+	if (np && of_property_read_bool(np, "rx-clock-mux")) {
+		unsigned int reg, val;
+		struct regmap *syscon = syscon_regmap_lookup_by_phandle(np,
+			"rx-clock-mux");
+
+		if (IS_ERR(syscon)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-mux syscon!\n");
+			return PTR_ERR(syscon);
+		}
+
+		if (of_property_read_u32_index(np, "rx-clock-mux", 1, &reg)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-mux reg. offset!\n");
+			return -EINVAL;
+		}
+
+		if (of_property_read_u32_index(np, "rx-clock-mux", 2, &val)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-mux reg. val!\n");
+			return -EINVAL;
+		}
+
+		regmap_write(syscon, reg, val);
+	}
+
+	if (np && of_property_read_bool(np, "rx-clock-skew")) {
+		unsigned int reg, val;
+		struct regmap *syscon = syscon_regmap_lookup_by_phandle(np,
+					"rx-clock-skew");
+
+		if (IS_ERR(syscon)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-skew syscon!\n");
+			return PTR_ERR(syscon);
+		}
+
+		if (of_property_read_u32_index(np, "rx-clock-skew", 1, &reg)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-skew reg. offset!\n");
+			return -EINVAL;
+		}
+
+		if (of_property_read_u32_index(np, "rx-clock-skew", 2, &val)) {
+			dev_err(&pdev->dev, "couldn't get the rx-clock-skew reg. val!\n");
+			return -EINVAL;
+		}
+
+		regmap_write(syscon, reg, val);
+	}
+
+	if (np && of_property_read_bool(np, "tx-clock-mux")) {
+		unsigned int reg, val;
+		struct regmap *syscon = syscon_regmap_lookup_by_phandle(np,
+			"tx-clock-mux");
+
+		if (IS_ERR(syscon)) {
+			dev_err(&pdev->dev, "couldn't get the tx-clock-mux syscon!\n");
+			return -EINVAL;
+		}
+
+		if (of_property_read_u32_index(np, "tx-clock-mux", 1, &reg)) {
+			dev_err(&pdev->dev, "couldn't get the tx-clock-mux reg. offset!\n");
+			return -EINVAL;
+		}
+
+		if (of_property_read_u32_index(np, "tx-clock-mux", 2, &val)) {
+			dev_err(&pdev->dev, "couldn't get the tx-clock-mux reg. val!\n");
+			return -EINVAL;
+		}
+
+		regmap_write(syscon, reg, val);
+	}
+
+	return 0;
+}
+
+static int fsd_eqos_clk_init(struct fsd_eqos_plat_data *plat,
+			     struct plat_stmmacenet_data *data)
+{
+	int ret, i;
+
+	const struct fsd_eqos_variant *fsd_eqos_variant_data = plat->fsd_eqos_instance_variant;
+
+	plat->clks = devm_kcalloc(plat->dev, fsd_eqos_variant_data->num_clks,
+				  sizeof(*plat->clks), GFP_KERNEL);
+	if (!plat->clks)
+		return -ENOMEM;
+
+	for (i = 0; i < fsd_eqos_variant_data->num_clks; i++)
+		plat->clks[i].id = fsd_eqos_variant_data->clk_list[i];
+
+	ret = devm_clk_bulk_get(plat->dev, fsd_eqos_variant_data->num_clks, plat->clks);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int fsd_clks_endisable(void *priv, bool enabled)
+{
+	struct fsd_eqos_plat_data *plat = priv;
+	int ret;
+
+	const struct fsd_eqos_variant *fsd_eqos_variant_data = plat->fsd_eqos_instance_variant;
+
+	if (enabled) {
+		ret = clk_bulk_prepare_enable(fsd_eqos_variant_data->num_clks, plat->clks);
+		if (ret) {
+			dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
+			return ret;
+		}
+	} else {
+		clk_bulk_disable_unprepare(fsd_eqos_variant_data->num_clks, plat->clks);
+	}
+
+	return 0;
+}
+
+static int fsd_eqos_probe(struct platform_device *pdev,
+			  struct plat_stmmacenet_data *data,
+			  struct stmmac_resources *res)
+{
+	struct fsd_eqos_plat_data *priv_plat;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	priv_plat = devm_kzalloc(&pdev->dev, sizeof(*priv_plat), GFP_KERNEL);
+	if (!priv_plat) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	priv_plat->dev = &pdev->dev;
+	data->bus_id = of_alias_get_id(np, "eth");
+	priv_plat->instance_num = data->bus_id;
+
+	priv_plat->fsd_eqos_instance_variant = &fsd_eqos_clk_info[data->bus_id];
+
+	ret = fsd_eqos_clk_init(priv_plat, data);
+
+	data->bsp_priv = priv_plat;
+	data->clks_config = fsd_clks_endisable;
+	data->rxmux_setup = dwc_eqos_rxmux_setup;
+
+	ret = fsd_clks_endisable(priv_plat, true);
+	if (ret)
+		goto error;
+
+	ret = dwc_eqos_setup_rxclock(pdev);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "ERROR:Unable to setup rxclock\n");
+out:
+	return 0;
+
+error:
+	priv_plat = ERR_PTR(ret);
+	goto out;
+}
+
+static int fsd_eqos_remove(struct platform_device *pdev)
+{
+	struct fsd_eqos_plat_data *priv_plat = get_stmmac_bsp_priv(&pdev->dev);
+
+	fsd_clks_endisable(priv_plat, false);
+
+	return 0;
+}
+
 static int tegra_eqos_probe(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *data,
 			    struct stmmac_resources *res)
@@ -415,6 +638,11 @@ static const struct dwc_eth_dwmac_data tegra_eqos_data = {
 	.remove = tegra_eqos_remove,
 };
 
+static const struct dwc_eth_dwmac_data fsd_eqos_data = {
+	.probe = fsd_eqos_probe,
+	.remove = fsd_eqos_remove,
+};
+
 static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 {
 	const struct dwc_eth_dwmac_data *data;
@@ -493,6 +721,7 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 static const struct of_device_id dwc_eth_dwmac_match[] = {
 	{ .compatible = "snps,dwc-qos-ethernet-4.10", .data = &dwc_qos_data },
 	{ .compatible = "nvidia,tegra186-eqos", .data = &tegra_eqos_data },
+	{ .compatible = "tesla,dwc-qos-ethernet-4.21", .data = &fsd_eqos_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, dwc_eth_dwmac_match);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8273e6a175c8..7be95a876c32 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3831,6 +3831,9 @@ static int __stmmac_open(struct net_device *dev,
 	netif_tx_start_all_queues(priv->dev);
 	stmmac_enable_all_dma_irq(priv);
 
+	if (priv->plat->rxmux_setup)
+		priv->plat->rxmux_setup(priv->plat->bsp_priv, true);
+
 	return 0;
 
 irq_error:
@@ -3884,6 +3887,9 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	if (priv->plat->rxmux_setup)
+		priv->plat->rxmux_setup(priv->plat->bsp_priv, false);
+
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -7383,6 +7389,9 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
+	if (priv->plat->rxmux_setup)
+		priv->plat->rxmux_setup(priv->plat->bsp_priv, false);
+
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
@@ -7546,6 +7555,9 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
+	if (priv->plat->rxmux_setup)
+		priv->plat->rxmux_setup(priv->plat->bsp_priv, true);
+
 	netif_device_attach(ndev);
 
 	return 0;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d..8867646917e0 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -229,6 +229,7 @@ struct plat_stmmacenet_data {
 	void (*ptp_clk_freq_config)(void *priv);
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
+	int (*rxmux_setup)(void *priv, bool external);
 	struct mac_device_info *(*setup)(void *priv);
 	int (*clks_config)(void *priv, bool enabled);
 	int (*crosststamp)(ktime_t *device, struct system_counterval_t *system,
-- 
2.17.1

