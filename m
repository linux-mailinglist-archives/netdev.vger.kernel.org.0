Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F189E616882
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiKBQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiKBQVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:21:42 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1997231ED1
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:15:23 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id z1so6188753qkl.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUIqt5qgvlwR23A+HVBIo3LzIMemIRkCkHJ4mOyl2J8=;
        b=FVlskIjr+sENRJWrtAh2zV8qqLujiM4y+aUUEzUPCKxu10SAzprl2BTMKUDXeAXmsa
         pTBQN5MOerOiiIU+/htxqxDfmOZdm0HsTjVqJeLWIzCHgLCgTULqjUwDQPsR5htfSfdP
         TXsdihcdQ4ldzdjkA1xRdlp3ulMwrXCBglBz7GIv2AVmd1wXV0NYSDXS1cSgYWiNwNIb
         zvR0/0VXuq7jK27wEB8R66hrMMyHG0uMp2KYin1AcEQ6AQNy+qmjYISDrFb4QUyq+6X7
         ZQRZqE58xVizemJiCDA4J54F6ApQY2/EFAQTLeVD1EadMIcZ0UheXRPHvdlSIupGH7p/
         9XGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUIqt5qgvlwR23A+HVBIo3LzIMemIRkCkHJ4mOyl2J8=;
        b=eMKkaqd9BSFsC0LTBnFLB7NoUyokseCDnT3hjGlR8FnjdywzpBpBFml+1RUJ+zWGDx
         r2jM9UA7sZxu2jsMKGbzgL5BXjVuI3v4vRcKEMNsIkzLzNW0kugnSA1Oxrpn3pnuKjKQ
         pzUYCsHfp+JhBjXZpHEKcY4eYN5Hg2MtCVcesHFAKQtIIUiYqd4UXOBvtq9uNuS3owi4
         nM5GTvqZ6QSm5FiqcuMnUKl4e91UI8teZdn3Xa2rk990OJhm2AewbVhhwKTXFlcRy6EM
         FWdIh6OFGgjhacaDOlwvcCXvpPNok5hSU8GUqDdOUsxD5vB8gjUzedwa+HNt/WFK5ZN3
         8cUQ==
X-Gm-Message-State: ACrzQf3p8UliaQ+FsZqQTa2ZCp98qwNcc2DzXWC1gq/bRa2epKF/M51A
        gkwjNz+Yk01FDHzFGHubaFgogg==
X-Google-Smtp-Source: AMsMyM41FmWXlA5k6IlmlP57QHOAFPhcgS/Hs4YLXIX7ot05fxx9yV2omsjHYy2A++h3HUiXZE8iBg==
X-Received: by 2002:a37:8847:0:b0:6fa:4e9a:7fbc with SMTP id k68-20020a378847000000b006fa4e9a7fbcmr5790560qkd.576.1667405716686;
        Wed, 02 Nov 2022 09:15:16 -0700 (PDT)
Received: from krzk-bin.. ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id h12-20020ac8548c000000b003a4ec43f2b5sm6831571qtq.72.2022.11.02.09.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:15:16 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 2/2] dt-bindings: net: dsa-port: constrain number of 'reg' in ports
Date:   Wed,  2 Nov 2022 12:15:12 -0400
Message-Id: <20221102161512.53399-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
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

'reg' without any constraints allows multiple items which is not the
intention in DSA port schema (as physical port is expected to have only
one address).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v2:
1. New patch
---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 10ad7e71097b..9abb8eba5fad 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -19,7 +19,8 @@ allOf:
 
 properties:
   reg:
-    description: Port number
+    items:
+      - description: Port number
 
   label:
     description:
-- 
2.34.1

