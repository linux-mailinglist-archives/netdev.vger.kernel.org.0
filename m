Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A706368AAE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhDWBtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbhDWBsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB4FC06134F;
        Thu, 22 Apr 2021 18:48:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y3so19423767eds.5;
        Thu, 22 Apr 2021 18:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NwdOsfFGN572tvuMPO0PlIKoBZLQUQuSZDjT5WAvEcA=;
        b=b1+mwV8JDIWlGbXSNE1mmls6BiKWtwR7MHHCEtAyH8PYD37XRz5weNadBRFRTFqOw8
         Z5aSCnLBmZnf7YRzduurKwNUmZpuE/r6rojvs5UKspUhcE3whp5SnLq7IWj08LS4nzDv
         RBsi1yTWHIGlNvAxpLnKcD5hYuJ86PybuOCQOvUNl9P9Dt5rJv8MVfFgp5SAg+gPw5Qu
         I3GGEolw5et6CFg8emdunWALXwBRD308ir1DRv2Swf8MqYfuWuXIfNIIcX15HbwW8G0e
         il9LNhoWi+qdKxXZ6+xn13pZajfgWYygvyh6/tiPNRG3/LILBEU42fsLbJFQYZL7CyJT
         hh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NwdOsfFGN572tvuMPO0PlIKoBZLQUQuSZDjT5WAvEcA=;
        b=DcU8aYRI3t7goRnzohfp7xj96cMur0F+xmXOkJk4dAG1O59dv6FMGIk6hTpATzkpnN
         5rO/Dnbs5xQtk2lKnDhOvteUw5epdibuYne5+3Z7QMq5JC2UusAqbMPTQ/ToE/VrQywt
         gdLW6aOkH/86IDLEU0GpsfACZWBh1qB2I659qrLo3qUEmKh4WKy9VwXowmmGKXbCjEHi
         x1EkdogmqJEIYWYNhyM4N1+oHB4q7vsTpYlTW0v5UI2tTm3S/YN77+0cqU/okUTmcDZR
         oc5nsLWhPr9Sv+2PSFGSz+tzDa0yqXRoVmSsUo0qAsCGBCCiudIBWUMPWzK99l29oDHG
         7Ozw==
X-Gm-Message-State: AOAM530EQR3JcEkcMa68LzCBbsfy382OA4qdExbbFvmQWC57cxgAKmEl
        mcKEK9069Y7i/XongFwKbmY=
X-Google-Smtp-Source: ABdhPJzby022guZt6fQRlOorR5UZXktbTwwpM7eJ6Sx9483dS0T0RFpcSt8jUiB+boUV0iQGaC5S9A==
X-Received: by 2002:a05:6402:31f0:: with SMTP id dy16mr1524542edb.161.1619142493491;
        Thu, 22 Apr 2021 18:48:13 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:13 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] drivers: net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Fri, 23 Apr 2021 03:47:40 +0200
Message-Id: <20210423014741.11858-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enlarge set page delay to QDSK source
- Enlarge mdio MASTER timeout busy wait

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d2f5e0b1c721..2ed1d5e283c2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -191,6 +191,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	}
 
 	qca8k_current_page = page;
+	usleep_range(1000, 2000);
 }
 
 static u32
@@ -617,7 +618,7 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	timeout = jiffies + msecs_to_jiffies(20);
+	timeout = jiffies + msecs_to_jiffies(2000);
 
 	/* loop until the busy flag has cleared */
 	do {
-- 
2.30.2

