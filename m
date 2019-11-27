Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D0510B069
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfK0NjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:39:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43061 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfK0NjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:39:01 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so26735762wra.10
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 05:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eU4VlI4ArP56nCay48Vt2NhXZMRD3ggL2hIZnoXhceQ=;
        b=uExpzpnhHZCBAFD3IcqrWJygCDHGgN5YWhG2Trp7uD2RnNs6F4LCOEOW9qsmZrbv/4
         sfRRoqkGSLnwAdV9oII/3bot1TZshIrhasnvpBLybobh7GqHUB6JnAb4SAxzjOVi1tZR
         JTd1i3oRhWTtX7fuTPRw7n7GK2h+yhK60eHj+lkdhBCpZWSmARvPwZL8Ef5BlkiNAqQ/
         Cfnan/ODgHMKSSSgfc1AJtf4+Z4qQ2kMwDNFqEVZNUPx2nnEdWC40Vm8CuFWMYHuTT9N
         ZUGPLpYWHGvUvEvQU7DX3vE2GfBJBaBMcxQd5CQIqKLwIxtd19Sd9uzcvetTFsdluW6I
         OIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eU4VlI4ArP56nCay48Vt2NhXZMRD3ggL2hIZnoXhceQ=;
        b=NRS+ddvAcoYRWJ3tPNrjA1xnIlBXzt8BYSnjjN1zNIS7p97ZD73zq/C88PcBoHGFik
         WW1UAXh0KOjKbveieQkQRV6kpK7RmqJDnC3dAX1JW49qwzCRgQHXMQ5Nqe7/rN9BnbsH
         kxSYbAQ1iSjdwH/cmWnkcQUgH0pF/r5MzIpU2QivRV79KVTUuzh9X5hWYgl1GY0l2uWD
         C2rT6plmtfD3MQGbAfSsN+q7a0HWiUEp8JjeGsd62si0NBfhhaqYe/Sek0CgC4gbhc6D
         xT71djumF/3HIYuc6hDM4yJCfDxNKZjpnmo58fMHdPOk3sR3XC8eHemX5cq9/pHgOckG
         qtfg==
X-Gm-Message-State: APjAAAWQHl3tJzwASC9R+xRyYFXcHT6riatWffFAdZyLAcBcZzEkVdCs
        PWrQ8CnDkXUmGWQdiPOkIBNN/w==
