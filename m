Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F7452179
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfFYEER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:04:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39677 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfFYEER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:04:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so8724656pfe.6;
        Mon, 24 Jun 2019 21:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lKJzQsTdWRiDE4LC6jT5wD3fUjkhZSxKv66YO52/0Io=;
        b=Pyn37ak+v6Ct7FBS87A6cqV6Q+HmCXkxXjRSAU2haW+C01rhiL8/FPl5o5feklwBgA
         G4M6AYWdtoAwRn2baMYR9UeN+jEJPdrnXY3rjJ8X0gLAfKhK8SCf7cYLzDtSyQeIxJTb
         Ur+1coG8C0o3hwaew4r74zMHsfBDLzxSCeDnZ73sC6Ghm02eWvB8oziMQ2UUBkYhGMeI
         zjyhoe2OxMXzrCUabWztTeSSyAg0lY7heQP+t6WcEBI49MoamdLPcp4JTNcxx4E35hLb
         uMhFcFScixboCUs6oI5I7wVHBM00sUpr2vblLlQe0OnnBdmPjW6xpXkh+21VDlgXHsNL
         bv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lKJzQsTdWRiDE4LC6jT5wD3fUjkhZSxKv66YO52/0Io=;
        b=BFvf5LrvGWV5dVZAuBRemT00sTfq+13zfbOf+hs/WhzPfx9vMQ931PPaRFPCw39BsI
         u7xoynoCWknTqM1/SXBDah+wVulS1O/ql3gGYeG6WvHPtxIHya6faASr653xYlQVAXea
         pG0OT8fJZ+KXWbSKqSLy+OUWI9Frz1GXgp6Ngk1rDlOVaHiuZgWlct7RKh8Lf+3hnLZH
         BYjS/iO1AxsXWcRlID+aW8WzufSaKo+VDOUQKBN1WI/mEfDpKY4C8SnX3xPq4xNnk2Q4
         8FUcrEPnGGvDR/DjCFAAegnklGCaOkIS4LdS1+VnVQ3CD4iE0IEBM5P0uomG8iU5FB9/
         b0Cg==
X-Gm-Message-State: APjAAAVW0H/s5p54rt0u6+ldHx/k783PIdQRoqQB+81h9Y8qZEVlDFUi
        IKzFnWPEFdOEY4iAUMWB1tY=
X-Google-Smtp-Source: APXvYqxTiHp0SY/tY143tklMJob5/LblyUUsPs1ZUb+XI7s8nI5LiITkZ/gdXMBmlKhbq5C+PhtCVg==
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr28893337pjr.50.1561435456007;
        Mon, 24 Jun 2019 21:04:16 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.04.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:04:15 -0700 (PDT)
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
Subject: [PATCH V3 00/15] cleanup cppcheck signed shifting errors
Date:   Tue, 25 Jun 2019 11:03:41 +0700
Message-Id: <20190625040356.27473-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is also do as the suggestion of "Linux Kernel Mentorship Task List"

https://wiki.linuxfoundation.org/lkmp/lkmp_task_list#cleanup_cppcheck_errors
"Shifting signed 32-bit value by 31 bits is undefined behaviour errors"

Change Log:

V2: Using BIT() macro instead of (1UL << nr) 

V3: 
* Update the comments from Russell King.
* Update commit message and cover letter for clearly the reason as request
  Peter Zijlstra
* For avoiding the broken only change (1<<nr) pattern to BIT(nr)

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
 arch/arm/mach-ep93xx/soc.h         | 134 ++++++++++++++++++-------------------
 arch/arm/mach-exynos/suspend.c     |   2 +-
 arch/arm/mach-footbridge/dc21285.c |   2 +-
 arch/arm/mach-imx/iomux-mx3.h      |  64 +++++++++---------
 arch/arm/mach-ks8695/regs-pci.h    |   4 +-
 arch/arm/mach-mmp/pm-mmp2.h        |  40 +++++------
 arch/arm/mach-mmp/pm-pxa910.h      |  74 ++++++++++----------
 arch/arm/mach-omap2/powerdomain.c  |   2 +-
 arch/arm/mach-orion5x/pci.c        |   8 +--
 arch/arm/mach-pxa/irq.c            |   4 +-
 arch/arm/mach-vexpress/spc.c       |   4 +-
 arch/arm/mm/fault.h                |   6 +-
 arch/arm/net/bpf_jit_32.c          |   2 +-
 arch/arm/vfp/vfpinstr.h            |   8 +--
 16 files changed, 183 insertions(+), 183 deletions(-)

-- 
2.11.0

