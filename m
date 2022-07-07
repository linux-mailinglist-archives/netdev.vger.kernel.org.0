Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A461569C14
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiGGHs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiGGHsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:24 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82125326FB;
        Thu,  7 Jul 2022 00:48:21 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id bi22-20020a05600c3d9600b003a04de22ab6so10228914wmb.1;
        Thu, 07 Jul 2022 00:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DHlqTFfBmwKmCk2ZbxLB23OQys0+sxL93SDYeC5xPbE=;
        b=hCZQp4+EB/upjBt44wtAfp/QH7vyw2GmFGgVm+9y9uNaDctka7LU1eFDR9jBn56iDp
         bux3ISM90LWwF7xFZgQXu5BWn4wkGokkaQIh1yk/DDy/dFhTgswkyhJdRNRs6lKFOfEp
         yKNMgqi9L4Wr/je75ZnQZOdq2Q7Xk8DFA7YK2IfMJMnBoOYtYkcapVjiWKXKB2wQ4uZ2
         OKtwlbBqDOF9+KOOBCi3Rot2d6MSKuSaXQ+vUP0z51kV0jI5vwYRjLOyAinulcdNwgsF
         +2eqiorkUpx6Yj0D/bnvT+QikvWDxGbILDmd6nbC0B7dIddLKqSLzUYDFehmFIZCeKWV
         7lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DHlqTFfBmwKmCk2ZbxLB23OQys0+sxL93SDYeC5xPbE=;
        b=N12M8KhoCHV95m2yhxVLu9c83HPBuf7mILgAzbEqi/MKZsT6qM4o5ztDFkTws4b2+0
         R2eJu7Cu1Akv/V5bY94zt5+r2ddXQhtgYDOpyKgwlLRM7xzuamXg/hJQlqDfz9iwqyIx
         VJi5DYrsCOO5e7+5S0EKROQvI8kgPAmOf1RdNXOsx8MG5g1tD8IgcgoAtkiSk/oTp/p9
         dUjebq8ORfqgzOEDw7pVZ50mGmQVlT5mlTCmRNA8xSWccREjrcXiAwVDfhiVuVwFI4hT
         RyuM9+xdzMcw2I33769X+qPLShIOz/Tq6y41zjI7cH4/IMXaNlyi2hxDaH1+zzvbVUgN
         lVLQ==
X-Gm-Message-State: AJIora9mSlghk4tklKavkNRkPtlkv/MHuYDMTpcsDAKQc8bf6PJ1FqUz
        EoFL2kehI1vgwK/y9GyfH0s=
X-Google-Smtp-Source: AGRyM1tvrdfRxK5Tczp267q4ABTQ28COkriB37z2fHu5E+xPpKRgSvz29jQiUs3n2M1B4Nib79VWEw==
X-Received: by 2002:a05:600c:3593:b0:3a1:8909:b5b2 with SMTP id p19-20020a05600c359300b003a18909b5b2mr2917280wmq.77.1657180099958;
        Thu, 07 Jul 2022 00:48:19 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id k23-20020a7bc317000000b003976fbfbf00sm29048940wmj.30.2022.07.07.00.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:19 -0700 (PDT)
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
Subject: [PATCH v4 0/9] tegra: Add support for MGBE controller
Date:   Thu,  7 Jul 2022 09:48:09 +0200
Message-Id: <20220707074818.1481776-1-thierry.reding@gmail.com>
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

In addition to patches 1-4 I plan to apply patches 5-8 to the Tegra tree
as well once the DT bindings have been reviewed and finalized. Patch 9
can go through the net-next tree independently since there are no
dependencies.

I've rebased this onto v5.19-rc1 rather than linux-next so that the bots
will hopefully have an easier time applying this. The series still
applies fine to linux-next (except for a minor conflict in patch 4 which
I can resolve in the Tegra tree), so patch 9 should apply fine on
net-next as well.

Changes in v4:
- address review comments from Krzysztof, see patch 5 for details

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

 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 162 ++++++++++
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
 12 files changed, 827 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

-- 
2.36.1

