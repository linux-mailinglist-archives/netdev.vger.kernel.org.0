Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7317BB51
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 12:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCFLOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 06:14:16 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37709 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFLOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 06:14:15 -0500
Received: by mail-lf1-f65.google.com with SMTP id j11so1597440lfg.4
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 03:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+90fvCT+eT+qxzkBzVZOZ4z0qBmXnJeXzGGmh1e9EY=;
        b=WpEnhXqsjwwVt+zIi66RuLlTp2NDHivX8XzsnNMpcdc+71Mb0xLxyase+CpnxDWRlt
         eYs43QICgBrJni3IAGGjA67z8Kpd5fhF4lnuVU9VOCohldbl7nsE8Uq2mYrUBiDzrfmR
         ub/G2BVyakgH72gB8y+K/SK/hkVleNC4o8aihIR/Gg7RmoJA0Te+yoVlygqiTm/o2AgC
         018rjBsZHDC3YQcuH3KPzwW1YJtdQ4XEZrVN6m57GRv3LaxOy0pKCSMs3ZjsOwNhlEaL
         5+7+L7ZlFlj8CU6nXHGC/BAIOpSJE7aXGpW2080DZSxT4IvFqXRwrkdVIEzSlR/Azs9M
         xvgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+90fvCT+eT+qxzkBzVZOZ4z0qBmXnJeXzGGmh1e9EY=;
        b=UyNWaq0T42kTrUVcWulDkkSni/MTQHAukfuGPflLx9fRGa1JhuBikrrbdkcBr3Qfpl
         i7LNPCYASjffAmqQ9PMIuNowSJ5pltlrFCTAlagubikBJbnMVH0aMQ7yOhRlBYZ+cuY4
         iY8cdk5HkGPKYzmzcxmQdmvlSdgaOgbVHw3h+qv3J8lb7RBs74/lO7mBlFzeyz4Lqv0Y
         5WLZj/0vIaZeJbHCrvzf8p/En4p4yU2OjgZKulFo854JNOuipv+yoTouFMsUl6MUShhd
         A9hbfEpD2w79PAkuMLFMNhuNaoMx2MUliSBKa2Yl1IejwIBIKzZg8QMhU3Od2ttcVG5W
         JgPQ==
X-Gm-Message-State: ANhLgQ32bImpPUISTUWoLW7/0ARNsj8I4aCCtBQEkuD8+TASjYUzgzlM
        ZYxYmQos31UaFctqoL6XJus=
X-Google-Smtp-Source: ADFU+vsEtk57POOuJinItvQxx3JE/U7bX/maWOpfLloLH3Xl4WKFxpg5qUqfR+eQo8f4SvqT2tiDyw==
X-Received: by 2002:ac2:555a:: with SMTP id l26mr1635098lfk.48.1583493251216;
        Fri, 06 Mar 2020 03:14:11 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id d26sm16857001lfn.22.2020.03.06.03.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 03:14:10 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <63892fca-4da6-0beb-73d3-b163977ed2fb@gmail.com>
Date:   Fri, 6 Mar 2020 12:14:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

I took a moment to note down what exactly happens in the IPv6 code so
we can be sure things work as expected. I compared kernel behavior
without your patch and with it for two different network interfaces.


On 04.03.2020 10:07, Hangbin Liu wrote:
>  From 9cf504dc30198133e470ea783c3fa53a8f56a20a Mon Sep 17 00:00:00 2001
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Tue, 3 Mar 2020 20:58:39 +0800
> Subject: [PATCH] ipv6/mcast: join and leave allnodes, allrouters addresses
>   when link up/down
> 
> This patch fixes two issues:
> 
> 1) When link up with IPv6 forwarding enabled, we forgot to join
> sitelocal_allrouters(ff01::2) and interfacelocal_allrouters(ff05::2),
> like what we do in function dev_forward_change()
> 
> 2) When link down, there is no listener for the allnodes, allrouters
> addresses. So we should remove them instead of storing the info in
> idev->mc_tomb.
> 
> To fix these two issue, I add two new functions ipv6_mc_join_localaddr()
> and ipv6_mc_leave_localaddr() to handle these addresses. And just join
> leave the group in ipv6_mc_{up, down}.

********************
  WITHOUT YOUR PATCH
********************

The problem we're dealing with seems to be specific to non-Ethernen
devices. For ARPHRD_IEEE80211_RADIOTAP:
1. Multicast addresses get added normally - as for any Ethernet device
2. addrconf_dev_config() returns without calling addrconf_add_dev()

That means wireless monitor interface gets mcast addresses added but
not removed (like it happens for Ethernet devices).

For ARPHRD_ETHER things seem to work correctly.

#
# wlan0 (ARPHRD_ETHER)
#

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev
		ipv6_dev_mc_inc(ff01::1)
		ipv6_dev_mc_inc(ff02::1)
		ipv6_dev_mc_inc(ff02::2)

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		addrconf_add_dev
			ipv6_find_idev
				ipv6_mc_up
					mld_del_delrec(ff02::2)
					igmp6_group_added(ff02::2)
					mld_del_delrec(ff02::1)
					igmp6_group_added(ff02::1)
					mld_del_delrec(ff01::1)
					igmp6_group_added(ff01::1)

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			igmp6_group_dropped(ff02::2)
				igmp6_leave_group(ff02::2)
					mld_add_delrec(ff02::2)
			igmp6_group_dropped(ff02::1)
			igmp6_group_dropped(ff01::1)

