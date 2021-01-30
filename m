Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1576A309938
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhAaAFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhA3XtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:49:15 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B7AC061786;
        Sat, 30 Jan 2021 15:47:58 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id rv9so18534735ejb.13;
        Sat, 30 Jan 2021 15:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0v5iUM3eT/Ti20q6q3wWUPuMtx4BAW9jWHtnT7+e1x0=;
        b=jZi79RK3zOvgTyMxfQZEtxWUx5P6eDuovUByfA9QylBMoW85T7Tp0l9kLjCGvOp9f7
         nqVTP4d//0v/S5xfdFn7n180vNe7RHKk5/J/MZ1MRq8k9HhGpWpE59SQjgft8gW3CkYw
         y62iMD+x2FLr1u9xDXqbJ/q6xaTbcKpb4k3PqCGBjFL6VzRZZlqet1FXVwQzOW99OPyT
         Mic9FKuYQ7enAWA7jDwfknEQ4sXATzg4DbjfiYnnshibJwnU0RLcJ0AjtuVKuQJCifa8
         NST47QVBz/DqOZ0HC9R5X/i+q5F/b9V6t0WlH/lKHQ3eiSNf1mrqbPdmPR3MunTWcSIi
         V4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0v5iUM3eT/Ti20q6q3wWUPuMtx4BAW9jWHtnT7+e1x0=;
        b=bI6O5tBRSIqdwdwpjH7j7RySHurJwpC6fl6st2Aq15r7Ze+skFQU8cfjGh0PLQ8BDr
         GMsVJ5oz3M1UiQqk7s2DYNzFcK47aPq/T/Tb153efaEfBZBo0nTq0bjba2A9Wwud718Y
         O2WSlydIaqoXYl2oTUbciZeIVGzMnCgLVeJmtSmQI6Fyk3xdyiu3IzFJySo1uM7hyGge
         yAfb49Hlq0ceN5o62d+wZazoc5YI0KLG57NqctIGfFk1WW18wQrWpkmJMTWZa1wHxOG/
         t9BnB0tIFBv2RWBpJtIGPowp174MEBgDXcLGF97wW5tGwbFZ8Qqb5CxhLiBodnj6Q6Oe
         IwEw==
X-Gm-Message-State: AOAM5338ZaWu6kL67s+qVOw3IRo/gM/UrsHW32wa1POPn+xF+FbENCmp
        l/N8n5NA69O/6lX/dLpsHD+ZhaEkpv/bz1U6
X-Google-Smtp-Source: ABdhPJxa055rLt/kprUEzHj/QF/UnfhydMDdukv7bcT6+oULsgxWoaTsoV3hJmZosgqEMVGg/wJigw==
X-Received: by 2002:a17:906:3fc4:: with SMTP id k4mr10765930ejj.137.1612050477214;
        Sat, 30 Jan 2021 15:47:57 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:56 -0800 (PST)
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
Subject: [PATCH 6/9] net: usb: lan78xx: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:27 +0100
Message-Id: <20210130234730.26565-7-kernel@esmil.dk>
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
 drivers/net/usb/lan78xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index bf243edeb064..e81c5699c952 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3375,9 +3375,9 @@ static void lan78xx_rx_bh(struct lan78xx_net *dev)
 		netif_wake_queue(dev->net);
 }
 
-static void lan78xx_bh(unsigned long param)
+static void lan78xx_bh(struct tasklet_struct *t)
 {
-	struct lan78xx_net *dev = (struct lan78xx_net *)param;
+	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
 	struct sk_buff *skb;
 	struct skb_data *entry;
 
@@ -3655,7 +3655,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 
-	tasklet_init(&dev->bh, lan78xx_bh, (unsigned long)dev);
+	tasklet_setup(&dev->bh, lan78xx_bh);
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
-- 
2.30.0

