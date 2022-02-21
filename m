Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8DB4BD4D3
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 05:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241009AbiBUEpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 23:45:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiBUEpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 23:45:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5022C517EC
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 20:44:51 -0800 (PST)
Received: from kwepemi100011.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K28jx2Dkfzbbby;
        Mon, 21 Feb 2022 12:40:21 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100011.china.huawei.com (7.221.188.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 12:44:49 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 12:44:48 +0800
Subject: Re: [PATCH net-next 1/2] ipv4: Invalidate neighbour for broadcast
 address upon address addition
To:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <mlxsw@nvidia.com>
References: <20220219154520.344057-1-idosch@nvidia.com>
 <20220219154520.344057-2-idosch@nvidia.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <c1d43b6e-1756-fc6b-4b68-7c9739044abb@huawei.com>
Date:   Mon, 21 Feb 2022 12:44:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220219154520.344057-2-idosch@nvidia.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2022/2/19 23:45, Ido Schimmel Ð´µÀ:
> In case user space sends a packet destined to a broadcast address when a
> matching broadcast route is not configured, the kernel will create a
> unicast neighbour entry that will never be resolved [1].
>
> When the broadcast route is configured, the unicast neighbour entry will
> not be invalidated and continue to linger, resulting in packets being
> dropped.
>
> Solve this by invalidating unresolved neighbour entries for broadcast
> addresses after routes for these addresses are internally configured by
> the kernel. This allows the kernel to create a broadcast neighbour entry
> following the next route lookup.
>
> Another possible solution that is more generic but also more complex is
> to have the ARP code register a listener to the FIB notification chain
> and invalidate matching neighbour entries upon the addition of broadcast
> routes.
>
> It is also possible to wave off the issue as a user space problem, but
> it seems a bit excessive to expect user space to be that intimately
> familiar with the inner workings of the FIB/neighbour kernel code.
>
> [1] https://lore.kernel.org/netdev/55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com/
>
> Reported-by: Wang Hai <wanghai38@huawei.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> Wang Hai, please retest as I have changed the patch a bit.
Thanks, retested and it worked.

Tested-by: Wang Hai <wanghai38@huawei.com>

-- 
Wang Hai

