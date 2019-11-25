Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD34E109073
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfKYOy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:54:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:44701 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbfKYOy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 09:54:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id w8so6703744pjh.11;
        Mon, 25 Nov 2019 06:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=Jdw2j/a/FE7gm5TNDBAcYPcU6FC63DMfZkzIU2VewEVpDhpApGP68i6gMhmkchbj+e
         l9S/ObcbNdRRWkz9zjXvcjpumCg6Q+s3ovDV3hdAD5ukAQxUKFE+DBqMouqqmV7//JRS
         u70bH5VOM6X/FhPHXVK2DsOfN846AeJlhlwzqTeQZqnqg+P6MuUbZwfXf6E8R60XlV1k
         jaWMBGsRfvyi9WXECVjImiUV49x/EQJDfz9AYf173Dhl3+k5aWRW4hNsoR2GMOEWWZ8T
         urn0QqrPGKG56T2cNiQT8AM2lGT/Gm+UU0LG8csbNgsuXMFrtC5MMEO75bNyoGbtFqRj
         qq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=b2nT1OAdwBRDrkcyh8nV2g5U7D0uEL1/KWU+cFL8aOT1Vc4UmOxj7jWDFubEOs07eH
         P2lS+tkb39ZwoiPryjDe2uHkWIgNAHQU2TpmRc5Pdc5Y3BesrOBd/tPy6Wq5bjutik+4
         GfiaUdghqRF+cgmK3D2xgTKgDyprn0OuYpPoP1gvdrOB7KFt1kvcyACK2pGs2SvgvaBk
         5PsHv4w1e6L/9hpcEamCdUti6BlTzAUjUIm9bO+zYOB1xcZWnCw3JSnq/XDgVgtMBwyu
         ztzTcaoUsZFmVVDMTgviqeHSz11b2PMm0F1NjueTGILbWDZdcpZEG+fjSR6/KjpdgUti
         rdlA==
X-Gm-Message-State: APjAAAUG3nMKGXbg4qI1xh7ZN+7td6VpVLlMRzK4WvuzFe0FXE9jX2Yd
        ns7DKQ2AmNfZn17G7ShaI5k=
X-Google-Smtp-Source: APXvYqyvHsHilf9t9KOojG+Pmwy271uQOp5mfMAs/WTxSrCm8y4S1x9ROHjYVuUHeXAar9XL5xb1wQ==
X-Received: by 2002:a17:90a:d155:: with SMTP id t21mr38128482pjw.84.1574693697671;
        Mon, 25 Nov 2019 06:54:57 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id j4sm8623602pgt.57.2019.11.25.06.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:54:56 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, oneukum@suse.com
Cc:     alexios.zavras@intel.com, johan@kernel.org, allison@lohutok.net,
        tglx@linutronix.de, benquike@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 1/2] drivers: net: hso: Fix -Wcast-function-type
Date:   Mon, 25 Nov 2019 21:54:42 +0700
Message-Id: <20191125145443.29052-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/hso.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 74849da031fa..ca827802f291 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1214,8 +1214,9 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(struct hso_serial *serial)
+static void hso_unthrottle_tasklet(unsigned long data)
 {
+	struct hso_serial *serial = (struct hso_serial *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1265,7 +1266,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
 		tasklet_init(&serial->unthrottle_tasklet,
-			     (void (*)(unsigned long))hso_unthrottle_tasklet,
+			     hso_unthrottle_tasklet,
 			     (unsigned long)serial);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
-- 
2.20.1

