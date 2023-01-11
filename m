Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BC5665644
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjAKIju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjAKIji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:39:38 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8B3CE01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:39:36 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230111083935epoutp02337be96c4a8b1d7b339b72a5aa2ceb1a~5NGwGij3L2640526405epoutp02A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:39:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230111083935epoutp02337be96c4a8b1d7b339b72a5aa2ceb1a~5NGwGij3L2640526405epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673426375;
        bh=7FLh0jGuKdVAaakStp1xPiAe/EEKKfi+9xX2zEYEdRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KliPIjJ+poVzguPCSHlQfoUDOA8vfSPXh/Bn+PN+57EJD0V4oLVhLaCjo0kWsvYJJ
         1RC++ILUTq4n0f9lmIM3GH5XmKY764qY6rFoYNE97PXzbYbg+do0HqrjGpRABJ6EUR
         Fip7KKgzejdVK4F27UHTCPwQ5HkDtRe9t0MFlTvY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230111083934epcas5p24adb0f4f0015412f8fbda7d22c131d79~5NGva_ra-0903809038epcas5p2E;
        Wed, 11 Jan 2023 08:39:34 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NsLhN5RJdz4x9QF; Wed, 11 Jan
        2023 08:39:32 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.DE.02301.4C57EB36; Wed, 11 Jan 2023 17:39:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230111075445epcas5p2b94c8ddc5608c0b20d3d28b049592b4a~5MfnY3Xnl0222602226epcas5p2W;
        Wed, 11 Jan 2023 07:54:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111075445epsmtrp177b43192700a9d9c654e4cba45e23416~5MfnXwNRX2456324563epsmtrp1f;
        Wed, 11 Jan 2023 07:54:45 +0000 (GMT)
X-AuditID: b6c32a49-201ff700000108fd-61-63be75c4b9c3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.44.10542.54B6EB36; Wed, 11 Jan 2023 16:54:45 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075442epsmtip1b9ad071ad7e6c1d8110c28a031d38359~5Mfk31Nv12452324523epsmtip1X;
        Wed, 11 Jan 2023 07:54:42 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com,
        Sriranjani P <sriranjani.p@samsung.com>,
        Chandrasekar R <rcsekar@samsung.com>,
        Suresh Siddha <ssiddha@tesla.com>
