Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1080E56C7B3
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 09:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiGIHbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 03:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGIHbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 03:31:37 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9AE6A9C1;
        Sat,  9 Jul 2022 00:31:36 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lg1yp6ZMbzFpyy;
        Sat,  9 Jul 2022 15:30:42 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 9 Jul 2022 15:31:34 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 9 Jul 2022 15:31:33 +0800
Subject: Re: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Quentin Monnet" <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220707140811.603590-1-pulehui@huawei.com>
 <CAEf4Bzb_re+o2zALCA+Rf_cJS-31350PjhzRg42bgW0mO-GVbg@mail.gmail.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <502e80cc-774e-77c0-e918-3c35a2c5ec17@huawei.com>
Date:   Sat, 9 Jul 2022 15:31:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb_re+o2zALCA+Rf_cJS-31350PjhzRg42bgW0mO-GVbg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/9 6:42, Andrii Nakryiko wrote:
> On Thu, Jul 7, 2022 at 6:37 AM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> Currently, when cross compiling bpf samples, the host side
>> cannot use arch-specific bpftool to generate vmlinux.h or
>> skeleton. We need to compile the bpftool with the host
>> compiler.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> ---
> 
> samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
> only. All that is supported by lightweight "bootstrap" bpftool
> version, so we can build just that. It will be faster, and bootstrap
> version should be always host-native even during cross compilation.
> See [0] for what I did in libbpf-bootstrap.
> 
> Also please cc Quention for bpftool-related changes. Thanks!
> 
>     [0] https://github.com/libbpf/libbpf-bootstrap/commit/fc28424eb3f0e39cfb5959296b070389b9a8bd8f
> 

so brilliant，we can take it to other places where rely on bpftool.
thanks.

>>   samples/bpf/Makefile | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 5002a5b9a7da..fe54a8c8f312 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -1,4 +1,5 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> +-include tools/scripts/Makefile.include
>>
>>   BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>>   TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>> @@ -283,11 +284,10 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>>   BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>>   BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
>>   BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
>> -$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>>              $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
>> -               OUTPUT=$(BPFTOOL_OUTPUT)/ \
>> -               LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
>> -               LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
>> +               ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
>> +               OUTPUT=$(BPFTOOL_OUTPUT)/
>>
>>   $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>>          $(call msg,MKDIR,$@)
>> --
>> 2.25.1
>>
> .
> 
