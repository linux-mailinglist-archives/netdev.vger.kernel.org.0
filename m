Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B513A512E8D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344319AbiD1Ig4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbiD1IgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:36:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1BA66F7
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso4864936wma.0
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahe9kmz5sZkVP4ViBXwullVhsY17APIJQ3g9W0K/6H4=;
        b=yfcJEiY5Fch3WC38kIxmXGd8u+P1R7SXR02eCOL9g+0TLv8H8RrUu+pvws5hrQW3Ys
         K0id9eCydzjBqNCdCGuroFsD1VI0Um+2EPS2CtZQLYU8+0qndFDGWXlfEIdKcWUB3+9t
         Nwfmoj36nySzLmAaDCcMxAUrGIo0w+KLdHIlFkaLEsiFceJZMwt+Otobj4qwDI9e1akn
         TiZEsXV3YTBagZYl/nhq4hcJtvM7GwsJPkVdabToN8cuJxGzpNCMJrb5/C4MWP1VQ+D1
         trOvrBFHq2Ky+uBiyyy8M/txo4lbWtrf5S6QPT9YC2FNlT1L2B135DFnJd4RWK66knEH
         zeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahe9kmz5sZkVP4ViBXwullVhsY17APIJQ3g9W0K/6H4=;
        b=C4nISZfe9f6NvRUAHioa3INIl27pnaftVX5XMJRuwaMA0eqhKP5xDPOa7YGUleIu68
         LblgGrNqylrQl+kl8eohxS8fh+LHYNDdlLDNQ/54SuAxEta0gwmgrc//NYz8pqsWGRBJ
         WaP3m/9BxyEQ3gOfJ26mZ82GWkXDZERT27gaFoqEorfC0JiAm2jQqo2JzgqA4RI/pATu
         Dk0jygCRx8M57rIIBNiVTKxrcCbsRCP5DF7P3jQtUwvf8+BKosPP5J+Q8v478byQxIsb
         sTg/13XZV8leVBlwbph1Vj4YUXSq/G0oys93tozK88BBiygGYSmdr+CUXAmIY1VLpjJm
         8lDg==
X-Gm-Message-State: AOAM531e4zwuyn0HGhbzIxb2sNPBRGTKhQIHos4/iZucp03rW4O8UugP
        /+fEkrE0t32HxP6nvCIle7jxXS1WqPgkxbD60s3gwA==
X-Google-Smtp-Source: ABdhPJxKU7CIrW8O5/1yBAOs8Fox+v2V/SG61aUDCYJQB8JIKWP7RSOwT0g6GPkApQhEj58GkBdxZA==
X-Received: by 2002:a7b:cd97:0:b0:38f:f785:ff8 with SMTP id y23-20020a7bcd97000000b0038ff7850ff8mr38324474wmj.44.1651134553361;
        Thu, 28 Apr 2022 01:29:13 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id bj3-20020a0560001e0300b0020af3d365f4sm1876249wrb.98.2022.04.28.01.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:29:12 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 1/3] dt-bindings: net: adin: document phy clock output properties
Date:   Thu, 28 Apr 2022 11:28:46 +0300
Message-Id: <20220428082848.12191-2-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428082848.12191-1-josua@solid-run.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
well as providing the reference clock on CLK25_REF.

Add DT properties to configure both pins.

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

