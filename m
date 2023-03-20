Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB836C1D37
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjCTRGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjCTRGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3709CAD2A;
        Mon, 20 Mar 2023 10:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 632BFB80FA1;
        Mon, 20 Mar 2023 16:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18A6C433EF;
        Mon, 20 Mar 2023 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331530;
        bh=Y6Q/iyRpxsM6GbYW4pCc03xs1NL2o4Kl7pnVJaab2SE=;
        h=From:To:Cc:Subject:Date:From;
        b=AklPzVp74sE6Evcat2CmPbGAuFhktDsu2dFYccO1BOxaF+kQdtbGn+d/yN/Hjxl0S
         b9oGXFuHfFXO0wYRA6vw7jSGCpQ0+yVWXTl/XYgVmQ0Hl2cgpwl/Li8QU/KA75nURo
         YHExw7t8JBj83eS8n6IxexP4zyemYJz6Gs1t5ONFeO4p9cSRIv6N6jtTDWbry7rueB
         mhZi+6m68Z48JIPGtn5WU0cp0iRqYiEjXL5esWcr4M7IhzQs2psE40Dn9noA0qB78I
         u3+nu/RPy7JfybbZsoTJJ2rXQuvvyZACKeU/mkyjF3elAtY+VuDl1mZhy54Be95Lr8
         sSnYun4lpylAQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in dedicated dts nodes
Date:   Mon, 20 Mar 2023 17:57:54 +0100
Message-Id: <cover.1679330630.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since cpuboot, ilm and dlm memory region are not part of MT7986 SoC RAM,
move them in dedicated mt7986a syscon dts nodes.
This series helps to keep backward-compatibility with older version of uboot
codebase where we have a limit of 8 reserved-memory dts child nodes.
At the same time we keep backward-compatibility with older dts version where
cpuboot, ilm and dlm were defined as reserved-memory child nodes.

Lorenzo Bianconi (10):
  net: ethernet: mtk_wed: rename mtk_wed_get_memory_region in
    mtk_wed_get_reserved_memory_region
  net: ethernet: mtk_wed: move cpuboot in a dedicated dts node
  dt-bindings: soc: mediatek: move cpuboot in a dedicated dts node
  arm64: dts: mt7986: move cpuboot in a dedicated node
  net: ethernet: mtk_wed: move ilm a dedicated dts node
  dt-bindings: soc: mediatek: move ilm in a dedicated dts node
  arm64: dts: mt7986: move ilm in a dedicated node
  net: ethernet: mtk_wed: move dlm a dedicated dts node
  dt-bindings: soc: mediatek: move dlm in a dedicated dts node
  arm64: dts: mt7986: move dlm in a dedicated node

 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 30 ++++---
 .../mediatek/mediatek,mt7986-wo-cpuboot.yaml  | 45 ++++++++++
 .../soc/mediatek/mediatek,mt7986-wo-dlm.yaml  | 46 ++++++++++
 .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 ++++++++++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     | 69 +++++++-------
 drivers/net/ethernet/mediatek/mtk_wed.c       | 19 ++++
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c   | 89 ++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_wed_wo.h    |  3 +-
 8 files changed, 289 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml

-- 
2.39.2

