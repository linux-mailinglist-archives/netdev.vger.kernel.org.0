Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480B182F2C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbfHFKAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:00:54 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40137 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732262AbfHFKAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:00:54 -0400
Received: by mail-yb1-f194.google.com with SMTP id j6so212196ybm.7
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 03:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ss7tfuNN9gph1p4XOsDIlLKrMAe3sezcu2lcCyG5PrA=;
        b=llzpCKvfTJg9zx4WGbK3W8ELlbZszVisTWmKs2WgL7/QVGUzVblcBslqpxo6sHvB/2
         XTxuH6yt7Pqho2/Dk3XQRm5ssQG4b0J5+VL1WLv3DvEuC4iWmLQBmcnIeEYbnhvQAS3d
         OaDIu3c8mjZ3MaC87uEx1ICI53UwFJn//mcEAXmhA1PI1HBLTuGVvr28BI74d7+vKFK8
         g8I+2D4tta/rMVSZZQJJDzvZToRr0JlJ0xd4r32m0Z7Y3QGdloZvUkRz4PwUMa4SBbTJ
         ReTDwAvbKrd4coRI8s0r8TqxVgUjPfsoTdlSM5oAL4w7ndmTwVVuizbrsn36eLs160LV
         Gc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ss7tfuNN9gph1p4XOsDIlLKrMAe3sezcu2lcCyG5PrA=;
        b=biTvN5Ae1SNxhGaShg1gam5ucoti4QQn8/GpZ4BVx3GJBirvppdT2RWdj4RY55Mrkn
         26t7lT4Yc/UWcbD1j94N1AsEL3gWFJ9RKKL02XPEQGL3kTgV+B0/z4SmI745Afo/URi3
         unfc7xUEJIVUT5+GXHDu9xmumf5+wKNPWb8BDez5BalsZ7s5fWDSeXLHIhWbNHOxjtSk
         xLWic9tDgMEykFNSPJqUqF0W7XOa/2QR7Bz1RRlCf9DuatoMrEgZyUxnMu3sSlrViS+H
         LSCB/8bMJ3SZ1gFd4YiPWeEiduNSwAhlbDl0l9Swmtdb8qs20M7CrPzacjzeTTuoiHOV
         Vg0w==
X-Gm-Message-State: APjAAAWAkj7Kk9EkSQC4zuEGp2h+x+fDhYI4/cff4lm/LmpFfR81hsLP
        NHcoUjoKjQeRBePfC6lZfUqY7g==
X-Google-Smtp-Source: APXvYqzW3wsw6yhTMacboTuQrkHBN1nGm4i1ke3WRJqGdu22UVLlanKhTbvJJsUeyrKaTw/x/WIwAA==
X-Received: by 2002:a25:2005:: with SMTP id g5mr1786698ybg.410.1565085653130;
        Tue, 06 Aug 2019 03:00:53 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id h12sm18316685ywm.91.2019.08.06.03.00.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 03:00:51 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 0/3] arm/arm64: Add support for function error injection
Date:   Tue,  6 Aug 2019 18:00:12 +0800
Message-Id: <20190806100015.11256-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch set is to add support for function error injection;
this can be used to eanble more advanced debugging feature, e.g.
CONFIG_BPF_KPROBE_OVERRIDE.

The patch 01/03 is to consolidate the function definition which can be
suared cross architectures, patches 02,03/03 are used for enabling
function error injection on arm64 and arm architecture respectively.

I tested on arm64 platform Juno-r2 and one of my laptop with x86
architecture with below steps; I don't test for Arm architecture so
only pass compilation.

- Enable kernel configuration:
  CONFIG_BPF_KPROBE_OVERRIDE
  CONFIG_BTRFS_FS
  CONFIG_BPF_EVENTS=y
  CONFIG_KPROBES=y
  CONFIG_KPROBE_EVENTS=y
  CONFIG_BPF_KPROBE_OVERRIDE=y

- Build samples/bpf on with Debian rootFS:
  # cd $kernel
  # make headers_install
  # make samples/bpf/ LLC=llc-7 CLANG=clang-7

- Run the sample tracex7:
  # dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
  # DEVICE=$(losetup --show -f testfile.img)
  # mkfs.btrfs -f $DEVICE
  # ./tracex7 testfile.img
  [ 1975.211781] BTRFS error (device (efault)): open_ctree failed
  mount: /mnt/linux-kernel/linux-cs-dev/samples/bpf/tmpmnt: mount(2) system call failed: Cannot allocate memory.

Changes from v1:
* Consolidated the function definition into asm-generic header (Will);
* Used APIs to access pt_regs elements (Will);
* Fixed typos in the comments (Will).


Leo Yan (3):
  error-injection: Consolidate override function definition
  arm64: Add support for function error injection
  arm: Add support for function error injection

 arch/arm/Kconfig                           |  1 +
 arch/arm/include/asm/ptrace.h              |  5 +++++
 arch/arm/lib/Makefile                      |  2 ++
 arch/arm/lib/error-inject.c                | 19 +++++++++++++++++++
 arch/arm64/Kconfig                         |  1 +
 arch/arm64/include/asm/ptrace.h            |  5 +++++
 arch/arm64/lib/Makefile                    |  2 ++
 arch/arm64/lib/error-inject.c              | 18 ++++++++++++++++++
 arch/powerpc/include/asm/error-injection.h | 13 -------------
 arch/x86/include/asm/error-injection.h     | 13 -------------
 include/asm-generic/error-injection.h      |  6 ++++++
 include/linux/error-injection.h            |  6 +++---
 12 files changed, 62 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/lib/error-inject.c
 create mode 100644 arch/arm64/lib/error-inject.c
 delete mode 100644 arch/powerpc/include/asm/error-injection.h
 delete mode 100644 arch/x86/include/asm/error-injection.h

-- 
2.17.1

