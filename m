Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021755BA441
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 03:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiIPB6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 21:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiIPB6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 21:58:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B7E82848;
        Thu, 15 Sep 2022 18:58:22 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTHG925pHznVJ0;
        Fri, 16 Sep 2022 09:55:29 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 09:58:11 +0800
Message-ID: <82fde04f-5f49-525c-dcf5-f5ab8a0d3ec4@huawei.com>
Date:   Fri, 16 Sep 2022 09:58:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,v3 1/9] net/sched: cls_api: add helper for tc cls
 walker stats updating
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <shuah@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220915063038.20010-1-shaozhengchao@huawei.com>
 <20220915063038.20010-2-shaozhengchao@huawei.com>
 <YyOz3qLWTS3raNpe@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <YyOz3qLWTS3raNpe@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/16 7:23, Cong Wang wrote:
> On Thu, Sep 15, 2022 at 02:30:30PM +0800, Zhengchao Shao wrote:
>> The walk implementation of most tc cls modules is basically the same.
>> That is, the values of count and skip are checked first. If count is
>> greater than or equal to skip, the registered fn function is executed.
>> Otherwise, increase the value of count. So we can reconstruct them.
>>
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> ---
>>   include/net/pkt_cls.h | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index d9d90e6925e1..d3cbbabf7592 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
>> @@ -81,6 +81,19 @@ int tcf_classify(struct sk_buff *skb,
>>   		 const struct tcf_proto *tp, struct tcf_result *res,
>>   		 bool compat_mode);
>>   
>> +static inline bool tc_cls_stats_update(struct tcf_proto *tp,
> 
> This function name is confusing, I don't think it updates anything,
> probably we only dump stats when calling ->walk(). Please use a better
> name here, like tc_cls_stats_dump().
> 
> Thanks.
Hi Wang：
	Thank you for your review. I will send V4.

Zhengchao Shao
