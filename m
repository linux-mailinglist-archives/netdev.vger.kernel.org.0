Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D864366B97E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjAPI4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjAPIzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:55:50 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C6F13D60;
        Mon, 16 Jan 2023 00:55:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y1so29670582plb.2;
        Mon, 16 Jan 2023 00:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5WAPbAs4qNs3+IgrwRS+Oyx6LWS3F6A1afWPeS2gaZE=;
        b=YMhGPwgnK1MFkgW0vtH6zBaFzz+mHKFtGswwQXsNYMp0XXfCCxqhS6BVXZgtGghuVX
         svIKmqYB8fZoeF7kBNLJTzKnFo2nSsfKBqfLBXwc9ZLA1EkIS+Zvho2LuOP4kJJcWVi4
         1HwfaUH0FKokvOsG9nlik8bUTDvegjmhKfy6AzV0e0QzFQBcAOXqNIjP2fxCNJGZYxwp
         XPMYylb/r8Yr0KDDMgfRc2CvE3moG6PJoJC+nfXGTrcLruQ73i6aNf/34TQ1kNQ2HGac
         Bfz29hdQCErq3D3AyoXaNoB5EOMulFrzJU9TLJ0t874bz8m8w7+oW74v8VT+PssqQ/a2
         0uyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WAPbAs4qNs3+IgrwRS+Oyx6LWS3F6A1afWPeS2gaZE=;
        b=YGoJkepdZM4ElfWQT2PJDq/z9phhyuNQnj634LG/QxfwcscvmzGFlIIBbiIulgVdlk
         fL+EffQB7MwM3kwiBsKTrqBaaieeUTZ3SeupHTbZ+4ATo/lLxsI4ND3kMZ6rBbbo2q9R
         Ow1doTc6Gt2zqKZPsmeU9fEa0yZOy8t0ySBYHKOjC7bXTy//LuKB4o3L9zIV+Oqd90Ff
         KS/PzMUO1r2QOj9g1G0erYGFGEA/Wwbfy46Vs8r7K/WesjDq525psBEB/XX1xOAt3ErA
         km7gfcBYMJo0qOgy5B+CyNmNJM+lrSXBuPDGNR/p4u5Sae6q4jsOLF77Bo/68f3u7zp0
         cP+Q==
X-Gm-Message-State: AFqh2kopjIKts2+01hna+5KD8fZcMQKiIG9/bMJeFgRFZyRQtftuyLfS
        s+RUl9YInSrwtea/B1Lr6miHq4Nv6YWPQA==
X-Google-Smtp-Source: AMrXdXvbiLCyZhCCqXfBy8uHXLmCRGhxA639S9jHdFC2k//d9UvckT9BoegeeYFdzv4Y0r2Seas66w==
X-Received: by 2002:a17:90a:4282:b0:223:f131:3604 with SMTP id p2-20020a17090a428200b00223f1313604mr93583016pjg.17.1673859347789;
        Mon, 16 Jan 2023 00:55:47 -0800 (PST)
Received: from Laptop-X1 ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a474700b00219463262desm15945575pjg.39.2023.01.16.00.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 00:55:46 -0800 (PST)
Date:   Mon, 16 Jan 2023 16:55:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
Subject: Re: [PATCHv3 net-next] selftests/net: mv bpf/nat6to4.c to net folder
Message-ID: <Y8URDVVQs9pRrNdU@Laptop-X1>
References: <20221218082448.1829811-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221218082448.1829811-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

May I ask what's the status of this patch? I saw it's deferred[1] but I don't
know what I should do.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20221218082448.1829811-1-liuhangbin@gmail.com/

Thanks
Hangbin

