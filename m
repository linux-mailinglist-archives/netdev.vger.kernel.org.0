Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097D317DAF9
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgCIIdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:33:51 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]:44320 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgCIIdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:33:50 -0400
Received: by mail-qv1-f47.google.com with SMTP id bp19so1617542qvb.11
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 01:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=WuUpwxLXglxI9oi6bGY8wspQLjmAQ1uTrHpEo7RIO1A=;
        b=g6+UE9C0FAKWgkW/Xh9rqt3kGeOcYuc0TRlPjsFbmOEL4Q3n45PW75S6SVdlJaNnop
         VNXEDRGJuhyHgnzixwv5LNsliPu0J5fQtgYyve9nSICsj+zDXSZwa7UoG980nmwmAYKJ
         rwyaxcgZBjV5WbRS9XrOxHdrteSubPQmuMFfppzbnTRVX6sS+vzaQ9Cm9Zs5gkzxNvgs
         fwy83GXXluhbvY0Nn+0pDgSEHap2KrnNYTm6dU1+8lR9WGDr+P5pdY3WWfycXaVqBS7+
         udh+Kt5RF3Y3v7+76cIE7K+TgjZ9slhuSCAsKZvTBWysCbcUOEbywWYczezkidzfiMh5
         ZhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WuUpwxLXglxI9oi6bGY8wspQLjmAQ1uTrHpEo7RIO1A=;
        b=uTi4qWZ97fvrXH/5K+2PyiBpI3bK1LoE8KDuZYsrl0ff6Wh+oh+Uj9DKaM/4dnCtSK
         T8nT+I0McQOuGlskSX3pGScXFs+pdEl8isdrHuxpExTbpODo70S52ER+2EZnoGIVv9yX
         3bzq9FTyfZ3YGQse9oSW17oeVOY+a9YHxLPHIRy8FPsKFq1KuaGHdY1a5Pq0auiNAf+H
         1F3WzVHNKkd+BYQUlJ6iUPrJLH6yukvUvrlZdXB765LgBbt7d1DGIO60h8hVqT9ECQT4
         mexq/LRLxRRCnqPveW477Xg1h4I7F1Txgr+DaTRzjdMeXn+pqJsKL4cYRiKVRmBnG+nV
         +Oqw==
X-Gm-Message-State: ANhLgQ1s1p7kqm7niu+tV3BZBBiKj7Ds1DpQxbvsFdJny7nM6WU8k/yZ
        f4Mz9vWQLKY0yjzgXdUz0/4=
X-Google-Smtp-Source: ADFU+vvk0N9r7tplDvL5kkUE4qbg/S48eSSiWk5NjLCtfB7Z0yUGvZfllzQuos4lnnHVLwYSjyli1A==
X-Received: by 2002:a0c:fc46:: with SMTP id w6mr13731226qvp.46.1583742829753;
        Mon, 09 Mar 2020 01:33:49 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j11sm20866308qtc.91.2020.03.09.01.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 01:33:49 -0700 (PDT)
Date:   Mon, 9 Mar 2020 16:33:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200309083341.GB2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
 <63892fca-4da6-0beb-73d3-b163977ed2fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63892fca-4da6-0beb-73d3-b163977ed2fb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafał,
On Fri, Mar 06, 2020 at 12:14:08PM +0100, Rafał Miłecki wrote:
> ********************
>  WITHOUT YOUR PATCH
> ********************
> 
> The problem we're dealing with seems to be specific to non-Ethernen
> devices. For ARPHRD_IEEE80211_RADIOTAP:
> 1. Multicast addresses get added normally - as for any Ethernet device
> 2. addrconf_dev_config() returns without calling addrconf_add_dev()
> 
> That means wireless monitor interface gets mcast addresses added but
> not removed (like it happens for Ethernet devices).
> #
> # mon-phy0 (ARPHRD_IEEE80211_RADIOTAP) ***
> #
> 
> addrconf_notify(NETDEV_REGISTER)
> 	ipv6_add_dev
> 		ipv6_dev_mc_inc(ff01::1)
> 		ipv6_dev_mc_inc(ff02::1)
> 		ipv6_dev_mc_inc(ff02::2)
> 
> addrconf_notify(NETDEV_UP)
> 	addrconf_dev_config
> 		/* Alas, we support only Ethernet autoconfiguration. */
> 		return;
> 
> addrconf_notify(NETDEV_DOWN)
> 	addrconf_ifdown
> 		ipv6_mc_down
> 			igmp6_group_dropped(ff02::2)
> 				igmp6_leave_group(ff02::2)
> 					mld_add_delrec(ff02::2)
> 			igmp6_group_dropped(ff02::1)
> 			igmp6_group_dropped(ff01::1)
> 

I'm very appreciate for your analyze. This makes me know why this issue
happens and why I couldn't reproduce it.

Yes, with ARPHRD_IEEE80211_RADIOTAP, we called mld_add_delrec() every time
when ipv6_mc_down(), but we never called mld_del_delrec() as ipv6_mc_up() was
not called. This makes the idev->mc_tomb bigger and bigger.

> *****************
>  WITH YOUR PATCH
> *****************
> 
> Things work OK - with your changes all calls like:
> ipv6_dev_mc_inc(ff01::1)
> ipv6_dev_mc_inc(ff02::1)
> ipv6_dev_mc_inc(ff02::2)
> are now part of ipv6_mc_up() which gets never called for the
> ARPHRD_IEEE80211_RADIOTAP.
> 
> I got one more question though:
> 
> Should we really call ipv6_mc_down() for ARPHRD_IEEE80211_RADIOTAP?
> 
> We don't call ipv6_mc_up() so maybe ipv6_mc_down() should be avoided
> too? It seems like asking for more problems in the future. Even now


Yes, for me there are actually two questions.

1. Should we avoid call ipv6_mc_down() as we don't call ipv6_mc_up() for
non-Ethernen dev. I think the answer is yes, we could. But on the
other hand, it seems IPv4 doesn't check the dev type and calls ip_mc_up()
directly in inetdev_event() NETDEV_UP.

2. Should we move ipv6_dev_mc_inc() from ipv6_add_dev() to ipv6_mc_up()?
I don't know yet, this dependents on whether we could add multicast address
on non-Ethernen dev.

> we call ipv6_mc_leave_localaddr() without ipv6_mc_join_localaddr()
> called first which seems unintuitive.

This doesn't matter much yet. As we will check if we have the address
in __ipv6_dev_mc_dec(), if not, we just return. But yes, form logic, this
looks asymmetric.

Thanks
Hangbin
