Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D231C26C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBOTYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhBOTX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:23:57 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40F8C0613D6;
        Mon, 15 Feb 2021 11:23:16 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id x3so5565792qti.5;
        Mon, 15 Feb 2021 11:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLfHN6LcDUzKrVZ3/a8BfPtAMufAeFUsNalZ5o2tDws=;
        b=is6E/bzAxVUziPgetRNnBsHKtwmlfrGyLgpOk+08tUx566mBZJaasFmvB2C66fhOVy
         6cjv06D5Wp1LAmHAtVV50SUrYTRbXD9pYMa2qUUOiLilJBVa1Ax8XjCFju5A9oiGjlCh
         WII8M9BkMkF8Dv2n6X1bjC+LAZ4KDfIOhbbNCPirIAHBFBanNg3xJRDbfpQbl7PWzuhP
         Cc/HwS2rBjJ+ILZyodm5XbdFZUD4+t9pobVzgo9+08wyL+Ip7746/33QA6gXxctZ/JNc
         pwhABwWuoE5lsgMLOedKjLCU/InmmyvGKHFs7Cd6Ffrk/hTLf1yIX2+fAn3pQSy0ZqAb
         ToGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLfHN6LcDUzKrVZ3/a8BfPtAMufAeFUsNalZ5o2tDws=;
        b=b5gMHP7thq96gLAs9IKg+JVAp9tc7g5+06lMy9eoIFFweCYONq9pDj5ARt1XngnNhg
         lLVthf6CwjetouP/unMTle6TR9g3C6Ac/IgIaSA37y6VQSm8ZpxfIYRjscXD6t8p44oJ
         ZMTJ3kqH0zpk2BY5b0CHOQVs0vLze1GCOvTjJACuRJk3qyt+RLEEa1BeJWLPBD7Mik6+
         RE3cvRzqWfc8YiPjjQrjH9yVKc4LWRiOAfHTx5Ow58MuxNC8OXiQs+d8jNmJCIfti3lg
         PLl4J3nWEcD2stT7fRiXIs2VJn++KbYxjVfmq9WYWkIX4kjVLVfE/JRV/LfkNAj+bZTW
         xlUg==
X-Gm-Message-State: AOAM530EHC4QV311D4jBLb274MhVbrwjl7quenKeEIy+nVCd63M1oV2Q
        KhTlsqJy1HQM++bqdQIzVZ8=
X-Google-Smtp-Source: ABdhPJxc6wsNPqjAraN+xwMTNx5Bvy7sj29Wi2KI4AloenZaP7+XKMe+GohyMzPkUDC5jek/l52HLw==
X-Received: by 2002:ac8:4751:: with SMTP id k17mr15867074qtp.46.1613416995971;
        Mon, 15 Feb 2021 11:23:15 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:48a6:eef1:8ac9:fd76])
        by smtp.googlemail.com with ESMTPSA id f128sm4131085qkj.45.2021.02.15.11.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:23:15 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tong Zhang <ztong0001@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wan/lmc: dont print format string when not available
Date:   Mon, 15 Feb 2021 14:23:07 -0500
Message-Id: <20210215192308.2668609-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev->name is determined only after calling register_hdlc_device(),
however ,it is used by printk before the name is fully determined.

  [    4.565137] hdlc%d: detected at e8000000, irq 11

Instead of printing out a %d, print hdlc directly

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/wan/lmc/lmc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index ebb568f9bc66..6c163db52835 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -854,7 +854,7 @@ static int lmc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&sc->lmc_lock);
 	pci_set_master(pdev);
 
-	printk(KERN_INFO "%s: detected at %lx, irq %d\n", dev->name,
+	printk(KERN_INFO "hdlc: detected at %lx, irq %d\n",
 	       dev->base_addr, dev->irq);
 
 	err = register_hdlc_device(dev);
-- 
2.25.1

