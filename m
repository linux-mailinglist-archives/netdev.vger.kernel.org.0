Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B2430993B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhA3XtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhA3Xsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:48:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67945C061574;
        Sat, 30 Jan 2021 15:47:53 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d2so14809514edz.3;
        Sat, 30 Jan 2021 15:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5opFbc9GXOiDzoGX7Mdpij1lxqzsIU+iWus0/IPai1Y=;
        b=gnPSiUQ7XA1pmo8A9e8MOqyvDfgsVhA9FXF2FnSVF17ljc6WUH8ZRJi8oo4aOGKid+
         2VLyXXyu0jGAjnfFBj643k5+p5oaeEilaluaze+QZEzYGW7nxMNBmzW7fGG8x6GpA9dO
         GOUgL81i7pDNxC6id1xoPVpD0RBL5puGy3pr/Z/JxpOR3zwd5TZH98Y2R90qiohx5FlI
         XOaM0hj1Uy2h5sAAiDIN2b5T0rsXPDw/NgbVFsiwElELsrxx8usEv0rc1ZPfdh6r3t+X
         xN/erEoOold2UaIaR9fks+Owd5sKmO8eMPGrqIwXF8Qovd2t+5t/QBRdIYsrrPTCSXJr
         hMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=5opFbc9GXOiDzoGX7Mdpij1lxqzsIU+iWus0/IPai1Y=;
        b=BAuWxPBaWjnzrRMRJQD7DNWJn5Sj+n/TL+ae9/CIPMNC9Fl++s/lB/FhbVgEaQAue0
         YTGP5qSNXim707sEDOpJI7X7KkPcQm/Yd61HkwX1lrbI8ZC4L/p344HHCDkceA1NvHGl
         0LHWgfWn22Y+GJmt4MUTb6ULbGY2v3RNJcq704XXyjhGGk5cCzUtlSMS7YvWjZMqWTIM
         kHHbzU81FtdyQc4RRgzK28tNBsq4ixDTCWJSpWc9qq9dhEC6vbzytUb8CDCYS/kb3/Z1
         EvQfnr+8kZxIbi6Bg56ch6Z8/DFDBG3feJFr/MbX7yVvN0Bp5kdPRkNyK1cE434RHSdz
         KoIQ==
X-Gm-Message-State: AOAM532gzjDG440Q6LhsX+cHa17FKlivS5OsYzXamaHfMHACYyIHIb/K
        KTUZCqKcA1w4jT8UP7G5w8pSxZkqF6h9mkWe
X-Google-Smtp-Source: ABdhPJxT/xoRO4n8PBEt6uAecRXvTXhIeTVTpJIiLGUmKwacac7MDFi4UBTQmzHef6Rfg4Gu6hkjqQ==
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr12230542eds.328.1612050472199;
        Sat, 30 Jan 2021 15:47:52 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:51 -0800 (PST)
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
Subject: [PATCH 1/9] arcnet: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:22 +0100
Message-Id: <20210130234730.26565-2-kernel@esmil.dk>
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
 drivers/net/arcnet/arcnet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index e04efc0a5c97..69d8920e394b 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -393,9 +393,9 @@ static void arcnet_timer(struct timer_list *t)
 	}
 }
 
-static void arcnet_reply_tasklet(unsigned long data)
+static void arcnet_reply_tasklet(struct tasklet_struct *t)
 {
-	struct arcnet_local *lp = (struct arcnet_local *)data;
+	struct arcnet_local *lp = from_tasklet(lp, t, reply_tasklet);
 
 	struct sk_buff *ackskb, *skb;
 	struct sock_exterr_skb *serr;
@@ -483,8 +483,7 @@ int arcnet_open(struct net_device *dev)
 		arc_cont(D_PROTO, "\n");
 	}
 
-	tasklet_init(&lp->reply_tasklet, arcnet_reply_tasklet,
-		     (unsigned long)lp);
+	tasklet_setup(&lp->reply_tasklet, arcnet_reply_tasklet);
 
 	arc_printk(D_INIT, dev, "arcnet_open: resetting card.\n");
 
-- 
2.30.0