X-Google-Smtp-Source: APXvYqxDnsF+COHQgRZP9CCHmIMcuL6Ca4nzr7dMlubewqhDVfPTLc7AHyQE/m7fwJdSl2zbtQKWKw==
X-Received: by 2002:adf:f5c2:: with SMTP id k2mr42144936wrp.118.1574861937643;
        Wed, 27 Nov 2019 05:38:57 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id k20sm6430968wmj.10.2019.11.27.05.38.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 05:38:56 -0800 (PST)
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <20191127094837.4045-4-jolsa@kernel.org>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 mQINBFnqRlsBEADfkCdH/bkkfjbglpUeGssNbYr/TD4aopXiDZ0dL2EwafFImsGOWmCIIva2
 MofTQHQ0tFbwY3Ir74exzU9X0aUqrtHirQHLkKeMwExgDxJYysYsZGfM5WfW7j8X4aVwYtfs
 AVRXxAOy6/bw1Mccq8ZMTYKhdCgS3BfC7qK+VYC4bhM2AOWxSQWlH5WKQaRbqGOVLyq8Jlxk
 2FGLThUsPRlXKz4nl+GabKCX6x3rioSuNoHoWdoPDKsRgYGbP9LKRRQy3ZeJha4x+apy8rAM
 jcGHppIrciyfH38+LdV1FVi6sCx8sRKX++ypQc3fa6O7d7mKLr6uy16xS9U7zauLu1FYLy2U
 N/F1c4F+bOlPMndxEzNc/XqMOM9JZu1XLluqbi2C6JWGy0IYfoyirddKpwzEtKIwiDBI08JJ
 Cv4jtTWKeX8pjTmstay0yWbe0sTINPh+iDw+ybMwgXhr4A/jZ1wcKmPCFOpb7U3JYC+ysD6m
 6+O/eOs21wVag/LnnMuOKHZa2oNsi6Zl0Cs6C7Vve87jtj+3xgeZ8NLvYyWrQhIHRu1tUeuf
 T8qdexDphTguMGJbA8iOrncHXjpxWhMWykIyN4TYrNwnyhqP9UgqRPLwJt5qB1FVfjfAlaPV
 sfsxuOEwvuIt19B/3pAP0nbevNymR3QpMPRl4m3zXCy+KPaSSQARAQABtC1RdWVudGluIE1v
 bm5ldCA8cXVlbnRpbi5tb25uZXRAbmV0cm9ub21lLmNvbT6JAj0EEwEIACcFAlnqRlsCGyMF
 CQlmAYAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQNvcEyYwwfB7tChAAqFWG30+DG3Sx
 B7lfPaqs47oW98s5tTMprA+0QMqUX2lzHX7xWb5v8qCpuujdiII6RU0ZhwNKh/SMJ7rbYlxK
 qCOw54kMI+IU7UtWCej+Ps3LKyG54L5HkBpbdM8BLJJXZvnMqfNWx9tMISHkd/LwogvCMZrP
 TAFkPf286tZCIz0EtGY/v6YANpEXXrCzboWEiIccXRmbgBF4VK/frSveuS7OHKCu66VVbK7h
 kyTgBsbfyQi7R0Z6w6sgy+boe7E71DmCnBn57py5OocViHEXRgO/SR7uUK3lZZ5zy3+rWpX5
 nCCo0C1qZFxp65TWU6s8Xt0Jq+Fs7Kg/drI7b5/Z+TqJiZVrTfwTflqPRmiuJ8lPd+dvuflY
 JH0ftAWmN3sT7cTYH54+HBIo1vm5UDvKWatTNBmkwPh6d3cZGALZvwL6lo0KQHXZhCVdljdQ
 rwWdE25aCQkhKyaCFFuxr3moFR0KKLQxNykrVTJIRuBS8sCyxvWcZYB8tA5gQ/DqNKBdDrT8
 F9z2QvNE5LGhWDGddEU4nynm2bZXHYVs2uZfbdZpSY31cwVS/Arz13Dq+McMdeqC9J2wVcyL
 DJPLwAg18Dr5bwA8SXgILp0QcYWtdTVPl+0s82h+ckfYPOmkOLMgRmkbtqPhAD95vRD7wMnm
 ilTVmCi6+ND98YblbzL64YG5Ag0EWepGWwEQAM45/7CeXSDAnk5UMXPVqIxF8yCRzVe+UE0R
 QQsdNwBIVdpXvLxkVwmeu1I4aVvNt3Hp2eiZJjVndIzKtVEoyi5nMvgwMVs8ZKCgWuwYwBzU
 Vs9eKABnT0WilzH3gA5t9LuumekaZS7z8IfeBlZkGXEiaugnSAESkytBvHRRlQ8b1qnXha3g
 XtxyEqobKO2+dI0hq0CyUnGXT40Pe2woVPm50qD4HYZKzF5ltkl/PgRNHo4gfGq9D7dW2OlL
 5I9qp+zNYj1G1e/ytPWuFzYJVT30MvaKwaNdurBiLc9VlWXbp53R95elThbrhEfUqWbAZH7b
 ALWfAotD07AN1msGFCES7Zes2AfAHESI8UhVPfJcwLPlz/Rz7/K6zj5U6WvH6aj4OddQFvN/
 icvzlXna5HljDZ+kRkVtn+9zrTMEmgay8SDtWliyR8i7fvnHTLny5tRnE5lMNPRxO7wBwIWX
 TVCoBnnI62tnFdTDnZ6C3rOxVF6FxUJUAcn+cImb7Vs7M5uv8GufnXNUlsvsNS6kFTO8eOjh
 4fe5IYLzvX9uHeYkkjCNVeUH5NUsk4NGOhAeCS6gkLRA/3u507UqCPFvVXJYLSjifnr92irt
 0hXm89Ms5fyYeXppnO3l+UMKLkFUTu6T1BrDbZSiHXQoqrvU9b1mWF0CBM6aAYFGeDdIVe4x
 ABEBAAGJAiUEGAEIAA8FAlnqRlsCGwwFCQlmAYAACgkQNvcEyYwwfB4QwhAAqBTOgI9k8MoM
 gVA9SZj92vYet9gWOVa2Inj/HEjz37tztnywYVKRCRfCTG5VNRv1LOiCP1kIl/+crVHm8g78
 iYc5GgBKj9O9RvDm43NTDrH2uzz3n66SRJhXOHgcvaNE5ViOMABU+/pzlg34L/m4LA8SfwUG
 ducP39DPbF4J0OqpDmmAWNYyHh/aWf/hRBFkyM2VuizN9cOS641jrhTO/HlfTlYjIb4Ccu9Y
 S24xLj3kkhbFVnOUZh8celJ31T9GwCK69DXNwlDZdri4Bh0N8DtRfrhkHj9JRBAun5mdwF4m
 yLTMSs4Jwa7MaIwwb1h3d75Ws7oAmv7y0+RgZXbAk2XN32VM7emkKoPgOx6Q5o8giPRX8mpc
 PiYojrO4B4vaeKAmsmVer/Sb5y9EoD7+D7WygJu2bDrqOm7U7vOQybzZPBLqXYxl/F5vOobC
 5rQZgudR5bI8uQM0DpYb+Pwk3bMEUZQ4t497aq2vyMLRi483eqT0eG1QBE4O8dFNYdK5XUIz
 oHhplrRgXwPBSOkMMlLKu+FJsmYVFeLAJ81sfmFuTTliRb3Fl2Q27cEr7kNKlsz/t6vLSEN2
 j8x+tWD8x53SEOSn94g2AyJA9Txh2xBhWGuZ9CpBuXjtPrnRSd8xdrw36AL53goTt/NiLHUd
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
Date:   Wed, 27 Nov 2019 13:38:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191127094837.4045-4-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
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
>   Makefile:102: *** Error: libbpf-devel is missing, please install it.  Stop.
> 
> Adding specific bpftool's libbpf check for libbpf_netlink_open (LIBBPF_0.0.6)
> which is the latest we need for bpftool at the moment.
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
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpftool/Makefile        | 40 ++++++++++++++++++++++++++++++-
>  tools/build/feature/test-libbpf.c |  9 +++++++
>  2 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 39bc6f0f4f0b..2b6ed08cb31e 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile

