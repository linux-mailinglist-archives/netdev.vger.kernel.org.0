Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87764FE14
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 09:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiLRIZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 03:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiLRIZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 03:25:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4156BD2D4;
        Sun, 18 Dec 2022 00:24:59 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f9so4347041pgf.7;
        Sun, 18 Dec 2022 00:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=swPox1nBTAr/nXQSupIO8X5V1jByvJ8pwcZW/GJ1hUM=;
        b=gSP5BnnZtoW9DDzn1XvXpRertfJ7K4w01QVnD8WbBD6+KMrjvGioSzqMLolAwqEYpk
         LiccHd0h8imfjdML9lYDwhCb9GfQkZNfKVmeU8XEPzJ/82xOgASbJe6JsWng1xcQ+t1o
         AIeqPbLkDSGPWn/Y5Z3iUVCd95AhyUgfERUXt3mwtL6UqGgTr8lu10AcjfnTMl8II26m
         YpU7F77pceGP4lY/a0VEJXzqFTSH7lhX1ww3t0lSPvTVhv5RXW3JHYWSuFfyIkh7MHT5
         PSbkdGs/XmuKk94ZYSFKCAn12jOKPC7EN1p/jNu14inyuQVekScH1zslzOx7rDAd6+Ny
         It8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swPox1nBTAr/nXQSupIO8X5V1jByvJ8pwcZW/GJ1hUM=;
        b=WX4Dz6F+oMAySaSuCvc9HZdtWI6WtgJ1X5YzA4ZcXl9sXp0qrthjfUnW0SL9MWINb7
         8/JhBbP6N9yIax0fXGmOMj2z3qwPbQ5NrkyP4KS+QLqDawVretDgD/oa62/hzdzqACZx
         8A8l49DuXOF0dFedLRr8GwEtlZ3Q+LluwQ6lR9QDSFyI8X3UOP6wTsu1Bx+eM7a8Xqnt
         e7x+ABJT/5HPEsvxdOZkVTylxZvkuetrn/qNDh0Cd9e7tENw2j1dCqcb20NCqIdLwx7s
         4ol7msU7voMlNSEhtR7nsvln0KhxwuNwYvsP02LtNiRJmNANCnbxRGUgDq6PwKn3kz+5
         yzNg==
X-Gm-Message-State: ANoB5plHv5duXoisy3VMXXx+ihmiFl4unkznTlrRvbYcBrPQvY+YuY7e
        LAZcB/vVjxzmj5JetJ9N/5bOELsOddFAMQ==
X-Google-Smtp-Source: AA0mqf56k7qSvP3f+LYJbsSDL2OaKdHwQPviC6fGWKHPVnDDenMU5Ml+7jgqlO7xegdqxVrF/Hos2w==
X-Received: by 2002:aa7:96f2:0:b0:576:bb87:f2f7 with SMTP id i18-20020aa796f2000000b00576bb87f2f7mr39122651pfq.12.1671351898166;
        Sun, 18 Dec 2022 00:24:58 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h10-20020aa796ca000000b00571cdbd0771sm4200885pfq.102.2022.12.18.00.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 00:24:57 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
Subject: [PATCHv3 net-next] selftests/net: mv bpf/nat6to4.c to net folder
Date:   Sun, 18 Dec 2022 16:24:48 +0800
Message-Id: <20221218082448.1829811-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some issues with the bpf/nat6to4.c building.

1. It use TEST_CUSTOM_PROGS, which will add the nat6to4.o to
   kselftest-list file and run by common run_tests.
2. When building the test via `make -C tools/testing/selftests/
   TARGETS="net"`, the nat6to4.o will be build in selftests/net/bpf/
   folder. But in test udpgro_frglist.sh it refers to ../bpf/nat6to4.o.
   The correct path should be ./bpf/nat6to4.o.
3. If building the test via `make -C tools/testing/selftests/ TARGETS="net"
   install`. The nat6to4.o will be installed to kselftest_install/net/
   folder. Then the udpgro_frglist.sh should refer to ./nat6to4.o.

To fix the confusing test path, let's just move the nat6to4.c to net folder
and build it as TEST_GEN_FILES.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Tested-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: remove unneeded $(OUTPUT)/bpf dir.

