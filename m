Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94ECB144CD9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAVIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:03:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:33426 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgAVIDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:03:30 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M83Qam009733, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (smtpsrv.realtek.com[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M83Qam009733
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 16:03:26 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 16:03:25 +0800
Received: from RTITCASV01.realtek.com.tw (172.21.6.18) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.1779.2
 via Frontend Transport; Wed, 22 Jan 2020 16:03:25 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 16:03:23 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v3 4/9] r8152: disable U2P3 for RTL8153B
Date:   Wed, 22 Jan 2020 16:02:08 +0800
Message-ID: <1394712342-15778-362-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-358-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
 <1394712342-15778-358-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable U2P3 may miss zero packet for bulk-in.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c3217a5c2fe1..bc6b2f8aaa7e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3389,7 +3389,6 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
-		r8153_u2p3en(tp, true);
 		r8153b_u1u2en(tp, true);
 	}
 }
@@ -4688,7 +4687,6 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 	r8153_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
-	r8153_u2p3en(tp, true);
 
 	set_bit(PHY_RESET, &tp->flags);
 }
@@ -5018,7 +5016,6 @@ static void rtl8153b_up(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
 
 	r8153_aldps_en(tp, true);
-	r8153_u2p3en(tp, true);
 	r8153b_u1u2en(tp, true);
 }
 
-- 
2.21.0

