Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29F7FEE2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390836AbfHBQs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:48:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35221 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbfHBQs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:48:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so33856657plp.2;
        Fri, 02 Aug 2019 09:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgdMzC369eZOQe1nP+iQAA42VLiDWQP08Q0sXkidxik=;
        b=ruNAu8Q4kz/Oqylu3Vf/XNFv3MVpTPCZ7Toy2kjaT1OZZYNs4cThGnhTNLZWC1FdOF
         LEwnQxtlHCvTaruVuyz6IvsJUz13fQSTrwQarbi1j/qyAB1tmTV9r3qjOmfhCHtMhQQj
         U/r9NQLOtZGqpwAjqzZJvi/RJBGyEbQDsZUuVIK9IrW6a3xlnOR4JXGsESnfWvsg1jY8
         MPCdsAOfw0g3TwTBL8YbnxLDlZrSBr1rlsTuHQXI4F/8aWeOo9WV5TRrVBOiBfBDzuvX
         pL9xhrfMffG/9oO5ytLpEPnFmeaIXUYDplFXYCTvpZFoKwH612fx6FD75YU01YNW+pUV
         h9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgdMzC369eZOQe1nP+iQAA42VLiDWQP08Q0sXkidxik=;
        b=OjM5YZAW+jxqsb6UUiRfq+UFDH7DnTvaWr3VyRWzWiHAnmhYqnXvPUg5bO3G4i4hYV
         lvjFJyESispYjmhKNcq3giBgBwBYF8VECEiAxNfRwCr+3kHWptSUeJolZjy4yENI/HbT
         wCiX4yjZ+iti8ad8RnuUyv00m2j97U0LSpl+KjjASyevjEbErWneFE7Ka/3PVU/LZu+H
         6aUSkD7wzgfbSBs27/zRbtTEMSyiynOwGWia6MjeUZVofcszjRu1Avxs45mdIMRHrC5r
         bjf1hiDS5rbnULZeRbIIFX6LeESgqQmr/3CQTG4OgJiv6jPDZHoZSYt8/uKlJCc99OmA
         qPcg==
X-Gm-Message-State: APjAAAUWtWENj759jPILSrriMA1gDJtdYXNWmEa7xPqSLY5Bmp4zXPp3
        bGQYxyuargd0DPxEUyF7SDEJbuuOYW3Gag==
X-Google-Smtp-Source: APXvYqzXwBykUHq15uR6yKW2w4CDTWp4aur1Yf9oRArKODUF/AVkqNA2xxygNqrTuoc0aSdNMz70SA==
X-Received: by 2002:a17:902:740a:: with SMTP id g10mr133221668pll.82.1564764506283;
        Fri, 02 Aug 2019 09:48:26 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id f3sm126220150pfg.165.2019.08.02.09.48.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 09:48:25 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2] mkiss: Use refcount_t for refcount
Date:   Sat,  3 Aug 2019 00:48:21 +0800
Message-Id: <20190802164821.20189-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Add #include.

 drivers/net/hamradio/mkiss.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 442018ccd65e..c5bfa19ddb93 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -25,6 +25,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/jiffies.h>
+#include <linux/refcount.h>
 
 #include <net/ax25.h>
 
@@ -70,7 +71,7 @@ struct mkiss {
 #define CRC_MODE_FLEX_TEST	3
 #define CRC_MODE_SMACK_TEST	4
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct completion	dead;
 };
 
@@ -668,7 +669,7 @@ static struct mkiss *mkiss_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	ax = tty->disc_data;
 	if (ax)
-		atomic_inc(&ax->refcnt);
+		refcount_inc(&ax->refcnt);
 	read_unlock(&disc_data_lock);
 
 	return ax;
@@ -676,7 +677,7 @@ static struct mkiss *mkiss_get(struct tty_struct *tty)
 
 static void mkiss_put(struct mkiss *ax)
 {
-	if (atomic_dec_and_test(&ax->refcnt))
+	if (refcount_dec_and_test(&ax->refcnt))
 		complete(&ax->dead);
 }
 
@@ -704,7 +705,7 @@ static int mkiss_open(struct tty_struct *tty)
 	ax->dev = dev;
 
 	spin_lock_init(&ax->buflock);
-	atomic_set(&ax->refcnt, 1);
+	refcount_set(&ax->refcnt, 1);
 	init_completion(&ax->dead);
 
 	ax->tty = tty;
@@ -784,7 +785,7 @@ static void mkiss_close(struct tty_struct *tty)
 	 * We have now ensured that nobody can start using ap from now on, but
 	 * we have to wait for all existing users to finish.
 	 */
-	if (!atomic_dec_and_test(&ax->refcnt))
+	if (!refcount_dec_and_test(&ax->refcnt))
 		wait_for_completion(&ax->dead);
 	/*
 	 * Halt the transmit queue so that a new transmit cannot scribble
-- 
2.20.1

