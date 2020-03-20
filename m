Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2118D2BA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCTPV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:21:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34637 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCTPV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:21:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id a23so2624726plm.1
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O35+CZnWm6pGmLPIAH8Mhp4SiXTYTHjYfEn+6dCmt6g=;
        b=Ybv5clG1f6r2tqbaIu9oyGvRXW9OIWxgWHx78gYnop1PsToZBJXHjwWV7DVWmX77ZB
         V+jRNmYkzzlCiw1mX+7nKQJFeAmp+BL68xm3lE+zPIEm+vAkdUa+HxTlHQCY5g+M2Wy0
         yZBUpcTRg6+HxwZnKqN+9TfrgSctdba+/JsI4rF5iQCfJ2LxRJ8scWRh20ZtJbH5LBV2
         DGb5CPB18ysp3YkUGsv/OzSt85u6cpufT4IVYP9LN4LTJqQevKOr2xYcNn328NBkfoxW
         j0JeF32nd+NXdhZCtXznOW/8fV5PRWOUHwglOVdKTkhlDjwC0yXux1etYv9eUocMxhyR
         f9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O35+CZnWm6pGmLPIAH8Mhp4SiXTYTHjYfEn+6dCmt6g=;
        b=ISwUxcodxBPP5/vX9i+NmrB3ytXttqZtQCy5F9P/k0g3g0Dx6m2PeM73dxpunR8GJg
         z5hqLMQ9szO769AC2gPmgRjwhtKvi310YAH79DKDbmCF/WqazG0whMyjCbx8TDy8Gcny
         vO+ctqNjr5ErQR5HWE3OonJzPTFxnbBN9A6qzJyU5IBbgFWXIDk+HRNADKeaIuzgU4Mp
         kjP55iSalpoq6Lm4OEHzskGj1d3Fgic7GBoVCwdyWndF5spUJjWleeSQiBARYMNZKK/z
         TCSn1B9w2TU/wL/Jwo9P9wQjDRfdtSHJ9+2dRiy/2wr8eY0pP+/Rx6vyzbWWo8rSWf7S
         uXyw==
X-Gm-Message-State: ANhLgQ1KgBJ/ZIIMt3DMuR6sRSXzjEpNL64I5OLbVWqy7Y8h0S7OfrD4
        UKBe3I/cWGI2vRd1ZM3tL7Q=
X-Google-Smtp-Source: ADFU+vsY55CGTDY1ewvzTcIav0rgvTqpK5QTnqHd7f3ak7/OxNCZJ3y4Th3+QJ81uS13Am29l9vNAA==
X-Received: by 2002:a17:90a:1d0:: with SMTP id 16mr10055948pjd.113.1584717715104;
        Fri, 20 Mar 2020 08:21:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e9f2:4948:e013:782b? ([2601:282:803:7700:e9f2:4948:e013:782b])
        by smtp.googlemail.com with ESMTPSA id z20sm5608954pge.62.2020.03.20.08.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 08:21:53 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for
 non-root users
To:     Vincent Bernat <vincent@bernat.ch>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        kafai@fb.com
References: <20200315155910.3262015-1-vincent@bernat.ch>
 <20200315.170231.388798443331914470.davem@davemloft.net>
 <a2d2b020-c2a7-5efa-497e-44eff651b9ce@gmail.com>
 <20200316.021314.2124785837023809696.davem@davemloft.net>
 <m3eets9zaz.fsf@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6738349a-d8f8-685c-d345-7724932fd24d@gmail.com>
Date:   Fri, 20 Mar 2020 09:21:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <m3eets9zaz.fsf@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ sorry for the delay; out of commission for a few days ]

On 3/16/20 7:58 AM, Vincent Bernat wrote:
>  ❦ 16 mars 2020 02:13 -07, David Miller:
> 
>>> As a reminder, there are currently 3 APIs to specify a preferred device
>>> association which influences route lookups:
>>>
>>> 1. SO_BINDTODEVICE - sets sk_bound_dev_if and is the strongest binding
>>> (ie., can not be overridden),
>>>
>>> 2. IP_UNICAST_IF / IPV6_UNICAST_IF - sets uc_index / ucast_oif and is
>>> sticky for a socket, and
>>>
>>> 3. IP_PKTINFO / IPV6_PKTINFO - which is per message.
>>>
>>> The first, SO_BINDTODEVICE, requires root privileges. The last 2 do not
>>> require root privileges but only apply to raw and UDP sockets making TCP
>>> the outlier.
>>>
>>> Further, a downside to the last 2 is that they work for sendmsg only;
>>> there is no way to definitively match a response to the sending socket.
>>> The key point is that UDP and raw have multiple non-root APIs to dictate
>>> a preferred device for sending messages.
>>>
>>> Vincent's patch simplifies things quite a bit - allowing consistency
>>> across the protocols and directions - but without overriding any
>>> administrator settings (e.g., inherited bindings via ebpf programs).
>>
>> Understood, but I still wonder if this mis-match of privilege
>> requirements was by design or unintentional.

IP_UNICAST_IF and IPV6_UNICAST_IF were added for wine (76e21053b5bf3 and
c4062dfc425e9) specifically for use by non-root processes. It is not
clear in the commit message why only sendmsg was needed and why only
udp/raw. I have not touched wine in 15+ years, so no easy way for me to
look into how the response side worked. My guess is just relying on the
socket matching when sk_bound_dev_if is not set.

>>
>> Allowing arbitrary users to specify SO_BINDTODEVICE has broad and far
>> reaching consequences, so at a minimum if we are going to remove the
>> restriction we should at least discuss the implications.

certainly. I brought up this need for non-privileged binding at netconf
a few years ago.[0] My thought at that time was to make IP_UNICAST_IF /
IPV6_UNICAST_IF work for TCP. What I like about Vincent's proposed
change is that it checks for an existing setting and does not override.

As I mentioned before, UDP and RAW both have APIs to get around the root
requirement for sends and responses can match sockets for non-VRF
scenarios. So, the biggest change for this patch is to TCP (and VRF use
cases).

wrt to TCP, allowing the setting for daemons narrows the scope of
bind(), so that should be ok. The daemon could, with additional work,
just ignore connection requests it does not believe come through the
preferred device, though routing changes could move an established
connection to a different interface. Overall, this should not be an
impact to servers.

TCP clients are the biggest question mark wrt to evading an admin's
routing setup. I can't say I can make a persuasive argument here beyond
consistency - a concern for TCP connections but not UDP.

> 
> Without VRF, it's hard to build a case where a process could "evade" its
> setup using SO_BINDTODEVICE. It could be used to use alternative routing
> table when ip rules are using interfaces (which is not uncommon), but I
> think almost all such setups are using this to have some isolation in
> routing (not for local processes), something that could be replaced by
> VRF.
> 
> With VRF, removing the restriction allows a process to have more
> possibilities than previously if it has not been restricted. This is my
> use case: it is actually difficult to use VRF for anything else than
> routing because local processes may want to receive connections in a VRF
> and forward them to another one.
> 
> In summary, unless I am missing something, the main implication is when
> using VRF. Without VRF, no real change.
> 
> An alternative would be to use a sysctl to decide the behaviour.

That is consistent with other l3mdev/vrf features.

[0] https://lwn.net/Articles/719393/
