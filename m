Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C825624B13
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 20:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKJT4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 14:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiKJT43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 14:56:29 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DA9A1B4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:56:28 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id d3so1570735ils.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocUEjaXvalO2lDp0ra2nIWRh/qi3vcvKb/fRj0kfIXs=;
        b=iO0BMOiKTGpHVZQMg6F9oQUWAqh31KTlX5fuYl3NviTrB6Kei0Xho18Y7D4Be1OVbe
         +DgWY6VYuK3jIljAx6cdNWxzNdGRAA2TlrpRDGOrRG3W0AmtM8cbxxNshFQJbrfWOCVc
         3qWf/AA59DPimGQwSAXaf/sF4980VjIAEN1ZOf048/Bf+NVyFru/JoEFDxM8OaqReW7v
         bgOvGYgbgvRo4e9J2wD5VabDpZ9RbE46BQZ1D8jRtz8kpGG7pmxJ0PgdV4yIgEPbnpre
         6sz3Fx9QAWwJ355ZoLF9zcR0Cwv1tG675ND1A9WAGG+j7ABm/tReyAUHSHzyxGH/AB7G
         wJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocUEjaXvalO2lDp0ra2nIWRh/qi3vcvKb/fRj0kfIXs=;
        b=miUgakv7Tg1hmcqJ65uCGTNlcYRHCThmYCteYWSwmNp0XHHwrMnu7BJi1Cfx/MQ8Lt
         8Ezcg/oEP57L0yMN+XfRg0usP4s5ZF9EnuOtuEOzr1fu/js50HCsYi2zzXdEy+OZD5w8
         9HwlO+fsueEthwFeR8bn5KjVWThAifmyIccVUYnPW5WYuoqE21kFwk4z/D5zqpNcOlOd
         PMAY9nT2s2LpUybVEgDNWOyzYD0idivQ39Fz7THBXD6NdjHOV6tsPqiFc/SKA32HEjjU
         2RuoTcnHpfaJJHCbV6uDzNhArImTX0Y6NzfqgdLFq7XBa0T46dSK+8KfuFpldAfgwm8p
         9zfg==
X-Gm-Message-State: ACrzQf2jW6Ww+3Qx4Uyt94ZGPZlPe+S3p8M9buFQQaHbnw2OgeiMVWIa
        VRhJcZe6U77el6awItSk7nHhrQ==
X-Google-Smtp-Source: AMsMyM5O5C3ge1Cvx+Fe0k1+5IM0IsCZT5vUxMcvAKevaj85MR58vznJVKxrpJnWUoUD+lx0MAt7DQ==
X-Received: by 2002:a05:6e02:1a08:b0:2ff:dc4b:a4c0 with SMTP id s8-20020a056e021a0800b002ffdc4ba4c0mr3468201ild.221.1668110187502;
        Thu, 10 Nov 2022 11:56:27 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id l2-20020a6b3e02000000b006bbddd49984sm28602ioa.9.2022.11.10.11.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 11:56:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] dt-bindings: net: qcom,ipa: restate a requirement
Date:   Thu, 10 Nov 2022 13:56:18 -0600
Message-Id: <20221110195619.1276302-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110195619.1276302-1-elder@linaro.org>
References: <20221110195619.1276302-1-elder@linaro.org>
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

Either the AP or modem loads GSI firmware.  If the modem-init
property is present, the modem loads it.  Otherwise, the AP loads
it, and in that case the memory-region property must be defined.

Currently this requirement is expressed as one or the other of the
modem-init or the memory-region property being required.  But it's
harmless for the memory-region to be present if the modem is loading
firmware (it'll just be ignored).

Restate the requirement so that the memory-region property is
required only if modem-init is not present.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 2d253ef488188..e752b76192df0 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -155,12 +155,15 @@ required:
   - interconnects
   - qcom,smem-states
 
-# Either modem-init is present, or memory-region must be present.
-oneOf:
-  - required:
+# If modem-init is not present, the AP loads GSI firmware, and
+# memory-region must be specified
+if:
+  not:
+    required:
       - modem-init
-  - required:
-      - memory-region
+then:
+  required:
+    - memory-region
 
 additionalProperties: false
 
-- 
2.34.1

