Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CED496D92
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiAVTRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:17:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAVTRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:17:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F2EFB8092A;
        Sat, 22 Jan 2022 19:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0906C004E1;
        Sat, 22 Jan 2022 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642879060;
        bh=JeXyzQULWAbMFiomXAsBJNjnrrAJw5Mhyf59QGiZVeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJghKbHCWhhld84ChEdv1nbqcjjMpckEn/db3woEjyGguVvRFezPhBgFEzsfbk6ZY
         Yf8sPYOMEUJ/AGXmOgrZ6QhF7bFbOpJMT5+SZIHs7ZsthkWX39YOLCWfdon4c4JaqK
         dJZPUrhAuYbf46qh6GY9Uz5/AegtWYH25VU2fT7PCoF2d9SS1t87a7Gz1ohvxtYVGA
         C3+xYc0k9kRnbhdFFLDBY8AZuZX/fwoXf7n8PvPs3+93165GLs6ybHFydLQu3EsgXk
         JqHRyFcnz05PISBjcexYSF16MvvRXAZSY+yWwpz8YiT+eu+WZ7r4UT/7/dfX7FmaBt
         Mv4osTx3hnu8A==
Date:   Sat, 22 Jan 2022 14:17:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 203/217] net: dsa: hold rtnl_mutex when
 calling dsa_master_{setup,teardown}
Message-ID: <YexYUqZzurZ1F3kc@sashalap>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-203-sashal@kernel.org>
 <20220118121329.v6inazagzduz6fyw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118121329.v6inazagzduz6fyw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 02:13:29PM +0200, Vladimir Oltean wrote:
>Hi Sasha,
>
>On Mon, Jan 17, 2022 at 09:19:26PM -0500, Sasha Levin wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit c146f9bc195a9dc3ad7fd000a14540e7c9df952d ]
>>
>> DSA needs to simulate master tracking events when a binding is first
>> with a DSA master established and torn down, in order to give drivers
>> the simplifying guarantee that ->master_state_change calls are made
>> only when the master's readiness state to pass traffic changes.
>> master_state_change() provide a operational bool that DSA driver can use
>> to understand if DSA master is operational or not.
>> To avoid races, we need to block the reception of
>> NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
>> chain while we are changing the master's dev->dsa_ptr (this changes what
>> netdev_uses_dsa(dev) reports).
>>
>> The dsa_master_setup() and dsa_master_teardown() functions optionally
>> require the rtnl_mutex to be held, if the tagger needs the master to be
>> promiscuous, these functions call dev_set_promiscuity(). Move the
>> rtnl_lock() from that function and make it top-level.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Please drop this patch from all stable branches (5.16, 5.15, 5.10).
>Thanks.

Dropped, thanks!

-- 
Thanks,
Sasha
