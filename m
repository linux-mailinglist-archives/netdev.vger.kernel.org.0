Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6F552B0D5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 05:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiERDgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 23:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiERDfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 23:35:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98A362A2E;
        Tue, 17 May 2022 20:35:47 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L2zB823mRz1JCCQ;
        Wed, 18 May 2022 11:34:24 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 11:35:44 +0800
Message-ID: <c6dfe9bc-07ac-62a7-0a34-12fecf0dfdaa@huawei.com>
Date:   Wed, 18 May 2022 11:35:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v4 3/6] bpf: Move is_valid_bpf_tramp_flags() to
 the public trampoline code
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
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
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20220517071838.3366093-1-xukuohai@huawei.com>
 <20220517071838.3366093-4-xukuohai@huawei.com>
 <20220517155349.4jk5oymnjvrasw2p@MacBook-Pro.local>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <20220517155349.4jk5oymnjvrasw2p@MacBook-Pro.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/2022 11:53 PM, Alexei Starovoitov wrote:
> On Tue, May 17, 2022 at 03:18:35AM -0400, Xu Kuohai wrote:
>>  
>> +static bool is_valid_bpf_tramp_flags(unsigned int flags)
>> +{
>> +	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
>> +	    (flags & BPF_TRAMP_F_SKIP_FRAME))
>> +		return false;
>> +
>> +	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
>> +	 * and it must be used alone.
>> +	 */
>> +	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
>> +	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +int bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image,
>> +			   void *image_end, const struct btf_func_model *m,
>> +			   u32 flags, struct bpf_tramp_links *tlinks,
>> +			   void *orig_call)
>> +{
>> +	if (!is_valid_bpf_tramp_flags(flags))
>> +		return -EINVAL;
>> +
>> +	return arch_prepare_bpf_trampoline(tr, image, image_end, m, flags,
>> +					   tlinks, orig_call);
>> +}
> 
> It's an overkill to introduce a new helper function just to validate
> flags that almost compile time constants.
> The flags are not user supplied.
> Please move /* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops ... */
> comment to bpf_struct_ops.c right before it calls arch_prepare_bpf_trampoline()
> And add a comment to trampoline.c saying that BPF_TRAMP_F_RESTORE_REGS
> and BPF_TRAMP_F_SKIP_FRAME should not be set together.
> We could add a warn_on there or in arch code, but feels like overkill.
> .

OK, will fix in next version.


