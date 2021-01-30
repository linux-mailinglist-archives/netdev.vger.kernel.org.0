Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B80309930
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhAaABZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhA3XtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:49:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793BCC06178B;
        Sat, 30 Jan 2021 15:48:01 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c2so14752851edr.11;
        Sat, 30 Jan 2021 15:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ClukBPu+CYzsZoBz7wV2vFswdP1FSRh8zSK4OVbxTg=;
        b=LR8tfNCxCknUbtdIjDpZOfe2+uThFtGib/Yfq0wcUy1mi+le6/6wPRmpJmh4Co5Ipo
         KrGfVpsMfasytLcyfIwnUIwzmICWAqPuFuPGwm5/vr+qbkJqNTEHXy/4T3IekfaAiBtR
         f+jjBrnLNa0VkOK5w3soXT1boKghPyAm4mPY0stUvfBU4WgHvy41CMKaM18bOLL2K/rY
         0yipkrTtBB/3rS4JMZTcwQDOYE7HEwot0GYSTwzn/bLIsGYP0tmQGhpfXDVPsuF49GWl
         RyaWFzhtW2eBXwRfFkCiMviK5lxQpl/U+zzuRyHWRSn2u5Xha210DVWqCVOESzi/DHR3
         6ARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=4ClukBPu+CYzsZoBz7wV2vFswdP1FSRh8zSK4OVbxTg=;
        b=fI6keJQg5El1YO7mtXcQ8uCfKJWJJBaJoQh7v1o5U+hJOuv8Hq248jqVES6P2eJqaN
         GJFaj9QTLwtANY9EaEwROH3hH8halqs3+s/VSDZw3z1zFnIf7b0ymdPA8t8kf5A5O6p1
         YdivlIIk5CJvKiycjB8bwisw8gwdPslxXnFRfipZfYxJb59TTYn4RilMC2VoxV29vfrX
         X/gxYRVoEtnrUdj9Hxcypd+6ModUYzV8001IC2viTiHcjUtjGmeq7YhF0lw0GLx2JG1+
         RP1N8nXbq5UTjkF/utrkjsL5qsn3xwpp+8lFC3S4XXhtQ1cTjGqgEKlVNelE7ACHK5Bx
         G+Qg==
X-Gm-Message-State: AOAM5319O4Z42fFv0MCjjS8MENwuxDscPBvHXNH9g57BE1bpJgP9gmgw
        DF+XNGIXqcWgHSJMvLletxmhh9t2JX4/J//C
X-Google-Smtp-Source: ABdhPJwNkQ4S/Zil30PaizXC32fjiWhgKh2kcrkZDrtkS9FXIguHxJZ5gBPRq7WSBzRkLzYecjVHEQ==
X-Received: by 2002:a05:6402:22a8:: with SMTP id cx8mr12211009edb.32.1612050480283;
        Sat, 30 Jan 2021 15:48:00 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:59 -0800 (PST)
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
Subject: [PATCH 9/9] net: usb: rtl8150: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:30 +0100
Message-Id: <20210130234730.26565-10-kernel@esmil.dk>
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
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index bf8a60533f3e..7656f2a3afd9 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -577,9 +577,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -878,7 +878,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.30.0

