Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4623555F381
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiF2Cvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF2Cvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:51:31 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A47E21E3B;
        Tue, 28 Jun 2022 19:51:23 -0700 (PDT)
X-UUID: cafb5ac551f6492ab5e501390c2468b9-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:8357c842-e7b8-4e02-902f-237a7021c497,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:100
X-CID-INFO: VERSION:1.1.7,REQID:8357c842-e7b8-4e02-902f-237a7021c497,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:100
X-CID-META: VersionHash:87442a2,CLOUDID:d70e1ad6-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:4a760a6ba097,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: cafb5ac551f6492ab5e501390c2468b9-20220629
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 53977515; Wed, 29 Jun 2022 10:51:13 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 29 Jun 2022 10:51:12 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 10:51:11 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v4 00/10] add more features for mtk-star-emac
Date:   Wed, 29 Jun 2022 10:50:59 +0800
Message-ID: <20220629025109.21933-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v4:
1. correct the usage of spin_lock/__napi_schedule.
2. fix coding style as Jakub's comments.

Changes in v3:
1. refractor driver as Jakub's comments in patch
   "net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs".
2. add acked-by as Rob's comments.
3. add a new patch for halp-duplex support in driver.

Changes in v2:
1. fix coding style as Bartosz's comments.
2. add reviewed-by as Bartosz's comments.

This series add more features for mtk-star-emac:
1. add reference clock pad selection for RMII;
2. add simple timing adjustment for RMII;
3. add support for MII;
4. add support for new IC MT8365;
5. separate tx/rx interrupt handling.

Biao Huang (10):
  net: ethernet: mtk-star-emac: store bit_clk_div in compat structure
  net: ethernet: mtk-star-emac: modify IRQ trigger flags
  net: ethernet: mtk-star-emac: add support for MT8365 SoC
  dt-bindings: net: mtk-star-emac: add support for MT8365
  net: ethernet: mtk-star-emac: add clock pad selection for RMII
  net: ethernet: mtk-star-emac: add timing adjustment support
  dt-bindings: net: mtk-star-emac: add description for new properties
  net: ethernet: mtk-star-emac: add support for MII interface
  net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs
  net: ethernet: mtk-star-emac: enable half duplex hardware support

 .../bindings/net/mediatek,star-emac.yaml      |  17 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 532 ++++++++++++------
 2 files changed, 373 insertions(+), 176 deletions(-)

-- 
2.18.0


