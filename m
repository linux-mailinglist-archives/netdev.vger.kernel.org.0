Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A0E10B153
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 15:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfK0O3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 09:29:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52080 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfK0O3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 09:29:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id g206so7323914wme.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 06:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ktTNh7pAVmpeFvai616hBnxhc67fQxq08tyEvcv/lI=;
        b=OvEEWwZYd6ItGnQ1O+7FM2NU0gLj1kSNxXNIFNMmYbJ/7E8otQKxQhCIo3KM4vZvLb
         Gg2bu1aqoqjMiPq6iNMWzSXxjejv9YUIQOQjWixaTH8dyf13Tn9hiOyWXfg3Vw2cj+2/
         G6AcEXeCDUmjB3uC4EuAgld7qW4yd09w2h/tfyHsVWUz7o4VtMyP9q/PWcX5u5pA/n4j
         uumgDHZbVrFKy9gQzk5nA9z8x+649A1Fm3T+A6eTSGZ885mNY4eMObbBkIZEqANh9fZr
         ITf8bsi2HiTbItBhzxQyzerOnqwbOhh63iUCznE8/I7s0X0DHbbEdEErC7tQ7zmuPXhA
         gxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6ktTNh7pAVmpeFvai616hBnxhc67fQxq08tyEvcv/lI=;
        b=U1cZEmqE5X+Ex1u7b5hJjWboasijLoxx8tZSXaoS5ZZlCp6tlFCDqD5xgRJSQ6E6Dz
         B1parcwAZNLF4v4lBF1AugJTCCL4QNEcuK+zMdQvNxe+A7klxuhqcWVT4g0oWY4PybYQ
         +YCW6pI4tWSoWK92VZaFEo4/YwVTa2noXy9y3XKnwVEJoZEjVt+3cYOrM64q8LNZK9bV
         dqXh/NiodiHZWQeEWEM2dZ/PLsSrwOrSEOthi6l6cwVcFk6G/Q8YCuLvZkWBk5K0XHtH
         6eDFHcRmoMoP89pusQQvmtuV1pgblSpRRe4t18FmTuje56gBKLqHfkYQitBpEmUOEMZb
         VvXQ==
X-Gm-Message-State: APjAAAVlyil7TroNOHlT+glWVGRIP6MvdnmUqIyBYjEF34E6Udspr1yI
        If27vkfh4vkx+468f0NPHu92ww==
X-Google-Smtp-Source: APXvYqzlp8eeeZ71RqUXxkF6r08zeKxESu+H+f1UvD6eEIFH+9qxNqFR+74QzRGY0pY/AtImE1uqvg==
X-Received: by 2002:a1c:4944:: with SMTP id w65mr4534611wma.39.1574864987159;
        Wed, 27 Nov 2019 06:29:47 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id 19sm21859098wrc.47.2019.11.27.06.29.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 06:29:46 -0800 (PST)
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
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
 <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
 <20191127141520.GJ32367@krava>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <236360cb-2597-85d6-d5ac-0ba0aa71d4cc@netronome.com>
