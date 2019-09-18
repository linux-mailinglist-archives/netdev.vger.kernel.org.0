Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0F2B6206
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfIRLF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 07:05:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39553 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfIRLF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 07:05:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id s19so6762681lji.6
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 04:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JNIOOCl1FIlLK8OEQrCWm+4MRTLInoFaM8HwgPYRrSI=;
        b=x9PsKe2lWSxm5YFoGrE7b1TTrtwP4ymR5aHH9sHEKViQA3aCR2IMzJ2aBGzYvIdJ17
         OtiILmKAN0rwR0GwJFAJy5PwRZwXAemG0uob3Zz1kWZLO8HzXikGDYheeGh9XwMxZS/d
         1zxWeZ4SDo0Y2AqIc/XMLu1xhSXcxP0qU0RdRalMXVHAiRHTuoqsaB4EXKrhfagz9qyc
         6yeAvnu4eEoRjkGR1NbBOc+2f31Lbpk3CrBYvLHmDs9uFCPkcSXTh/ZzzcNQ3BXng9gA
         GaCTr+J1gFHg2F27Zy0MkLOEU7YoJ3XFLbNPSeyu15FWT50wATdLXZbv7LCG/gCEx7Dv
         AAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=JNIOOCl1FIlLK8OEQrCWm+4MRTLInoFaM8HwgPYRrSI=;
        b=Cfs22t2abhDeBEjyYaHF0l5tqojYk0zWx+I4eqTnnJDvXdw3wSPuuSCVSrxaLAR/oh
         zpDzfn1rOhS3UEDIaKuNkJAMTWbxVirefAjxZgCY0/1I1ahmDVY4vUg2rGEj2+dPEHtn
         Q9DvEhf185IdrdWMGps5Z+CXMiXwSl7qJrR5w7wTl75EfrCMgMV7ktcmUwKUYFzYRwxz
         3SnKeqxtMsWzD4CeGxry+7c5StqTCO3dMwPKT/zxYx8dpCxRMraB8WYNpGguUs+FSRVO
         P7JbHYCa1op3NQ/CLMILQ5tQXlLaYRohKAqf6AeiZestOhoH2ioIEOS+6UxzsxbaYUZg
         lHmA==
X-Gm-Message-State: APjAAAVIpfAbfJ1B9Mv94eQ/kibeVwyl0EP89r/DvwLFKX2a/znKN05/
        dFelmMyMcoCfayy5gID383JTNA==
X-Google-Smtp-Source: APXvYqwhzGaNYWRfqqbacjV8ivacocjE8Zel8keZadSmB9WJFdU54IEBfsuyRvZlrIEaM1mB7lZcrg==
X-Received: by 2002:a2e:9ac4:: with SMTP id p4mr1793545ljj.206.1568804721863;
        Wed, 18 Sep 2019 04:05:21 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id s7sm959288ljs.16.2019.09.18.04.05.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 04:05:20 -0700 (PDT)
Date:   Wed, 18 Sep 2019 14:05:18 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 bpf-next 11/14] libbpf: makefile: add C/CXX/LDFLAGS to
 libbpf.so and test_libpf targets
Message-ID: <20190918110517.GD2908@khorivan>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-12-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZXNN_dhs=jUjtfCqtuV1bk9H=q5b07kVDQQsysjhF4cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzZXNN_dhs=jUjtfCqtuV1bk9H=q5b07kVDQQsysjhF4cQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 10:19:22PM -0700, Andrii Nakryiko wrote:
>On Mon, Sep 16, 2019 at 4:00 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> In case of LDFLAGS and EXTRA_CC/CXX flags there is no way to pass them
>> correctly to build command, for instance when --sysroot is used or
>> external libraries are used, like -lelf, wich can be absent in
>> toolchain. This can be used for samples/bpf cross-compiling allowing
>> to get elf lib from sysroot.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  tools/lib/bpf/Makefile | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index c6f94cffe06e..bccfa556ef4e 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -94,6 +94,10 @@ else
>>    CFLAGS := -g -Wall
>>  endif
>>
>> +ifdef EXTRA_CXXFLAGS
>> +  CXXFLAGS := $(EXTRA_CXXFLAGS)
>> +endif
>> +
>>  ifeq ($(feature-libelf-mmap), 1)
>>    override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
>>  endif
>> @@ -176,8 +180,9 @@ $(BPF_IN): force elfdep bpfdep
>>  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>>
>>  $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
>> -       $(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
>> -                                   -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>> +       $(QUIET_LINK)$(CC) $(LDFLAGS) \
>> +               --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
>> +               -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>>         @ln -sf $(@F) $(OUTPUT)libbpf.so
>>         @ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
>>
>> @@ -185,7 +190,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
>>         $(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>>
>>  $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
>> -       $(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
>> +       $(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
>
>Instead of doing ifdef EXTRA_CXXFLAGS bit above, you can just include
>both $(CXXFLAGS) and $(EXTRA_CXXFLAGS), which will do the right thing
>(and is actually recommended my make documentation way to do this).
It's good practice to follow existent style, I've done similar way as for
CFLAGS + EXTRACFLAGS here, didn't want to verify it can impact on
smth else. And my goal is not to correct everything but embed my
functionality, series tool large w/o it.

>
>But actually, there is no need to use C++ compiler here,
>test_libbpf.cpp can just be plain C. Do you mind renaming it to .c and
>using C compiler instead?
Seems like, will try in next v.

>
>>
>>  $(OUTPUT)libbpf.pc:
>>         $(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
>> --
>> 2.17.1
>>

-- 
Regards,
Ivan Khoronzhuk
