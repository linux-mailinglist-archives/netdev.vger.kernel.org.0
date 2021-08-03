Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC71E3DF367
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhHCRBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbhHCQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:57:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3888C06179B
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x14so29804817edr.12
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+EPYcaX3CGR6fdD8iidPM1vuQj/8EScCk9Ihcu/BcLM=;
        b=lus0/h2VlRSuqGhqBjNs74DotStClboolaUWJaT1PAirGa3NR45tpqDP17thwiV34C
         XxaMy8AJ2fAQ5rahAHKmFIxLW+/7LfCh442kMFoiLdoZljpEDcZZsugAF8dEbpgBkqhf
         pcLfLbPocubqKdBmtjI1oaCTDweru4Z5DnC1ME1m+O2+18A17+mErGRdbrsrppgy3Sjt
         HeFv91Jk7PmwUW9VxfEmUWhN+WpXJ5BhaMhOnDkcI060wReDPSuEPfq9Ifuixfs8Gh8W
         eP89sH3GVTsOljlEcS3ptzgOVfs/bql7fDaZalWgvqNoYYyD90doB3sYVvY3XUk0kqpj
         1OvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+EPYcaX3CGR6fdD8iidPM1vuQj/8EScCk9Ihcu/BcLM=;
        b=TUsL55UJlKc86buJEeiEe3vi2pUk8VKLLl2C6WjY8tGFzt/K0I/8HhRlk2KgAhQiEO
         pmMbEybBuv0HfJRafJm6wJvY3xUQWt3CyNEPW4vU0hzS/Pk2TfGIWsuQQjDufyGTU0Xv
         //otjm3OLQzc3sCf0LT4qqwexJEqQlH1TMhue/FgLg3YXJnJpbHJrZy4VmqAdc7xrIex
         StFWkqtAfp2FNMZpOFVrT4lzmbbPcHvXwqMZoHiVbHFyFWGXRgSb+4uY5AayqVdFXtXT
         9bdDdBJC/K39V5x9ZE/XjLaP2rlmf0yGykpTslXcfbdZwybv/XtsziuJ7mhurWXTuKUQ
         Gw3A==
X-Gm-Message-State: AOAM53205ZRNbzF0k5nVK2mdwiHjSZ1VNCtb6XOEBmVmsX9otaFY8v0s
        /vet9bYTPC+KMxeZBpz72To=
X-Google-Smtp-Source: ABdhPJy5apG0obtdJSYO8gA2PqZR4n7SGGuGMtAdoMG2AfbCF1OLXIhqzG1y+jULJ/HxdjEtXFy49g==
X-Received: by 2002:aa7:c042:: with SMTP id k2mr27250312edo.104.1628009758337;
        Tue, 03 Aug 2021 09:55:58 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:57 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/8] bus: fsl-mc: extend fsl_mc_get_endpoint() to pass interface ID
Date:   Tue,  3 Aug 2021 19:57:42 +0300
Message-Id: <20210803165745.138175-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In case of a switch DPAA2 object, the interface ID is also needed when
querying for the object endpoint. Extend fsl_mc_get_endpoint() so that
users can also pass the interface ID that are interested in.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c                  | 4 +++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 include/linux/fsl/mc.h                           | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 09c8ab5e0959..b3691de8ac06 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -914,7 +914,8 @@ void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
 }
 EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
 
-struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
+struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev,
+					  u16 if_id)
 {
 	struct fsl_mc_device *mc_bus_dev, *endpoint;
 	struct fsl_mc_obj_desc endpoint_desc = {{ 0 }};
@@ -925,6 +926,7 @@ struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
 	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
 	strcpy(endpoint1.type, mc_dev->obj_desc.type);
 	endpoint1.id = mc_dev->obj_desc.id;
+	endpoint1.if_id = if_id;
 
 	err = dprc_get_connection(mc_bus_dev->mc_io, 0,
 				  mc_bus_dev->mc_handle,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f664021c3ad1..7065c71ed7b8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4138,7 +4138,7 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	int err;
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
-	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
+	dpmac_dev = fsl_mc_get_endpoint(dpni_dev, 0);
 
 	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
 		return PTR_ERR(dpmac_dev);
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 63b56aba925a..30ece3ae6df7 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -423,7 +423,8 @@ int __must_check fsl_mc_allocate_irqs(struct fsl_mc_device *mc_dev);
 
 void fsl_mc_free_irqs(struct fsl_mc_device *mc_dev);
 
-struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev);
+struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev,
+					  u16 if_id);
 
 extern struct bus_type fsl_mc_bus_type;
 
-- 
2.31.1

