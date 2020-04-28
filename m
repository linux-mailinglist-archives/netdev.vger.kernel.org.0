Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7B1BC127
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgD1O11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:27:27 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:56784 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgD1O11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:27:27 -0400
Received: from [192.168.254.4] (unknown [50.34.219.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 15B2313C283;
        Tue, 28 Apr 2020 07:27:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 15B2313C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1588084046;
        bh=uJfi3yqJT689k/koN7HWdgLdOqnl3VJ1ES5anj/Umb4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=fN9YNTV5I6Omibnf0OY3BKpmE5av8OT+WHtiZg9c5deRZt+tc41d0scOzOMwQcsE1
         1mbSWQDZN5tzgPiAi0/Jqj4JsaNr4pVg/5zKq8s8NyTSl5kP1hEWAAtX5x5x/lfBEw
         yDb5OYYRI/biBC0TzdbjdWp4DVChOKz3ofS9HIyY=
Subject: Re: [PATCH] ath10k: increase rx buffer size to 2048
To:     Kalle Valo <kvalo@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>
References: <20200205191043.21913-1-linus.luessing@c0d3.blue>
 <3300912.TRQvxCK2vZ@bentobox> <3097447.aZuNXRJysd@sven-edge>
 <87blnblsyv.fsf@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <ll@simonwunderlich.de>,
        mail@adrianschmutzler.de
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <db0f12d8-0604-70fa-81ad-5c1060eb0c6e@candelatech.com>
Date:   Tue, 28 Apr 2020 07:27:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <87blnblsyv.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/28/2020 05:01 AM, Kalle Valo wrote:
> Sven Eckelmann <sven@narfation.org> writes:
>
>> On Wednesday, 1 April 2020 09:00:49 CEST Sven Eckelmann wrote:
>>> On Wednesday, 5 February 2020 20:10:43 CEST Linus Lüssing wrote:
>>>> From: Linus Lüssing <ll@simonwunderlich.de>
>>>>
>>>> Before, only frames with a maximum size of 1528 bytes could be
>>>> transmitted between two 802.11s nodes.
>>>>
>>>> For batman-adv for instance, which adds its own header to each frame,
>>>> we typically need an MTU of at least 1532 bytes to be able to transmit
>>>> without fragmentation.
>>>>
>>>> This patch now increases the maxmimum frame size from 1528 to 1656
>>>> bytes.
>>> [...]
>>>
>>> @Kalle, I saw that this patch was marked as deferred [1] but I couldn't find
>>> any mail why it was done so. It seems like this currently creates real world
>>> problems - so would be nice if you could explain shortly what is currently
>>> blocking its acceptance.
>>
>> Ping?
>
> Sorry for the delay, my plan was to first write some documentation about
> different hardware families but haven't managed to do that yet.
>
> My problem with this patch is that I don't know what hardware and
> firmware versions were tested, so it needs analysis before I feel safe
> to apply it. The ath10k hardware families are very different that even
> if a patch works perfectly on one ath10k hardware it could still break
> badly on another one.
>
> What makes me faster to apply ath10k patches is to have comprehensive
> analysis in the commit log. This shows me the patch author has
> considered about all hardware families, not just the one he is testing
> on, and that I don't need to do the analysis myself.

It has been in ath10k-ct for a while, and that has some fairly wide coverage
in OpenWrt, so likely if there were problems we would have seen it already.

I did not make any specific changes to firmware to support this, so upstream
firmware should behave similarly.

Seems like upstream ath10k could really benefit from having some test beds
so you can actually test code on different chips and have confidence
in your changes!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
