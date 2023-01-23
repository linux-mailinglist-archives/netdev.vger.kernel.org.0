Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC0677762
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjAWJ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjAWJ07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:26:59 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 01:26:53 PST
Received: from securemail.qrnsap.io (securemail.qrsnap.io [50.126.96.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F0718B25;
        Mon, 23 Jan 2023 01:26:53 -0800 (PST)
From:   Reese Russell <git@qrsnap.io>
To:     git@qrsnap.io
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Added Netgear AXE3000 (A8000) usb_device_id to mt7921u_device_table[]
Date:   Mon, 23 Jan 2023 01:05:50 -0800
Message-Id: <20230123090555.21415-1-git@qrsnap.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,TO_EQ_FM_DIRECT_MX autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue: Though the Netgear AXE3000 (A8000) is based on the mt7921
chipset because of the unique USB VID:PID combination this device
does not initialize/register. Thus making it not plug and play.

Fix: Adds support for the Netgear AXE3000 (A8000) based on the Mediatek
mt7921au chipset. The method of action is adding the USD VID/PID
pair to the mt7921u_device_table[] array.

Notes: A retail sample of the Netgear AXE3000 (A8000) yeilds the following
from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This pair
0846:9060 VID:PID has been reported by other users on Github.

Signed-off-by: Reese Russell <git@qrsnap.io>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 5321d20dcdcb..62e9728588f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -15,6 +15,8 @@
 static const struct usb_device_id mt7921u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7961, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ },
 };
 
-- 
2.37.2

