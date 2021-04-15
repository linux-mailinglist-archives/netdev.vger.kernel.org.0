Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D7B360780
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 12:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhDOKsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 06:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhDOKsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 06:48:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FD0C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so14157990pji.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZDSWVTMlAMb2GC5FLf9Wr+xeqh7iVHbgBuOpIuXmgM=;
        b=NampagNzPrn6NSKjQijinEcRmJ+6VjtD0femYHPPlCRPWwAi9YpHUbts3GmziV4e0T
         ev9UQcH5gJuTNiSr5NBZ30+KHwlpPiDC07hJEVMggSrBLQrsGtFFfTwNlQFV4//lUt5E
         p3BjI3Bu+4wQJCHxmo//e1BuYYPt60Bca+AOl9vDgS0DiEM3NIsp69qiIQVvs8BXFUr4
         MhFALAr4S4P2YUECtsnJlquCNt2uNVchZjD3AYJeeEuCQEdKyeXqY7E1KwI3AH4M4++3
         juOky+zdxOjVkSYGXNpSueM0ZY8hS+KqqVWxB24ZxKqvVPOz39WdnDJrGsdni8LSToGI
         eHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZDSWVTMlAMb2GC5FLf9Wr+xeqh7iVHbgBuOpIuXmgM=;
        b=NxMwg8zbOGLtMV9pL0Mw3E6Xgje9sa3p8Xf+3xCLadBatA5J9SeAX2ljrMfUdx3RrO
         /D3pUSFy+KiCMwNMwcxVOWJgWebv2BrCANR9bF2Kxmq37RlrCJqTMkIv01GFoT67PWF+
         e/HFtxFC+vRbqd7vdYBEfwvU9Q4v56iITNJhw4lm7ntNl7mUHHA3gUBpm5+0Kb54F/Rd
         qKRbaopxThGzmdOAx/mPwxcCPEdlosRq1KItL5vi4wIUeZHziYlRnFOjnEwoB2j2EEbq
         bktEBiBufkQGfw1AlfSesua4F+Spe18XplbfpOJxYoztTNvdzc8yB2B+0xKyvnLZMS+r
         Xskw==
X-Gm-Message-State: AOAM533zKe9dtuUrbksDrWP4YWjK01dOS6k1D6xgq5/Fi971+FIYfCHO
        tRMRwQ+yUhFOsuS8lDLpuHlW1Q==
X-Google-Smtp-Source: ABdhPJy+pmq8JLU/ek1cCoTJ2vGhGprFa2FPymMVG3bBW9n0OHjDvrYzdFm67XV/33rUpYEEszwGew==
X-Received: by 2002:a17:90b:1d88:: with SMTP id pf8mr3178517pjb.114.1618483662489;
        Thu, 15 Apr 2021 03:47:42 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id f65sm2130672pgc.19.2021.04.15.03.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 03:47:41 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 1/2] dt-bindings: bcm4329-fmac: add optional brcm,ccode-map
Date:   Thu, 15 Apr 2021 18:47:27 +0800
Message-Id: <20210415104728.8471-2-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210415104728.8471-1-shawn.guo@linaro.org>
References: <20210415104728.8471-1-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional brcm,ccode-map property to support translation from ISO3166
country code to brcmfmac firmware country code and revision.

The country revision is needed because the RF parameters that provide
regulatory compliance are tweaked per platform/customer.  So depending
on the RF path tight to the chip, certain country revision needs to be
specified.  As such they could be seen as device specific calibration
data which is a good fit into device tree.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml          | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index b5fcc73ce6be..c11f23b20c4c 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -68,6 +68,13 @@ properties:
     description: A GPIO line connected to the WL_RST line, if present
       this shall be flagged as active low.
 
+  brcm,ccode-map:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    description: Multiple strings for translating ISO3166 country code to
+      brcmfmac firmware country code and revision.
+    items:
+      pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
+
 required:
   - compatible
   - reg
@@ -97,5 +104,6 @@ examples:
         interrupts = <24 IRQ_TYPE_EDGE_FALLING>;
         interrupt-names = "host-wake";
         reset-gpios = <&gpio 23 GPIO_ACTIVE_LOW>;
+        brcm,ccode-map = "JP-JP-78", "US-Q2-86";
       };
     };
-- 
2.17.1

