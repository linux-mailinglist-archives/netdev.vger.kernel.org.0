Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1564E83B
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 09:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLPIlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 03:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiLPIlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 03:41:21 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A142D8;
        Fri, 16 Dec 2022 00:41:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so5350784pjr.3;
        Fri, 16 Dec 2022 00:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2uYbHB0sSZ3tOjfiE8uB+ws0Uk0wZ5B+rhVD9Zm2u6Y=;
        b=CvRT8bKmoqn2U384N7HuAFXdUUMm+20BS2q/67mAMoKy1k7rIkASzs7iyy3pl0iNS4
         fnkz4lj4zC85g3E1NdDo/a8ix0hOGqbsgjfy/bb5GDsbJNqi6GVxBbz9LaK6x7GrmY0B
         VKXZHeNp1uL02L8uvEPyeEwjKgrKgAcFP0A34A43bQZQII57ZNrXhE/G+A4hWNICU6EZ
         WJMrfov0+fejf5P/z790/21g2XFW0szzypZLaOmAZ1bHR9b+3mL7UvZi28v7oVXIMrsq
         Vq9Y5Et3Wo7Tjosd/LMhl0r9yR0utQnGLsV3xPhKa+nyXNYMVlW0+HcoX+uUkhQptWed
         yqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2uYbHB0sSZ3tOjfiE8uB+ws0Uk0wZ5B+rhVD9Zm2u6Y=;
        b=nML88qEKsoZT3v+oL1s+AA9q7PhlBdsPvchFjlP/k0wfKe5hiu+uQRW6H6DQXCfzeo
         7DqEp3MV2ly7zubqCpSOgjOFJhYPPEKtZjXRk4vfhdDMG0nvnKxVju9ihEPntcV1C0nn
         RLNCfh8K8oO+Kpu5BVTelH/xAkLFcGe7saFib6rSr93G6i9fHHJNLnvqm9onLuSReOHl
         I9ciHiWCM8ScmsxSXXZDiHztOcpxiPG4HlXvXOnE8k7mCEU/MSdTMRUTDpDMA+IO3lWn
         5ruRnNat3yvlfN2xpicTWkOr3gPBHfqbFEMRqFuHCbi21rsV5VnfxuVA3pn+6omDT3C9
         6bWg==
X-Gm-Message-State: ANoB5pmW7vEYhPMXQHCOq5go9nO6ICbJX1BiOEcflD1ITlNMt/VPN/Lr
        MyaRCTIr/Aodo0ZbyyhT4Rq5vQpcaski0Q==
X-Google-Smtp-Source: AA0mqf5CIIMj93MQ93WNk2fMv2+EDKMZNHUqmnMrnAR/3vyQoaWizqpi/rvs9LT0iroZEMzn0OMvzw==
X-Received: by 2002:a05:6a21:9989:b0:9d:efbe:e608 with SMTP id ve9-20020a056a21998900b0009defbee608mr43735716pzb.36.1671180078780;
        Fri, 16 Dec 2022 00:41:18 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b00188a7bce192sm1006626plg.264.2022.12.16.00.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 00:41:17 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] selftests/net: mv bpf/nat6to4.c to net folder
Date:   Fri, 16 Dec 2022 16:41:09 +0800
Message-Id: <20221216084109.1565213-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
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

v2: Update the Makefile rules rely on commit 837a3d66d698 ("selftests:
net: Add cross-compilation support for BPF programs").

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

I don't know if there is a way to just install a single TEST_GEN_FILES
to a separate folder. If there is, then we don't need to move the files.

---
 tools/testing/selftests/net/Makefile          | 50 +++++++++++++++++-
 tools/testing/selftests/net/bpf/Makefile      | 51 -------------------
 .../testing/selftests/net/{bpf => }/nat6to4.c |  0
 tools/testing/selftests/net/udpgro_frglist.sh |  8 +--
 4 files changed, 52 insertions(+), 57 deletions(-)
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..ed9a315187c1 100644
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
+MAKE_DIRS := $(BUILD_DIR)/libbpf $(OUTPUT)/bpf
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

