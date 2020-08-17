Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28FD2462A8
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgHQJS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHQJS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:18:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D35C061389;
        Mon, 17 Aug 2020 02:18:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h12so7817900pgm.7;
        Mon, 17 Aug 2020 02:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FQvu3zIKHcfDVUfKtSNhAC6ZzQDedEm/LuwK8bWrPeg=;
        b=D7eDa0sTjwHCA8r6MCWSFMRxFQkDRfX7e4fguBwE+NqCdLaBdvT8ONpLvgzAjxtVQT
         0ppL357zpK2cqmejsnz5VEqE9kmyIvsp/43Twv5a9NzWcoSYF0wGizjZ9zjUOZUarpa6
         Rc3XCG4Wm/C+XLOLCzBVfdIXQ90RWb8AEOKqZXhdPJ/NfRn3hfLtGberOYeprAHUwSJQ
         ulOOErg41MiOj1g2LNgno+3QMivuYXqc4mkuyqq2LhWdKpn3CpDymg1ZrwPxHiavkADA
         aWCo+QxkF5OeKgNSC4ix5Pl06VUDNeICDFdGAyaW4Q4qIj4LQJvAqaJseGgPjYZCbCYI
         stcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FQvu3zIKHcfDVUfKtSNhAC6ZzQDedEm/LuwK8bWrPeg=;
        b=eogt3aJBbOXnLcnN5ozaYbPRsTn480FHwwSUs+uibj3G82alrJp9kBFl8tfVkH+C6m
         iGDNbfft6V4FFrD+cV88jH9h+niubx6nJ6wwGM2Y1XzJioDO4YGwNPqinID+UIK+VYGJ
         G5qePmClqiRwM0aBB1rqNWSIk2rirHU8w+OEmP531sm7KzSqcBW8MgM8TRGUp9xHXYWg
         Wuqtb/KYd4snxAv3jQuF1mtyRUQchzk+Di11XbTZNjBHghSfejjnLleWUwruvpVLyI2R
         UMSn/mN9BaAd5fvB7AGepEV/Q67UM7ewTUKzTuvQjcsUHkqonwlz8Im6fNfeWtWAHoUX
         8Q7w==
X-Gm-Message-State: AOAM5328I6jlGmexPHuMt4riGEIZRXB/tMIFQnsOb71K/9C5UMHh93MD
        c5FVTiRswx+fp6s28Ajaqao=
X-Google-Smtp-Source: ABdhPJwtRhOmhjCwN7IXEf1tWrXGn9elZdq5DEvcUP+b4kgMpyQCKqzdT+NRfaecTuV91gmR9bNLEw==
X-Received: by 2002:aa7:8c42:: with SMTP id e2mr10326531pfd.181.1597655905521;
        Mon, 17 Aug 2020 02:18:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:18:24 -0700 (PDT)
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
Subject: [PATCH] drivers: vme: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:03 +0530
Message-Id: <20200817091617.28119-9-allen.cryptic@gmail.com>
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
 drivers/vme/bridges/vme_fake.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/vme/bridges/vme_fake.c b/drivers/vme/bridges/vme_fake.c
index 6a1bc284f297..38dd5f949cd0 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -90,13 +90,13 @@ static struct device *vme_root;
 /*
  * Calling VME bus interrupt callback if provided.
  */
-static void fake_VIRQ_tasklet(unsigned long data)
+static void fake_VIRQ_tasklet(struct tasklet_struct *t)
 {
 	struct vme_bridge *fake_bridge;
 	struct fake_driver *bridge;
 
-	fake_bridge = (struct vme_bridge *) data;
-	bridge = fake_bridge->driver_priv;
+	bridge = from_tasklet(bridge, t, int_tasklet);
+	fake_bridge = bridge->parent;
 
 	vme_irq_handler(fake_bridge, bridge->int_level, bridge->int_statid);
 }
@@ -1098,8 +1098,7 @@ static int __init fake_init(void)
 	/* Initialize wait queues & mutual exclusion flags */
 	mutex_init(&fake_device->vme_int);
 	mutex_init(&fake_bridge->irq_mtx);
-	tasklet_init(&fake_device->int_tasklet, fake_VIRQ_tasklet,
-			(unsigned long) fake_bridge);
+	tasklet_setup(&fake_device->int_tasklet, fake_VIRQ_tasklet);
 
 	strcpy(fake_bridge->name, driver_name);
 
-- 
2.17.1

