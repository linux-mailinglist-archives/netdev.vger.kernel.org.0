Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD62749BD
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIVUEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVUEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:04:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD63C061755;
        Tue, 22 Sep 2020 13:04:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so12880169pgl.2;
        Tue, 22 Sep 2020 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LwGfBBJgKBgS+jH5gAWH5iyNNIi2yF8tjn973S871XE=;
        b=PkHtiOl2ot+0gTm8DKL57C5y/kdd6slabBkOc7ONiG2tGgFYI0n2JXUlf70+jhwFjt
         yMfa8NiRx47Xm9Zo//VsFEymtlSE0oxV6LOOP8NSqEzV0iDl2YeW/mD4TCx9nngUsnDE
         Yg/ZNep1MFTzS1GTUS0+DwlT/P7b/n70uEvT/YfrSje5IF4QQtlF4xrEotLBsOuce/my
         rSBq3bAES1lFAvHn3kNejA3Pio+Qq0AeMEf8vZsuV/3lnrE5mtYESkulS1hXWbuuhlrr
         Ar9NvWK1kz9uJ6FYgt8A+QlV64s5xei6mLfbsWfgRLhHgk6XYrVwkrNnnoDh2WIcBkI6
         +U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LwGfBBJgKBgS+jH5gAWH5iyNNIi2yF8tjn973S871XE=;
        b=jXy5qNsVx0UkPtSPOfm3igynObug3qE9A1eqzH/apCA+n+KWfn0t+X6siQCnnZB7PC
         b35eHlY4MR25rd3+R5UGIl80Yf2nXVze3gnzlnf1VWQfSEf1xiuomu35nFFeAjlz/Qer
         wPraLcL0tO5HjlCZrC+TgIQJDq2L6Ue5xg5IIyxyUcQAR6GSTOF4YUV8KXTanSFmfLCj
         2AgbTKRPc8g/n4wMlDIwBTbEH5ey3OYYaP/ZybdrmktUOemi0exIQycSAVf0kkfPAnzs
         oM8xwO7toO660f6T0FZhf0I5eDqzCF7pGqxci7LTzK6YZK5uFwDuYIaIOUbOetw5Vu5N
         4DUA==
X-Gm-Message-State: AOAM532d96rdrEQqf4tIKTqeZKdmoykEBVlS4gnK5RTRrJrvzYmJ9vrk
        qA+NejbmoS3VNsQDg8ROfHqfWYsitVd33w==
X-Google-Smtp-Source: ABdhPJxo9ee7nJ75PiAQfaEMyEqIXNWtMONQK4wsZCoOr1C4P3OrSlHZqcu721YdUNJkRhl4Xpmanw==
X-Received: by 2002:aa7:92c8:0:b029:13e:d13d:a12b with SMTP id k8-20020aa792c80000b029013ed13da12bmr5359950pfa.19.1600805044485;
        Tue, 22 Sep 2020 13:04:04 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q18sm15562700pfg.158.2020.09.22.13.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 13:04:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/2] net: dsa: bcm_sf2: Disallow port 5 to be a DSA CPU port
Date:   Tue, 22 Sep 2020 13:03:55 -0700
Message-Id: <20200922200356.2611257-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200922200356.2611257-1-f.fainelli@gmail.com>
References: <20200922200356.2611257-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the switch driver is written such that port 5 or 8 could be CPU
ports, the use case on Broadcom STB chips is to use port 8 exclusively.
The platform firmware does make port 5 comply to a proper DSA CPU port
binding by specifiying an "ethernet" phandle. This is undesirable for
now until we have an user-space configuration mechanism (such as
devlink) which could support dynamically changing the port flavor at
run time.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 723820603107..2bd52b03de38 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -457,6 +457,7 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 {
 	struct device_node *port;
 	unsigned int port_num;
+	struct property *prop;
 	phy_interface_t mode;
 	int err;
 
@@ -483,6 +484,16 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 
 		if (of_property_read_bool(port, "brcm,use-bcm-hdr"))
 			priv->brcm_tag_mask |= 1 << port_num;
+
+		/* Ensure that port 5 is not picked up as a DSA CPU port
+		 * flavour but a regular port instead. We should be using
+		 * devlink to be able to set the port flavour.
+		 */
+		if (port_num == 5 && priv->type == BCM7278_DEVICE_ID) {
+			prop = of_find_property(port, "ethernet", NULL);
+			if (prop)
+				of_remove_property(port, prop);
+		}
 	}
 }
 
-- 
2.25.1

