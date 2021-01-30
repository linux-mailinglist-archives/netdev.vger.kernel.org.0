Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B444230992E
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhAaABz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhA3XtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:49:18 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B412C06178A;
        Sat, 30 Jan 2021 15:48:00 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a9so198181ejr.2;
        Sat, 30 Jan 2021 15:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H1Cm87epGk3yHYnXa/HQswxlCoCs7d3pmbS6SaZIvj4=;
        b=TJXAnUPIZF10U5PRVBvJdbP2vJux0LwiO3RRWlJviahAakyN78HEwz2dUa7HF6dmmO
         7TMNBrg3tVG2YXp7U93Z+EFb5wNOKvX8RtpY4QR6HehnL4kEEPRwYNUsgVZ0ppnALdFP
         uEPky/DLZMKJunM5ba3+usxTJd5+B5zfqHqm83MrIpkt/s75f9yROcEr9u6NNQov2aJA
         R14gkm8sDmwB3a6cdnWpknyVEY1tP09cunI4nexbe22bk3Grvw/J5ZAPEqZKSqam1yD0
         GMcuVQtuyq5DSASAqRNIFPfauwlpHbkKygSKfBZsp1FK1CQHgLT1PuIViq6RkJcM3sXD
         Jeag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=H1Cm87epGk3yHYnXa/HQswxlCoCs7d3pmbS6SaZIvj4=;
        b=qlOMjt3LJK3VicYPg07RwJXMdktjb5+1/SY+hDOMZFrwVna2vQr4orjck38kn/hLLp
         fsYhiWUrkjlreCRuTFl2vaRwdbZjfYYpnY/z0A1zM2kGcwBgMGHfsrS2Fshmn3ABbvSM
         4n287eGHAjpgpbpWuUfwj5WvVLvo1TwBQVdM87GAbn7WykawwTnyC/KR4jeBL6wDakVz
         xBzDAHptvzTXnltvkNtyqUtHnKduvxu01ziJc/EIIR6PBT73I8sPJ6qLFDuWcOJV6u/S
         TaWgkuowah1F71TtnDcUHc5yneV0lQYopJ3oIUmVMYD+Xiv4zh8IXrTtfw0aZL+7vrdK
         RyuA==
X-Gm-Message-State: AOAM5310GeEwk0uQkSmZxGN8qY4V4LPZVQfEF5qNfLHO99MOeDOgNeCS
        JTLLJwDmqEIbs0HEMxdKkwUs5XgJGnGDqOVm
X-Google-Smtp-Source: ABdhPJzVZQCuacEHAoUL9tmDvVCy+E07YZGMhK0kuMceg4CjgHl97CiERxEwjneP2WiYS2xngi2dNQ==
X-Received: by 2002:a17:906:a450:: with SMTP id cb16mr11315700ejb.167.1612050479257;
        Sat, 30 Jan 2021 15:47:59 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:58 -0800 (PST)
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
Subject: [PATCH 8/9] net: usb: r8152: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:29 +0100
Message-Id: <20210130234730.26565-9-kernel@esmil.dk>
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
 drivers/net/usb/r8152.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 67cd6986634f..0d7d2938e21d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2393,11 +2393,9 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
-static void bottom_half(unsigned long data)
+static void bottom_half(struct tasklet_struct *t)
 {
-	struct r8152 *tp;
-
-	tp = (struct r8152 *)data;
+	struct r8152 *tp = from_tasklet(tp, t, tx_tl);
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
@@ -6714,7 +6712,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	mutex_init(&tp->control);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 	INIT_DELAYED_WORK(&tp->hw_phy_work, rtl_hw_phy_work_func_t);
-	tasklet_init(&tp->tx_tl, bottom_half, (unsigned long)tp);
+	tasklet_setup(&tp->tx_tl, bottom_half);
 	tasklet_disable(&tp->tx_tl);
 
 	netdev->netdev_ops = &rtl8152_netdev_ops;
-- 
2.30.0

