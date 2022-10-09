Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD15F8C4B
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJIQXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJIQXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:23:42 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A622B185;
        Sun,  9 Oct 2022 09:23:40 -0700 (PDT)
X-QQ-mid: bizesmtp62t1665332600t7odh38m
Received: from localhost.localdomain ( [58.247.70.42])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 00:23:19 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: fs34Pe/+C2TRRIMPMY6EuhGRcUlkuDlYD9T688osuzNd+aO2IxqPU9q1csLTw
        eFvw7YdWc7ddI4mcnGNno6LMd5RRTKOU3o4pm59a/QzJ5sg/ZHe/a6ikOh3WroOuMhHt5DW
        BDRWG39HUU+0u/KphSyO8RYDbpquNmiDllqQ/FdmxrFVfLM63tcmJyKRJYhsVUGq9sGDrEW
        jZ5IVnEuu+xs3GW04ZfkSJui5CEaYbYR/YiuuIFd2SJdqIKIGW005aT4rQoNvWQ2MPLfQ6Y
        8x9kpnGSLP/vmbqrJ9AKAJAHJ+8kA2STRwXyD4/g8pKsyencxbVEL4+T8Fb0H9Ulas4V0uc
        Kd89urL8sK2v4GMhlNRSdVdE66v33MF9PdQ3EGjd7CQ1a9D5oxqkdiVD+plLA==
X-QQ-GoodBg: 0
From:   Soha Jin <soha@lohu.info>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yangyu Chen <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Soha Jin <soha@lohu.info>
Subject: [PATCH 2/3] net: stmmac: add Phytium's PHYT0004 to dwmac-generic compatible devices
Date:   Mon, 10 Oct 2022 00:22:46 +0800
Message-Id: <20221009162247.1336-3-soha@lohu.info>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009162247.1336-1-soha@lohu.info>
References: <20221009162247.1336-1-soha@lohu.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phytium's GMAC devices (ACPI HID: PHYT0004) can be run by DWMAC's generic
driver, add it to the match table.

Signed-off-by: Soha Jin <soha@lohu.info>
Tested-by: Yangyu Chen <cyy@cyyself.name>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index 4d272605a8b7..bde827bc7b72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -66,7 +66,7 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static const struct of_device_id dwmac_generic_match[] = {
+static const struct of_device_id dwmac_generic_match_of[] = {
 	{ .compatible = "st,spear600-gmac"},
 	{ .compatible = "snps,dwmac-3.40a"},
 	{ .compatible = "snps,dwmac-3.50a"},
@@ -80,7 +80,13 @@ static const struct of_device_id dwmac_generic_match[] = {
 	{ .compatible = "snps,dwxgmac"},
 	{ }
 };
-MODULE_DEVICE_TABLE(of, dwmac_generic_match);
+MODULE_DEVICE_TABLE(of, dwmac_generic_match_of);
+
+static const struct acpi_device_id dwmac_generic_match_acpi[] = {
+	{"PHYT0004"},
+	{}
+};
+MODULE_DEVICE_TABLE(acpi, dwmac_generic_match_acpi);
 
 static struct platform_driver dwmac_generic_driver = {
 	.probe  = dwmac_generic_probe,
@@ -88,7 +94,8 @@ static struct platform_driver dwmac_generic_driver = {
 	.driver = {
 		.name           = STMMAC_RESOURCE_NAME,
 		.pm		= &stmmac_pltfr_pm_ops,
-		.of_match_table = of_match_ptr(dwmac_generic_match),
+		.of_match_table = dwmac_generic_match_of,
+		.acpi_match_table = dwmac_generic_match_acpi
 	},
 };
 module_platform_driver(dwmac_generic_driver);
-- 
2.30.2

