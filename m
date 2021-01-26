Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE713048C7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388194AbhAZFjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732115AbhAZDfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 22:35:39 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB531C06174A;
        Mon, 25 Jan 2021 19:34:58 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id x71so17133741oia.9;
        Mon, 25 Jan 2021 19:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=loohkZAKsZDbkdCoMUXlVDMNQHJ6H2P6HeBaC1bU6Ik=;
        b=FvjOcmkQnig6wqaFE0vVvA4SfhS35ilbcU9GvrL1i8uwn9pMAsv57VDLh2gAsiTe0B
         7IB+xV7vcbb/77nkBmYVDYqC35uxGzcXumd+hvCkYbRuKtPfEnxDrN0yai1u/SLuhEee
         Vscrfz7JG/HSsPu5a8FbrKzae7nlzgE+Ss23NXIaknsWUQEHZsfhscKfKQx0Vm9FIsMd
         rOxT1LLjNQH42D7TBo1F+MQfDh9ieOHBxpl3JVhXPiNJRa2UTGs4LB6Q8DYOd8MRbqPP
         WjpelirF64C8rx7S8Lig7RRG8WO8/cMjgK7TKdd70SxrUFjLZKsWrpeOHFBzH2baO4TX
         jwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=loohkZAKsZDbkdCoMUXlVDMNQHJ6H2P6HeBaC1bU6Ik=;
        b=BykWLPpejThdIX3xG0uv4qhSR9AGVGrPKDU415CY5ZGwSr1lbbLY0GOk8OCXBYcx3S
         rSeBd6WnrPc/vB6XY9GJtvfL+P9xvTsjsLzrIWaHSZSyWg1XLuL6xI9yhMSX6qN9gQYp
         2PEfq45SnTeyqFkxzrpBKXKnPEDnxPN0qxcxrx1DmEmsIG3b4ZSZ5WVm+1aiCwbzzmq5
         6X7wqtUO6S90We/0BuWRxxP8bUufwLmYLG7PDDu+Jp8vpYYaIscU/XF2YXjPYfQWoBk/
         IWRzAPn1HY6zd+a0BXbQNaW1jZdYLgAsOlA3pmIvgQ+akvrUvp80XdAOssAU/Ox8Va4K
         3v4Q==
X-Gm-Message-State: AOAM531Ifa6zkm2Rv6q6fLDaWgR8dcO3NvZecpi0QofCf68gdwPQt+H/
        BVJ01lecSzDOlpiq61qBMCE=
X-Google-Smtp-Source: ABdhPJxkre9Bvv2KxaUHEbRKlOwTJUMYFF6OgPmIFYpdWP36nVjKV/0ZUHQ/Z7V6OH5GHYBLVH6k8Q==
X-Received: by 2002:aca:f382:: with SMTP id r124mr1978802oih.175.1611632098343;
        Mon, 25 Jan 2021 19:34:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id v2sm2129201ooq.25.2021.01.25.19.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 19:34:57 -0800 (PST)
Subject: Re: [PATCH v4 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     Praveen Chaudhary <praveen5582@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>, David Ahern <dsahern@kernel.org>
References: <20210125214430.24079-1-pchaudhary@linkedin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <21884a37-ee26-3c8c-690e-9ea29d77d8b9@gmail.com>
Date:   Mon, 25 Jan 2021 20:34:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125214430.24079-1-pchaudhary@linkedin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 2:44 PM, Praveen Chaudhary wrote:
> For IPv4, default route is learned via DHCPv4 and user is allowed to change
> metric using config etc/network/interfaces. But for IPv6, default route can
> be learned via RA, for which, currently a fixed metric value 1024 is used.
> 
> Ideally, user should be able to configure metric on default route for IPv6
> similar to IPv4. This fix adds sysctl for the same.
> 
> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Changes in v1.
> 1.) Correct the call to rt6_add_dflt_router.
> 
> Changes in v2.
> 1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
> 2.) Change Type to __u32 instead of __s32.
> 3.) Change description in Documentation/networking/ip-sysctl.rst.
> 4.) Use proc_douintvec instead of proc_dointvec.
> 5.) Code style in ndisc_router_discovery().
> 6.) Change Type to u32 instead of unsigned int.
> 
> Changes in v3:
> 1.) Removed '---' and '```' from description.
> 2.) Remove stray ' after accept_ra_defrtr.
> 3.) Fix tab in net/ipv6/addrconf.c.
> 
> Changes in v4:
> 1.) Remove special case of 0 and use IP6_RT_PRIO_USER as default.
> 2.) Do not allow 0.
> 3.) Change Documentation accordingly.
> 4.) Remove extra brackets and compare with zero in ndisc_router_discovery().
> 5.) Remove compare with zero in rt6_add_dflt_router().
> 
> Logs:
> 
> For IPv4:
> 
> Config in etc/network/interfaces:
> auto eth0
> iface eth0 inet dhcp
>     metric 4261413864
> 
> IPv4 Kernel Route Table:
> $ ip route list
> default via 172.21.47.1 dev eth0 metric 4261413864
> 
> FRR Table, if a static route is configured:
> [In real scenario, it is useful to prefer BGP learned default route over DHCPv4 default route.]
> Codes: K - kernel route, C - connected, S - static, R - RIP,
>        O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
>        T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
>        > - selected route, * - FIB route
> 
> S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03
> K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
> 
> i.e. User can prefer Default Router learned via Routing Protocol in IPv4.
> Similar behavior is not possible for IPv6, without this fix.
> 
> After fix [for IPv6]:
> sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.ra_defrtr_metric=1996489705
> 
> IP monitor: [When IPv6 RA is received]
> default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  pref high
> 
> Kernel IPv6 routing table
> $ ip -6 route list
> default via fe80::be16:65ff:feb3:ce8e dev eth0 proto ra metric 1996489705 expires 21sec hoplimit 64 pref high
> 
> FRR Table, if a static route is configured:
> [In real scenario, it is useful to prefer BGP learned default route over IPv6 RA default route.]
> Codes: K - kernel route, C - connected, S - static, R - RIPng,
>        O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
>        v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
>        > - selected route, * - FIB route
> 
> S>* ::/0 [20/0] is directly connected, eth0, 00:00:06
> K   ::/0 [119/1001] via fe80::xx16:xxxx:feb3:ce8e, eth0, 6d07h43m
> 
> If the metric is changed later, the effect will be seen only when next IPv6
> RA is received, because the default route must be fully controlled by RA msg.
> Below metric is changed from 1996489705 to 1996489704.
> 
> $ sudo sysctl -w net.ipv6.conf.eth0.ra_defrtr_metric=1996489704
> net.ipv6.conf.eth0.ra_defrtr_metric = 1996489704
> 
> IP monitor:
> [On next IPv6 RA msg, Kernel deletes prev route and installs new route with updated metric]
> 
> Deleted default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  expires 3sec hoplimit 64 pref high
> default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489704  pref high
> ---
>  Documentation/networking/ip-sysctl.rst | 10 ++++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/net/ip6_route.h                |  3 ++-
>  include/uapi/linux/ipv6.h              |  1 +
>  include/uapi/linux/sysctl.h            |  1 +
>  net/ipv6/addrconf.c                    | 11 +++++++++++
>  net/ipv6/ndisc.c                       | 12 ++++++++----
>  net/ipv6/route.c                       |  5 +++--
>  8 files changed, 37 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


