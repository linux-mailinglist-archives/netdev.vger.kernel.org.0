Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B707105C29
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKUVm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:42:29 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44924 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKUVm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:42:28 -0500
Received: by mail-pl1-f193.google.com with SMTP id az9so2170238plb.11
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t6UbFd+jsoBUib7qTx+BJ7svX081NKhXcR40/0W3LxE=;
        b=NzfzBTFLLQbShuKd0+1iHPSbgolHJ4OtPiIo3cDBAbu/SkruCzBCsN/endbdxELPdg
         a2BGy0s6vp2YcKj3PofvztX4RQFiTivhdir/N//IVWWRGQ2a6JfQvwJKUa/sAuQPkwBl
         vBzjsu5iH77F4iDXo+o57Y1A0xCR1HoBzEOIXdj4vx1A4uyAlcehU83323iGR7g2J/+T
         uLncB6IFuO9PUxXESW8i/3VrqJSUb5vUYh9h4fhk7GTlwcBXKjqFLvEuw58816PaT84Z
         740FYIO0PN1Pk84xVg5afM3Ai1eLS0aNwBlJYsNwBCTkO/bbIj6cSHCWddN53w5Qr6VY
         QAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t6UbFd+jsoBUib7qTx+BJ7svX081NKhXcR40/0W3LxE=;
        b=ZTv/GddzGZSytH0406A+GvLyIfT2KTZCMLyEgm0FCIguCnvCrCQgWlDOAPec9MtmGe
         DnfrG0+PBTBxG5TutHX5YgGD3wMOl+KQ88RJa0kRMOTzRcq8ljPNfKdJMGhixM9V9gf3
         yEwh9dT6N+gAOsaH+eteomHZzDZh66/nVHp519ZM9J+Ik9cS9bbXal9HvAqfPP9nOEab
         ZIVRhZUt6WUmDRk0shs5tGXp3S3qUwPkEWlmHFrMue2BWY208iH/EziBNzaV1AWkW0uh
         nKgoKWjNeHDQ9DY4f27lpOOoYBB5ImBlM5fIYrtyCVimz8QsHf9/E6XI6711GK/E3o5G
         jyYg==
X-Gm-Message-State: APjAAAVLh6B7MJAsVQK5kavBbxj5yrObH7pEWwOIG59GO+oOwuKCffLI
        mnk5b90ACHJ/K8a0E/cyeujObA==
X-Google-Smtp-Source: APXvYqzbwEqp+od0wOuk1Bhy360HecFCd8C8kLSld7Mxdz+8NHByzGE6CLBQgIGfRr178ZNtj+Y9wA==
X-Received: by 2002:a17:902:854c:: with SMTP id d12mr6529877plo.264.1574372547563;
        Thu, 21 Nov 2019 13:42:27 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 6sm4768899pfy.43.2019.11.21.13.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:42:25 -0800 (PST)
Date:   Thu, 21 Nov 2019 13:42:25 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com, andriin@fb.com
Subject: Re: [PATCH v5 bpf-next 11/15] libbpf: don't use cxx to test_libpf
 target
Message-ID: <20191121214225.GA3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-12-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011002808.28206-12-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11, Ivan Khoronzhuk wrote:
> No need to use C++ for test_libbpf target when libbpf is on C and it
> can be tested with C, after this change the CXXFLAGS in makefiles can
> be avoided, at least in bpf samples, when sysroot is used, passing
> same C/LDFLAGS as for lib.
> 
> Add "return 0" in test_libbpf to avoid warn, but also remove spaces at
> start of the lines to keep same style and avoid warns while apply.
Hey, just spotted this patch, not sure how it slipped through.
The c++ test was there to make sure libbpf can be included and
linked against c++ code (i.e. libbpf headers don't have some c++
keywords/etc).

Any particular reason you were not happy with it? Can we revert it
back to c++ and fix your use-case instead? Alternatively, we can just
remove this test if we don't really care about c++.

> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  tools/lib/bpf/Makefile                         | 18 +++++-------------
>  .../lib/bpf/{test_libbpf.cpp => test_libbpf.c} | 14 ++++++++------
>  2 files changed, 13 insertions(+), 19 deletions(-)
>  rename tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c} (61%)
> 
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 1270955e4845..46280b5ad48d 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -52,7 +52,7 @@ ifndef VERBOSE
>  endif
>  
>  FEATURE_USER = .libbpf
> -FEATURE_TESTS = libelf libelf-mmap bpf reallocarray cxx
> +FEATURE_TESTS = libelf libelf-mmap bpf reallocarray
>  FEATURE_DISPLAY = libelf bpf
>  
>  INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
> @@ -142,15 +142,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN) | \
>  VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
>  			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
>  
> -CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
> -
> -CXX_TEST_TARGET = $(OUTPUT)test_libbpf
> -
> -ifeq ($(feature-cxx), 1)
> -	CMD_TARGETS += $(CXX_TEST_TARGET)
> -endif
> -
> -TARGETS = $(CMD_TARGETS)
> +CMD_TARGETS = $(LIB_TARGET) $(PC_FILE) $(OUTPUT)test_libbpf
>  
>  all: fixdep
>  	$(Q)$(MAKE) all_cmd
> @@ -190,8 +182,8 @@ $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
>  $(OUTPUT)libbpf.a: $(BPF_IN)
>  	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>  
> -$(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
> -	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
> +$(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
> +	$(QUIET_LINK)$(CC) $(INCLUDES) $^ -lelf -o $@
>  
>  $(OUTPUT)libbpf.pc:
>  	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
> @@ -266,7 +258,7 @@ config-clean:
>  	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
>  
>  clean:
> -	$(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
> +	$(call QUIET_CLEAN, libbpf) $(RM) $(CMD_TARGETS) \
>  		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
>  		*.pc LIBBPF-CFLAGS bpf_helper_defs.h
>  	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
> diff --git a/tools/lib/bpf/test_libbpf.cpp b/tools/lib/bpf/test_libbpf.c
> similarity index 61%
> rename from tools/lib/bpf/test_libbpf.cpp
> rename to tools/lib/bpf/test_libbpf.c
> index fc134873bb6d..f0eb2727b766 100644
> --- a/tools/lib/bpf/test_libbpf.cpp
> +++ b/tools/lib/bpf/test_libbpf.c
> @@ -7,12 +7,14 @@
>  
>  int main(int argc, char *argv[])
>  {
> -    /* libbpf.h */
> -    libbpf_set_print(NULL);
> +	/* libbpf.h */
> +	libbpf_set_print(NULL);
>  
> -    /* bpf.h */
> -    bpf_prog_get_fd_by_id(0);
> +	/* bpf.h */
> +	bpf_prog_get_fd_by_id(0);
>  
> -    /* btf.h */
> -    btf__new(NULL, 0);
> +	/* btf.h */
> +	btf__new(NULL, 0);
> +
> +	return 0;
>  }
> -- 
> 2.17.1
> 
