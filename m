Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F761C0A7
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 04:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfENC3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 22:29:06 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:11846 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726387AbfENC3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 22:29:06 -0400
X-UUID: 781b2acb1fcd4409801e6ecda65f8466-20190514
X-UUID: 781b2acb1fcd4409801e6ecda65f8466-20190514
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1269660347; Tue, 14 May 2019 10:29:00 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 14 May 2019 10:28:58 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 14 May 2019 10:28:58 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>
Subject: [v2, PATCH 0/4] fix some bugs in stmmac
Date:   Tue, 14 May 2019 10:28:49 +0800
Message-ID: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes in v2:                                                                  
        1. update rx_tail_addr as Jose's comment                                
        2. changes clk_csr condition as Alex's proposition                      
        3. remove init lines in dwmac-mediatek, get clk_csr from dts instead.   
                                                                                
v1:                                                                             
This series fix some bugs in stmmac driver                                      
3 patches are for common stmmac or dwmac4:                                      
        1. update rx tail pointer to fix rx dma hang issue.                     
        2. change condition for mdc clock to fix csr_clk can't be zero issue.   
        3. write the modified value back to MTL_OPERATION_MODE.                 
1 patch is for dwmac-mediatek:                                                  
        modify csr_clk value to fix mdio read/write fail issue for dwmac-mediatek
                                                                                
Biao Huang (4):                                                                 
  net: stmmac: update rx tail pointer register to fix rx dma hang               
    issue.                                                                      
  net: stmmac: fix csr_clk can't be zero issue                                  
  net: stmmac: write the modified value back to MTL_OPERATION_MODE              
  net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio                 
    read/write fail                                                             
                                                                                
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    2 --                   
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    2 ++                   
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    7 ++++---              
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    5 ++++-                
 4 files changed, 10 insertions(+), 6 deletions(-)                              
                                                                                
--                                                                              
1.7.9.5 

