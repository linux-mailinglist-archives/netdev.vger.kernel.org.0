Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3C109FA2
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 14:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfKZNyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 08:54:33 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43650 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfKZNyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 08:54:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id b1so9030328pgq.10;
        Tue, 26 Nov 2019 05:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=jn3dXdAUXjCfoTNIr3OuAUBdVoonrWEKqBMAuY8e4g0tBuHvsaniCAg1vun5q/XJb6
         m68Oi1JcNA3elKzuyziqT9UmhDJTzPJpqSWbwePveSiW79D06dNmHVP2kqiBG2nv5kpy
         Te0vcwffP3luJ+ZHivGiNFFeEN9dc9huhdQUNFWmWy8nCLldOjp/AZCtf3eKe2+3YirG
         ohOCO29qxyFBYmw27rU4q4LA7GKX2yKZl48dalyIhFvqJ5hQYmrgtML0ZH4jtlMrS99A
         nP/LTkgHeEo3B17svNxg2O708y4rNEcRUEImbCV9bm/Q2ytpsQrRDZ2lqrUeb7y6xjAe
         KJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=OTOKcgN1pnYOZmZwDdMVYi125QxBeG9CiRdQLTsIjkoFKbLB9nPuQakTDzAeIZTgCu
         L6Kw7ezQYOXqYjrSrUq1/l2qpTR+RXbJTIhN3jej4TFUV15WpNe8LupKGFigACVO03Ro
         Ihcl06XBYtfKsw89VF91Nl6NG3f41cy77q+UhKZX0ASrMD2LGMyUqoXy+fbPHFdTMuik
         V50bSqQ5ylR3SWhhmgEva2x15oZTRY95moo16rv9J2MH+zZBDWw8BEK5/+otoYKBwBKy
         7/4Qz11F7Wu90HIE9BmqlSxAUEMzZ8MXLe876zTQezh7VOd9+Cmacy5gxg5J+e85jpqR
         ZhMA==
X-Gm-Message-State: APjAAAVvsk8GyJCpo7RqQjv0Co0v1+g4QrX0t0uBolOQdxrGLzxKzzvt
        4wUISZmoXfj/tQdBhrYapYwrA2vZvo0=
X-Google-Smtp-Source: APXvYqwEndTpIDrFY2fzA2dGp2sWoeRfH5LLeu+qEp6aMt+qIb+DSwKvlV2AxLfZHhRF7NA6PnbkSA==
X-Received: by 2002:a63:6b87:: with SMTP id g129mr30172249pgc.438.1574776471317;
        Tue, 26 Nov 2019 05:54:31 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id v3sm13018499pfi.26.2019.11.26.05.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:54:30 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net
Cc:     alexios.zavras@intel.com, allison@lohutok.net, benquike@gmail.com,
        gregkh@linuxfoundation.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com, tglx@linutronix.de,
        tranmanphong@gmail.com
Subject: [Patch v2 1/2] net: hso: Fix -Wcast-function-type
Date:   Tue, 26 Nov 2019 20:54:12 +0700
Message-Id: <20191126135413.19929-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126135413.19929-1-tranmanphong@gmail.com>
References: <20191125.110708.76766634808358006.davem@davemloft.net>
 <20191126135413.19929-1-tranmanphong@gmail.com>
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