v2: Update the Makefile rules rely on commit 837a3d66d698 ("selftests:
    net: Add cross-compilation support for BPF programs").
---
 tools/testing/selftests/net/Makefile          | 50 +++++++++++++++++-
 tools/testing/selftests/net/bpf/Makefile      | 51 -------------------
 .../testing/selftests/net/{bpf => }/nat6to4.c |  0
 tools/testing/selftests/net/udpgro_frglist.sh |  8 +--
 4 files changed, 52 insertions(+), 57 deletions(-)
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..47314f0b3006 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -75,14 +75,60 @@ TEST_GEN_PROGS += so_incoming_cpu
 TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
+TEST_GEN_FILES += nat6to4.o
 
 TEST_FILES := settings
 
 include ../lib.mk
 
-include bpf/Makefile
-
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
 $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
+
+# Rules to generate bpf obj nat6to4.o
+CLANG ?= clang
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+BPFDIR := $(abspath ../../../lib/bpf)
+APIDIR := $(abspath ../../../include/uapi)
+
+CCINCLUDE += -I../bpf
+CCINCLUDE += -I../../../../usr/include/
+CCINCLUDE += -I$(SCRATCH_DIR)/include
+
+BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
+
+MAKE_DIRS := $(BUILD_DIR)/libbpf
+$(MAKE_DIRS):
+	mkdir -p $@
+
+# Get Clang's default includes on this system, as opposed to those seen by
+# '-target bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
+define get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
+
+$(OUTPUT)/nat6to4.o: nat6to4.c $(BPFOBJ) | $(MAKE_DIRS)
+	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
+	   $(APIDIR)/linux/bpf.h					       \
+	   | $(BUILD_DIR)/libbpf
+	$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/     \
+		    EXTRA_CFLAGS='-g -O0'				       \
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
+EXTRA_CLEAN := $(SCRATCH_DIR)
diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
deleted file mode 100644
index 4abaf16d2077..000000000000
--- a/tools/testing/selftests/net/bpf/Makefile
+++ /dev/null
@@ -1,51 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-
-CLANG ?= clang
-SCRATCH_DIR := $(OUTPUT)/tools
-BUILD_DIR := $(SCRATCH_DIR)/build
-BPFDIR := $(abspath ../../../lib/bpf)
-APIDIR := $(abspath ../../../include/uapi)
-
-CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../../../usr/include/
-CCINCLUDE += -I$(SCRATCH_DIR)/include
-
-BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
-
-MAKE_DIRS := $(BUILD_DIR)/libbpf $(OUTPUT)/bpf
-$(MAKE_DIRS):
-	mkdir -p $@
-
-TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
-all: $(TEST_CUSTOM_PROGS)
-
-# Get Clang's default includes on this system, as opposed to those seen by
-# '-target bpf'. This fixes "missing" files on some architectures/distros,
-# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
-#
-# Use '-idirafter': Don't interfere with include mechanics except where the
-# build would have failed anyways.
-define get_sys_includes
-$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
-endef
-
-ifneq ($(CROSS_COMPILE),)
-CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
-endif
-
-CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
-
-$(TEST_CUSTOM_PROGS): $(OUTPUT)/%.o: %.c $(BPFOBJ) | $(MAKE_DIRS)
-	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
-
-$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
-	   $(APIDIR)/linux/bpf.h					       \
-	   | $(BUILD_DIR)/libbpf
-	$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/     \
-		    EXTRA_CFLAGS='-g -O0'				       \
-		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
-
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)
-
diff --git a/tools/testing/selftests/net/bpf/nat6to4.c b/tools/testing/selftests/net/nat6to4.c
similarity index 100%
rename from tools/testing/selftests/net/bpf/nat6to4.c
rename to tools/testing/selftests/net/nat6to4.c
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index c9c4b9d65839..0a6359bed0b9 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -40,8 +40,8 @@ run_one() {
 
 	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
 	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
-	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
-	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file nat6to4.o section schedcls/ingress6/nat_6  direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file nat6to4.o section schedcls/egress4/snat4 direct-action
         echo ${rx_args}
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
@@ -88,8 +88,8 @@ if [ ! -f ${BPF_FILE} ]; then
 	exit -1
 fi
 
-if [ ! -f bpf/nat6to4.o ]; then
-	echo "Missing nat6to4 helper. Build bpfnat6to4.o selftest first"
+if [ ! -f nat6to4.o ]; then
+	echo "Missing nat6to4 helper. Build bpf nat6to4.o selftest first"
 	exit -1
 fi
 
-- 
2.38.1

