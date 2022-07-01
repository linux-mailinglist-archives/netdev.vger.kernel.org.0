Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0B15628BC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 04:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiGACIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 22:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiGACIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 22:08:13 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29308BF56;
        Thu, 30 Jun 2022 19:08:12 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 1D5EA1E80D21;
        Fri,  1 Jul 2022 10:06:45 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j6CcEk6owDcw; Fri,  1 Jul 2022 10:06:42 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 592AA1E80D09;
        Fri,  1 Jul 2022 10:06:42 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] net: usb: Fix typo in code
Date:   Fri,  1 Jul 2022 10:07:51 +0800
Message-Id: <20220701020751.3059-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hasdata does not need to be initialized to zero. It will be assigned a
value in the following judgment conditions.
Remove the repeated ';' from code.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/net/usb/catc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index e7fe9c0f63a9..268c32521691 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -280,7 +280,7 @@ static void catc_irq_done(struct urb *urb)
 	struct catc *catc = urb->context;
 	u8 *data = urb->transfer_buffer;
 	int status = urb->status;
-	unsigned int hasdata = 0, linksts = LinkNoChange;
+	unsigned int hasdata, linksts = LinkNoChange;
 	int res;
 
 	if (!catc->is_f5u011) {
@@ -335,7 +335,7 @@ static void catc_irq_done(struct urb *urb)
 		} 
 	}
 resubmit:
-	res = usb_submit_urb (urb, GFP_ATOMIC);
+	res = usb_submit_urb(urb, GFP_ATOMIC);
 	if (res)
 		dev_err(&catc->usbdev->dev,
 			"can't resubmit intr, %s-%s, status %d\n",
@@ -781,7 +781,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 			intf->altsetting->desc.bInterfaceNumber, 1)) {
 		dev_err(dev, "Can't set altsetting 1.\n");
 		ret = -EIO;
-		goto fail_mem;;
+		goto fail_mem;
 	}
 
 	netdev = alloc_etherdev(sizeof(struct catc));
-- 
2.18.2

