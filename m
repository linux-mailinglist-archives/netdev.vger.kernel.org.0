Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474B8569469
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiGFVdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiGFVdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:03 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CBC27145;
        Wed,  6 Jul 2022 14:33:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a5so9065015wrx.12;
        Wed, 06 Jul 2022 14:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQeQaOxN0HB5D1bNCZjbAOQZZcj64PzWtyy+r30Dm8c=;
        b=WuFLcy1Hg4DsPSzvy+6YrFfBLxA5xaf3ppnoxfgbBEW6QbeL1kDYDQnTo5qcm1vB9Z
         O83SvNb6/uip9toZa0Zf3cA5pxYMwA7DZLDxUh2C4np1gKAqJKapKL6QBtVf/OhPLwbq
         GGRPF6ZuEq0Wwaco5O9LPOKJxp3FECQULxewqZHZyHUswvE9k0xR5uimb5LAtcP+8/eL
         1DqHPFnMgCGv4gbjGFIobM13dpiNSOQIin481ZznFcWmRGUHLEPLI4f/Dz4OWYRMEstd
         Qrlbx7QbrUL9Efs67PYUlHH4CBzHNBmnTysM6/nm+qLggFP56T+XVnuPo6C8HA9KCKV4
         m93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQeQaOxN0HB5D1bNCZjbAOQZZcj64PzWtyy+r30Dm8c=;
        b=MjBD5+Y2lDjtfbwXvnhBFNcRQ/N4RzgnPfqZDZME9lpExTA9tIWrA72dNr3VqKTrdE
         Dh57KDRWjTMMFVsj1lO56cXISuptb3AeW5OZ7/NFNESoWyXK0loZeXgnBk7HQN+SDSRP
         IPaAVrtlncsvo4KYjp3LRRunaKXwU+3OmChU2IQJJ1X769bc6cFREsz3mZyNMm9F6rfO
         hz49Shd5WXmVfFLz3dXxYP/IFmGMbGwaprGcea1ayI6MB5IWcGTT5IobzAarEk14hRET
         eVwE+nso03un6gz4y+v8iBA4/ZPglyFLPTthbUQbQlXl3FfIGwmTn4OnGdzm2BIPe4e8
         aybg==
X-Gm-Message-State: AJIora9tR4s8vKaJGNp1Qx/bikYbCJaaPaDdEpUuKaTXZQZ0wYHHY1Fe
        qb1reSQ+xe0v3FlANkgOkdg=
X-Google-Smtp-Source: AGRyM1tT2Ajo9DNZEZO6q5sT1Mzgz1311qX7qiOPP8scOSLsAMCDE3jaro3Vtkaz9IoRl1mgOD3c2A==
X-Received: by 2002:a05:6000:100f:b0:21d:779f:fa87 with SMTP id a15-20020a056000100f00b0021d779ffa87mr8308831wrx.291.1657143181298;
        Wed, 06 Jul 2022 14:33:01 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003a0375c4f73sm27237705wmq.44.2022.07.06.14.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:00 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 0/9] tegra: Add support for MGBE controller
Date:   Wed,  6 Jul 2022 23:32:46 +0200
Message-Id: <20220706213255.1473069-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Hi everyone,

This series adds support for the MGBE Ethernet controller that can be
found on Tegra234 SoCs.

Despite what I said earlier, I've decided to include patches 1-4 here
to make it a little easier for patchwork (and related tooling) to detect
this as a subsequent series. I do have those patches in the Tegra tree
already with the Acked-bys from Krzysztof, though, so no need to go
through those again.

Hopefully the DT bindings are all good now. I've run them through the
dt_binding_check target and verified that the DTS changes in this series
also validate correctly. I've left the interrupt-names property in and
added the additional (optional) macsec-ns and macsec interrupts to
illustrate why we need the "common" interrupt. Hopefully that now
clarifies things.

In addition to patches 1-4 I plan to apply patches 5-8 to the Tegra tree
as well once the DT bindings have been reviewed and finalized. Patch 9
can go through the net-next tree independently since there are no
dependencies.

Changes in v3:
- address remaining review comments on DT bindings

Changes in v2:
- address some review comments on DT bindings

Thierry

Bhadram Varka (3):
  dt-bindings: net: Add Tegra234 MGBE
  arm64: defconfig: Enable Tegra MGBE driver
  stmmac: tegra: Add MGBE support

Thierry Reding (6):
  dt-bindings: power: Add Tegra234 MGBE power domains
  dt-bindings: Add Tegra234 MGBE clocks and resets
  dt-bindings: memory: Add Tegra234 MGBE memory clients
  memory: tegra: Add MGBE memory clients for Tegra234
  arm64: tegra: Add MGBE nodes on Tegra234
  arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit

 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 169 ++++++++++
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts |  21 ++
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      | 136 ++++++++
 arch/arm64/configs/defconfig                  |   1 +
 drivers/memory/tegra/tegra234.c               |  80 +++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
 include/dt-bindings/clock/tegra234-clock.h    | 101 ++++++
 include/dt-bindings/memory/tegra234-mc.h      |  20 ++
 .../dt-bindings/power/tegra234-powergate.h    |   1 +
 include/dt-bindings/reset/tegra234-reset.h    |   8 +
 12 files changed, 834 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

-- 
2.36.1

