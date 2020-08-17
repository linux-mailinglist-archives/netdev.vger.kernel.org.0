Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFCF2462E4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgHQJTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHQJTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:19:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75806C061389;
        Mon, 17 Aug 2020 02:19:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y10so5635257plr.11;
        Mon, 17 Aug 2020 02:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ifLfIrBu1ltO21juvrs7/f94zIPbflxds2FmAIn0JZY=;
        b=QLC6x/O13MeP0lPsSOPKaI+ocf7oT0PGwI9jaqY5n+w05x+fnihg68gNW9IMTCYLmr
         QP7/v8OCTappeLr1ZuVp0BsTJ1mH85ENUZ2a6AmLJxjUUhw01jO65HrM9m3jJ/8fkzOD
         /S951cp1wfO+Ld6aPWrVxO7J0pQj6AA1qxc5UAopaYjDT3vKbgs6OuTAyMB506fY0UDH
         5Vov97HYXFpYb/YY3HH4v98ijkrDRUNEPcHpqzt4ZRRsovwJz6805sBa4AZVV67aGl1m
         cckpnrRBYuVhiBXYyB2AdVauJXp4muM3muUnNrrm5+mb6Juwp+3iKvIPDL2fSNnGn3kS
         Vy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ifLfIrBu1ltO21juvrs7/f94zIPbflxds2FmAIn0JZY=;
        b=S2zM3R+rTji5Sy2aSEw8VnUzNnVaMCTkCZXvuLb8xwIRUr4o4MQt6PPfgozSkzzX8Y
         k5+uwHjghyUDFv++6dcxGY8Q/FIAXdsFKvBaCpUKizDuZ3TjOy7A0Kxfxd9E+2Svwg6B
         aNHEEjpyBsfbh49GI3UvdvI4kC19FfCtU+HwUJfiO5Nzx7hEFFksJP2ekXaPv0TzMnaA
         qPObjNN2zUSS/E2pkOjSKPdaeVCPcV+TDwBoiLp21Y5aegqG/62BDQVFdxqYVD4Qmjqq
         NRlA2LCCrNvs25vX9GmfefvET3cMSiClPyniloRvRWV77FB+AjmeVqjxO9xerATKp2vL
         wihA==
X-Gm-Message-State: AOAM530flyj8iCrJg8pVBxxwuPFhwNnLKdAKRD73tbGAXZeMJ9ibT1Cx
        viO/8Ie7nx4ddSw4253Pr8o=
X-Google-Smtp-Source: ABdhPJwQiN0j3I0XTBAoTEh/kHlRdKQRBPrBZjjvBv7FEdQfK+kQb/LL0lHsiyq2Kw2a6+jej7syqg==
X-Received: by 2002:a17:90a:2210:: with SMTP id c16mr12291145pje.65.1597655969939;
        Mon, 17 Aug 2020 02:19:29 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:19:29 -0700 (PDT)
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
Subject: [PATCH 1/2] mailbox: bcm: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:08 +0530
Message-Id: <20200817091617.28119-14-allen.cryptic@gmail.com>
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
 drivers/mailbox/bcm-pdc-mailbox.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/bcm-pdc-mailbox.c b/drivers/mailbox/bcm-pdc-mailbox.c
index 53945ca5d785..5b375985f7b8 100644
--- a/drivers/mailbox/bcm-pdc-mailbox.c
+++ b/drivers/mailbox/bcm-pdc-mailbox.c
@@ -962,9 +962,9 @@ static irqreturn_t pdc_irq_handler(int irq, void *data)
  * a DMA receive interrupt. Reenables the receive interrupt.
  * @data: PDC state structure
  */
-static void pdc_tasklet_cb(unsigned long data)
+static void pdc_tasklet_cb(struct tasklet_struct *t)
 {
-	struct pdc_state *pdcs = (struct pdc_state *)data;
+	struct pdc_state *pdcs = from_tasklet(pdcs, t, rx_tasklet);
 
 	pdc_receive(pdcs);
 
@@ -1589,7 +1589,7 @@ static int pdc_probe(struct platform_device *pdev)
 	pdc_hw_init(pdcs);
 
 	/* Init tasklet for deferred DMA rx processing */
-	tasklet_init(&pdcs->rx_tasklet, pdc_tasklet_cb, (unsigned long)pdcs);
+	tasklet_setup(&pdcs->rx_tasklet, pdc_tasklet_cb);
 
 	err = pdc_interrupts_init(pdcs);
 	if (err)
-- 
2.17.1