Subject: [PATCH v2 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
Date:   Wed, 11 Jan 2023 13:24:20 +0530
Message-Id: <20230111075422.107173-3-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230111075422.107173-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmuu6R0n3JBqt/aVr8fDmN0eLBvG1s
        FnPOt7BYzD9yjtXi6bFH7Bb3Fr1jteh78ZDZ4sK2PlaLy7vmsFnM+7uW1eLYAjGLb6ffMFos
        2vqF3eL/662MFg8/7GG3mHVhB6tF694j7Ba336xjtVj0YAGrg7DHlpU3mTye9m9l99g56y67
        x4JNpR6bVnWyedy5tofN4/2+q2wefVtWMXo8/bGX2WPL/s+MHv+a5rJ7fN4kF8ATlW2TkZqY
        klqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SjkkJZYk4pUCgg
        sbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE741LjZLaC
        mR4Vx//3sjcwfrfuYuTkkBAwkfg5/RJTFyMXh5DAbkaJmZeusEE4nxglFq17wwrhfGaU+Hj/
        FRtMy5rzPVAtuxglth/YA5YQEmhlkng6oR7EZhPQlWi99hmsSETgC6PE9TUd7CAOs8BMJomz
        P5YxgVQJCzhJ3Ds5hRnEZhFQlej8PQHM5hWwk/j86z4jxDp5idUbDoDFOQXsJf48+gU2SELg
        CofE3ouHmSCKXCSmP17HDGELS7w6voUdwpaSeNnfBmWnS2w+spkVws6R6Ghqhqq3lzhwZQ5L
        FyMH0HWaEut36UOEZSWmnloHNp5ZgE+i9/cTqFW8EjvmwdhqEosfdULZMhJrH32CGu8hsenS
        WxZIEE1ilDj+9yfzBEa5WQgrFjAyrmKUTC0ozk1PLTYtMMxLLYfHW3J+7iZGcErW8tzBePfB
        B71DjEwcjIcYJTiYlUR4V3LuSRbiTUmsrEotyo8vKs1JLT7EaAoMwInMUqLJ+cCskFcSb2hi
        aWBiZmZmYmlsZqgkzpu6dX6ykEB6YklqdmpqQWoRTB8TB6dUA5OfZH6h4fmFj+8xMM+eZBj/
        uerm820brCdoeF00WnTnyLSJucnPPqRMbSz5nlN2UljDMHhq67cHxdJZT8w6Wvh15nvf/lzH
        tFAws+nBhD/NZopFK1JOh7sl/WnOaHj/zEO+Svr445K3r6LnT/lX/lC8Y+4NwRyxEvtt9x8H
        f19QX1+vWLb3Xs0BeSuuKM55H+Z+MCp68XmutHZTWFzaz5ouQz++ntTgZ5sloiff8syJyo89
        9nmr9sYtRrOuLTh1cf2T/n9KW1UvTJm93I7RfNYB05MvWSRXT7NNuM97dfq8Mouk/8tKEsRE
        /X9N/C3pfG/n4oNiMSrcU4Q2yD0vMvnpMLXTXNW5qP/IFAtD1b9KLMUZiYZazEXFiQApVDtX
        UgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSnK5r9r5kg/OzlSx+vpzGaPFg3jY2
        iznnW1gs5h85x2rx9Ngjdot7i96xWvS9eMhscWFbH6vF5V1z2Czm/V3LanFsgZjFt9NvGC0W
        bf3CbvH/9VZGi4cf9rBbzLqwg9Wide8Rdovbb9axWix6sIDVQdhjy8qbTB5P+7eye+ycdZfd
        Y8GmUo9NqzrZPO5c28Pm8X7fVTaPvi2rGD2e/tjL7LFl/2dGj39Nc9k9Pm+SC+CJ4rJJSc3J
        LEst0rdL4Mq41DiZrWCmR8Xx/73sDYzfrbsYOTkkBEwk1pzvYepi5OIQEtjBKHH+xT52iISM
        xMkHS5ghbGGJlf+es0MUNTNJrDl6hRUkwSagK9F67TMTiC0i0MAkMX92NkgRs8BCJomjE14x
        giSEBZwk7p2cAjaJRUBVovP3BDCbV8BO4vOv+4wQG+QlVm84ABbnFLCX+PPoF9gVQkA1TX8/
        Mk5g5FvAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4ZrS0djDuWfVB7xAjEwfj
        IUYJDmYlEd6VnHuShXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamCacmOvjfq7fU/tEuYzPn8U7/tPfvlr16fnXc9PXi5/crPNLdMi/7XZ65rM+v5euOzr
        9MpLMEVFWSSP6WTTg492KpFth38ulZltU3MswWfh+4kym9u3XOZdVhSx7fCc55vOVqe9beL/
        sW/9pDfMOvWnbHf+Oh7gqLzA9cstd5/OPYe7/n539GJcFXhMPsri6XcdZRHxT1kfBHOW5tpv
        PO9mdKwm6/C/HzueiEXbenwQqOKZ6rqvTEdpisxUH6bowicyYmWnJ178HarSts5gOU/sw2Uu
        D1r5U5fd2OthuPHl3Aevy6t/KhndVQ2SVah3dsgXc7x9mPNrbUYBe3ORu9b/BrYwzZY774zr
        Yt6turVGiaU4I9FQi7moOBEAryHxiwgDAAA=
X-CMS-MailID: 20230111075445epcas5p2b94c8ddc5608c0b20d3d28b049592b4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111075445epcas5p2b94c8ddc5608c0b20d3d28b049592b4a
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
        <CGME20230111075445epcas5p2b94c8ddc5608c0b20d3d28b049592b4a@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 174 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  24 +++
 include/linux/stmmac.h                        |   1 +
 3 files changed, 199 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 358fc26f8d1f..e41b6e849a9d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/stmmac.h>
+#include <linux/regmap.h>
 
 #include "stmmac_platform.h"
 #include "dwmac4.h"
@@ -37,6 +38,45 @@ struct tegra_eqos {
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
+static const int rx_clock_skew_val[] = {0x2, 0x0};
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
@@ -267,6 +307,134 @@ static int tegra_eqos_init(struct platform_device *pdev, void *priv)
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
+static int dwc_eqos_setup_rxclock(struct platform_device *pdev, int ins_num)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct regmap *syscon;
+	unsigned int reg;
+
+	if (np && of_property_read_bool(np, "rx-clock-skew")) {
+		syscon = syscon_regmap_lookup_by_phandle_args(np,
+				"rx-clock-skew", 1, &reg);
+		if (IS_ERR(syscon)) {
+			dev_err(&pdev->dev,
+				"couldn't get the rx-clock-skew syscon!\n");
+			return PTR_ERR(syscon);
+		}
+
+		regmap_write(syscon, reg, rx_clock_skew_val[ins_num]);
+	}
+
+	return 0;
+}
+
+static int fsd_eqos_clk_init(struct fsd_eqos_plat_data *plat,
+			     struct plat_stmmacenet_data *data)
+{
+	int ret = 0, i;
+
+	const struct fsd_eqos_variant *fsd_eqos_variant_data =
+						plat->fsd_eqos_instance_variant;
+
+	plat->clks = devm_kcalloc(plat->dev, fsd_eqos_variant_data->num_clks,
+				  sizeof(*plat->clks), GFP_KERNEL);
+	if (!plat->clks)
+		return -ENOMEM;
+
+	for (i = 0; i < fsd_eqos_variant_data->num_clks; i++)
+		plat->clks[i].id = fsd_eqos_variant_data->clk_list[i];
+
+	ret = devm_clk_bulk_get(plat->dev, fsd_eqos_variant_data->num_clks,
+				plat->clks);
+
+	return ret;
+}
+
+static int fsd_clks_endisable(void *priv, bool enabled)
+{
+	int ret, num_clks;
+	struct fsd_eqos_plat_data *plat = priv;
+
+	num_clks = plat->fsd_eqos_instance_variant->num_clks;
+
+	if (enabled) {
+		ret = clk_bulk_prepare_enable(num_clks, plat->clks);
+		if (ret) {
+			dev_err(plat->dev, "Clock enable failed, err = %d\n", ret);
+			return ret;
+		}
+	} else {
+		clk_bulk_disable_unprepare(num_clks, plat->clks);
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
+	int ret = 0;
+
+	priv_plat = devm_kzalloc(&pdev->dev, sizeof(*priv_plat), GFP_KERNEL);
+	if (!priv_plat) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	priv_plat->dev = &pdev->dev;
+	data->bus_id = of_alias_get_id(np, "eth");
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
+	ret = dwc_eqos_setup_rxclock(pdev, data->bus_id);
+	if (ret) {
+		fsd_clks_endisable(priv_plat, false);
+		dev_err_probe(&pdev->dev, ret, "Unable to setup rxclock\n");
+	}
+
+error:
+	return ret;
+}
+
+static int fsd_eqos_remove(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct fsd_eqos_plat_data *priv_plat = get_stmmac_bsp_priv(&pdev->dev);
+
+	ret = fsd_clks_endisable(priv_plat, false);
+
+	return ret;
+}
+
 static int tegra_eqos_probe(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *data,
 			    struct stmmac_resources *res)
@@ -415,6 +583,11 @@ static const struct dwc_eth_dwmac_data tegra_eqos_data = {
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
@@ -495,6 +668,7 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 static const struct of_device_id dwc_eth_dwmac_match[] = {
 	{ .compatible = "snps,dwc-qos-ethernet-4.10", .data = &dwc_qos_data },
 	{ .compatible = "nvidia,tegra186-eqos", .data = &tegra_eqos_data },
+	{ .compatible = "tesla,dwc-qos-ethernet-4.21", .data = &fsd_eqos_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, dwc_eth_dwmac_match);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 592d29abcb1c..0330647ca8b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3821,6 +3821,12 @@ static int __stmmac_open(struct net_device *dev,
 	netif_tx_start_all_queues(priv->dev);
 	stmmac_enable_all_dma_irq(priv);
 
+	if (priv->plat->rxmux_setup) {
+		ret = priv->plat->rxmux_setup(priv->plat->bsp_priv, true);
+		if (ret)
+			netdev_err(priv->dev, "Rxmux setup failed\n");
+	}
+
 	return 0;
 
 irq_error:
@@ -3874,6 +3880,12 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	if (priv->plat->rxmux_setup) {
+		ret = priv->plat->rxmux_setup(priv->plat->bsp_priv, false);
+		if (ret)
+			netdev_err(priv->dev, "Rxmux setup failed\n");
+	}
+
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -7397,6 +7409,12 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
+	if (priv->plat->rxmux_setup) {
+		ret = priv->plat->rxmux_setup(priv->plat->bsp_priv, false);
+		if (ret)
+			netdev_err(priv->dev, "Rxmux setup failed\n");
+	}
+
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
@@ -7560,6 +7578,12 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
+	if (priv->plat->rxmux_setup) {
+		ret = priv->plat->rxmux_setup(priv->plat->bsp_priv, true);
+		if (ret)
+			netdev_err(priv->dev, "Rxmux setup failed\n");
+	}
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

