Return-Path: <netdev+bounces-12041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D9A735C9D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1DA51C206FD
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C8D12B72;
	Mon, 19 Jun 2023 17:01:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E3D52A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:01:44 +0000 (UTC)
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AD211D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:01:40 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b477e9d396so19810301fa.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687194099; x=1689786099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3yMeqwFbUwChaaY+2kXQ++7jSRaUs+3ol5kKFJmD0BA=;
        b=OhHELcAI+0qa0VaQkXid5sHdJ/r3vmhDpp7mf8StAukqs91HWZ6XQnzNPQ/V6h3Am1
         tYinDWqBpNwzsVohADsHPAgCLsZv4sHcSq4QJG3vLbwc92oMOTRY/RNcTrQMwTax36jr
         kNMOEyqsf5tW3HtyfOpu9oBA457k4HVmZuwRdMoORb6l1GTbrCb0KWpUS3xX3usovHza
         MdS2/hox0AU4FHlUfFtqYUwTAc5tOiP+NaD7bRn54nbSOjJo1K/RFnSrNWQD2De5Hniv
         Qy7thYONvFCAC0GoIPATkI05C9LS5EfjOviYp9UN4+dRud7qN03EyqYA1PE+iiDyfxUK
         29/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687194099; x=1689786099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yMeqwFbUwChaaY+2kXQ++7jSRaUs+3ol5kKFJmD0BA=;
        b=DUGGxFZILWNUg4nqvCgJGu9z/5fA+2NaLM5klK2gbGPgRN+xh6A5cOEtb87YMzROE5
         xre0s8H8a2cq+dk9AQmXYxCvJMe5mDghc8pgmixHTPQPSXCiCsXBN7Z23eR3oax3X0ha
         O1xv8pynnZXBXDUBhflLDfkjvmJXYyKpNT4y840kbDiNHyJHxI2c+4iHlPNDsUhJFU7w
         9mL2U9tpv0Rvv0KciV+9FivWUe3cINfdQTNns+JV9N5QnEEDl+vU3Yb/eCfrZt1dI9mA
         /4RUFs0lntHKMPHCkmvLfV0U9ADqmSmg1lMYJ+EIPhK2XFQ0xAtsPJqugvRKMdpUpk3/
         1png==
X-Gm-Message-State: AC+VfDyffNjlkOiN2pGMmuL3eLyvPk9T616vNfafBxR2xeLK2UKDz/sR
	fNSZNZLkNQ9CLezqDG84uHvZrA==
X-Google-Smtp-Source: ACHHUZ6km+wFH2Ik4L8UizQ0gpCirfIeOM7hLqgXQDbaVbVN2UTTWLgmSeQFZE6GSUYC2UnUhH3QOQ==
X-Received: by 2002:a2e:3211:0:b0:2b4:7d83:c804 with SMTP id y17-20020a2e3211000000b002b47d83c804mr1724696ljy.50.1687194099137;
        Mon, 19 Jun 2023 10:01:39 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id b6-20020a1709065e4600b00985ed2f1584sm5146700eju.187.2023.06.19.10.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 10:01:38 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Marek Vasut <marex@denx.de>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next] dt-bindings: net: micrel,ks8851: allow SPI device properties
Date: Mon, 19 Jun 2023 19:01:34 +0200
Message-Id: <20230619170134.65395-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The Micrel KS8851 can be attached to SPI or parallel bus and the
difference is expressed in compatibles.  Allow common SPI properties
when this is a SPI variant and narrow the parallel memory bus properties
to the second case.

This fixes dtbs_check warning:

  qcom-msm8960-cdp.dtb: ethernet@0: Unevaluated properties are not allowed ('spi-max-frequency' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/micrel,ks8851.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/micrel,ks8851.yaml b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
index b44d83554ef5..b726c6e14633 100644
--- a/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
+++ b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
@@ -44,13 +44,13 @@ required:
 
 allOf:
   - $ref: ethernet-controller.yaml#
-  - $ref: /schemas/memory-controllers/mc-peripheral-props.yaml#
   - if:
       properties:
         compatible:
           contains:
             const: micrel,ks8851
     then:
+      $ref: /schemas/spi/spi-peripheral-props.yaml#
       properties:
         reg:
           maxItems: 1
@@ -60,6 +60,7 @@ allOf:
           contains:
             const: micrel,ks8851-mll
     then:
+      $ref: /schemas/memory-controllers/mc-peripheral-props.yaml#
       properties:
         reg:
           minItems: 2
-- 
2.34.1


