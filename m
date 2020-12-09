Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6A2D44A7
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgLIOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:46:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLIOqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607525072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e7Pu0i4wzMW+hUAEXm/gf9JpqIG0w2jh68wmkJ/xVbM=;
        b=SSMSyeZKcymK3sSFQLcwnDpkCi1sfVdMIbHMFoS0KODMovsaO03p6R2SFrMzu7xePtSrvC
        ZiwMPU7hrxWSTXt8XE56KCBcrvj/O8ywTfV4dqhrpEeXPMyMyYXc5iHMypoK0jqKTU/TSE
        dx1soFcXnootMoL1r2Qk8wEsZdbrG9M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-FDTXcp6rN8Cvx9Lq9OZBtA-1; Wed, 09 Dec 2020 09:44:26 -0500
X-MC-Unique: FDTXcp6rN8Cvx9Lq9OZBtA-1
Received: by mail-ej1-f70.google.com with SMTP id m4so588321ejc.14
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e7Pu0i4wzMW+hUAEXm/gf9JpqIG0w2jh68wmkJ/xVbM=;
        b=rBg9ehUXxxYxAnnjrmw2dDDLoH3IvCzxESaGD57Z3Hb9Pn9lOxea/rOUxREBBWJBQp
         QFE2UnMyQ/cs5YK8+HKM2sNvXY2IkrnfBucu9+M/b2Er9Dk4PtXOHOOolJxL8kMtwzFT
         FeJ0w9k+tQkmH3DuStIvmA/SlTBfeGk4yWKIAyoUDF/dpWqFeHxT1qHKQEI0+7S+i2Ed
         3gdf+oRwXj9ey6XX2TFC7R1WAqk86UMZRgHJV0st4DKyr+cZbmre+gI37CV8LB7eai0k
         dgE1pi9oVkMalLX8iD9qpDyEV2KqBKbKDHd5RwCTXTIRCjNJHTIRGsFERX9wucUKQEb8
         ZyJA==
X-Gm-Message-State: AOAM530HGHJxnibgrr5za0KLvjxAKtTKLfbtcCCj6/t3uCYwB6OU/MYL
        ioP7iyqB74pP8npfP4+A9LXPPC6WIEoVU19davH3ZUFgvKWTH70KT07FwioxlZFS2psunAJWHD2
        uu45FPDrb4BEeJYfw
X-Received: by 2002:a17:906:298c:: with SMTP id x12mr2369484eje.244.1607525064714;
        Wed, 09 Dec 2020 06:44:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyf4Ei5vw5hwUpJ8v+dC3wOPNfIOkK6CdbAHhWnJT1B66rp6MW7UiLMUBcR4YGCNGhl5k1SIw==
X-Received: by 2002:a17:906:298c:: with SMTP id x12mr2369472eje.244.1607525064422;
        Wed, 09 Dec 2020 06:44:24 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id b21sm1905696edr.53.2020.12.09.06.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:44:23 -0800 (PST)
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        viltaly.lifshits@intel.com
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
 <DM6PR19MB2636A4097B68DBB253C416D8FACE0@DM6PR19MB2636.namprd19.prod.outlook.com>
 <383daf0d-8a9b-c614-aded-6e816f530dcd@intel.com>
 <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
 <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f02a02b7-16e7-89e9-f7ca-b6554ef5503e@redhat.com>
Date:   Wed, 9 Dec 2020 15:44:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/8/20 5:14 PM, Alexander Duyck wrote:
> On Tue, Dec 8, 2020 at 1:30 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi,
>>
>> On 12/8/20 6:08 AM, Neftin, Sasha wrote:
>>> On 12/7/2020 17:41, Limonciello, Mario wrote:
>>>>> First of all thank you for working on this.
>>>>>
>>>>> I must say though that I don't like the approach taken here very
>>>>> much.
>>>>>
>>>>> This is not so much a criticism of this series as it is a criticism
>>>>> of the earlier decision to simply disable s0ix on all devices
>>>>> with the i219-LM + and active ME.
>>>>
>>>> I was not happy with that decision either as it did cause regressions
>>>> on all of the "named" Comet Lake laptops that were in the market at
>>>> the time.  The "unnamed" ones are not yet released, and I don't feel
>>>> it's fair to call it a regression on "unreleased" hardware.
>>>>
>>>>>
>>>>> AFAIK there was a perfectly acceptable patch to workaround those
>>>>> broken devices, which increased a timeout:
>>>>> https://patchwork.ozlabs.org/project/intel-wired-
>>>>> lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
>>>>>
>>>>> That patch was nacked because it increased the resume time
>>>>> *on broken devices*.
>>>>>
>>> Officially CSME/ME not POR for Linux and we haven't interface to the ME. Nobody can tell how long (and why) ME will hold PHY access semaphore ant just increasing the resuming time (ULP configure) won't be solve the problem. This is not reliable approach.
>>> I would agree users can add ME system on their responsibilities.
>>
>> It is not clear to me what you are trying to say here.
> 
> Based on the earlier thread you had referenced and his comment here it
> sounds like while adding time will work for most cases, it doesn't
> solve it for all cases.

AFAIK there are 0 documented cases where the suspend/resume issue
continues to be a problem after the timeout has been increased.

If you know of actual documented cases (rather then this just being
a theoretical problem), then please provide links to those cases.

