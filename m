Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A279AAC2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393312AbfHWIxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 04:53:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40111 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393110AbfHWIxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 04:53:32 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7N8rPRd020363, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7N8rPRd020363
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 23 Aug 2019 16:53:25 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Fri, 23 Aug 2019
 16:53:24 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <jslaby@suse.cz>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 1/2] Revert "r8152: napi hangup fix after disconnect"
Date:   Fri, 23 Aug 2019 16:53:01 +0800
Message-ID: <1394712342-15778-315-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-314-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0ee1f4734967af8321ecebaf9c74221ace34f2d5.

This conflicts with commit ffa9fec30ca0 ("r8152: set
RTL8152_UNPLUG only for real disconnection").

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0cc03a9ff545..690a24d1ef82 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4018,8 +4018,7 @@ static int rtl8152_close(struct net_device *netdev)
 #ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&tp->pm_notifier);
 #endif
-	if (!test_bit(RTL8152_UNPLUG, &tp->flags))
-		napi_disable(&tp->napi);
+	napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
 	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);
-- 
2.21.0

