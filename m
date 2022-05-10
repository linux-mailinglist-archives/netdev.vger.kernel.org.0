Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8281C520B6B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiEJCq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiEJCq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:46:26 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CEF327F135;
        Mon,  9 May 2022 19:42:28 -0700 (PDT)
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxENsN0XliBpIPAA--.61414S3;
        Tue, 10 May 2022 10:42:22 +0800 (CST)
Subject: Re: [PATCH bpf-next 2/3] net: sysctl: No need to check CAP_SYS_ADMIN
 for bpf_jit_*
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
 <1652079475-16684-3-git-send-email-yangtiezhu@loongson.cn>
 <9b5fadfb-7d43-7341-deeb-756885042a25@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <586ea9a2-0c81-97f8-72f4-260e0fcabaff@loongson.cn>
Date:   Tue, 10 May 2022 10:42:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <9b5fadfb-7d43-7341-deeb-756885042a25@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9BxENsN0XliBpIPAA--.61414S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFW3AFW5Ar4fWw18uw4DArb_yoWfGFg_Jr
        y7WFsrCw4rJr47u3W8K39xXry3Gw1DZws8Aa1fCrW2vw1rta45Ja4xKryDCas5XFyvvrsI
        9rsYqFWIy3ya9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l
        c2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
        tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf
        9x07je6wZUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/09/2022 11:02 PM, Daniel Borkmann wrote:
> On 5/9/22 8:57 AM, Tiezhu Yang wrote:
>> The mode of the following procnames are defined as 0644, 0600, 0600
>> and 0600 respectively in net_core_table[], normal user can not write
>> them, so no need to check CAP_SYS_ADMIN in the related proc_handler
>> function, just remove the checks.
>>
>> /proc/sys/net/core/bpf_jit_enable
>> /proc/sys/net/core/bpf_jit_harden
>> /proc/sys/net/core/bpf_jit_kallsyms
>> /proc/sys/net/core/bpf_jit_limit
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>
> I don't think we can make this assumption - there are various other
> (non-BPF)
> sysctl handlers in the tree doing similar check to prevent from userns'
> based
> CAP_SYS_ADMIN.
>

OK, thank you for your reply, let me drop this patch now,
I will send v2 (patch #1 and #3) later.

Thanks,
Tiezhu

