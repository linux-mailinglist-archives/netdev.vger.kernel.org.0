Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558642BBBC2
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgKUCAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:00:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7716 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgKUCAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:00:47 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CdGpD6RPKzkcZg;
        Sat, 21 Nov 2020 10:00:20 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 21 Nov 2020
 10:00:36 +0800
Subject: Re: [RFC V2 net-next 1/2] ethtool: add support for controling the
 type of adaptive coalescing
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <kuba@kernel.org>, <mkubecek@suse.cz>
References: <1605853479-4483-1-git-send-email-tanhuazhong@huawei.com>
 <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
 <20201120152548.GN1853236@lunn.ch>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <51257502-cf5e-0a98-5bbd-5e3d18d3e15a@huawei.com>
Date:   Sat, 21 Nov 2020 10:00:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201120152548.GN1853236@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/20 23:25, Andrew Lunn wrote:
>> @@ -310,6 +334,13 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
>>   	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
>>   	if (ret < 0)
>>   		goto out_ops;
>> +
>> +	if (ops->set_ext_coalesce) {
>> +		ret = ops->set_ext_coalesce(dev, &ext_coalesce);
>> +		if (ret < 0)
>> +			goto out_ops;
>> +	}
>> +
> 
> The problem here is, if ops->set_ext_coalesce() fails, you need to
> undo what dev->ethtool_ops->set_coalesce() did. From the users
> perspective, this should be atomic. It does everything, or it does
> nothing and returns an error code.
> 
> And that is not easy given this structure of two op calls.
> 
>      Andrew
> 

yes, i will try what Michal suggested in V1.

Regards.
Huazhong.

> .
> 

