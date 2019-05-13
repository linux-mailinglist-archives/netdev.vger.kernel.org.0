Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151A01B03C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfEMGWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 02:22:40 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:39927 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfEMGWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 02:22:39 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x4D6MKMG031944;
        Mon, 13 May 2019 15:22:23 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x4D6MKMG031944
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1557728544;
        bh=d8gbEARL3UEIkmRM3efisa39Z3caCnTyjI4aXWlpqto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5SBMawRToWN8wXGdhy3zro5xY47D7sCmKP5XsuainrhzTWMQ6wYv49fVxLJTgggU
         fkamefo4i1gUpwYmRNgGYS+lSXdVa8RLYxFtG/8lVDQcXVbNZM0QoTLmJi8mXRjJcw
         tcKGm6P30sZEWp1PGwoZdZ331QFjfMdrDwtVoJ94zCZNouSpiURUWpXVYGYwT2AXWm
         VXiwCe/25fR2S29w9qlOrPy2H3r5mb1PS+6a59VpoAYf4OiNGIwviu9W6kJ3HPuXPk
         FjLmGBGvqKoVU8A4SK18OLAIDgCErvnF6U5tRAOMKoPtFlw6OB4v54TxMYTAkWK9zQ
         LHIVXfsL/WspQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        netdev@vger.kernel.org, x86@kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 3/4] treewide: prefix header search paths with $(srctree)/
Date:   Mon, 13 May 2019 15:22:16 +0900
Message-Id: <20190513062217.20750-4-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190513062217.20750-1-yamada.masahiro@socionext.com>
References: <20190513062217.20750-1-yamada.masahiro@socionext.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/mips/pnx833x/Platform                    | 2 +-
 arch/powerpc/Makefile                         | 2 +-
 arch/sh/Makefile                              | 4 ++--
 arch/x86/kernel/Makefile                      | 2 +-
 arch/x86/mm/Makefile                          | 2 +-
 arch/xtensa/boot/lib/Makefile                 | 2 +-
 drivers/hid/intel-ish-hid/Makefile            | 2 +-
 drivers/net/ethernet/chelsio/libcxgb/Makefile | 2 +-
 drivers/target/iscsi/cxgbit/Makefile          | 6 +++---
 drivers/usb/storage/Makefile                  | 2 +-
 fs/ocfs2/dlm/Makefile                         | 3 +--
 fs/ocfs2/dlmfs/Makefile                       | 2 +-
 fs/xfs/Makefile                               | 4 ++--
 net/bpfilter/Makefile                         | 2 +-
 scripts/dtc/Makefile                          | 6 +++---
 scripts/genksyms/Makefile                     | 4 ++--
 scripts/kconfig/Makefile                      | 4 ++--
 17 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/mips/pnx833x/Platform b/arch/mips/pnx833x/Platform
index 794526caab12..6b1a847d593f 100644
--- a/arch/mips/pnx833x/Platform
+++ b/arch/mips/pnx833x/Platform
@@ -1,5 +1,5 @@
 # NXP STB225
 platform-$(CONFIG_SOC_PNX833X)	+= pnx833x/
-cflags-$(CONFIG_SOC_PNX833X)	+= -Iarch/mips/include/asm/mach-pnx833x
+cflags-$(CONFIG_SOC_PNX833X)	+= -I $(srctree)/arch/mips/include/asm/mach-pnx833x
 load-$(CONFIG_NXP_STB220)	+= 0xffffffff80001000
 load-$(CONFIG_NXP_STB225)	+= 0xffffffff80001000
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 258ea6b2f2e7..c345b79414a9 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -211,7 +211,7 @@ endif
 
 asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
 
-KBUILD_CPPFLAGS	+= -Iarch/$(ARCH) $(asinstr)
+KBUILD_CPPFLAGS	+= -I $(srctree)/arch/$(ARCH) $(asinstr)
 KBUILD_AFLAGS	+= $(AFLAGS-y)
 KBUILD_CFLAGS	+= $(call cc-option,-msoft-float)
 KBUILD_CFLAGS	+= -pipe $(CFLAGS-y)
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 4009bef62fe9..b4a86f27e048 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -191,8 +191,8 @@ cpuincdir-y			+= cpu-common	# Must be last
 drivers-y			+= arch/sh/drivers/
 drivers-$(CONFIG_OPROFILE)	+= arch/sh/oprofile/
 
