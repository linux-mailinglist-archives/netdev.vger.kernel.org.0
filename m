Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D65376DC0
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhEHAay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhEHAag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290E5C061342;
        Fri,  7 May 2021 17:29:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 4-20020a05600c26c4b0290146e1feccd8so5752391wmv.1;
        Fri, 07 May 2021 17:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zDaLmFUYhqX+LyRYiq/joH5mOAsxQ0ZWvgt0bWE9Fa4=;
        b=XQSbCEolcIxHn5qSNGLACEYdk+CXsGHAJuEuxkbd3LoOVfILHmp11sb90gCJEibkf6
         eBxYBfFgAyWB8jUJsoad+EaHXG38QCaW4nuTLDs/O9lewTKE3BBSJFLHswxkkIkEw1Bk
         GiBcDnUiiQg0Izk5iOWijeXVa9Ln7xfwqN/lUyfODtcoDCfI3EA4oj5zY7Ah4GTzGV5g
         OetDxxAECloxd9DVLjCJFqfVhuy0LPNvHEJGkwBf2UiEHAjzWsC7ojefb1FNUus1iBGs
         lMAGLPLkkYTTp3XFCM5G3T5vUz4eS+9hUqdkEHGp6x0zwElWLdfLB2FA3D/NdQyQmpur
         0jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zDaLmFUYhqX+LyRYiq/joH5mOAsxQ0ZWvgt0bWE9Fa4=;
        b=FMmUVybSWQnErGO1WRO9nmVsQrE0vNapQJkfH+WP5lJilqyviq6qOZt/7hpIegP2Du
         CIjusjCxqdXd+VkjHRHC1CuuKyid5/DV1neh7XQu4kn3ODx1UsZq8oack5/rlqtGgA81
         cXNrVBiFEySr0Q9t3X/s0Fh0aQBA/EQVZGP8SSU3XrF0Owh9i7B3MVWx3m9zQ7TzMYaJ
         X1HMWmPWerTDthFjOBtv46cgmT9pmTMb58c+t1azFE2l/kCWjNBOjuvXgGNi02+Rhjug
         OMQLxR5mLvb5txGbNoCpFcwHa1leHq8QoLsM3UkNuVeeDwMw6I9Q1iahavbEy7rtM43m
         im8g==
X-Gm-Message-State: AOAM530zXMgJP/VaaAZMc8bJbded2FyRglWykA8Lf2S36CNdyVoQz9Oe
        JMaIEfSzFZYvxPduGMZ0tVI=
X-Google-Smtp-Source: ABdhPJxs5JpVTAtbE+CWrPSg50KMLjmDid4E26hnyb+e2F09q/1XTIyk3Eu2HGbY+M39xvKmxuTqLQ==
X-Received: by 2002:a05:600c:4242:: with SMTP id r2mr23800648wmm.140.1620433772800;
        Fri, 07 May 2021 17:29:32 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:32 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 13/28] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Sat,  8 May 2021 02:29:03 +0200
Message-Id: <20210508002920.19945-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 in the compatible list.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..1daf68e7ae19 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
 
-- 
2.30.2

