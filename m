Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8B10CBBD
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 16:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfK1PcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 10:32:11 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51692 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK1PcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 10:32:10 -0500
Received: by mail-wm1-f67.google.com with SMTP id g206so11402253wme.1
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 07:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sj9mN9ZsJ6qIK1eZ9BSfajQYDocDuB1NNcBuyqoxXHw=;
        b=j5eEvv9FjEE0wybqoNbFHlnR7Gr1JdZpOkW1jz/puBbCvXCSkJkhNNjJDgxwFFDEGF
         9DP2xImVNYENrdA2Wu+jOCD7Bv4HUoVpDQ232/+Q/8hyW9PxTIvyHsrX68FzVhLOnGDy
         CVhN2MM1o9cmPA+i2nkIuNGTAhd37bhoNUHZyiEkqqk5doJLuzCcO5okGCB/gLYzLNTk
         l7g91K3OG7yLECQgHRwiLR+NUwGTjWALQeV9pPcqfNAaIKuEl6FKHdU1IuI5qPOq8GIO
         lRzMkjP+6OQjCX1ma0ym0NFrjjJQATEg21GB2gYgY/HUvuobaX8WdXJSx0NHmCVIAeKA
         Ap3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sj9mN9ZsJ6qIK1eZ9BSfajQYDocDuB1NNcBuyqoxXHw=;
        b=VhB14YOiYikbbZbIGqZ3mMQvTBHqYNANaySurQd9FrKrD3ZtV1bGgTHPyxh9QhtRPF
         uYNP34fHP8C7rZbuMTbIap8HNAihlEPZtIE0d/dj5vg/fBygeDX1KskNSmQjqWwkUj4H
         d7j956SZpFnWAr+wWSuw7D58mP4T3u7pq9n0wh/mCgPHlThw1GAeZtsaXkedD2L5jk0/
         OhqNVJdNfMpsdps3fcc62Ikg2KjCI0wEWdkqmyC1AIzSsmq/uPmJsiHqUTZxc7XxX78K
         DVCp9cSHpRmxomAzetJn4mIRKldEJlh3GrnYjDqFKnxw/Pl28l69oa2jPArbXlDyeKzM
         AKvA==
X-Gm-Message-State: APjAAAVA5/KYqDFGhmF2jDTxfU0aTEeVZQ19ThLpATmh2vXGPkX6X6nX
        u4VoV/BDxmCyIxS45y7x316kgA==
X-Google-Smtp-Source: APXvYqz+sSgwc/rvUouPPi7gz034nzHWDGhW5QBTeoMWZruGXNtCf8tmqqBpmRnS9wWrGajXIujERQ==
X-Received: by 2002:a7b:c7cc:: with SMTP id z12mr3417400wmk.115.1574955127774;
        Thu, 28 Nov 2019 07:32:07 -0800 (PST)
Received: from [192.168.1.9] ([194.53.187.153])
        by smtp.gmail.com with ESMTPSA id f1sm5364335wrp.93.2019.11.28.07.32.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 07:32:06 -0800 (PST)
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <20191128145316.1044912-1-toke@redhat.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf v2] bpftool: Allow to link libbpf dynamically
Message-ID: <497b4151-9aad-f3a9-3aff-78d665e5f750@netronome.com>
Date:   Thu, 28 Nov 2019 15:32:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191128145316.1044912-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-28 15:53 UTC+0100 ~ Toke Høiland-Jørgensen <toke@redhat.com>
> From: Jiri Olsa <jolsa@kernel.org>
> 
> Currently we support only static linking with kernel's libbpf
> (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
> that triggers libbpf detection and bpf dynamic linking:
> 
>   $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=1
> 
> If libbpf is not installed, build (with LIBBPF_DYNAMIC=1) stops with:
> 
>   $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=1
>     Auto-detecting system features:
>     ...                        libbfd: [ on  ]
>     ...        disassembler-four-args: [ on  ]
>     ...                          zlib: [ on  ]
>     ...                        libbpf: [ OFF ]
> 
>   Makefile:102: *** Error: No libbpf devel library found, please install-devel or libbpf-dev.
> 
> Adding LIBBPF_DIR compile variable to allow linking with
> libbpf installed into specific directory:
> 
>   $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
> 
> It might be needed to clean build tree first because features
> framework does not detect the change properly:
> 
>   $ make -C tools/build/feature clean
>   $ make -C tools/bpf/bpftool/ clean
> 
> Since bpftool uses bits of libbpf that are not exported as public API in
> the .so version, we also pass in libbpf.a to the linker, which allows it to
> pick up the private functions from the static library without having to
> expose them as ABI.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v2:
>   - Pass .a file to linker when dynamically linking, so bpftool can use
>     private functions from libbpf without exposing them as API.
>     
>  tools/bpf/bpftool/Makefile | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 39bc6f0f4f0b..397051ed9e41 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -1,6 +1,15 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +# LIBBPF_DYNAMIC to enable libbpf dynamic linking.
> +
>  include ../../scripts/Makefile.include
>  include ../../scripts/utilities.mak
> +include ../../scripts/Makefile.arch
> +
> +ifeq ($(LP64), 1)
> +  libdir_relative = lib64
> +else
> +  libdir_relative = lib
> +endif
>  
>  ifeq ($(srctree),)
>  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> @@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
>  LDFLAGS += $(EXTRA_LDFLAGS)
>  endif
>  
> -LIBS = $(LIBBPF) -lelf -lz
> +LIBS = -lelf -lz

Hi Toke,

You don't need to remove $(LIBBPF) here, because you add it in both
cases below (whether $(LIBBPF_DYNAMIC) is defined or not).

>  
>  INSTALL ?= install
>  RM ?= rm -f
> @@ -63,6 +72,19 @@ RM ?= rm -f
>  FEATURE_USER = .bpftool
>  FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>  FEATURE_DISPLAY = libbfd disassembler-four-args zlib
> +ifdef LIBBPF_DYNAMIC
> +  FEATURE_TESTS   += libbpf
> +  FEATURE_DISPLAY += libbpf
> +
> +  # for linking with debug library run:
> +  # make LIBBPF_DYNAMIC=1 LIBBPF_DIR=/opt/libbpf
> +  ifdef LIBBPF_DIR
> +    LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
> +    LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(libdir_relative)
> +    FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
> +    FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
> +  endif
> +endif
>  
>  check_feat := 1
>  NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
> @@ -88,6 +110,20 @@ ifeq ($(feature-reallocarray), 0)
>  CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
>  endif
>  
> +ifdef LIBBPF_DYNAMIC
> +  ifeq ($(feature-libbpf), 1)
> +    # bpftool uses non-exported functions from libbpf, so pass both dynamic and
> +    # static versions and let the linker figure it out
> +    LIBS    := -lbpf $(LIBBPF) $(LIBS)

[$(LIBBPF) added to $(LIBS) here...]

> +    CFLAGS  += $(LIBBPF_CFLAGS)
> +    LDFLAGS += $(LIBBPF_LDFLAGS)
> +  else
> +    dummy := $(error Error: No libbpf devel library found, please install-devel or libbpf-dev.)

“install-devel” :)

> +  endif
> +else
> +  LIBS := $(LIBBPF) $(LIBS)

[... and here]

> +endif
> +
>  include $(wildcard $(OUTPUT)*.d)
>  
>  all: $(OUTPUT)bpftool
> 

Thanks,
Quentin
