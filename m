Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5365B0379
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbfIKSTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:19:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfIKSTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:19:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 33882607C6; Wed, 11 Sep 2019 18:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568225964;
        bh=Cq8dA5RuJNCfEAowmhvZuC5y4iuFy5mhIPmTToluUMs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=D4aSuyuLCh3pJmHnnFpuTZCHcgVPaPoy16SYi1IkAD2LGzeyMkb1mf4M04VdRUEsl
         deUcjNc05bsek504fYmwIDZbrG6EDW1lu3lpUtBPeCdZqQkJ68cukQl+Hzlsp1p82J
         wny+cIg6vd2kG6sSC7EPTgNfqTVcbu96E3ggKVSY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 933CF602BC;
        Wed, 11 Sep 2019 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568225963;
        bh=Cq8dA5RuJNCfEAowmhvZuC5y4iuFy5mhIPmTToluUMs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oPoyWpwWaYG6gmpB5EbPPo9zZG4bz8pA8hQ3l4p8ZV5bp+GMzxvD0tduXjlV+A/vn
         4PvOsNNH3umELX67JiyoIbxDx+wsjMi3kYHic0fJIv+3qNnM2tnVsy/YnztgZjQHat
         egYPG4zlizRYUB9g1n3e9+jHAuwVloSa1avaEzGg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 933CF602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
        <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
Date:   Wed, 11 Sep 2019 21:19:19 +0300
In-Reply-To: <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 11 Sep 2019 12:26:32 +0200")
Message-ID: <87ef0mlmqg.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

>>    ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware
>>    ath10k_pci 0000:02:00.0: failed to set 5g txpower 23: -11
>>    ath10k_pci 0000:02:00.0: failed to setup tx power 23: -11
>>    ath10k_pci 0000:02:00.0: failed to recalc tx power: -11
>>    ath10k_pci 0000:02:00.0: failed to set inactivity time for vdev 0: -108
>>    ath10k_pci 0000:02:00.0: failed to setup powersave: -108
>> 
>> That certainly looks like something did try to set a power limit, but
>> eventually failed.
>
> Yeah, that does seem a bit fishy. Kalle would have to comment for
> ath10k.
>
>> Immediately after that:
>> 
>>    wlp2s0: deauthenticating from 54:ec:2f:05:70:2c by local choice
>> (Reason: 3=DEAUTH_LEAVING)
>
> I don't _think_ any of the above would be a reason to disconnect, but it
> clearly looks like the device got stuck at this point, since everything
> just fails afterwards.

Yeah, to me it looks anything ath10k tries to do with the devie fails,
even resetting the device.

> Looks like indeed the driver gives the device at least *3 seconds* for
> every command, see ath10k_wmi_cmd_send(), so most likely this would
> eventually have finished, but who knows how many firmware commands it
> would still have attempted to send...

3 seconds is a bit short but in normal cases it should be enough. Of
course we could increase the delay but I'm skeptic it would help here.

> Perhaps the driver should mark the device as dead and fail quickly once
> it timed out once, or so, but I'll let Kalle comment on that.

Actually we do try to restart the device when a timeout happens in
ath10k_wmi_cmd_send():

        if (ret == -EAGAIN) {
                ath10k_warn(ar, "wmi command %d timeout, restarting hardware\n",
                            cmd_id);
                queue_work(ar->workqueue, &ar->restart_work);
        }
                        

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
