Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23C22D8C6B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 09:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405116AbgLMIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 03:34:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:27667 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgLMIez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 03:34:55 -0500
IronPort-SDR: ADqudVa+ux0YXd8nH1AeN7LqJF525L63sthAihw0Jf68xTBWE5VIDK1o9oKSGyeQJhssvqDIax
 Z/ly2Fd9LISw==
X-IronPort-AV: E=McAfee;i="6000,8403,9833"; a="174710547"
X-IronPort-AV: E=Sophos;i="5.78,415,1599548400"; 
   d="scan'208";a="174710547"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2020 00:34:11 -0800
IronPort-SDR: ckNchWv0732E3MSOJyVMzFoXAC6bCRlqWvwlTkj9sVwJeboVYAnUUJHpYW6ISqD/Ad2Zpt2MDM
 yboHrmCqkPeQ==
X-IronPort-AV: E=Sophos;i="5.78,415,1599548400"; 
   d="scan'208";a="366547944"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.185.168.69]) ([10.185.168.69])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2020 00:34:01 -0800
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
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
        viltaly.lifshits@intel.com, "Efrati, Nir" <nir.efrati@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
 <DM6PR19MB2636A4097B68DBB253C416D8FACE0@DM6PR19MB2636.namprd19.prod.outlook.com>
 <383daf0d-8a9b-c614-aded-6e816f530dcd@intel.com>
 <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
 <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
 <f02a02b7-16e7-89e9-f7ca-b6554ef5503e@redhat.com>
 <CAKgT0UeBuy3S2wKrU+5jwEu9w2yQpmG8Bb+HvPvFCSPuZ=Z-6Q@mail.gmail.com>
 <2adc911e-85d4-d533-d17d-55ac78c8fcba@intel.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <0c428918-7ea0-e796-90bb-05d5fa4fd136@intel.com>
