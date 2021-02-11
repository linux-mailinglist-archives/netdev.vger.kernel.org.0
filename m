Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A067B318A38
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhBKMQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhBKMNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:13:50 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00E9C06178A;
        Thu, 11 Feb 2021 04:13:09 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id b16so7037017lji.13;
        Thu, 11 Feb 2021 04:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AXjo91NU1riO24orGNjx7IfdO+L8CByC9r+nnemA7tE=;
        b=pfaZPryMElKRaSs84AmP7beM6Ko/in2xHsKchGqzKYglcO9sXL6XFZVq9omNEHbZAr
         6sttMlWxx/DxQmec2X7QPbX1faWJcJcLkQkulYIQhFzNSsy1MjkO46bkX4BXx418GMax
         HU1Wg82CmSkM7yDmLGBk7ulHgMsqlwbWT5w5sld8adf3Tbdt213JiPKiVvBoKrwAaKWd
         09E7UMw9dQcAEvMUSnS2GdZoZS+4nxeKXlT9dv0Qx3AXNeS2lVPdL8lxpISBprrCT6OT
         M7JdVcH8wW9csE7y1RV8p4J0+xOtrwIpR2dukBGBGMkVbyv5scOVDkTJJ1hxUyPWGM5z
         TwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXjo91NU1riO24orGNjx7IfdO+L8CByC9r+nnemA7tE=;
        b=GbBcl03WtX0b+Au05V6PuBLqHo74Drz6kOFBJeEEfE8hIk9kjc/3babOuSOKx86oxk
         BUIdwrOpLse80C1GLlns7Fj7yNiykccjF5ztlCyivyczr0v1Mt5iM9qKN4aN3VLDAxBe
         fTbe78YbWvDf1/EIwGtkstllMFJTiWbdMWAGZwENmeNRoQ3PXP1MaOFJLAONS8q/Sl87
         0dQWmn66vQX3DDGXSVyHBGU2cpqsNHZdzzsQhb3ta1/r89R+tPM2UmJ+G1iJKl/KIS+m
         4zGMLHj2I/KTwrlL6i9mtqYLd0qVwtsoHgooSutYSXSVpfEZrrjAX0KWSBv1mmbwIsIF
         3mQA==
X-Gm-Message-State: AOAM533shKQUoEM/IC7vG/YmziN8LjqIJC7Cg1K4wIvq14xjmBGkUokV
        ULjAsG8HtUyfvxWpNuU/oDB4XcZi5fg=
X-Google-Smtp-Source: ABdhPJw2kmkiZ/V6KdUUDvac+WAhrxI0iDxsqQxvI3pNs5lTYCmh4Ro3Wag53TCbvPfVDxQmN4DX9w==
X-Received: by 2002:a2e:9004:: with SMTP id h4mr5082640ljg.276.1613045588367;
        Thu, 11 Feb 2021 04:13:08 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:08 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 5.12 2/8] dt-bindings: net: bcm4908-enet: include ethernet-controller.yaml
Date:   Thu, 11 Feb 2021 13:12:33 +0100
Message-Id: <20210211121239.728-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It should be /included/ by every Ethernet controller binding. It adds
support for various generic properties.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index c70f222365c0..79c38ea14237 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -11,6 +11,9 @@ description: Broadcom's Ethernet controller integrated into BCM4908 family SoCs
 maintainers:
   - Rafał Miłecki <rafal@milecki.pl>
 
+allOf:
+  - $ref: ethernet-controller.yaml#
+
 properties:
   compatible:
     const: brcm,bcm4908-enet
-- 
2.26.2

