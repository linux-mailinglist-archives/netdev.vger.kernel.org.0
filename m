Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081C75EFE9A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 22:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiI2UXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 16:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiI2UXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 16:23:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C86B1FE1AB;
        Thu, 29 Sep 2022 13:22:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e11-20020a17090a77cb00b00205edbfd646so7041108pjs.1;
        Thu, 29 Sep 2022 13:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=D9gG0sZPfTkmJ91PNo+4svdhTmp+avan+u/cTvZY0tg=;
        b=a50l6LkPDqz2FPz0AOPzPlDhqKgjZVPgCHqXEvP96YwgNrIPGWuNS6ahCw6GoXN11p
         0b6X1F6nQYS4g0eZHRTa44dX5tF9ThURYQVAKaOq/5SM1qUjBPhTZxtrh5x2I02bVikx
         CEyM9I4OFIij8ffu+3+IdaVhjnlJMwdCUh0dl3nfGQQklMt7TnERZrhzlRLpFGPCltNT
         6icUJupynLr5ajcrY91bnGsgvF7dzKvSnIBFCiOkR1FCOb09HJf7+5mDvvPWQpqDYnhI
         7o9KCL7BD51b3tphf/wEdEFm7IQBy9QNve5Qc/TL5T0THrD8ldO264j36nTFJP/bDW2f
         e+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=D9gG0sZPfTkmJ91PNo+4svdhTmp+avan+u/cTvZY0tg=;
        b=Bz/iLcuu/IBtlc9h3VjukNJ4o3wEkk+qJTbSQtZKCQIfqVNiJuF35VMqrvVHubGGzj
         Qkdjrw5wo04rdotXuWYDT1MftoNzamU3sA1bN8NAUH4+HWR+xzHGpC1J6naYQZmPz2Wx
         XYNTTmalC7vNg6aY2+ihESPaZCBl2DUVE+0NCP15MmkcL8ZGmKM9fD1BJUQH/c8jcZnT
         GF/NF1nxGV5Ht7McUMcp92WdNKVse81svOCCNTX3j+Xbq6nVF3lFVbjT2EK8ozGTxahd
         K2/E6gCR2VZv9e0FEz4bG3zQLQBVgxA5S5YGMi7Zzw0jt07mHcCYVv9mtA7/GLaJ9Oio
         10cw==
X-Gm-Message-State: ACrzQf1SS9Oi5PVO5kDLm5XUFFpscggsZdOlYzl2IgFX6dBNQv5DQKiT
        Q+fKnJ9MHhv+a7wNbvdLk7dYUDdO2DA=
X-Google-Smtp-Source: AMsMyM68E+mHuHQdO3e9uHdDuS3BwPcnVrFcDD/sc8VfYdZ4ADiQ3lSaCg8LYUWrxX/rBrnnpBdoEw==
X-Received: by 2002:a17:902:8e84:b0:178:57e4:805b with SMTP id bg4-20020a1709028e8400b0017857e4805bmr5121474plb.144.1664482978672;
        Thu, 29 Sep 2022 13:22:58 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:637c:7f23:f348:a9e6])
        by smtp.gmail.com with ESMTPSA id p15-20020a17090a680f00b002029e3d5cb8sm177082pjj.34.2022.09.29.13.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 13:22:58 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:22:55 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: nfc: marvell,nci: fix reset line polarity in
 examples
Message-ID: <YzX+nzJolxAKmt+z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset line is supposed to be "active low" (it even says so in the
description), but examples incorrectly show it as "active high"
(likely because original examples use 0 which is technically "active
high" but in practice often "don't care" if the driver is using legacy
gpio API, as this one does).

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
index a191a04e681c..308485a8ee6c 100644
--- a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
@@ -128,7 +128,7 @@ examples:
 
             i2c-int-rising;
 
-            reset-n-io = <&gpio3 19 GPIO_ACTIVE_HIGH>;
+            reset-n-io = <&gpio3 19 GPIO_ACTIVE_LOW>;
         };
     };
 
@@ -151,7 +151,7 @@ examples:
             interrupt-parent = <&gpio1>;
             interrupts = <17 IRQ_TYPE_EDGE_RISING>;
 
-            reset-n-io = <&gpio3 19 GPIO_ACTIVE_HIGH>;
+            reset-n-io = <&gpio3 19 GPIO_ACTIVE_LOW>;
         };
     };
 
@@ -162,7 +162,7 @@ examples:
         nfc {
             compatible = "marvell,nfc-uart";
 
-            reset-n-io = <&gpio3 16 GPIO_ACTIVE_HIGH>;
+            reset-n-io = <&gpio3 16 GPIO_ACTIVE_LOW>;
 
             hci-muxed;
             flow-control;
-- 
2.38.0.rc1.362.ged0d419d3c-goog


-- 
Dmitry
