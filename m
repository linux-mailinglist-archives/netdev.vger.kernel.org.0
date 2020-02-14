Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4761915D3DF
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 09:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgBNIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 03:33:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgBNIde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 03:33:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id w12so9891187wrt.2
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 00:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ga2UjLKuVSIX3KkoqxUzrI3r+N/AydKyt5U+BEN4+kc=;
        b=FA0WS6rjZ5/PFEljQWq9/66CO1IKzs//KK0bCSEbnOhyvHr+Scvfs6HZ/MhMzNHPNm
         fjip/MfMJ00EM8xCCofmv8WCKjj6jD/TFYA9wN05tsBiHZtzU2SyaKJ5AfrAYTjlHIag
         TnW9lEEzywEO6fyZupFPCA3DwU4G/2QzjbaUbVYF41cCP88YNV2YVTuMdH/WTALysg7W
         e/lkxij8ZYgHtKkcdfMrjFjPZKUBo1MiuDUlyJL82UGQvGCVlxRH1nXp+O2xp4wPc2uQ
         GVQLdjWPrhRFYrojuwz6EWaFJbOqmFH7H/ZN+4iAeaIbxX4hHj5kjqgKVZ+MaFhx//M9
         gz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ga2UjLKuVSIX3KkoqxUzrI3r+N/AydKyt5U+BEN4+kc=;
        b=D43Frc4Ik8x+/ltJIO0manrE0uFNUPLnAl7jVyo5Ik54It62m5uFWX3Vj4Ac9UYL7P
         7lh57yDKyoHmjJ5ul0xim4zuxk+OuBmYHo2SSH2spaV4O1/oZu1j21MqkwJ5UVyWsPoS
         8igvHbAQuCqw1se168gmYOQ3nnoFfA7OYpUYkIk28M2f/liqim/Dtk9wVb9X+x4zck/6
         wW9/f/cVk6c8Ul0nantIH4VpaQgl+IcdzDqZdXXJM3G5AUhZYAx9/Dhyg7rvCql8ZM9j
         bKM1iThVgZEm/mk38nqIA2Rss9hYS5LeaXdn0Lw+SeJale/34FpwI/tJLXr6SzGVUmTY
         rFVA==
X-Gm-Message-State: APjAAAUPiaOYueA+FgcpQbpXsFg7AWRjWNXRRqcD/qPznjSmkmLWLPh+
        N0ITN31NqUBxQumGKc0XnPtBxQ==
X-Google-Smtp-Source: APXvYqykPB2o6zu5qz0aEAmCV5drtZLktVPr+8z/Bl3kMkBlQxew4fx5K5AaE7OxhsDNX2OeWEEoww==
X-Received: by 2002:a5d:494f:: with SMTP id r15mr2738423wrs.143.1581669210958;
        Fri, 14 Feb 2020 00:33:30 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id p15sm6257061wma.40.2020.02.14.00.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 00:33:30 -0800 (PST)
Date:   Fri, 14 Feb 2020 09:33:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
Message-ID: <20200214083329.GA2100@nanopsycho>
References: <20200213045826.181478-1-edumazet@google.com>
 <20200213064532.GD22610@nanopsycho>
 <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
 <741c1c4e-9f83-d5bd-0100-d33cb5db7cc6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741c1c4e-9f83-d5bd-0100-d33cb5db7cc6@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 14, 2020 at 08:11:26AM CET, eric.dumazet@gmail.com wrote:
>
>
>On 2/12/20 10:58 PM, Eric Dumazet wrote:
>> 
>> 
>> On 2/12/20 10:45 PM, Jiri Pirko wrote:
>>> Thu, Feb 13, 2020 at 05:58:26AM CET, edumazet@google.com wrote:
>>>> Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
>>>> guarantee it is nul terminated.
>>>>
>>>> We should use nla_strdup() instead of kstrdup(), since this
>>>> helper will make sure not accessing out-of-bounds data.
>>>>
>>>>
>>>> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>> Cc: Jiri Pirko <jiri@mellanox.com>
>>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>>> ---
>>>> net/core/rtnetlink.c | 26 ++++++++++++--------------
>>>> 1 file changed, 12 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>>> index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
>>>> --- a/net/core/rtnetlink.c
>>>> +++ b/net/core/rtnetlink.c
>>>> @@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>>>> 	if (err)
>>>> 		return err;
>>>>
>>>> -	alt_ifname = nla_data(attr);
>>>> +	alt_ifname = nla_strdup(attr, GFP_KERNEL);
>>>> +	if (!alt_ifname)
>>>> +		return -ENOMEM;
>>>> +
>>>> 	if (cmd == RTM_NEWLINKPROP) {
>>>> -		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
>>>> -		if (!alt_ifname)
>>>> -			return -ENOMEM;
>>>> 		err = netdev_name_node_alt_create(dev, alt_ifname);
>>>> -		if (err) {
>>>> -			kfree(alt_ifname);
>>>> -			return err;
>>>> -		}
>>>> +		if (!err)
>>>> +			alt_ifname = NULL;
>>>> 	} else if (cmd == RTM_DELLINKPROP) {
>>>> 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
>>>> -		if (err)
>>>> -			return err;
>>>> 	} else {
>>>
>>>
>>>> -		WARN_ON(1);
>>>> -		return 0;
>>>> +		WARN_ON_ONCE(1);
>>>> +		err = -EINVAL;
>>>
>>> These 4 lines do not seem to be related to the rest of the patch. Should
>>> it be a separate patch?
>> 
>> Well, we have to kfree(alt_ifname).
>> 
>> Generally speaking I tried to avoid return in the middle of this function.
>> 
>> The WARN_ON(1) is dead code today, making it a WARN_ON_ONCE(1) is simply
>> a matter of avoiding syslog floods if this path is ever triggered in the future.
>
>Also, related to this new fancy code ;)
>
>Is there anything preventing netdev_name_node_alt_destroy() from destroying the primary
>ifname ?
>
>netdev_name_node_lookup() should be able to find dev->name_node itself ?
>
>Then we would leave a dangling pointer in dev->name_node, and crash later.
>
>I am thinking we need this fix :

That is correct. We need that. Thanks!


>
>diff --git a/net/core/dev.c b/net/core/dev.c
>index a6316b336128cdb31eea6e80f1a47620abbd0d31..3fa2bc2c30ee1350b5b4b400f0552b9bf2a62697 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -331,6 +331,11 @@ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
>        name_node = netdev_name_node_lookup(net, name);
>        if (!name_node)
>                return -ENOENT;
>+
>+       /* Do not trust users, ever ! */
>+       if (name_node == dev->name_node || name_node->dev != dev)
>+               return -EINVAL;
>+
>        __netdev_name_node_alt_destroy(name_node);
> 
>        return 0;
