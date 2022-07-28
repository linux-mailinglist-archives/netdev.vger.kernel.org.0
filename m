Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3537583F56
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiG1M4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 08:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbiG1M4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 08:56:34 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF373474D8;
        Thu, 28 Jul 2022 05:56:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LtrGX59TzzKFHZ;
        Thu, 28 Jul 2022 20:55:16 +0800 (CST)
Received: from [10.67.111.192] (unknown [10.67.111.192])
        by APP3 (Coremail) with SMTP id _Ch0CgAHD2t7h+JiChAqBQ--.32279S2;
        Thu, 28 Jul 2022 20:56:29 +0800 (CST)
Message-ID: <9170060c-8727-68d6-7be2-8aa75e30c6e6@huaweicloud.com>
Date:   Thu, 28 Jul 2022 20:56:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next] bpf: Fix NULL pointer dereference when
 registering bpf trampoline
Content-Language: en-US
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Song Liu <song@kernel.org>
References: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
 <YuKAlk+p/ABzfUQ+@krava>
From:   Xu Kuohai <xukuohai@huaweicloud.com>
In-Reply-To: <YuKAlk+p/ABzfUQ+@krava>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: _Ch0CgAHD2t7h+JiChAqBQ--.32279S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyxtF45Zr15XF1fAFWfuFg_yoW8uw43pF
        yrG3ZxCFWjqFW8ur9Fg3WUXF15J3ykJr17WF42kay09Fn8Grn5JF42gwnrta4Dtr45ur1F
        yFs0vF9093WUu3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 50xn30hkdlqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2022 8:27 PM, Jiri Olsa wrote:
> On Thu, Jul 28, 2022 at 07:40:48AM -0400, Xu Kuohai wrote:
>> From: Xu Kuohai <xukuohai@huawei.com>
> 
> SNIP
> 
>>
>> It's caused by a NULL tr->fops passed to ftrace_set_filter_ip(). tr->fops
>> is initialized to NULL and is assigned to an allocated memory address if
>> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is enabled. Since there is no
>> direct call on arm64 yet, the config can't be enabled.
>>
>> To fix it, call ftrace_set_filter_ip() only if tr->fops is not NULL.
>>
>> Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
>> Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> Tested-by: Bruno Goncalves <bgoncalv@redhat.com>
>> Acked-by: Song Liu <songliubraving@fb.com>
>> ---
>>   kernel/bpf/trampoline.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
>> index 42e387a12694..0d5a9e0b9a7b 100644
>> --- a/kernel/bpf/trampoline.c
>> +++ b/kernel/bpf/trampoline.c
>> @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>>   		return -ENOENT;
>>   
>>   	if (tr->func.ftrace_managed) {
>> -		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
>> -		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
>> +		if (tr->fops)
>> +			ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
>> +						   0, 0);
>> +		else
>> +			ret = -ENOTSUPP;
>> +
>> +		if (!ret)
>> +			ret = register_ftrace_direct_multi(tr->fops,
>> +							   (long)new_addr);
>>   	} else {
>>   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
>>   	}
> 
> do we need to do the same also in unregister_fentry and modify_fentry ?
> 

No need for now, this is the only place where we call ftrace_set_filter_ip().

tr->fops is passed to ftrace_set_filter_ip() and *ftrace_direct_multi()
functions, and when CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is not enabled,
the *ftrace_direct_multi()s do nothing except returning an error code, so
it's safe to pass NULL to them.

> jirka

