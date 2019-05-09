Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11118312
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 03:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEIBBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 21:01:31 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:18779 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfEIBBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 21:01:31 -0400
Received: from grover.flets-west.jp (softbank126125154139.bbtec.net [126.125.154.139]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x4910hX5026248;
        Thu, 9 May 2019 10:00:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x4910hX5026248
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1557363644;
        bh=W0lfXc6AxJfFbQb9h4FjR/5t6SeEfM/LyaprjVB7Apw=;
        h=From:To:Cc:Subject:Date:From;
        b=J19yNRSDsAQu73Q9fxFJ0JIowc43871V/0i0356E4y+uM2TFafnOc8y3MH7Yo7nrw
         2GkjjGbNdc/SHpTEuDTNjBUy/IXVLhJ1pa3I5Q1pv34ptrs1f/SYyvcXwgTkDTi6S9
         dFUgmOl0bOFKQ0a+AEeRBEm9WEMgBYKwoBKXxSvG2pbFqGKF+caEctbdhjGt8OPOYt
         tjFkmRuTh7UlD6+yJ8iNzQK/Eh0Ksquvy3ak894d+irzuS29PDFset9T5KYNZjG8tG
         ZtwFDsCLEFpodPvFiTu1VJoII3apndgl4A1KZXUTeGpu1j7ZeZvZ/Rd8wUYjMg1+jr
         diMFWErcNO3LA==
X-Nifty-SrcIP: [126.125.154.139]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH v2] samples: guard sub-directories with CONFIG options
Date:   Thu,  9 May 2019 10:00:19 +0900
Message-Id: <1557363619-1211-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not descend to sub-directories when unneeded.

I used subdir-$(CONFIG_...) for hidraw, seccomp, and vfs because
they only contain host programs.

While we are here, let's add SPDX License tag, and sort the directories
alphabetically.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2:
  - Rebased on mainline

 samples/Makefile         | 24 ++++++++++++++++++++----
 samples/seccomp/Makefile |  2 +-
 samples/vfs/Makefile     |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 8e096e0..debf892 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,6 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux samples code
 
-obj-y			+= kobject/ kprobes/ trace_events/ livepatch/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
-			   configfs/ connector/ v4l/ trace_printk/ \
-			   vfio-mdev/ vfs/ qmi/ binderfs/ pidfd/
+obj-$(CONFIG_SAMPLE_ANDROID_BINDERFS)	+= binderfs/
+obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
+obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
+subdir-y				+= hidraw
+obj-$(CONFIG_SAMPLE_HW_BREAKPOINT)	+= hw_breakpoint/
+obj-$(CONFIG_SAMPLE_KDB)		+= kdb/
+obj-$(CONFIG_SAMPLE_KFIFO)		+= kfifo/
+obj-$(CONFIG_SAMPLE_KOBJECT)		+= kobject/
+obj-$(CONFIG_SAMPLE_KPROBES)		+= kprobes/
+obj-$(CONFIG_SAMPLE_LIVEPATCH)		+= livepatch/
+subdir-y				+= pidfd
+obj-$(CONFIG_SAMPLE_QMI_CLIENT)		+= qmi/
+obj-$(CONFIG_SAMPLE_RPMSG_CLIENT)	+= rpmsg/
+subdir-$(CONFIG_SAMPLE_SECCOMP)		+= seccomp
+obj-$(CONFIG_SAMPLE_TRACE_EVENTS)	+= trace_events/
+obj-$(CONFIG_SAMPLE_TRACE_PRINTK)	+= trace_printk/
+obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
+obj-y					+= vfio-mdev/
+subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 00e0b5e..009775b 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-hostprogs-$(CONFIG_SAMPLE_SECCOMP) := bpf-fancy dropper bpf-direct user-trap
+hostprogs-y := bpf-fancy dropper bpf-direct user-trap
 
 HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
diff --git a/samples/vfs/Makefile b/samples/vfs/Makefile
index 4ac9690..a3e4ffd 100644
--- a/samples/vfs/Makefile
+++ b/samples/vfs/Makefile
@@ -1,5 +1,5 @@
 # List of programs to build
-hostprogs-$(CONFIG_SAMPLE_VFS) := \
+hostprogs-y := \
 	test-fsmount \
 	test-statx
 
-- 
2.7.4

