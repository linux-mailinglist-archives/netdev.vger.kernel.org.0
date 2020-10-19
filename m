Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144A629302A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgJSVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgJSVDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:03:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA89C0613CE;
        Mon, 19 Oct 2020 14:03:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a1so501346pjd.1;
        Mon, 19 Oct 2020 14:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hxBelbPygyz/yC0KrNOxkFn9uM1ejxdi1qnz/Hbxc+E=;
        b=IAILx8K8165CKUtXluG83OHedKCocuY3KTRggkgMV19MWE+EGGMNFQEdqDdzu0iWTz
         TwhgFJ8YsWkM0YqGnm8n+kbv26Bgt+BnjzvuKDrJShKuqBfSvobFtWf56iSS7ubyWV88
         NIUp0b8rEAM5mI4+z/YyahUaYktEMIyWaV87hwl+Ng7cVSN7OsUpE1/+GZiCekefvFX9
         5lhVvPTzqWV9E49TZ9Thlao8ozbxgHVFIFyOxFEE3t1jvyapL+s4o8Bm+sFCRGlaWVHm
         3JJUA23B+fpLQeOcvtWTl7H+wYDPQ7p+wklRYIxflayoWlO20U2D4RSrkIJgP6/3cwMm
         7BSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hxBelbPygyz/yC0KrNOxkFn9uM1ejxdi1qnz/Hbxc+E=;
        b=HRPRvs2l+hyvLxh27Zn5LpKqlz5qUa6MmIylfTVcg2vLmbTwOhLVFTWuIzjOtvekv8
         PlKUEvZX4/K8g/+x2S9ObxQ5evB2bs1uy/XVpY5LAUxjAIxh1nhz5FLtv7bYhTzXi5bD
         ++ZPBr7+YoR+wr22+oeEvk65mHhtYARLdlQ2uKK5SSaBETmjYew5DORLk8pajdLMsmWO
         70UXVn/yN2kM0S7r9347llrWnug4DZTV9bIIds6J7UG3jd80QV7Wq8NZ9V3Fqek43wCe
         ECiBEKB0V1Vh+rDiFgtqs7e61H/2QCWVY3FyAX4Vb2e9uLSwBX/4KmJuR6d2gF/XzsDj
         QdrA==
X-Gm-Message-State: AOAM5326HGDlaKmu64HJy883XTaTO2X1mW6XhZzQ9RWncBdoH9LrPLrB
        HQwqNpPkS3M4WfqI7ZzPbWxR0DncJXc=
X-Google-Smtp-Source: ABdhPJy5zvG+vnwptE2dEOjRHOku/lBADJdo9KWGqmr3b2EUIAYOq9fNn9k9d7Z9qiDjyd/xwEPdVw==
X-Received: by 2002:a17:90a:4097:: with SMTP id l23mr1269927pjg.160.1603141422202;
        Mon, 19 Oct 2020 14:03:42 -0700 (PDT)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e16sm365296pjr.36.2020.10.19.14.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 14:03:41 -0700 (PDT)
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
Date:   Mon, 19 Oct 2020 14:03:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019200258.jrtymxikwrijkvpq@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 1:02 PM, Vladimir Oltean wrote:
> On Mon, Oct 19, 2020 at 10:17:44AM -0700, Florian Fainelli wrote:
>> These devices also do not utilize the upper/lower linking so the
>> check about the netpoll device having upper is not going to be a
>> problem.
> 
> They do as of 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), don't they? The question is why
> that doesn't work, and the answer is, I believe, that the linkage needs
> to be the other way around than DSA has it.



> 
>>
>> The solution adopted here is identical to the one done for
>> net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
>> master network devices"), with the network namespace scope being
>> restricted to that of the process configuring netpoll.
> 
> ... and further restricted to the only network namespace that DSA
> supports. As a side note, we should declare NETIF_F_NETNS_LOCAL_BIT for
> DSA interfaces.
> 
>>
>> Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  net/core/netpoll.c | 22 ++++++++++++++++++----
>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
>> index c310c7c1cef7..960948290001 100644
>> --- a/net/core/netpoll.c
>> +++ b/net/core/netpoll.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/export.h>
>>  #include <linux/if_vlan.h>
>> +#include <net/dsa.h>
>>  #include <net/tcp.h>
>>  #include <net/udp.h>
>>  #include <net/addrconf.h>
>> @@ -657,15 +658,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
>>  
>>  int netpoll_setup(struct netpoll *np)
>>  {
>> -	struct net_device *ndev = NULL;
>> +	struct net_device *ndev = NULL, *dev = NULL;
>> +	struct net *net = current->nsproxy->net_ns;
>>  	struct in_device *in_dev;
>>  	int err;
>>  
>>  	rtnl_lock();
>> -	if (np->dev_name[0]) {
>> -		struct net *net = current->nsproxy->net_ns;
>> +	if (np->dev_name[0])
>>  		ndev = __dev_get_by_name(net, np->dev_name);
>> -	}
>> +
>>  	if (!ndev) {
>>  		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
>>  		err = -ENODEV;
>> @@ -673,6 +674,19 @@ int netpoll_setup(struct netpoll *np)
>>  	}
>>  	dev_hold(ndev);
>>  
>> +	/* bring up DSA management network devices up first */
>> +	for_each_netdev(net, dev) {
>> +		if (!netdev_uses_dsa(dev))
>> +			continue;
>> +
>> +		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
>> +		if (err < 0) {
>> +			np_err(np, "%s failed to open %s\n",
>> +			       np->dev_name, dev->name);
>> +			goto put;
>> +		}
>> +	}
>> +
> 
> Completely crazy and outlandish idea, I know, but what's wrong with
> doing this in DSA?

I really do not have a problem with that approach however other stacked
devices like 802.1Q do not do that. It certainly scales a lot better to
do this within DSA rather than sprinkling DSA specific knowledge
throughout the network stack. Maybe for "configuration less" stacked
devices such as DSA, 802.1Q (bridge ports?), bond etc. it would be
acceptable to ensure that the lower device is always brought up?

PS: if you quote below the git version, it would appear that Thunderbird
just eats that part of the mail... another bug to submit there.
-- 
Florian
