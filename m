Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4500B5068B1
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiDSKaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242166AbiDSKaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:30:09 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAFE2655E
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:24 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso1261355wma.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsebvKOYokXaJagvEDFDSbIazWtZdVMdtGwXTxdqiEY=;
        b=jCgzCTInl5IYOadrG9WDwFXRlUaAFQKPa6+CFdtUoSxDB4KkPlkiBl3IKhCRBFz8ow
         kWvz1UUfALZmImtqLEZ8McF68KFtZwgn3lYgJmMOSJixHZYCyLkcV4PMmoFMWsYaqabj
         ZgxznfG7Q7LWIKyZwL00L2TEdksyVf3ZBupcLAcXDhgkJS26oiF5AC03lfkgpSWb73hz
         f4mC1zzsI0H95ZK98paeSKnNge3FYtmtaRL0RT+29KJSyO8P+JXYQE2CANeirHrUTtwo
         wUixSclnO5Nsn1sDH/R5vKzx0IaAMiXg5OqlXxS8xbCXhDEuNinJ8iQG5MYkhk+g+3Pm
         J8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsebvKOYokXaJagvEDFDSbIazWtZdVMdtGwXTxdqiEY=;
        b=mNypTiGE+QR3u7OKuChJFubSprWznlAN2rPZpkgbQgjrQ/IbmcYWmOaE/Q9SGU6cde
         qy0jjxMc+4+wpmVQo8rJVIlcCdUJE4QqSVqSseHc7jy4X6RvZL4+IalhrKaN7ImTCzBr
         CR1+EYA7mx6FtFvlOgLxgByKIgiiGVTEWPa0FCZidz0bVf33WQI4/CQPk9eNqqzkbXA0
         4099btVtWnB8perqh9KDuocDx12s8gg8jI9IiRj00R1e92e/SPBeVy1g9YH9xuNahurD
         Jo2i7tSuPZgKvNYguvdFuHiCING8FbKjD9tEyaiOI7L5m+lnFBQSBCrAmOdL+gHllQNk
         QqRA==
X-Gm-Message-State: AOAM5339yT05NVkRaJp+UO17Qx33kLGR64gz+KclIJ8A0Ym9cSHjNCYv
        QBGFB20eKDGST0v9IXJrzTsIb3BXX4Z8qULD
X-Google-Smtp-Source: ABdhPJyCrFR4HvGsP59e4e8wADqqvbLSyhuuYKUKr/nq6q+fcw9b60JbuuOLkElcBc+65zkvYPLrvg==
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr14715656wmn.187.1650364042725;
        Tue, 19 Apr 2022 03:27:22 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id m4-20020a7bcb84000000b00389efb7a5b4sm19036166wmi.17.2022.04.19.03.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:27:22 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 1/3] dt-bindings: net: adin: document phy clock output properties
Date:   Tue, 19 Apr 2022 13:27:07 +0300
Message-Id: <20220419102709.26432-2-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419102709.26432-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
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
V1 -> V2: changed clkout property to enum
V1 -> V2: added property for CLK25_REF pin

 .../devicetree/bindings/net/adi,adin.yaml       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 1129f2b58e98..3e0c6304f190 100644
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
+    - 25mhz-reference
+    - 125mhz-free-running
+    - 125mhz-recovered
+    - adaptive-free-running
+    - adaptive-recovered
+
+  adi,phy-output-reference-clock:
+    description: Enable 25MHz reference clock output on CLK25_REF pin.
+    $ref: /schemas/types.yaml#/definitions/flag
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

