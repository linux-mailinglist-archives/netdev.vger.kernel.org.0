Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5449012FDD4
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgACUWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:22:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgACUWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:22:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE1A6159761FA;
        Fri,  3 Jan 2020 12:22:32 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:22:29 -0800 (PST)
Message-Id: <20200103.122229.1623284927697664894.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, yuehaibing@huawei.com,
        f.fainelli@gmail.com, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] ethtool: remove set but not used variable
 'lsettings'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103073923.GA4769@unicorn.suse.cz>
References: <20200103034856.177906-1-yuehaibing@huawei.com>
        <20200103073923.GA4769@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:22:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Fri, 3 Jan 2020 08:39:23 +0100

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

Applied, thanks.
