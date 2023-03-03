Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E8E6A8F59
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 03:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCCCmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 21:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjCCCmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 21:42:53 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F43210A
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 18:42:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f18so1874331lfa.3
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 18:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677811370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iDNEXw8teYXC1RePAZhjBh/dGMalMHP9Lg4fn2iWwxc=;
        b=dbiBVX/9NCg6BYhGh8+LSwc0ol2iHOSJAG4s5qAC8SSKGGXFnOadO4zhO2ClOZxR+T
         h57Xi6/m6alMV2KeoMcOwLJA60xhg5m6RjAK6+BoJZ4dx7z96UaS52+hN+DkPCwJQBJm
         RHNHTKlIH4lcldJhSyQYjwdaAHxB/ubgYt5BqbeBSM8sSAnaw20m5OcPsoiABIHqU/JK
         +fj74GC4nkL+uA3QG61opD2K90/6c6crSgwyJ9VnKZ1NguTDCU4irPdKTbOjJGFruvtB
         SsgVDZ5RTYAneDGzXiT4gt+sDQ9u9pf7mqs7XGld37ce1IvRjhktTGktDeKxdJF8dZSJ
         nE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677811370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDNEXw8teYXC1RePAZhjBh/dGMalMHP9Lg4fn2iWwxc=;
        b=n2OsNioGrIQEDj5jtNxMOXDTUtjwBKBW7KGdmcsbgFAbdt9SieV7MYNPDC52mxS9zq
         cnqQ5WIjFM35tU5fGln/fhJTjSDhFUMJjZnA7Q5kxb0VPFcXhjdymwoS21a+x4mFxcIL
         5yOxMUXbE5o4clFjD/J4EEEfwRL8PuVLPMiioJtMIUQ9S9wW9hzU03+NQR5h+dhN+COT
         7EUJAHn+PnmuqVgBk+MPuLlYKoD+SyTWlZYN8pWo7PlAyO1iVPI8AqEy9uGeNphq8D7A
         TRg84y/rFyM0Xk3rnxeW30pSVRWiW4jt29HAtPbOzFUmQFSwJ/czpTR+C0l/31ACRxjK
         SV/A==
X-Gm-Message-State: AO0yUKUUbE1AKSyAGptSpLXXcgkBB/rSr+q78uJ14VDVbWGsiszkacmi
        +u13i91fIby+RTtNBAmNk9vTOeCHEdfrPLFH
X-Google-Smtp-Source: AK7set/6zMdHJiXD7PXCcw4098kJJxCA5Cq9XHtnY3BVqas1Stg1PK/SfGNLLtpNEMiO4rTo9aUbOw==
X-Received: by 2002:ac2:548d:0:b0:4e0:ff8e:bbfc with SMTP id t13-20020ac2548d000000b004e0ff8ebbfcmr98941lfk.31.1677811369885;
        Thu, 02 Mar 2023 18:42:49 -0800 (PST)
Received: from localhost.localdomain (abym99.neoplus.adsl.tpnet.pl. [83.9.32.99])
        by smtp.gmail.com with ESMTPSA id x19-20020a19f613000000b004db1cd5efcesm181379lfe.241.2023.03.02.18.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 18:42:49 -0800 (PST)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
To:     linux-arm-msm@vger.kernel.org, andersson@kernel.org,
        agross@kernel.org
Cc:     marijn.suijten@somainline.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: ath10k: Add vdd-smps supply
Date:   Fri,  3 Mar 2023 03:42:45 +0100
Message-Id: <20230303024246.2175382-1-konrad.dybcio@linaro.org>
X-Mailer: git-send-email 2.39.2
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

Mention the newly added vdd-smps supply.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index b61c2d5a0ff7..8697e63aeffa 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -66,7 +66,7 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa", "vdd-3.3-ch0",
-			   and "vdd-3.3-ch1".
+			   "vdd-3.3-ch1" and "vdd-smps".
 - memory-region:
 	Usage: optional
 	Value type: <phandle>
-- 
2.39.2

