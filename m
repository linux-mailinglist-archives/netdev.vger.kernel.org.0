Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B53A2877D0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgJHPrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:47:02 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:52185 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbgJHPq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:46:59 -0400
Received: from localhost.localdomain ([192.30.34.233]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N4h7p-1kXaxO1g5H-011kDN; Thu, 08 Oct 2020 17:46:22 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] ARM, timers: ebsa110 cleanup
Date:   Thu,  8 Oct 2020 17:45:58 +0200
Message-Id: <20201008154601.1901004-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Q2x1rl9rLYWFu+fsbJHX+/nzZ/cPOL+HhOYXfylp131m845mcg2
 HxdRLNep1smt/9g5n1vlNPaEeT1A1gdmsLgRjByN2VXTS7IYMbpnRdgd4qGt1A99/IEnu3R
 PF/WHjQClHVsoC2nRCs2ZGbL9z4FsLcld/ExUPIp8T4NYRutqN9JGvMoD/AhWQkokE2vdkL
 URecNYCBqf5HbZYo1K4rA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3flL27H+/Ho=:oqIHZ21HZXstVyoN46lH5o
 czMGOrnkW0ANWHLEivNoTExKnShcowoezyQripj/ICprE7pEo10uRki2qS81bLLHRF+Y9GJ5c
 CyrTvvuD5/YJZD+UC8Wv72ZvDfd/9iD7qLd0MwywHNDvghsyYm4Apt8OwpJlkAjzyrEAzkrhk
 CkHG0L+/HUEN5Oe0btpza5XAf+w8et8oZXVpg488kyJy6WxSSZfeVOyGfdOCFmnBf/ciPjnv3
 DRVpN1VL2227bPPJuxMlYCSoV1FW2k8HCV0Xn/fRGaB/Pm9jPcwMS5aQ+KuGV6FUm3efCAE2i
 zWJiHD1uFCkFd/+xWCJZf01S6K0BX8yC2K3NVTE7vYdGrbSwb7ldXrTZrljswDm7ojgLkYZO+
 d5qJUY/CqtDIBZQhsOdJhsO/g5QQMv9btosbvTomDYJB21FrbvVhO6pjKPNzr2Qa1atduGB7D
 RlGKvgNDdPA7JcP5uFPftS+MFw77NYGL6K/sMpcLF4KwBgrysaANC+wG5c+kvzSpZ6P0O04H0
 1fBHnGqRRBIvyRx6PVcVxPeQdomSjMFo+Yow/LtftsCTDavQdweVNN4nUjuS7HLDQK0ZeZciD
 wy+3uxbAdhXW9UWoSdFdmk8wpNW5ehpgM6O1rXMW/WdE6kPjVHiorptSHE7b/AZy63HUKaXq8
 fVU6asHPecs47obj7irrKz3tkQ8+VieH/eoEZ9PW937fH3R4xU5Ls3YwzWRGCRYwpxTgY2U49
 8T2ZWXnZFoerK4tJxRvkUCcqVkXHMWLzKl75weVyxvHXPfriTgpIQAX0rLr6W4QcWKAgKFU5u
 sGufuc6L7w5cGVc7Tcuql1HJ5Jzdsj9ymqIeB1XsuOtb3sy3KV9TOj3eHronjH9rUeevxyJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ebsa110 platform is the last thing that uses
CONFIG_ARCH_USES_GETTIMEOFFSET, and Russell has previously said that he
thinks the platform can be retired now.

Removing it allows us clean up the timer code by throwing out all of
the references to arch_gettimeoffset().

The am79c961a network driver can presumably also go, as no other platform
references it.

I don't expect these to make it into the coming merge window, posting here
as an RFC, and as a reference for the mildly related timer tick series.

     Arnd

Arnd Bergmann (3):
  ARM: remove ebsa110 platform
  net: remove am79c961a driver
  timekeeping: remove arch_gettimeoffset

 .../time/modern-timekeeping/arch-support.txt  |  33 -
 MAINTAINERS                                   |   8 -
 arch/arm/Kconfig                              |  24 +-
 arch/arm/Kconfig.debug                        |   6 +-
 arch/arm/Makefile                             |   8 -
 arch/arm/configs/ebsa110_defconfig            |  74 --
 arch/arm/kernel/Makefile                      |   6 +-
 arch/arm/mach-ebsa110/Makefile                |   8 -
 arch/arm/mach-ebsa110/Makefile.boot           |   5 -
 arch/arm/mach-ebsa110/core.c                  | 323 --------
 arch/arm/mach-ebsa110/core.h                  |  38 -
 .../mach-ebsa110/include/mach/entry-macro.S   |  33 -
 arch/arm/mach-ebsa110/include/mach/hardware.h |  21 -
 arch/arm/mach-ebsa110/include/mach/io.h       |  89 --
 arch/arm/mach-ebsa110/include/mach/irqs.h     |  17 -
 arch/arm/mach-ebsa110/include/mach/memory.h   |  22 -
 .../mach-ebsa110/include/mach/uncompress.h    |  41 -
 arch/arm/mach-ebsa110/io.c                    | 440 ----------
 arch/arm/mach-ebsa110/leds.c                  |  71 --
 drivers/Makefile                              |   2 -
 drivers/clocksource/Kconfig                   |   2 +-
 drivers/net/ethernet/amd/Kconfig              |  10 +-
 drivers/net/ethernet/amd/Makefile             |   1 -
 drivers/net/ethernet/amd/am79c961a.c          | 763 ------------------
 drivers/net/ethernet/amd/am79c961a.h          | 143 ----
 include/linux/time.h                          |  13 -
 kernel/time/Kconfig                           |   9 -
 kernel/time/clocksource.c                     |   8 -
 kernel/time/timekeeping.c                     |  25 +-
 kernel/trace/Kconfig                          |   2 -
 30 files changed, 9 insertions(+), 2236 deletions(-)
 delete mode 100644 Documentation/features/time/modern-timekeeping/arch-support.txt
 delete mode 100644 arch/arm/configs/ebsa110_defconfig
 delete mode 100644 arch/arm/mach-ebsa110/Makefile
 delete mode 100644 arch/arm/mach-ebsa110/Makefile.boot
 delete mode 100644 arch/arm/mach-ebsa110/core.c
 delete mode 100644 arch/arm/mach-ebsa110/core.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/io.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ebsa110/io.c
 delete mode 100644 arch/arm/mach-ebsa110/leds.c
 delete mode 100644 drivers/net/ethernet/amd/am79c961a.c
 delete mode 100644 drivers/net/ethernet/amd/am79c961a.h

Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org


-- 
2.27.0

