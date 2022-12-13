Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABC464B03A
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiLMHMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiLMHMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:12:24 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34574193D2;
        Mon, 12 Dec 2022 23:12:22 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h33so9820250pgm.9;
        Mon, 12 Dec 2022 23:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rj1UBUKaY6rtQ9I5885ZHn2hBS1jlgAWFKKXV1FV4G8=;
        b=FogQtRIqMaFHiQ0Yxu4UGVwdcZliCagyo2DTjTb4dWtxlZo1Qiynn93U3NalTJZ8C4
         tnoHx2XyJ/JQRNm9WCaOT0p8frhTEJmss1UtLvz8Rxm1czdvW7o00R6rbRtOE7m9V+rg
         K5XDB1GQfCJlJtfZIFleD540XTir5MXz8SE9K7XbWRy3id2T9ID++6HWCLUwTyZiddsA
         Lz7g81p3DHy1qkQyKhSKkFfuYZAdq3ZXmt2KH5KQ6vPgblm8e2Ypr4LGzi4o2aJ8POoD
         NpocwzmPt1/h3A+BZwn3teA0HPqLDph3ISpfF15B00yc7PxGAYRovY7bNniFtA/0ZtAg
         KMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rj1UBUKaY6rtQ9I5885ZHn2hBS1jlgAWFKKXV1FV4G8=;
        b=UhNjzp+KCX2kJtVzQAAUmF4hL4gC9SFfAQo6OYapGHafb1Fjn79++cgNZ0lgvvEp6l
         uxU0Nj6rBAdHOUkg+cvWlvIY05TBuwoR0CeOFkAV9n2HGA/4BKxLZIb+a1DIgqeydyQj
         OMj2G7ghwrUh1A4kw6cM0no63mpf9y8bdlHX5nXV6E1eEJZz4pckfRzPK148wDMWT3zH
         jWjM35UZl6AB7lWHXtU0P1YdhGNsC0PSr+6HQvPfvGzluD735SplnOXmgOAdlO5RQlQh
         rMQwxjqnmuP2gQa5L1ypDfXbYjdS1VxZ+ZdZiW2gAlagowNrQewrahDiXGyExmfQq+V8
         kDSw==
X-Gm-Message-State: ANoB5pnbFPbhDtHDtR5wTncuYn6kGyWQF7XfHQJQzGkQh5FeFHaL8A3o
        HAfc0LDdphV8sid9UneqT9AtBoOBTeitOnPh
X-Google-Smtp-Source: AA0mqf7X0A3350WK/Vi9eoSNzAqbd/5dScS4mBUkLGcF+RcqQH3i7qG0gJj975gQ/8RIPQs5eFEH4Q==
X-Received: by 2002:a62:e50e:0:b0:574:9e66:1bce with SMTP id n14-20020a62e50e000000b005749e661bcemr17668697pff.5.1670915540753;
        Mon, 12 Dec 2022 23:12:20 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c7-20020aa79527000000b0057255b82bd1sm6904345pfp.217.2022.12.12.23.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 23:12:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/net: mv bpf/nat6to4.c to net folder
Date:   Tue, 13 Dec 2022 15:12:11 +0800
Message-Id: <20221213071211.1208297-1-liuhangbin@gmail.com>
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

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile            | 11 +++++++++--
 tools/testing/selftests/net/bpf/Makefile        | 14 --------------
 tools/testing/selftests/net/{bpf => }/nat6to4.c |  0
 tools/testing/selftests/net/udpgro_frglist.sh   |  6 +++---
 4 files changed, 12 insertions(+), 19 deletions(-)
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 69c58362c0ed..d1495107a320 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -71,14 +71,21 @@ TEST_GEN_FILES += bind_bhash
 TEST_GEN_PROGS += sk_bind_sendto_listen
 TEST_GEN_PROGS += sk_connect_zero_addr
 TEST_PROGS += test_ingress_egress_chaining.sh
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
+CLANG ?= clang
+CCINCLUDE += -I../bpf
+CCINCLUDE += -I../../../lib
+CCINCLUDE += -I../../../../usr/include/
+
+$(OUTPUT)/nat6to4.o: nat6to4.c
+	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
deleted file mode 100644
index 8ccaf8732eb2..000000000000
--- a/tools/testing/selftests/net/bpf/Makefile
+++ /dev/null
@@ -1,14 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-
-CLANG ?= clang
-CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../../lib
-CCINCLUDE += -I../../../../../usr/include/
-
-TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
-all: $(TEST_CUSTOM_PROGS)
-
-$(OUTPUT)/%.o: %.c
-	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
-
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
diff --git a/tools/testing/selftests/net/bpf/nat6to4.c b/tools/testing/selftests/net/nat6to4.c
similarity index 100%
rename from tools/testing/selftests/net/bpf/nat6to4.c
rename to tools/testing/selftests/net/nat6to4.c
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index c9c4b9d65839..4f58444c90a1 100755
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
 
@@ -88,7 +88,7 @@ if [ ! -f ${BPF_FILE} ]; then
 	exit -1
 fi
 
-if [ ! -f bpf/nat6to4.o ]; then
+if [ ! -f nat6to4.o ]; then
 	echo "Missing nat6to4 helper. Build bpfnat6to4.o selftest first"
 	exit -1
 fi
-- 
2.38.1

