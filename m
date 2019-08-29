Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EDAA1A88
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfH2Myn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:54:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42596 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2Mym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:54:42 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so4673362iod.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xFIrm2rvlBJcSGr2RmlLC2NlYzal0F/FWUHeBci1sts=;
        b=MXqCMqs5XQik8RKEhI6ThfjdeudR/mCFyS4O8FytM57ZEu/Bk7Rztkd5ss9oqaM3F6
         N2sLolrxrnNs9betzCPRXYjzeVzjRng8OxhbqOWWMZRiGrz463HsfWNXLj2PlDeGUXgX
         0NWAKns5aUAmJLwel0Cwmil8g3Cyan+UkuP2jT1z1KjYrrnXhiDbBv2WhCiJ9RtAQjjO
         Ce2rw4X5VvgTiunIWOmNWWp4VPKHy9GEHxs5fDF4Z46ZRGt/pM74D4dK1F1nepYuCbaP
         mDs6QN8Y+v11p//SdSSWOzOAAEInUCPd4Lk6j7OXginC0uzPKYdxztCVpFUKMNxSJnB+
         nIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xFIrm2rvlBJcSGr2RmlLC2NlYzal0F/FWUHeBci1sts=;
        b=nR/0xJObjIgrOO9bCvSdsnXYWduhgC+FUQoQLDnGpgsC89yboDOaop6idWfCcRSU1k
         kvyxsm1VnJwd/84IY6wC/rTAzXM+wb24Ed5eXFKReuV24tY+e4/WSPlbdcNojWUrRzfv
         w5viBL4YNde3H+tjR9ozwk9HUWqzRT/FheuBMw+wTRLqE9VcgyFtAUkUy5AyqO3dyCmn
         YUg4rqTJmO0/JzMHv3zKP7urW340sUJOJja/mlfW99WmbwtZN0Qb0ES5UufILAcnKN+B
         2AieA2HLxY5xXg/g5IYQJxIyiJ/JOxYQU2cS4GhVtREBbQh3rHRj803+z1tzlppIuaFA
         nSCA==
X-Gm-Message-State: APjAAAUVyIJA+vkXi3aPFIeYoOI9oOr4oITzyeKxcAuybG5Ca72pP0F/
        +cGYMFr6iYYKb+wnD/3sjfsyjSt7mMo=
X-Google-Smtp-Source: APXvYqx1adrllmLxi7tfHaSl6893Uj+ZpKj3656Qsr1THc2pSw1dcccdrDCubBzuZyfBk6APbJETmQ==
X-Received: by 2002:a05:6638:25a:: with SMTP id w26mr10294224jaq.133.1567083281354;
        Thu, 29 Aug 2019 05:54:41 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d0da:f404:d884:d34b? ([2601:282:800:fd80:d0da:f404:d884:d34b])
        by smtp.googlemail.com with ESMTPSA id q74sm4110406iod.72.2019.08.29.05.54.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 05:54:40 -0700 (PDT)
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190828103718.GF2312@nanopsycho>
 <2c561928-1052-4c33-848d-ed7b81e920cf@gmail.com>
 <20190829062850.GG2312@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <87432763-769b-be25-6e5c-a15f8ebfd654@gmail.com>
Date:   Thu, 29 Aug 2019 06:54:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190829062850.GG2312@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 12:28 AM, Jiri Pirko wrote:
> Wed, Aug 28, 2019 at 11:26:03PM CEST, dsahern@gmail.com wrote:
>> On 8/28/19 4:37 AM, Jiri Pirko wrote:
>>> Tue, Aug 06, 2019 at 09:15:17PM CEST, dsahern@kernel.org wrote:
>>>> From: David Ahern <dsahern@gmail.com>
>>>>
>>>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>>>> tracked fib entries and rules per network namespace. Restore that behavior.
>>>
>>> David, please help me understand. If the counters are per-device, not
>>> per-netns, they are both the same. If we have device (devlink instance)
>>> is in a netns and take only things happening in this netns into account,
>>> it should count exactly the same amount of fib entries, doesn't it?
>>
>> if you are only changing where the counters are stored - net_generic vs
>> devlink private - then yes, they should be equivalent.
> 
> Okay.
> 
>>
>>>
>>> I re-thinked the devlink netns patchset and currently I'm going in
>>> slightly different direction. I'm having netns as an attribute of
>>> devlink reload. So all the port netdevices and everything gets
>>> re-instantiated into new netns. Works fine with mlxsw. There we also
>>> re-register the fib notifier.
>>>
>>> I think that this can work for your usecase in netdevsim too:
>>> 1) devlink instance is registering a fib notifier to track all fib
>>>    entries in a namespace it belongs to. The counters are per-device -
>>>    counting fib entries in a namespace the device is in.
>>> 2) another devlink instance can do the same tracking in the same
>>>    namespace. No problem, it's a separate counter, but the numbers are
>>>    the same. One can set different limits to different devlink
>>>    instances, but you can have only one. That is the bahaviour you have
>>>    now.
>>> 3) on devlink reload, netdevsim re-instantiates ports and re-registers
>>>    fib notifier
>>> 4) on devlink reload with netns change, all should be fine as the
>>>    re-registered fib nofitier replays the entries. The ports are
>>>    re-instatiated in new netns.
>>>
>>> This way, we would get consistent behaviour between netdevsim and real
>>> devices (mlxsw), correct devlink-netns implementation (you also
>>> suggested to move ports to the namespace). Everyone should be happy.
>>>
>>> What do you think?
>>>
>>
>> Right now, registering the fib notifier walks all namespaces. That is
>> not a scalable solution. Are you changing that to replay only a given
>> netns? Are you changing the notifiers to be per-namespace?
> 
> Eventually, that seems like good idea. Currently I want to do
> if (net==nsim_dev->mynet)
> 	done
> check at the beginning of the notifier.
> 

The per-namespace replay should be done as part of this re-work. It
should not be that big of a change. Add 'struct net' arg to
register_fib_notifier. If set, call fib_net_dump only for that
namespace. The seq check should be made per-namespace.

You mentioned mlxsw works fine with moving ports to a new network
namespace, so that will be a 'real' example with a known scalability
problem that should be addressed now.
