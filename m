Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332EA330053
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 12:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhCGLdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 06:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCGLdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 06:33:35 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D50C06174A;
        Sun,  7 Mar 2021 03:33:35 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id j12so5215712pfj.12;
        Sun, 07 Mar 2021 03:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QE9e3qNn83WSUIE3jJrl7w+oJ+JiRqDPe+H/RVHlaiQ=;
        b=jAqGFUpvVIshblWcz1U92JGc/yzMRSJnQ4RRDb9E+TnPJHyE4UOL9UoKFi75TxovVB
         BIk2hgvalBp3AZZdnAhoV5pLUklMWp0Zv75MJN/3FxoSrdksVVm9ekwCfGby/38kK9gU
         xHDuASCH7ESLCeiiZJ2I67O3ABlNd0ECKi7jaQvv8WpzfIWEjsWkMQhfw9yQTEaHc69t
         P2M8ao0YjlE6w8ibGYsBk2g5IeRgd9uYGqX+DRULmictZtgj7zhPwVsaM0VqH+/LNW9U
         e+cG7skQI5UOcDqc0E7Ej0hyPZaj+igV9qICRgsIOF20HXFh+ZN09JiR9X0wai147vT/
         SmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QE9e3qNn83WSUIE3jJrl7w+oJ+JiRqDPe+H/RVHlaiQ=;
        b=mktKYtDLn4HLLYJwNE4zu81Nrx9Tghvo8VvoJm47bu027nYDdKrq50x3jIki/Smx5F
         oj31PIEK3IhW1a57uBnQWK4aBeZJtfh1HiYW6+f/+EyXolPhyVrLqBV2O4LgDf2tZeut
         hRlp22mk+as2DTlmch3BfeGFJDppOFEI4qrR2eYXBscm0JEhitaidXceAuDwOdyvkQ0S
         KaGA2OD4AYGA9QqDYrSGrECn/Zww4Fxrk7LVzDqs7MbzlitFsg1zK5vpwVgUyEP9oY5p
         mHyR7yxxZNcNLieDUl950rQDisvCF4gjdSJ4fK5v+KAB1UYwjbRLqhsGX9Jc53h9mtXv
         3/ug==
X-Gm-Message-State: AOAM533xboWAf8FM2z9e3vEBs8kjDEP1Ubjo35roQ4k2oky5jSavZM65
        MLCalgZlrdwenv0p99ksF0A=
X-Google-Smtp-Source: ABdhPJxTGMQM2ns0X8ie7NcjXNv+b1/ikFV/9hVY8e25+Uro7slGW55TB38Ver9fiekPS5XUH7f6vQ==
X-Received: by 2002:a63:5a02:: with SMTP id o2mr16054504pgb.202.1615116814913;
        Sun, 07 Mar 2021 03:33:34 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:8b48:4689:855d:ef6b])
        by smtp.gmail.com with ESMTPSA id r10sm7100110pfq.216.2021.03.07.03.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 03:33:34 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: lapbether: Remove netif_start_queue / netif_stop_queue
Date:   Sun,  7 Mar 2021 03:33:07 -0800
Message-Id: <20210307113309.443631-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the devices in this driver, the default qdisc is "noqueue",
because their "tx_queue_len" is 0.

In function "__dev_queue_xmit" in "net/core/dev.c", devices with the
"noqueue" qdisc are specially handled. Packets are transmitted without
being queued after a "dev->flags & IFF_UP" check. However, it's possible
that even if this check succeeds, "ops->ndo_stop" may still have already
been called. This is because in "__dev_close_many", "ops->ndo_stop" is
called before clearing the "IFF_UP" flag.

If we call "netif_stop_queue" in "ops->ndo_stop", then it's possible in
"__dev_queue_xmit", it sees the "IFF_UP" flag is present, and then it
checks "netif_xmit_stopped" and finds that the queue is already stopped.
In this case, it will complain that:
"Virtual device ... asks to queue packet!"

To prevent "__dev_queue_xmit" from generating this complaint, we should
not call "netif_stop_queue" in "ops->ndo_stop".

We also don't need to call "netif_start_queue" in "ops->ndo_open",
because after a netdev is allocated and registered, the
"__QUEUE_STATE_DRV_XOFF" flag is initially not set, so there is no need
to call "netif_start_queue" to clear it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 605fe555e157..c3372498f4f1 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -292,7 +292,6 @@ static int lapbeth_open(struct net_device *dev)
 		return -ENODEV;
 	}
 
-	netif_start_queue(dev);
 	return 0;
 }
 
@@ -300,8 +299,6 @@ static int lapbeth_close(struct net_device *dev)
 {
 	int err;
 
-	netif_stop_queue(dev);
-
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
-- 
2.27.0

