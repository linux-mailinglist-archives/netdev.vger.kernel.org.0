Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129A32E6C48
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgL1Wzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbgL1Vc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:32:56 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FB5C061793;
        Mon, 28 Dec 2020 13:32:16 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id 2so10561840ilg.9;
        Mon, 28 Dec 2020 13:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0mgkEBKIgthZwWHaiaeNu2SDu9707vUBzGfBzMLaV6Y=;
        b=O/WiIoBhWkr8USQeFOPH6PH2BVd2jaVYBAIFzOYkmx0ONnlsHRjaIk4CUVP6lEGiUg
         rP8t0I9iFTH2MAfc5MCf20HsHO3+/OLK/8CPUqJIMLArDZsDmFnGZXq87DuCh8mHXDS9
         4vqT7OCiG7zo4Coc63pJYpaAhTx6rohb3yIiTeAV9dIQAgWl3hsD/0scF4wbkmJtxJmA
         cAWu98GZK+7+8HA2+N+VgZlXpw//HD5YfUKhuqahPCPuIahVAgNLX5DQX91/4MovR2BD
         0NA18UaUiY+Vz6AyV0oNpoMhFiO3KItYSEerqtzTNRVnuRs24J24lWnMkajFmvEsXDgp
         5pgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0mgkEBKIgthZwWHaiaeNu2SDu9707vUBzGfBzMLaV6Y=;
        b=C79XtdZQFH3izK2vO14SgAmpVbXBToFI+lxOs9bJUZy7aBZaxW6UYmMoQNZw44gJ7P
         xRWKFmHgBQfUYoEHwHEFZg80jzjtqduWGvs6i3P4TouNEUgIiSODxpjxj8CsyU7NIInd
         JyMEVWqmhsCHfPF7cuawaHiTNR4Mf4TBBOD2zMK6FI2tyUHSHSwJta/QIbTIzpVjEFuF
         OL6R63F2gK6HBOe1dWz5nwhOOiliH8zlEuLI5wWvhAyUq1LHlBtF3KC7fE+1MlcVlC5Y
         m3BXpG4/TQsIoRAja1ARePcfeUOmvqLS34M42P7RMCa27VMVqaFWHuCPN8VK3XyIuBj8
         e9pQ==
X-Gm-Message-State: AOAM530wwlfwebve6CgaQpWwCpX1GvypZyVDxPJo1BTskPPIR5ewy+84
        oiXkmWQ59tDE4hGNNyh5qCCgf1iHJ8/9HQ==
X-Google-Smtp-Source: ABdhPJzaz0G0X0wJXZF1uo8GTeZwZfzPWHCfWSYQIuJg3ssr/osNzmLj7vgStIksKo3Dtj994NVBIg==
X-Received: by 2002:a92:6410:: with SMTP id y16mr46130029ilb.126.1609191135309;
        Mon, 28 Dec 2020 13:32:15 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:f45d:df49:9a4c:4914])
        by smtp.gmail.com with ESMTPSA id r10sm27671275ilo.34.2020.12.28.13.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:32:14 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings: net: renesas,etheravb: Add additional clocks
Date:   Mon, 28 Dec 2020 15:31:17 -0600
Message-Id: <20201228213121.2331449-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB driver assumes there is an external clock, but it could
be driven by an external clock.  In order to enable a programmable
clock, it needs to be added to the clocks list and enabled in the
driver.  Since there currently only one clock, there is no
clock-names list either.

Update bindings to add the additional optional clock, and explicitly
name both of them.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
 .../devicetree/bindings/net/renesas,etheravb.yaml     | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 244befb6402a..c1a06510f056 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -49,7 +49,16 @@ properties:
   interrupt-names: true
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: AVB functional clock
+      - description: Optional TXC reference clock
+
+  clock-names:
+    items:
+      - const: fck
+      - const: txc_refclk
 
   iommus:
     maxItems: 1
-- 
2.25.1

