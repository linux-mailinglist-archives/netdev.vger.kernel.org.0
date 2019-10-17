Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02A0DB1E8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfJQQHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:07:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41207 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfJQQHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 12:07:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so1938681pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 09:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m/BUBjtaBfaJxhvaRc4enQkwLP6kIWFXEbRnBKTWtNI=;
        b=vgMV9FXAYMqvbxY9a+XZooF/umoxaDsWnndeSRy9ZlAnj23ML8kL/N+8HS4bjh2Ybe
         KEfOGa5VYkjQNAMPEYZbySppxSFNucgFuLRGjVDpWzFOz5EGyk78WTsurIkkgG6GDIA0
         YDgg0bmJHzAV3znMc1N9xogKaQ99qAR31Yhyr5ycFVKmRhBR5KQXVM/y1ym6FsMZ+1yk
         uBWMRzA2QWEw/rFutlr1FfHiKLpAcAVB6W6Vg18LDLYB8DiMVd8RHxeirBoS6I2+tw9W
         kONfmLoDXuSTcK00siiNgWbHqzygtxAGai0l47lbu1w8pNAEK4MOWfI4sb1KVQg+j0Ey
         e9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m/BUBjtaBfaJxhvaRc4enQkwLP6kIWFXEbRnBKTWtNI=;
        b=fbPnazLSRFdzw+0qmI0Zv4vOwue+VT4dK8sMcacY+sR0YrRn3Y4d8FK8toLgYWFl6T
         oKKaOyqFE61RuVW6bcKCpqbO7pEIakXpajHGwq+DscjXss0yD+bm5FJ1sk+V0pX+ruea
         Mef65G+6TgTQImcU7MjrhHpmCy5TspNY3NhOP66y8INu7ytz2yynkuEYX+8cN4emIp7i
         8/wUBd5kaak3hY6ZM5WLcut2nzKOKyBSfJcfT0HOxe+UwjO3UpRYOY8hcielk/x5iFoO
         p68VTUbf02krC+HmHlMoNtO9lcxwEC+2WHmpROus16NVLKO+6znux5mtFfgc3+sCo2LZ
         0HSA==
X-Gm-Message-State: APjAAAXmirUu0MeAQ3diX1bIazx9KAecJYUDNH5JLCLSvB3VuuCJ4Suj
        dm6d5sY8paUaYIkn3SZ1rZ14Sw==
X-Google-Smtp-Source: APXvYqx6eNsDg07gMsRQiVZ9KtoMBNamjIbcZEsVR9p4AevOO/a+gzUGrqPOG6IrF3zGkD/lAfgwcw==
X-Received: by 2002:aa7:9acb:: with SMTP id x11mr1020992pfp.249.1571328438201;
        Thu, 17 Oct 2019 09:07:18 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r21sm6259475pfc.27.2019.10.17.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 09:07:17 -0700 (PDT)
Date:   Thu, 17 Oct 2019 09:07:16 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Message-ID: <20191017160716.GA2090@mini-arch>
References: <20191016060051.2024182-1-andriin@fb.com>
 <20191016060051.2024182-6-andriin@fb.com>
 <20191016163249.GD1897241@mini-arch>
 <CAEf4BzYVWc8RWNSthN8whROYJUEijR1Uh3Lyt6bkuhM2tRsq2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYVWc8RWNSthN8whROYJUEijR1Uh3Lyt6bkuhM2tRsq2Q@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16, Andrii Nakryiko wrote:
