Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB251AF14
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378024AbiEDUdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378019AbiEDUd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DFC4FC56
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D6D61776
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592C2C385A5;
        Wed,  4 May 2022 20:29:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="POegLlgd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6VN9TTLhCQZxLU6ybMvdxREUXg5CZscGkIQKbFu6N4=;
        b=POegLlgdV9fSk1dCUPiRmviOZJ7pqgTFb30Qpz405xi/XJY44RXXwMzFeGrbXDyFnY69GQ
        pKttmboo+k/6exQ8c0MmikPCn/Gz8PuiT1k9XuCNn63IHSMtnlFyUiaKGCFs68DL0iFOm2
        NKSNXULaXKV1WQ7gR66pTJAr18XwpRY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 92654a3f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 6/6] wireguard: selftests: set panic_on_warn=1 from cmdline
Date:   Wed,  4 May 2022 22:29:20 +0200
Message-Id: <20220504202920.72908-7-Jason@zx2c4.com>
In-Reply-To: <20220504202920.72908-1-Jason@zx2c4.com>
References: <20220504202920.72908-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than setting this once init is running, set panic_on_warn from
the kernel command line, so that it catches splats from WireGuard
initialization code and the various crypto selftests.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/arch/aarch64.config  | 2 +-
 .../testing/selftests/wireguard/qemu/arch/aarch64_be.config | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/arm.config      | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/armeb.config    | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/i686.config     | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/m68k.config     | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/mips.config     | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/mips64.config   | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/mips64el.config | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/mipsel.config   | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/powerpc.config  | 2 +-
 .../testing/selftests/wireguard/qemu/arch/powerpc64.config  | 2 +-
 .../selftests/wireguard/qemu/arch/powerpc64le.config        | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/riscv32.config  | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/riscv64.config  | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/s390x.config    | 2 +-
 tools/testing/selftests/wireguard/qemu/arch/x86_64.config   | 2 +-
 tools/testing/selftests/wireguard/qemu/init.c               | 6 ------
 18 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/arch/aarch64.config b/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
index e9ac41f6b3ae..09016880ce03 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
@@ -4,5 +4,5 @@ CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config b/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
index 03609a203e8c..19ff66e4c602 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
@@ -5,5 +5,5 @@ CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/arm.config b/tools/testing/selftests/wireguard/qemu/arch/arm.config
index c616124fdd59..fc7959bef9c2 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/arm.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/arm.config
@@ -8,5 +8,5 @@ CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/armeb.config b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
index d3a40a974e16..f3066be81c19 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/armeb.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
@@ -8,6 +8,6 @@ CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_CPU_BIG_ENDIAN=y
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/i686.config b/tools/testing/selftests/wireguard/qemu/arch/i686.config
index a9b4fe795048..6d90892a85a2 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/i686.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/i686.config
@@ -2,5 +2,5 @@ CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/m68k.config b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
index 62a15bdb877e..82c925e49beb 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
@@ -5,5 +5,5 @@ CONFIG_MAC=y
 CONFIG_SERIAL_PMACZILOG=y
 CONFIG_SERIAL_PMACZILOG_TTYS=y
 CONFIG_SERIAL_PMACZILOG_CONSOLE=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mips.config b/tools/testing/selftests/wireguard/qemu/arch/mips.config
index df71d6b95546..d7ec63c17b30 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mips.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mips.config
@@ -7,5 +7,5 @@ CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mips64.config b/tools/testing/selftests/wireguard/qemu/arch/mips64.config
index 90c783f725c4..0994947e3392 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mips64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mips64.config
@@ -10,5 +10,5 @@ CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mips64el.config b/tools/testing/selftests/wireguard/qemu/arch/mips64el.config
index 435b0b43e00c..591184342f47 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mips64el.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mips64el.config
@@ -11,5 +11,5 @@ CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mipsel.config b/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
index 62bb50c4a85f..18a498293737 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
@@ -8,5 +8,5 @@ CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
index 57957093b71b..5e04882e8e35 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
@@ -6,5 +6,5 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_MATH_EMULATION=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
index c19c7b519d8b..737194b7619e 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
@@ -7,7 +7,7 @@ CONFIG_PPC_RADIX_MMU=y
 CONFIG_HVC_CONSOLE=y
 CONFIG_CPU_BIG_ENDIAN=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=hvc0 wg.success=hvc1"
+CONFIG_CMDLINE="console=hvc0 wg.success=hvc1 panic_on_warn=1"
 CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 CONFIG_FRAME_WARN=1280
 CONFIG_THREAD_SHIFT=14
diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
index f52f1e2bc7f6..8148b9d1220a 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
@@ -7,7 +7,7 @@ CONFIG_PPC_RADIX_MMU=y
 CONFIG_HVC_CONSOLE=y
 CONFIG_CPU_LITTLE_ENDIAN=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=hvc0 wg.success=hvc1"
+CONFIG_CMDLINE="console=hvc0 wg.success=hvc1 panic_on_warn=1"
 CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 CONFIG_FRAME_WARN=1280
 CONFIG_THREAD_SHIFT=14
diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv32.config b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
index ea53e78e923e..0bd0e72d95d4 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
@@ -8,5 +8,5 @@ CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_CMDLINE_FORCE=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv64.config b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
index 4a08d8c1d4af..dc266f3b1915 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
@@ -8,5 +8,5 @@ CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_CMDLINE_FORCE=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/s390x.config b/tools/testing/selftests/wireguard/qemu/arch/s390x.config
index 274a44f4e49c..a7b44dca0b0a 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/s390x.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/s390x.config
@@ -3,4 +3,4 @@ CONFIG_SCLP_VT220_CONSOLE=y
 CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_S390_GUEST=y
-CONFIG_CMDLINE="console=ttysclp0 wg.success=vport0p1"
+CONFIG_CMDLINE="console=ttysclp0 wg.success=vport0p1 panic_on_warn=1"
diff --git a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
index 45dd53a0d760..efa00693e08b 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
@@ -2,5 +2,5 @@ CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index 0b45055d9de0..2a0f48fac925 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -110,12 +110,6 @@ static void enable_logging(void)
 			panic("write(exception-trace)");
 		close(fd);
 	}
-	fd = open("/proc/sys/kernel/panic_on_warn", O_WRONLY);
-	if (fd >= 0) {
-		if (write(fd, "1\n", 2) != 2)
-			panic("write(panic_on_warn)");
-		close(fd);
-	}
 }
 
 static void kmod_selftests(void)
-- 
2.35.1

