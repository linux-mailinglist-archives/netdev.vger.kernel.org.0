Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E06915B9F6
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 08:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgBMHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 02:17:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54800 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgBMHRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 02:17:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so4957143wmh.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 23:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I4lwcgR3mtEIRDtxsNmEXLX2hhHe2uY/jTA0l1zNMqU=;
        b=sIHAIXek/31kvbbUBsnYJ9Dhyp/rp+jaDY7I+2uYqjqTEABKvCNnrKQzX6c3bmI7fV
         pLCyHgqFSlQDC76j0pp7XlyHJrFt4snD1HG9ibe4B5cO/c8PIXBp+7LFUWvsA6vJDu4k
         RZ9VW59q4ePB5PsjeT7HKIgYAWLmhbdxzWBrxqIWn+vFxMXqRppK27L1euUBZofei3yR
         FuASHRQIL1wQLs10zwNN002aCmrjapIZlMgWn34NGwbqKu9dZg/OBcO30SDtq65xP8YX
         5rw8MrgjK1jW8XBwL23oM9XE2bUDZdFbtQtDiM2vDjIsM1BIkdUuzCDdt0VRbj31mcF2
         NCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I4lwcgR3mtEIRDtxsNmEXLX2hhHe2uY/jTA0l1zNMqU=;
        b=FTDNGxGiZ4kDNA8gPrbnTPxz3KCqsBKc0HVTbhUIhAgeKmswPEYDgZvXZ45/yGMV10
         IGqTDIuEDfoKuviH3FNeWmIapW7cJ4aWMlmg5pu8duqtM+tbujt2NPKTyw3MljwaMqjm
         3yqwLQwb2PrmUGkKbthSYJ19X3sjfh54rKG8tuyX3EE8uxNSrEQRLf9vyRJ5MDvlfwXH
         vZn9Oy5WBQCdPX22Y4dQsPOK3sBRLtRzHI8pT5ZEDD0S3IuB3OQIkkaC8m2/dhlahFF9
         HC6LssThA5XmfCGdwXouAWp22VImo6PnqPK8luYAGpHNXk2/fRPvmPkSveCufqtA4kt/
         fSZA==
X-Gm-Message-State: APjAAAU4Scv30YMqg0PP+ZLxQX5AYyHKEPwnfIq8oe6rAO44elczgXmD
        btFUkJOL1jpPjJwEpQv8oZ1FBQ==
X-Google-Smtp-Source: APXvYqxGj6Topf32rclkxkuMQrEaxLLFFXAiA4sBQzRcQUWbNUmc7I62z1QKdNQeeP6zvaZVJHcBpQ==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr4063726wmb.130.1581578223103;
        Wed, 12 Feb 2020 23:17:03 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id e1sm1665236wrt.84.2020.02.12.23.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 23:17:02 -0800 (PST)
Date:   Thu, 13 Feb 2020 08:17:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
Message-ID: <20200213071701.GE22610@nanopsycho>
References: <20200213045826.181478-1-edumazet@google.com>
 <20200213064532.GD22610@nanopsycho>
 <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 13, 2020 at 07:58:01AM CET, eric.dumazet@gmail.com wrote:
>
>
>On 2/12/20 10:45 PM, Jiri Pirko wrote:
>> Thu, Feb 13, 2020 at 05:58:26AM CET, edumazet@google.com wrote:
>>> Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
>>> guarantee it is nul terminated.
>>>
>>> We should use nla_strdup() instead of kstrdup(), since this
>>> helper will make sure not accessing out-of-bounds data.
>>>
>>> 
>>> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Cc: Jiri Pirko <jiri@mellanox.com>
>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>> ---
>>> net/core/rtnetlink.c | 26 ++++++++++++--------------
>>> 1 file changed, 12 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>> index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
>>> --- a/net/core/rtnetlink.c
>>> +++ b/net/core/rtnetlink.c
>>> @@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>>> 	if (err)
>>> 		return err;
>>>
>>> -	alt_ifname = nla_data(attr);
>>> +	alt_ifname = nla_strdup(attr, GFP_KERNEL);
>>> +	if (!alt_ifname)
>>> +		return -ENOMEM;
>>> +
>>> 	if (cmd == RTM_NEWLINKPROP) {
>>> -		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
>>> -		if (!alt_ifname)
>>> -			return -ENOMEM;
>>> 		err = netdev_name_node_alt_create(dev, alt_ifname);
>>> -		if (err) {
>>> -			kfree(alt_ifname);
>>> -			return err;
>>> -		}
>>> +		if (!err)
>>> +			alt_ifname = NULL;
>>> 	} else if (cmd == RTM_DELLINKPROP) {
>>> 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
>>> -		if (err)
>>> -			return err;
>>> 	} else {
>> 
>> 
>>> -		WARN_ON(1);
>>> -		return 0;
>>> +		WARN_ON_ONCE(1);
>>> +		err = -EINVAL;
>> 
>> These 4 lines do not seem to be related to the rest of the patch. Should
>> it be a separate patch?
>
>Well, we have to kfree(alt_ifname).
>
>Generally speaking I tried to avoid return in the middle of this function.

Yep, but you also change the return value. So that looked to me like
something for another patch. But as you wish :)


>
>The WARN_ON(1) is dead code today, making it a WARN_ON_ONCE(1) is simply
>a matter of avoiding syslog floods if this path is ever triggered in the future.
>
>> 
>> Otherwise, the patch looks fine to me.
>>
>
>Thanks !
>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

