Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C374A7678
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbiBBRHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:07:13 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:45164 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbiBBRHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:07:13 -0500
Received: from [IPV6:2003:e9:d731:20df:8d81:5815:ac7:f110] (p200300e9d73120df8d8158150ac7f110.dip0.t-ipconnect.de [IPv6:2003:e9:d731:20df:8d81:5815:ac7:f110])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9A9B1C07BA;
        Wed,  2 Feb 2022 18:07:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643821631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7n5yVKh4GIQdEb7lDq+H4Ebq+rZEZny6GqYiUP1FmU=;
        b=baGpCIKsSgR3IJ14KL2eEUt53tKDLeyejzMdj0xLHmx7l3Tdxne44pamNX0FF4ZdRyZet6
        57KoRKO3ununyE2VbwwF0OQPdlDGKs84cEZLSIECokccCyXxlOhpWU2Z5oespWa3IiTs6e
        EfyehVyb2n7+bfCZ/iZB5hBusc4XCyyyIL52bf7LTvOR65lhq6D8nvANQNBmSx2Wt+N+A9
        HD2cBV8PnRWQpQlJvHMrJpTpjXY1PaZT+GojaV6vIPRv4hAcytWwoCO5Y5SN4w2pw39oEf
        ci96oeTDA1745cBMwYyQaJ9DWdpMQuFj8bPeQgmqw6R4p/gd0qPIN+Zm4NEUGA==
Message-ID: <8bb9c2e0-21ed-d6ad-ddfe-c748ae06d66e@datenfreihafen.org>
Date:   Wed, 2 Feb 2022 18:07:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH wpan-next v2 5/5] net: ieee802154: Drop duration settings
 when the core does it already
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-6-miquel.raynal@bootlin.com>
 <20220201184014.72b3d9a3@xps13>
 <fab37d38-0239-8be3-81aa-98d163bf5ca4@datenfreihafen.org>
 <20220202084017.7a88f20d@xps13>
 <026d499d-2814-2d5a-b148-fd7ec8ae9eb6@datenfreihafen.org>
 <20220202145034.13a34e98@xps13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220202145034.13a34e98@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 02.02.22 14:50, Miquel Raynal wrote:
> Hi Stefan,
> 
> stefan@datenfreihafen.org wrote on Wed, 2 Feb 2022 13:17:39 +0100:
> 
>> Hello.
>>
>> On 02.02.22 08:40, Miquel Raynal wrote:
>>> Hi Stefan,
>>>
>>> stefan@datenfreihafen.org wrote on Tue, 1 Feb 2022 21:51:04 +0100:
>>>    
>>>> Hello.
>>>>
>>>> On 01.02.22 18:40, Miquel Raynal wrote:
>>>>> Hi,
>>>>>     >>>> --- a/drivers/net/ieee802154/ca8210.c
>>>>>> +++ b/drivers/net/ieee802154/ca8210.c
>>>>>> @@ -2978,7 +2978,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
>>>>>>     	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
>>>>>>     	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
>>>>>>     	ca8210_hw->phy->cca_ed_level = -9800;
>>>>>> -	ca8210_hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
>>>>>>     	ca8210_hw->phy->lifs_period = 40;
>>>>>>     	ca8210_hw->phy->sifs_period = 12;
>>>>>
>>>>> I've missed that error                ^^
>>>>>
>>>>> This driver should be fixed first (that's probably a copy/paste of the
>>>>> error from the other driver which did the same).
>>>>>
>>>>> As the rest of the series will depend on this fix (or conflict) we could
>>>>> merge it through wpan-next anyway, if you don't mind, as it was there
>>>>> since 2017 and these numbers had no real impact so far (I believe).
>>>>
>>>> Not sure I follow this logic. The fix you do is being removed in 4/4 of your v3 set again. So it would only be in place for these two in between commits.
>>>
>>> Exactly.
>>>    
>>>> As you laid out above this has been in place since 2017 and the number have no real impact. Getting the fix in wpan-next to remove it again two patches later would not be needed here.
>>>>
>>>> If you would like to have this fixed for 5.16 and older stable kernels I could go ahead and apply it to wpan and let it trickle down into stable trees.
>>>
>>> I'm fine "ignoring" the issue in stable kernels, it was just a warning
>>> for you that this would happen otherwise, given the fact that this is
>>> the second driver doing so (first fix has already been merged) and that
>>> I just realized it now.
>>>    
>>>> We would have to deal with either a merge of net into net-next or with
>>>> a merge conflicts when sending the pull request. Both can be done.
>>>>
>>>> But given the circumstances above I have no problem to drop this fix completely and have it fixed implicitly with the rest of the patchset.
>>>
>>> Fine by me!
>>
>> Let's do it like this.
>> You drop it from this series against wpan-next.
>> I will pull it out of the series and apply to wpan directly. That way we get it into the stable kernels as well. You already did the work so we should not waste it.
>> I will deal with the merge conflict get get between wpan/net and wpan-next/net-next on my side. Nothing to worry for you.
> 
> That's very kind, but don't feel forced to do that, I won't turn mad if
> you finally decide that this requires too much handling for such a
> short-in-time improvement ;)

Nah, don't worry. I just applied it to wpan. It's the right thing to do 
as we simply do not know who is using the driving in what situation. 
Holding off a fix that you already did would be silly.

I deal with the merge conflict when it comes to it.

regards
Stefan Schmidt
