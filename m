Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAC062B3F0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiKPHdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiKPHdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:33:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E00B2EF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:02 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a14so28465959wru.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gVVk4rPqVJ+nI9+Wk7suoLY9Sdv75O8vEmrQasB0XMM=;
        b=ezU1MOhuwcskDPEe2bAhdvR+saE8yzF7v50He6N3NYDA1e9oyfiK0xPq/mtJzqf6zo
         hV3LIOzYgJ+2LZlLEk3wlsgHkCYlPabAM7ejHya7guA8ZshDLICtfFxKM4yrLtRZq4uD
         j38fLLpxY20S+xJ3DHEGn1kCYmVZWlu0QPjNEyxYCQ4ecRCiwQLryn153Ovy0t6Y0Ig0
         uQ28ddCIkeDEAWhkqWiSezzs98gD2fGopOKA+jM++ODFnhHLL9W3XnWOtF6pGZC3Qo9f
         danLss66FfMq0m2B3K+UzXK8FxXcU64qZhuwzodNH2l7NTEaJ8FPhTEOeyfNRUe5mG5G
         427w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVVk4rPqVJ+nI9+Wk7suoLY9Sdv75O8vEmrQasB0XMM=;
        b=KZXhNgxisIZDemjRbGARVEjtKCrMrX0H33aX/vbPW2Zr9PC034rReL770KQMO3OrWr
         BXtuMFfTJRtrFc06FDSgbChfSuVFpG8m5m1/ZNa36WwajOT+QQjCGP2UOd7Y0ZPkoNJU
         irkVSOr62krh9Ka/xbJdSiWzP2OBptjgido3cJPkJ7YKKujxsE7We2Og6YEIz6NImpDB
         yXhD/YY5scOpiJ9lh/G/XEpaeTx2oz7QERX7EPz2zSH+kf+P266+h4i6DyO/xZQACWgo
         0x9diePCgliygYUr9zfdp/E492wfBLqnxiIM9+3noSgxslyDtSJtoh3a8jHOiOSQxlNP
         Yq2w==
X-Gm-Message-State: ANoB5pkHfD7ntUsPqorBF99JfWk8IKomj6ZOYSULksmlOJjeOOSErzLq
        qcKUfRw0JEOF6dvA+PGqSgJbPw==
X-Google-Smtp-Source: AA0mqf5x3z6lTJoUgZpWStT49LW4IwwLma+kYAXJ24eaiJV/S+x5T+thpkd8IXxjYf33veA4Ud8BIQ==
X-Received: by 2002:a05:6000:24f:b0:232:eb2:6a33 with SMTP id m15-20020a056000024f00b002320eb26a33mr13198010wrz.325.1668583981057;
        Tue, 15 Nov 2022 23:33:01 -0800 (PST)
Received: from zoltan.localdomain ([167.98.215.174])
        by smtp.gmail.com with ESMTPSA id g34-20020a05600c4ca200b003cfd4e6400csm1058823wmp.19.2022.11.15.23.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 23:32:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/5] net: ipa: change GSI firmware load specification
Date:   Wed, 16 Nov 2022 01:32:51 -0600
Message-Id: <20221116073257.34010-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Version 3 just adds reviewed-by tags for Krzysztof Kozlowski.

Version 2 of this series modifies the first patch only.  One section
in the description is reworded, and the example now consistenly
describes the SC7180 SoC, both as suggested by Krzysztof.

Currently, GSI firmware must be loaded for IPA before it can be
used--either by the modem, or by the AP.  New hardware supports a
third option, with the bootloader taking responsibility for loading
GSI firmware.  In that case, neither the AP nor the modem needs to
do that.

The first patch in this series deprecates the "modem-init" Device
Tree property in the IPA binding, using a new "qcom,gsi-loader"
property instead.  The second and third implement logic in the code
to support either the "old" or the "new" way of specifying how GSI
firmware is loaded.

The last two patches implement a new value for the "qcom,gsi-loader"
property.  If the value is "skip", neither the AP nor modem needs to
load the GSI firmware.  The first of these patches implements the
change in the IPA binding; the second implements it in the code.

					-Alex

Alex Elder (5):
  dt-bindings: net: qcom,ipa: deprecate modem-init
  net: ipa: encapsulate decision about firmware load
  net: ipa: introduce "qcom,gsi-loader" property
  dt-bindings: net: qcom,ipa: support skipping GSI firmware load
  net: ipa: permit GSI firmware loading to be skipped

 .../devicetree/bindings/net/qcom,ipa.yaml     | 78 +++++++++++----
 drivers/net/ipa/ipa_main.c                    | 95 +++++++++++++++----
 2 files changed, 135 insertions(+), 38 deletions(-)

-- 
2.34.1

