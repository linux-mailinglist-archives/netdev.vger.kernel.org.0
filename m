Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79E22C9104
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgK3W0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgK3W0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:26:44 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9D6C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:26:04 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z10so4490297ilu.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nqwqy2DjALPMDgNpJpApjzEY7RyuK2fjobHyr1NAVk=;
        b=s9MXKiRzBoh2LuE4txOQple+sNs6PmMX5D0oQf+OC6ow07q+fvJ5VL7TlHIViuhwA5
         eGcmgieGuPWTYsLkONJ9p4vnPvCkv9WmzY07BrvjV8cGtI++kqKg6NeLFEUKknl/bC6W
         WGATRoH10InGRFCXBytOz+qPFf4jOJ1YVRc9HeTPm21e9U5b+iW1V2zDDiUqUpSVaIDe
         tAwBol/wTHJcQGEvZIBuJPUBzcf6GqfNBAHmiy43DAfe0N6SB2aFbtYYUmimKSJTGSbe
         OcLE96lP5mNsNffTsbuSMKcoHgyu4kqxjJ4tpoCpJezVj+pwyyFd31tQ3fsXYA24Nu+A
         Chgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nqwqy2DjALPMDgNpJpApjzEY7RyuK2fjobHyr1NAVk=;
        b=qTxu/kCkSt5f2PBLcgEJzcYiC4grvWvUIlPVwoFbjk9+9nHJOCD+yUaypfV/Ef2aHP
         34Ujw4/+Gka0zvjNdNlLZUY5d9O5LRkeKUdgj5kQoC3r3OJLgE9+PAWOumv5Fo29M7KO
         etzvly2Z9gkFgvjXH0L09D8J3mH7Sw2Ec24ItKQB7CoGXTvxNI2+qoMAMCgFnM8En7fC
         PJNutma+Rl+kUDxucktXnxX7zbRaj5MtNDHRlLfSyIw7r3HgQmsCCpMNSPv47Cl0tARw
         QPhOy0d+4UoeaCAYrXqRwec9wTgAAlPAOl93cR5lE+LcnwmBOg3DEi9XAh7DNXdXU9oy
         vUwg==
X-Gm-Message-State: AOAM530DUCnMbRDlSwmObfgMVD8MYUsGIJ+7xidA3JfK8hqEhIbXdrTQ
        tesJnsExExUQKUUI3hWikrtPbJY/mD3AJdvrB+4=
X-Google-Smtp-Source: ABdhPJyR7djbVrSqsyJq6DWGcXdR/CKLoS8rjVvTDPV4H/pL+0Vrt+yzvLN8yDtvaxQRYspWHid9hLd6eCKzsYO9QE0=
X-Received: by 2002:a92:730d:: with SMTP id o13mr19777208ilc.95.1606775163749;
 Mon, 30 Nov 2020 14:26:03 -0800 (PST)
MIME-Version: 1.0
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
 <20201130212907.320677-2-anthony.l.nguyen@intel.com> <CAKgT0Uf7BoQ5DAWD8V7vhRZfRZCEBxc_X4Wn35mYEvMPSq-EaQ@mail.gmail.com>
 <DM6PR19MB263628DAC7F032E575C5E5EAFAF50@DM6PR19MB2636.namprd19.prod.outlook.com>
In-Reply-To: <DM6PR19MB263628DAC7F032E575C5E5EAFAF50@DM6PR19MB2636.namprd19.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Nov 2020 14:25:52 -0800
Message-ID: <CAKgT0UedAJbhh5dA5V+otzXe2Hn3VZ44+=DGEtNWjA5R3sDBug@mail.gmail.com>
Subject: Re: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 2:16 PM Limonciello, Mario
<Mario.Limonciello@dell.com> wrote:
>
> >
> > Generally the use of module parameters and sysfs usage are frowned
> > upon.
>
> I was trying to build on the existing module parameters that existed
> already for e1000e.  So I guess I would ask, why are those not done in
> ethtool?  Should those parameters go away and they migrate to ethtool
> for the same reasons as this?

What it comes down to is that the existing module parameters are
grandfathered in and we should not break things by removing them. New
drivers aren't allowed to add them, and we are not supposed to add to
them.

> > Based on the configuration isn't this something that could just
> > be controlled via an ethtool priv flag? Couldn't you just have this
> > default to whatever the heuristics decide at probe on and then support
> > enabling/disabling it via the priv flag? You could look at
> > igb_get_priv_flags/igb_set_priv_flags for an example of how to do what
> > I am proposing.
>
> I don't disagree this solution would work, but it adds a new dependency
> on having ethtool and the kernel move together to enable it.

Actually ethtool wouldn't have to change. The priv-flags are passed as
strings to ethtool from the driver and set as a u32 bit flag array if
I recall correctly.

> One advantage of the way this is done it allows shipping a system with an
> older Linux kernel that isn't yet recognized in the kernel heuristics to
> turn on by default with a small udev rule or kernel command line change.
>
> For example systems that aren't yet released could have this documented on
> RHEL certification pages at release time for older RHEL releases before a
> patch to add to the heuristics has been backported.

I suggest taking a look at the priv-flags interface. I am not
suggesting adding a new interface to ethtool. It is an existing
interface designed to allow for one-off features to be
enabled/disabled on a given port.

> >
> > I think it would simplify this quite a bit since you wouldn't have to
> > implement sysfs show/store operations for the value and would instead
> > be allowing for reading/setting via the get_priv_flags/set_priv_flags
> > operations. In addition you could leave the code for checking what
> > supports this in place and have it set a flag that can be read or
> > overwritten.
>
> If the consensus is to move in this direction, yes I'll redo the patch
> series and modify ethtool as well.

No changes needed to ethtool. The flags are driver specific which is
why this would work, or are you saying this change will be needed for
other drivers? If so then yes I would recommend coming up with a
standard interface we can use for those drivers as well.
