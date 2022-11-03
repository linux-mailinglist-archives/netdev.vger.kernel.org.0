Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534E561793D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiKCI7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKCI7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:59:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE1B5583;
        Thu,  3 Nov 2022 01:59:05 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2yNg19LXz15MLT;
        Thu,  3 Nov 2022 16:58:59 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 16:59:03 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 16:59:02 +0800
Subject: Re: [PATCH] uapi: Add missing linux/stddef.h header file to in.h
To:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <keescook@chromium.org>,
        <gustavoars@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <acme@kernel.org>
References: <20221031095517.100297-1-yangjihong1@huawei.com>
 <477a37b80b01d5eaa895effa20df29bcf02f65b6.camel@redhat.com>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <300b547d-8ea5-d7d1-f39e-d55df73847cd@huawei.com>
Date:   Thu, 3 Nov 2022 16:59:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <477a37b80b01d5eaa895effa20df29bcf02f65b6.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

On 2022/11/3 16:25, Paolo Abeni wrote:
> On Mon, 2022-10-31 at 17:55 +0800, Yang Jihong wrote:
>> commit 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper") does not
>> include "linux/stddef.h" header file, and tools headers update linux/in.h copy,
>> BPF prog fails to be compiled:
>>
>>      CLNG-BPF [test_maps] bpf_flow.bpf.o
>>      CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.bpf.o
>>    In file included from progs/cgroup_skb_sk_lookup_kern.c:9:
>>    /root/linux/tools/include/uapi/linux/in.h:199:3: error: type name requires a specifier or qualifier
>>                    __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>>                    ^
>>    /root/linux/tools/include/uapi/linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
>>                    __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>>                                                 ^
>>    2 errors generated.
>>
>> To maintain consistency, add missing header file to kernel.
>> Fixes: 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
>>
>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> 
> The 'Fixes' tag must be separated by the commit message by a blank
> line, and you need to remove the empty line between 'Fixes' and SoB.
> 
> Additionally, on repost, please specify the target tree in the patch
> subj, and wrap the commit message text to 75 chars per line (that does
> not apply to the build output).
> 
OK, will fix these issues in the next version, thanks for your advice.


Thanks,
Yang
> Thanks,
> 
> Paolo
> 
> 
> .
> 
