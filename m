Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CFF614473
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 07:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKAGCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 02:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAGCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 02:02:33 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B88F6E50;
        Mon, 31 Oct 2022 23:02:30 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.77])
        by gateway (Coremail) with SMTP id _____8Dx_7dztmBjt7oDAA--.11588S3;
        Tue, 01 Nov 2022 14:02:27 +0800 (CST)
Received: from loongson-PC.loongson.cn (unknown [10.20.42.77])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxb+JqtmBjCVwJAA--.28915S2;
        Tue, 01 Nov 2022 14:02:26 +0800 (CST)
From:   Liu Peibao <liupeibao@loongson.cn>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     chenhuacai@loongson.cn, lvjianmin@loongson.cn,
        zhuyinbo@loongson.cn, liupeibao@loongson.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] stmmac: dwmac-loongson: fix invalid mdio_node
Date:   Tue,  1 Nov 2022 14:02:18 +0800
Message-Id: <20221101060218.16453-1-liupeibao@loongson.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxb+JqtmBjCVwJAA--.28915S2
X-CM-SenderInfo: xolx1vpled0qxorr0wxvrqhubq/1tbiAQARCmNfuuMNGgADsr
X-Coremail-Antispam: 1Uk129KBjvJXoW7tF45JFyxKry3tr15GFW3Jrb_yoW8Ww4Upw
        4fCa4akr9IgrW7Ca1DXr4DXFy5u3yUt39rGr4Iya9a9a9YyrWjqry2gFWUAF1xArZ5C3W2
        vr109w1UGF1DAwUanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bS8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxV
        Aaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY
        O2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
        WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
        JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rV
        WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4U
        YxBIdaVFxhVjvjDU0xZFpf9x07jeq2NUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In current code "plat->mdio_node" is always NULL, the mdio
support is lost as there is no "mdio_bus_data". The original
driver could work as the "mdio" variable is never set to
false, which is described in commit <b0e03950dd71> ("stmmac:
dwmac-loongson: fix uninitialized variable ......"). And
after this commit merged, the "mdio" variable is always
false, causing the mdio supoort logic lost.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 017dbbda0c1c..79fa7870563b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -51,7 +51,6 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	struct stmmac_resources res;
 	struct device_node *np;
 	int ret, i, phy_mode;
-	bool mdio = false;
 
 	np = dev_of_node(&pdev->dev);
 
@@ -69,12 +68,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (!plat)
 		return -ENOMEM;
 
+	plat->mdio_node = of_get_child_by_name(np, "mdio");
 	if (plat->mdio_node) {
-		dev_err(&pdev->dev, "Found MDIO subnode\n");
-		mdio = true;
-	}
+		dev_info(&pdev->dev, "Found MDIO subnode\n");
 
-	if (mdio) {
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-- 
2.20.1

