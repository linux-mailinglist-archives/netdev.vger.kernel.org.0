Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79484A5DE3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbiBAOEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbiBAOES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:04:18 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E75C06173E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 06:04:18 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p63so20441580iod.11
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 06:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MLEfOvs0XYTBMi37IYE0nxh2vKRdvGYr4hL4oQxHa8M=;
        b=Xj2bWEPqf/2o6pjwC5MIf9Pl3NxXOWzz7BeXYgtgm6Hus2Yg3a3j6lvS6Mh3MLMWjl
         XZmowq6m0Cg4I3jz80YK4GAhyGfB0jX6GvuIgpX7SSW8WYS67i51CLR1n6D3j6I8GJqS
         V7c8maJhi0BoIbeuo0Hfequvnf3k/jSCe2xoP6YmCFlXoNIHYA7XIj5jopwozViiO6eA
         /53is8M4gdf+L0/2kcthNDduO/rRUO9wW0b6zMjoi6J6UWvxb675WqEg2VTrCz5HAr2H
         gIlzofTgo1XmStIAR0OHYFAeYFl/+B5WySuRTnNkh3X2g2zLOfEE6ZAJH0P+h0dvYd1m
         2L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MLEfOvs0XYTBMi37IYE0nxh2vKRdvGYr4hL4oQxHa8M=;
        b=he5MXTwTErrj54R/wlcFcEdiW+aWCSa6e3idYl9Efz3OjITphdbqJKRh2VaKO6E+ff
         8ahGDErySSudnQNKAcXodguJFjEmQO4vvhwf1AcKSbt8zMXVmmd+Z5lzictLfMP+Uc3E
         kqYsZ6r6NCOewa4FEZjGU6LbBRqm8pJDr65Js0CHvDJxkH4O13d0jPRieW7QT31B+CPE
         RRISkZ9M2DDhoRhYpsHHaNHY6tW6962XBqsy+LhgkBXp8dxRFxW9HKhfH5tlYEH9r3Gt
         nadbxJ55dmKpszaErxd2yr/aTDgfgElJ1gzxbkkgrHJGSl5GoFFU7c/JHO6fVDzirC4g
         kQeA==
X-Gm-Message-State: AOAM533hwl/5y0J6q9/KrNnp7kSVxkYkOcX+wFL3cRCPPJh5yZqfdisn
        xpWBvbuz6mdKIdMDKIcbQ1Vgpw==
X-Google-Smtp-Source: ABdhPJzhJCQkilBeE2UUjay3h4zAOk49+hyIXb1Kon58qZEntbRNmrkJBEYbHMuFuxnSqthW9Q+BeA==
X-Received: by 2002:a05:6602:2207:: with SMTP id n7mr13354260ion.89.1643724257507;
        Tue, 01 Feb 2022 06:04:17 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o7sm189267ilo.17.2022.02.01.06.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:04:16 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] dt-bindings: net: qcom,ipa: add optional qcom,qmp property
Date:   Tue,  1 Feb 2022 08:04:11 -0600
Message-Id: <20220201140412.467233-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201140412.467233-1-elder@linaro.org>
References: <20220201140412.467233-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some systems, the IPA driver must make a request to ensure that
its registers are retained across power collapse of the IPA hardware.
On such systems, we'll use the existence of the "qcom,qmp" property
as a signal that this request is required.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b86edf67ce626..58ecc62adfaae 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -107,6 +107,10 @@ properties:
           - const: imem
           - const: config
 
+  qcom,qmp:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the AOSS side-channel message RAM
+
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
@@ -222,6 +226,8 @@ examples:
                                      "imem",
                                      "config";
 
+                qcom,qmp = <&aoss_qmp>;
+
                 qcom,smem-states = <&ipa_smp2p_out 0>,
                                    <&ipa_smp2p_out 1>;
                 qcom,smem-state-names = "ipa-clock-enabled-valid",
-- 
2.32.0

