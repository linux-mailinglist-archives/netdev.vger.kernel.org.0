Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4388265D240
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjADMSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjADMS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA0111805
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:18:26 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id b145so18605536pfb.2
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 04:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CfjGbj2lhgNb15cBHMqIlY+4XQ8hcmxd6tQTjrz+Asg=;
        b=jB66rVeWuYbTaFuQsw5CGk64zF0jb58okMQxYCcxYd9P+S2yLWbxybislnesORXHDH
         P+XAJvCXzzutu4DRCvReuYeZq4cnTI7fk/iHzSc/pNHrtNWc+BNrQKuAuNAaa42bxcYc
         s3dT5oSKGoSjLfZagYuoTEgumtcGcT8yHrT8hb/FcyHwfT/GLr0HLRUZn8OrQYYAinO3
         h+MuyOIUAa237uilAGwBpWFpWXbf6U4JiX+IgK6i8efAJv++caT3525Rj+5cmHfPJNYC
         7hcEInIrq22sUdXbx1ki19abaxCGQO/KMPdaAFE0GjvPrtUYP7Nnyndnbh6P++bTDHdk
         W1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfjGbj2lhgNb15cBHMqIlY+4XQ8hcmxd6tQTjrz+Asg=;
        b=FVb+R5UgaWfQECO5ep3NqR5xQRUFKc1SA7KyrVaHJi3XSJRgUQ5lHBj9WcgUSvm3OP
         2mALyRFyDGPU4CR2PHBE2sqlOHobJokET+E0U3sDx4YszgPdjmW2V2Y+2F6V4peDG3L9
         dHeyVs1XDKgTDsWcGtPg96x3lapItslBIw29C2sRIEoxq7e54mqsFM6POQHzggJlvyZF
         P31dnYSwJ77Wq/RsjoQRCpzj7pD4yzOloCG4PW9zuNxy2a9d/wk6W86yuSGbJncb/acg
         kFP/EVFE8uCyeeP6ehrXQcx1/gJ9BPrznWxySNJm79UEH5JeT93S3mLYARC0rJS38wDv
         lXog==
X-Gm-Message-State: AFqh2kp41wG+NSWEiDZSGRtFWaAdsobSobXekFgwSXNXA4JFKhJKBvAT
        9kB1e4dMXG3Ttf5KYly3Pdvm/g==
X-Google-Smtp-Source: AMrXdXshs8BAcFi+lFpQ/Fy/MCLYOSnZanE+X8vWl3gghlM5TaEsHFtxa5yJZksKGlcShbjNJWT/Cw==
X-Received: by 2002:a62:e911:0:b0:581:579d:5c44 with SMTP id j17-20020a62e911000000b00581579d5c44mr29162595pfh.5.1672834705427;
        Wed, 04 Jan 2023 04:18:25 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id z28-20020aa79e5c000000b0058215708d57sm9327461pfq.141.2023.01.04.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 04:18:25 -0800 (PST)
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        lauro.venancio@openbossa.org, linville@tuxdriver.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: [PATCH net] nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()
Date:   Wed,  4 Jan 2023 21:17:11 +0900
Message-Id: <20230104121711.7809-1-linuxlovemin@yonsei.ac.kr>
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
 memcpy
 dummy_timer
 call_timer_fn
 run_timer_softirq
 __do_softirq
 irq_exit_rcu
 sysvec_apic_timer_interrupt

Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
---
 drivers/nfc/pn533/usb.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 6f71ac72012e..325818fbaf3b 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -48,6 +48,8 @@ struct pn533_usb_phy {
 	struct usb_interface *interface;
 
 	struct urb *out_urb;
+	struct completion *out_done;
+
 	struct urb *in_urb;
 
 	struct urb *ack_urb;
@@ -157,6 +159,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 				struct sk_buff *out)
 {
 	struct pn533_usb_phy *phy = dev->phy;
+	struct completion out_done;
 	int rc;
 
 	if (phy->priv == NULL)
@@ -168,10 +171,15 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	phy->out_done = &out_done;
+	init_completion(&out_done);
+
 	rc = usb_submit_urb(phy->out_urb, GFP_KERNEL);
 	if (rc)
 		return rc;
 
+	wait_for_completion(&out_done);
+
 	if (dev->protocol_type == PN533_PROTO_REQ_RESP) {
 		/* request for response for sent packet directly */
 		rc = pn533_submit_urb_for_response(phy, GFP_KERNEL);
@@ -408,7 +416,30 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	return arg.rc;
 }
 
-static void pn533_send_complete(struct urb *urb)
+static void pn533_out_complete(struct urb *urb)
+{
+	struct pn533_usb_phy *phy = urb->context;
+
+	complete(phy->out_done);
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
+}
+
+static void pn533_ack_complete(struct urb *urb)
 {
 	struct pn533_usb_phy *phy = urb->context;
 
@@ -496,10 +527,10 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
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

