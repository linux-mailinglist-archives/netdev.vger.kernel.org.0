Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C875269177
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgINQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgINQZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:25:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BCFC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:25:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k14so170315pgi.9
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AjkQmibtnPMFeiIuA/emeKx42IvxqoodSR+cqoE++bY=;
        b=g57q+kL9yBD1DrOEQRmWUVmdUh5DvambYRzh56grcJ0wLPrTO5j2dXrGnw2hVw4r38
         VyBdwcZ9XdOdeoFa3lUQAy5nH6GxqT9VC18s3BF76UreYXDs+yqgML05t71ym168SYja
         raGriEUZ/nld14JHgF3BgAXtOnfqbn3N8yLmpARK0StROeh1OMW1apexREA7A/4YcgJU
         SkhPTs4P02cKSkih96gMb5ZS9G2a5LWshwY9NdPxX2X88rt8h0q00ETOlnAlU0M/mApr
         RN7JeQ5weZCjPk9hmf3fDHTXuf0WhMXEnFDjXg1AsH0Tbr3me2Fm/V7ex3s5hQ5Sdhxl
         Icwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjkQmibtnPMFeiIuA/emeKx42IvxqoodSR+cqoE++bY=;
        b=tXnROiXL1dLRodHw3Q1YpGqPV9nPO0UtsLyCdWWzA0fMaSG3Fn8qvXRU42tfOAaOBn
         SBEA3EjhKfBQmVzUnNnvy1mK4nBoVUYkeBa+aheuidEC2O3G6e4kKfJ0nPZj5LeAtPna
         5uyRfLqJzRvWE2CP1hXWNCuZbl/Ue5T+zS4hIRAl6K6bVZHTDP+2DOahu0IYp4vK7y9t
         LbL4hTs5eWFFvx8Qe2kvVx09vl+jjQwnIPXDnr5cMrLEge+FlohvJsXuDnTwhkZWUyr2
         QjXunhXSklu8D4bBy9/1h65w3seOZLde14t/mvI+i0wq3o+C9djjV5w0T8veymNRvt6t
         X/lQ==
X-Gm-Message-State: AOAM533IUiFWsWxfwCP1mr14MMBnkHyJzzQ8lqi6XixbuTDZ96eT3bVC
        DmRlGwctn8QbmXnsx+Uihak=
X-Google-Smtp-Source: ABdhPJwja15GqNmIHeyj35OfRreuv1VlG4OGMKmNXR4du6hkSXhbhU5QwGdwim/ryXsWDgxO6T514A==
X-Received: by 2002:a63:c80b:: with SMTP id z11mr11460503pgg.440.1600100746617;
        Mon, 14 Sep 2020 09:25:46 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r144sm11573172pfc.63.2020.09.14.09.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 09:25:45 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912001542.fqn2hcp35xkwqoun@skbuf>
 <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
 <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <b3f766f9-498a-a529-0e37-c6afa440dbd5@gmail.com>
Date:   Mon, 14 Sep 2020 09:25:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2020 8:53 AM, Jakub Kicinski wrote:
> On Fri, 11 Sep 2020 19:54:11 -0700 Florian Fainelli wrote:
>>> I think I'm missing the problem you're trying to describe.
>>> Are you making a general comment / argument on ethtool stats?
>>>
>>> Pause stats are symmetrical - as can be seen in your quote
>>> what's RX for the CPU is TX for the switch, and vice versa.
>>>
>>> Since ethtool -A $cpu_mac controls whether CPU netdev generates
>>> and accepts pause frames, correspondingly the direction and meaning
>>> of pause statistics on that interface is well defined.
>>>
>>> You can still append your custom CPU port stats to ethtool -S or
>>> debugfs or whatnot, but those are only useful for validating that
>>> the configuration of the CPU port is not completely broken. Otherwise
>>> the counters are symmetrical. A day-to-day user of the device doesn't
>>> need to see both of them.
>>
>> It would be a lot easier to append the stats if there was not an
>> additional ndo introduce to fetch the pause statistics because DSA
>> overlay ndo on a function by function basis. Alternatively we should
>> consider ethtool netlink operations over a devlink port at some point so
>> we can get rid of the ugly ndo and ethtool_ops overlay that DSA does.
> 
> I'm trying to target the 99.9% of users here, so in all honesty I'm
> concerned that if we try to cater to strange corner cases too much
> the entire interface will suffer. Hence I decided not to go with
> devlink, but extend the API people already know and use. It's the most
> logical and obvious place to me.
> 
>> Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a
>> stringset identifier? That way there is a single point within driver to
>> fetch stats.
> 
> Can you say more? There are no strings reported in this patch set.

What I am suggesting is that we have a central and unique method for 
drivers to be called for all ethtool statisitcs to be obtained, and not 
create another ethtool operation specifically for pause stats.

Today we have get_ethtool_stats and a stringset argument that tells you 
which type of statistic to return. I am not suggesting that we return 
strings or that it should be necessary for fetching pause stats.
-- 
Florian
