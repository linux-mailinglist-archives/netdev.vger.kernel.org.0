Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214E465FCAC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjAFIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAFIYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:24:15 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62598625E5
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:24:09 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 141so763863pgc.0
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sn4vclDppemT9HR5gllHV02avqYoKes1VuAorkVaAhE=;
        b=OykugGdeI1b8varXjNUGA0/rpqGUPfzdg+fuKc86CijoX97iiNxiUaB1a5FyMRbHpE
         EF8ToHEaLAZL0A0/CZ7DiLTtXKnQ49rVaVHct5iIEuCp4C0CG4t3m14a679TXzwRZVH1
         V2hYCctcETH0M59MLNvU0qQQ1njL4BslQr6asa3tXAOs/EN9hHKZ1sS9sVxVsp4WUEWN
         rO8TkmL/IE0Iw7n1Dwkk0MM8ECrfx9lB9dZm+5TeUmhSyVzm0hcgN2t474pE87escejh
         nxn20rq0+xKrglwpQUM+xSlssHI6Mj+lRJz2DWW0giID1mpY7s7ydck5/QJ3HRzcdXdZ
         56sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sn4vclDppemT9HR5gllHV02avqYoKes1VuAorkVaAhE=;
        b=0UvI/IZcy8zRmtdz0S3Q/ilU5SFSDh2D+yYDZ06ZS3WuMUG4RSGadPaH7/gBA8qrP+
         hpP1l6LfeQArrGB2/rfhjDUgR6Yi20nTMLqokCTVrJWBc0ItOiVhdhPcIARON5v8Yk+B
         n5E4R30KaYstEGhUy2ZvqqTSadS8N8InR7yBZiKxxbJ/VXQGTMO6z20cGHeiinFd2w7Z
         usvKlpLG7YkF1ppP+SqSXZlqrwOZhj+Y7Rr5tA8ppGqLhjNlaaMjOb9nKOiaed2t8tvu
         GYAD53dC+q/SJWQPo3DZivtcl5OzdorIeh76bsPzOAm2XPclgU5TI2CmQoIJ3GJsiI4m
         p8nQ==
X-Gm-Message-State: AFqh2kq8sx/dpNNHI2uOphwAobXayCttBDyikACgNFSIU0HLhZo5nSem
        JBjYmNnIns8VKDjfm5pAr26VXlsTmqBq849IAlUSMQ==
X-Google-Smtp-Source: AMrXdXtJ5r42tjQvO6OFDqB4LOX+Ip4QPuWMXWJZ/i+4OziaHIhAnKEaS0HEHFYnbUzhoXZPUYNGpQ==
X-Received: by 2002:a05:6a00:3247:b0:576:65f5:c60a with SMTP id bn7-20020a056a00324700b0057665f5c60amr47625335pfb.27.1672993448756;
        Fri, 06 Jan 2023 00:24:08 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id j123-20020a62c581000000b00576d76c9927sm557240pfg.106.2023.01.06.00.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:24:08 -0800 (PST)
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     kuba@kernel.org, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        lauro.venancio@openbossa.org, linville@tuxdriver.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: [PATCH net v2] nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()
Date:   Fri,  6 Jan 2023 17:23:44 +0900
Message-Id: <20230106082344.357906-1-linuxlovemin@yonsei.ac.kr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a use-after-free that occurs in hcd when in_urb sent from
pn533_usb_send_frame() is completed earlier than out_urb. Its callback
frees the skb data in pn533_send_async_complete() that is used as a
transfer buffer of out_urb. Wait before sending in_urb until the
callback of out_urb is called. To modify the callback of out_urb alone,
separate the complete function of out_urb and ack_urb.

Found by a modified version of syzkaller.

BUG: KASAN: use-after-free in dummy_timer
Call Trace:
 memcpy (mm/kasan/shadow.c:65)
 dummy_perform_transfer (drivers/usb/gadget/udc/dummy_hcd.c:1352)
 transfer (drivers/usb/gadget/udc/dummy_hcd.c:1453)
 dummy_timer (drivers/usb/gadget/udc/dummy_hcd.c:1972)
 arch_static_branch (arch/x86/include/asm/jump_label.h:27)
 static_key_false (include/linux/jump_label.h:207)
 timer_expire_exit (include/trace/events/timer.h:127)
 call_timer_fn (kernel/time/timer.c:1475)
 expire_timers (kernel/time/timer.c:1519)
 __run_timers (kernel/time/timer.c:1790)
 run_timer_softirq (kernel/time/timer.c:1803)

Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
---
v1->v2
  Add file names and line numbers in the stack trace.
  Put the completion struct for out_urb on the stack.

 drivers/nfc/pn533/usb.c | 44 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 6f71ac72012e..ed9c5e2cf3ad 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -153,10 +153,17 @@ static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
 	return usb_submit_urb(phy->ack_urb, flags);
 }
 
+struct pn533_out_arg {
+	struct pn533_usb_phy *phy;
+	struct completion done;
+};
+
 static int pn533_usb_send_frame(struct pn533 *dev,
 				struct sk_buff *out)
 {
 	struct pn533_usb_phy *phy = dev->phy;
+	struct pn533_out_arg arg;
+	void *cntx;
 	int rc;
 
 	if (phy->priv == NULL)
@@ -168,10 +175,17 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	init_completion(&arg.done);
+	cntx = phy->out_urb->context;
+	phy->out_urb->context = &arg;
+
 	rc = usb_submit_urb(phy->out_urb, GFP_KERNEL);
 	if (rc)
 		return rc;
 
+	wait_for_completion(&arg.done);
+	phy->out_urb->context = cntx;
+
 	if (dev->protocol_type == PN533_PROTO_REQ_RESP) {
 		/* request for response for sent packet directly */
 		rc = pn533_submit_urb_for_response(phy, GFP_KERNEL);
@@ -408,7 +422,31 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	return arg.rc;
 }
 
-static void pn533_send_complete(struct urb *urb)
+static void pn533_out_complete(struct urb *urb)
+{
+	struct pn533_out_arg *arg = urb->context;
+	struct pn533_usb_phy *phy = arg->phy;
+
+	switch (urb->status) {
+	case 0:
+		break; /* success */
+	case -ECONNRESET:
+	case -ENOENT:
+		dev_dbg(&phy->udev->dev,
+			"The urb has been stopped (status %d)\n",
+			urb->status);
+		break;
+	case -ESHUTDOWN:
+	default:
+		nfc_err(&phy->udev->dev,
+			"Urb failure (status %d)\n",
+			urb->status);
+	}
+
+	complete(&arg->done);
+}
+
+static void pn533_ack_complete(struct urb *urb)
 {
 	struct pn533_usb_phy *phy = urb->context;
 
@@ -496,10 +534,10 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
 	usb_fill_bulk_urb(phy->out_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_out_complete, phy);
 	usb_fill_bulk_urb(phy->ack_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_ack_complete, phy);
 
 	switch (id->driver_info) {
 	case PN533_DEVICE_STD:
-- 
2.25.1

