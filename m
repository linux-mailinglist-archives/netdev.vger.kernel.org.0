Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF1C615B1C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiKBDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBDsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:48:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46579275E2;
        Tue,  1 Nov 2022 20:48:07 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2CX24THmzHvKH;
        Wed,  2 Nov 2022 11:47:46 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 11:47:43 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 11:47:43 +0800
Subject: Re: [PATCH net-next] ipvlan: minor optimization for ipvlan outbound
 process
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221102021549.12213-1-linyunsheng@huawei.com>
 <CANn89iJWyLQDHHJXNHb78zpX=At1oyqPaUmeQ5-GuzX2YOxGDQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9cdb2fff-9eee-564d-f8df-38ff7125dad2@huawei.com>
Date:   Wed, 2 Nov 2022 11:47:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJWyLQDHHJXNHb78zpX=At1oyqPaUmeQ5-GuzX2YOxGDQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/2 11:23, Eric Dumazet wrote:
> On Tue, Nov 1, 2022 at 7:15 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Avoid some local variable initialization and remove some
>> redundant assignment in ipvlan outbound process.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Really I do not see the point of such a patch, making future backports
> more difficult.

As the ipvlan outbound process is in the fast path, avoiding the
unnecessary steps might be worth the backport cost.

Anyway, it is more of judgment call, not a rule, right?

> 
> Changing old code like that should only be done if this is really necessary,
> for instance before adding a new functionality.
> .
> 
