Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F19309935
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhAaAE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhA3XtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:49:15 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733DAC0613ED;
        Sat, 30 Jan 2021 15:47:57 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id i8so2120557ejc.7;
        Sat, 30 Jan 2021 15:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l1vBwvopkVoZW1LdSHZ0VntQhbz1e+J1ify4RkFAUDg=;
        b=nCgfM79Cv1gKTkdnZi+iTVkIXmdJIhRtPl2up6JysfrtdUsAtapHTnrBj9JOzzuP3y
         6jteTY5b+UbXw3j3hUYB0UsRYQbJzqONVhX2mEeHFMnuiSRKLtg9UfO5TWsSzR5XQeAi
         txdjfDP8I8CcLFDTptZLCUIZAiwBVOllsCEAG5kGLHEflBrhPzQzOfymbJDMD9V1fCD9
         xqLAQwFQZ11O0Qr7g1JkwsQ8mKpZY10Im3F4b9TrZvGcDR7zKOfbTYwppG4/4JNCtjHl
         mBNpEdQKCA6jVqbUitSl8lMMrRGieegva9AxUhmKRze8N4SMPWCh4gaKPhrj4r6MjpUu
         L66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=l1vBwvopkVoZW1LdSHZ0VntQhbz1e+J1ify4RkFAUDg=;
        b=loi/M1nfOXXN3wLawYi1oakN50JIQQGnUUvoj9udLsjIHGPtnKO0/6Vkl9I8E+f0FH
         3T3jijMME4fdCUUlxNW4RTb1cv6OkISAQpuugKHhb/FxR7MEOAPgTsc1BoSebXgNMIMt
         63ZSfTHvqlc7nS5mqebPFptmnTLC/xcGArdI+5QFyrr3AFokSr+VRlQClCQT628fj5CM
         9kKY7ikmtle22XP8qgNBbzBNFpbOEWxqoojBTho6xxz3XHXd/ip/0m9r8MJopXfcoV0R
         mF5E4O7nBuMLG1spwdAeTG5xcp27ystQjDwFPKBPcDPbfQEQ537usRWE8KXsNs9miKyg
         bL0g==
X-Gm-Message-State: AOAM530ZP88MTke1MddPD7c1LIXoMT1H9A6+e62IIw2IRniNS7sAeEuL
        f7QmYnTb2TN6Edf6mV/FKlORb6vCTI7g4aHw
X-Google-Smtp-Source: ABdhPJzpHTsZkK8Pa94gAzrIL7rzOqlHSImWy/F8RfwN3spTn1VbC9nzYNpa8S+xYB+ItKRu4NxBaQ==
X-Received: by 2002:a17:906:bc5a:: with SMTP id s26mr10653887ejv.327.1612050476291;
        Sat, 30 Jan 2021 15:47:56 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:55 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Petko Manolov <petkan@nucleusys.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] net: usb: hso: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:26 +0100
Message-Id: <20210130234730.26565-6-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210130234730.26565-1-kernel@esmil.dk>
References: <20210130234730.26565-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/usb/hso.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ef6dd012b8c4..31d51346786a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1213,9 +1213,10 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(unsigned long data)
+static void hso_unthrottle_tasklet(struct tasklet_struct *t)
 {
-	struct hso_serial *serial = (struct hso_serial *)data;
+	struct hso_serial *serial = from_tasklet(serial, t,
+						 unthrottle_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1264,9 +1265,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
-		tasklet_init(&serial->unthrottle_tasklet,
-			     hso_unthrottle_tasklet,
-			     (unsigned long)serial);
+		tasklet_setup(&serial->unthrottle_tasklet,
+			      hso_unthrottle_tasklet);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
-- 
2.30.0

