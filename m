Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6596213C58F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgAOOPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:15:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56410 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729417AbgAOONG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 09:13:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579097585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpxFK0rlkhyTfyqA9bHWu7DLL4byHWgLPixehsmQCkc=;
        b=R5g7xoSgaFNovKI/mI6d8SsgOXe0+8lwiDkGrRxZZuSSfry2jMIKAkbHp/qmK84G/ZLDZE
        5i+d66u/WVIejuVY+YIPWTPEMHpSQyD67zME54aj7irepptIL4QQhjvetOuAttDDDt8KAP
        kLOtqQ9d5PCUC9cGfkkOLZZ6PY+G2dg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-UE08VA99Nya_hki1iK7a2Q-1; Wed, 15 Jan 2020 09:13:03 -0500
X-MC-Unique: UE08VA99Nya_hki1iK7a2Q-1
Received: by mail-lf1-f69.google.com with SMTP id i29so3243629lfc.18
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 06:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DpxFK0rlkhyTfyqA9bHWu7DLL4byHWgLPixehsmQCkc=;
        b=HQtAaeK/DCmlQ8mWgHBPeAN0gWm5w+SC7U0wKE9ZgUll4RuEPy4P5yKCp2u42yd19X
         rBmq3Vqz7dH6f19YwXiCJOB/Koc5Plnp775aX3n1pyj4J37umS/nFyoIibyLMK2kP/d4
         0W0+Hf/LflqdiJE14Oz4BCAW2keZW9SLXrFO0Tu+iAsXaAP163QoFlPZ4cWt2p/vwrUe
         n8n3oKCwfkDz3BCNosYEis4iNYQnMtUdAzpo9gHsQMjQ2FxR6Udd6k52u6eNYn4BpRUA
         v4+evayZGJ1qRSjHE8gCYvvxPmNyEVulm5l5zBjOg9NDv2uVDuKAlYsaFGl/bB4KdD3x
         HfcQ==
X-Gm-Message-State: APjAAAUGgS6wlADQvbt8tRauHi1G5+s1xXfyFaB1mUOr5v2/l38lHlob
        CS8ufnmZgmspZ6K1YxyiGrBr5Igsb3kjHldP2rGjStf8TxCExrMToRelklKShdslWNZWlKA215k
        eqlIHmMNNY/cK77oR
X-Received: by 2002:a19:5e16:: with SMTP id s22mr4861210lfb.33.1579097581945;
        Wed, 15 Jan 2020 06:13:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHgcSMYdmq2Qpg+smezAqp82lJFIXNVeJddJhi4eCEV0/EIlNjNOhfqiJg4Hs1ey+YlIRk1g==
X-Received: by 2002:a19:5e16:: with SMTP id s22mr4861193lfb.33.1579097581717;
        Wed, 15 Jan 2020 06:13:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i17sm9293135ljd.34.2020.01.15.06.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 06:13:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AA90D1804D8; Wed, 15 Jan 2020 15:12:58 +0100 (CET)
Subject: [PATCH bpf-next v2 09/10] selftests: Remove tools/lib/bpf from
 include path
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Wed, 15 Jan 2020 15:12:58 +0100
Message-ID: <157909757860.1192265.1725940708658939712.stgit@toke.dk>
In-Reply-To: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

To make sure no new files are introduced that doesn't include the bpf/
prefix in its #include, remove tools/lib/bpf from the include path
entirely, and use tools/lib instead. To fix the original issue with
bpf_helper_defs.h being stale, change the Makefile rule to regenerate the
file in the lib/bpf dir instead of having a local copy in selftests.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/.gitignore |    3 ++-
 tools/testing/selftests/bpf/Makefile   |   16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1d14e3ab70be..17dd02651dee 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -33,10 +33,11 @@ libbpf.pc
 libbpf.so.*
 test_hashmap
 test_btf_dump
+test_cgroup_attach
+test_select_reuseport
 xdping
 test_cpp
 *.skel.h
 /no_alu32
 /bpf_gcc
 /tools
-bpf_helper_defs.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index cd98ae875e30..4889cc3ead4b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -21,7 +21,7 @@ LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)  \
-	  -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)			\
+	  -I$(GENDIR) -I$(TOOLSINCDIR)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lz -lrt -lpthread
@@ -129,7 +129,7 @@ $(OUTPUT)/runqslower: force
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	      \
 		    OUTPUT=$(CURDIR)/tools/
 
-BPFOBJ := $(OUTPUT)/libbpf.a
+BPFOBJ := $(BPFDIR)/libbpf.a
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
@@ -155,17 +155,17 @@ force:
 DEFAULT_BPFTOOL := $(OUTPUT)/tools/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 
-$(DEFAULT_BPFTOOL): force
+$(DEFAULT_BPFTOOL): force $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			      \
 		    prefix= DESTDIR=$(OUTPUT)/tools/ install
 
 $(BPFOBJ): force
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BPFDIR)/ $(BPFOBJ)
 
-BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
-$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
+BPF_HELPERS := $(BPFDIR)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
+$(BPFDIR)/bpf_helper_defs.h: $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)			      \
-		    OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
+		OUTPUT=$(BPFDIR)/ $(BPFDIR)/bpf_helper_defs.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -186,7 +186,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
 	     -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi		\
-	     -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
+	     -I$(APIDIR) -I$(LIBDIR) -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types