-cflags-y	+= $(foreach d, $(cpuincdir-y), -Iarch/sh/include/$(d)) \
-		   $(foreach d, $(machdir-y), -Iarch/sh/include/$(d))
+cflags-y	+= $(foreach d, $(cpuincdir-y), -I $(srctree)/arch/sh/include/$(d)) \
+		   $(foreach d, $(machdir-y), -I $(srctree)/arch/sh/include/$(d))
 
 KBUILD_CFLAGS		+= -pipe $(cflags-y)
 KBUILD_CPPFLAGS		+= $(cflags-y)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 00b7e27bc2b7..ce1b5cc360a2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -42,7 +42,7 @@ endif
 # non-deterministic coverage.
 KCOV_INSTRUMENT		:= n
 
-CFLAGS_irq.o := -I$(src)/../include/asm/trace
+CFLAGS_irq.o := -I $(srctree)/$(src)/../include/asm/trace
 
 obj-y			:= process_$(BITS).o signal.o
 obj-$(CONFIG_COMPAT)	+= signal_compat.o
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 4b101dd6e52f..84373dc9b341 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -21,7 +21,7 @@ CFLAGS_physaddr.o		:= $(nostackp)
 CFLAGS_setup_nx.o		:= $(nostackp)
 CFLAGS_mem_encrypt_identity.o	:= $(nostackp)
 
-CFLAGS_fault.o := -I$(src)/../include/asm/trace
+CFLAGS_fault.o := -I $(srctree)/$(src)/../include/asm/trace
 
 obj-$(CONFIG_X86_PAT)		+= pat_rbtree.o
 
diff --git a/arch/xtensa/boot/lib/Makefile b/arch/xtensa/boot/lib/Makefile
index 355127faade1..e3d717c7bfa1 100644
--- a/arch/xtensa/boot/lib/Makefile
+++ b/arch/xtensa/boot/lib/Makefile
@@ -7,7 +7,7 @@ zlib	:= inffast.c inflate.c inftrees.c
 
 lib-y	+= $(zlib:.c=.o) zmem.o
 
-ccflags-y	:= -Ilib/zlib_inflate
+ccflags-y	:= -I $(srctree)/lib/zlib_inflate
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_inflate.o = -pg
 CFLAGS_REMOVE_zmem.o = -pg
diff --git a/drivers/hid/intel-ish-hid/Makefile b/drivers/hid/intel-ish-hid/Makefile
index 2de97e4b7740..f0a82b1c7cb9 100644
--- a/drivers/hid/intel-ish-hid/Makefile
+++ b/drivers/hid/intel-ish-hid/Makefile
@@ -23,4 +23,4 @@ intel-ishtp-hid-objs += ishtp-hid-client.o
 obj-$(CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER) += intel-ishtp-loader.o
 intel-ishtp-loader-objs += ishtp-fw-loader.o
 
-ccflags-y += -Idrivers/hid/intel-ish-hid/ishtp
+ccflags-y += -I $(srctree)/$(src)/ishtp
diff --git a/drivers/net/ethernet/chelsio/libcxgb/Makefile b/drivers/net/ethernet/chelsio/libcxgb/Makefile
index 2534e30a1560..441913b5221e 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/Makefile
+++ b/drivers/net/ethernet/chelsio/libcxgb/Makefile
@@ -1,4 +1,4 @@
-ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
+ccflags-y := -I $(srctree)/$(src)/../cxgb4
 
 obj-$(CONFIG_CHELSIO_LIB) += libcxgb.o
 
diff --git a/drivers/target/iscsi/cxgbit/Makefile b/drivers/target/iscsi/cxgbit/Makefile
index d16aaae7ba2a..0dcaf2006f78 100644
--- a/drivers/target/iscsi/cxgbit/Makefile
+++ b/drivers/target/iscsi/cxgbit/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
-ccflags-y += -Idrivers/net/ethernet/chelsio/libcxgb
-ccflags-y += -Idrivers/target/iscsi
+ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
+ccflags-y += -I $(srctree)/drivers/target/iscsi
 
 obj-$(CONFIG_ISCSI_TARGET_CXGB4)  += cxgbit.o
 
diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index c5126a4cd954..a67ddcbb4e24 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -6,7 +6,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-ccflags-y := -Idrivers/scsi
+ccflags-y := -I $(srctree)/drivers/scsi
 
 obj-$(CONFIG_USB_UAS)		+= uas.o
 obj-$(CONFIG_USB_STORAGE)	+= usb-storage.o
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index ef2854422a6e..3d4041f0431e 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -1,7 +1,6 @@
-ccflags-y := -I$(src)/..
+ccflags-y := -I $(srctree)/$(src)/..
 
 obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o
 
 ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
 	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o
-
diff --git a/fs/ocfs2/dlmfs/Makefile b/fs/ocfs2/dlmfs/Makefile
index 33431a0296a3..0a0b93d940fe 100644
--- a/fs/ocfs2/dlmfs/Makefile
+++ b/fs/ocfs2/dlmfs/Makefile
@@ -1,4 +1,4 @@
-ccflags-y := -I$(src)/..
+ccflags-y := -I $(srctree)/$(src)/..
 
 obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
 
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1dfc6df2e2bd..91831975363b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -4,8 +4,8 @@
 # All Rights Reserved.
 #
 
-ccflags-y += -I$(src)			# needed for trace events
-ccflags-y += -I$(src)/libxfs
+ccflags-y += -I $(srctree)/$(src)		# needed for trace events
+ccflags-y += -I $(srctree)/$(src)/libxfs
 
 ccflags-$(CONFIG_XFS_DEBUG) += -g
 
diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 854395fb98cd..aa945ab5b655 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -5,7 +5,7 @@
 
 hostprogs-y := bpfilter_umh
 bpfilter_umh-objs := main.o
-KBUILD_HOSTCFLAGS += -Itools/include/ -Itools/include/uapi
+KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 HOSTCC := $(CC)
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 5f227d8d39d8..82160808765c 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -9,7 +9,7 @@ dtc-objs	:= dtc.o flattree.o fstree.o data.o livetree.o treesource.o \
 dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
 
 # Source files need to get at the userspace version of libfdt_env.h to compile
-HOST_EXTRACFLAGS := -I$(src)/libfdt
+HOST_EXTRACFLAGS := -I $(srctree)/$(src)/libfdt
 
 ifeq ($(wildcard /usr/include/yaml.h),)
 ifneq ($(CHECK_DTBS),)
@@ -23,8 +23,8 @@ HOSTLDLIBS_dtc	:= -lyaml
 endif
 
 # Generated files need one more search path to include headers in source tree
-HOSTCFLAGS_dtc-lexer.lex.o := -I$(src)
-HOSTCFLAGS_dtc-parser.tab.o := -I$(src)
+HOSTCFLAGS_dtc-lexer.lex.o := -I $(srctree)/$(src)
+HOSTCFLAGS_dtc-parser.tab.o := -I $(srctree)/$(src)
 
 # dependencies on generated files need to be listed explicitly
 $(obj)/dtc-lexer.lex.o: $(obj)/dtc-parser.tab.h
diff --git a/scripts/genksyms/Makefile b/scripts/genksyms/Makefile
index 03b7ce97de14..66c314bc5933 100644
--- a/scripts/genksyms/Makefile
+++ b/scripts/genksyms/Makefile
@@ -31,8 +31,8 @@ $(obj)/parse.tab.h: $(src)/parse.y FORCE
 endif
 
 # -I needed for generated C source (shipped source)
-HOSTCFLAGS_parse.tab.o := -I$(src)
-HOSTCFLAGS_lex.lex.o := -I$(src)
+HOSTCFLAGS_parse.tab.o := -I $(srctree)/$(src)
+HOSTCFLAGS_lex.lex.o := -I $(srctree)/$(src)
 
 # dependencies on generated files need to be listed explicitly
 $(obj)/lex.lex.o: $(obj)/parse.tab.h
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7c5dc31c1d95..5e0cd86cb4a7 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -147,8 +147,8 @@ common-objs	:= confdata.o expr.o lexer.lex.o parser.tab.o preprocess.o \
 		   symbol.o
 
 $(obj)/lexer.lex.o: $(obj)/parser.tab.h
-HOSTCFLAGS_lexer.lex.o	:= -I$(src)
-HOSTCFLAGS_parser.tab.o	:= -I$(src)
+HOSTCFLAGS_lexer.lex.o	:= -I $(srctree)/$(src)
+HOSTCFLAGS_parser.tab.o	:= -I $(srctree)/$(src)
 
 # conf: Used for defconfig, oldconfig and related targets
 hostprogs-y	+= conf
-- 
2.17.1

