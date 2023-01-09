Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FBB662D19
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbjAIRpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbjAIRpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:45:34 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D43591B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:33 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m7so8997327wrn.10
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=48ftCATxHgOiOe6xbKGx2ZiY6n3+BUStS7/be/RWXjo=;
        b=uIyVlkZMW/HK5vBfVUvOkqrToPfP556HNThca4pQQfYpADbQsZh5bnOZnXrlQfuh/x
         OJTgZXPMIBFwIfeEC5Ekj8YBKMs5TNSSH+vlvtRMzYbi3ZiyT7ik8GFNE/Q02NRjJJ80
         oUhRleC0eXkskPsDGH4RiF43IlSg8LaEJfGCM8orW5aCQvFkjxGmSC2OpKBNJ+/LAbcb
         nWe8Yj304C1lxFOJrm4q+sRmQjgXnQ6ocZBohOnptfyNLB0MEOoaa5gyTd8A2NmJCuPA
         Wa7Ix6RAJXjybmvcDRC0hM1dcXhlF7c6AdvnlRAXYCY4Enr8AoxyphhTL46nl07TPwbU
         kpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=48ftCATxHgOiOe6xbKGx2ZiY6n3+BUStS7/be/RWXjo=;
        b=DvW6PPr2cewr1oZE3ZxVOiGcMoOktaNIRVRAyNF6FPKFTUyOjUKMzc7G4tYSlqOK4b
         rNztuhISW0TyEZIeoxrWPKS67vzkRfEQib3V3ZfKkmq6b7rxVOGffmlY33LtO+czPdzK
         E819QChDR6E1UAENqwEp+g+uYPohFJArUVyLfNP75Bx1yPMNj8bSztOURAFM5+CpxFOx
         621Ng2V/dikp0rlDyUY6RoPxqFvcAiomFhISnEAbLPu6LvpqPPwqIfVqvPzCJYxlKYxP
         2fWcheGn0XwJLmg0YyYVyqbfQTKPU9MqVT7BnvKoftBudpZqT2x10bsRgYK3o4liH0Iu
         ZHDg==
X-Gm-Message-State: AFqh2krnGxkDlH8zitG/pw0i/9IL7TZwWAwu4Z1cFwEGkFvER5ixCtPy
        rneMUGhKLTMUHmYyX7oJR9SbVQ==
X-Google-Smtp-Source: AMrXdXu9JkiYxSufEml13EpQTB0wBLF4UHrsBsfZhlYDworiPjQZ/MQb2g6EnCJfiC/KysHLez8NFg==
X-Received: by 2002:a05:6000:1e1a:b0:290:968:f1ac with SMTP id bj26-20020a0560001e1a00b002900968f1acmr25786641wrb.33.1673286332425;
        Mon, 09 Jan 2023 09:45:32 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:32 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Date:   Mon,  9 Jan 2023 18:44:53 +0100
Message-Id: <20230109174511.1740856-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

This adds basic support for the Qualcomm sa8775p platform and its reference
board: sa8775p-ride. The dtsi contains basic SoC description required for
a simple boot-to-shell. The dts enables boot-to-shell with UART on the
sa8775p-ride board. There are three new drivers required to boot the board:
pinctrl, interconnect and GCC clock. Other patches contain various tweaks
to existing code. More support is coming up.

Bartosz Golaszewski (15):
  dt-bindings: clock: sa8775p: add bindings for Qualcomm gcc-sa8775p
  arm64: defconfig: enable the clock driver for Qualcomm SA8775P
    platforms
  dt-bindings: clock: qcom-rpmhcc: document the clock for sa8775p
  clk: qcom: rpmh: add clocks for sa8775p
  dt-bindings: interconnect: qcom: document the interconnects for
    sa8775p
  arm64: defconfig: enable the interconnect driver for Qualcomm SA8775P
  dt-bindings: pinctrl: sa8775p: add bindings for qcom,sa8775p-tlmm
  arm64: defconfig: enable the pinctrl driver for Qualcomm SA8775P
    platforms
  dt-bindings: mailbox: qcom-ipcc: document the sa8775p platform
  dt-bindings: power: qcom,rpmpd: document sa8775p
  soc: qcom: rmphpd: add power domains for sa8775p
  dt-bindings: arm-smmu: document the smmu on Qualcomm SA8775P
  iommu: arm-smmu: qcom: add support for sa8775p
  dt-bindings: arm: qcom: document the sa8775p reference board
  arm64: dts: qcom: add initial support for qcom sa8775p-ride

Shazad Hussain (2):
  clk: qcom: add the GCC driver for sa8775p
  interconnect: qcom: add a driver for sa8775p

Yadu MG (1):
  pinctrl: qcom: sa8775p: add the pinctrl driver for the sa8775p
    platform

 .../devicetree/bindings/arm/qcom.yaml         |    5 +
 .../bindings/clock/qcom,gcc-sa8775p.yaml      |   77 +
 .../bindings/clock/qcom,rpmhcc.yaml           |    1 +
 .../bindings/interconnect/qcom,rpmh.yaml      |   14 +
 .../devicetree/bindings/iommu/arm,smmu.yaml   |    1 +
 .../bindings/mailbox/qcom-ipcc.yaml           |    1 +
 .../bindings/pinctrl/qcom,sa8775p-tlmm.yaml   |  142 +
 .../devicetree/bindings/power/qcom,rpmpd.yaml |    1 +
 arch/arm64/boot/dts/qcom/Makefile             |    1 +
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts     |   39 +
 arch/arm64/boot/dts/qcom/sa8775p.dtsi         |  841 +++
 arch/arm64/configs/defconfig                  |    3 +
 drivers/clk/qcom/Kconfig                      |    9 +
 drivers/clk/qcom/Makefile                     |    1 +
 drivers/clk/qcom/clk-rpmh.c                   |   17 +
 drivers/clk/qcom/gcc-sa8775p.c                | 4806 +++++++++++++++++
 drivers/interconnect/qcom/Kconfig             |    9 +
 drivers/interconnect/qcom/Makefile            |    2 +
 drivers/interconnect/qcom/sa8775p.c           | 2542 +++++++++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c    |    1 +
 drivers/pinctrl/qcom/Kconfig                  |    9 +
 drivers/pinctrl/qcom/Makefile                 |    1 +
 drivers/pinctrl/qcom/pinctrl-sa8775p.c        | 1649 ++++++
 drivers/soc/qcom/rpmhpd.c                     |   34 +
 include/dt-bindings/clock/qcom,gcc-sa8775p.h  |  320 ++
 .../dt-bindings/interconnect/qcom,sa8775p.h   |  231 +
 include/dt-bindings/power/qcom-rpmpd.h        |   19 +
 27 files changed, 10776 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc-sa8775p.yaml
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
 create mode 100644 arch/arm64/boot/dts/qcom/sa8775p-ride.dts
 create mode 100644 arch/arm64/boot/dts/qcom/sa8775p.dtsi
 create mode 100644 drivers/clk/qcom/gcc-sa8775p.c
 create mode 100644 drivers/interconnect/qcom/sa8775p.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sa8775p.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-sa8775p.h
 create mode 100644 include/dt-bindings/interconnect/qcom,sa8775p.h

-- 
2.37.2

