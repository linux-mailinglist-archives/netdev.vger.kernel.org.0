Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2500B32E4F6
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCEJfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:35:17 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60630 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCEJfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:35:02 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1259YwRF2026101, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1259YwRF2026101
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 5 Mar 2021 17:34:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 5 Mar 2021
 17:34:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8169: fix r8168fp_adjust_ocp_cmd function
Date:   Fri, 5 Mar 2021 17:34:41 +0800
Message-ID: <1394712342-15778-348-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The (0xBAF70000 & 0x00FFF000) << 6 should be (0xf70 << 18).

Fixes: 561535b0f239 ("r8169: fix OCP access on RTL8117")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f704da3f214c..7aad0ba53372 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -767,7 +767,7 @@ static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int typ
 	if (type == ERIAR_OOB &&
 	    (tp->mac_version == RTL_GIGA_MAC_VER_52 ||
 	     tp->mac_version == RTL_GIGA_MAC_VER_53))
-		*cmd |= 0x7f0 << 18;
+		*cmd |= 0xf70 << 18;
 }
 
 DECLARE_RTL_COND(rtl_eriar_cond)
-- 
2.26.2

