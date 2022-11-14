Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9E6289AB
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiKNTrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236809AbiKNTrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:47:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEC71D323;
        Mon, 14 Nov 2022 11:47:40 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id i10so22275357ejg.6;
        Mon, 14 Nov 2022 11:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYmcpnW+ePTt4zEzu+teiWByE3/vsa59R3Lc76Pvt6g=;
        b=bcDLb4T5i3fAW751pVys7VAd/J/u49NNcKnx1M30PsveLWVzxshJTGR/Tb/JzaD2oY
         Dj3vRfsmCVg54cI5AP7ddzgxbB8NS1o3kXs4bIwmYaYkqNsAULNmM2O6IJAdVp2D6lKz
         DoczCZArkxR8Wn9oOvkt0WWu7BYahKmKEoZQ3vJ08DurZ2vUACxso++hTRyTrgieYjed
         wuJS3jGvlAbixIookRK6cRy0bYDEq7z9MI/6C1u7DbvU+cjIy6wX4A8YXfHuxRTqhPl/
         S7+A4wMJzhUZCZi1BE+DptqTc2wvrTgjyOiqjN3Ob8e94td7gjFrqW3Kg4DePMfvoeML
         jdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYmcpnW+ePTt4zEzu+teiWByE3/vsa59R3Lc76Pvt6g=;
        b=ZsdBeO4K2F3Q7Q2W4dXGPyV7G1YjDKZgU8GaNEAI/6iD5ovPH6mIGLwI3VHAN7C6nv
         9Rg8RjLZb4Upt6AE4tJTLFEMpVUh2yFY2c+Xoz9f/07mKx4MjIeRAQoEuYILhlcyNRG6
         n5MzjcL7r84VBQgPAccwWPIY+D3HuiVoXXMQoDzmE2RgJ9wtvjp0F0I/hXjlOQKa+Yi7
         2CKnKBoOhzODToca5neWWb/QYrGQsvPI3ztPyUdfAS9v7Jc3o4VwGR37uQQZSC40F4fE
         Pr6uzsmQWr9mTp30IoLxTYPfRCU7Nem5Spzxhb6U1Wsz0aePq5UGWEv+64K6l0x99zhv
         3Y6w==
X-Gm-Message-State: ANoB5plQGzqmFgdSXci7UL+MCf5cMfUIj+JZfIYEU1VR3e7qrTrmitMw
        62deJ9/UKVTEV6AuS68X39eSMjKAPVK3WA==
X-Google-Smtp-Source: AA0mqf51HJAjjBZeHlAjjPueqCuplZVbbeBBRVTfKe9I5jUORIRwwZhujq8bmIJIx03ZHShvDvq84w==
X-Received: by 2002:a17:906:ae52:b0:7ad:4a55:5e19 with SMTP id lf18-20020a170906ae5200b007ad4a555e19mr11573740ejb.65.1668455259275;
        Mon, 14 Nov 2022 11:47:39 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007a62215eb4esm4666405ejk.16.2022.11.14.11.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:47:38 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 2/5] dt-bindings: net: ipq4019-mdio: add IPQ8074 compatible
Date:   Mon, 14 Nov 2022 20:47:31 +0100
Message-Id: <20221114194734.3287854-2-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
References: <20221114194734.3287854-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow using IPQ8074 specific compatible along with the fallback IPQ4019
one in order to be able to specify which compatibles require clocks to
be able to validate them via schema.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 1ba8de982bd1..f4918c9e6fd2 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -22,6 +22,7 @@ properties:
       - items:
           - enum:
               - qcom,ipq6018-mdio
+              - qcom,ipq8074-mdio
           - const: qcom,ipq4019-mdio
 
   "#address-cells":
-- 
2.38.1

