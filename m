Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94251FFFE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbiEIOkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiEIOki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:40:38 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783781BA8F2
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:36:43 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso10877151wme.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 07:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yPyFcCAqsBcaZbtE1X5DjA7G79Cug8Z1WeFCxfEjFlo=;
        b=TnAJo0TSbSssofJ/+UOs/L2Sd05RiqqcB0xVFZixDATsXtGCFOtpGZ90WxyTEODTh1
         T3DNynS8287uYEoZu2sLBd8fdUnXCCEk/xO1OdafiCHFG0C7Plijv4H9i7sonu6KobAr
         8V5QAv7E8D6cYfgOC7lW6jDQnwRe7Tqo8Gpb8JWHXbyx1QbkvUfS89hcfQKikDhEBDNf
         SEGY4hTUuEbWpeQkubMx9HeHywwegJRNQvO6BNUx61nGV95PCY6kqLaVHujg2mmDhEop
         4GNx6hy7kUfWegaPqTo2QzUsIfJMWKxJf4Feqnh5qB7IAnrc6tAYI4jRXKaLQctMsdVg
         vs8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yPyFcCAqsBcaZbtE1X5DjA7G79Cug8Z1WeFCxfEjFlo=;
        b=rKg3FtfGu0ny972idqqxspu1Wna7Ryv7WcwRT35iezwfvg/hIsMN1RzXhWfJrYXc5h
         FnlCjOCbIXULLZw4ln90ZxLWDyLaG1bmYaX6Ev9X9oA65eas7oQ36eLvR3jEFHp0bcxe
         k8qkXVZBfx1psDaRxA/HCQinVBHNrD1Yfr8DFNrFOZZ3SK9o2TFGgRJK5BlVSNoaWrSi
         F7e67LmJYFUCjezH+VLS2J7kgn4Uta6ifRf7R2AW9hFY6uHwFoPz9CpcGpMDjPh0/J4V
         jSDDbQC4TEX+5Xi3MnLXIRdjkF2TpfBz0Nfw6a/4N9R9SJIOL3/ispx6HHNv/xHymjyA
         iU8Q==
X-Gm-Message-State: AOAM531IlTF5eChLMyJXmAMmniV06S2CG3k7alRzprNyq6vZ140bBcbB
        Cp6BLPQc62y2OzEYyaA1688zXYGf1IF6PHr34yF2vA==
X-Google-Smtp-Source: ABdhPJwuhSG6FUo3GYajEjDPeKw30Pi/VtO+YYqofICsgTOPsR3fZeL7GgnL2c+WPXPwbtsg7vUwUw==
X-Received: by 2002:a7b:c5d0:0:b0:389:fe85:3d79 with SMTP id n16-20020a7bc5d0000000b00389fe853d79mr23513603wmk.77.1652107001657;
        Mon, 09 May 2022 07:36:41 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm11121155wrl.97.2022.05.09.07.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 07:36:41 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock output properties
Date:   Mon,  9 May 2022 17:36:33 +0300
Message-Id: <20220509143635.26233-2-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220509143635.26233-1-josua@solid-run.com>
References: <20220428082848.12191-1-josua@solid-run.com>
 <20220509143635.26233-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
well as providing the reference clock on CLK25_REF.

Add DT properties to configure both pins.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
V3 -> V4: changed type of adi,phy-output-reference-clock to boolean
V1 -> V2: changed clkout property to enum
V1 -> V2: added property for CLK25_REF pin

 .../devicetree/bindings/net/adi,adin.yaml       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 1129f2b58e98..cc4f128222ba 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,6 +36,23 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
+  adi,phy-output-clock:
+    description: Select clock output on GP_CLK pin. Three clocks are available:
+      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
+      The phy can also automatically switch between the reference and the
+      respective 125MHz clocks based on its internal state.
+    $ref: /schemas/types.yaml#/definitions/string
+    enum:
+      - 25mhz-reference
+      - 125mhz-free-running
+      - 125mhz-recovered
+      - adaptive-free-running
+      - adaptive-recovered
+
+  adi,phy-output-reference-clock:
+    description: Enable 25MHz reference clock output on CLK25_REF pin.
+    type: boolean
+
 unevaluatedProperties: false
 
 examples:
-- 
2.35.3

