Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05562977B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKOLbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiKOLbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:31:32 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614A0D11F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:31:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v1so23701571wrt.11
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8v8FoH1On1F2wnSoCme92GBkJZmxbbw7MltkC0PFYms=;
        b=fV81m0WSB0Y0qWL64erh+PxRX/0jfKH6EuUYi1t5kjQz8PuFyAd/DioBHcf1HQT1db
         OddtrRrcbbaPvBsbdaXjpnNFSM8I5foNs2TU2VHwWYfJfWJMz3jJWdko60QZC1c9W2+K
         x04Jka6V9I2ds31GZRRI7ZwSHNYHKBUgVHXYO2ZuTlvGyZWXgbWMetK/aWK/O+eNT5SQ
         TTMkr5aMtu0YG3tnX6tWeNIoPYlgqieK07001dSLFGfH+0PoCe+hlvZEmNXP2oOLqKRd
         YYjhFulu7AC/oG076eU0IV4Xc3400GQwJ6NAYXFDu5aowI0gVPXvwjawC5ID9sLV9ZI5
         FcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8v8FoH1On1F2wnSoCme92GBkJZmxbbw7MltkC0PFYms=;
        b=mathZfyqG9d6TXyZZIyvhx5kIuazKNQerF1q+VhKATTS+rwcaPbi1LQmLJgPe/COTy
         zJR4DrfK++XlUgV7U0oYCh5Igyfdn+juqU0VCpIWYsTLK3nwvqnE46nVtISgzT9hdiMp
         8VZrWGlrbtn+7iRFRESb3eB9aVafr1XKXqZJrhLKMtDyWep1lGa7fyW3W3yJgdVOBsA6
         vHghrMi9RY1bILTuQaRpATaTxiSwME8ash18FET/ZRtvslOLLrWcVJhJOJtV2JKsNhoF
         W07nrtbXvWVEsZw3mMhDFB2cEY23kHtOdOc4Ydf3ef4fNWo80V7arRLFdeh/YlJ7vSwC
         3snw==
X-Gm-Message-State: ANoB5pk3yxzSjxSWsz5ahhZNxMJfgj2mEliqlONKd/ouqoAzRNGrlGeu
        HV36sIThINlspAvjBVENk/VJgA==
X-Google-Smtp-Source: AA0mqf4rBCbH8yVrbONUMZtbsOjGvs/+gFwoCFUHPTxOJOfNsDMlOXKvZ7JDtRGqVf/ZjSQQ60BhCg==
X-Received: by 2002:adf:ec8f:0:b0:236:ae0d:e833 with SMTP id z15-20020adfec8f000000b00236ae0de833mr10196617wrn.155.1668511890934;
        Tue, 15 Nov 2022 03:31:30 -0800 (PST)
Received: from zoltan.localdomain ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id r18-20020adfe692000000b00238df11940fsm12273091wrm.16.2022.11.15.03.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:31:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/5] dt-bindings: net: qcom,ipa: support skipping GSI firmware load
Date:   Tue, 15 Nov 2022 05:31:18 -0600
Message-Id: <20221115113119.249893-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115113119.249893-1-elder@linaro.org>
References: <20221115113119.249893-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new enumerated value to those defined for the qcom,gsi-loader
property.  If the qcom,gsi-loader is "skip", the GSI firmware will
already be loaded, so neither the AP nor modem is required to load
GSI firmware.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index d0f34763b9383..9e81b9ec7cfdd 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -128,10 +128,12 @@ properties:
     enum:
       - self
       - modem
+      - skip
     description:
       Indicates how GSI firmware should be loaded.  If the AP loads
       and validates GSI firmware, this property has value "self".
       If the modem does this, this property has value "modem".
+      Otherwise, "skip" means GSI firmware loading is not required.
 
   modem-init:
     deprecated: true
-- 
2.34.1