On Sun, Dec 18, 2022 at 04:24:48PM +0800, Hangbin Liu wrote:
> There are some issues with the bpf/nat6to4.c building.
> 
> 1. It use TEST_CUSTOM_PROGS, which will add the nat6to4.o to
>    kselftest-list file and run by common run_tests.
> 2. When building the test via `make -C tools/testing/selftests/
>    TARGETS="net"`, the nat6to4.o will be build in selftests/net/bpf/
>    folder. But in test udpgro_frglist.sh it refers to ../bpf/nat6to4.o.
>    The correct path should be ./bpf/nat6to4.o.
> 3. If building the test via `make -C tools/testing/selftests/ TARGETS="net"
>    install`. The nat6to4.o will be installed to kselftest_install/net/
>    folder. Then the udpgro_frglist.sh should refer to ./nat6to4.o.
> 
> To fix the confusing test path, let's just move the nat6to4.c to net folder
> and build it as TEST_GEN_FILES.
> 
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Tested-by: Björn Töpel <bjorn@kernel.org>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v3: remove unneeded $(OUTPUT)/bpf dir.
> 
> v2: Update the Makefile rules rely on commit 837a3d66d698 ("selftests:
>     net: Add cross-compilation support for BPF programs").
> ---
>  tools/testing/selftests/net/Makefile          | 50 +++++++++++++++++-
>  tools/testing/selftests/net/bpf/Makefile      | 51 -------------------
>  .../testing/selftests/net/{bpf => }/nat6to4.c |  0
>  tools/testing/selftests/net/udpgro_frglist.sh |  8 +--
>  4 files changed, 52 insertions(+), 57 deletions(-)
>  delete mode 100644 tools/testing/selftests/net/bpf/Makefile
>  rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 3007e98a6d64..47314f0b3006 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -75,14 +75,60 @@ TEST_GEN_PROGS += so_incoming_cpu
>  TEST_PROGS += sctp_vrf.sh
>  TEST_GEN_FILES += sctp_hello
>  TEST_GEN_FILES += csum
> +TEST_GEN_FILES += nat6to4.o
>  
>  TEST_FILES := settings
>  
>  include ../lib.mk
>  
> -include bpf/Makefile
> -
>  $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
>  $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
>  $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
>  $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
> +
> +# Rules to generate bpf obj nat6to4.o
> +CLANG ?= clang
> +SCRATCH_DIR := $(OUTPUT)/tools
> +BUILD_DIR := $(SCRATCH_DIR)/build
> +BPFDIR := $(abspath ../../../lib/bpf)
> +APIDIR := $(abspath ../../../include/uapi)
> +
> +CCINCLUDE += -I../bpf
> +CCINCLUDE += -I../../../../usr/include/
> +CCINCLUDE += -I$(SCRATCH_DIR)/include
> +
> +BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
> +
> +MAKE_DIRS := $(BUILD_DIR)/libbpf
> +$(MAKE_DIRS):
> +	mkdir -p $@
> +
> +# Get Clang's default includes on this system, as opposed to those seen by
> +# '-target bpf'. This fixes "missing" files on some architectures/distros,
> +# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> +#
> +# Use '-idirafter': Don't interfere with include mechanics except where the
> +# build would have failed anyways.
> +define get_sys_includes
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> +	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
> +endef
> +
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
> +endif
> +
> +CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> +
> +$(OUTPUT)/nat6to4.o: nat6to4.c $(BPFOBJ) | $(MAKE_DIRS)
> +	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
> +
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
> +	   $(APIDIR)/linux/bpf.h					       \
> +	   | $(BUILD_DIR)/libbpf
> +	$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/     \
> +		    EXTRA_CFLAGS='-g -O0'				       \
> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
> +
> +EXTRA_CLEAN := $(SCRATCH_DIR)
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> deleted file mode 100644
> index 4abaf16d2077..000000000000
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ /dev/null
> @@ -1,51 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0
> -
> -CLANG ?= clang
> -SCRATCH_DIR := $(OUTPUT)/tools
> -BUILD_DIR := $(SCRATCH_DIR)/build
> -BPFDIR := $(abspath ../../../lib/bpf)
> -APIDIR := $(abspath ../../../include/uapi)
> -
> -CCINCLUDE += -I../../bpf
> -CCINCLUDE += -I../../../../../usr/include/
> -CCINCLUDE += -I$(SCRATCH_DIR)/include
> -
> -BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
> -
> -MAKE_DIRS := $(BUILD_DIR)/libbpf $(OUTPUT)/bpf
> -$(MAKE_DIRS):
> -	mkdir -p $@
> -
> -TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
> -all: $(TEST_CUSTOM_PROGS)
> -
> -# Get Clang's default includes on this system, as opposed to those seen by
> -# '-target bpf'. This fixes "missing" files on some architectures/distros,
> -# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> -#
> -# Use '-idirafter': Don't interfere with include mechanics except where the
> -# build would have failed anyways.
> -define get_sys_includes
> -$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> -	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
> -$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
> -endef
> -
> -ifneq ($(CROSS_COMPILE),)
> -CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
> -endif
> -
> -CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> -
> -$(TEST_CUSTOM_PROGS): $(OUTPUT)/%.o: %.c $(BPFOBJ) | $(MAKE_DIRS)
> -	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
> -
> -$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
> -	   $(APIDIR)/linux/bpf.h					       \
> -	   | $(BUILD_DIR)/libbpf
> -	$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/     \
> -		    EXTRA_CFLAGS='-g -O0'				       \
> -		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
> -
> -EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)
> -
> diff --git a/tools/testing/selftests/net/bpf/nat6to4.c b/tools/testing/selftests/net/nat6to4.c
> similarity index 100%
> rename from tools/testing/selftests/net/bpf/nat6to4.c
> rename to tools/testing/selftests/net/nat6to4.c
> diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
> index c9c4b9d65839..0a6359bed0b9 100755
> --- a/tools/testing/selftests/net/udpgro_frglist.sh
> +++ b/tools/testing/selftests/net/udpgro_frglist.sh
> @@ -40,8 +40,8 @@ run_one() {
>  
>  	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
>  	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
> -	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
> -	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
> +	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file nat6to4.o section schedcls/ingress6/nat_6  direct-action
> +	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file nat6to4.o section schedcls/egress4/snat4 direct-action
>          echo ${rx_args}
>  	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
>  
> @@ -88,8 +88,8 @@ if [ ! -f ${BPF_FILE} ]; then
>  	exit -1
>  fi
>  
> -if [ ! -f bpf/nat6to4.o ]; then
> -	echo "Missing nat6to4 helper. Build bpfnat6to4.o selftest first"
> +if [ ! -f nat6to4.o ]; then
> +	echo "Missing nat6to4 helper. Build bpf nat6to4.o selftest first"
>  	exit -1
>  fi
>  
> -- 
> 2.38.1
> 
