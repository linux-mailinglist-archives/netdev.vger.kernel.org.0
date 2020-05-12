Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BB01D008A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbgELVPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731048AbgELVPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 17:15:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E292205C9;
        Tue, 12 May 2020 21:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589318120;
        bh=h/sNaaOBNEIhDG5F88sE/lVoo2pnusKIDpAt5Nj16bU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=15ccKmPYwu9UCPoRG67pADblyZ343olE5H31aaftayRfho+H9r4IYa/rTbJdBV7WC
         OTQe9SpA57tTMSlJTWp4pP3rMrftlBuiYD7omQb7t+We2XOU+MxoZE8cNtjEbnGJvD
         IRtmMWUCDGYkEQEEjd4r4AhFBhhQZIxAlEREc2ZY=
Date:   Tue, 12 May 2020 17:15:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: stable/linux-4.4.y bisection: baseline.login on
 at91-sama5d4_xplained
Message-ID: <20200512211519.GB29995@sasha-vm>
References: <5eb8399a.1c69fb81.c5a60.8316@mx.google.com>
 <2db7e52e-86ae-7c87-1782-8c0cafcbadd8@collabora.com>
 <20200512111059.GA34497@piout.net>
 <980597f7-5170-72f2-ec2f-efc64f5e27eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <980597f7-5170-72f2-ec2f-efc64f5e27eb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 01:29:06PM -0700, Florian Fainelli wrote:
>
>
>On 5/12/2020 4:10 AM, Alexandre Belloni wrote:
>> Hi,
>>
>> On 12/05/2020 06:54:29+0100, Guillaume Tucker wrote:
>>> Please see the bisection report below about a boot failure.
>>>
>>> Reports aren't automatically sent to the public while we're
>>> trialing new bisection features on kernelci.org but this one
>>> looks valid.
>>>
>>> It appears to be due to the fact that the network interface is
>>> failing to get brought up:
>>>
>>> [  114.385000] Waiting up to 10 more seconds for network.
>>> [  124.355000] Sending DHCP requests ...#
>>> ..#
>>> .#
>>>  timed out!
>>> [  212.355000] IP-Config: Reopening network devices...
>>> [  212.365000] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>>> #
>>>
>>>
>>> I guess the board would boot fine without network if it didn't
>>> have ip=dhcp in the command line, so it's not strictly a kernel
>>> boot failure but still an ethernet issue.
>>>
>>
>> I think the resolution of this issue is
>> 99f81afc139c6edd14d77a91ee91685a414a1c66. If this is taken, then I think
>> f5aba91d7f186cba84af966a741a0346de603cd4 should also be backported.
>
>Agreed.

Okay, I've queued both for 4.4, thanks!

f5aba91d7f1 had a little conflict with missing 2b2427d06426 ("phy:
micrel: Add ethtool statistics counters") but I've worked around that.

-- 
Thanks,
Sasha
