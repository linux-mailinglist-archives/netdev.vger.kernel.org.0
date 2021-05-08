Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7659376DD9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhEHAcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhEHAbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:31:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269F7C06135B;
        Fri,  7 May 2021 17:29:47 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o127so6102004wmo.4;
        Fri, 07 May 2021 17:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MOLPDc8gh067O4OWdNlGUuI5YoNwGjIQBjLg8LQX940=;
        b=ddI6l62VvWsC0xVGP2mnZXHWMYr2U/4LLN5DWMheBvTAqvN9wuc31ndF/nmut2CPAQ
         WvKN6yGOWwXk5AegXO8g+zg+2wNoCPSxcaqinTNMOdtLHBleOqpoLQhAE7h3jYkRHEoF
         4BOpesi8pr4zv9bfrINpP0CIEZUlvniPzzVSBLtBfKXRZv3TeAP282geHZwJRdzg2fWY
         zXq9wDMk14/+Pdu/tNN1H5ie0uH+PucvQH0TLyS7Nl+yF44aV9SRGwX61kfh9gp35ktd
         TgI298Naeo/kjdizafz/5xhmt2ei9EIpZhExN7b21K0DbsrNMSBdIqlQrDUuF1l4JZES
         fuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MOLPDc8gh067O4OWdNlGUuI5YoNwGjIQBjLg8LQX940=;
        b=fNvz9D0+DUTujNpTZr9eqFSPBgntugzFFTtED97jc+iL5GiDitZmGMb//TXqg4rxAB
         +zTlB8g/+RmOs/rWjB2tNb2xfG2ldBQsnZPMnyoJmhz+fy2GGFjLM4nQ3vHW7Beib84a
         C15vTXeG3ayVQ3wqNLwlzauMBzYRqxgZQ+U1EO0CFFT/c46VzL+1EkuSqjYSlyOUIdG5
         TNqjv0EVOh1pkmnJ45ZU384L6aDJIrXGEazieuVj6VyMLfVQ9IFtCRVOBOJZwvl96eFv
         TfvZI8iZ4EBNIVePDm3ksGwdgFWpQ9grY9gJdK7wCJRe21nyk3pnz1y5kVjCzESSxDBD
         iyRQ==
X-Gm-Message-State: AOAM533NF9HbYxZojf1wkWD1UJVBvr0Ahw1kAPFLpzGqQjNMYZZFqYdP
        AN++7CnJHG/7s+h/qaQ7Oq8=
X-Google-Smtp-Source: ABdhPJzz1MNReaK3Lu9L/EXnVOIlddL6utwXLDIG0ibhGbORBzREZg4RxVVQbJDNk8SQr8cRMOrW3w==
X-Received: by 2002:a1c:1f03:: with SMTP id f3mr22542244wmf.175.1620433785695;
        Fri, 07 May 2021 17:29:45 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 24/28] devicetree: net: dsa: Document use of mdio node inside switch node
Date:   Sat,  8 May 2021 02:29:14 +0200
Message-Id: <20210508002920.19945-24-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch node can contain mdio node to describe internal mdio and PHYs
connected to the switch ports.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 8a3494db4d8d..fbefaca884cc 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -15,6 +15,9 @@ description:
   This binding represents Ethernet Switches which have a dedicated CPU
   port. That port is usually connected to an Ethernet Controller of the
   SoC. Such setups are typical for embedded devices.
+  Switch can also have PHY port connected to an internal mdio bus by
+  declaring a mdio node inside the switch node and declaring the
+  phy-handle for each required port.
 
 select: false
 
@@ -87,6 +90,31 @@ patternProperties:
 
         additionalProperties: false
 
+patternProperties:
+  mdio:
+    description:
+      Describes the internal mdio of the Ethernet switch
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      phy:
+        type: object
+        description: Ethernet switch internal PHY
+
+        properties:
+          reg:
+            description: PHY address
+
+        required:
+            - reg
+
+        additionalProperties: false
+
 oneOf:
   - required:
       - ports
-- 
2.30.2

