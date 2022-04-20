Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B8950827D
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376341AbiDTHq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 03:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376348AbiDTHqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 03:46:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE483BFA3;
        Wed, 20 Apr 2022 00:44:03 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kjt2x1R9KzhXY4;
        Wed, 20 Apr 2022 15:43:53 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 15:43:59 +0800
Message-ID: <82e7faec-7f0c-573f-4945-de7072744dcb@huawei.com>
Date:   Wed, 20 Apr 2022 15:43:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v2 5/6] bpf, arm64: bpf trampoline for arm64
Content-Language: en-US
From:   Xu Kuohai <xukuohai@huawei.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
References: <20220414162220.1985095-1-xukuohai@huawei.com>
 <20220414162220.1985095-6-xukuohai@huawei.com>
 <CAEf4Bzb_R56wAuD-Wgg7B5brT-dcsa+5sYynY+_CFzRwg+N5AA@mail.gmail.com>
 <6c18a27f-c983-58f3-1dc0-5192f7df232a@huawei.com>
In-Reply-To: <6c18a27f-c983-58f3-1dc0-5192f7df232a@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/2022 9:57 AM, Xu Kuohai wrote:
> On 4/16/2022 1:12 AM, Andrii Nakryiko wrote:
>> On Thu, Apr 14, 2022 at 9:10 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>>>
>>> Add bpf trampoline support for arm64. Most of the logic is the same as
>>> x86.
>>>
>>> fentry before bpf trampoline hooked:
>>>  mov x9, x30
>>>  nop
>>>
>>> fentry after bpf trampoline hooked:
>>>  mov x9, x30
>>>  bl  <bpf_trampoline>
>>>
>>> Tested on qemu, result:
>>>  #55 fentry_fexit:OK
>>>  #56 fentry_test:OK
>>>  #58 fexit_sleep:OK
>>>  #59 fexit_stress:OK
>>>  #60 fexit_test:OK
>>>  #67 get_func_args_test:OK
>>>  #68 get_func_ip_test:OK
>>>  #101 modify_return:OK
>>>
>>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>> ---
>>
>> Can you please also take a look at [0], which is an ongoing work to
>> add support for BPF cookie to BPF trampoline-based BPF programs. It's
>> very close to being done, so it would be good if you can implement
>> that at the same time.
> 
> OK, I'll take a look and try to implemnt it.

already implemented, but there are some conflicts between these two
series, will send v3 after trampoline cookie are merged.
