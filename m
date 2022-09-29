Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287CB5EED89
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiI2GFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiI2GFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:05:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEE210FD4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:05:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v4so550114pgi.10
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=HooJ4kDdd+nfW0+c6w2JS1sLHMZcAjvPxacv4NnqElw=;
        b=XLfgz8R0QgXxKIwTdqCc5/W6+dRlPrE+0sfoxAJyJlw7bJFVK5CeuOGX6TPAnsvTDk
         0udBR5kitB6ljQhDK9Rc3uA/NJ5vmtFxXdlvvsDT2rLuEPzixW7kDK3sAP7ok5uWWImg
         ruU2+2ElC2x7z3Cbb3cZF7oIHLRzgI9lFj81maV6IclSnhDri9pNemXYFpk+068pPiGU
         3K8Lk7rBcM5gxXPgXygFbP/PbGlAGbzZJOyZNJ5gZ2NbLMC5uTxLOyaHg5ffyjqlpgLR
         rrTG09lwqGjFdb646tgW0CaIa0Rdt52gJUlduGM8J984BnsytY830b3GnfGVhPVpujCG
         E80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HooJ4kDdd+nfW0+c6w2JS1sLHMZcAjvPxacv4NnqElw=;
        b=Af/Y1O7p/MDMVP1LIC+o5STWDh4kUmOj7vyeTbKKXypAH1ihRYJvxA7SX1Eww3We4d
         VfnPn/JihqC9Gf0XAaW4c+EdhYLDljEIjWuoIfIprsr88jYxXsCX4m1I5ZRFrBsdD6vy
         MjyMWmeNj99BsdWFc+UGC/YF0I8Q5aoQ+gvSE2ijkv+WWxwbgtH0gYTl59zAOcddqtES
         DbVXQJEFp2Hnrlwh7441M01qX5uj9/azZv+klIKImdXzz8YIlS6kzXHVQ7O5p0N0hdoA
         e1NMSQ9Qu4Rc0eo7k1fTLU4M5YmWr5HfDJw1e6XCoHyrEB3NI5qFJDjh2iB4NKYJXMYp
         ewUA==
X-Gm-Message-State: ACrzQf1MYQujWqyCWTwe3epCaT4OmlAeDxwBlUSAComKBiEozUXKz35+
        yfikLigFloWVaLard/D5Bi20Pg==
X-Google-Smtp-Source: AMsMyM6KHxFl66z9CrxC/L6MnzvH0M1CK+EsJtzkw4wGjJaNH1EKqbGOucUm+HKEayh0wE8+07WPaA==
X-Received: by 2002:a05:6a00:a29:b0:54e:6aed:c655 with SMTP id p41-20020a056a000a2900b0054e6aedc655mr1730017pfh.25.1664431504883;
        Wed, 28 Sep 2022 23:05:04 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7])
        by smtp.gmail.com with ESMTPSA id i1-20020aa796e1000000b00540c3b6f32fsm5037681pfq.49.2022.09.28.23.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 23:05:04 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH v2 4/4] MAINTAINERS: Point to the yaml version of 'qcom,ethqos' dt-bindings
Date:   Thu, 29 Sep 2022 11:34:05 +0530
Message-Id: <20220929060405.2445745-5-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the MAINTAINERS file to point to the yaml version of
'qcom,ethqos' dt-bindings.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f7082a08ac4..b9860fd758c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17011,7 +17011,7 @@ M:	Vinod Koul <vkoul@kernel.org>
 R:	Bhupesh Sharma <bhupesh.sharma@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/qcom,ethqos.txt
+F:	Documentation/devicetree/bindings/net/qcom,ethqos.yaml
 F:	drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
 
 QUALCOMM FASTRPC DRIVER
-- 
2.37.1

