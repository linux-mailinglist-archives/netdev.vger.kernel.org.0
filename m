Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F14529CF8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243834AbiEQIys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbiEQIyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:54:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012BA286F4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j24so8499806wrb.1
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6aUKPv64m5V2ebbVeG/29i6DFjS8TzA0Vv0qPRIsII0=;
        b=d3utbKV+hrmvsavS15sOKd2LoviosVuzvFggC5cnMPENbfTlTue0E9yzPdGFHbWEum
         fDHun+nTtZlUsfLeeIbgZtGd/op4t4mFx1VxCVY3vEwPkYFXO4GJ0JY/v6PeifICly4c
         TpNEa7qLKCQPU7XqHkQK4wBx+bQRb4QnV8OB6K9UqFEH4gA4AGhmybZtiklR9OFNfWYN
         0TM5oucQdDQ6G9aTCF/fTYFlhPpzbQTMsvi9461YZejCBwehJaHM5CJNDj8TRK17BRjN
         WfSz79yok4r+4euVTG5iBLksSRnd4MCZpMR1a3bOXjkaLmwvreTMk0C1YRL9rxLpklEN
         PERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6aUKPv64m5V2ebbVeG/29i6DFjS8TzA0Vv0qPRIsII0=;
        b=uorGms++Tex+1+hui63K6HxvH7OqUAF8OA7+IwCgcLFGY2UTvyaKTlxE5qvPc4uCet
         Fs3Gsp3PpELkH9xucIZbaRgG2C/4f0lHZoZM5+mxUxy5oXhKabcEbs62yyipsgqVh1I5
         gHkiQEnfjY/8ttI5Q3iy5Yc9Vm9Oh3ZZ+FDMft1NWQIIejy/DT/xYt28NWmCH+0gv+He
         CbahDIStrdHp9bW3vailZpg1xMtuq4xRP0oz62ZkE64abC+mG3TiCGGxuY9/FunqI6zy
         HXFWwCbaiMOh/phF4ErkWstRWlrHRUAool7o9Lv1OhHavZFAbmCeBdeHqVtC5IRdtqVg
         HkWg==
X-Gm-Message-State: AOAM5328N/V3C9RyGpCJwi3nMSMgEw4cEyh5RkxkiHaKe8+BkZkgiu/x
        lsbC2/ObAybWncwQtEwsS6vQzwOcvn4FtFNBpkU=
X-Google-Smtp-Source: ABdhPJyj1/3gwkDNALlvJmkZbPJQMTa+taoyaAre+0li7LXLoWWP6+nAc8Y8ZQJaf/cVl054cx4WIA==
X-Received: by 2002:a05:6000:1c2:b0:20d:e3c:1d1e with SMTP id t2-20020a05600001c200b0020d0e3c1d1emr5476566wrx.688.1652777684334;
        Tue, 17 May 2022 01:54:44 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-54-179.red.bezeqint.net. [82.81.54.179])
        by smtp.gmail.com with ESMTPSA id c13-20020adfa70d000000b0020c5253d8bfsm11880386wrd.11.2022.05.17.01.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:54:43 -0700 (PDT)
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
Subject: [PATCH v5 1/3] dt-bindings: net: adin: document phy clock output properties
Date:   Tue, 17 May 2022 11:54:29 +0300
Message-Id: <20220517085431.3895-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220517085143.3749-1-josua@solid-run.com>
References: <20220517085143.3749-1-josua@solid-run.com>
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

Technically the phy also supports a recovered 125MHz clock for
synchronous ethernet. However SyncE should be configured dynamically at
runtime, so it is explicitly omitted in this binding.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
V4 -> V5: removed recovered clock options
V3 -> V4: changed type of adi,phy-output-reference-clock to boolean
V1 -> V2: changed clkout property to enum
V1 -> V2: added property for CLK25_REF pin

 .../devicetree/bindings/net/adi,adin.yaml         | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 1129f2b58e98..77750df0c2c4 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,6 +36,21 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
+  adi,phy-output-clock:
+    description: Select clock output on GP_CLK pin. Two clocks are available:
+      A 25MHz reference and a free-running 125MHz.
+      The phy can alternatively automatically switch between the reference and
+      the 125MHz clocks based on its internal state.
+    $ref: /schemas/types.yaml#/definitions/string
+    enum:
+      - 25mhz-reference
+      - 125mhz-free-running
+      - adaptive-free-running
+
+  adi,phy-output-reference-clock:
+    description: Enable 25MHz reference clock output on CLK25_REF pin.
+    type: boolean
+
 unevaluatedProperties: false
 
 examples:
-- 
2.35.3

