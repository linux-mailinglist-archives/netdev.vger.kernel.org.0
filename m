Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECFC7D1FD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbfGaXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:36:17 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33191 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfGaXgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:36:17 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so48821434lfc.0
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2VjrwJCxiQwueZ1twvT3oIyarEAfg5WYSCxQl8Fm8qc=;
        b=KgrGAl4/UHNSPtRYJubWs6nDoZ9AsJD49C9JUyUhQJrXDzk8snre5eAq6bjvQKi625
         7uNoCsl4rcyaHsRokDluvQ8k5RpJ9Riwu8y/y6EQFI+lh95wl2ERWO7cHt5iISv9U1A9
         AXvwA7ji/eSpYk63XRMlJPzrJf9XWLI0kmQnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2VjrwJCxiQwueZ1twvT3oIyarEAfg5WYSCxQl8Fm8qc=;
        b=sAP8pERHS9nwqExXUDbkU/70kzMSZf+5AGaP7irdE8EFw/hpbZA33MvJC3qna0Q6dW
         ZRV0+rxRfxZbK2CPxmzk3nPGDzi+PqKE6Cx30w3KsVe7Sg2kHrbAXxIyc7Ibns0Wnt2h
         f4qwkuziayuuduNXTPd70A71mN7aBEsOBgwF9jiQ+bAIYbti617RBK1Aw3KmY+LSFc4c
         6xVC0OQuC4EMaL59NgOrLzsuMq86595+5yAK8aZkTdco5az7esqGn4T2CN/JLppQrs3D
         DQG8EWZipxLLiD4sVH6bKDRb2Z628l5OXamapDUso0JUqUBqTIK9gGutr4NdsqJF0jl0
         g7tg==
X-Gm-Message-State: APjAAAWsxsAkB62towTdNZvuQPKUI9ukeZ7uf7pn0K8koMOcz1flbLOp
        JGls+IemlWvEwfla0Wqi18fzIw==
X-Google-Smtp-Source: APXvYqzdXA6HM4ddZqxn8OU/9MxCm7TKHKLA+KFhmosLWZ50p7JrcgsTvt7lL3ucNM4/JB/2vcDvjA==
X-Received: by 2002:a19:c887:: with SMTP id y129mr60111969lff.73.1564616175529;
        Wed, 31 Jul 2019 16:36:15 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id z23sm12008560lfq.77.2019.07.31.16.36.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 16:36:14 -0700 (PDT)
Subject: Re: [PATCH net v3] net: bridge: move vlan init/deinit to
 NETDEV_REGISTER/UNREGISTER
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
References: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
 <20190731224955.10908-1-nikolay@cumulusnetworks.com>
 <20190731155338.15ff34cb@hermes.lan>
 <c9a68f85-49f6-6d02-e130-a03d540aa0a7@cumulusnetworks.com>
Message-ID: <5cef086b-0b4c-44a2-c828-1c991000a1a0@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 02:36:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c9a68f85-49f6-6d02-e130-a03d540aa0a7@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 2:32 AM, Nikolay Aleksandrov wrote:
> On 8/1/19 1:53 AM, Stephen Hemminger wrote:
>>   
>>> -int br_vlan_init(struct net_bridge *br)
>>> +static int br_vlan_init(struct net_bridge *br)
>>>  {
>>>  	struct net_bridge_vlan_group *vg;
>>>  	int ret = -ENOMEM;
>>> @@ -1083,6 +1085,8 @@ int br_vlan_init(struct net_bridge *br)
>>>  	return ret;
>>>  
>>>  err_vlan_add:
>>> +	RCU_INIT_POINTER(br->vlgrp, NULL);
>>> +	synchronize_rcu();
>>
>> Calling sychronize_rcu is expensive. And the callback for
>> notifier is always called with rtnl_head. 
>>
>> Why not just keep the pointer initialization back in the
>> code where bridge is created, it was safe there.
>>
> 
> Because now the device registered and we've published the group, right now
> it is not an issue but if we expose an rcu helper we'll have to fix this
> because it'd become a bug.
> I'd prefer to have the error path correct and future-proof it, since it's
> an error path we're not concerned with speed, but rather correctness. Also
> these are rarely exercised so the bug might remain for a very long time.
> 
> 

About why move it - I've explained in the commit message, it might be safe
but it has presented a lot of bugs, we'll have to separate it in two parts
one that initializes the vlan group and second one which adds the fdb, then
we'll have to split the flush/delete in two different places to cleanup.
This way we have only a single exit point that cleans up and it works for
all cases. The synchronize there wouldn't be called under normal circumstances.



