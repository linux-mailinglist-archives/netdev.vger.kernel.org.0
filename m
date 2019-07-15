Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA9C682A2
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfGODT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 23:19:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46340 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbfGODT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 23:19:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id i8so6981492pgm.13;
        Sun, 14 Jul 2019 20:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dE4s0OhkbyjtLoyb2cJC6b5aCQ/NmMNOFMVLWNoGJqs=;
        b=b1IfCBLKMhumYmRbCzq/AJukPBRYV2V8P0kpS4mf3HHbtXyjW8fBQhF6KDCIuREKoY
         Vr3vcJHmg8yINW1wnYUIbULvVZy0+gRthgKHobn+fQxc2rRkzgJIwgvca8g2jin5947Z
         iOTFuZYdWXcO4fssJTcW5zuyaI8Aq8GSLQnZp/3A1ycchbBFbDYcs6tiDvwpIrFKYhTw
         9eGEFYi8dborhS8ztPnhnh1TTqoB9DdsWg3/mIx1eF6ccUniQTRxg5RNtblwdlA5g+gb
         O7hoaYb3uaD5iyqKLnJC6am8MH2tAdP4QcKNKJm2VAZ2zGgUCYYz8bLRSzgCcSnJ/Rdc
         1gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dE4s0OhkbyjtLoyb2cJC6b5aCQ/NmMNOFMVLWNoGJqs=;
        b=K30prT4UIW8XBRROLBN5y9EeThXZBjwypK0Cg4wp9ccCahZK+TnGjR/dH0ycCWDaUX
         MsHcZMBwexQxfukVNL+iRQRRZga4EkEeahlKFNGzqeVmwdO3zqjl6/2oYqXXy2jjTEJy
         1cRK11Mj/GfUNrfYV+tSk1XV2CA96SlBXlQqYW7Gm4gOXk3gEKffPD17S1T4FBP7BrHZ
         4gVN5z8reuMV8RjvTqiNi8Hh/Qknn8jobzerYVnlXsmcBTN5unWw7MW2DB9mSdBNC4Bh
         CwZaqxIbf9ryqf+KhjxauqjmUlFO0Gs8ZJ1MF4zqw785mxIcYIYRXgL72zbo2uZCppbc
         VdrQ==
X-Gm-Message-State: APjAAAXpttwX+1Q6O4yQTqTbWnzIxPMsFAarR7iuZtIKPgQpmVGYigu1
        UN+if1rGVysPHBnnFmnYS5o=
X-Google-Smtp-Source: APXvYqxc2nuUXVbW6u86m0y7dv6PsETlYZO01VmTOr4ntxX+qVtEOZm2HAx/njgdKvxSK984x/6NlA==
X-Received: by 2002:a17:90b:d8b:: with SMTP id bg11mr26744825pjb.30.1563160767835;
        Sun, 14 Jul 2019 20:19:27 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id o35sm5683496pgm.29.2019.07.14.20.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:19:27 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        "David S . Miller" <davem@davemloft.net>, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 18/24] hippi: Remove call to memset after pci_alloc_consistent
Date:   Mon, 15 Jul 2019 11:19:21 +0800
Message-Id: <20190715031921.7028-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_consistent calls dma_alloc_coherent directly.
In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/net/hippi/rrunner.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 7b9350dbebdd..2a6ec5394966 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1196,7 +1196,6 @@ static int rr_open(struct net_device *dev)
 		goto error;
 	}
 	rrpriv->rx_ctrl_dma = dma_addr;
-	memset(rrpriv->rx_ctrl, 0, 256*sizeof(struct ring_ctrl));
 
 	rrpriv->info = pci_alloc_consistent(pdev, sizeof(struct rr_info),
 					    &dma_addr);
@@ -1205,7 +1204,6 @@ static int rr_open(struct net_device *dev)
 		goto error;
 	}
 	rrpriv->info_dma = dma_addr;
-	memset(rrpriv->info, 0, sizeof(struct rr_info));
 	wmb();
 
 	spin_lock_irqsave(&rrpriv->lock, flags);
-- 
2.11.0

