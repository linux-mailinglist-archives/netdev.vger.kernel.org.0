Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2100833375E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCJIeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:34:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40996 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhCJIdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:33:33 -0500
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lJuHb-0003GO-C1
        for netdev@vger.kernel.org; Wed, 10 Mar 2021 08:33:31 +0000
Received: by mail-wm1-f72.google.com with SMTP id s192so2336527wme.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZxvgYZhRwx3vtBKrExOY7yB1Rao/D3y6ddDmt53T8k=;
        b=JtvCmRFd2GDR4/RiC+ZMgQx9rwz5gg0u46J7oARKozSVhHAKZVwEdgaQp+2ri6Tc98
         alizSqA/FKEMZmNUibCelXWD2AXmiRmPXVuba2cP2Zs1WY1a+sYlC9kjEds8M6W6mA1v
         Ls+1vVLfVm2nJbRXDbwrhZjN15FiW6/Zuo996Y4P2K/glvbhq/1+x8zFRjAbwyjndFZN
         njZEu589PZvvhvnrSopBkRkjwmVxEAx3qwrDiIVAg7CeGxguOzd5XoY8vNA6CwKmyOkY
         4+iGUWYtSADE3P7uYrFYp9T1rieoGMWO7DpPPNpWQhF2juJD0aGn0AE1RTf2al0oiNQO
         Hauw==
X-Gm-Message-State: AOAM530pd1hhYI6jTEceOVicnLUNHowfXLHGKlkxJVk18iBvaIA93+ZV
        Hn6cmso2Lk7dqWl7o8waPbIoUWDx+Knte2b+9g3IeW8JgDQugw7unsIbiHFgX+s7Uq4pRE4Uc0d
        1KHX+1vYLbj+F6VRNXB6w3i/u3q2ux6ZTlw==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr2225372wma.24.1615365211048;
        Wed, 10 Mar 2021 00:33:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+uPRMBgFfoVCHx5kur24yVECBMZDDtyDQfyluEn8gAohH3gku3X1wAI4MIWrYIO0FNDk1jQ==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr2225348wma.24.1615365210807;
        Wed, 10 Mar 2021 00:33:30 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id m17sm28675495wrx.92.2021.03.10.00.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:33:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        arm@kernel.org, soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [RFC v2 0/5] arm64 / clk: socfpga: simplifying, cleanups and compile testing
Date:   Wed, 10 Mar 2021 09:33:22 +0100
Message-Id: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

All three Intel arm64 SoCFPGA architectures (Agilex, N5X and Stratix 10)
are basically flavors/platforms of the same architecture.  At least from
the Linux point of view.  Up to a point that N5X and Agilex share DTSI.
Having three top-level architectures for the same one barely makes
sense and complicates driver selection.

Try to unify them.

Changes since v1:
=================
1. New patch 3/5: arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64
2. New patch 4/5: arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64
3. Fix build issue reported by kernel test robot (with ARCH_STRATIX10
   and COMPILE_TEST but without selecting some of the clocks).

I tested compile builds on few configurations, so I hope kbuild 0-day
will check more options (please give it few days on the lists).

Best regards,
Krzysztof


Krzysztof Kozlowski (5):
  clk: socfpga: allow building N5X clocks with ARCH_N5X
  clk: socfpga: build together Stratix 10, Agilex and N5X clock drivers
  arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64
  arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64
  clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks

 arch/arm64/Kconfig.platforms                | 17 ++++-------------
 arch/arm64/boot/dts/altera/Makefile         |  2 +-
 arch/arm64/boot/dts/intel/Makefile          |  6 +++---
 arch/arm64/configs/defconfig                |  3 +--
 drivers/clk/Kconfig                         |  1 +
 drivers/clk/Makefile                        |  4 +---
 drivers/clk/socfpga/Kconfig                 | 17 +++++++++++++++++
 drivers/clk/socfpga/Makefile                |  7 +++----
 drivers/edac/Kconfig                        |  2 +-
 drivers/edac/altera_edac.c                  | 10 +++++-----
 drivers/firmware/Kconfig                    |  2 +-
 drivers/fpga/Kconfig                        |  2 +-
 drivers/mfd/Kconfig                         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
 drivers/reset/Kconfig                       |  2 +-
 15 files changed, 43 insertions(+), 38 deletions(-)
 create mode 100644 drivers/clk/socfpga/Kconfig

-- 
2.25.1

