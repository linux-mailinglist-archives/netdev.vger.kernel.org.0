Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE612462CE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgHQJTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgHQJTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:19:04 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DDFC061389;
        Mon, 17 Aug 2020 02:19:04 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s15so7821086pgc.8;
        Mon, 17 Aug 2020 02:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H53NItB96hhK0lZMvS5UWr62MZO4kDlJxK+OZQUxxIA=;
        b=Q9//06PpCdzBcB5+2FmR3vcPX8ASc3s+ZqMBFaeRwEkDMjoO3ubFfEuRDvNyw69Dic
         A+UvP5p7Sa7LwPskN9TiPkDaTIGuH2iea/lkrw98pDSnGmsaUfJX37kbIJa1u46YHB5f
         Biss505SKwh0HAGB5MaLRxgXu1CO2EwXczixBc538BCK83Jyz086JRCbTSXgutB7e4FX
         /W9NvIU4fSh/Ib/tv7t7BztqxaZ4vcJQgOiXTE1ktzbLpdXGu8a6uU6wMvjuhA4hl/Yv
         klgo2KrIpjJmP8zUsX/rM/tO2Wej91r/JteBk1SMuYF1iBTXfyMg4piAFIrY2mqWn3/s
         KsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H53NItB96hhK0lZMvS5UWr62MZO4kDlJxK+OZQUxxIA=;
        b=BJyEAzeViTQ566SNpvJI4o0+LVT/uI1GZkErhLRMu+vICYNNDe8kepBENm2jX3iVo5
         l8wuA9HLVKDYaBS4ZtgRZpQ5V/E18ILJsqYN6mPBxMYe92T0ANiTDgNaYx3bOt+HN7xN
         XaPuqE9MMhTxjB1lAJ4fUKWY7ZQ9sHzVE1eTZiDv/mIjdHZUd5FSLlmOk3n576n90lQs
         l2JHXzpOletwhyUDS1uPmNIOnfHiryDmjrwxA695fqvlybLZ8Ajh5ysi8mOLnoRzft8m
         o4p42O0B/bF33p+J+5RyYO6TdQ9tpWGYvZvpvv0BCUJ52Y32U0wR50AHm/Kjx34VPXPH
         aZWA==
X-Gm-Message-State: AOAM531J+KdnajAdOJeyh7wf21ejpNGlTAf1wzvfOHxVGtGWPlcrIzEe
        wdoayt6l3iAUKCS4J3f9cpk=
X-Google-Smtp-Source: ABdhPJwwv5IFUmxu6OFvp0ePee/WauDvfAGFpW7BnuWSsn7pFfdtUZETkOuz5u6jMhvkrLcgz5ASfg==
X-Received: by 2002:a63:5552:: with SMTP id f18mr8843602pgm.298.1597655944120;
        Mon, 17 Aug 2020 02:19:04 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:19:03 -0700 (PDT)
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
Subject: [PATCH 1/2] hsi: nokia-modem: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:06 +0530
Message-Id: <20200817091617.28119-12-allen.cryptic@gmail.com>
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
 drivers/hsi/clients/nokia-modem.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index cd7ebf4c2e2f..36d373f089ce 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -36,9 +36,10 @@ struct nokia_modem_device {
 	struct hsi_client	*cmt_speech;
 };
 
-static void do_nokia_modem_rst_ind_tasklet(unsigned long data)
+static void do_nokia_modem_rst_ind_tasklet(struct tasklet_struct *t)
 {
-	struct nokia_modem_device *modem = (struct nokia_modem_device *)data;
+	struct nokia_modem_device *modem = from_tasklet(modem, t,
+						nokia_modem_rst_ind_tasklet);
 
 	if (!modem)
 		return;
@@ -155,8 +156,8 @@ static int nokia_modem_probe(struct device *dev)
 	modem->nokia_modem_rst_ind_irq = irq;
 	pflags = irq_get_trigger_type(irq);
 
-	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
-			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
+	tasklet_setup(&modem->nokia_modem_rst_ind_tasklet,
+			do_nokia_modem_rst_ind_tasklet);
 	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
 				pflags, "modem_rst_ind", modem);
 	if (err < 0) {
-- 
2.17.1

