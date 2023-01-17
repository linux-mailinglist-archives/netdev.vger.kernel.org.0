Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE9866E29F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjAQPpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjAQPo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:44:56 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E4442DD5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:42:57 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id n7so4944778wrx.5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7To1PtEGVp3/tPOk0JXLL+U9DaqHG+W01y2JfF1hK5I=;
        b=sqjNmW/XT9f6bMUz2HReEOEm15NNiVvPMxUXTumv8HXRcwKFSzVq7Sn7osexqENlED
         cxpgAQoVCMBcA79O0bs/6PdcgcYa/TCGcPRaPZH025Da/t856WXh9yyikX2+AO+uKUnh
         N/OeBwjz/VL3hTVLOWDw0z7c7IzRwqNe2Ce/AGJOzFkyMqwHDc2CeYEacuaLbTZ5uI6W
         sWCWb3Bh5+J4VBpHVjxd4368wMNeEWsviX25PYwG6Dq6KYh8qxIr/YflMdXoWlib7AyQ
         rtoZqZ3C3qfWKwOcfB1ILORxKgwThZUzHy8KkJQFu+nsJhPv4IlmTQt+X32frJsjt9Fv
         8zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7To1PtEGVp3/tPOk0JXLL+U9DaqHG+W01y2JfF1hK5I=;
        b=ZVY2IUZvb6e9Hc6E9oJDdlXz2PV5SaJ/K5QFLmAzFZSi7VstOlur+rMGCC79z/tb1g
         J9zEpxgaJiR2CAGs8tuXSrIBO2Tp7cKbh2jt+7H8k89DsBMBIqW0QBG0WnwlQsQB3usU
         5YRVENF4HopDSu9KRWDmEKe2xRSfuLfo0h+bFwiIkoHidjtqabyIBJ/tmgh6JLcirIGE
         O/AcFAlQPZ+s2tOqbFvl5pExyuRgCDEBjLIn9/LKgwQsOPhYi/T2jqIeAhuDLDzSGC/Z
         eHIjPUvicyECj8egOzlvJ+YYn6J4rpfy4p01g2P1li5qyqVfaqKys4IPy5M7zadiCyT9
         oc+A==
X-Gm-Message-State: AFqh2kratOX9kNjDNmvw2OSJJm+IrtOBNhRUFaRo+A2ZO23j9pK87Z0q
        2ZCqp5IwkfjkHogeaTLukfLdqw==
X-Google-Smtp-Source: AMrXdXtTN1BLtD1pbah3CZTaOxF4sW540xUc7Q3jg68foOOF4e44hppWy+ht1PSRvVqSopEM+M//jg==
X-Received: by 2002:a5d:4384:0:b0:2bd:f8c8:9786 with SMTP id i4-20020a5d4384000000b002bdf8c89786mr2922814wrq.64.1673970175526;
        Tue, 17 Jan 2023 07:42:55 -0800 (PST)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id a1-20020a5d4d41000000b002bdef155868sm9467141wru.106.2023.01.17.07.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 07:42:55 -0800 (PST)
Message-ID: <43e6cd9f-ac54-46da-dba9-d535a2a77207@isovalent.com>
Date:   Tue, 17 Jan 2023 15:42:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Content-Language: en-GB
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tonghao Zhang <tong@infragraf.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <0792068b-9aff-d658-5c7d-086e6d394c6c@csgroup.eu>
 <C811FC00-CE38-4227-B2E8-4CD8989D8B94@infragraf.org>
 <4ab9aafe-6436-b90d-5448-f74da22ddddb@csgroup.eu>
 <376f9737-f9a4-da68-8b7f-26020021613c@isovalent.com>
 <21b09e52-142d-92f5-4f8b-e4190f89383b@csgroup.eu>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <21b09e52-142d-92f5-4f8b-e4190f89383b@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-17 14:55 UTC+0000 ~ Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> 
