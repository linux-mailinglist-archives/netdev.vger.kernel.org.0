Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2053233967
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbgG3T6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgG3T6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:58:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71FAC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l2so15444277wrc.7
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u0mj2PuKYrLEDonSx5jyPxMgkXBqv0e7pSLRJXxg3DY=;
        b=nOikdJ4nhv4ZGQwkVaOUEtc5wympviVb7tGkYeogFhnxoCf12g3O7Od0QYS+UyOvdl
         kWR55MRDk+s0tyS+dRNVKuJwjQMFegXwZ+RkDEwv3+GzAPYqYE+VY6HrS8kXupDuUG/2
         Z6B5Q7TLG4kLtlJ8uQ9WGFBkErchabnQtGrwPgGs/01USEd0wgoLodn1fd9zbpKwxbiO
         qNxxN0CONYCTHqCuPTvkN+hoGkOUZ7Uh1zNSa0z4tAzIrxZzVMzotG0janltHa3drL+g
         JRrSBlQMulT9B1SxeWopRtZ1QT5NzIQN/U1eVeSPXpZPoyIaob6NPf70Os/zHHlxISf8
         VlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u0mj2PuKYrLEDonSx5jyPxMgkXBqv0e7pSLRJXxg3DY=;
        b=qkPMl3VkGCQc0M30lWICAGe23RtKm3srBHEdcLQG5+s9jpJqOeNDz3+O+T/THCEuZU
         y4wWGqCuOm6Hn83AcUCs1AvagIL8muRU9duFwRtTCE8kKLTaBQ2HtTI2s6VxsoUxeMiA
         kcA/cO0K42s/VWOEXI92XhEid9cI2KgM8Pco7Sk1l2cIGxNP2UJXCC81TXUCio06Zzch
         3wMd+sctYZExwzJDMEXEduAILTfllAajzwwworMrrZGS0skGOWyS04T1kBewTK9Sh1BS
         JZCxqfzGL8kTgpNYCOJmiRdiX6GdODbKpUjOtDF8QBiYC8NiK6UX4IozICL7vm0/u+3A
         rcNQ==
X-Gm-Message-State: AOAM53148RBf1IoDhW0YGuFHuz/9GwnyqVA1rfzFweK0pYNJi9xrD1Xe
        vw0Q46x1Rj1otcmAS+8KaDz+CJnuXK33cg==
X-Google-Smtp-Source: ABdhPJz6mrfC/YDdNdfs+O4ww5NIfjy9/OOvkeJXpFHJofAoxBaF4/b/0rXZcl3VsZGoZpi37rxxpA==
X-Received: by 2002:adf:f7c3:: with SMTP id a3mr324039wrq.162.1596139091420;
        Thu, 30 Jul 2020 12:58:11 -0700 (PDT)
Received: from xps13.lan (3e6b1cc1.rev.stofanet.dk. [62.107.28.193])
        by smtp.googlemail.com with ESMTPSA id z6sm11326993wml.41.2020.07.30.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:58:10 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH v2 1/4 net-next] dt-bindings: net: mdio: add reset-post-delay-us property
Date:   Thu, 30 Jul 2020 21:57:46 +0200
Message-Id: <20200730195749.4922-2-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730195749.4922-1-bruno.thomsen@gmail.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "reset-post-delay-us" parameter to MDIO bus properties,
so it's possible to add a delay after reset deassert.
This is optional in case external hardware slows down
release of the reset signal.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index d6a3bf8550eb..26afb556dfae 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -39,6 +39,13 @@ properties:
       and must therefore be appropriately determined based on all devices
       requirements (maximum value of all per-device RESET pulse widths).
 
+  reset-post-delay-us:
+    description:
+      Delay after reset deassert in microseconds. It applies to all MDIO
+      devices and it's determined by how fast all devices are ready for
+      communication. This delay happens just before e.g. Ethernet PHY
+      type ID auto detection.
+
   clock-frequency:
     description:
       Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
-- 
2.26.2