Date:   Wed, 27 Nov 2019 14:29:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191127141520.GJ32367@krava>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-27 15:15 UTC+0100 ~ Jiri Olsa <jolsa@redhat.com>
> On Wed, Nov 27, 2019 at 01:38:55PM +0000, Quentin Monnet wrote:
>> 2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
>>> Currently we support only static linking with kernel's libbpf
>>> (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
>>> that triggers libbpf detection and bpf dynamic linking:
>>>
>>>   $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=1
>>>
>>> If libbpf is not installed, build (with LIBBPF_DYNAMIC=1) stops with:
>>>
>>>   $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=1
>>>     Auto-detecting system features:
>>>     ...                        libbfd: [ on  ]
>>>     ...        disassembler-four-args: [ on  ]
>>>     ...                          zlib: [ on  ]
>>>     ...                        libbpf: [ OFF ]
>>>
>>>   Makefile:102: *** Error: libbpf-devel is missing, please install it.  Stop.
>>>
>>> Adding specific bpftool's libbpf check for libbpf_netlink_open (LIBBPF_0.0.6)
>>> which is the latest we need for bpftool at the moment.
>>>
>>> Adding LIBBPF_DIR compile variable to allow linking with
>>> libbpf installed into specific directory:
>>>
>>>   $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
>>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
>>>
>>> It might be needed to clean build tree first because features
>>> framework does not detect the change properly:
>>>
>>>   $ make -C tools/build/feature clean
>>>   $ make -C tools/bpf/bpftool/ clean
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>  tools/bpf/bpftool/Makefile        | 40 ++++++++++++++++++++++++++++++-
>>>  tools/build/feature/test-libbpf.c |  9 +++++++
>>>  2 files changed, 48 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>>> index 39bc6f0f4f0b..2b6ed08cb31e 100644
>>> --- a/tools/bpf/bpftool/Makefile
>>> +++ b/tools/bpf/bpftool/Makefile
>>
>>> @@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
>>>  LDFLAGS += $(EXTRA_LDFLAGS)
>>>  endif
>>>  
>>> -LIBS = $(LIBBPF) -lelf -lz
>>> +LIBS = -lelf -lz
>>
>> Hi Jiri,
>>
>> This change seems to be breaking the build with the static library for
>> me. I know you add back $(LIBBPF) later in the Makefile, see at the end
>> of this email...
>>
>>>  
>>>  INSTALL ?= install
>>>  RM ?= rm -f
>>> @@ -64,6 +73,23 @@ FEATURE_USER = .bpftool
>>>  FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>>>  FEATURE_DISPLAY = libbfd disassembler-four-args zlib
>>>  
>>> +ifdef LIBBPF_DYNAMIC
>>> +  # Add libbpf check with the flags to ensure bpftool
>>> +  # specific version is detected.
>>
>> Nit: We do not check for a specific bpftool version, we check for a
>> recent enough libbpf version?
> 
> hi,
> we check for a version that has the latest exported function
> that bpftool needs, which is currently libbpf_netlink_open
> 
> please check the '#ifdef BPFTOOL' in feature/test-libbpf.c
> 
> it's like that because there's currently no support to check
> for particular library version in the build/features framework
> 
> I'll make that comment more clear

Thanks!
>>> +  FEATURE_CHECK_CFLAGS-libbpf := -DBPFTOOL
>>> +  FEATURE_TESTS   += libbpf
>>> +  FEATURE_DISPLAY += libbpf
>>> +
>>> +  # for linking with debug library run:
>>> +  # make LIBBPF_DYNAMIC=1 LIBBPF_DIR=/opt/libbpf
>>> +  ifdef LIBBPF_DIR
>>> +    LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
>>> +    LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(libdir_relative)
>>> +    FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
>>> +    FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
>>> +  endif
>>> +endif
>>> +
>>>  check_feat := 1
>>>  NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
>>>  ifdef MAKECMDGOALS
>>> @@ -88,6 +114,18 @@ ifeq ($(feature-reallocarray), 0)
>>>  CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
>>>  endif
>>>  
>>> +ifdef LIBBPF_DYNAMIC
>>> +  ifeq ($(feature-libbpf), 1)
>>> +    LIBS    += -lbpf
>>> +    CFLAGS  += $(LIBBPF_CFLAGS)
>>> +    LDFLAGS += $(LIBBPF_LDFLAGS)
>>> +  else
>>> +    dummy := $(error Error: No libbpf devel library found, please install libbpf-devel)
>>
>> libbpf-devel sounds like a RH/Fedora package name, but other
>> distributions might have different names (Debian/Ubuntu would go by
>> libbpf-dev I suppose, although I don't believe such package exists at
>> the moment). Maybe use a more generic message?
> 
> sure, actually in perf we use both package names like:
> 
>   Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.
> 
> or we can go with generic message:
> 
>   Error: No libbpf devel library found, please install.

Either is fine with me, thanks!

>>> +  endif
>>> +else
>>> +  LIBS += $(LIBBPF)
>>
>> ... I believe the order of the libraries is relevant, and it seems the
>> static libbpf should be passed before the dynamic libs. Here I could fix
>> the build with the static library on my setup by prepending the library
>> path instead, like this:
>>
>> 	LIBS := $(LIBBPF) $(LIBS)
> 
> could you please paste the build error? I don't see any on Fedora,

Sure, here it is. On top of your branch (on Ubuntu 18.04):

----------------

$ make -C tools/bpf/bpftool/
make: Entering directory '/root/linux/bpf-next/tools/bpf/bpftool'

Auto-detecting system features:
...                        libbfd: [ on  ]
...        disassembler-four-args: [ on  ]
...                          zlib: [ on  ]

  CC       map_perf_ring.o
  CC       xlated_dumper.o
  CC       btf.o
  CC       tracelog.o
  CC       perf.o
  CC       cfg.o
  CC       btf_dumper.o
  CC       net.o
  CC       netlink_dumper.o
  CC       common.o
  CC       cgroup.o
  CC       main.o
  CC       json_writer.o
  CC       prog.o
  CC       map.o
  CC       feature.o
  CC       jit_disasm.o
  CC       disasm.o
make[1]: Entering directory '/root/linux/bpf-next/tools/lib/bpf'

Auto-detecting system features:
...                        libelf: [ on  ]
...                           bpf: [ on  ]

Parsed description of 117 helper function(s)
  MKDIR    staticobjs/
  CC       staticobjs/libbpf.o
  CC       staticobjs/bpf.o
  CC       staticobjs/nlattr.o
  CC       staticobjs/btf.o
  CC       staticobjs/libbpf_errno.o
  CC       staticobjs/str_error.o
  CC       staticobjs/netlink.o
  CC       staticobjs/bpf_prog_linfo.o
  CC       staticobjs/libbpf_probes.o
  CC       staticobjs/xsk.o
  CC       staticobjs/hashmap.o
  CC       staticobjs/btf_dump.o
  LD       staticobjs/libbpf-in.o
  LINK     libbpf.a
make[1]: Leaving directory '/root/linux/bpf-next/tools/lib/bpf'
  LINK     bpftool
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__init_prog_names':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:466: undefined reference to `gelf_getsym'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:473: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__elf_finish':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:570: undefined reference to `elf_end'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__elf_init':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:600: undefined reference to `elf_memory'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:613: undefined reference to `elf_begin'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:623: undefined reference to `gelf_getehdr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object_search_section_size':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:714: undefined reference to `gelf_getshdr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:720: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:730: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:708: undefined reference to `elf_nextscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__variable_offset':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:784: undefined reference to `gelf_getsym'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:790: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__init_user_maps':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:937: undefined reference to `elf_getscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:939: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:957: undefined reference to `gelf_getsym'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:981: undefined reference to `gelf_getsym'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:990: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__init_user_btf_maps':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1359: undefined reference to `elf_getscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1361: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `section_have_execinstr':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1428: undefined reference to `elf_getscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1432: undefined reference to `gelf_getshdr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_object__elf_collect':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1608: undefined reference to `elf_getscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1608: undefined reference to `elf_rawdata'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1619: undefined reference to `gelf_getshdr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1625: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1632: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1613: undefined reference to `elf_nextscn'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `bpf_program__collect_reloc':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1928: undefined reference to `gelf_getrel'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1932: undefined reference to `gelf_getsym'
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:1941: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `__bpf_object__open':
/root/linux/bpf-next/tools/lib/bpf/libbpf.c:3934: undefined reference to `elf_version'
/root/linux/bpf-next/tools/lib/bpf/libbpf.a(libbpf-in.o): In function `btf__parse_elf':
/root/linux/bpf-next/tools/lib/bpf/btf.c:413: undefined reference to `elf_version'
/root/linux/bpf-next/tools/lib/bpf/btf.c:427: undefined reference to `elf_begin'
/root/linux/bpf-next/tools/lib/bpf/btf.c:432: undefined reference to `gelf_getehdr'
/root/linux/bpf-next/tools/lib/bpf/btf.c:440: undefined reference to `elf_getscn'
/root/linux/bpf-next/tools/lib/bpf/btf.c:440: undefined reference to `elf_rawdata'
/root/linux/bpf-next/tools/lib/bpf/btf.c:450: undefined reference to `gelf_getshdr'
/root/linux/bpf-next/tools/lib/bpf/btf.c:455: undefined reference to `elf_strptr'
/root/linux/bpf-next/tools/lib/bpf/btf.c:462: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/btf.c:470: undefined reference to `elf_getdata'
/root/linux/bpf-next/tools/lib/bpf/btf.c:445: undefined reference to `elf_nextscn'
/root/linux/bpf-next/tools/lib/bpf/btf.c:500: undefined reference to `elf_end'
collect2: error: ld returned 1 exit status
Makefile:158: recipe for target 'bpftool' failed
make: *** [bpftool] Error 1
make: Leaving directory '/root/linux/bpf-next/tools/bpf/bpftool'

----------------

Adding the V=1 flag shows the compilation is attempted with the
following command:

gcc -O2 -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wundef -Wwrite-strings -Wformat -Wstrict-aliasing=3 -Wshadow -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ -I/root/linux/bpf-next/kernel/bpf/ -I/root/linux/bpf-next/tools/include -I/root/linux/bpf-next/tools/include/uapi -I/root/linux/bpf-next/tools/lib/bpf -I/root/linux/bpf-next/tools/perf -DBPFTOOL_VERSION='"5.4.0"' -DDISASM_FOUR_ARGS_SIGNATURE -DHAVE_LIBBFD_SUPPORT  -o bpftool map_perf_ring.o perf.o net.o cgroup.o tracelog.o btf_dumper.o xlated_dumper.o json_writer.o prog.o map.o common.o btf.o cfg.o main.o netlink_dumper.o feature.o jit_disasm.o disasm.o -lelf -lz /root/linux/bpf-next/tools/lib/bpf/libbpf.a -lbfd -ldl -lopcodes

If I move -lelf and -lz after <path>/libbpf.a, then it builds fine.

Hope this helps,
Quentin
