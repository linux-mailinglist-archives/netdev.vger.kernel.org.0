Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C9C425635
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242388AbhJGPMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242275AbhJGPMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B0B26113E;
        Thu,  7 Oct 2021 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633619423;
        bh=6XparVng5W/AReJHiKchmXlIe9lsC3Z91YzkLUlPNCg=;
        h=From:To:Cc:Subject:Date:From;
        b=uGBU3w5ZPcovOtfzM/FIsHTD7h3JxuPJygqvsc/Akx8WIgRCpgs3UgXZBZTV82I1O
         pW+TIPVurN88xf3WvDzFDkgp4KUNa7HpHH0yruRMhNm5135jx5bqq+/CKSzQGvE9Do
         ViwsXF7lFqxOsI6bHhr9Jy2jv4XcchqTsLVaQi+z5d/b1rYbgoS7hR41kw3y30v3an
         GfXh2Vp3SSFv+/Ic2Yauk4D9evUCiGVqN10/ZzGkA3ER8QQimEVtKd0+OTGa/g7KUM
         0ggiEgI2DrGim19ev5P6YtxGkOvCy0ZLC7gw6ICyGtfCMR5AINWv1keeKoUptUyCZ3
         OdUDZ2/BTlnCQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Simon Trimmer <simont@opensource.cirrus.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 1/2] firmware: include drivers/firmware/Kconfig unconditionally
Date:   Thu,  7 Oct 2021 17:10:09 +0200
Message-Id: <20211007151010.333516-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Compile-testing drivers that require access to a firmware layer
fails when that firmware symbol is unavailable. This happened
twice this week:

 - My proposed to change to rework the QCOM_SCM firmware symbol
   broke on ppc64 and others.

 - The cs_dsp firmware patch added device specific firmware loader
   into drivers/firmware, which broke on the same set of
   architectures.

We should probably do the same thing for other subsystems as well,
but fix this one first as this is a dependency for other patches
getting merged.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Simon Trimmer <simont@opensource.cirrus.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
No changes in v2, but it's now queued in my asm-generic
tree for v5.15

 arch/arm/Kconfig    | 2 --
 arch/arm64/Kconfig  | 2 --
 arch/ia64/Kconfig   | 2 --
 arch/mips/Kconfig   | 2 --
 arch/parisc/Kconfig | 2 --
 arch/riscv/Kconfig  | 2 --
 arch/x86/Kconfig    | 2 --
 drivers/Kconfig     | 2 ++
 8 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fc196421b2ce..59baf6c132a7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1989,8 +1989,6 @@ config ARCH_HIBERNATION_POSSIBLE
 
 endmenu
 
-source "drivers/firmware/Kconfig"
-
 if CRYPTO
 source "arch/arm/crypto/Kconfig"
 endif
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 077f2ec4eeb2..407b4addea36 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1931,8 +1931,6 @@ source "drivers/cpufreq/Kconfig"
 
 endmenu
 
-source "drivers/firmware/Kconfig"
-
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 045792cde481..1e33666fa679 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -388,8 +388,6 @@ config CRASH_DUMP
 	  help
 	    Generate crash dump after being started by kexec.
 
-source "drivers/firmware/Kconfig"
-
 endmenu
 
 menu "Power management and ACPI options"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 771ca53af06d..6b8f591c5054 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3316,8 +3316,6 @@ source "drivers/cpuidle/Kconfig"
 
 endmenu
 
-source "drivers/firmware/Kconfig"
-
 source "arch/mips/kvm/Kconfig"
 
 source "arch/mips/vdso/Kconfig"
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 4742b6f169b7..27a8b49af11f 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -384,6 +384,4 @@ config KEXEC_FILE
 
 endmenu
 
-source "drivers/firmware/Kconfig"
-
 source "drivers/parisc/Kconfig"
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c3f3fd583e04..8bc71ab143e3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -561,5 +561,3 @@ menu "Power management options"
 source "kernel/power/Kconfig"
 
 endmenu
-
-source "drivers/firmware/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4e001bbbb425..4dca39744ee9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2828,8 +2828,6 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
-source "drivers/firmware/Kconfig"
-
 source "arch/x86/kvm/Kconfig"
 
 source "arch/x86/Kconfig.assembler"
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 30d2db37cc87..0d399ddaa185 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -17,6 +17,8 @@ source "drivers/bus/Kconfig"
 
 source "drivers/connector/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "drivers/gnss/Kconfig"
 
 source "drivers/mtd/Kconfig"
-- 
2.29.2

