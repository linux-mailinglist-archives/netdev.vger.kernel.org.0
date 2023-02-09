Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FE3690395
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjBIJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBIJZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:25:32 -0500
Received: from mr85p00im-ztdg06011201.me.com (mr85p00im-ztdg06011201.me.com [17.58.23.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52986186C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934270; bh=7pXasyRfKVF9IUAegxYhrYLSu6imwBLW9zNCQeKHD28=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=gQAkvJMpUts7a8vDkqQd8GpQeoy7dmn5CdJoIVWcMt2TI05q7hZtVu7ymLgwmxtPW
         jYrQFag7YJqsQna1g/p3iooJtr6pIu9D+CFDfBPNJXscL12udNk6LMru2QFpGyaTyB
         OanYyBAZ//EDDKLCQD23RWvAPalvEdZuiu0q+SIgSG9blEkG85+9vQjn9glf8aFVCD
         7d4uXJyZe8rGsZNMz2KWBKkIIYmcTSm3MYTmK8yRrsHhwhhb58rXPelT3/mb08wHh5
         4KanEtSETSy7fxWuJTtssk2AecLCWWGR24r1yl8P/wTWE10lPUIe8bWX5+WN+eCboR
         xwIJb9qWOYBbA==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06011201.me.com (Postfix) with ESMTPSA id B9FD79622C0;
        Thu,  9 Feb 2023 09:17:49 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 00/11] ARM: removal of STiH415/STiH416 remainings bits
Date:   Thu,  9 Feb 2023 10:16:48 +0100
Message-Id: <20230209091659.1409-1-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: C2vTVmPR7z1gInH5yviJ2h-bYafnNbiR
X-Proofpoint-GUID: C2vTVmPR7z1gInH5yviJ2h-bYafnNbiR
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302090088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of code in order to support STiH415 and STiH416 have already
been removed from the kernel in 2016, however few bits are still
remainings.
This serie removes the last pieces of support for STiH415, STiH416
and STiD127.

Alain Volmat (11):
  Documentation: arm: remove stih415/stih416 related entries
  ARM: sti: removal of stih415/stih416 related entries
  irqchip/st: remove stih415/stih416 and stid127 platforms support
  dt-bindings: irqchip: sti: remove stih415/stih416 and stid127
  dt-bindings: arm: sti: remove bindings for stih415 and stih416
  thermal/drivers/st: remove syscfg based driver
  net: ethernet: stmmac: dwmac-sti: remove stih415/stih416/stid127
  dt-bindings: net: dwmac: sti: remove stih415/sti416/stid127
  dt-bindings: reset: remove stih415/stih416 reset bindings
  dt-bindings: clock: remove stih416 bindings
  ARM: debug: removal of STiH415/STiH416 related debug uart

 Documentation/arm/index.rst                   |   2 -
 Documentation/arm/sti/overview.rst            |  10 +-
 Documentation/arm/sti/stih415-overview.rst    |  14 --
 Documentation/arm/sti/stih416-overview.rst    |  13 --
 .../devicetree/bindings/arm/sti.yaml          |   2 -
 .../st,sti-irq-syscfg.txt                     |   9 +-
 .../devicetree/bindings/net/sti-dwmac.txt     |   3 +-
 arch/arm/Kconfig.debug                        |  28 ---
 arch/arm/mach-sti/Kconfig                     |  20 +-
 arch/arm/mach-sti/board-dt.c                  |   2 -
 drivers/irqchip/irq-st.c                      |  15 --
 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   |  60 +-----
 drivers/thermal/st/Kconfig                    |   4 -
 drivers/thermal/st/Makefile                   |   1 -
 drivers/thermal/st/st_thermal_syscfg.c        | 174 ------------------
 include/dt-bindings/clock/stih416-clks.h      |  17 --
 include/dt-bindings/reset/stih415-resets.h    |  28 ---
 include/dt-bindings/reset/stih416-resets.h    |  52 ------
 18 files changed, 8 insertions(+), 446 deletions(-)
 delete mode 100644 Documentation/arm/sti/stih415-overview.rst
 delete mode 100644 Documentation/arm/sti/stih416-overview.rst
 delete mode 100644 drivers/thermal/st/st_thermal_syscfg.c
 delete mode 100644 include/dt-bindings/clock/stih416-clks.h
 delete mode 100644 include/dt-bindings/reset/stih415-resets.h
 delete mode 100644 include/dt-bindings/reset/stih416-resets.h

-- 
2.34.1

