Return-Path: <netdev+bounces-2167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C93667009A0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE7A1C21209
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF1A1E539;
	Fri, 12 May 2023 13:58:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E531DDDC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:58:58 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52F7D870
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:54 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9659e9bbff5so1830081466b.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1683899933; x=1686491933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EurCSfvr992X/6Gy0O7JYm3XtzvDHOqQWEeqxrS+tkg=;
        b=MpFaid4LrmkmpMNIiLRoMm4TkTXzDi5yrI72zQiY/CTDBf6wZnkRzw0ebnE5kU2nC3
         CTssnKiroIDezyQIpPCbfqsGVRqgBdNf4IiKZ4JDlecqbg3ibhQsYKR9HT05PBGMu6oZ
         inazl50xNH67x74+4QDxhGVet6+ez4HZLIhoJ8wZyt8sgLH2Nyn8Fs7ZmL4oMhha3jgH
         S8Pxw9mH5FdIqai1pv0/GwGdfzurB93XD32hA/xJBPsnb2sii0rq4yrvxq2K/dyO/yhb
         IqzdIzGovHN+Y46gBxWjdNT63uqVIHP9Jyg9ZG1t4kGqSgRqh0/Vjq5VIoKxS5xhKnOC
         uVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683899933; x=1686491933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EurCSfvr992X/6Gy0O7JYm3XtzvDHOqQWEeqxrS+tkg=;
        b=ifqHUVutXgc3FnTOrcva1O4iznvNWkcq7KyieZ6jncWTtsPwxg9UbgLOz8oloCfLJw
         wlAvSXtT2gGDgAdewwIXFgGS4DQzqhCOiGObSAgAKtOieisomKiYis+IEfnFqNqL1Bv/
         17XOYIAtps/TtaVAJUN+KH4wGhmnS1X9HK+1e77m4Gt2IdC6izssBaA6adq803HmXKEV
         GyRXNQkbt5Tv59er7eiiJhIsZ0rdO/lU4fMWI/PN3znRwKevjeP6IG1vtLi009uDQ/BJ
         bTjADH7wVjqnV5kZx1HXGU1yQFXGiVSqSTi08PQQrAPtGvMfOpLxabC/K4QTQbZ2oFVp
         17ag==
X-Gm-Message-State: AC+VfDx+k0rT5qogPvlj3RpSMZPDgWgIZOnWgUoO25tG5yGVf+ic7TvO
	EnNM/Noc0F3fJMcVbrdF8T1Rdw==
X-Google-Smtp-Source: ACHHUZ5UEyM3P4D5ZDQEYMfCru5M45wxzGFfzUZ3l9Wr66ILwFSWfRSSpyyWy7RFttpKOGFK+/FqlA==
X-Received: by 2002:a17:907:6088:b0:949:cb6a:b6f7 with SMTP id ht8-20020a170907608800b00949cb6ab6f7mr24594424ejc.56.1683899933449;
        Fri, 12 May 2023 06:58:53 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mc27-20020a170906eb5b00b00966330021e9sm5399061ejb.47.2023.05.12.06.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:58:53 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 12 May 2023 15:58:23 +0200
Subject: [PATCH v2 1/4] dt-bindings: net: qualcomm: Add WCN3988
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230421-fp4-bluetooth-v2-1-3de840d5483e@fairphone.com>
References: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 netdev@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the compatible for the Bluetooth part of the Qualcomm WCN3988
chipset.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index 68f78b90d23a..7a53e05ae50d 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -18,6 +18,7 @@ properties:
     enum:
       - qcom,qca6174-bt
       - qcom,qca9377-bt
+      - qcom,wcn3988-bt
       - qcom,wcn3990-bt
       - qcom,wcn3991-bt
       - qcom,wcn3998-bt
@@ -106,6 +107,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,wcn3988-bt
               - qcom,wcn3990-bt
               - qcom,wcn3991-bt
               - qcom,wcn3998-bt

-- 
2.40.1


