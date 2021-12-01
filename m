Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09877464D2C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242543AbhLALtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLALtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:49:05 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D14BC061574;
        Wed,  1 Dec 2021 03:45:44 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1msO3O-00074i-FC; Wed, 01 Dec 2021 12:45:38 +0100
Message-ID: <cd155eaf-8559-b7ad-d9da-818f59f21872@leemhuis.info>
Date:   Wed, 1 Dec 2021 12:45:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-BS
To:     Stefan Dietrich <roots@gmx.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
 <YZ3q4OKhU2EPPttE@kroah.com>
 <8119066974f099aa11f08a4dad3653ac0ba32cd6.camel@gmx.de>
 <20211124153449.72c9cfcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6htm4aj.fsf@intel.com>
 <227af6b0692a0a57f5fb349d4d9c914301753209.camel@gmx.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
In-Reply-To: <227af6b0692a0a57f5fb349d4d9c914301753209.camel@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1638359144;a2c7a904;
X-HE-SMSGID: 1msO3O-00074i-FC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 25.11.21 09:41, Stefan Dietrich wrote:
> 
> thanks - this was spot-on: disabling CONFIG_PCIE_PTM resolves the issue
> for latest 5.15.4 (stable from git) for both manual and network-manager
> NIC configuration.
> 
> Let me know if I may assist in debugging this further.

What is the status here? There afaics hasn't been any progress since
nearly a week.

Vinicius, do you still have this on your radar? Or was there some progress?

Or is this really related to another issue, as Jakub suspected? Then it
might be solved by the patch here:

https://bugzilla.kernel.org/show_bug.cgi?id=215129

Ciao, Thorsten

> On Wed, 2021-11-24 at 17:07 -0800, Vinicius Costa Gomes wrote:
>> Hi Stefan,
>>
>> Jakub Kicinski <kuba@kernel.org> writes:
>>
>>> On Wed, 24 Nov 2021 18:20:40 +0100 Stefan Dietrich wrote:
>>>> Hi all,
>>>>
>>>> six exciting hours and a lot of learning later, here it is.
>>>> Symptomatically, the critical commit appears for me between
>>>> 5.14.21-
>>>> 051421-generic and 5.15.0-051500rc2-generic - I did not find an
>>>> amd64
>>>> build for rc1.
>>>>
>>>> Please see the git-bisect output below and let me know how I may
>>>> further assist in debugging!
>>>
>>> Well, let's CC those involved, shall we? :)
>>>
>>> Thanks for working thru the bisection!
>>>
>>>> a90ec84837325df4b9a6798c2cc0df202b5680bd is the first bad commit
>>>> commit a90ec84837325df4b9a6798c2cc0df202b5680bd
>>>> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>>>> Date:   Mon Jul 26 20:36:57 2021 -0700
>>>>
>>>>     igc: Add support for PTP getcrosststamp()
>>
>> Oh! That's interesting.
>>
>> Can you try disabling CONFIG_PCIE_PTM in your kernel config? If it
>> works, then it's a point in favor that this commit is indeed the
>> problematic one.
>>
>> I am still trying to think of what could be causing the lockup you
>> are
>> seeing.
>>
>>

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave they thus might sent someone reading this down the
wrong rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

#regzbot poke
