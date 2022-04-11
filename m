Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901994FB92A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345181AbiDKKQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345176AbiDKKQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ECC42A26;
        Mon, 11 Apr 2022 03:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F2F0613F5;
        Mon, 11 Apr 2022 10:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D741AC385A3;
        Mon, 11 Apr 2022 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649672025;
        bh=oG1NBLa6Pa4sLeuqHrZskjNq1N1hcQVmn0kQO/mGzI4=;
        h=From:To:Cc:Subject:Date:From;
        b=fCKWZH1pcefEFpALbSsH9D4XaBY/NJ0mDIAtrwPMSgCb+eC6z9kZD2FQ/8v7Lz7gl
         qWp4gWt0Rt5VXDGlcNhXdJCK4MI6eSbplcgBmVJAT7Ix6wY9UhCNLdyldpr7Jh+N8f
         X1ii0gY1OSOaq3FMVmF7y09nmq8i+EB1KLsYQCBbNsXNV65meVt50vF6zVyrJU0QY3
         1zQvXCTTuG+RKr1umF8oN84PIg18ykyc68bUCX4lt6atm8y3bRRwrC2iEw+PKXRchz
         Tj/PW3JWJFRoNlO8RGFBs5X3jo8qwXtcqzfy944bIu9jpPDxbe/k0TX23UTpBcKjzG
         hQFhcSMpYqqZQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh@kernel.org, devicetree@vger.kernel.org,
        nbd@nbd.name
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: use standard property for cci-control-port
Date:   Mon, 11 Apr 2022 12:13:25 +0200
Message-Id: <40598de79a6317fdd3a44dfe29ce4223e1e0d3ed.1649671814.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on standard cci-control-port property to identify CCI port
reference.
Update mt7622 dts binding.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi    | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 47d223e28f8d..f232f8baf4e8 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -970,7 +970,7 @@ eth: ethernet@1b100000 {
 		power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
-		mediatek,cci-control = <&cci_control2>;
+		cci-control-port = <&cci_control2>;
 		mediatek,wed = <&wed0>, <&wed1>;
 		mediatek,pcie-mirror = <&pcie_mirror>;
 		mediatek,hifsys = <&hifsys>;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 209d00f56f62..18eebcaa6a76 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3149,7 +3149,7 @@ static int mtk_probe(struct platform_device *pdev)
 		struct regmap *cci;
 
 		cci = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-						      "mediatek,cci-control");
+						      "cci-control-port");
 		/* enable CPU/bus coherency */
 		if (!IS_ERR(cci))
 			regmap_write(cci, 0, 3);
-- 
2.35.1

