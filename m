Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CDED39F1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 09:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJKHVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 03:21:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44987 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfJKHVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 03:21:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id q15so4034396pll.11;
        Fri, 11 Oct 2019 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZEe+doT9RkH0Sc3++Qlx3Z67qWPEyfcCZdqfrOnL/uU=;
        b=M5bg+vUFq7KUP5I736VPJC9Xc3g0O3vNA2PuVRZyC6JfxYuarQxjrgin6pccPPweZr
         d9C5bLFcgxo5iGWEIW7Hj5fM9IjSlMumoeq0u+ZluO1FlSQ1u+Vqk6UHD1K5jHGVwCYv
         uBo12VZe5Pp+Z9FHAEwlR1aRwGrt/Dr/z9hkRS4PpZ2dm5cuAgp42WmG7y8GYEVO8r2w
         pxJrWixePtbialIzXsNAOLQksBymPngWaCEHMZL6ayrshZInguLi5SHKHgiRPzHoAxZv
         o7E/YihhTxsFQcUPYpDDnFMbAB5qWOth/Yxtt5L2pwq870tgfD05BlTmxajRz5IMcrOL
         bq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZEe+doT9RkH0Sc3++Qlx3Z67qWPEyfcCZdqfrOnL/uU=;
        b=NqL2vRUnaErvZ3nmuk4NUmeSNd7IppXuub71fnkACHFtertCb38+LuAwj1hGYw2MU0
         necTmeI+YGNFvj+X+3olYMTm5pgvdCfJi6bodfffIyLqEpA33taRmBHSHWOIFdHLNXek
         n4eWgbzflecwKhAVfLYoiRnuteolYQB8eav+uYjzQyF1pRhYsLN/Azd/RjSyHAorqGA0
         EV5LngAWD332bweG/7r1b9X7eR5KHiy6d30mVSWyqloxqoNw6Xmutlmp+RBwC+zra4Wy
         qhjqErhnbES+r9FLtrwrT2mOrKqrXqpX2rvWrffFa3Oo4QuMXWp6bjmHYx1grvfsuhZG
         IppA==
X-Gm-Message-State: APjAAAUN8MwVDxlV9+HwKOFZh1v1lqv65c9oGK+hBZC6aaP8ahy6lftm
        q/BDo0kFDNbUU+9PMNenVXY=
X-Google-Smtp-Source: APXvYqxzNWoid5FdHTj5xn8IMd+0zxKDaORdqb981siIbDQkALU0PRx+A3uZO0b3g0WrcZH1kdbx6Q==
X-Received: by 2002:a17:902:bb92:: with SMTP id m18mr13060501pls.297.1570778462901;
        Fri, 11 Oct 2019 00:21:02 -0700 (PDT)
Received: from wambui.zuku.co.ke ([197.237.61.225])
        by smtp.googlemail.com with ESMTPSA id 20sm8359126pfp.153.2019.10.11.00.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 00:21:02 -0700 (PDT)
From:   Wambui Karuga <wambui.karugax@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, Wambui Karuga <wambui.karugax@gmail.com>
Subject: [PATCH] staging: isdn: remove assignment in if conditionals
Date:   Fri, 11 Oct 2019 10:20:44 +0300
Message-Id: <20191011072044.7022-1-wambui.karugax@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove variable assignment in if statements in
drivers/staging/isdn/avm/b1.c.
Issues reported by checkpatch.pl as:
ERROR: do not use assignment in if condition

Also refactor code around some if statements to remove comparisons
to NULL and unnecessary braces in single statement blocks.

Signed-off-by: Wambui Karuga <wambui.karugax@gmail.com>
---
 drivers/staging/isdn/avm/b1.c | 41 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/isdn/avm/b1.c b/drivers/staging/isdn/avm/b1.c
