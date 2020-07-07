Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68BF21796D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgGGUcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGUcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:32:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83447C061755;
        Tue,  7 Jul 2020 13:32:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so17573622pgf.0;
        Tue, 07 Jul 2020 13:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeySuj/oEugtEWY5uoav+/25T8POCDlTKNSa4jKela8=;
        b=pxliOLHMXIiBnA2FQyAbtVyhFVnsj1Bf3x1PFVZKEprdhGLI+HIZdVk/+WrM0Cai2X
         bYwuK9j0WZRkS2D6Rg4BKO/PlB63kGVUEye3XZEATIBNC6oqr9ngP7PFgUkMvQdPF/ZP
         TxTOJwBA0Lf4AJISH+hSMMgHDaASuPMrX64F/uqtNfvYFLfv3CnZjAuZWdt6KnekxaBc
         NOg4kz/AsvjWW+F7rCJ4D82lQ+OYBeIKVpDjVbKhzha5feYMdKFlRrBz4MSSuBVDNnjL
         OKWGWMCNTtrx0mvDDoMZS6bkzqR9jMzEJ5wY3bqtv+6si/lSN5NI1TEGfrnkp2yFO/5J
         XbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeySuj/oEugtEWY5uoav+/25T8POCDlTKNSa4jKela8=;
        b=VoffrIzQXjpIbzogyFbM32rrdN5l50TrJ7aD3BcAgbcuGhM0Kx2MUI5H5cmcuVWkk0
         /pYMJvaI6r0H/PP04XWIYsdf6591QC/tBN97f35ByidFxGal8zImCCFbOJJSUC/rzfwc
         0edGpuC3kS+Ba+gg9mCnFEa0K2xt0StW7N76Y2rV34oFZVuzvhniW5rrYcT9fFyAkb2M
         IWxDmJ/HI72E26J5oDNALY/DX78kHDivYnj7en+0gOPZeVlbglefHodNzBDPXbA7smlO
         /01x+P7xE94BANMG+QR4nSjDCHM32RVWczfiBykgELL6aTRA93Hh+7oTCNnAx+EZLg+G
         /f+g==
X-Gm-Message-State: AOAM532pH8osYTn01AlHMwMRs1Wm2IBKWh6aATMhse32m6Ijv+871cbh
        Yqk66l9UZShPb9HL4OYKL8B++ioVIMazRA==
X-Google-Smtp-Source: ABdhPJw9rUgzv6O9DChT28DVk/YCaBxEbzwNyWBZUp7hsBKSWHiT+184EN+mGfkeKP8R4RtdafFd2g==
X-Received: by 2002:a62:7845:: with SMTP id t66mr6665864pfc.5.1594153973002;
        Tue, 07 Jul 2020 13:32:53 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:a2ce:c8ff:fe03:6cb0])
        by smtp.gmail.com with ESMTPSA id g22sm1726321pgb.82.2020.07.07.13.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 13:32:52 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH net-next] net: sfp: add error checking with sfp_irq_name
Date:   Tue,  7 Jul 2020 13:32:05 -0700
Message-Id: <20200707203205.28592-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add error checking with sfp_irq_name before use.

Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7bdfcde98266..eef458ab0e5b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2354,6 +2354,9 @@ static int sfp_probe(struct platform_device *pdev)
 					      "%s-%s", dev_name(sfp->dev),
 					      gpio_of_names[i]);
 
+		if (!sfp_irq_name)
+			return -ENOMEM;
+
 		err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
 						NULL, sfp_irq,
 						IRQF_ONESHOT |
-- 
2.21.3

