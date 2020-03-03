Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948E117724A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgCCJXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:23:16 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37713 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgCCJXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:23:16 -0500
Received: by mail-lj1-f194.google.com with SMTP id q23so2714611ljm.4
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QmEUkFraTVpFfmAup3PVWxV0kkzh/9tnrOmqwD9MB8Y=;
        b=REuKJnQ1u/x2n0vzM0dCZuhgg1ez6wbv0v9hOsskuG54nJ5rpnjfE3QjqapIWNy7kb
         5XNBGDDHGL9UCRPNnZbO9WbAJQUjf8KMvJCytsIKbUJlAjMt63YhWHBWUQdepYT3UFIy
         fAyg59Zk/bDE00TnaPiDdn+dPDp5YGw2kgH158NuI1JCavZPvBZ2h1ED3fXgu0fnQ8q5
         N7D/E+aqfTBpDZUKuk7h3+j6084ttvLy6Xj9gbJCsV1Jc2x6eVNpBQwU9akvgYKX8CZe
         2+gDWXwqotd7dpv359WX7W+EegDxNdvu7CzKghcMuchYM1sdW4ck8WpcSv7etvSl2e73
         t3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QmEUkFraTVpFfmAup3PVWxV0kkzh/9tnrOmqwD9MB8Y=;
        b=Nu0aWx4uNjp8HOLvJ9gLqsPWGjSQPPC9W4wOHNWzoikjLvLrkvuxzZs9odhyjPqxHu
         G1IECrRwtGy1hhrthQiYD09TTInRKqQqDmfeeOsEa9PQpRqS1DC7MRMSEE5/y6eSybsA
         8BKTd5C9cnS0w/7cZeWK0N7nLOYsBDQwQcQNh4qbKMXGxxfUJe8eQJhEmmEHIBtM0weB
         LMBVLowLhNGTzoub0rMsm1NlIVpSpbim06JDrk23HRWYJ13LMJ/WRrnnyrhsVSVVIxrh
         7KOuD7+DU2xW5XzVOiBi9lvx/xtQ2x/IVkrRaDv3h+9zHHkZRkQLTYGiL4qqmb3tJuxe
         11SQ==
X-Gm-Message-State: ANhLgQ0l+sLa5/I0anxxl5QiJliflEeXJ5X1YixLKAa1lqu9om8svyDC
        dfTs4Ybd124K47mFIYWU7rc=
X-Google-Smtp-Source: ADFU+vueD2NyAclvh/8DHSnBezcnz4iBUldXnlvy8pq5r5E68rxcNopry/ab4L3wWlKVorpPSCRyFQ==
X-Received: by 2002:a05:651c:50a:: with SMTP id o10mr1914635ljp.189.1583227394408;
        Tue, 03 Mar 2020 01:23:14 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id a3sm11718183lfo.70.2020.03.03.01.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 01:23:13 -0800 (PST)
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
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
Date:   Tue, 3 Mar 2020 10:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.2020 10:11, Hangbin Liu wrote:
> On Tue, Mar 03, 2020 at 05:00:35PM +0800, Hangbin Liu wrote:
>> On Tue, Mar 03, 2020 at 07:16:44AM +0100, Rafał Miłecki wrote:
>>> It appears that every interface up & down sequence results in adding a
>>> new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
>>> obviously result in running out of memory at some point. That list isn't
>>> cleared until removing an interface.
>>
>> Thanks Rafał, this info is very useful. When we set interface up, we will
>> call ipv6_add_dev() and add in6addr_linklocal_allrouters to the mcast list.
>> But we only remove it in ipv6_mc_destroy_dev(). This make the link down save
>> the list and link up add a new one.
>>
>> Maybe we should remove the list in ipv6_mc_down(). like:
> 
> Or maybe we just remove the list in addrconf_ifdown(), as opposite of
> ipv6_add_dev(), which looks more clear.
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 164c71c54b5c..4369087b8b74 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3841,6 +3841,12 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>                  ipv6_ac_destroy_dev(idev);
>                  ipv6_mc_destroy_dev(idev);
>          } else {
> +               ipv6_dev_mc_dec(dev, &in6addr_interfacelocal_allnodes);
> +               ipv6_dev_mc_dec(dev, &in6addr_linklocal_allnodes);
> +
> +               if (idev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
> +                       ipv6_dev_mc_dec(dev, &in6addr_linklocal_allrouters);
> +
>                  ipv6_mc_down(idev);
>          }

FWIW I can confirm it fixes the problem for me!

Only one ff02::2 entry is present when removing interface:

[  105.686503] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
[  105.692056] [ipv6_mc_down] idev->dev->name:mon-phy0
[  105.696957] [ipv6_mc_destroy_dev -> __mld_clear_delrec] kfree(pmc:c64fd880) ff02::2
