Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6D4246289
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgHQJRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQJRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:17:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BD4C061389;
        Mon, 17 Aug 2020 02:17:45 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ep8so7403314pjb.3;
        Mon, 17 Aug 2020 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mo6iICj1w8TKwOisUCBNzTZG5p5dM66mXRaY4cwKyZk=;
        b=TzbwEFTqX0QCsBFflLiO6trddpNRzDxFXlyalb8p8shAuNzSqnVRPY8vMtBs1W5gGO
         YUc9r1hZWkAsv9H25E5N7kwqFWChbTSHzlTwFhWkQtf63DEW68snGk4kLIJ5B50DmJxW
         MWiO1udraHvmpV1CUmZxnsCDK3iuigHsru9yj+Oquzzzyly4+EM9iRLcN2KRuZWEdlkQ
         fk0Czl4+kqYHd4k4r0smEt/HwPMvVApbc9poEuzVer5sNiD49xlJWmv3Z+GjWTQ1m5b+
         aFLAe1vugsFxn+AMoHEAGT8072rZH7m2jZyN/wKgUUmGiQtrTmT5nZIW44CYFt5Ph9RF
         ifXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mo6iICj1w8TKwOisUCBNzTZG5p5dM66mXRaY4cwKyZk=;
        b=Z6Zjc1vjVWV79qPEGQfKuwJaYlZ8f1aDUtZB0impxNJXgiE9Zj7gw0HKPBJxF5Dm0f
         04yCWT0ddilX9Lo24pji+G4kz1E12/O/iAIxhiqIAnUYJ3a+S73RqX8yYqyHoxjdTlq8
         tKRgzffY5chOJ6cfyNVzpL2Uol/kw2+gNFORxcpELiop218D6P1YuwzEmxagrqOR/ygQ
         G1tcgxrjWO2v0QNu7kXhnGbmBKrYChmIQ/Xk1kKeltyDY7oIUWIQd5sPh/ZKd/O75ceW
         /4GvJfUc19eenw4NdC1n3Z3krf4UBjn5aKufOU8P/ZO10vHqGB7RnU3xSovCtyoT1tqK
         yrMg==
X-Gm-Message-State: AOAM5322ghw9eZeq3TEShopfn4qUZoamXAYzWyfDgtvStDy7Mt8nw1Lx
        cRRltfKFIw2+lEF0412efyY=
X-Google-Smtp-Source: ABdhPJwq6UEku9ZvxUlcSd9v3lLdDcS44qfn7fyf+CsiORE4iW8DsxOdwJSiRT3OcMi8Q3GfQoOtrg==
X-Received: by 2002:a17:90a:2210:: with SMTP id c16mr12286360pje.65.1597655865119;
        Mon, 17 Aug 2020 02:17:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:17:44 -0700 (PDT)
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
Subject: [PATCH] drivers: ntb: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:00 +0530
Message-Id: <20200817091617.28119-6-allen.cryptic@gmail.com>
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
 drivers/ntb/ntb_transport.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index e6d1f5b298f3..ab3bee2fc803 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -273,7 +273,7 @@ enum {
 #define NTB_QP_DEF_NUM_ENTRIES	100
 #define NTB_LINK_DOWN_TIMEOUT	10
 
-static void ntb_transport_rxc_db(unsigned long data);
+static void ntb_transport_rxc_db(struct tasklet_struct *t);
 static const struct ntb_ctx_ops ntb_transport_ops;
 static struct ntb_client ntb_transport_client;
 static int ntb_async_tx_submit(struct ntb_transport_qp *qp,
@@ -1234,8 +1234,7 @@ static int ntb_transport_init_queue(struct ntb_transport_ctx *nt,
 	INIT_LIST_HEAD(&qp->rx_free_q);
 	INIT_LIST_HEAD(&qp->tx_free_q);
 
-	tasklet_init(&qp->rxc_db_work, ntb_transport_rxc_db,
-		     (unsigned long)qp);
+	tasklet_setup(&qp->rxc_db_work, ntb_transport_rxc_db);
 
 	return 0;
 }
@@ -1685,9 +1684,9 @@ static int ntb_process_rxc(struct ntb_transport_qp *qp)
 	return 0;
 }
 
-static void ntb_transport_rxc_db(unsigned long data)
+static void ntb_transport_rxc_db(struct tasklet_struct *t)
 {
-	struct ntb_transport_qp *qp = (void *)data;
+	struct ntb_transport_qp *qp = from_tasklet(qp, t, rxc_db_work);
 	int rc, i;
 
 	dev_dbg(&qp->ndev->pdev->dev, "%s: doorbell %d received\n",
-- 
2.17.1

