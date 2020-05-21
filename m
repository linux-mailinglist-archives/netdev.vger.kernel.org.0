Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978D1DD396
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgEUQ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728632AbgEUQ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:58:10 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28457C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 09:58:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i15so7320131wrx.10
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 09:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Y9QXn5/MtNpd1gpuH+YQVxBDqCPuf0vIRP+fPeT388=;
        b=CQ7SXN1PdVyxzxTn48IBDk1HDqJrKf6aZ67r0kdzGCIMp82jRV5cP4cXU2qsgf8AMR
         f0AYNpGAUQai+4PcqZ5mqW77BBJDzPWRJnwb8ORAmgyJ5eeg8et4blG30bbGrcpoxGMM
         rYvRWqpfyEztOdLirxGPacBA6cO421LA1RVow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Y9QXn5/MtNpd1gpuH+YQVxBDqCPuf0vIRP+fPeT388=;
        b=kjr20a6772srim6NbeTbBTAhrFBSWNcSKrXLcdvnm63jASColSsfReZiH5mmd1tGHW
         P3Tzp7UrYMoEXRgjave1duRQcia23Q84Y3YoNbjFLLXcVWKeUQV3o1h60ZHRqzIQ/CZF
         KrYsth9DZe6Bau1OT9VgKJibYpudZC2a+W2fCA/XRzAiRuWNLtqZu0dPUyTgFs8aKco1
         81zIBJ2uz7SG2q0RYkvZ8PMRmOKqCKnUdKLObwOsPCmGCbBHzSHIpZhVDFeSWFNhfJPV
         6/4jg4eh0BLIopFdTk4lQyEJJ71hl4oEUHrVKvj0YHpgGN0zdnIi3k5E+qr8I1jbBmEx
         5eSQ==
X-Gm-Message-State: AOAM531b4rRVukwrrAj0PmslOe0UVZI9tU1j2/mW6T4dzjQYW+ztMejf
        1dqn9lPED3I4FZ7U4jvcL9iFnA==
X-Google-Smtp-Source: ABdhPJwtTFeFA0RzSf70parteHd+eKsBzJ7WMtkTQlSR9kL4jx9EHI7evkipwvopFBuSAuWcIlqymA==
X-Received: by 2002:a5d:5389:: with SMTP id d9mr6717311wrv.77.1590080287860;
        Thu, 21 May 2020 09:58:07 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q15sm6224927wrf.87.2020.05.21.09.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 09:58:07 -0700 (PDT)
Subject: Re: [PATCH 1/3] bridge: mrp: Add br_mrp_unique_ifindex function
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
        kuba@kernel.org, roopa@cumulusnetworks.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
 <20200520130923.3196432-2-horatiu.vultur@microchip.com>
 <cecbdbf0-bb49-1e3c-c163-8e7412c6fcec@cumulusnetworks.com>
 <20200521181337.ory6lxyswatqhoej@soft-dev3.localdomain>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <39ba5110-2c2a-6fd9-a3e3-000b52a366dc@cumulusnetworks.com>
Date:   Thu, 21 May 2020 19:58:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200521181337.ory6lxyswatqhoej@soft-dev3.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/2020 21:49, Horatiu Vultur wrote:
> The 05/21/2020 11:16, Nikolay Aleksandrov wrote:
>> On 20/05/2020 16:09, Horatiu Vultur wrote:
>>> It is not allow to have the same net bridge port part of multiple MRP
>>> rings. Therefore add a check if the port is used already in a different
>>> MRP. In that case return failure.
>>>
>>> Fixes: 9a9f26e8f7ea ("bridge: mrp: Connect MRP API with the switchdev API")
>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>> ---
>>>  net/bridge/br_mrp.c | 31 +++++++++++++++++++++++++++++++
>>>  1 file changed, 31 insertions(+)
>>>
>>> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
>>> index d7bc09de4c139..a5a3fa59c078a 100644
>>> --- a/net/bridge/br_mrp.c
>>> +++ b/net/bridge/br_mrp.c
>>> @@ -37,6 +37,32 @@ static struct br_mrp *br_mrp_find_id(struct net_bridge *br, u32 ring_id)
>>>       return res;
>>>  }
>>>
>>> +static bool br_mrp_unique_ifindex(struct net_bridge *br, u32 ifindex)
>>> +{
>>> +     struct br_mrp *mrp;
>>> +     bool res = true;
>>> +
>>> +     rcu_read_lock();
>>
>> Why do you need the rcu_read_lock() here when lockdep_rtnl_is_held() is used?
>> You should be able to just do rtnl_dereference() below as this is used only
>> under rtnl.
> 
> Hi Nik,
> 
> Also initially I thought that is not needed, but when I enabled all the
> RCU debug configs to see if I use correctly the RCU, I got a warning
> regarding suspicious RCU usage.
> And that is the reason why I have put it.
> 

Did you try using rtnl_dereference() instead of rcu_dereference() ?

>>
>>> +     list_for_each_entry_rcu(mrp, &br->mrp_list, list,
>>> +                             lockdep_rtnl_is_held()) {
>>> +             struct net_bridge_port *p;
>>> +
>>> +             p = rcu_dereference(mrp->p_port);
>>> +             if (p && p->dev->ifindex == ifindex) {
>>> +                     res = false;
>>> +                     break;
>>> +             }
>>> +
>>> +             p = rcu_dereference(mrp->s_port);
>>> +             if (p && p->dev->ifindex == ifindex) {
>>> +                     res = false;
>>> +                     break;
>>> +             }
>>> +     }
>>> +     rcu_read_unlock();
>>> +     return res;
>>> +}
>>> +
>>>  static struct br_mrp *br_mrp_find_port(struct net_bridge *br,
>>>                                      struct net_bridge_port *p)
>>>  {
>>> @@ -255,6 +281,11 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
>>>           !br_mrp_get_port(br, instance->s_ifindex))
>>>               return -EINVAL;
>>>
>>> +     /* It is not possible to have the same port part of multiple rings */
>>> +     if (!br_mrp_unique_ifindex(br, instance->p_ifindex) ||
>>> +         !br_mrp_unique_ifindex(br, instance->s_ifindex))
>>> +             return -EINVAL;
>>> +
>>>       mrp = kzalloc(sizeof(*mrp), GFP_KERNEL);
>>>       if (!mrp)
>>>               return -ENOMEM;
>>>
>>
> 

