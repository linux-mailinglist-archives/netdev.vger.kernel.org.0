Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581EF3098E6
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 00:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhA3XtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhA3Xse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:48:34 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D126C06174A;
        Sat, 30 Jan 2021 15:47:54 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id i8so2120467ejc.7;
        Sat, 30 Jan 2021 15:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Yo9kNchCDDIWynezRjAttZ2661/CkVAgV5LpPo25MQ=;
        b=le7TELf5GzAEJhC/2f8Vmt/Yhk547GHEGEl81Tk8hEMQ0V+kTHOFSsuJYT3K12A3dk
         11nxA//swONE977C+sEUMerqh+MXRl8DkEP0cxkj4ftoKtJPjHtnfCdQEg7AqrgC2nRi
         Yzh/6j6K6Zdoyg9o7SENkIgwAc541J1rqyKNaSLeImzDsdPeCPuPyN/QBbpdsBR7a/Qx
         REbrDUtUkWqm4vyxR7Hsl/fzGRB5VDKL2r7M5Dfe1YIbcLKAPG+LwIAuJ/D8G7XJapJD
         oX4bRJv+0u1BG63evr/wioNd1sTmxrsMM3nCIdIYKysOTQsNTANXblrjUJsJRQLDRCKP
         mfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0Yo9kNchCDDIWynezRjAttZ2661/CkVAgV5LpPo25MQ=;
        b=QGkjEYAK0HCWwC4ubSPdVd2KMKTjiv3a2TRwdzyeaGItf6PtGerFoOCdo47jqUi5MT
         NFVu1iZO03I/wMO2Ib6IgOlBg5lTKPn7vr49PBy9pHOZzwyTxcNy9VePW8xUkKJK/W+4
         I9XT6IJyekeQGTPFJbjKPPhZdowcwc1Q0/Ak1CRskTRYGnXHjQRdrXvJIUlTsdWd8bpb
         2wQ+8oejU8xpJjXaJyflJ4TLm+DAjvV6yBXuIEn7+zWKJsSu3cThslPG5ShVkxol1MC/
         2cj9tS/uSrgWQAKTQDblQXAPQlrE4DVD2xys7/nSk3hwaR3teDLK85l3kFGF2Jck8SO9
         kbLA==
X-Gm-Message-State: AOAM532iWFBPZFJ3RoQbWxLkpYVsD/+b30HlwFFUpf5l2tEH4U6SaSHc
        JKJF6JOJkgBkJ923h1wHgzskrkkkJ799UDyR
X-Google-Smtp-Source: ABdhPJwV3Uo1wvgSQtJ/dCUIGhCjQ3Ee5XDLIEZPsbmU7AH5hLZlhTCA+cCFSauCpTPB7QLIxWJDgw==
X-Received: by 2002:a17:906:46d3:: with SMTP id k19mr10774940ejs.546.1612050473207;
        Sat, 30 Jan 2021 15:47:53 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:52 -0800 (PST)
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
Subject: [PATCH 2/9] caif_virtio: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:23 +0100
Message-Id: <20210130234730.26565-3-kernel@esmil.dk>
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
 drivers/net/caif/caif_virtio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 47a6d62b7511..106f089eb2a8 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -598,9 +598,9 @@ static netdev_tx_t cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static void cfv_tx_release_tasklet(unsigned long drv)
+static void cfv_tx_release_tasklet(struct tasklet_struct *t)
 {
-	struct cfv_info *cfv = (struct cfv_info *)drv;
+	struct cfv_info *cfv = from_tasklet(cfv, t, tx_release_tasklet);
 	cfv_release_used_buf(cfv->vq_tx);
 }
 
@@ -716,9 +716,7 @@ static int cfv_probe(struct virtio_device *vdev)
 	cfv->ctx.head = USHRT_MAX;
 	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
 
-	tasklet_init(&cfv->tx_release_tasklet,
-		     cfv_tx_release_tasklet,
-		     (unsigned long)cfv);
+	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
 
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
-- 
2.30.0

