Return-Path: <netdev+bounces-1136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC39D6FC513
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F36DD1C20B6F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7E217ADD;
	Tue,  9 May 2023 11:35:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52033182A9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:35:24 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110A12D58;
	Tue,  9 May 2023 04:35:22 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4efe8b3f3f7so6555112e87.2;
        Tue, 09 May 2023 04:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683632120; x=1686224120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQ9PB/UjgQdEomLsQFjCrSpNBCkBCgqrAFyhnpB0P5Q=;
        b=AGmJEnX5lM99SSQkFuTItq4ndHX2KRpXyqZvV0gG2r8ACzzjDEUaMa9gGMcROf1TdF
         FwUqjU7T0m6o6qMrqVrDjrvmtotNEkJRFsTKldLFyJHw8y20SkkoNZNmttmBkkeVC534
         MYFi15xzLOwd/yuV0Moral/BgTbCAWCKRqFsWSzog/WqeGJzorm4TX1WtfL5sij1fdT8
         bp+mpdyipj2Kdm75szKLNI80mOz8zdf3qcOphWXTlTXLlIUNBzFe7U2g5LVkvYWf3bhO
         uph4mNsQYNl+bylVL0YS+1l+23S7iCUqBHO/dHGLoTnhtzGFm8Kn9CmyakMjHwGo3Pr2
         7q0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683632120; x=1686224120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aQ9PB/UjgQdEomLsQFjCrSpNBCkBCgqrAFyhnpB0P5Q=;
        b=FyVTtPi7rpHlEA2E3SvIS2ALUb9zPIEkxmp9SemYdGAxWrAVQqWlQxaUkxs4edXutB
         wE8wSNOXVuu7s4cEFqS+yQqVHGU9pUTexyWQCT1onXSadgWeW09s/36LB5K6X6ZwgS+u
         QWwqnHvgGylfahvaH2WnN7Sx6w/n51OrSU47GAzbarDLTVTg4bxMUJavd/RlVTaeGnXC
         XXNWpqcvMPACaO5n9PuBmE0Kfxs6El8MzcmTRlz7XC2OChfrX+N2VHtN9lnuzrLjWyCM
         8gHD1D3GEI7qOtybdMpPQNk74vKHpet5/iXq/XndkULK9qotmToOEkqRSf1On8vk3946
         Vdng==
X-Gm-Message-State: AC+VfDxLtHTKiGFKKYOTxQWGETDKHSr/hsO2XI3bktYXJMq0SZFbLHeU
	qQu2ewGIo6/0fH5CBIGIitc=
X-Google-Smtp-Source: ACHHUZ6GvZGEid83w6782Tu4dK7RhRUtad1gNRgpAbl5QMHkN490GGttEB3yPd9qZJ+bmNOmx9T/JA==
X-Received: by 2002:ac2:5638:0:b0:4f1:26f5:7814 with SMTP id b24-20020ac25638000000b004f126f57814mr649736lff.20.1683632120413;
        Tue, 09 May 2023 04:35:20 -0700 (PDT)
Received: from localhost.localdomain (93-80-66-133.broadband.corbina.ru. [93.80.66.133])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac24570000000b004f25ccac240sm108940lfm.74.2023.05.09.04.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 04:35:20 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Date: Tue,  9 May 2023 14:35:02 +0000
Message-Id: <20230509143504.30382-4-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509143504.30382-1-fr0st61te@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the mac-address-increment option for specify MAC address taken by
any other sources.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 .../devicetree/bindings/net/ethernet-controller.yaml      | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..6900098c5105 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -34,6 +34,14 @@ properties:
     minItems: 6
     maxItems: 6
 
+  mac-address-increment:
+    $ref: /schemas/types.yaml#/definitions/int32
+    description:
+      Specifies the MAC address increment to be added to the MAC address.
+      Should be used in cases when there is a need to use MAC address
+      different from one obtained by any other level, like u-boot or the
+      NC-SI stack.
+
   max-frame-size:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
-- 
2.40.1


