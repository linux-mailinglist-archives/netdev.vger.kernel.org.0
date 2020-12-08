Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B332D27BB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLHJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:32:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727728AbgLHJcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607419846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4gXzSaav/qWw7+pF0tiVYim8F4nDRvOBt7xLk8iti0=;
        b=B3JlMVQdg4JcMiRBfzUloauBhnv0aXjY+7X2col9lo6nG8kf8tsP/s7MHHvsDEgFJFi/Zf
        7LU/idTKsHasmCNP0N++xLk9X+2Lc6dgzf5MNye4OVb8hBnomysj5FPWsBeWWS1V51MZC+
        NHjk13zTYz6m0+rEhmMN8tFyXsyg4OU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-XJrcpKe1Nym5n_CTOsFzwQ-1; Tue, 08 Dec 2020 04:30:41 -0500
X-MC-Unique: XJrcpKe1Nym5n_CTOsFzwQ-1
Received: by mail-ej1-f71.google.com with SMTP id u10so4942122ejy.18
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 01:30:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4gXzSaav/qWw7+pF0tiVYim8F4nDRvOBt7xLk8iti0=;
        b=sWK3mbFytirp534PpcjGkgZbZNYj0muxPAWU+GcWgzHDLPZcYErOPxCBSFFBfZPdn3
         R5bPG0BGF4DAV8svJ2wGdxNZbLEtfNS5VyJopEXlbcGN3CYD4BnqPu6ApHjltyZVOfL/
         cBsBve2CuBI0eAoBcZPXk4qKZiFWmy/pTt36/7F7QwZcK1RPU8pCW+4KM52jBzd0hvtr
         E8iKz0P7oIl2nNdKG1hTAk4nrDT3oSA3xlENyfSLW9ZCh1VS2hWays8pbujdiTu3PxKr
         hVPWfUWWV1C0IpvrHnR/FF16xxMWK1XBKoGo12+UVjKyEAbd/3tzYeMaQlDvtjl5kGpy
         WJWg==
X-Gm-Message-State: AOAM531fw816YY24qODqGXvp94Ysxk++I36a5HQrcwSHvd+mFHrh3fi3
        8y5JybhVsRm6e7Nmol4hGAkwY4KfDBdDE/XZuOBWi1p/toPqfxyjiT/hyBqoG1pb5GIPg/AxTZF
        2KmKW3XxBFLQZP9IM
X-Received: by 2002:a05:6402:129a:: with SMTP id w26mr12249071edv.355.1607419839739;
        Tue, 08 Dec 2020 01:30:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPKIXmBZ1ZbQcKGouDIjTXKfUkjZFARJoSi8+5Q0SNiCV6dUdwOJYdxdocwTQkErwDPiZ64A==
X-Received: by 2002:a05:6402:129a:: with SMTP id w26mr12249042edv.355.1607419839407;
        Tue, 08 Dec 2020 01:30:39 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id b7sm15310139ejp.5.2020.12.08.01.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:30:38 -0800 (PST)
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
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
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
Date:   Tue, 8 Dec 2020 10:30:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <383daf0d-8a9b-c614-aded-6e816f530dcd@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/8/20 6:08 AM, Neftin, Sasha wrote:
> On 12/7/2020 17:41, Limonciello, Mario wrote:
>>> First of all thank you for working on this.
>>>
>>> I must say though that I don't like the approach taken here very
>>> much.
>>>
>>> This is not so much a criticism of this series as it is a criticism
>>> of the earlier decision to simply disable s0ix on all devices
>>> with the i219-LM + and active ME.
>>
>> I was not happy with that decision either as it did cause regressions
>> on all of the "named" Comet Lake laptops that were in the market at
>> the time.  The "unnamed" ones are not yet released, and I don't feel
>> it's fair to call it a regression on "unreleased" hardware.
>>
>>>
>>> AFAIK there was a perfectly acceptable patch to workaround those
>>> broken devices, which increased a timeout:
>>> https://patchwork.ozlabs.org/project/intel-wired-
>>> lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
>>>
>>> That patch was nacked because it increased the resume time
>>> *on broken devices*.
>>>
> Officially CSME/ME not POR for Linux and we haven't interfrace to the ME. Nobody can tell how long (and why) ME will hold PHY access semaphore ant just increasing the resuming time (ULP configure) won't be solve the problem. This is not reliable approach.
> I would agree users can add ME system on their responsibilities.

It is not clear to me what you are trying to say here.

Are you saying that you insist on keeping the e1000e_check_me check and
thus needlessly penalizing 100s of laptops models with higher
power-consumption unless these 100s of laptops are added manually
to an allow list for this?

I'm sorry but that is simply unacceptable, the maintenance burden
of that is just way too high.

Testing on the models where the timeout issue was first hit has
shown that increasing the timeout does actually fix it on those
models. Sure in theory the ME on some buggy model could hold the
semaphore even longer, but then the right thing would be to
have a deny-list for s0ix where we can add those buggy models
(none of which we have encountered sofar). Just like we have
denylist for buggy hw in other places in the kernel.

Maintaining an ever growing allow list for the *theoretical*
case of encountering a model where things do not work with
the increased timeout is not a workable and this not an
acceptable solution.

The initial addition of the e1000e_check_me check instead
of just going with the confirmed fix of bumping the timeout
was already highly controversial and should IMHO never have
been done.

Combining this with an ever-growing allow-list on which every
new laptop model needs to be added separately + a new
"s0ix-enabled" ethertool flag, which existence is basically
an admission that the allow-list approach is flawed goes
from controversial to just plain not acceptable.

Regards,

Hans