Date:   Sun, 13 Dec 2020 10:33:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <2adc911e-85d4-d533-d17d-55ac78c8fcba@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2020 07:28, Neftin, Sasha wrote:
> On 12/10/2020 04:24, Alexander Duyck wrote:
>> On Wed, Dec 9, 2020 at 6:44 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>>
>>> Hi,
>>>
>>> On 12/8/20 5:14 PM, Alexander Duyck wrote:
>>>> On Tue, Dec 8, 2020 at 1:30 AM Hans de Goede <hdegoede@redhat.com> 
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> On 12/8/20 6:08 AM, Neftin, Sasha wrote:
>>>>>> On 12/7/2020 17:41, Limonciello, Mario wrote:
>>>>>>>> First of all thank you for working on this.
>>>>>>>>
>>>>>>>> I must say though that I don't like the approach taken here very
>>>>>>>> much.
>>>>>>>>
>>>>>>>> This is not so much a criticism of this series as it is a criticism
>>>>>>>> of the earlier decision to simply disable s0ix on all devices
>>>>>>>> with the i219-LM + and active ME.
>>>>>>>
>>>>>>> I was not happy with that decision either as it did cause 
>>>>>>> regressions
>>>>>>> on all of the "named" Comet Lake laptops that were in the market at
>>>>>>> the time.  The "unnamed" ones are not yet released, and I don't feel
>>>>>>> it's fair to call it a regression on "unreleased" hardware.
>>>>>>>
>>>>>>>>
>>>>>>>> AFAIK there was a perfectly acceptable patch to workaround those
>>>>>>>> broken devices, which increased a timeout:
>>>>>>>> https://patchwork.ozlabs.org/project/intel-wired-
>>>>>>>> lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
>>>>>>>>
>>>>>>>> That patch was nacked because it increased the resume time
>>>>>>>> *on broken devices*.
>>>>>>>>
>>>>>> Officially CSME/ME not POR for Linux and we haven't interface to 
>>>>>> the ME. Nobody can tell how long (and why) ME will hold PHY access 
>>>>>> semaphore ant just increasing the resuming time (ULP configure) 
>>>>>> won't be solve the problem. This is not reliable approach.
>>>>>> I would agree users can add ME system on their responsibilities.
>>>>>
>>>>> It is not clear to me what you are trying to say here.
>>>>
>>>> Based on the earlier thread you had referenced and his comment here it
>>>> sounds like while adding time will work for most cases, it doesn't
>>>> solve it for all cases.
>>>
>>> AFAIK there are 0 documented cases where the suspend/resume issue
>>> continues to be a problem after the timeout has been increased.
>>>
>>> If you know of actual documented cases (rather then this just being
>>> a theoretical problem), then please provide links to those cases.
>>
>> If there are such notes I wouldn't have access to them. Do we know if
>> any sort of errata document has been posted for this issue by Intel?
>> That would be where an explanation of the problems and the reasoning
>> behind the workaround would be defined. Without that I am just
>> speculating based off of what has been said here and in the other
>> thread.
>>
>>>> The problem is as a vendor you are usually
>>>> stuck looking for a solution that will work for all cases which can
>>>> lead to things like having to drop features because they can be
>>>> problematic for a few cases.
>>>
>>> I disagree, there will/might always be some broken corner case
>>> laptop-model / hw-design out there on which a feature breaks. Simply
>>> disabling all features which might cause problems in "a few cases"
>>> would mean that we pretty much have to disable over half the features
>>> in the kernel.
>>>
>>> Take for example SATA NCQ (command queing) this is know to not work
>>> on some devices, up to the point of where with some buggy firmwares
>>> it may cause full systems hangs and/or data-corruption. So this is
>>> a much bigger problem then the "system won't suspend" issue we
>>> are talking about here. Still the ATA subsys maintainers have enabled
>>> this by default because it is an important feature to have and they
>>> are using a deny-list to avoid enabling this on known broken hardware;
>>> and yes every know and then we need to add a new model to the deny-list.
>>>
>>> And the same for SATA ALPM support (a power-management feature like 
>>> s0ix)
>>> that is enabled by default too, combined with a deny-list.
>>> I'm very familiar with the ALPM case since I pushed of it being
>>> enabled by default and I've done most of the maintenance work
>>> of the deny-list since it was enabled by default.
>>>
>>> The kernel is full of this pattern, we don't disable an important
>>> feature (and power-management is important) just because of this
>>> causing issues in "a few cases". And again you say "a few cases"
>>> but I know of 0 documented cases where this issue is still a problem
>>> after bumping the timeout.
>>
>> It all comes down to who owns the maintenance in those cases. That is
>> the heart of the issue.
>>
>> Last I knew Intel was maintaining the e1000e driver. So the decision
>> to support this or not is up to them unless Dave or Jakub want to
>> override. Basically the maintenance cost has to be assumed by whoever
>> decides what route to go. I guess Intel for now is opting to require
>> an allow-list rather than a deny-list for that reason. That way
>> whoever adds a new device is on the hook to verify it works, rather
>> than them having to fix things after something breaks.
>>
>>>>> Are you saying that you insist on keeping the e1000e_check_me check 
>>>>> and
>>>>> thus needlessly penalizing 100s of laptops models with higher
>>>>> power-consumption unless these 100s of laptops are added manually
>>>>> to an allow list for this?
>>>>>
>>>>> I'm sorry but that is simply unacceptable, the maintenance burden
>>>>> of that is just way too high.
>>>>
>>>> Think about this the other way though. If it is enabled and there are
>>>> cases where adding a delay doesn't resolve it then it still doesn't
>>>> really solve the issue does it?
>>>
>>> Again AFAIK that is a theoretical "If it ..." and even if it is not
>>> theoretical, then we can add a deny-list. Maintaining a deny list for
>>> "a few cases" being broken is a lot easier then maintaining an allow
>>> list for allother hardware out there.
>>>
>>> Let me put it this way, the allow-list will be orders of magnitude
>>> longer then the deny lists. Which list would you rather manually
>>> keep up2date?
>>
>> It all depends on the support model. An allow-list puts the onus on
>> the vendors to validate their parts before they have access to the
>> feature as we are seeing now from Dell. A deny-list would put the onus
>> on the community and Intel as we would have to find and document the
>> cases where this doesn't work. Ultimately it all comes down to who has
>> to do the work.
>>
>>>>> Testing on the models where the timeout issue was first hit has
>>>>> shown that increasing the timeout does actually fix it on those
>>>>> models. Sure in theory the ME on some buggy model could hold the
>>>>> semaphore even longer, but then the right thing would be to
>>>>> have a deny-list for s0ix where we can add those buggy models
>>>>> (none of which we have encountered sofar). Just like we have
>>>>> denylist for buggy hw in other places in the kernel.
>>>>
>>>> This would actually have a higher maintenance burden then just
>>>> disabling the feature. Having to individually test for and deny-list
>>>> every one-off system with this bad configuration would be a pretty
>>>> significant burden. That also implies somebody would have access to
>>>> such systems and that is not normally the case. Even Intel doesn't
>>>> have all possible systems that would include this NIC.
>>>>
>>>>> Maintaining an ever growing allow list for the *theoretical*
>>>>> case of encountering a model where things do not work with
>>>>> the increased timeout is not a workable and this not an
>>>>> acceptable solution.
>>>>
>>>> I'm not a fan of the allow-list either, but it is preferable to a
>>>> deny-list where you have to first trigger the bug before you realize
>>>> it is there.
>>>
>>> IIRC, if the bug is there the system does not suspend, and the e1000e
>>> driver logs an error that it is the culprit. So this is very easy to 
>>> spot /
>>> detect by end users when they hit it.
>>>
>>> Again the kernel is full of deny lists to disable some features
>>> on broken hardware, with sometimes hitting the buggy/broken hw
>>> scenario having much worse consequences. Yet this is how this is
>>> done everywhere.
>>>
>>> The e1000e driver really is not all that special that it should
>>> get an exception to how this is normally done.
>>
>> Actually allow-lists are not all that uncommon when it comes to the
>> network tree. The fact is there are a number of PHYs and the like that
>> are supported only by allow-list if I recall on the Intel parts.
>> Basically the model depends on the issue. If you want to be able to
>> test and verify something before you add support for it normally an
>> allow-list is the way to go.
>>
>>>> Ideally there should be another solution in which the ME
>>>> could somehow set a flag somewhere in the hardware to indicate that it
>>>> is alive and the driver could read that order to determine if the ME
>>>> is actually alive and can skip this workaround. Then this could all be
>>>> avoided and it can be safely assumed the system is working correctly.
>>>>
>>>>> The initial addition of the e1000e_check_me check instead
>>>>> of just going with the confirmed fix of bumping the timeout
>>>>> was already highly controversial and should IMHO never have
>>>>> been done.
>>>>
>>>> How big was the sample size for the "confirmed" fix? How many
>>>> different vendors were there within the mix? The problem is while it
>>>> may have worked for the case you encountered you cannot say with
>>>> certainty that it worked in all cases unless you had samples of all
>>>> the different hardware out there.
>>>>
>>>>> Combining this with an ever-growing allow-list on which every
>>>>> new laptop model needs to be added separately + a new
>>>>> "s0ix-enabled" ethertool flag, which existence is basically
>>>>> an admission that the allow-list approach is flawed goes
>>>>> from controversial to just plain not acceptable.
>>>>
>>>> I don't view this as problematic, however this is some overhead to it.
>>>> One thing I don't know is if anyone has looked at is if the issue only
>>>> applies to a few specific system vendors. Currently the allow-list is
>>>> based on the subdevice ID. One thing we could look at doing is
>>>> enabling it based on the subvendor ID in which case we could
>>>> allow-list in large swaths of hardware with certain trusted vendors.
>>>> The only issue is that it pulls in any future parts as well so it puts
>>>> the onus on that manufacturer to avoid misconfiguring things in the
>>>> future.
>>>
>>> If we go this route, we will likely get Dell, Lenovo (which had
>>> the issue without the increased timeout) and maybe HP on the
>>> allow-list, probably with a finer grained deny-list on top to
>>> opt out on some models from these vendors where things turn
>>> out to be buggy after all.
>>>
>>> This:
>>>
>>> 1. Still requires a deny-list on top (at least this is very likely)
>>> 2. Leaves users of all but the 3 big vendors in the cold which
>>> really is not a nice way to deal with this.
>>
>> Well the beauty about the kernel is that you are always welcome to
>> submit a patch and we can debate it. I know in the case of the Intel
>> 10G NIC there was a patch that added a module parameter for overriding
>> the PHY allow-list so that the NIC would try to enable whatever PHY
>> was connected to it. Perhaps you could submit a similar patch that
>> would allow your timer approach and add a warning indicating that if
>> you see PHY hangs the s0ix issue may be responsible.
>>
> Again, the ME/AMT system not POR on Linux. We can't guarantee smooth 
> working Linux platforms with ME.
> We will consult with our Architecture regards this approach 
> (ULP_CONFIG_DONE time out and privileged flag for S0ix) - I will reply 
> soon.
After internal discussion, our recommendations as follow:

1. The relevant timeout should be increased from 300ms to 1000ms 
regardless of anything else. We haven't interface with CSME. Despite 
this, we compared it to the Windows driver and decided to recommend an 
increased delay up to 1000ms. 
(https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/ 
- this is expected solve part of the problem)

2.Since S0ix is mainstream now and users expect the related power
consumption savings, the flow should be enabled by default
We don't want any lists for controlling how the feature should be
enabled/disabled.
There should be a controllable flag for enabling/disabling the S0ix 
flow, since this is the flow that introduced the inter-op problems with ME.

3.The flag must be persistent (keeping its value across reboots/Sx 
entries) and controllable at runtime, either by the OEM (during initial 
setup) or by a privileged user (admin).

> Thanks,
> Sasha
Thanks,
Sasha

