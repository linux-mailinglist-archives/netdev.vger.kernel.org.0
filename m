Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248E8B287C
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404083AbfIMWdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:33:22 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37921 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404034AbfIMWdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:33:20 -0400
Received: by mail-lf1-f68.google.com with SMTP id u28so2491193lfc.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ihmb3q/NdECGRR5zzEyyPCuHVNkS8lC17ByG/rKgfTs=;
        b=yduZq7G9bgba7AT9kCxy32dgPaU1+nS3rrt1SkQVewbNckwKWpgGRfVk3Y0BmZy3T/
         hc2tkDna8PRu8vNhOjxNByF3gi1YbIztijqkbhAoC0kl/huMcgyMEk7x+UOox7gG5Okn
         ERaOtSaA+6nr1OQd+i6MuHkecmR0NZ6yG1bytGiA2TZdg814CgUE9pwPlLQmCnF84+sz
         r4AibbVNdmVlRPAmkkCeAvkdCvvVpjbSUpjQqldGzJ6ayRZmm5g9gO5o4tPxeYdpWy+a
         BWT6QgDvq860MsINwgU27P5zHGS0QcTdpKsGoyx9agaR7mf2aT5/DB+d+PDfqtbPB3O5
         NRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=ihmb3q/NdECGRR5zzEyyPCuHVNkS8lC17ByG/rKgfTs=;
        b=YmrTpGa0Bl7As5qFlYXmTrCRwcQ+tW5axisykNggSmC/J3UNBf4bxy7ovDNMR9XrOG
         mv5/dLGJ0lTBSaqMpL8VKYw0Ocxuik4AUXf0AECIvWXrLN7Ym2HiHZgGzmrPmhk9DN01
         UZ05QL9t5l36wZhgKe5uULRwww8HkKh7WZm6xSufbnDk1mVSOY5AHfX2lsNu+BPNmAvk
         LUu7/3c+aUMbfwQFzykahfm6fgUyLorDWT6d4O/wJPdhqQxd7b682BkRfH/1GfF95D79
         FKKfx6J66eyb5e7lOWrxlxihhW4H1/2naGbwm6hzVAcm2zaIiBASOthKpuHO1mCvMfIO
         Id2g==
X-Gm-Message-State: APjAAAX7sEEWiJ6H1XzPA7KRBYuttXeAq73D6XCnIZApPkwwKjl/loZ8
        GQnZRYbILuYnny1HS0FzRIYitUoWi7A=
X-Google-Smtp-Source: APXvYqwhyEj6qqlzJGRhzh2nm6Ue6JgbrQHXynRGsrsIq7IeayiUmrTW8RDYxiR2eoWifL/xp/4mAA==
X-Received: by 2002:a19:d6:: with SMTP id 205mr9338872lfa.144.1568413996212;
        Fri, 13 Sep 2019 15:33:16 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id r19sm6732884ljd.95.2019.09.13.15.33.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Sep 2019 15:33:16 -0700 (PDT)
Date:   Sat, 14 Sep 2019 01:33:13 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 10/11] libbpf: makefile: add C/CXX/LDFLAGS to
 libbpf.so and test_libpf targets
Message-ID: <20190913223313.GF26724@khorivan>
Mail-Followup-To: Yonghong Song <yhs@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" <clang-built-linux@googlegroups.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-11-ivan.khoronzhuk@linaro.org>
 <0ad42019-2614-b70c-f93e-527c136bba83@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0ad42019-2614-b70c-f93e-527c136bba83@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 09:43:22PM +0000, Yonghong Song wrote:
>
>
>On 9/10/19 11:38 AM, Ivan Khoronzhuk wrote:
>> In case of LDFLAGS and EXTRA_CC/CXX flags there is no way to pass them
>> correctly to build command, for instance when --sysroot is used or
>> external libraries are used, like -lelf, wich can be absent in
>> toolchain. This is used for samples/bpf cross-compiling allowing to
>> get elf lib from sysroot.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>   samples/bpf/Makefile   |  8 +++++++-
>>   tools/lib/bpf/Makefile | 11 ++++++++---
>>   2 files changed, 15 insertions(+), 4 deletions(-)
>
>Could you separate this patch into two?
>One of libbpf and another for samples.
>
>The subject 'libbpf: ...' is not entirely accurate.
Yes, ofc.
But there is too many patches already, but better a lot of small
changes then couple huge.

>
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 79c9aa41832e..4edc5232cfc1 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -186,6 +186,10 @@ ccflags-y += -I$(srctree)/tools/perf
>>   ccflags-y += $(D_OPTIONS)
>>   ccflags-y += -Wall
>>   ccflags-y += -fomit-frame-pointer
>> +
>> +EXTRA_CXXFLAGS := $(ccflags-y)
>> +
>> +# options not valid for C++
>>   ccflags-y += -Wmissing-prototypes
>>   ccflags-y += -Wstrict-prototypes
>>
>> @@ -252,7 +256,9 @@ clean:
>>
>>   $(LIBBPF): FORCE
>>   # Fix up variables inherited from Kbuild that tools/ build system won't like
>> -	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(BPF_SAMPLES_PATH)/../../ O=
>> +	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(PROGS_CFLAGS)" \
>> +		EXTRA_CXXFLAGS="$(EXTRA_CXXFLAGS)" LDFLAGS=$(PROGS_LDFLAGS) \
>> +		srctree=$(BPF_SAMPLES_PATH)/../../ O=
>>
>>   $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
>>   	$(call filechk,offsets,__SYSCALL_NRS_H__)
>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index c6f94cffe06e..bccfa556ef4e 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -94,6 +94,10 @@ else
>>     CFLAGS := -g -Wall
>>   endif
>>
>> +ifdef EXTRA_CXXFLAGS
>> +  CXXFLAGS := $(EXTRA_CXXFLAGS)
>> +endif
>> +
>>   ifeq ($(feature-libelf-mmap), 1)
>>     override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
>>   endif
>> @@ -176,8 +180,9 @@ $(BPF_IN): force elfdep bpfdep
>>   $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>>
>>   $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
>> -	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
>> -				    -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>> +	$(QUIET_LINK)$(CC) $(LDFLAGS) \
>> +		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
>> +		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>>   	@ln -sf $(@F) $(OUTPUT)libbpf.so
>>   	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
>>
>> @@ -185,7 +190,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
>>   	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>>
>>   $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
>> -	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
>> +	$(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
>>
>>   $(OUTPUT)libbpf.pc:
>>   	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
>>

-- 
Regards,
Ivan Khoronzhuk