> The problem is as a vendor you are usually
> stuck looking for a solution that will work for all cases which can
> lead to things like having to drop features because they can be
> problematic for a few cases.

I disagree, there will/might always be some broken corner case
laptop-model / hw-design out there on which a feature breaks. Simply
disabling all features which might cause problems in "a few cases"
would mean that we pretty much have to disable over half the features
in the kernel.

Take for example SATA NCQ (command queing) this is know to not work
on some devices, up to the point of where with some buggy firmwares
it may cause full systems hangs and/or data-corruption. So this is
a much bigger problem then the "system won't suspend" issue we
are talking about here. Still the ATA subsys maintainers have enabled
this by default because it is an important feature to have and they
are using a deny-list to avoid enabling this on known broken hardware;
and yes every know and then we need to add a new model to the deny-list.

And the same for SATA ALPM support (a power-management feature like s0ix)
that is enabled by default too, combined with a deny-list.
I'm very familiar with the ALPM case since I pushed of it being
enabled by default and I've done most of the maintenance work
of the deny-list since it was enabled by default.

The kernel is full of this pattern, we don't disable an important
feature (and power-management is important) just because of this
causing issues in "a few cases". And again you say "a few cases"
but I know of 0 documented cases where this issue is still a problem
after bumping the timeout.

>> Are you saying that you insist on keeping the e1000e_check_me check and
>> thus needlessly penalizing 100s of laptops models with higher
>> power-consumption unless these 100s of laptops are added manually
>> to an allow list for this?
>>
>> I'm sorry but that is simply unacceptable, the maintenance burden
>> of that is just way too high.
> 
> Think about this the other way though. If it is enabled and there are
> cases where adding a delay doesn't resolve it then it still doesn't
> really solve the issue does it?

Again AFAIK that is a theoretical "If it ..." and even if it is not
theoretical, then we can add a deny-list. Maintaining a deny list for
"a few cases" being broken is a lot easier then maintaining an allow
list for allother hardware out there.

Let me put it this way, the allow-list will be orders of magnitude
longer then the deny lists. Which list would you rather manually
keep up2date?


>> Testing on the models where the timeout issue was first hit has
>> shown that increasing the timeout does actually fix it on those
>> models. Sure in theory the ME on some buggy model could hold the
>> semaphore even longer, but then the right thing would be to
>> have a deny-list for s0ix where we can add those buggy models
>> (none of which we have encountered sofar). Just like we have
>> denylist for buggy hw in other places in the kernel.
> 
> This would actually have a higher maintenance burden then just
> disabling the feature. Having to individually test for and deny-list
> every one-off system with this bad configuration would be a pretty
> significant burden. That also implies somebody would have access to
> such systems and that is not normally the case. Even Intel doesn't
> have all possible systems that would include this NIC.
> 
>> Maintaining an ever growing allow list for the *theoretical*
>> case of encountering a model where things do not work with
>> the increased timeout is not a workable and this not an
>> acceptable solution.
> 
> I'm not a fan of the allow-list either, but it is preferable to a
> deny-list where you have to first trigger the bug before you realize
> it is there.

IIRC, if the bug is there the system does not suspend, and the e1000e
driver logs an error that it is the culprit. So this is very easy to spot /
detect by end users when they hit it.

Again the kernel is full of deny lists to disable some features
on broken hardware, with sometimes hitting the buggy/broken hw
scenario having much worse consequences. Yet this is how this is
done everywhere.

The e1000e driver really is not all that special that it should
get an exception to how this is normally done.

> Ideally there should be another solution in which the ME
> could somehow set a flag somewhere in the hardware to indicate that it
> is alive and the driver could read that order to determine if the ME
> is actually alive and can skip this workaround. Then this could all be
> avoided and it can be safely assumed the system is working correctly.
> 
>> The initial addition of the e1000e_check_me check instead
>> of just going with the confirmed fix of bumping the timeout
>> was already highly controversial and should IMHO never have
>> been done.
> 
> How big was the sample size for the "confirmed" fix? How many
> different vendors were there within the mix? The problem is while it
> may have worked for the case you encountered you cannot say with
> certainty that it worked in all cases unless you had samples of all
> the different hardware out there.
> 
>> Combining this with an ever-growing allow-list on which every
>> new laptop model needs to be added separately + a new
>> "s0ix-enabled" ethertool flag, which existence is basically
>> an admission that the allow-list approach is flawed goes
>> from controversial to just plain not acceptable.
> 
> I don't view this as problematic, however this is some overhead to it.
> One thing I don't know is if anyone has looked at is if the issue only
> applies to a few specific system vendors. Currently the allow-list is
> based on the subdevice ID. One thing we could look at doing is
> enabling it based on the subvendor ID in which case we could
> allow-list in large swaths of hardware with certain trusted vendors.
> The only issue is that it pulls in any future parts as well so it puts
> the onus on that manufacturer to avoid misconfiguring things in the
> future.

If we go this route, we will likely get Dell, Lenovo (which had
the issue without the increased timeout) and maybe HP on the
allow-list, probably with a finer grained deny-list on top to
opt out on some models from these vendors where things turn
out to be buggy after all.

This:

1. Still requires a deny-list on top (at least this is very likely)
2. Leaves users of all but the 3 big vendors in the cold which
really is not a nice way to deal with this.

Regards,

Hans

