Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93516D2137
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbjCaNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjCaNNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3621B1A47B;
        Fri, 31 Mar 2023 06:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B0862906;
        Fri, 31 Mar 2023 13:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E90FC433D2;
        Fri, 31 Mar 2023 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268408;
        bh=J0jYdD4GFbRNZgMq6swXWLS5Vv9lQ1S0Ja+zV3iG0pk=;
        h=From:To:Cc:Subject:Date:From;
        b=UYmcVABExLetFpnwTrefBjodSMN54HPtHQto4VdrAb1+3ykXSCDg9XYjwkFA2NUGH
         1xiMdkY5q0lt3NP3MaUk9WET8c1LJb3RkrAbaAKrzRucCzxUKG+PIRF+GM03lvJf7N
         FN2S2nM1kgKL2ApO0z2bkjvpGLTRjdU3MdYFV1ZtcM7HaZ0Tfiqgwgb9hZvWGQDmEc
         8H/wrHW1nJZzvH5pSqDX5V4ZnXmt92K4FxpmXMkQdG9Re6rmcLb6dKc6T6/QNpvpce
         4I71mzdjvuC38rcVV47G4PZXEuXaW7ZJJh0nLXV+MfAuKdKeKSDgIXzI0AZyO9c91k
         reMa0OKh6ITzw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in dedicated dts nodes
Date:   Fri, 31 Mar 2023 15:12:36 +0200
Message-Id: <cover.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since cpuboot, ilm and dlm memory region are not part of MT7986 SoC RAM,
move them in dedicated mt7986a syscon dts nodes.
At the same time we keep backward-compatibility with older dts version where
cpuboot, ilm and dlm were defined as reserved-memory child nodes.

Changes since v1:
- fix dts schema compilation error
- rebase on top of net-next

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

