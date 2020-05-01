Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081141C1FE1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEAVpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAVpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:45:06 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2E4C08E859
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 14:45:06 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ep1so5431149qvb.0
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmchGPRatpHGz7FXodcq0SJqPYC5mC9nnx68TlaFw4w=;
        b=xwWgPvauD6ppamEvtNf9ufZFJSbi1n2KGMzoE1syqLec3fCNoSjft7GT/6N59WPd0O
         M7sPxOR6NTHeuv6QCZb5HHY2UDi1TvOcGjKwZAwXjScQfnYjJ5OiXvgna3D02FM8arMH
         qqA/bxLsQ9/sPLat9/rX78cKaqJCwivNFeSOuIGysl7LilmEsX4rCD3XyIvEaU+B1Snd
         qEov4+C7hfmK5E5w10OSx56H87NYvnpUpC8ewjFFitGFVeIeegoXktpsyFmPMJ+SDzdd
         nrO90BisFqJX2sH34XILdpb9qWapOLZ+0BOOKnRNzHY0Qk9f7PvedtPA6sKDfun4HRLX
         cyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmchGPRatpHGz7FXodcq0SJqPYC5mC9nnx68TlaFw4w=;
        b=ukbgsHooQiSlAtddGpYkXC5d3nW9CRb0Np+QX/FbR/Ls6ZHxGaMQED+zguDRu6b4qH
         zdUPuCnRDbW/5Ot+/N7Wrxd8VGoRc5IN9eNprgw5t9tSubvaVmJrUxNuQ6qq2Sg2lhmw
         luaCjf1CY+VQmy2p/XeNv75+OP/SiRGotB5yV+qm4/0A/uTH0z/F6xe8FZNHjqwVlwSi
         eBuf5W0nzQqFUoWtzHkE5rDBYK7nFuNIpQMW3an0CzkrC0TdSEGXtVV6UJAA3cfG+BgP
         05GjfB1Kyn/2gVSkeZg3TxhAofgpQ35+oN4EblYnHlyHcZiqE4LLZW/cr5sG/RRip1yo
         7gDQ==
X-Gm-Message-State: AGi0PubxZsUnd/zKqTN5rDb0Vl6R904BXG+HgH8tnG40ZBnp83yyDw0E
        fyWhey1bMjF6jTlbx9Dx8N+UxQ==
X-Google-Smtp-Source: APiQypIuAa6x+i0csPOWBkj82VsqurAxBOnw3UAt3938Ebx2ta9aLDycZjFVpTUNGLKa+OXLdVUAgQ==
X-Received: by 2002:a0c:e786:: with SMTP id x6mr6237094qvn.11.1588369505083;
        Fri, 01 May 2020 14:45:05 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l12sm3587374qke.89.2020.05.01.14.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 14:45:04 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: add IPA iommus property
Date:   Fri,  1 May 2020 16:45:00 -0500
Message-Id: <20200501214500.31433-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA accesses "IMEM" and main system memory through an SMMU, so
its DT node requires an iommus property to define range of stream IDs
it uses.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 140f15245654..7b749fc04c32 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -20,7 +20,10 @@ description:
   The GSI is an integral part of the IPA, but it is logically isolated
   and has a distinct interrupt and a separately-defined address space.
 
-  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.
+  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.  See
+  iommu/iommu.txt and iommu/arm,smmu.yaml for more information about SMMU
+  bindings.
+
 
   - |
     --------             ---------
@@ -54,6 +57,9 @@ properties:
       - const: ipa-shared
       - const: gsi
 
+  iommus:
+    maxItems: 1
+
   clocks:
     maxItems: 1
 
@@ -126,6 +132,7 @@ properties:
 
 required:
   - compatible
+  - iommus
   - reg
   - clocks
   - interrupts
@@ -164,6 +171,7 @@ examples:
                 modem-init;
                 modem-remoteproc = <&mss_pil>;
 
+                iommus = <&apps_smmu 0x720 0x3>;
                 reg = <0 0x1e40000 0 0x7000>,
                         <0 0x1e47000 0 0x2000>,
                         <0 0x1e04000 0 0x2c000>;
-- 
2.20.1