> Le 17/01/2023 à 15:41, Quentin Monnet a écrit :
>> [Vous ne recevez pas souvent de courriers de quentin@isovalent.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
>>
>> 2023-01-17 14:25 UTC+0000 ~ Christophe Leroy <christophe.leroy@csgroup.eu>
>>>
>>>
>>> Le 17/01/2023 à 15:18, Tonghao Zhang a écrit :
>>>>
>>>>
>>>>> On Jan 17, 2023, at 7:36 PM, Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>>>>>
>>>>>
>>>>>
>>>>> Le 17/01/2023 à 08:30, Christophe Leroy a écrit :
>>>>>>
>>>>>>
>>>>>> Le 17/01/2023 à 06:30, Tonghao Zhang a écrit :
>>>>>>>
>>>>>>>
>>>>>>>> On Jan 9, 2023, at 4:15 PM, Christophe Leroy
>>>>>>>> <christophe.leroy@csgroup.eu> wrote:
>>
>> [...]
>>
>>>>>>>> Sure I will try to test bpftool again in the coming days.
>>>>>>>>
>>>>>>>> Previous discussion about that subject is here:
>>>>>>>> https://patchwork.kernel.org/project/linux-riscv/patch/20210415093250.3391257-1-Jianlin.Lv@arm.com/#24176847=
>>
>> Christophe, apologies from dropping the discussion the last time, it
>> seems your last message on that thread didn't make it to my inbox at the
>> time :/. Thanks a lot for looking into that again!
>>
>>>>>>> Hi Christophe
>>>>>>> Any progress? We discuss to deprecate the bpf_jit_enable == 2 in 2021,
>>>>>>> but bpftool can not run on powerpc.
>>>>>>> Now can we fix this issue?
>>>>>>
>>>>>> Hi Tong,
>>>>>>
>>>>>> I have started to look at it but I don't have any fruitfull feedback yet.
>>>>>
>>>>> Hi Again,
>>>>>
>>>>> I tested again, the problem is still the same as one year ago:
>>>>>
>>>>> root@vgoip:~# ./bpftool prog
>>>>> libbpf: elf: endianness mismatch in pid_iter_bpf.
>>>> It seem to be not right ehdr->e_ident[EI_DATA]. Do we can print the real value?
>>>> /*
>>>>    * e_ident[EI_DATA]
>>>>    */
>>>> #define ELFDATANONE     0
>>>> #define ELFDATA2LSB     1
>>>> #define ELFDATA2MSB     2
>>>> #define ELFDATANUM      3
>>>>
>>>> bpf_object__elf_init:
>>>> obj->efile.ehdr = ehdr = elf64_getehdr(elf);
>>>>
>>>>> libbpf: failed to initialize skeleton BPF object 'pid_iter_bpf': -4003
>>>>> Error: failed to open PID iterator skeleton
>>>>>
>>>>> root@vgoip:~# uname -a
>>>>> Linux vgoip 6.2.0-rc3-02596-g1c2c9c13e256 #242 PREEMPT Tue Jan 17
>>>>> 09:36:08 CET 2023 ppc GNU/Linux
>>>> On my pc, elf is little endian.
>>>> # readelf -h tools/bpf/bpftool/pid_iter.bpf.o
>>>> ELF Header:
>>>>     Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
>>>>     Class:                             ELF64
>>>>     Data:                              2's complement, little endian # x86_64
>>>>     Version:                           1 (current)
>>>>     OS/ABI:                            UNIX - System V
>>>>     ABI Version:                       0
>>>>     Type:                              REL (Relocatable file)
>>>>     Machine:                           Linux BPF
>>>>     Version:                           0x1
>>>>     Entry point address:               0x0
>>>>     Start of program headers:          0 (bytes into file)
>>>>     Start of section headers:          64832 (bytes into file)
>>>>     Flags:                             0x0
>>>>     Size of this header:               64 (bytes)
>>>>     Size of program headers:           0 (bytes)
>>>>     Number of program headers:         0
>>>>     Size of section headers:           64 (bytes)
>>>>     Number of section headers:         13
>>>>     Section header string table index: 1
>>>>
>>>
>>> Yes, must be something wrong with the build, I get same as you :
>>>
>>> $ LANG= readelf -h pid_iter.bpf.o
>>> ELF Header:
>>>     Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
>>>     Class:                             ELF64
>>>     Data:                              2's complement, little endian
>>>     Version:                           1 (current)
>>>     OS/ABI:                            UNIX - System V
>>>     ABI Version:                       0
>>>     Type:                              REL (Relocatable file)
>>>     Machine:                           Linux BPF
>>>     Version:                           0x1
>>>     Entry point address:               0x0
>>>     Start of program headers:          0 (bytes into file)
>>>     Start of section headers:          34704 (bytes into file)
>>>     Flags:                             0x0
>>>     Size of this header:               64 (bytes)
>>>     Size of program headers:           0 (bytes)
>>>     Number of program headers:         0
>>>     Size of section headers:           64 (bytes)
>>>     Number of section headers:         13
>>>     Section header string table index: 1
>>>
>>>
>>> Whereas I expect the same as bpftool I suppose, which is :
>>>
>>> $ LANG= readelf -h bpftool
>>> ELF Header:
>>>     Magic:   7f 45 4c 46 01 02 01 00 00 00 00 00 00 00 00 00
>>>     Class:                             ELF32
>>>     Data:                              2's complement, big endian
>>>     Version:                           1 (current)
>>>     OS/ABI:                            UNIX - System V
>>>     ABI Version:                       0
>>>     Type:                              EXEC (Executable file)
>>>     Machine:                           PowerPC
>>>     Version:                           0x1
>>>     Entry point address:               0x100027d0
>>>     Start of program headers:          52 (bytes into file)
>>>     Start of section headers:          1842896 (bytes into file)
>>>     Flags:                             0x0
>>>     Size of this header:               52 (bytes)
>>>     Size of program headers:           32 (bytes)
>>>     Number of program headers:         9
>>>     Size of section headers:           40 (bytes)
>>>     Number of section headers:         39
>>>     Section header string table index: 38
>>>
>>
>> pid_iter.bpf.o should be generated from that command in bpftool's Makefile:
>>
>>          $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h \
>>                          $(LIBBPF_BOOTSTRAP)
>>                  $(QUIET_CLANG)$(CLANG) \
>>                          -I$(or $(OUTPUT),.) \
>>                          -I$(srctree)/tools/include/uapi/ \
>>                          -I$(LIBBPF_BOOTSTRAP_INCLUDE) \
>>                          -g -O2 -Wall -fno-stack-protector \
>>                          -target bpf -c $< -o $@
>>
>> My understanding is that "-target bpf" is supposed to pick the
>> endianness for the host (see "llc --version | grep bpf". If that's not
>> the case, could you please try to turn that into '-target bpfeb' in the
>> Makefile instead? I'd be curious to see if it helps.
>>
> 
> I guess it cannot work if it picks the endianness for the build host. It 
> should pick the endianness for the target host.
> 
> That's worse it seems with bpfeb : it fails at build :
> 
>    LINK    /home/chleroy/linux-powerpc/tools/bpf/bpftool/bootstrap/bpftool
>    GEN     vmlinux.h
>    CLANG   pid_iter.bpf.o
>    GEN     pid_iter.skel.h
> libbpf: elf: endianness mismatch in pid_iter_bpf.
> Error: failed to open BPF object file: Endian mismatch
> make: *** [Makefile:222: pid_iter.skel.h] Error 93
> 
> 
> Complete build in case it helps:
> 
> $ LANG= make CROSS_COMPILE=ppc-linux- ARCH=powerpc
> 
> Auto-detecting system features:
> ...                         clang-bpf-co-re: [ [32mon[m  ]
> ...                                    llvm: [ [31mOFF[m ]
> ...                                  libcap: [ [31mOFF[m ]
> ...                                  libbfd: [ [31mOFF[m ]

[...]

>    CLANG   pid_iter.bpf.o
>    GEN     pid_iter.skel.h
> libbpf: elf: endianness mismatch in pid_iter_bpf.
> Error: failed to open BPF object file: Endian mismatch
> make: *** [Makefile:222: pid_iter.skel.h] Error 93


Right sorry, I forgot you were cross-compiling. As far as I understand,
it seems that bpftool's Makefile picks up the host endianness when
building the skeleton header file and embedding the BPF program in it,
so loading it on the target host doesn't work. We would like it to build
the skeleton with the target endianness instead, but it seems that
libbpf does not support that (referring to
bpf_object__check_endianness() in tools/lib/bpf/libbpf.c).

I don't know if there's a way to make libbpf work here, or plans to add
it (Andrii do you know?).

In the meantime, you could disable the use of skeletons in bpftool, by
removing "clang-bpf-co-re" from FEATURE_TESTS from the Makefile. You
should get a functional binary, which would only miss a few features
(namely, printing the pids of programs holding references to BPF
programs, and the "bpftool prog profile" command).
