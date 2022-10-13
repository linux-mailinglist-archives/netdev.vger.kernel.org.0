Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6FB5FE5F9
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJMXoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJMXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:44:34 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12CD199888
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:44:22 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id df9so2281924qvb.9
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G4y6mG+4mDb5OA/mvjphPM6v31//PNw4p/aCL2x8Kr4=;
        b=HSPj0ofgWQ7QT+KTnLHM+8NWoBEfCxHC4YKqk6R86pzR7pPikvPG8xHSBss01D2Ejs
         VfTjnUXbLPAIvYJf+RLG3xzwnMx25G1IdqpzT+LplvdMEnka/WUiH9MOa9WQcq6BhUY2
         HnIpcsZDYB0gtXPmwYqtzxFsJhQqRJlvjcrxNqNRZ9L4+IsdCYtbp+j+0D6wfo4kazdy
         B9WCGlrULPlSfkFCLkUqGK7ilxtr4cXx754ATZ7UWKn/2dWEASXg1XWxO9o5YohCLMG2
         jZxCozdRodlCT+VVaVM5MIcNcZDjr9M2zxtjWEpk9HzsTL7Nj2YBfo8oSaNH3sy8pNeD
         fF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4y6mG+4mDb5OA/mvjphPM6v31//PNw4p/aCL2x8Kr4=;
        b=INFcgB8N1suosUuMCc9klHfSpiJbXA0KcqN2k9Sl1spe1OKLQCIAoOyq2kxX61Pxh5
         8ek8WQgsZtqTxxWZogFjOmNXJHeYSd6WK1m8FzyEfxHX6Bx9+kq/7aD91aMThsWOOd9C
         mmwtSWoyKu4UNkus+uN4JI0W5iZsbbSi9pXpiUa/OnAF3CUN4LnQaaMyxDxhOJIflfWU
         BQgLTgWk+uLlwy6aHlwqIilwVKRlQjoeaSyn9BBZIlPXx6y3rkkemtLHorCJkVIfODtH
         67MUx4WyjTCQlGOLoBfAwrjk1Op4U3OKRYon1L67toSBMzO4x8k9V55vzbun5mY+wKdb
         SHXw==
X-Gm-Message-State: ACrzQf3doAoVnCLp7iXeBIkCh8mSHLBSSewy8EpQzZn09Fn3QcfnPzK6
        rDWY4gdUD6AZymRWoaSOQmOYwA==
X-Google-Smtp-Source: AMsMyM4ZbodensA/Nqmrz2W2buL7MGJ5OnmzoL5Xy9Pl6OMGuchRLFFRuIMuxAF8HafgxloTlPRSqg==
X-Received: by 2002:a0c:b294:0:b0:4b1:a396:d1cc with SMTP id r20-20020a0cb294000000b004b1a396d1ccmr2170493qve.107.1665704654294;
        Thu, 13 Oct 2022 16:44:14 -0700 (PDT)
Received: from krzk-bin.home (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b006bb82221013sm1210073qkn.0.2022.10.13.16.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:44:13 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: nfc: s3fwrn5: Drop Krzysztof Opasiak
Date:   Thu, 13 Oct 2022 19:42:05 -0400
Message-Id: <20221013234205.132630-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Emails to Krzysztof Opasiak bounce ("Recipient address rejected: User
unknown") so drop his email from maintainers of s3fwrn5 NFC bindings and
driver.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml | 1 -
 MAINTAINERS                                                    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index 64995cbb0f97..41c9760227cd 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -8,7 +8,6 @@ title: Samsung S3FWRN5 NCI NFC Controller
 
 maintainers:
   - Krzysztof Kozlowski <krzk@kernel.org>
-  - Krzysztof Opasiak <k.opasiak@samsung.com>
 
 properties:
   compatible:
diff --git a/MAINTAINERS b/MAINTAINERS
index d0d808564539..e06289b01229 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18160,7 +18160,6 @@ F:	include/media/drv-intf/s3c_camif.h
 
 SAMSUNG S3FWRN5 NFC DRIVER
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
-M:	Krzysztof Opasiak <k.opasiak@samsung.com>
 L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
-- 
2.34.1