ipv6_mc_destroy_dev
	ipv6_mc_down
		igmp6_group_dropped(ff02::2)
		igmp6_group_dropped(ff02::1)
		igmp6_group_dropped(ff01::1)
	mld_clear_delrec
	__ipv6_dev_mc_dec(ff02::1)
	__ipv6_dev_mc_dec(ff02::2)


#
# mon-phy0 (ARPHRD_IEEE80211_RADIOTAP) ***
#

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev
		ipv6_dev_mc_inc(ff01::1)
		ipv6_dev_mc_inc(ff02::1)
		ipv6_dev_mc_inc(ff02::2)

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		/* Alas, we support only Ethernet autoconfiguration. */
		return;

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			igmp6_group_dropped(ff02::2)
				igmp6_leave_group(ff02::2)
					mld_add_delrec(ff02::2)
			igmp6_group_dropped(ff02::1)
			igmp6_group_dropped(ff01::1)

ipv6_mc_destroy_dev
	ipv6_mc_down
		igmp6_group_dropped(ff02::2)
		igmp6_group_dropped(ff02::1)
		igmp6_group_dropped(ff01::1)
	mld_clear_delrec
	__ipv6_dev_mc_dec(ff02::1)
	__ipv6_dev_mc_dec(ff02::2)

*****************
  WITH YOUR PATCH
*****************

Things work OK - with your changes all calls like:
ipv6_dev_mc_inc(ff01::1)
ipv6_dev_mc_inc(ff02::1)
ipv6_dev_mc_inc(ff02::2)
are now part of ipv6_mc_up() which gets never called for the
ARPHRD_IEEE80211_RADIOTAP.

I got one more question though:

Should we really call ipv6_mc_down() for ARPHRD_IEEE80211_RADIOTAP?

We don't call ipv6_mc_up() so maybe ipv6_mc_down() should be avoided
too? It seems like asking for more problems in the future. Even now
we call ipv6_mc_leave_localaddr() without ipv6_mc_join_localaddr()
called first which seems unintuitive.

#
# wlan0 (ARPHRD_ETHER)
#

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		addrconf_add_dev
			ipv6_find_idev
				ipv6_mc_up
					ipv6_mc_join_localaddr
						ipv6_dev_mc_inc(ff01::1)
						ipv6_dev_mc_inc(ff02::1)
						ipv6_dev_mc_inc(ff01::2)
						ipv6_dev_mc_inc(ff02::2)
						ipv6_dev_mc_inc(ff05::2)
					mld_del_delrec(ff05::2)
					igmp6_group_added(ff05::2)
					mld_del_delrec(ff02::2)
					igmp6_group_added(ff02::2)
					mld_del_delrec(ff01::2)
					igmp6_group_added(ff01::2)
					mld_del_delrec(ff02::1)
					igmp6_group_added(ff02::1)
					mld_del_delrec(ff01::1)
					igmp6_group_added(ff01::1)

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			ipv6_mc_leave_localaddr
				__ipv6_dev_mc_dec(ff01::1)
				__ipv6_dev_mc_dec(ff02::1)
				__ipv6_dev_mc_dec(ff01::2)
				__ipv6_dev_mc_dec(ff02::2)
					igmp6_group_dropped(ff02::2)
				__ipv6_dev_mc_dec(ff05::2)
					igmp6_group_dropped(ff05::2)

ipv6_mc_destroy_dev
	ipv6_mc_down
		ipv6_mc_leave_localaddr
			__ipv6_dev_mc_dec(ff01::1)
			__ipv6_dev_mc_dec(ff02::1)
			__ipv6_dev_mc_dec(ff01::2)
			__ipv6_dev_mc_dec(ff02::2)
			__ipv6_dev_mc_dec(ff05::2)
	mld_clear_delrec

#
# mon-phy0 (ARPHRD_IEEE80211_RADIOTAP)
#

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		/* Alas, we support only Ethernet autoconfiguration. */
		return;

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			ipv6_mc_leave_localaddr
				__ipv6_dev_mc_dec(ff01::1)
				__ipv6_dev_mc_dec(ff02::1)
				__ipv6_dev_mc_dec(ff01::2)
				__ipv6_dev_mc_dec(ff02::2)
				__ipv6_dev_mc_dec(ff05::2)

ipv6_mc_destroy_dev
	ipv6_mc_down
		ipv6_mc_leave_localaddr
			__ipv6_dev_mc_dec(ff01::1)
			__ipv6_dev_mc_dec(ff02::1)
			__ipv6_dev_mc_dec(ff01::2)
			__ipv6_dev_mc_dec(ff02::2)
			__ipv6_dev_mc_dec(ff05::2)
	mld_clear_delrec
