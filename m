Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61ACE63B740
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiK2B3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiK2B3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:29:22 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D412ED58;
        Mon, 28 Nov 2022 17:29:21 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NLl955YHkz15MxW;
        Tue, 29 Nov 2022 09:28:41 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 09:29:19 +0800
Message-ID: <3a3e0df0-fe2f-78c4-41ce-5cf194607a3a@huawei.com>
Date:   Tue, 29 Nov 2022 09:29:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] udp_tunnel: Add checks for nla_nest_start() in
 __udp_tunnel_nic_dump_write()
To:     David Ahern <dsahern@kernel.org>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20221126100634.106887-1-yuancan@huawei.com>
 <20221126100634.106887-2-yuancan@huawei.com>
 <d3eb1d37-fcbc-e3d7-30d4-3e97aa20696b@kernel.org>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <d3eb1d37-fcbc-e3d7-30d4-3e97aa20696b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/28 3:39, David Ahern 写道:
> On 11/26/22 3:06 AM, Yuan Can wrote:
>> As the nla_nest_start() may fail with NULL returned, the return value needs
>> to be checked.
>>
>> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>>   net/ipv4/udp_tunnel_nic.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
>> index bc3a043a5d5c..75a0caa4aebe 100644
>> --- a/net/ipv4/udp_tunnel_nic.c
>> +++ b/net/ipv4/udp_tunnel_nic.c
>> @@ -624,6 +624,8 @@ __udp_tunnel_nic_dump_write(struct net_device *dev, unsigned int table,
>>   			continue;
>>   
>>   		nest = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
>> +		if (!nest)
>> +			goto err_cancel;
> no need to call nla_nest_cancel if nest_start fails.
Ok, thanks for the suggestion, it will be fixed in the next version.

-- 
Best regards,
Yuan Can

