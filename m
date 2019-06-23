Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7334FC1E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFWPNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:13:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38845 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfFWPNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:13:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so1410507pfn.5;
        Sun, 23 Jun 2019 08:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=Xny/Smm8ZOguBx6TIBYh9sfQZ5lBQfd4r1V74iu/FWY=;
        b=AHq9iXY732JpkFSqZdNIYjZNHnrPNVqUImqq8TWWU45Q3Esqy5KfwrkA9Vb0zJz8hR
         8p1BVEMu/lR5DwXb36tOM+ZwT5i7oPTfi2M7f36Ix3XTlBygBeCAW/jdWdcC4NFTB9C3
         8Vag/Y/jhqkr4RhoHTnUy2LuO+R6GGdvJ6TUnKhKyxe3tVw/WOarmd6mMiruUvMjVYbd
         IMppE2WaX0i2Rlw/yRAHXS0FSm9UwC54+mJKiRSoDOmT6sXtCQcIOvaXfpxmuxS1xogJ
         0p9gi+R7XHfmvA3x7Kl9RYAyPLh5jt5MJ+S4xWyQZh3AjhYXE9JZI0ij4hSkhFDOelBc
         3ELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=Xny/Smm8ZOguBx6TIBYh9sfQZ5lBQfd4r1V74iu/FWY=;
        b=A6AJpbK0nhXuQL6Fj7VvKRr9JmXWF0Wk5XhZHUrd12dfOlt238J34ToWYPW1O1xuRB
         Q7MmHY1Nmzyn2jH/QCc6QZ4EsKlrgPwMZn91OKLG74U4FhVNgQ0ETSu2KYwx+LUFBgmR
         zMpOgSwBdVPBep/sRbXLpSyUl9WIDA4qavSPmgX7Qg1GZuCehJgVuTSQQ9Ff602RvrQN
         b4twQHS92xnIMKDpL85lxwoBYKhK4hJGrG/UxMuArjQiOp0XaiS8oG7cQN6kzYQL+m4K
         2vGrRRKBHSOzXy5stsZ3fZi/wO3RlQr4yk77CBK32m2wb+SmxogjKivqQFAXkoqLITp2
         uqpA==
X-Gm-Message-State: APjAAAVbIFnW2ja/GEJs0f8YCuXPfK03gX8l4fUqBA75ztnUDQPzVmOr
        mqRS6bnP6S03HHReq2sT7lg=
X-Google-Smtp-Source: APXvYqxriftyOkEo1w2RU5r8+lBgCvesL+lma0dOdPirxFZjjUgMMEvh5asrfLLTeV2X5oRX0ldd/A==
X-Received: by 2002:a17:90a:d3d7:: with SMTP id d23mr18126025pjw.26.1561302833413;
        Sun, 23 Jun 2019 08:13:53 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.13.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:13:52 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, peterz@infradead.org,
        nsekhar@ti.com, ast@kernel.org, jolsa@redhat.com,
        netdev@vger.kernel.org, gerg@uclinux.org,
        lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        tranmanphong@gmail.com, festevam@gmail.com,
        gregory.clement@bootlin.com, allison@lohutok.net,
        linux@armlinux.org.uk, krzk@kernel.org, haojian.zhuang@gmail.com,
        bgolaszewski@baylibre.com, tony@atomide.com, mingo@redhat.com,
        linux-imx@nxp.com, yhs@fb.com, sebastian.hesselbarth@gmail.com,
        illusionist.neo@gmail.com, jason@lakedaemon.net,
        liviu.dudau@arm.com, s.hauer@pengutronix.de, acme@kernel.org,
        lkundrak@v3.sk, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Subject: [PATCH 00/15] cleanup cppcheck signed shifting errors
Date:   Sun, 23 Jun 2019 22:12:58 +0700
Message-Id: <20190623151313.970-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are errors with cppcheck 

"Shifting signed 32-bit value by 31 bits is undefined behaviour errors"

This is just a mirror changing.

Phong Tran (15):
  arm: perf: cleanup cppcheck shifting error
  ARM: davinci: cleanup cppcheck shifting errors
  ARM: ep93xx: cleanup cppcheck shifting errors
  ARM: exynos: cleanup cppcheck shifting error
  ARM: footbridge: cleanup cppcheck shifting error
  ARM: imx: cleanup cppcheck shifting errors
  ARM: ks8695: cleanup cppcheck shifting error
  ARM: mmp: cleanup cppcheck shifting errors
  ARM: omap2: cleanup cppcheck shifting error
  ARM: orion5x: cleanup cppcheck shifting errors
  ARM: pxa: cleanup cppcheck shifting errors
  ARM: vexpress: cleanup cppcheck shifting error
  ARM: mm: cleanup cppcheck shifting errors
  ARM: bpf: cleanup cppcheck shifting error
  ARM: vfp: cleanup cppcheck shifting errors

 arch/arm/kernel/perf_event_v7.c    |   6 +-
 arch/arm/mach-davinci/ddr2.h       |   6 +-
 arch/arm/mach-ep93xx/soc.h         | 132 ++++++++++++++++++-------------------
 arch/arm/mach-exynos/suspend.c     |   2 +-
 arch/arm/mach-footbridge/dc21285.c |   2 +-
 arch/arm/mach-imx/iomux-mx3.h      |  64 +++++++++---------
 arch/arm/mach-ks8695/regs-pci.h    |   4 +-
 arch/arm/mach-mmp/pm-mmp2.h        |  40 +++++------
 arch/arm/mach-mmp/pm-pxa910.h      |  76 ++++++++++-----------
 arch/arm/mach-omap2/powerdomain.c  |   2 +-
 arch/arm/mach-orion5x/pci.c        |   8 +--
 arch/arm/mach-pxa/irq.c            |   4 +-
 arch/arm/mach-vexpress/spc.c       |  12 ++--
 arch/arm/mm/fault.h                |   6 +-
 arch/arm/net/bpf_jit_32.c          |   2 +-
 arch/arm/vfp/vfpinstr.h            |  28 ++++----
 16 files changed, 197 insertions(+), 197 deletions(-)

-- 
2.11.0

