Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC42B1A74
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKMMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:02:41 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7536 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgKMMCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:02:20 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CXcTg6xYLzhkB3;
        Fri, 13 Nov 2020 19:59:51 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Nov 2020 19:59:57 +0800
Subject: Re: [PATCH net] devlink: Add missing genlmsg_cancel() in
 devlink_nl_sb_port_pool_fill()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <davem@davemloft.net>, <idosch@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201111135853.63997-1-wanghai38@huawei.com>
 <20201112095124.660733a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <c6c5af9e-431d-97f7-16d3-aa4774041765@huawei.com>
Date:   Fri, 13 Nov 2020 19:59:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201112095124.660733a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/13 1:51, Jakub Kicinski 写道:
> On Wed, 11 Nov 2020 21:58:53 +0800 Wang Hai wrote:
>> If sb_occ_port_pool_get() failed in devlink_nl_sb_port_pool_fill(),
>> msg should be canceled by genlmsg_cancel().
>> +++ b/net/core/devlink.c
>> @@ -1447,8 +1447,10 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
[...]
>>   			return err;
> I guess the driver would have to return -EMSGSIZE for this to matter,
> which is quite unlikely but we should indeed fix.
>
> Still, returning in the middle of the function with an epilogue is what
> got use here in the first place, so please use a goto. E.g. like this:
>
[...]
>   static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
>
> .

Thanks for your review,  I just sent v2

[PATCH v2 net] devlink: Add missing genlmsg_cancel() in 
devlink_nl_sb_port_pool_fill()

