Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3A246313
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgHQJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgHQJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:20:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A69DC061389;
        Mon, 17 Aug 2020 02:20:15 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so7207676plt.3;
        Mon, 17 Aug 2020 02:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=48ZUy5TmzQBYUzPrjZvYPJeHWlYkLbZYovshPbclrcg=;
        b=FoufY+wCt538UGODDBNoxdFMHMLuyZNGQ6MHR7pZXvqvIrAnPj8PHB4pQsWp/mWg6o
         KsvcX8Y87zDteEZApNo70LMlrBVZaBliAR2vLGx60Xbo7CohHtYkdt/Mg+u50DG1h36h
         9Fwly9brTQHjZlbl7lAqxgOWAbzrsFhJBcqUC23aSRj/VpiU2JCK2mbui+uqvhxhgmrl
         IvuQewyHW9KqIl6MAWFr6dd8dgP34kntnReO4dunTk9vfs81InEHWHE3302xh+V3TqjN
         5ledaxK7A0foZnhRefzAA6Ra/wxb6d+K7gxqNB1TdKvqBatRR5FaVQrX9ZSt/5m+frdy
         H7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=48ZUy5TmzQBYUzPrjZvYPJeHWlYkLbZYovshPbclrcg=;
        b=byK9FvKPmJ2qKiaXQ7me6xpWdIIwtbzsQ4OHw7mCVZ/eYjSKcXH7TOtIjViiXhqCof
         1ipwXsij/CUPF5xtvtw7V6Q4R+ejZYbqXnmN7Cqls+nzmrvPssrxdLFaCHBfJwCHKi7V
         pP386Mbt9QnY/IXwJSJSC7ErYBHSEpALkZU1TXwP65GhTtfKVuL+n0sfXN7i+eXFlmIG
         PCR7vSfS91vCLx0KufYfmIzV6t/g2ciu0ljHzaAO4ek/uhhg4QMgxSyh8cEV2O/xjluP
         tzRY/aLyztOAGjTCZxxvSsaPGDHJtwU9eCucgJZPIaFxjIpKuxJwH07/+Ve+RvijteVi
         Iu7Q==
X-Gm-Message-State: AOAM5339Oe0rUDJS9Ds5MSfD91lV34hUJwZfMJ0Me69du9q4MEF/bFZE
        yDgHvX/qtRAg9oPHcM8DaKo=
X-Google-Smtp-Source: ABdhPJzGq3wy6E/Dy/SnfM+UdmLXd8ExYtYFE4LwG7DZVH6d40QHdot/zCUw6TFKmzo3uMNttbjBZg==
X-Received: by 2002:a17:902:bd85:: with SMTP id q5mr9922465pls.99.1597656014891;
        Mon, 17 Aug 2020 02:20:14 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:20:14 -0700 (PDT)
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
Subject: [PATCH] net: atm: convert tasklets callbacks to use from_tasklet()
Date:   Mon, 17 Aug 2020 14:46:11 +0530
Message-Id: <20200817091617.28119-17-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

Update all the callbacks of all tasklets by using
from_tasklet() and remove .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/atm/pppoatm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 579b66da1d95..3803be8470f7 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -416,7 +416,6 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	pvcc->chan.mtu = atmvcc->qos.txtp.max_sdu - PPP_HDRLEN -
 	    (be.encaps == e_vc ? 0 : LLC_LEN);
 	pvcc->wakeup_tasklet = tasklet_proto;
-	pvcc->wakeup_tasklet.data = (unsigned long) &pvcc->chan;
 	err = ppp_register_channel(&pvcc->chan);
 	if (err != 0) {
 		kfree(pvcc);
-- 
2.17.1

