Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7934924A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhCYMnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhCYMmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:42:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BE4C06174A;
        Thu, 25 Mar 2021 05:42:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ha17so992301pjb.2;
        Thu, 25 Mar 2021 05:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0bt+yFJbuDlDnqVqGjm/70yTbKSPm5K8BlbdmF89ZI=;
        b=StNfHAFGoHxehkGTqooGf8klr1qXp2gc8gFROjg0dDKsDwDXEq2ua5tmqrdNsZJALz
         TJc0kJNAEYMKA2+hZhwd2xF/GlF+1f7IjsnArRkS4x8Tf01vHDSoG/bMqGVnfoAFmHn8
         mYYADs0eDO6cW7iRblKj7G9UD4rQFG9G1HrVWD35njpigEEb3j7dL5E0d26OVoKJsL6j
         ElH6zAdaDF5eI9/Dh1616fXe0sJ7x9zNlwlLKDpMR2SKrCjoMXtJ5MF0q+nxoFfpVtjz
         yK8VB+NH1DApwOOpfAxzSBujmKSguVQP1BC3mVtJDxoPDOYe1CKBS6B/AMlnhVhBxuuh
         mIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0bt+yFJbuDlDnqVqGjm/70yTbKSPm5K8BlbdmF89ZI=;
        b=hqlNPwuz0FD/psBF+jCA4AeeTOy76WHRCNHJEXq7haJDKNh7rkCoxaC+AYFrk/TsnJ
         DPnNG1872zoPFw49wucflxoCuQgjF+W2nE4Xs4U8OVE9/VD9zO2KACKDrvRF9+Ss8slh
         zaxfX+86TirTrD9Llu4vCITBNTGQNeKJeRIIA3S0oIAWRWnmdmrpaAY+vXX81VCqMmhZ
         9v8pymTyb5L5SXWlmptii5RX1eNirlnlaSM1KtmBRZsJx0qVro4z/tXqEF4BsqpLA+SE
         ZN8e3/VZRP4/ktw4SNszKLQkgKh8ufR1yaWoRxvpnKNZEX2TD5MDnc9caEFacotAwuil
         08uw==
X-Gm-Message-State: AOAM531TXkhU7uQANWidzqCt/AZS8eR67vjZex1C0ndkypNqMl08aHc1
        rm3T9a2Z/A26XmGVE7mbO9E=
X-Google-Smtp-Source: ABdhPJxhXEzpQ0Nlk3nozlLLPS01ADiVLHi5cqf7bEE00gMKLwqesBcpjuXtE550YOp602+/E+RypA==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr8729145pjs.119.1616676163922;
        Thu, 25 Mar 2021 05:42:43 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:42:43 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anand Moon <linux.amoon@gmail.com>,
        linux-amlogic@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of ethernet-phy compatible string
Date:   Thu, 25 Mar 2021 12:42:20 +0000
Message-Id: <20210325124225.2760-2-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
by the device tree to initialize the mdio phy.

As per the of_mdio below 2 are valid compatible string
	"ethernet-phy-ieee802.3-c22"
	"ethernet-phy-ieee802.3-c45"

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 2766fe45bb98..cfc7909d3e56 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -33,7 +33,7 @@ properties:
         description: PHYs that implement IEEE802.3 clause 22
       - const: ethernet-phy-ieee802.3-c45
         description: PHYs that implement IEEE802.3 clause 45
-      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
+      - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"
         description:
           If the PHY reports an incorrect ID (or none at all) then the
           compatible list may contain an entry with the correct PHY ID
@@ -44,10 +44,10 @@ properties:
           this is the chip vendor OUI bits 19:24, followed by 10
           bits of a vendor specific ID.
       - items:
-          - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
+          - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"
           - const: ethernet-phy-ieee802.3-c22
       - items:
-          - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
+          - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"
           - const: ethernet-phy-ieee802.3-c45
 
   reg:
-- 
2.31.0

