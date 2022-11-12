Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EAC626B67
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 21:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiKLUH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 15:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiKLUHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 15:07:25 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9957D1402F
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 12:07:22 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id d3so4040919ils.1
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 12:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OjxOPLzWayMM34TYDIOn4YJBIrr4/PeJ0axT2GqWnMo=;
        b=iA/nY8KLi3U1BcdOxgx9+y7xBKt32iOmQLRV4zxGlU3OYYgOR5m2cIQoE4QUBGeB+S
         gVWvFcaEdu5hCkJjMG40CiQa6YF/vUetF5fJO2qkkyjiY+ZHi4ZHS2sIkb4yk0BK42Zw
         3vQkR/HO5cFnZmwczrZdcU5nuK6sRu6/nz8M8sPAjQ+c/h3TdLvalPVKnvgcOte5TFvC
         ++4sRaEqt9NlecVe24kG4dVbMN+6zk+u97cPsE/0SPsxR9QjHx7o/Bao4ixnZwzcFweV
         yn1fKfOVudFsnlYHTNw/cuVC8V3GS3ZbLA6qV4MEhyX7cXhaZ6ro4afRTDLUBLzp7TQj
         Y9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjxOPLzWayMM34TYDIOn4YJBIrr4/PeJ0axT2GqWnMo=;
        b=paWOI9AUIQ+7mVk2+zrFWCEUfNK/68HMWlfvb1FMaf7Qu+hlxGHmzTu+JRUBSJXwyX
         dcYO5Q14pqsezaeEUZcn49+PyCAyCNT2tXawIXprCO1mhSa/JfBaIHkL2mv7ASxWJjaW
         refzYbX3JgAEPEp/aNaxhDDKbFWnBKiG05osMJGoPdbUXc4M83r0mqnT6J4FkYcj86Tq
         gFBC9IT3WmGYWhS9pFYpdua1kQvqULW8jsv5L0V/Z4ilY8FgQQNuBIVkSDtBNStcchv/
         0RQN6R5dPoQgtlFzD68SlNoTULVtXDEGnC7wSw5U4Kw1sVGsswh0Lyqp6Nh/D19XlJ71
         KbgA==
X-Gm-Message-State: ANoB5plIrSzQ0FigwnKnW35S9Kf5KLPMLVX36JSY3FNI4db9RmMYXq9K
        9HoRXSUt46G+Bxg9fq6Pfzk0Tg==
X-Google-Smtp-Source: AA0mqf5drpD8vXv0IYl+bsRyK3KVibZiYUaxs3V3jfCSnCrUqrdVqDjUDJv+4zodL7XSBnDO8Su2qA==
X-Received: by 2002:a92:d94f:0:b0:2fa:b811:ed3b with SMTP id l15-20020a92d94f000000b002fab811ed3bmr3542403ilq.288.1668283641934;
        Sat, 12 Nov 2022 12:07:21 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id j28-20020a02cb1c000000b00363dee286edsm2036870jap.60.2022.11.12.12.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 12:07:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: change GSI firmware load specification
Date:   Sat, 12 Nov 2022 14:07:12 -0600
Message-Id: <20221112200717.1533622-1-elder@linaro.org>
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

 .../devicetree/bindings/net/qcom,ipa.yaml     | 61 +++++++++---
 drivers/net/ipa/ipa_main.c                    | 95 +++++++++++++++----
 2 files changed, 126 insertions(+), 30 deletions(-)

-- 
2.34.1

