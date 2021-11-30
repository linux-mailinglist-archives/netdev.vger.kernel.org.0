Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAA463FC6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343959AbhK3VUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343979AbhK3VUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 16:20:07 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD34C061746;
        Tue, 30 Nov 2021 13:16:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y13so92381969edd.13;
        Tue, 30 Nov 2021 13:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YExRoIvi7i7R5zagT3u/D1cyGj3kreE8VGtG4x03o0s=;
        b=hgLUCdPRBn86lbfXSiT0q3sQDoRDO2qh+IzZIUm+jYQJEkmyiBS8WTM8TJqjD6J2Of
         giJcK1gpY2iSgGkH1lggj8PhLctXxNYDvmEh9l1QZVKv5pEYWm6d6IsksXtDDiIBI+bd
         kXTo4wZi5p5ANZSxhLxDikj4kzKz+NJPiwLJF2UPF6iADZ2WRwvAZ7v0P3n7A3NiYIj4
         dxQBxU9cubxQJ+RVDRn4FAouPgE1wJwO7Xs94jBI0PwKKDa6qcBmPWCDvMpo/NRKsvov
         D/eYGq/dMgTRDk9V9ZgHc1jJBD0R9bu4qOLXyQcQPKlXMNbu0oW7KGQBUn8nMPq4QnOl
         K7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YExRoIvi7i7R5zagT3u/D1cyGj3kreE8VGtG4x03o0s=;
        b=m/6FmXmTmlbJSjfmBpLUrZNcsm/QqEllppcfJKtyoR4NwTHUgCtHlz95WBd03wY1v1
         DEnt5ytp8JCBO28TFNYZETGVPsWA9P+6u8H1DVm8nh28fns0dsTcgKfx2qdzPR5C4QmJ
         mXPLZ0F0AW8loXhxt3YuB1hH5lhveR5vX8DnmplR8nJAK8ev0WcQz+GXRYHhN70UnEZ6
         CxiqtcMGGoIrYgkF3gKAYVYwT5YsEoMxg374RQ5sYChc1J2MfFusaAey9OaoR1v8NJf2
         MZlrLmXXAoL0GfUIf7Ku24KHxTgi8MrzG8SgmZ8e5Mc1uAgWqwQdQmTH9nOB7/ROgYOh
         4Jbg==
X-Gm-Message-State: AOAM533t2/LFbMIupiOhvd6L0KtQ0r43ezWX9gL9qFyYr9/KGLTSLFqs
        X3+16Z1g+fT3WvqYm09howA=
X-Google-Smtp-Source: ABdhPJzN3Fz2CCVkITuPmOXAd8mJgSmRUjCHj/t3duUmoTej31dKqiExhdHHeGJT6WDUNVzVnYtUdg==
X-Received: by 2002:a17:906:9753:: with SMTP id o19mr1810343ejy.243.1638307006053;
        Tue, 30 Nov 2021 13:16:46 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm12271753eds.38.2021.11.30.13.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 13:16:45 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [net-next PATCH v2 2/2] dt-bindings: net: dsa: qca8k: improve port definition documentation
Date:   Tue, 30 Nov 2021 22:16:25 +0100
Message-Id: <20211130211625.29724-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130211625.29724-1-ansuelsmth@gmail.com>
References: <20211130211625.29724-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean and improve port definition for qca8k documentation by referencing
the dsa generic port definition and adding the additional specific port
definition.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 40 ++-----------------
 1 file changed, 3 insertions(+), 37 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..89c21b289447 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -99,40 +99,9 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        properties:
-          reg:
-            description: Port number
-
-          label:
-            description:
-              Describes the label associated with this port, which will become
-              the netdev name
-            $ref: /schemas/types.yaml#/definitions/string
-
-          link:
-            description:
-              Should be a list of phandles to other switch's DSA port. This
-              port is used as the outgoing port towards the phandle ports. The
-              full routing information must be given, not just the one hop
-              routes to neighbouring switches
-            $ref: /schemas/types.yaml#/definitions/phandle-array
-
-          ethernet:
-            description:
-              Should be a phandle to a valid Ethernet device node.  This host
-              device is what the switch port is connected to
-            $ref: /schemas/types.yaml#/definitions/phandle
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-          sfp: true
+        $ref: dsa-port.yaml#
 
+        properties:
           qca,sgmii-rxclk-falling-edge:
             $ref: /schemas/types.yaml#/definitions/flag
             description:
@@ -154,10 +123,7 @@ patternProperties:
               SGMII on the QCA8337, it is advised to set this unless a communication
               issue is observed.
 
-        required:
-          - reg
-
-        additionalProperties: false
+        unevaluatedProperties: false
 
 oneOf:
   - required:
-- 
2.32.0