> On Wed, Oct 16, 2019 at 9:32 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/15, Andrii Nakryiko wrote:
> > > Define test runner generation meta-rule that codifies dependencies
> > > between test runner, its tests, and its dependent BPF programs. Use that
> > > for defining test_progs and test_maps test-runners. Also additionally define
> > > 2 flavors of test_progs:
> > > - alu32, which builds BPF programs with 32-bit registers codegen;
> > > - bpf_gcc, which build BPF programs using GCC, if it supports BPF target.
> > Question:
> >
> > Why not merge test_maps tests into test_progs framework and have a
> > single binary instead of doing all this makefile-related work?
> > We can independently address the story with alu32/gcc progs (presumably
> > in the same manner, with make defines).
> 
> test_maps wasn't a reason for doing this, alue2/bpf_gcc was. test_maps
> is a simple sub-case that was just easy to convert to. I dare you to
> try solve alu32/bpf_gcc with make defines (whatever you mean by that)
> and in a simpler manner ;)
I think my concern comes from the fact that I don't really understand why
we need all that complexity (and the problem you're solving for alu/gcc;
part of that is that you're replacing everything, so it's hard to
understand what's the real diff).

In particular, why do we need to compile test_progs 3 times for
normal/alu32/gcc? Isn't it the same test_progs? Can we just teach test_progs
to run the tests for 3 output dirs with different versions of BPF programs?
(kind of like you do in your first patch with -<flavor>, but just in a loop).

> > I can hardly follow the existing makefile and now with the evals it's
> > 10x more complicated for no good reason.
> 
> I agree that existing Makefile logic is hard to follow, especially
> given it's broken. But I think 10x more complexity is gross
> exaggeration and just means you haven't tried to follow rules' logic.
Not 10x, but it does raise a complexity bar. I tried to follow the
rules, but I admit that I didn't try too hard :-)

> The rules inside DEFINE_TEST_RUNNER_RULES are exactly (minus one or
> two ifs to prevent re-definition of target) the rules that should have
> been written for test_progs, test_progs-alu32, test_progs-bpf_gcc.
> They define a chain of BPF .c -> BPF .o -> tests .c -> tests .o ->
> final binary + test.h generation. Previously we were getting away with
> this for, e.g., test_progs-alu32, because we always also built
> test_progs in parallel, which generated necessary stuff. Now with
> recent changes to test_attach_probe.c which now embeds BPF .o file,
> this doesn't work anymore. And it's going to be more and more
> prevalent form, so we need to fix it.
> 
> Surely $(eval) and $(call) are not common for simple Makefiles, but
> just ignore it, we need that to only dynamically generate
> per-test-runner rules. DEFINE_TEST_RUNNER_RULES can be almost read
> like a normal Makefile definitions, module $$(VAR) which is turned
> into a normal $(VAR) upon $(call) evaluation.
> 
> But really, I'd like to be wrong and if there is simpler way to
> achieve the same - go for it, I'll gladly review and ack.
Again, it probably comes from the fact that I don't see the problem
you're solving. Can we start by removing 3 test_progs variations
(somthing like patch below)? If we can do it, then the leftover parts
that generate alu32/gcc bpf program don't look too bad and can probably
be tweaked without makefile codegen.

--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -157,26 +157,10 @@ TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
 
 ifneq ($(SUBREG_CODEGEN),)
 ALU32_BUILD_DIR = $(OUTPUT)/alu32
-TEST_CUSTOM_PROGS += $(ALU32_BUILD_DIR)/test_progs_32
 $(ALU32_BUILD_DIR):
 	mkdir -p $@
 
-$(ALU32_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read | $(ALU32_BUILD_DIR)
-	cp $< $@
-
-$(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
-						$(ALU32_BUILD_DIR)/urandom_read \
-						| $(ALU32_BUILD_DIR)
-	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) \
-		-o $(ALU32_BUILD_DIR)/test_progs_32 \
-		test_progs.c test_stub.c cgroup_helpers.c trace_helpers.c prog_tests/*.c \
-		$(OUTPUT)/libbpf.a $(LDLIBS)
-
-$(ALU32_BUILD_DIR)/test_progs_32: $(PROG_TESTS_H)
-$(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
-
-$(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR)/test_progs_32 \
-					| $(ALU32_BUILD_DIR)
+$(ALU32_BUILD_DIR)/%.o: progs/%.c | $(ALU32_BUILD_DIR)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=probe -mattr=+alu32 $(LLC_FLAGS) \
@@ -194,19 +178,10 @@ MENDIAN=-mlittle-endian
 endif
 BPF_GCC_CFLAGS = $(GCC_SYS_INCLUDES) $(MENDIAN)
 BPF_GCC_BUILD_DIR = $(OUTPUT)/bpf_gcc
-TEST_CUSTOM_PROGS += $(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc
 $(BPF_GCC_BUILD_DIR):
 	mkdir -p $@
 
-$(BPF_GCC_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read | $(BPF_GCC_BUILD_DIR)
-	cp $< $@
-
-$(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc: $(OUTPUT)/test_progs \
-					 | $(BPF_GCC_BUILD_DIR)
-	cp $< $@
-
-$(BPF_GCC_BUILD_DIR)/%.o: progs/%.c $(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc \
-			  | $(BPF_GCC_BUILD_DIR)
+$(BPF_GCC_BUILD_DIR)/%.o: progs/%.c | $(BPF_GCC_BUILD_DIR)
 	$(BPF_GCC) $(BPF_CFLAGS) $(BPF_GCC_CFLAGS) -O2 -c $< -o $@
 endif
 
> Please truncate irrelevant parts, easier to review.
Sure, will do, but I always forget because I don't have this problem.
In mutt I can press shift+s to jump to the next unquoted section.
