Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBA0D19F3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfJIUmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:42:39 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46251 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731851AbfJIUlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:53 -0400
Received: by mail-lf1-f65.google.com with SMTP id t8so2644898lfc.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IxUitNmcKfvxEmpW+0pRzzeuEr0YPZuYrEHpJHWrZps=;
        b=XxRSaB971je38Es3NqDcLIfWZ1SCl8b5y1RGBQkjALcmSilmdWzH/Kb1XtER9g9xAe
         tOgqSTmQN8XpR7qv45/xk6j20FCWQKNAdIFvbw23IrvQLXHKwW58SBhBd3JedzFIpqGy
         NL75xI4Zizg+d+SX26HNbQmruSEqEegbgy9LZFLNH57wqZB6ovhYTKgQkV1GSnLIIbQ4
         MMWwNYwY28emh7+BzrPpKGzJnaFXvszJd/iG1dXyH/vPFtN/aW1L4Gy/JFVNU0G/7UDQ
         G1arT3UmKydusR++V6E8KQ07yCF6/fmNELFaXUoxSlWPxN7w0JY2Ly+pJcaOMg/YZ/Hp
         NVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IxUitNmcKfvxEmpW+0pRzzeuEr0YPZuYrEHpJHWrZps=;
        b=TvnoB2J5sKskZFQGgQFhPz1D78vILV0CywR+4AkjAaEOUx1a+AaArJilqeI+zwszcZ
         E/fr7uj81rDch12tRdX1773Kesf4HCLCRtbr/joiBjEKv3VGW0ohe14nqYIYOb35Zv18
         wfld2H+VS436iTLu/3FobE/C/OIwllM6X4sOOFRhLFPAdee3dQ8lc6+2rWyQy/pVOVa3
         mGuOui7DyhztFM7UxTdsW7hAbZbNla7lk9SXssVyY7spYH0FLQi/EzsS06wecosXALKa
         U5nIrH6arUDB2fJg7Y7gKIWR9frCeyXYRU/b/RMrL3U7hdCjejidfBPKjybjDqyOwibD
         o0vg==
X-Gm-Message-State: APjAAAWb9+RnLhrXOZOxCu73glzEFEL26AoPa3Stfu9kruoSAInck758
        HzXbhr2WUHdFl03z//BqKTMJUQ==
X-Google-Smtp-Source: APXvYqyVWeuhoSA/O+G3DzhNvOgbrXwpkQFyR31cuL/wiIZjkSocYvtu1NGSkIm7H4xzDeUZJD7e5g==
X-Received: by 2002:a19:4352:: with SMTP id m18mr3247695lfj.27.1570653709288;
        Wed, 09 Oct 2019 13:41:49 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:48 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 07/15] samples/bpf: add makefile.target for separate CC target build
Date:   Wed,  9 Oct 2019 23:41:26 +0300
Message-Id: <20191009204134.26960-8-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Makefile.target is added only and will be used in
sample/bpf/Makefile later in order to switch cross-compiling to CC
from HOSTCC environment.

The HOSTCC is supposed to build binaries and tools running on the host
afterwards, in order to simplify build or so, like "fixdep" or else.
In case of cross compiling "fixdep" is executed on host when the rest
samples should run on target arch. In order to build binaries for
target arch with CC and tools running on host with HOSTCC, lets add
Makefile.target for simplicity, having definition and routines similar
to ones, used in script/Makefile.host. This allows later add
cross-compilation to samples/bpf with minimum changes.

The tprog stands for target programs built with CC.

Makefile.target contains only stuff needed for samples/bpf, potentially
can be reused later and now needed only for unblocking tricky
samples/bpf cross compilation.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile.target | 75 +++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 samples/bpf/Makefile.target

diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
new file mode 100644
index 000000000000..7621f55e2947
--- /dev/null
+++ b/samples/bpf/Makefile.target
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: GPL-2.0
+# ==========================================================================
+# Building binaries on the host system
+# Binaries are not used during the compilation of the kernel, and intended
+# to be build for target board, target board can be host of course. Added to
+# build binaries to run not on host system.
+#
+# Sample syntax
+# tprogs-y := xsk_example
+# Will compile xsk_example.c and create an executable named xsk_example
+#
+# tprogs-y    := xdpsock
+# xdpsock-objs := xdpsock_1.o xdpsock_2.o
+# Will compile xdpsock_1.c and xdpsock_2.c, and then link the executable
+# xdpsock, based on xdpsock_1.o and xdpsock_2.o
+#
+# Derived from scripts/Makefile.host
+#
+__tprogs := $(sort $(tprogs-y))
+
+# C code
+# Executables compiled from a single .c file
+tprog-csingle	:= $(foreach m,$(__tprogs), \
+			$(if $($(m)-objs),,$(m)))
+
+# C executables linked based on several .o files
+tprog-cmulti	:= $(foreach m,$(__tprogs),\
+			$(if $($(m)-objs),$(m)))
+
+# Object (.o) files compiled from .c files
+tprog-cobjs	:= $(sort $(foreach m,$(__tprogs),$($(m)-objs)))
+
+tprog-csingle	:= $(addprefix $(obj)/,$(tprog-csingle))
+tprog-cmulti	:= $(addprefix $(obj)/,$(tprog-cmulti))
+tprog-cobjs	:= $(addprefix $(obj)/,$(tprog-cobjs))
+
+#####
+# Handle options to gcc. Support building with separate output directory
+
+_tprogc_flags   = $(TPROGS_CFLAGS) \
+                 $(TPROGCFLAGS_$(basetarget).o)
+
+# $(objtree)/$(obj) for including generated headers from checkin source files
+ifeq ($(KBUILD_EXTMOD),)
+ifdef building_out_of_srctree
+_tprogc_flags   += -I $(objtree)/$(obj)
+endif
+endif
+
+tprogc_flags    = -Wp,-MD,$(depfile) $(_tprogc_flags)
+
+# Create executable from a single .c file
+# tprog-csingle -> Executable
+quiet_cmd_tprog-csingle 	= CC  $@
+      cmd_tprog-csingle	= $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ $< \
+		$(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
+$(tprog-csingle): $(obj)/%: $(src)/%.c FORCE
+	$(call if_changed_dep,tprog-csingle)
+
+# Link an executable based on list of .o files, all plain c
+# tprog-cmulti -> executable
+quiet_cmd_tprog-cmulti	= LD  $@
+      cmd_tprog-cmulti	= $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ \
+			  $(addprefix $(obj)/,$($(@F)-objs)) \
+			  $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
+$(tprog-cmulti): $(tprog-cobjs) FORCE
+	$(call if_changed,tprog-cmulti)
+$(call multi_depend, $(tprog-cmulti), , -objs)
+
+# Create .o file from a single .c file
+# tprog-cobjs -> .o
+quiet_cmd_tprog-cobjs	= CC  $@
+      cmd_tprog-cobjs	= $(CC) $(tprogc_flags) -c -o $@ $<
+$(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
+	$(call if_changed_dep,tprog-cobjs)
-- 
2.17.1

