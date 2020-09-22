Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809C82743A8
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgIVN56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgIVN5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:57:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A11C061755;
        Tue, 22 Sep 2020 06:57:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so12531984pfd.3;
        Tue, 22 Sep 2020 06:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJ6p6KQrFHv/X0gpBRR8tAtaYHzz851/rFcYD/vBdOI=;
        b=ePjTJvVQH1Vw/PEOrpuUHva9+mLlnwB/qKuH0+uB+MENSmJXg1HOdl7gjQ3iAXelHQ
         g9SoUf/O1ORkp1hL2jW1acBEig0U2V3MbL9oFx1XDBbB34cvCC+cvzRq2Y+GX43cbDqP
         75xt+WjcQkpuC0FGSW+NB95VPOWZXQKLQWu9/vQaddgsOzg37jaEHMmg6f5Jow/kUXpk
         Dmbag9eyNKZxBoY7zRpCiIUq6HC19I2glVcXzToPcv509LBE24ktlh1H4VGcF+DmGk5t
         mzhnuU1lkXDGGIh60R8ctxAAg707dCMpkdPH9wpBP9rPHuQ71YM58VHWUgf9NFdhsLYR
         UUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJ6p6KQrFHv/X0gpBRR8tAtaYHzz851/rFcYD/vBdOI=;
        b=j5xdLkSsR9rf0+Nqu2EdNRiuEjc+7V55bo9sPEuyNW0eDPVWXR83E+wr5+CX/ViWpX
         oS41wf92YRXjaz8LTDLTZtl15hI/VPFuxZ3DXAOs4OM+LkbVROCgv5Id1vCYIZBiDbMj
         +FJ7Zb7hFwM9AnCSXn2hwDO8XK8uU6Lmi6EFTgHxmQvPEMfAvzOD44fSKqPRNqPVoJMY
         tJQcFxiavhjli8a+Ya6tv8sUbT1Z7AtgKZsP5nxlzfdz27AilKCGmr+erGhFMxv1c/bj
         YdL2V2xGvle4pRlSsB8hbFZx5tSpwj3DJhJeiiC0FSKxMC2ENZRkIvxIySORWQPAdjQW
         6Rew==
X-Gm-Message-State: AOAM5327GXUKB6WJOKqL9hvK/TxlDwiV+XigdU0bphcu2/W8OcaEIr9D
        m7UftIQWqEeiaD4AGJE16SY=
X-Google-Smtp-Source: ABdhPJyne0983SQ6UBZwrfGAmMTGKjtVtIuCCYtICO8KBPdondAJjQD4BW/8rjtl9uW6fV1xPz5c1w==
X-Received: by 2002:a17:902:c252:b029:d2:4345:5c7 with SMTP id 18-20020a170902c252b02900d2434505c7mr2174961plg.4.1600783062223;
        Tue, 22 Sep 2020 06:57:42 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:e94c:84f3:ad0e:58d7])
        by smtp.gmail.com with ESMTPSA id r206sm15413461pfr.91.2020.09.22.06.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 06:57:41 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] drivers/net/wan/x25_asy: Correct the ndo_open and ndo_stop functions
Date:   Tue, 22 Sep 2020 06:57:18 -0700
Message-Id: <20200922135718.508013-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
Move the lapb_register/lapb_unregister calls into the ndo_open/ndo_stop
functions in x25_asy_netdev_ops.
This makes the LAPB protocol start/stop when the network interface
starts/stops. When the network interface is down, the LAPB protocol
shouldn't be running and the LAPB module shoudn't be generating control
frames.

2.
Move netif_start_queue/netif_stop_queue into the ndo_open/ndo_stop
functions in x25_asy_netdev_ops.
This makes the TX queue start/stop when the network interface
starts/stops.

3.
The x25_asy_close function was originally used as the ndo_stop function.
However, I think when stopping the interface we shouldn't do the things
that this function does (except netif_stop_queue).
 1) We shouldn't clear TTY_DO_WRITE_WAKEUP and set sl->xleft to 0,
    because this may cause the transmission of the last frame before
    stopping to be incomplete.
 2) We shouldn't set sl->rcount to 0,
    because if we stop the interface and quickly start it again,
    the first frame we receive could be incomplete.
So I moved it to make it be called in x25_asy_close_tty (when closing
the TTY line discipline) instead. (This also makes the code look better
because x25_asy_open is called in x25_asy_open_tty.)

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/x25_asy.c | 42 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 7ee980575208..88a73ce6d9f4 100644
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
@@ -615,11 +605,7 @@ static void x25_asy_close_tty(struct tty_struct *tty)
 		dev_close(sl->dev);
 	rtnl_unlock();
 
-	err = lapb_unregister(sl->dev);
-	if (err != LAPB_OK)
-		pr_err("%s: lapb_unregister error: %d\n",
-		       __func__, err);
-
+	x25_asy_close(sl->dev);
 	tty->disc_data = NULL;
 	sl->tty = NULL;
 	x25_asy_free(sl);
@@ -722,15 +708,37 @@ static int x25_asy_ioctl(struct tty_struct *tty, struct file *file,
 
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

