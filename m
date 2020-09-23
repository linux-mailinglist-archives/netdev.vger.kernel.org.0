Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2F275FA1
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIWSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgIWSSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:18:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E04C0613CE;
        Wed, 23 Sep 2020 11:18:23 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f2so216247pgd.3;
        Wed, 23 Sep 2020 11:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXe+Xi2hqeDB8MW7GyGTEglCxm3DJb1+87Kb1HBQWfg=;
        b=dcrRSZIM8n7Pb8lEpy1uBQjkoW07HJcmt5qqW2sAXWPsWKzSXi4+TY5gn+DbB8npg3
         m6gOP8ephpLSkfq5mkNZJBhZiwsyyZ4uBceieghZcbq0eNZAVpZTYkSRlrb3ClxXAeRo
         5cJwcFH68SlvDSIB8LtThRnl46bn3gQ3YrepcsctnbCJSVdltGvkTM3IGVTNvz5mzRqa
         tV8zAPjUgcsGVwMiRpkf64XYqtJ53O+93Gf3egDwwhU9JJA8jkljFkQNg81JZSB6YPZk
         QRt1SPR5MKKW6n1Uc3nKV/PqjT6gqUGAjipxJD7kDPCnKd5w6uW8XQQr2wGOMVvP0nqL
         6Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXe+Xi2hqeDB8MW7GyGTEglCxm3DJb1+87Kb1HBQWfg=;
        b=MHl3Tl71Ywymoatf+QSa0GfMANrj1ib/KQwW7NCjfNj2+GQlM/7M8TtTbX+YQetodY
         vCW9v+oWQrdZqs2H29lBjPPPHB4eOf8w4znE4YEHI385MolzWKYQdpc3Lj4ooycgc/xJ
         nK2LVbBA//pwv3hACsy8v6KDiJ7Kmt6fhlJmLr28Ixd/cOHqeOBtzd+q6tHFgAGVUlOH
         wYG8aClXVU3/y0y933EHtuK9HigAjrTcDeqofsQuG+udt66S7ink0iIOQhSuYNLaG7Fh
         JDAPK6pjMuyBf0ru+GfyfVV8eYBZabGU4d4hpzyOagKNgIzbogLPYhYBpWq6j44aXLsK
         gukg==
X-Gm-Message-State: AOAM531vbLhbkTGaBXYBoVvQJiWwBDo2pQjJyZhdetGX3OLc7H04CruT
        FBIukH3mU2N/M3HVpBDfkA1LYqUDjHc=
X-Google-Smtp-Source: ABdhPJzpQHKL/4vlUVobCdQXxCV7Z04CNMzQRVpRqdeCAwPFB4zCExxsX9vIteOjtAk6PgEz6jQThA==
X-Received: by 2002:a63:ea4f:: with SMTP id l15mr803127pgk.434.1600885102711;
        Wed, 23 Sep 2020 11:18:22 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a59c:1afa:6c3b:76b3])
        by smtp.gmail.com with ESMTPSA id q15sm561446pgr.27.2020.09.23.11.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 11:18:22 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net v2] drivers/net/wan/x25_asy: Correct the ndo_open and ndo_stop functions
Date:   Wed, 23 Sep 2020 11:18:18 -0700
Message-Id: <20200923181818.422274-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
Move the lapb_register/lapb_unregister calls into the ndo_open/ndo_stop
functions.
This makes the LAPB protocol start/stop when the network interface
starts/stops. When the network interface is down, the LAPB protocol
shouldn't be running and the LAPB module shoudn't be generating control
frames.

2.
Move netif_start_queue/netif_stop_queue into the ndo_open/ndo_stop
functions.
This makes the TX queue start/stop when the network interface
starts/stops.
(netif_stop_queue was originally in the ndo_stop function. But to make
the code look better, I created a new function to use as ndo_stop, and
made it call the original ndo_stop function. I moved netif_stop_queue
from the original ndo_stop function to the new ndo_stop function.)

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from v1:
In v1, I moved the x25_asy_close call to x25_asy_close_tty.
Now, although I still want to do that change, I think it may be better
to do that in a future patch.

---
 drivers/net/wan/x25_asy.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 7ee980575208..c418767a890a 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -464,7 +464,6 @@ static int x25_asy_open(struct net_device *dev)
 {
 	struct x25_asy *sl = netdev_priv(dev);
 	unsigned long len;
-	int err;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -490,14 +489,7 @@ static int x25_asy_open(struct net_device *dev)
 	sl->xleft    = 0;
 	sl->flags   &= (1 << SLF_INUSE);      /* Clear ESCAPE & ERROR flags */
 
-	netif_start_queue(dev);
-
-	/*
-	 *	Now attach LAPB
-	 */
-	err = lapb_register(dev, &x25_asy_callbacks);
-	if (err == LAPB_OK)
-		return 0;
+	return 0;
 
 	/* Cleanup */
 	kfree(sl->xbuff);
@@ -519,7 +511,6 @@ static int x25_asy_close(struct net_device *dev)
 	if (sl->tty)
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 
-	netif_stop_queue(dev);
 	sl->rcount = 0;
 	sl->xleft  = 0;
 	spin_unlock(&sl->lock);
@@ -604,7 +595,6 @@ static int x25_asy_open_tty(struct tty_struct *tty)
 static void x25_asy_close_tty(struct tty_struct *tty)
 {
 	struct x25_asy *sl = tty->disc_data;
-	int err;
 
 	/* First make sure we're connected. */
 	if (!sl || sl->magic != X25_ASY_MAGIC)
@@ -615,11 +605,6 @@ static void x25_asy_close_tty(struct tty_struct *tty)
 		dev_close(sl->dev);
 	rtnl_unlock();
 
-	err = lapb_unregister(sl->dev);
-	if (err != LAPB_OK)
-		pr_err("%s: lapb_unregister error: %d\n",
-		       __func__, err);
-
 	tty->disc_data = NULL;
 	sl->tty = NULL;
 	x25_asy_free(sl);
@@ -722,15 +707,39 @@ static int x25_asy_ioctl(struct tty_struct *tty, struct file *file,
 
 static int x25_asy_open_dev(struct net_device *dev)
 {
+	int err;
 	struct x25_asy *sl = netdev_priv(dev);
 	if (sl->tty == NULL)
 		return -ENODEV;
+
+	err = lapb_register(dev, &x25_asy_callbacks);
+	if (err != LAPB_OK)
+		return -ENOMEM;
+
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static int x25_asy_close_dev(struct net_device *dev)
+{
+	int err;
+
+	netif_stop_queue(dev);
+
+	err = lapb_unregister(dev);
+	if (err != LAPB_OK)
+		pr_err("%s: lapb_unregister error: %d\n",
+		       __func__, err);
+
+	x25_asy_close(dev);
+
 	return 0;
 }
 
 static const struct net_device_ops x25_asy_netdev_ops = {
 	.ndo_open	= x25_asy_open_dev,
-	.ndo_stop	= x25_asy_close,
+	.ndo_stop	= x25_asy_close_dev,
 	.ndo_start_xmit	= x25_asy_xmit,
 	.ndo_tx_timeout	= x25_asy_timeout,
 	.ndo_change_mtu	= x25_asy_change_mtu,
-- 
2.25.1

