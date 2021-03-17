Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEF33EE52
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCQKaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhCQK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:29:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989F1C06174A;
        Wed, 17 Mar 2021 03:29:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k8so1245063wrc.3;
        Wed, 17 Mar 2021 03:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7tywzNw9fsDWNrH980tUqw2vjS036DogVuKiVwVCtiw=;
        b=MucTtyg64YTPB9iAhB4PTi1MDTlnjwgDlK1GNmpyQ5z1PlGeQF1morkspsgoE8ipp1
         Dicr45RdyzOmN1I1LKp6EzaPW/fMLaeSTxX1vfJcA33aNjbJgmpOKptieUBgh59Ejjqs
         uf+I5M5ShS8JhXMdSF6TMuevJieK1oLk2Q0AYoAmV6p71gGLyDGZvCDwDkn3LIuSO2xd
         dK3zP9V+2ZTZAUu1oLmYlBftrBQUgNf6Bo4i2Ub/CATuyOhINXCCELibKQPhw9QgScLu
         EgsBzwyzNI6aRpg+5S3ec3jqzISi3y90FixeFQgk4oucW5Yp15aB2K1WtnX4BbzE8v1+
         CiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7tywzNw9fsDWNrH980tUqw2vjS036DogVuKiVwVCtiw=;
        b=EQcd6XOFQ4nFMO7ZU0l7pRk3LmcJDFFsriC1BqbEAZDWPL5Xlt4SSI4asnvfqUBI3H
         sEh9dttcq7EEUq4Y/BLZMTW56NxPCUVjnsYrC4BCRzxUPNT1Rl7zpG/DSpIJKPXoC112
         7EyLjqnPhOuDGEDkuLDOP57Y4+HoF0udCeNdvYdRU9VQhHBH3KDmdah3Q3jeUYZaWD6m
         5H0nIzbl0S/+OP9Qg+ycIjp3u07uR9wIvRO5Ron/sU9DjlnI11R6OH+6ZtBKSTytO9sX
         KDMTpKqDr2pdl9q10gbFOp49nrZWAFIXkOHuuLm7T0W9avBdmQMXLhfZrzyTmJlrpNxD
         pHwA==
X-Gm-Message-State: AOAM533TxfvvCLeJAESZVBfFd/JSGh/2qpm0BfTTC4o1aOCiUqvMQu6F
        Q4PkRVhMQlKKPU53GOB30HCqTf7yGVu5Ng==
X-Google-Smtp-Source: ABdhPJyR+jyPcJjtKzUEtzzpHg7r+8f1xN+r/vR0XNbwaqW3UvZ7YoVkAew2bJ6tqQoZClp3mYCdag==
X-Received: by 2002:adf:f512:: with SMTP id q18mr3681248wro.61.1615976970300;
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id y18sm25342493wrw.39.2021.03.17.03.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 net-next 2/2] net: dsa: b53: support legacy tags
Date:   Wed, 17 Mar 2021 11:29:27 +0100
Message-Id: <20210317102927.25605-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210317102927.25605-1-noltari@gmail.com>
References: <20210317102927.25605-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tags are used on BCM5325, BCM5365 and BCM63xx switches.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 v2: remove unneeded comment and remove NET_DSA_TAG_BRCM_LEGACY from
  b53_can_enable_brcm_tags() as Florian reported that legacy tag can be
  stacked.

 drivers/net/dsa/b53/Kconfig      |  1 +
 drivers/net/dsa/b53/b53_common.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index f9891a81c808..90b525160b71 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -3,6 +3,7 @@ menuconfig B53
 	tristate "Broadcom BCM53xx managed switch support"
 	depends on NET_DSA
 	select NET_DSA_TAG_BRCM
+	select NET_DSA_TAG_BRCM_LEGACY
 	select NET_DSA_TAG_BRCM_PREPEND
 	help
 	  This driver adds support for Broadcom managed switch chips. It supports
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a162499bcafc..d3e5baa1ed5f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2052,15 +2052,17 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 {
 	struct b53_device *dev = ds->priv;
 
-	/* Older models (5325, 5365) support a different tag format that we do
-	 * not support in net/dsa/tag_brcm.c yet.
-	 */
-	if (is5325(dev) || is5365(dev) ||
-	    !b53_can_enable_brcm_tags(ds, port, mprot)) {
+	if (!b53_can_enable_brcm_tags(ds, port, mprot)) {
 		dev->tag_protocol = DSA_TAG_PROTO_NONE;
 		goto out;
 	}
 
+	/* Older models require a different 6 byte tag */
+	if (is5325(dev) || is5365(dev) || is63xx(dev)) {
+		dev->tag_protocol = DSA_TAG_PROTO_BRCM_LEGACY;
+		goto out;
+	}
+
 	/* Broadcom BCM58xx chips have a flow accelerator on Port 8
 	 * which requires us to use the prepended Broadcom tag type
 	 */
-- 
2.20.1

