Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3CF20EEFB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgF3HIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:08:05 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:45858 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbgF3HIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 03:08:04 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowAC3OPjl4_peKEhOAQ--.46047S2;
        Tue, 30 Jun 2020 15:04:05 +0800 (CST)
From:   Chen Ni <vulab@iscas.ac.cn>
To:     dsd@gentoo.org, kune@deine-taler.de, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] net: zydas: remove needless check before usb_free_coherent()
Date:   Tue, 30 Jun 2020 07:04:04 +0000
Message-Id: <20200630070404.8207-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowAC3OPjl4_peKEhOAQ--.46047S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFWrZw4UGr47GFWDGFyDWrg_yoWfKrg_Gr
        Z7WFnxXry5Jw109rWUAay3Z39Yya93Xws5WrsaqrW5Wayjq3sxAw1jyry7JrsrGFnYvFnx
        Gw1kJFW8JFySqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_ZcC_Gr8dMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8
        Jr1lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
        x2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0ziiIDnUUUUU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiAxADA13qZLQmfQAAsv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>

usb_free_coherent() is safe with NULL addr and this check is
not required.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 8ff0374126e4..65b5985ad402 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -600,9 +600,7 @@ void zd_usb_disable_int(struct zd_usb *usb)
 	dev_dbg_f(zd_usb_dev(usb), "urb %p killed\n", urb);
 	usb_free_urb(urb);
 
-	if (buffer)
-		usb_free_coherent(udev, USB_MAX_EP_INT_BUFFER,
-				  buffer, buffer_dma);
+	usb_free_coherent(udev, USB_MAX_EP_INT_BUFFER, buffer, buffer_dma);
 }
 
 static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
-- 
2.17.1

