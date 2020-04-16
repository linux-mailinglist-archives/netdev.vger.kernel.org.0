Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F281AC642
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403933AbgDPOgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732727AbgDPOgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 10:36:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B425721927;
        Thu, 16 Apr 2020 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587047798;
        bh=K05TjfuN0mVanbfhM9527Uua1VL4QgBScX7Spl6twYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSlPbuF8brl0bdxWL4PZWiqPVPSvkBlP03kjxdkua7AsabxXBKoU8hvIwQ+oQtqa6
         Ew90Zh4aOYUjojrUzchwpgtH6W2Z4yWqBJaw4mizPOIU4BC/hLoJxZ+i4cAO4pYD6d
         rIpH9rzO/H9b8D+ujNbFxbWCv52IX/blltDQ3YZE=
Date:   Thu, 16 Apr 2020 10:36:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416143636.GM1068@sasha-vm>
References: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
 <20200416140441.GL1068@sasha-vm>
 <CAJ3xEMjobvx=S4JC4n+TLwN9xnJcwNa-B4O_Evi6PUq30VJchQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjobvx=S4JC4n+TLwN9xnJcwNa-B4O_Evi6PUq30VJchQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:17:09PM +0300, Or Gerlitz wrote:
>On Thu, Apr 16, 2020 at 5:04 PM Sasha Levin <sashal@kernel.org> wrote:
>> On Thu, Apr 16, 2020 at 04:40:31PM +0300, Or Gerlitz wrote:
>> >On Thu, Apr 16, 2020 at 3:00 AM Sasha Levin <sashal@kernel.org> wrote:
>> >> I'd maybe point out that the selection process is based on a neural
>> >> network which knows about the existence of a Fixes tag in a commit.
>> >>
>> >> It does exactly what you're describing, but also taking a bunch more
>> >> factors into it's desicion process ("panic"? "oops"? "overflow"? etc).
>> >
>> >As Saeed commented, every extra line in stable / production kernel
>> >is wrong. IMHO it doesn't make any sense to take into stable automatically
>> >any patch that doesn't have fixes line. Do you have 1/2/3/4/5 concrete
>> >examples from your (referring to your Microsoft employee hat comment
>> >below) or other's people production environment where patches proved to
>> >be necessary but they lacked the fixes tag - would love to see them.
>>
>> Sure, here are 5 from the past few months:
>>
>> e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
>> 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
>> 39d170b3cb62 ("ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()")
>> 8b51dc729147 ("rsi: fix a double free bug in rsi_91x_deinit()")
>> 5146f95df782 ("USB: hso: Fix OOB memory access in hso_probe/hso_get_config_data")
>>
>> 5 Different drivers, neither has a stable tag or a Fixes: tag, all 5
>> have a CVE number assigned to them.
>
>CVE number sounds good enough to me to AI around and pull to
>stable,  BUT only to where relevant, and nothing beyond (see below).

But this is true with so many other things... This example was easy
because I could grep for CVE, but what about commits that don't get
assigned a CVE number but are just as severe?

Here are few without a CVE ID:

f700546682a6 ("rsi: fix nommu_map_sg overflow kernel panic")
3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
536dc5df2808 ("hv_netvsc: Fix memory leak when removing rndis device")

Could we agree here that important commits from drivers/net/ don't have
a fixes tag but still should end up in stable?

>> >We've been coaching new comers for years during internal and on-list
>> >code reviews to put proper fixes tag. This serves (A) for the upstream
>> >human review of the patch and (B) reasonable human stable considerations.
>>
>> Thanks for doing it - we do see more and more fixes tags.
>>
>> >You are practically saying that for cases we screwed up stage (A) you
>> >can somehow still get away with good results on stage (B) - I don't
>> >accept it. BTW - during my reviews I tend to ask/require developers to
>> >skip the word panic, and instead better explain the nature of the
>> >problem / result.
>>
>> Humans are still humans, and humans make mistakes. Fixes tags get
>> forgotten
>
>In the netdev land, the very much usual habit is for -rc patches to have
>Fixes tag, so maybe some RCA comment here would be to
>enforce that better across the kermel land?

I'd be very happy to see better tagging (not just fixes, but also
reported-by/tested-by/etc).

>> stable tags get forgotten.
>
>An easy AI would be to deduce the -stable tag from the -fixes tag, just
>find out where the offending patch was accepted and never/ever (please!)
>push a fix beyond that kernel.

This is tricky because not all commits with a fixes tag need to go to
stable, right?

We have a bunch of commits that "fix" a documentation typo for example.

>> I very much belive you that the mellanox stuff are in good shape thanks
>> to your efforts, but the kernel world is bigger than a few select drivers.
>
>>>>>> This is great, but the kernel is more than just net/. Note that I also
>>>>>> do not look at net/ itself, but rather drivers/net/ as those end up with
>>>>>> a bunch of missed fixes.
>
>>>>>drivers/net/ goes through the same DaveM net/net-next trees, with the
>>>>> same rules.
>
>>>you ignored this comment, any more specific complaints?
>
>> See above (the example commits). The drivers/net/ stuff don't work as
>> well as net/ sadly.
>
>Disagree.
>
>If there is a problem it is due to some driver/net/ driver maintainers
>not doing their job good enough.

Maybe it's just me missing something here, but I thought that
drivers/net/ aren't supposed to add a stable tag, they're just supposed
to write good commit message, add a fixes tag if necessary, and the
netdev maintainers will do the rest?

"""
Q: How can I tell what patches are queued up for backporting to the various stable releases?
A: Normally Greg Kroah-Hartman collects stable commits himself, but for networking, Dave collects up patches he deems critical for the networking subsystem, and then hands them off to Greg.
"""

There are 2 things I understood from this:

1. "networking subsystem" == net/
2. Dave does patch selection.

>> >> Let me put my Microsoft employee hat on here. We have driver/net/hyperv/
>> >> which definitely wasn't getting all the fixes it should have been
>> >> getting without AUTOSEL.
>> >
>> >> While net/ is doing great, drivers/net/ is not. If it's indeed following
>> >> the same rules then we need to talk about how we get done right.
>> >
>> >I never [1] saw -stable push requests being ignored here in netdev.
>> >Your drivers have four listed maintainers and it's common habit by
>> >commercial companies to have paid && human (non autosel robots)
>> >maintainers that take care of their open source drivers. As in commercial
>> >SW products, Linux has a current, next and past (stable) releases, so
>> >something sounds as missing to me in your care matrix.
>>
>> How come? DaveM is specifically asking not to add stable tags because he
>> will do the selection himself, right? So the hyperv stuff indeed don't
>> include a stable tag, but all fixes should have a proper Fixes: tag.
>
>Ask/tell your maintainer to note that in their cover letters, it will be taken.

Or allow them to tag stuff for stable? :)

>> So why don't they end up in a stable tree?
>
>> If we need to send a mail saying which commits should go to stable, we
>> might as well tag them for stable to begin with, right?
>
>so how about you go and argue with the netdev maintainer and
>settle your complaints instead of WA your disagreements using autosel?

So we had this discussion a while back and what I thought the outcome
was that I'll ignore net/ and so I did.

I've mentioned it before - I'm not stuck on doing what I'm doing now for
no reason. If the netdev maintainers want this done in a different way,
or if you can show me data that what I'm doing is wrong, I'll be happy
to change my workflow.

-- 
Thanks,
Sasha
