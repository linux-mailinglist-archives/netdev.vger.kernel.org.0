Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5343098E8
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 00:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhA3Xtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhA3Xsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:48:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E9DC0613D6;
        Sat, 30 Jan 2021 15:47:56 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id n6so14747010edt.10;
        Sat, 30 Jan 2021 15:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zRwD9qdAbO8fK598YRqxgb8mENfF+ajdr9W7w7+HkI=;
        b=Ohy7riB2thMin4OEstXOEn/eLXtkv998O6y0+FvfpNSYWu+23y99sNMmDhwS78t4Yq
         NMq7iWUIOsTkKBkCa0h7lRebOEYTeuiG+kvXuoN+GDr39McsTuwlPMHrSSt7Sb4pximB
         ++asPFQkaDe9WD/3/4PkB9fPGpMpvWOvH9yd4KrcmO/FEwhkBXmWVwfpZt1MqxesqZAK
         mCpnJqzWEA6vWSgzY1ngEdH+1GI7lA34WEWYeyyJzH531pfrnq8EO95FyAbg4ucjyPPL
         eDuXhiSdfC7CwdnfrE3Y4uOUQUuBz/neUytCBjmmlXVhyes1YnpbvoYV/yZSNQ6d2mYN
         WcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1zRwD9qdAbO8fK598YRqxgb8mENfF+ajdr9W7w7+HkI=;
        b=J5H9ZrecplGWFDgizAKH1VvCHdie0VS8hI13gW4WsGu+v8+xQ/0aPbcurwXMPffrZ9
         a9T5D9Xit+jQq532L9+rvZM0KqmZVLWmdgwyKZDULXrRY0RTCmdoi6SI86Q6Lc36GdUo
         R0G0y0C4+CuOMsRaDmN7IWsBk9X0LuYbEbEsFSxa6r68KQ0cwykX351F2VwCiNZUBaOi
         yxLj+Cc1yNUjhAgfIto/1k13zXE9DF6yQdcJLjE2aDqcb6mvSm/66XPWfoH8P2829KRY
         SFioH9k1j97FWNNINlCozXHuZcAZmFL8YSNG/r5EBX3pPmYR++2Idp//CpxVcfc7H8G6
         EwIQ==
X-Gm-Message-State: AOAM533WSFeznIPLQfhCl3GZJwopG1zkJ9xornzDuaYJp7wtNFweAZcm
        iVbwsqQCYwxNxKfBRijlCze1foLrJY+3Rl24
X-Google-Smtp-Source: ABdhPJxiIz46Vt1P0xn/IbTDl3Bas4tq2o8OftuhU9qGcPDm2XgWBaZOIX7kG3EQMvyhnncrtuRw2w==
X-Received: by 2002:aa7:cdc7:: with SMTP id h7mr12234530edw.353.1612050475189;
        Sat, 30 Jan 2021 15:47:55 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:54 -0800 (PST)
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
Subject: [PATCH 4/9] ppp: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:25 +0100
Message-Id: <20210130234730.26565-5-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210130234730.26565-1-kernel@esmil.dk>
References: <20210130234730.26565-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the async and synctty drivers to use the new tasklet API n
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/ppp/ppp_async.c   | 8 ++++----
 drivers/net/ppp/ppp_synctty.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 29a0917a81e6..2b66cf301b0e 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -101,7 +101,7 @@ static void ppp_async_input(struct asyncppp *ap, const unsigned char *buf,
 			    char *flags, int count);
 static int ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			   unsigned long arg);
-static void ppp_async_process(unsigned long arg);
+static void ppp_async_process(struct tasklet_struct *t);
 
 static void async_lcp_peek(struct asyncppp *ap, unsigned char *data,
 			   int len, int inbound);
@@ -179,7 +179,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	ap->lcp_fcs = -1;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_async_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead);
@@ -488,9 +488,9 @@ ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_async_process(unsigned long arg)
+static void ppp_async_process(struct tasklet_struct *t)
 {
-	struct asyncppp *ap = (struct asyncppp *) arg;
+	struct asyncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 0f338752c38b..86ee5149f4f2 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -90,7 +90,7 @@ static struct sk_buff* ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *);
 static int ppp_sync_send(struct ppp_channel *chan, struct sk_buff *skb);
 static int ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			  unsigned long arg);
-static void ppp_sync_process(unsigned long arg);
+static void ppp_sync_process(struct tasklet_struct *t);
 static int ppp_sync_push(struct syncppp *ap);
 static void ppp_sync_flush_output(struct syncppp *ap);
 static void ppp_sync_input(struct syncppp *ap, const unsigned char *buf,
@@ -177,7 +177,7 @@ ppp_sync_open(struct tty_struct *tty)
 	ap->raccm = ~0U;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_sync_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead_cmp);
@@ -480,9 +480,9 @@ ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_sync_process(unsigned long arg)
+static void ppp_sync_process(struct tasklet_struct *t)
 {
-	struct syncppp *ap = (struct syncppp *) arg;
+	struct syncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
-- 
2.30.0

