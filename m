Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE3609F5B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJXKxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJXKxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:53:34 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D389959E94
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:53:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MwsHr64hxz15Lwh;
        Mon, 24 Oct 2022 18:48:40 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 18:53:30 +0800
Message-ID: <f7b4472d-013a-2999-7ea5-623af852ed3b@huawei.com>
Date:   Mon, 24 Oct 2022 18:53:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: sched: cbq: stop timer in cbq_destroy() when
 cbq_init() fails
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <kaber@trash.net>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221022104054.221968-1-shaozhengchao@huawei.com>
 <Y1Ss3OaWuWR5p2A3@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y1Ss3OaWuWR5p2A3@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/23 10:54, Cong Wang wrote:
> On Sat, Oct 22, 2022 at 06:40:54PM +0800, Zhengchao Shao wrote:
>> When qdisc_create() fails to invoke the cbq_init() function for
>> initialization, the timer has been started. But cbq_destroy() doesn't
>> stop the timer. Fix it.
>>
> 
> Hmm? qdisc_watchdog_init() only initializes it, not starts it, right?
> 
> Thanks.
Hi Wang:
	Thank you for your review. The description is incorrect,
qdisc_watchdog_init() only initializes timer, and cbq_destroy() missed
to cancle timer.

Zhengchao Shao
