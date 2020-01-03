Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3088612F564
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgACIZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:25:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgACIZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 03:25:33 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A244BD010FAE0F605C51;
        Fri,  3 Jan 2020 16:25:29 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 Jan 2020
 16:25:23 +0800
Subject: Re: [PATCH net-next] ethtool: remove set but not used variable
 'lsettings'
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
References: <20200103034856.177906-1-yuehaibing@huawei.com>
 <20200103073923.GA4769@unicorn.suse.cz>
CC:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <532c6c68-4dd6-bd08-2a86-a257f3384156@huawei.com>
Date:   Fri, 3 Jan 2020 16:25:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200103073923.GA4769@unicorn.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/3 15:39, Michal Kubecek wrote:
> On Fri, Jan 03, 2020 at 03:48:56AM +0000, YueHaibing wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> net/ethtool/linkmodes.c: In function 'ethnl_set_linkmodes':
>> net/ethtool/linkmodes.c:326:32: warning:
>>  variable 'lsettings' set but not used [-Wunused-but-set-variable]
>>   struct ethtool_link_settings *lsettings;
>>                                 ^
>> It is never used, so remove it.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/ethtool/linkmodes.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
>> index 0b99f494ad3b..96f20be64553 100644
>> --- a/net/ethtool/linkmodes.c
>> +++ b/net/ethtool/linkmodes.c
>> @@ -323,7 +323,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
>>  {
>>  	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
>>  	struct ethtool_link_ksettings ksettings = {};
>> -	struct ethtool_link_settings *lsettings;
>>  	struct ethnl_req_info req_info = {};
>>  	struct net_device *dev;
>>  	bool mod = false;
>> @@ -354,7 +353,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
>>  			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>>  		goto out_ops;
>>  	}
>> -	lsettings = &ksettings.base;
>>  
>>  	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
>>  	if (ret < 0)
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> Thank you. I wonder why my compiler does not complain.

Using make W=1

> 
> Michal
> 
> .
> 

