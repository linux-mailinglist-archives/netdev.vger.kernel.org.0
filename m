Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9BF25B5B4
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIBVLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBVLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:11:47 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02803C061244;
        Wed,  2 Sep 2020 14:11:45 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so389900pfn.5;
        Wed, 02 Sep 2020 14:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ygs/IE+McqnrSxyHqHFy4fGxAYxycxzoXo7z9MWjpSE=;
        b=Sez8vDAIPo2dPyGnQS6dBAJTSd0ckApYKvLiT9kh86tRC6TiCt5SJAojVGqMwV2n83
         6e7NK12P3Q7uJeGKoAS+QiuTjmYQEQ71+Ju10FG173eW/ohTlMCHtolivsvGo32sMTUZ
         ou9a8HpwbAwXEjagxptwwJE2Ul9gxP9s4xTsBcFRb4G+NeirUs+cyAGW6bKRRsF75+hk
         e+rHfd6C0f+L7C6bYmwmhm0uEDXgpa82OGhqWYk5Jeb0cXQXXVetmpbofL3lsNx98bbQ
         vSqMTJqsOQ/ol2leiJwMDpMsorJ7czXI94iwpAVYdDFC5ta2EYWspEd9J4sR4vSEssAS
         gs7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ygs/IE+McqnrSxyHqHFy4fGxAYxycxzoXo7z9MWjpSE=;
        b=Tg7kfB3CDd12gaogG2k3/d8cjg9DQLkLwv9/kH84mJ6hr5kU/AwirpXRA+fxFMaP2P
         b1iEHHckpERYSzyXGqdD4Ir8qm5MtoH2W8cKRMy0yKzeis+0u+h496N2poyT7TciN8mJ
         KWq07weK8SPmZV1zOj3AR8EYd8LrCE/Of3f4XhcswpgDcccSj15A52Mppj3SNYuBalFz
         wwUBb58HIJgBxZsthDM1rGb9Uya7s2GdKbGypMJZI2glzUMrBRHLWEf17aeMPz0Ye0fh
         wKbLferFvvjcQk9JL9rhSKAiPvT/zVow0gdTUFzs9P/4tgNbX5HOse3rB7Q1tu+rB1oJ
         coMA==
X-Gm-Message-State: AOAM533yCPcZFyTxsI/9dhIbnbBbTJvpoIXoOpM4lWxVq7Ygg7+h5pSu
        8/NcjZ4BuEAIM6+iiCpupuo=
X-Google-Smtp-Source: ABdhPJzwflc8pRYyFM7ZKAJJz2UK59HuPj0IrOAB2Ka2pobxtUpsmQA6rXJrwy/UfT2ubcgeTptjZA==
X-Received: by 2002:a17:902:b60d:: with SMTP id b13mr331817pls.48.1599081105327;
        Wed, 02 Sep 2020 14:11:45 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:b49f:31b6:73e2:b3d2])
        by smtp.gmail.com with ESMTPSA id q71sm337132pja.9.2020.09.02.14.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:11:44 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
Date:   Wed,  2 Sep 2020 14:11:41 -0700
Message-Id: <20200902211141.48712-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PVC devices are virtual devices in this driver stacked on top of the
actual HDLC device. They are the devices normal users would use.
PVC devices have two types: normal PVC devices and Ethernet-emulated
PVC devices.

When transmitting data with PVC devices, the ndo_start_xmit function
will prepend a header of 4 or 10 bytes. Currently this driver requests
this headroom to be reserved for normal PVC devices by setting their
hard_header_len to 10. However, this does not work when these devices
are used with AF_PACKET/RAW sockets. Also, this driver does not request
this headroom for Ethernet-emulated PVC devices (but deals with this
problem by reallocating the skb when needed, which is not optimal).

This patch replaces hard_header_len with needed_headroom, and set
needed_headroom for Ethernet-emulated PVC devices, too. This makes
the driver to request headroom for all PVC devices in all cases.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 9acad651ea1f..12b35404cd8e 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_DLCI;
 	dev->flags = IFF_POINTOPOINT;
-	dev->hard_header_len = 10;
+	dev->hard_header_len = 0;
 	dev->addr_len = 2;
 	netif_keep_dst(dev);
 }
@@ -1093,6 +1093,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	dev->mtu = HDLC_MAX_MTU;
 	dev->min_mtu = 68;
 	dev->max_mtu = HDLC_MAX_MTU;
+	dev->needed_headroom = 10;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->ml_priv = pvc;
 
-- 
2.25.1