>>> So it seems to me that we have a simple choice here:
>>>
>>> 1. Longer resume time on devices with an improperly configured ME
>>> 2. Higher power-consumption on all non-buggy devices
>>>
>>> Your patches 4-7 try to workaround 2. but IMHO those are just
>>> bandaids for getting the initial priorities *very* wrong.
>>
>> They were done based upon the discussion in that thread you linked and others.
>> If the owners of this driver feel it's possible/scalable to follow your proposal
>> I'm happy to resubmit a new v4 series with these sets of patches:
>>
>> 1) Fixup for the exception corner case referenced in this thread
>> 2) Patch 1 from this series that fixes cable connected case
>> 3) Increase the timeout (from your referenced link)
>> 4) Revert the ME disallow list
>>
>>>
>>> Instead of penalizing non-buggy devices with a higher power-consumption,
>>> we should default to penalizing the buggy devices with a higher
>>> resume time. And if it is decided that the higher resume time is
>>> a worse problem then the higher power-consumption, then there
>>> should be a list of broken devices and s0ix can be disabled on those.
>>
>> I'm perfectly happy either way, my primary goal is that Dell's notebooks and
>> desktops that meet the architectural and firmware guidelines for appropriate
>> low power consumption over s0ix are not penalized.
>>
>>>
>>> The current allow-list approach is simply never going to work well
>>> leading to too high power-consumption on countless devices.
>>> This is going to be an endless game of whack-a-mole and as
>>> such really is a bad idea.
>>
>> I envisioned that it would evolve over time.  For example if by the time Dell
>> finished shipping new CML models it was deemed that all the CML hardware was done
>> properly it could instead by an allow list of Dell + Comet Point.
>> If all of Tiger Lake are done properly 'maybe' by the time the ML ships maybe it
>> could be an allow list of Dell + CML or newer.
>>
>> But even if the heuristic changed - this particular configuration needs to be tested
>> on every single new model.  All of the notebooks that have a Tested-By clause were
>> checked by Dell and Dell's partners.
>>
>>>
>>> A deny-list for broken devices is a much better approach, esp.
>>> since missing devices on that list will still work fine, they
>>> will just have a somewhat larger resume time.
>>
>> I don't have configuration deemed buggy.  Since you were commenting in that other
>> thread with the patch from Aaaron It sounds like you do. Can you perhaps check if
>> that proposal actually works?
>>
>>>
>>> So what needs to happen IMHO is:
>>>
>>> 1. Merge your fix from patch 1 of this set
>>> 2. Merge "e1000e: bump up timeout to wait when ME un-configure ULP mode"
>>> 3. Drop the e1000e_check_me check.
>>>
>>> Then we also do not need the new "s0ix-enabled" ethertool flag
>>> because we do not need userspace to work-around us doing the
>>> wrong thing by default.
>>
>> If we collectively agree to keep either an allow list "or" disallow list at
>> all I think you need a way check whether enabling this feature works.
>>
>> If we are making an assertion it will always work properly all the time, I agree
>> that there is no need for an ethtool flag.
>>
>>>
>>> Note a while ago I had access to one of the devices having suspend/resume
>>> issues caused by the S0ix support (a Lenovo Thinkpad X1 Carbon gen 7)
>>> and I can confirm that the "e1000e: bump up timeout to wait when ME
>>> un-configure ULP mode" patch fixes the suspend/resume problem without
>>> any noticeable negative side-effects.
>>>
>>
>> Can you or someone else with this model please check with a current kernel
>> w/ reverting ME check and adding the patch from Vitaly (included as patch 1
>> in my series)?
>>
>>> Regards,
>>>
>>> Hans
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>>
>>>> Changes from v2 to v3:
>>>>   - Correct some grammar and spelling issues caught by Bjorn H.
>>>>     * s/s0ix/S0ix/ in all commit messages
>>>>     * Fix a typo in commit message
>>>>     * Fix capitalization of proper nouns
>>>>   - Add more pre-release systems that pass
>>>>   - Re-order the series to add systems only at the end of the series
>>>>   - Add Fixes tag to a patch in series.
>>>>
>>>> Changes from v1 to v2:
>>>>   - Directly incorporate Vitaly's dependency patch in the series
>>>>   - Split out s0ix code into it's own file
>>>>   - Adjust from DMI matching to PCI subsystem vendor ID/device matching
>>>>   - Remove module parameter and sysfs, use ethtool flag instead.
>>>>   - Export s0ix flag to ethtool private flags
>>>>   - Include more people and lists directly in this submission chain.
>>>>
>>>> Mario Limonciello (6):
>>>>    e1000e: Move all S0ix related code into its own source file
>>>>    e1000e: Export S0ix flags to ethtool
>>>>    e1000e: Add Dell's Comet Lake systems into S0ix heuristics
>>>>    e1000e: Add more Dell CML systems into S0ix heuristics
>>>>    e1000e: Add Dell TGL desktop systems into S0ix heuristics
>>>>    e1000e: Add another Dell TGL notebook system into S0ix heuristics
>>>>
>>>> Vitaly Lifshits (1):
>>>>    e1000e: fix S0ix flow to allow S0i3.2 subset entry
>>>>
>>>>   drivers/net/ethernet/intel/e1000e/Makefile  |   2 +-
>>>>   drivers/net/ethernet/intel/e1000e/e1000.h   |   4 +
>>>>   drivers/net/ethernet/intel/e1000e/ethtool.c |  40 +++
>>>>   drivers/net/ethernet/intel/e1000e/netdev.c  | 272 +----------------
>>>>   drivers/net/ethernet/intel/e1000e/s0ix.c    | 311 ++++++++++++++++++++
>>>>   5 files changed, 361 insertions(+), 268 deletions(-)
>>>>   create mode 100644 drivers/net/ethernet/intel/e1000e/s0ix.c
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>>>
>>
> Thanks,
> Sasha
> 