> @@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
>  LDFLAGS += $(EXTRA_LDFLAGS)
>  endif
>  
> -LIBS = $(LIBBPF) -lelf -lz
> +LIBS = -lelf -lz

Hi Jiri,

This change seems to be breaking the build with the static library for
me. I know you add back $(LIBBPF) later in the Makefile, see at the end
of this email...

>  
>  INSTALL ?= install
>  RM ?= rm -f
> @@ -64,6 +73,23 @@ FEATURE_USER = .bpftool
>  FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>  FEATURE_DISPLAY = libbfd disassembler-four-args zlib
>  
> +ifdef LIBBPF_DYNAMIC
> +  # Add libbpf check with the flags to ensure bpftool
> +  # specific version is detected.

Nit: We do not check for a specific bpftool version, we check for a
recent enough libbpf version?

> +  FEATURE_CHECK_CFLAGS-libbpf := -DBPFTOOL
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
> +
>  check_feat := 1
>  NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
>  ifdef MAKECMDGOALS
> @@ -88,6 +114,18 @@ ifeq ($(feature-reallocarray), 0)
>  CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
>  endif
>  
> +ifdef LIBBPF_DYNAMIC
> +  ifeq ($(feature-libbpf), 1)
> +    LIBS    += -lbpf
> +    CFLAGS  += $(LIBBPF_CFLAGS)
> +    LDFLAGS += $(LIBBPF_LDFLAGS)
> +  else
> +    dummy := $(error Error: No libbpf devel library found, please install libbpf-devel)

libbpf-devel sounds like a RH/Fedora package name, but other
distributions might have different names (Debian/Ubuntu would go by
libbpf-dev I suppose, although I don't believe such package exists at
the moment). Maybe use a more generic message?

> +  endif
> +else
> +  LIBS += $(LIBBPF)

... I believe the order of the libraries is relevant, and it seems the
static libbpf should be passed before the dynamic libs. Here I could fix
the build with the static library on my setup by prepending the library
path instead, like this:

	LIBS := $(LIBBPF) $(LIBS)

On the plus side, all build attempts from
tools/testing/selftests/bpf/test_bpftool_build.sh pass successfully on
my setup with dynamic linking from your branch.

> +endif
> +
>  include $(wildcard $(OUTPUT)*.d)
>  
>  all: $(OUTPUT)bpftool

Thanks,
Quentin
