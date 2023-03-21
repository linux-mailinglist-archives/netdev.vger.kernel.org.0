Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475AF6C3851
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCURfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCURev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:34:51 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7843853DA6;
        Tue, 21 Mar 2023 10:34:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v1so8441200wrv.1;
        Tue, 21 Mar 2023 10:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679420061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5vmC+EEyycxrgZNummq179GgUhM4r8ZAr7cKYD7Z2E=;
        b=ZDYPBmIzA7ipL8Y6TLfI0FVN2waK6eXQTb9Y9gbyiLyfZ68Vc2tLAtOGtJFSk3uZ82
         saQGvYjkO2OK5s+aB+uRdUFDNBPPWT6ZBVEcM2tcs4uAr84Y4CAXo6ouEaVR45VXcp62
         XRjQ4bn15CwaclzaEg3cvsPKsaqPpw4+SWi83bhiUfO2KkW+ixFx+baR9tCbjNghuBm5
         hceRfYnXezJBqdKYaVxTq0XmjPA7FoEXRRATgIrpkKWH17Ap+tt72VnuRukWzea+RrIu
         8cu8/7G2mXy+dsyjir2AnY9w5tPvTPqBvEWXU9XqtguqUu4OtkU+lkDCdq0w0Ht+Cp+4
         +14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5vmC+EEyycxrgZNummq179GgUhM4r8ZAr7cKYD7Z2E=;
        b=TloKpvlPPKgw3s1pk6WLNNO2LXFt5jVro4oOQB18Nu3cYLqrNy8PyDnKBpus7orcJ0
         vCYUnwUUtRkZjPILBEijsqIehMUJ8tpLmHqfWNQxfrsgysvMyc/gIeHY0emPskeo/wlZ
         OVh6eykkOY+0Dk5KetDubO63Aa7x1IJYQWtQE6FyTxfJYpwQKh4MFy2eZgv+GghDmNio
         iro8jKskuPR8C5CtpL8MLpvTKxHAXa76BsRXQJPcLCcu1UZA62m+1v1XPlXgkqD/XpSa
         C1+0a5l6KK7Wde/5dEDMAcb3GGPzlcAimIwwVyNnfx9S55SQNSkzRdxrLtxvEj+CdDHO
         bsow==
X-Gm-Message-State: AO0yUKWXRfUGHDqnsbZ6A09ZX1HvxhX8fglhD6Cakwi9ttcK9EH3Fq9o
        AkMvKIrv5Ly0zgDwWWDjxfQ=
X-Google-Smtp-Source: AK7set8RbKIGVaZ1Xy2DSHNTpAaldPx+B5drOYEB97FkjgzzzFUQTwTzA4gY056QhPu/dGAN9uTLKg==
X-Received: by 2002:a5d:440b:0:b0:2ce:ae4c:c429 with SMTP id z11-20020a5d440b000000b002ceae4cc429mr3501801wrq.4.1679420060860;
        Tue, 21 Mar 2023 10:34:20 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b002da1261aa44sm184775wrf.48.2023.03.21.10.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:34:17 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Simon Horman <simon.horman@corigine.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 1/4] dt-bindings: net: dsa: b53: add more 63xx SoCs
Date:   Tue, 21 Mar 2023 18:33:56 +0100
Message-Id: <20230321173359.251778-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230321173359.251778-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230321173359.251778-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 v2: no changes.

 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 5bef4128d175..57e0ef93b134 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -57,8 +57,11 @@ properties:
       - items:
           - enum:
               - brcm,bcm3384-switch
+              - brcm,bcm6318-switch
               - brcm,bcm6328-switch
+              - brcm,bcm6362-switch
               - brcm,bcm6368-switch
+              - brcm,bcm63268-switch
           - const: brcm,bcm63xx-switch
 
 required:
-- 
2.30.2

