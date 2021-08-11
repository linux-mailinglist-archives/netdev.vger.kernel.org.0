Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EA93E9695
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhHKRNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhHKRNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:13:54 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5571BC061765;
        Wed, 11 Aug 2021 10:13:30 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w20so7242590lfu.7;
        Wed, 11 Aug 2021 10:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t0put3WQKCyr8vI6kbv2MIdMuz0kftSF9W7Wh/dF+0U=;
        b=bU8hQa1VUy8iWV9ZyBg4llJxBlD7PywdItpJUIDq/mLactvQ5li8YB8O/gf+/klZyJ
         xZ4vOqxZiodRxYUH+njbn3Y3yOm/DsvWEtRI+e9iV/khDpl5ecMduKyGKCy7Xi9QwnZ8
         rRciD8GMyKE+7tAMuKZYPd88krERSIngSrE5aHxgR9VJIvRid89bWJJZvtHssr46Ecuf
         UETKXCVCU63vV4sxDvShbIB/QrCLEV/T0URQNK6Mc7fuBSLe/8xlZ2wFT9QKhcuAIPEK
         dEiNzddi6Tc9YKwr/6GhBINM0wVzytLLji1Y8g/ajCGSarDZ9i153bBZsch72PoZcYxo
         /cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t0put3WQKCyr8vI6kbv2MIdMuz0kftSF9W7Wh/dF+0U=;
        b=M0PZjwWsTj3jgEjugTgGEGuOs45lkmfbMaEMQMq9i5yEo+FnoPr3P1v6OUk1tkPPAt
         JPRt+WU3n+453QG+0RgAYNGOq9Td2Ko0VKoXvqoBrh9ZbPA5BhKDLJaVOrBQY0AlRwW8
         KpB2k/l4wa8KQIOB9pk25+/MZrVpuLeeHxX9+8kMQccG6SOSukdWz2Kd49FacWvWO7Qk
         kraAACNIdAVRJEngSZuEZbi29MGruaOce3fmaNNm7it5S9o7JJWQ4Q/QrBcYqhVO8y+M
         aqCU8yZZiS/OqRpiaoPaqEoWjC2rSTrv+oySnI+SKWM/9KdEUQTiC0sVwXwp36v6hriM
         Ufag==
X-Gm-Message-State: AOAM533c5rMuAhF3Ji2dezOMXnH6vWAZnQNDzp8v4Umrc/O2488TdfMv
        X8YDBjfQG11/MAHfbIbCzO4dtBD4hTEC4g==
X-Google-Smtp-Source: ABdhPJzdAOrZbvuOIhZRHAOplWIFFE136F1d/U/Cm3OF/nxEwEWXhq/1c6wB0imh7aD5gI8RAybOZg==
X-Received: by 2002:a05:6512:990:: with SMTP id w16mr26465179lft.346.1628702008669;
        Wed, 11 Aug 2021 10:13:28 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id g5sm2095125lfb.10.2021.08.11.10.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 10:13:28 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: hso: drop unused function argument
Date:   Wed, 11 Aug 2021 20:13:21 +0300
Message-Id: <20210811171321.18317-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

_hso_serial_set_termios() doesn't use it's second argument, so it can be
dropped.

Fixes: ac9720c37e87 ("tty: Fix the HSO termios handling a bit")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/hso.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index dec96e8ab567..0e37bf24a826 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1079,8 +1079,7 @@ static void hso_init_termios(struct ktermios *termios)
 	tty_termios_encode_baud_rate(termios, 115200, 115200);
 }
 
-static void _hso_serial_set_termios(struct tty_struct *tty,
-				    struct ktermios *old)
+static void _hso_serial_set_termios(struct tty_struct *tty)
 {
 	struct hso_serial *serial = tty->driver_data;
 
@@ -1262,7 +1261,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	if (serial->port.count == 1) {
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
-		_hso_serial_set_termios(tty, NULL);
+		_hso_serial_set_termios(tty);
 		tasklet_setup(&serial->unthrottle_tasklet,
 			      hso_unthrottle_tasklet);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
@@ -1394,7 +1393,7 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 	/* the actual setup */
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	if (serial->port.count)
-		_hso_serial_set_termios(tty, old);
+		_hso_serial_set_termios(tty);
 	else
 		tty->termios = *old;
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
-- 
2.32.0

