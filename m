Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030C150C6E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbfFXNv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:51:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35213 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbfFXNvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:51:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so7173432pgl.2;
        Mon, 24 Jun 2019 06:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bS9CCVyWEuckL8u69D81nqeXtcKIqj0WvuL/deztfxA=;
        b=STUm1cxNJnae+2FI43yRQ5HEaTHSxK+bvkN9usO4qrn43dFIhPBq6Zu+2c7psdHdX1
         KZoN7g46UrRZAXePlZuPqYLitdh2jKse2p2UqTO1y8j7GCrRi5wdvmI8fFwG7uMZD0gj
         k2jfWnUdZ3MViAPx3kbunnPoRSFiS98WDozGItYv4pDJzAP+9clJwLibluvCzHX8eWrq
         0aHtW71fHq5Amft72c7T8rxO4bZyngVRf0RoeGBOxpylMM5H/+nvS/xwX3gE9DYpI2im
         nE9ZqTB4Hp47etlWvriLWtVGUK+tuMxQdhEFVrDZjdwn26GNylio3yIv6pY6kmxC9C28
         HsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bS9CCVyWEuckL8u69D81nqeXtcKIqj0WvuL/deztfxA=;
        b=ZQFW4xGrG6W6Y9VrZRzYDolpF/QDzn0fCdTFFzAznPHaXmWhcY2xZbd5IWODAk59yz
         y0wEPyGLDerx7oqDQgTBI7gPtrC96P55OZNwtfTe8aCD+gr0+GvpSf8OuTgjZiFQVBa2
         LGndZdWRZCNf6P3itdRrojsaZMxEnrncCTbufG4xrKntKjOXszylk0k5LkJJ3eN7D+6Q
         APbbx6niZ+pYvM03tYBi9FbbILhkigIvf/BbqcO0RUG8PKRny4K4oC6khvGY805/THgT
         1RNQ1sgAdrkGH0/sg0uPGPTwqi3wkXugNnhLClCyq+czdZiNfNxVeoUFPNRanhSgdKw+
         3yMg==
X-Gm-Message-State: APjAAAUXW6vXqQ+eQ6YAb8mgQQOGOupL14IXMG4f3303xOMdbC0RAYiM
        gBNDW5fPMOFrBN+feSGgCi8=
X-Google-Smtp-Source: APXvYqzQSmWH/uIVE4LHageyRy8Q7FGokXruF6yqV6OtmrovRUHuiXdxjTCPC1+a9TDKriLZ/1SghA==
X-Received: by 2002:a17:90a:af8e:: with SMTP id w14mr25480941pjq.89.1561384284784;
        Mon, 24 Jun 2019 06:51:24 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:51:23 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     tranmanphong@gmail.com
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, sudeep.holla@arm.com, swinslow@gmail.com,
        tglx@linutronix.de, tony@atomide.com, will@kernel.org, yhs@fb.com
Subject: [PATCH V2 00/15] cleanup cppcheck signed shifting errors
Date:   Mon, 24 Jun 2019 20:50:50 +0700
Message-Id: <20190624135105.15579-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are errors with cppcheck 

"Shifting signed 32-bit value by 31 bits is undefined behaviour errors"

This is just a mirror changing. 

V2: Using BIT() macro instead of (1UL << nr) 

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
 arch/arm/vfp/vfpinstr.h            |   8 +--
 16 files changed, 187 insertions(+), 187 deletions(-)

-- 
2.11.0

