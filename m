Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C94246262
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgHQJRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:17:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5434C061389;
        Mon, 17 Aug 2020 02:17:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f5so7186550plr.9;
        Mon, 17 Aug 2020 02:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uZ+1GKxChp21LTxKeZeHItaYyTUEZmeDAjJJ3IuyUSU=;
        b=QOU3It2wstSJQ8rTV/fRKD6g3FxnjKR7x+Yn8XhXibiXjd9f+wMUX06FxPTeJckaOy
         b461ZvK+YUE+a4MgqglsIfnmBh1hfgw+OcprCrJKfwn6S7iF4u002CSD866ly3D9ewzl
         KZefKfGEV/Ayb6cOaQMdIuFxRgOzaQ6p54wUjWaECLiKBrgQHy3tV6AeZbifktOme+eH
         NjF7sOjZeNi5IMHEZbD9MOiEmhtBLqVvzb4547MxWG8lXsvmAhu3YelPfx4zHgGe28Jc
         2XbbfK00LrxN/7E2T3xL/1NXOWZUugF7t8FyOW2q/Qb6jXYDE7eKIouYXUKYiMSgzqKW
         ix0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uZ+1GKxChp21LTxKeZeHItaYyTUEZmeDAjJJ3IuyUSU=;
        b=c0B0u/td4GMOuCSAjjovOZpOBScq1ysACldAx0J7J3QomkMwnMqwESFy2Xn32jV21d
         Jkw0Cx7wx+PwNtOh4jVQvhApu/YEKxzdbHhXddDFm7OFmpJVzVjE7qCSQqdtUZNvl5M/
         ix3r6Y70bfIxKyqbPcJUqNUh6C4AvAV3QLHt276EHy4+xUzWSDI4DnLazzE8gyh01Bhu
         /XpVB8ULqEpxCLUBz0hYGAKXrHya7XQtIKrkXcrbhzKfviu8qInPepnaRCaJUzY/3fJA
         xB6rK5VwqVzUYQ0e0fA50ux/GR6YeuPkjqfEJcpSTV2zhoYovsMMB1WHeDokizYs+nF/
         ySKw==
X-Gm-Message-State: AOAM532uGMtWYOQx+CVRFRj+6jf5oART+tDPUNdjOtkrQd/Z0/OGnVs/
        qqhOByR/g+wZYk7dZnF7nFo=
X-Google-Smtp-Source: ABdhPJwXoSwxxXkSke3l7PujHUMjPUXY5EKX6zhSfgL0hCl2GRP8rzNL2p+R0J7BH7wXM281JFEI2Q==
X-Received: by 2002:a17:90a:3948:: with SMTP id n8mr8798780pjf.156.1597655827403;
        Mon, 17 Aug 2020 02:17:07 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:17:06 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        3chas3@gmail.com, axboe@kernel.dk, stefanr@s5r6.in-berlin.de,
        airlied@linux.ie, daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@HansenPartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org
Cc:     keescook@chromium.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] char: ipmi: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:45:57 +0530
Message-Id: <20200817091617.28119-3-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/char/ipmi/ipmi_msghandler.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 737c0b6b24ea..e1814b6a1225 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -39,7 +39,7 @@
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
-static void smi_recv_tasklet(unsigned long);
+static void smi_recv_tasklet(struct tasklet_struct *t);
 static void handle_new_recv_msgs(struct ipmi_smi *intf);
 static void need_waiter(struct ipmi_smi *intf);
 static int handle_one_recv_msg(struct ipmi_smi *intf,
@@ -3430,9 +3430,8 @@ int ipmi_add_smi(struct module         *owner,
 	intf->curr_seq = 0;
 	spin_lock_init(&intf->waiting_rcv_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
-	tasklet_init(&intf->recv_tasklet,
-		     smi_recv_tasklet,
-		     (unsigned long) intf);
+	tasklet_setup(&intf->recv_tasklet,
+		     smi_recv_tasklet);
 	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
 	spin_lock_init(&intf->xmit_msgs_lock);
 	INIT_LIST_HEAD(&intf->xmit_msgs);
@@ -4467,10 +4466,10 @@ static void handle_new_recv_msgs(struct ipmi_smi *intf)
 	}
 }
 
-static void smi_recv_tasklet(unsigned long val)
+static void smi_recv_tasklet(struct tasklet_struct *t)
 {
 	unsigned long flags = 0; /* keep us warning-free. */
-	struct ipmi_smi *intf = (struct ipmi_smi *) val;
+	struct ipmi_smi *intf = from_tasklet(intf, t, recv_tasklet);
 	int run_to_completion = intf->run_to_completion;
 	struct ipmi_smi_msg *newmsg = NULL;
 
@@ -4542,7 +4541,7 @@ void ipmi_smi_msg_received(struct ipmi_smi *intf,
 		spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
 
 	if (run_to_completion)
-		smi_recv_tasklet((unsigned long) intf);
+		smi_recv_tasklet(&intf->recv_tasklet);
 	else
 		tasklet_schedule(&intf->recv_tasklet);
 }
-- 
2.17.1

