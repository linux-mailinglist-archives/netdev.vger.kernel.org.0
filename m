Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544273EA0AA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhHLIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbhHLIiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:38:50 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FF6C061765;
        Thu, 12 Aug 2021 01:38:25 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l18so7126774wrv.5;
        Thu, 12 Aug 2021 01:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cL+v+mJZbDKu3E2nlPu3obY4wZvMWp8Bfgw61KaUc+c=;
        b=TZ7IbqEG0XsYEqaghS48DqkPbgkgq2SiegVWWaDJyPC9XDFaX/Ehf37TF0aIf99c3G
         EQJ9EEofayWY6CNxWoZ8pTtgqzIiw5JyGe9Y3vv8JkqSqHBdhZikdy3RBU56ZXpIWIjq
         Z27hglTJYKx62BrTB2ia+7WE437mqyX0cs6BWL6xK3k4JSSIEzb7oR1D9ddmNtbScgR/
         Nzg/Tsn63qSUQ2iYWPPy0TvbfRTRfNU8aeS+RYUidDUNNgN+7bt3hjRacRJ4X4yAem0L
         Sb6yn96gqzYNrh3sDKudVmSWMmISerR2qYyeUySr+GhRDCsmGp20SngF2AcFaV+ygGLK
         yyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cL+v+mJZbDKu3E2nlPu3obY4wZvMWp8Bfgw61KaUc+c=;
        b=E7anmYB9Sq/Whtt3cehhRrBD8ytCRfotc5PohHXbRz1uAh9LCDHPCTtY5LY06sb6rI
         JreVtxrALwZIk6onLsg02GPuh0K0GNc1RDw9YVZJU+G/9nHDZG6f5yKzQ5dV1BAI1zY8
         ELI/I1JoNeN9KSutSMWGSR+O45npumsXiqkhfeazQUF29L6YXIXE/oHWR4mTChfp91Xq
         poyYAaVSGtPNGVCqkejCFUJeWcY17ikh88KzY3Li8M1jENGUtuHiijlMGY+MWnGBcWu8
         upa/W9xJmndUbvKPfsL1cxCIvi0cu+njIkN+ph1tR+eODWsoT9iY1Y7SKu5SXTfVMDN3
         OQPQ==
X-Gm-Message-State: AOAM531QVz8LIfHjORYPBieV+VZLVzP5/0tNf0bDoVHHKV4PidSrsA5d
        F5TY1bKIE+m9aZVzwU/NAL0=
X-Google-Smtp-Source: ABdhPJyGcP5E5bvL7hCNHMtcf5+5UgEIIfswf9J9LSqwn9LkPsKFHeUfoYOv9bDTUZV3xE5brKV4uA==
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr2720662wrw.76.1628757503921;
        Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d76:9600:40d6:1b8e:9bb5:afdf])
        by smtp.gmail.com with ESMTPSA id 9sm1830324wmf.34.2021.08.12.01.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 2/3] net: 802: remove dead leftover after ipx driver removal
Date:   Thu, 12 Aug 2021 10:38:05 +0200
Message-Id: <20210812083806.28434-3-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7a2e838d28cf ("staging: ipx: delete it from the tree") removes the
ipx driver and the config IPX. Since then, there is some dead leftover in
./net/802/, that was once used by the IPX driver, but has no other user.

Remove this dead leftover.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 net/802/Makefile |  1 -
 net/802/p8023.c  | 60 ------------------------------------------------
 2 files changed, 61 deletions(-)
 delete mode 100644 net/802/p8023.c

diff --git a/net/802/Makefile b/net/802/Makefile
index 19406a87bdaa..bfed80221b8b 100644
--- a/net/802/Makefile
+++ b/net/802/Makefile
@@ -8,7 +8,6 @@ obj-$(CONFIG_LLC)	+= p8022.o psnap.o
 obj-$(CONFIG_NET_FC)	+=                 fc.o
 obj-$(CONFIG_FDDI)	+=                 fddi.o
 obj-$(CONFIG_HIPPI)	+=                 hippi.o
-obj-$(CONFIG_IPX)	+= p8022.o psnap.o p8023.o
 obj-$(CONFIG_ATALK)	+= p8022.o psnap.o
 obj-$(CONFIG_STP)	+= stp.o
 obj-$(CONFIG_GARP)	+= garp.o
diff --git a/net/802/p8023.c b/net/802/p8023.c
deleted file mode 100644
index 19cd56990db2..000000000000
--- a/net/802/p8023.c
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *	NET3:	802.3 data link hooks used for IPX 802.3
- *
- *	802.3 isn't really a protocol data link layer. Some old IPX stuff
- *	uses it however. Note that there is only one 802.3 protocol layer
- *	in the system. We don't currently support different protocols
- *	running raw 802.3 on different devices. Thankfully nobody else
- *	has done anything like the old IPX.
- */
-
-#include <linux/in.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <linux/slab.h>
-
-#include <net/datalink.h>
-#include <net/p8022.h>
-
-/*
- *	Place an 802.3 header on a packet. The driver will do the mac
- *	addresses, we just need to give it the buffer length.
- */
-static int p8023_request(struct datalink_proto *dl,
-			 struct sk_buff *skb, unsigned char *dest_node)
-{
-	struct net_device *dev = skb->dev;
-
-	dev_hard_header(skb, dev, ETH_P_802_3, dest_node, NULL, skb->len);
-	return dev_queue_xmit(skb);
-}
-
-/*
- *	Create an 802.3 client. Note there can be only one 802.3 client
- */
-struct datalink_proto *make_8023_client(void)
-{
-	struct datalink_proto *proto = kmalloc(sizeof(*proto), GFP_ATOMIC);
-
-	if (proto) {
-		proto->header_length = 0;
-		proto->request	     = p8023_request;
-	}
-	return proto;
-}
-
-/*
- *	Destroy the 802.3 client.
- */
-void destroy_8023_client(struct datalink_proto *dl)
-{
-	kfree(dl);
-}
-
-EXPORT_SYMBOL(destroy_8023_client);
-EXPORT_SYMBOL(make_8023_client);
-
-MODULE_LICENSE("GPL");
-- 
2.17.1

