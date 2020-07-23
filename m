Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B222B8C0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgGWVeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgGWVeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:34:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA2FC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:34:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j18so6213930wmi.3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Iz8DEhAte0HBb/dIdVsjz9VdbWc8+ODh+Vf5rsHSTk=;
        b=g/MG1vHYzxsbsxNlT9cfhscKyECd7MtM8VA+qHGnbVBef6cFropC9Zd98KZFJ3+lPQ
         mckPpTYLEv79QtEikUyU+I6/LEfgq3HfPv9FnfPWjkqIdmjtK/W6TS6GKmTGHp2sYYNs
         +KpGAA5h8M53QyFlcGNo0VLwosLOI0cLRH36VYsAgo2hnQxdraRzwq5qGz/8IeW6MXBu
         V5X8VSyVfD4MqJ8RVGau9UZIfdntN5XgNoHNFwEQc4zuw8BUnKW4Gi9D3JmogRIn33nL
         /17O1qlnn3NJDZZYxZqxgGjHMiFuOMcvwj+PWHzNKKK//csKIrjC4T9NS2dV0ect2jQY
         2iqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9Iz8DEhAte0HBb/dIdVsjz9VdbWc8+ODh+Vf5rsHSTk=;
        b=IyFtaRoqdwyhd2JEM4dHO+M+KnKMRsEIDmY41nHO+wSQM8Zem+CHl0cJLhBBYr+FEk
         5UY/SzO83GfW3ykddu4IXDq2LV1XJQtYum/UBfws8QuJYlsdHDQz37JJ935qzlMzAhbU
         OjLTbYg0++ki8e26Iw6IPkEx1ZpGAdKeXJgOxHUaObXo7LZuq+dofF2wAkIaTnIGwZIN
         Hd5fxChXG0g4UR2+nAiHdQMtHZjCl/1lRfOZNdVGFk5tCKoChQ4cO7Fn2cvDPI9IM5Gz
         /Vr4m8pMiTBCv4YTFBMIZ8mZgtdys8/1wkhkaaJ82pD195HaAbXII02NRqflLcmkvITK
         27vQ==
X-Gm-Message-State: AOAM531NMVV88Am8zV+JsJH7/2gX6PsfveWog6IMH4QiqOW1jWA/xjUe
        RHZq1PynhgVv5y+OniEuFMthELk7
X-Google-Smtp-Source: ABdhPJynGSQdL2yJNg41S3VS27gco271obE72inqT2jjbAq7djvk8+rEmXdxTCeoinpbtRRCn/625Q==
X-Received: by 2002:a1c:2547:: with SMTP id l68mr2782139wml.181.1595540040847;
        Thu, 23 Jul 2020 14:34:00 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h11sm5702095wrb.68.2020.07.23.14.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 14:34:00 -0700 (PDT)
Subject: Re: dsa: mv88e6xxx losing DHCPv6 solicit packets / IPv6 multicast
 packets?
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
References: <20200723164610.62e70bde@dellmb.labs.office.nic.cz>
 <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <f52ca482-6ad8-b471-5f59-851e9af65688@gmail.com>
Date:   Thu, 23 Jul 2020 14:33:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 2:27 PM, Chris Packham wrote:
> Hi Marek,
> 
> On 24/07/20 2:46 am, Marek Behún wrote:
>> Hi,
>>
>> a customer of ours filed a ticket saying that when using upstream kernel
>> (5.8.0-rc6 on Debian 10) on Turris MOX (88e6190 switch) with DSA with
>> default configuration, the switch is losing DHCPv6 solicit packets /
>> IPv6 multicast packets sent to ff02::1::2 address.
>>
>>> Specifically, it seems the 88E6190 hardware switches in the Peridot
>>> module is swallowing IPv6 multicast packets (sent to ff02::1:2 ).
>>> We tested this by mirroring the Mox LAN port on the switch and saw the
>>> DHCPv6 solicit packet arriving out of the switch but the Mox kernel
>>> didn't see it (using tcpdump).
>> Is this issue known?
> 
> I can't speak to the Peridot specifically but other Marvell silicon I've 
> dealt with does try to avoid trapping packets to the CPU. Normally you 
> would set specific registers/table entries to declare interest in 
> particular reserved multicast groups.
> 
> I had a quick skim of the Peridot docs and the references to reserved 
> multicast I see are all about the 802.1D BPDUs.
> 
> It might be necessary to configure MLD snooping or add an FDB entry to 
> get the ff02::1::2 packets to the CPU.
> 
> There is also the possibility that the CPUs Ethernet port is dropping 
> the packets for similar reasons. I'd expect Linux to handle that 
> correctly put perhaps with a DSA configuration it skips the multicast 
> reception config.
> 
> As another thought do you know what DHCPv6 client/server is being used. 
> There was a fairly recent bugfix for busybox that was needed because the 
> v6 code was using the wrong MAC address.

Unlike standalone Ethernet NICs, DSA network devices do not currently
filter multicast or unicast using their ndo_set_rx_mode() at the switch
level, however they do program the DSA master network device's RX
filter, so this could be a source of bugs as well, possibly.

There is work in progress to address that by Vladimir [1], however by
default the switch is expected to flood unknown MC and UC towards the
CPU port.

[1]: https://patchwork.ozlabs.org/project/netdev/list/?series=178540
-- 
Florian
