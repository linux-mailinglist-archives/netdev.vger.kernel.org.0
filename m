Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD575B145B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 08:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIHGEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 02:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiIHGEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 02:04:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C02E13DF5;
        Wed,  7 Sep 2022 23:04:39 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MNT6L41phzgYyW;
        Thu,  8 Sep 2022 14:02:02 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 14:04:36 +0800
Message-ID: <9673fd54-a11a-369c-83e4-4a0a4236be74@huawei.com>
Date:   Thu, 8 Sep 2022 14:04:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,v2 01/22] net: sched: act: move global static
 variable net_id to tc_action_ops
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <martin.lau@linux.dev>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <ast@kernel.org>, <andrii@kernel.org>, <song@kernel.org>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
 <20220906121346.71578-2-shaozhengchao@huawei.com>
 <YxjQ0Pyz74xVLFBC@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <YxjQ0Pyz74xVLFBC@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/8 1:11, Cong Wang wrote:
> On Tue, Sep 06, 2022 at 08:13:25PM +0800, Zhengchao Shao wrote:
>> diff --git a/include/net/act_api.h b/include/net/act_api.h
>> index 9cf6870b526e..86253f8b69a3 100644
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -113,6 +113,7 @@ struct tc_action_ops {
>>   	enum tca_id  id; /* identifier should match kind */
>>   	size_t	size;
>>   	struct module		*owner;
>> +	unsigned int		net_id;
>>   	int     (*act)(struct sk_buff *, const struct tc_action *,
>>   		       struct tcf_result *); /* called under RCU BH lock*/
>>   	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
> 
> This _might_ introduce some unnecessary hole in this struct, could you
> check pahole output?
> 
> Thanks.

Hi Wang:
	Thank you for your review. I have send v3. And I'll pay
attention next time.

Zhengchao Shao
