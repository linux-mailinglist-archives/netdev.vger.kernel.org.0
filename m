Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32F924624A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHQJQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQJQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:16:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D7BC061389;
        Mon, 17 Aug 2020 02:16:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh1so7184409plb.12;
        Mon, 17 Aug 2020 02:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nYi1qCRVXukm3Vys4Ax0zzpvhrxgpQ9/OWRIEzi7jMM=;
        b=mxWi/elPlQYhLXMLOAt36tJYQ+Hp1VAtd/uz+Kc8cIdiewSdg8n95X+KYxSdWGZJ1y
         /1rHnM4HvYeEmKOOLXL2wTqM2vSxMsb9VJZkfdrjZ8c8pWQ4rrQImtoKQ977EHgQ+THx
         Aa919IaWGz3+LC2CnAhGPcCnKZKjEcT2ftL3tbor1l7DdNN51bTmd6wf3G7Uglbn9gd3
         IvO4ciTbor+qNIHbn5ZnArhfiWQHMjs284hcUdKxz9v7/11dHOTVFY1ki+iFopZAQ166
         233J/wFqybY2SkuhDb0GHf7Xk3e7tw+qSNZabUjFckMBu8dhIwFr7uUw3BLLKtx0v0Fq
         3HVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nYi1qCRVXukm3Vys4Ax0zzpvhrxgpQ9/OWRIEzi7jMM=;
        b=lrj+uJxdJpEIamwguU3hYqchl9pkUjOg1PwRFi/AX1gdgtnw6PlM/vtlnggvEKimYP
         lJ+XZ3HSJghOSF5qDeN4B1ACqkEV5jMuhtK/mHWqv4P6mgHfX9DBGjLhpGTteNmGmqFI
         LHNBD1g8VEsV0vSuz+t7SP73tlHY5zi3X0ddCrPuznKrAKxqpNCKkM1XUxyYV2SUJMfq
         DXVn4hZCcHO0WOOKf/P46zAgxhEDWHUrIWpEqIbGF9c7U+fVv6v2YYAuNlQvXzZyfkoY
         4Hurr4n7e/GkpPMPAKiyC72AYOfJ9OPxOAYLnHRS4qHCo2L2wrDsIlmAcPvxWiipKjkb
         hCGQ==
X-Gm-Message-State: AOAM531LIru3JgBdpugP33/3Phz8shnEq+JkBrHNCNfS7ygLLjVNKQtv
        68OA9EMiliiZpLF+p4nKUlo=
X-Google-Smtp-Source: ABdhPJx+wEvCOSvKZxezpdY6lLs7UvfZeX3QH5NUsgJeM5vKZGxtJnJRJpZ8+dEdqnJdMBLPa9KLfg==
X-Received: by 2002:a17:902:8495:: with SMTP id c21mr10840498plo.82.1597655800670;
        Mon, 17 Aug 2020 02:16:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:16:39 -0700 (PDT)
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
Subject: [PATCH] arch: um: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:45:55 +0530
Message-Id: <20200817091617.28119-1-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
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
 arch/um/drivers/vector_kern.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 8735c468230a..06980870ae23 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1196,9 +1196,9 @@ static int vector_net_close(struct net_device *dev)
 
 /* TX tasklet */
 
-static void vector_tx_poll(unsigned long data)
+static void vector_tx_poll(struct tasklet_struct *t)
 {
-	struct vector_private *vp = (struct vector_private *)data;
+	struct vector_private *vp = from_tasklet(vp, t, tx_poll);
 
 	vp->estats.tx_kicks++;
 	vector_send(vp->tx_queue);
@@ -1629,7 +1629,7 @@ static void vector_eth_configure(
 	});
 
 	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
-	tasklet_init(&vp->tx_poll, vector_tx_poll, (unsigned long)vp);
+	tasklet_setup(&vp->tx_poll, vector_tx_poll);
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
 	timer_setup(&vp->tl, vector_timer_expire, 0);
-- 
2.17.1

