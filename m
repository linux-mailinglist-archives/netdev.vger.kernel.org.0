Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956615B0E8E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIGUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIGUty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:49:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0835E31213
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:49:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pj10so5272506pjb.2
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=B6Ko3OJsi3My3U394LKzG8EklGxMOFfBOJITDS0awiM=;
        b=Ze1KQOlEPe5reaj0Lf1bTPtHUU6TxiunzPeQO68W1hBBrmEpH4g2XDpQ3IB71q7BQT
         m61B2fWIFP3c0wecBvPmyR9ZJY9Si/4Tsa9bbIy3kZNSe7eaQahqPo42KVLiRpIJk8ds
         3xldO47w4gk1+0/X/lpwjJ/0eqRmZGjrr6RJ5JuUzUeZfuKbFIIYsmMjnTtRXKF4CLSO
         OCDubPZ9KK+xEfO0vL20Wwp5lqnf/k0rBD+sf1EdKp+hzN6EEmdIjfirosSNsPZn0HW3
         bsEN3F5L+sOPt+qkrmuwieiOc3pH7pH4nu4peCYxgrR/7SuC46W/rZ4FRhENStB6/B9U
         uiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=B6Ko3OJsi3My3U394LKzG8EklGxMOFfBOJITDS0awiM=;
        b=GxShAFwpExSjqLmbA3yvc9+2j7x2/d1cnoer2GmbqxSbIuv4GrPIpmJySoGggDpbwe
         L4Y42H8FPjHPfA4L+E2OLkhSStDDdxvSD9CjcG9XgkUsO+aMARtvrnk64cT9+KKJ0PvD
         XjOsS+wp05p/OpDgbxIhlz1/O7hlpTQKXzf/5Wq3KmHNypMNtS8KaMTkJZwpkW1KhYv4
         M5WIcdnK9AHqG2UHtmkbHR52jNfvh9p9EV8gkoDKFpUb5BYepaTao/DyXWGdrWFQ9mU3
         FNRrXLXnxtU2rsaAD7HJcfTwWh3zL7x8zYld8FUD2yh+yJKwXx5NrJpw0AQpTNChbLtu
         VDvg==
X-Gm-Message-State: ACgBeo07qpsmjAwikZLzRmVmAvQ6XF3OFgmCCkNurNg2fhCzxgDf9KdO
        KHyH2r2kXtSI+d5im+Czqpw5iA==
X-Google-Smtp-Source: AA6agR6fZmpd7SsPnR7Tq4yoruwuUPK94V6y3bPbEVACKI8POKGjIhcHfPpg2pvJPBPD5GKN9aSDow==
X-Received: by 2002:a17:90b:4f81:b0:1fe:591a:3c04 with SMTP id qe1-20020a17090b4f8100b001fe591a3c04mr386150pjb.66.1662583791270;
        Wed, 07 Sep 2022 13:49:51 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b001712c008f99sm12795140plh.11.2022.09.07.13.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:49:50 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 3/4] dt-bindings: net: snps,dwmac: Update reg maxitems
Date:   Thu,  8 Sep 2022 02:19:23 +0530
Message-Id: <20220907204924.2040384-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the Qualcomm dwmac based ETHQOS ethernet block
supports 64-bit register addresses, update the
reg maxitems inside snps,dwmac YAML bindings.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2b6023ce3ac1..f89ca308d55f 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -94,7 +94,7 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
+    maxItems: 4
 
   interrupts:
     minItems: 1
-- 
2.37.1

