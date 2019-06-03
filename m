Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87B033B6E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfFCWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:35:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34575 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCWfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:35:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id h2so5852536pgg.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aQ5PuLYyE1eBEgcnLuyBcd0ENGksG/WYSgdfpY2sMvg=;
        b=Kugq1F2mfs8wgX1i7c4hUgTEy5iya8UoSlQ9cY3QfoD8s150IvTRbH5AzxGq2NhFMA
         7hQhXvvNJYpJMLzFjrdaWBw92Uf/NMIzAEPtsJ4d0AXL/d+RsPQt98tXRijEhzuyBC5P
         U6MpzgmeKcea/OPWEfwmrulEKbutohVdcULMcOSVzMREtKOx0Orb2hDrRA9sih1NW1pK
         XEE25lM6UQkTg2YYxbKs2EZ1N5/rJDAx5QJLYw3j22Z3kDjZWr6sFhtcVkosoeM11bDF
         y86W+bIEeX4hBAUb6BimYbJ1kyxgEVtEsfxNYAaIy31K8vCJqS7fT/YVzCEENRS7DUb/
         xXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQ5PuLYyE1eBEgcnLuyBcd0ENGksG/WYSgdfpY2sMvg=;
        b=PQ7cgL0rYvOIK2o8KHH9VVGf7gG6vlnxlQJ5wdnzx7aFKx2Vk/OaYFyEjwzxn7wnkk
         goramOq/X3gfb3YswGP62dthehBfQsprYcyzcfvC0V8gCYLR1P66X3GiNIa2GGWGgCw8
         hCYNwI5O2CUn5Tckx8okkiQWMNl3BFErcVyJP2q/3KhYwiV/A5NjnwrI+MTDXw3CavmJ
         9HTLlcWNdob3Z9Srw3NvqSdgcpyNdD+HwVIOOeSmLBGlAbfIDd88mIz2mjtXVpeoHezw
         IPWPV/zH+PrhyUGeQOr1HbXw495WqY4ya+8s9o8qeKBuyoXwsStpTQvyahVcVyBpSSKd
         zpFw==
X-Gm-Message-State: APjAAAUKbmr8NvfIuwnyg8dEnCVup3rI0yU0FEdVa2inCwgxSNcTB7zK
        zguAUYbETe7TOZq1wxNe2Z93CjJYuOo=
X-Google-Smtp-Source: APXvYqybBJpDzMVbGrrhZoqzNuEylcrRz7KPwyda4Oa5K8gsdw2K0YvOJ69DzTZCmNiuVHzwIyW/cw==
X-Received: by 2002:aa7:8d50:: with SMTP id s16mr33474867pfe.96.1559594533926;
        Mon, 03 Jun 2019 13:42:13 -0700 (PDT)
Received: from [172.27.227.197] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y12sm12725128pgi.10.2019.06.03.13.42.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 13:42:12 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
Date:   Mon, 3 Jun 2019 14:42:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 12:09 PM, Wei Wang wrote:
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index fada5a13bcb2..51cb5cb027ae 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -432,15 +432,21 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
>>         struct fib6_info *sibling, *next_sibling;
>>         struct fib6_info *match = res->f6i;
>>
>> -       if (!match->fib6_nsiblings || have_oif_match)
>> +       if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
>>                 goto out;
> 
> So you mentioned fib6_nsiblings and nexthop is mutually exclusive. Is
> it enforced from the configuration?

It is enforced by the patch that wires up RTA_NH_ID for IPv6.

>> @@ -1982,6 +2010,14 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
>>                 rcu_read_unlock();
>>                 dst_hold(&rt->dst);
>>                 return rt;
>> +       } else if (res.fib6_flags & RTF_REJECT) {
>> +               rt = ip6_create_rt_rcu(&res);
>> +               rcu_read_unlock();
>> +               if (!rt) {
>> +                       rt = net->ipv6.ip6_null_entry;
>> +                       dst_hold(&rt->dst);
>> +               }
>> +               return rt;
>>         }
>>
> Why do we need to call ip6_create_rt_rcu() to create a dst cache? Can
> we directly return ip6_null_entry here? This route is anyway meant to
> drop the packet. Same goes for the change in ip6_pol_route_lookup().

This is to mimic what happens if you added a route like this:
   ip -6 ro add blackhole 2001:db8:99::/64

except now the blackhole target is contained in the nexthop spec.


> 
> And for my education, how does this new nexthop logic interact with
> the pcpu_rt cache and the exception table? Those 2 are currently
> stored in struct fib6_nh. They are shared with fib6_siblings under the
> same fib6_info. Are they also shared with nexthop for the same
> fib6_info?

With nexthop objects IPv6 can work very similar to IPv4. Multiple IPv4
fib entries (fib_alias) can reference the same fib_info where the
fib_info contains an array of fib_nh and the cached routes and
exceptions are stored in the fib_nh.

The one IPv6 attribute that breaks the model is source routing which is
a function of the prefix. For that reason you can not use nexthop
objects with fib entries using source routing. See the note in this
patch in fib6_check_nexthop

> I don't see much changes around that area. So I assume they work as is?

Prior patch sets moved the pcpu and exception caches from fib6_info to
fib6_nh.
