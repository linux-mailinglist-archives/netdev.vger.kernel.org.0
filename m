Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905745744C0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiGNGA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiGNGAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:00:23 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DCD2F001;
        Wed, 13 Jul 2022 23:00:21 -0700 (PDT)
X-UUID: 38d780fcad1d432babaf4905bbf1effd-20220714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:ef59268c-cf53-4920-9f4b-67217ab792ca,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:100
X-CID-INFO: VERSION:1.1.8,REQID:ef59268c-cf53-4920-9f4b-67217ab792ca,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:100
X-CID-META: VersionHash:0f94e32,CLOUDID:20dd75d7-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:425824298e3e,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 38d780fcad1d432babaf4905bbf1effd-20220714
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 422873143; Thu, 14 Jul 2022 14:00:17 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 14 Jul 2022 14:00:16 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 14 Jul 2022 14:00:16 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Subject: [PATCH net v5 0/3] stmmac: dwmac-mediatek: fix clock issue
Date:   Thu, 14 Jul 2022 14:00:11 +0800
Message-ID: <20220714060014.18958-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes in v5:
1. add reivewd-by as Matthias's comments.
2. fix "warning: unused variable 'ret' [-Wunused-variable]" as Jakub's comments

changes in v4:
1. improve commit message and test ko insertion/remove as Matthias's comments.
2. add patch "net: stmmac: fix pm runtime issue in stmmac_dvr_remove()" to
   fix vlan filter deletion issue.
3. add patch "net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow"
   to fix unbalanced ptp clock issue in suspend/resume flow.

changes in v3:
1. delete mediatek_dwmac_exit() since there is no operation in it,
as Matthias's comments.

changes in v2:
1. clock configuration is still needed in probe,
and invoke mediatek_dwmac_clks_config() instead.
2. update commit message.

v1:
remove duplicated clock configuration in init/exit.

Biao Huang (3):
  stmmac: dwmac-mediatek: fix clock issue
  net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
  net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 49 ++++++++-----------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++++-----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  8 ++-
 3 files changed, 39 insertions(+), 40 deletions(-)

-- 
2.25.1


