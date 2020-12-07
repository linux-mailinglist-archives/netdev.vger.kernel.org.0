Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FF82D120A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgLGN3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgLGN3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607347686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmWE4Di/SrsoSOSW6qXuYa1KIu/jIAKq7DifFwoMfwo=;
        b=N0/I6wDLkCxzcCJkR4DT7jdkre7pkeNqJg392xjed3ka14vPNoYlLSibdRYq20hnpxVRCE
        vdeZKadmObqQC2OCs7wFE86urFtQ2jzFjvCVWjKgW340hEnPrGRiU4F29wmJ6Hjs0oxVH7
        mRJ4N/82unWXAYLL0+zYFnbuGHrMZAA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-b-cVSJvZNHafRHv_4Z9wHQ-1; Mon, 07 Dec 2020 08:28:03 -0500
X-MC-Unique: b-cVSJvZNHafRHv_4Z9wHQ-1
Received: by mail-ej1-f72.google.com with SMTP id bm18so3826528ejb.6
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 05:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zmWE4Di/SrsoSOSW6qXuYa1KIu/jIAKq7DifFwoMfwo=;
        b=lb4uMzvkFGaRxE31NMXZWX61qO8Hbea5Zz6aE+3Humu3nWun+KboTnkBjTW08KMSbC
         nKAnMm2SnvRZZ9F7SL+GiDjGIR4tXQGv5Lb/ZdJDe6qGdttMYnvYq6IgYv5hfAzeF6xI
         N+jr+K/ofKo3g/98m4I/eD2ePkVufs/13INdNUTZcqQ2IjDGF/M7j7T6jU5bQayWCsb5
         6AoTmMBynEKdZ6H2hdv+KlA5DWuWtxWOP/pgS6EsSZvjzLfwA4rAY8P4zVRaDkyrJXXQ
         p75MHuL6bZAwq5ncEHCFv/G+4f32Ctr7r6R0OWh03h55USe2mZuV7HBdk7qwpWXeFYEI
         /jHA==
X-Gm-Message-State: AOAM531NuIwacBGa+DdrvIME+lRzAxxDkLCeqoBgHIQoS5vLR9bgWTyJ
        LejkG6YTZiGZOhJ42GddhDZW9XzNH109HcrSm+QOSdaE+eSp81zQ7W1FMxiUglDQhl3mqnplWyQ
        6cwjzVxndtSpo711w
X-Received: by 2002:a17:906:22c7:: with SMTP id q7mr18854666eja.486.1607347681960;
        Mon, 07 Dec 2020 05:28:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEorJ0sLId/xL9w8EuO0JL3r6cc0kBtMY1HiSGC5kejytn+C5L/ToMHIPmo2of6ILKDTvCoA==
X-Received: by 2002:a17:906:22c7:: with SMTP id q7mr18854658eja.486.1607347681764;
        Mon, 07 Dec 2020 05:28:01 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id oq27sm3461543ejb.108.2020.12.07.05.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 05:28:01 -0800 (PST)
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com
References: <20201204200920.133780-1-mario.limonciello@dell.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
Date:   Mon, 7 Dec 2020 14:28:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204200920.133780-1-mario.limonciello@dell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/4/20 9:09 PM, Mario Limonciello wrote:
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> with i219-LM controller.
> 
> Performing suspend to idle with these ethernet controllers requires a properly
> configured system.  To make enabling such systems easier, this patch
> series allows determining if enabled and turning on using ethtool.
> 
> The flows have also been confirmed to be configured correctly on Dell's Latitude
> and Precision CML systems containing the i219-LM controller, when the kernel also
> contains the fix for s0i3.2 entry previously submitted here and now part of this
> series.
> https://marc.info/?l=linux-netdev&m=160677194809564&w=2
> 
> Patches 4 through 7 will turn the behavior on by default for some of Dell's
> CML and TGL systems.

First of all thank you for working on this.

I must say though that I don't like the approach taken here very
much.

This is not so much a criticism of this series as it is a criticism
of the earlier decision to simply disable s0ix on all devices
with the i219-LM + and active ME.

AFAIK there was a perfectly acceptable patch to workaround those
broken devices, which increased a timeout:
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/

That patch was nacked because it increased the resume time
*on broken devices*.

So it seems to me that we have a simple choice here:

1. Longer resume time on devices with an improperly configured ME
2. Higher power-consumption on all non-buggy devices

Your patches 4-7 try to workaround 2. but IMHO those are just
bandaids for getting the initial priorities *very* wrong.

Instead of penalizing non-buggy devices with a higher power-consumption,
we should default to penalizing the buggy devices with a higher
resume time. And if it is decided that the higher resume time is
a worse problem then the higher power-consumption, then there
should be a list of broken devices and s0ix can be disabled on those.

The current allow-list approach is simply never going to work well
leading to too high power-consumption on countless devices.
This is going to be an endless game of whack-a-mole and as
such really is a bad idea.

A deny-list for broken devices is a much better approach, esp.
since missing devices on that list will still work fine, they
will just have a somewhat larger resume time.

So what needs to happen IMHO is:

1. Merge your fix from patch 1 of this set
2. Merge "e1000e: bump up timeout to wait when ME un-configure ULP mode"
3. Drop the e1000e_check_me check.

Then we also do not need the new "s0ix-enabled" ethertool flag
because we do not need userspace to work-around us doing the
wrong thing by default.

Note a while ago I had access to one of the devices having suspend/resume
issues caused by the S0ix support (a Lenovo Thinkpad X1 Carbon gen 7)
and I can confirm that the "e1000e: bump up timeout to wait when ME
un-configure ULP mode" patch fixes the suspend/resume problem without
any noticeable negative side-effects.

Regards,

Hans









> 
> Changes from v2 to v3:
>  - Correct some grammar and spelling issues caught by Bjorn H.
>    * s/s0ix/S0ix/ in all commit messages
>    * Fix a typo in commit message
>    * Fix capitalization of proper nouns
>  - Add more pre-release systems that pass
>  - Re-order the series to add systems only at the end of the series
>  - Add Fixes tag to a patch in series.
> 
> Changes from v1 to v2:
>  - Directly incorporate Vitaly's dependency patch in the series
>  - Split out s0ix code into it's own file
>  - Adjust from DMI matching to PCI subsystem vendor ID/device matching
>  - Remove module parameter and sysfs, use ethtool flag instead.
>  - Export s0ix flag to ethtool private flags
>  - Include more people and lists directly in this submission chain.
> 
> Mario Limonciello (6):
>   e1000e: Move all S0ix related code into its own source file
>   e1000e: Export S0ix flags to ethtool
>   e1000e: Add Dell's Comet Lake systems into S0ix heuristics
>   e1000e: Add more Dell CML systems into S0ix heuristics
>   e1000e: Add Dell TGL desktop systems into S0ix heuristics
>   e1000e: Add another Dell TGL notebook system into S0ix heuristics
> 
> Vitaly Lifshits (1):
>   e1000e: fix S0ix flow to allow S0i3.2 subset entry
> 
>  drivers/net/ethernet/intel/e1000e/Makefile  |   2 +-
>  drivers/net/ethernet/intel/e1000e/e1000.h   |   4 +
>  drivers/net/ethernet/intel/e1000e/ethtool.c |  40 +++
>  drivers/net/ethernet/intel/e1000e/netdev.c  | 272 +----------------
>  drivers/net/ethernet/intel/e1000e/s0ix.c    | 311 ++++++++++++++++++++
>  5 files changed, 361 insertions(+), 268 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/e1000e/s0ix.c
> 
> --
> 2.25.1
> 
> 