index 40ca1e8fa09f..32ec8cf31fd0 100644
--- a/drivers/staging/isdn/avm/b1.c
+++ b/drivers/staging/isdn/avm/b1.c
@@ -261,9 +261,10 @@ int b1_loaded(avmcard *card)
 	b1_put_byte(base, SEND_POLL);
 	for (stop = jiffies + tout * HZ; time_before(jiffies, stop);) {
 		if (b1_rx_full(base)) {
-			if ((ans = b1_get_byte(base)) == RECEIVE_POLL) {
+			ans = b1_get_byte(base);
+			if (ans == RECEIVE_POLL)
 				return 1;
-			}
+
 			printk(KERN_ERR "%s: b1_loaded: got 0x%x, firmware not running\n",
 			       card->name, ans);
 			return 0;
@@ -284,8 +285,9 @@ int b1_load_firmware(struct capi_ctr *ctrl, capiloaddata *data)
 	int retval;
 
 	b1_reset(port);
+	retval = b1_load_t4file(card, &data->firmware);
 
-	if ((retval = b1_load_t4file(card, &data->firmware))) {
+	if (retval) {
 		b1_reset(port);
 		printk(KERN_ERR "%s: failed to load t4file!!\n",
 		       card->name);
@@ -295,7 +297,8 @@ int b1_load_firmware(struct capi_ctr *ctrl, capiloaddata *data)
 	b1_disable_irq(port);
 
 	if (data->configuration.len > 0 && data->configuration.data) {
-		if ((retval = b1_load_config(card, &data->configuration))) {
+		retval = b1_load_config(card, &data->configuration);
+		if (retval) {
 			b1_reset(port);
 			printk(KERN_ERR "%s: failed to load config!!\n",
 			       card->name);
@@ -525,7 +528,9 @@ irqreturn_t b1_interrupt(int interrupt, void *devptr)
 			MsgLen = 30;
 			CAPIMSG_SETLEN(card->msgbuf, 30);
 		}
-		if (!(skb = alloc_skb(DataB3Len + MsgLen, GFP_ATOMIC))) {
+
+		skb = alloc_skb(DataB3Len + MsgLen, GFP_ATOMIC);
+		if (!skb) {
 			printk(KERN_ERR "%s: incoming packet dropped\n",
 			       card->name);
 		} else {
@@ -539,7 +544,9 @@ irqreturn_t b1_interrupt(int interrupt, void *devptr)
 
 		ApplId = (unsigned) b1_get_word(card->port);
 		MsgLen = b1_get_slice(card->port, card->msgbuf);
-		if (!(skb = alloc_skb(MsgLen, GFP_ATOMIC))) {
+		skb = alloc_skb(MsgLen, GFP_ATOMIC);
+
+		if (!skb) {
 			printk(KERN_ERR "%s: incoming packet dropped\n",
 			       card->name);
 			spin_unlock_irqrestore(&card->lock, flags);
@@ -663,11 +670,17 @@ int b1_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "%-16s %s\n", "type", s);
 	if (card->cardtype == avm_t1isa)
 		seq_printf(m, "%-16s %d\n", "cardnr", card->cardnr);
-	if ((s = cinfo->version[VER_DRIVER]) != NULL)
+
+	s = cinfo->version[VER_DRIVER];
+	if (s)
 		seq_printf(m, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
+
+	s = cinfo->version[VER_CARDTYPE];
+	if (s)
 		seq_printf(m, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != NULL)
+
+	s = cinfo->version[VER_SERIAL];
+	if (s)
 		seq_printf(m, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -784,13 +797,15 @@ static int __init b1_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != NULL && p[1]) {
+	p = strchr(revision, ':');
+	if (p && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != NULL && p > rev)
+		p = strchr(rev, '$');
+		if (p && p > rev)
 			*(p - 1) = 0;
-	} else
+	} else {
 		strcpy(rev, "1.0");
-
+	}
 	printk(KERN_INFO "b1: revision %s\n", rev);
 
 	return 0;
-- 
2.23.0

