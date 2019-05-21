Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7EE2584B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfEUTaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:30:55 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45824 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfEUTay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:54 -0400
Received: by mail-qk1-f195.google.com with SMTP id j1so11776632qkk.12
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E9qpYWzMct/oNX/WojYYzQyUR7f9T+jjfQePTtF04G4=;
        b=H+a/FVsNXjX4L40NoPsX86+kmRHvzLA6A3JMlohLHS/sl63F+KNQh1W+NyVi2pnCxr
         S5Jqvc+bJ5DpHOJvZB/Ip5m9AfX/3x+ug0WTuFwczwecAydozweq+RoS8vXxZ/5VrzmO
         Y2t485B9WXME4LE5MROcJNmhxoZK9ukvkXBvkwiKbiE7LCJQtKWpUw/O9jqHRSkrXUd5
         iRzECLC+OBBKCu1ziM6RuiI5F32Y02bUQw9xycPBGFmePiWDBqUhLYqvV5OI/F69f+qa
         u6nZKS+ulQyJa4RGhR0poPM4nO8uZr9u2Bx4jcDKgVfANOXcJIcyjDtGSKYxDsQMFJQQ
         4Ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9qpYWzMct/oNX/WojYYzQyUR7f9T+jjfQePTtF04G4=;
        b=j7h6FX5mmBqdZ5Sl9Ngx9YYqnufN+3cPQHaaqoPptUjZtzgMeg3H63onNh4C04v9v5
         7oUQScmsdeFUTNkkuB4Z082YmOxEYH/eqDfxMza9bZM0h940j9VbDoby81aN7PoEeHEl
         Hb3qmIfg5LgIkOuCFtRUrqVICl6YUw7r9IZGb089LNctDfFv6gbM1H7gkXSX2yH2gMcr
         xypP5+feFmbTLJrN2hutd0fikpr1qUONPAJSqh9fSDZsO/yss2VGWLOTW9doZfaS/J7e
         gIvzrdt7UQb67gsLf6AEpgWFbeCv/zRfdDY9U7AahBuXey2OVm2HbgXPsRh0q2UoMSNA
         H+2g==
X-Gm-Message-State: APjAAAU3ftt4/S1KfUOl74e4enrDuJfapexoqmrZSdgBv/ZF4zOj2p/Q
        Knj4SxmCs3sltdj83P6Z48kKIVUb
X-Google-Smtp-Source: APXvYqzFAsz4RxMvRdoKv1BThI1eCtMvRi4k72xp/1Cq27pur5tGbFS2Ip1HorN3YZemREN//YH4uA==
X-Received: by 2002:a37:4e8d:: with SMTP id c135mr13759336qkb.120.1558467053347;
        Tue, 21 May 2019 12:30:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j10sm9450962qth.8.2019.05.21.12.30.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:52 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 2/9] net: dsa: allow switches to receive frames
Date:   Tue, 21 May 2019 15:29:57 -0400
Message-Id: <20190521193004.10767-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a rcv DSA switch operation to allow taggers to let the driver of
the source switch to process the received frame on its own.

At the moment, only DSA and EDSA taggers make use of this hook.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h  | 5 +++++
 net/dsa/tag_dsa.c  | 6 ++++++
 net/dsa/tag_edsa.c | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 685294817712..027bb67ebaf7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -543,6 +543,11 @@ struct dsa_switch_ops {
 	 */
 	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
 					  struct sk_buff *skb);
+
+	/*
+         * SKB Rx hooks
+         */
+	bool (*rcv)(struct dsa_switch *ds, struct sk_buff *skb);
 };
 
 struct dsa_switch_driver {
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..20688674e00f 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -63,6 +63,7 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt)
 {
+	struct dsa_switch *ds;
 	u8 *dsa_header;
 	int source_device;
 	int source_port;
@@ -87,6 +88,11 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	source_device = dsa_header[0] & 0x1f;
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
+	/* Allow the source switch device to process the frame on its own */
+	ds = dsa_master_find_switch(dev, source_device);
+	if (ds && ds->ops->rcv && ds->ops->rcv(ds, skb))
+		return NULL;
+
 	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
 	if (!skb->dev)
 		return NULL;
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index e8eaa804ccb9..2ba3d48a23e2 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -76,6 +76,7 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 				struct packet_type *pt)
 {
+	struct dsa_switch *ds;
 	u8 *edsa_header;
 	int source_device;
 	int source_port;
@@ -100,6 +101,11 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	source_device = edsa_header[0] & 0x1f;
 	source_port = (edsa_header[1] >> 3) & 0x1f;
 
+	/* Allow the target switch device to process the frame on its own */
+	ds = dsa_master_find_switch(dev, source_device);
+	if (ds && ds->ops->rcv && ds->ops->rcv(ds, skb))
+		return NULL;
+
 	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
 	if (!skb->dev)
 		return NULL;
-- 
2.21.0

