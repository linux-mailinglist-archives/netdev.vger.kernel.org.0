Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17C2D2F3D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgLHQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgLHQPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 11:15:51 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF21C0613D6;
        Tue,  8 Dec 2020 08:15:11 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id d9so8829789iob.6;
        Tue, 08 Dec 2020 08:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oLW8xGxoanWIpJZovz5czICr17i3LTPEQIdqGA3O2h0=;
        b=CrdkV8rVgDKbU+JWugnZu/ASTWkgGuftLg+bo5Y6wrvT9CZAL7f/Ib+cmCyVw6n9SJ
         oWm9XKNEBDhWdBKlz/9tIIVY7jkM0EU446Hl2B2pgz+tdXjPkEuMpEEVP3+09EsGrhFy
         39b3VWPxG08coduB0bDMIJ9QeYmgs0kkoHt2pKY4IDUvgsXTDB7usxHxluT+1BAXTMM+
         H/EIy6prqc9OFu6LQwGoMeuH/xsCiph6igRly3nhzc5RzWaK+cS0zsgyA1NApO9F4KLy
         3lrB4KJNmn/ORSK/xKYgtqRwlGRp5JhRe52UKnTbjX73D462/HnflLGHP/Xw3vVLrFlf
         8Vqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oLW8xGxoanWIpJZovz5czICr17i3LTPEQIdqGA3O2h0=;
        b=bMGOWkKZhPgW/nW9yYPVDAz8xnN7g7AQ39BVxQ9snFKnMfE7x1umMTGbpDG58VKCcJ
         J0gLjexKcYCic+6kKpXRiPQ/ttHVS3RKeK2eh1nCnW1nk5drnjkqWCyYlKd4qb9mR2H+
         3yDBIiJHf6VAw5Qo5Ue1c0rHvpxHQZar7oJvFo946pK0tzXprj+dA54Y9PTUkP41D21L
         CcgloOKt5EkdWkliJh/iJcOG1Vwk1vC0zmu8TXP5jEONAGnt9GdLCUtlj4Nhl2aQBg83
         rju/AGTzEJYipFvh9hQpiEIYw0dF6BZsDqppLShHhxIHJHI7iy2hDb44mo/2uJDGBVVl
         PsTg==
X-Gm-Message-State: AOAM53113vo/orrwk9Aft1huWAjxJsaByL39qtY0HzNESntpyshx75lQ
        URks+b8KxbEjYpu5Scr3jO6OmbQKmXBcyXXrsZU=
X-Google-Smtp-Source: ABdhPJxXeSbNnS0AeBgABRYL8Vmru53bsBrzbyhq87wFdTsv9q/V2oexnDeIfcYrjPz5NCgFr4xpx2rWyu1scvDIowQ=
X-Received: by 2002:a5d:8344:: with SMTP id q4mr25183113ior.38.1607444110138;
 Tue, 08 Dec 2020 08:15:10 -0800 (PST)
MIME-Version: 1.0
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com> <DM6PR19MB2636A4097B68DBB253C416D8FACE0@DM6PR19MB2636.namprd19.prod.outlook.com>
 <383daf0d-8a9b-c614-aded-6e816f530dcd@intel.com> <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
In-Reply-To: <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 8 Dec 2020 08:14:58 -0800
Message-ID: <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Hans de Goede <hdegoede@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 1:30 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 12/8/20 6:08 AM, Neftin, Sasha wrote:
> > On 12/7/2020 17:41, Limonciello, Mario wrote:
> >>> First of all thank you for working on this.
> >>>
> >>> I must say though that I don't like the approach taken here very
> >>> much.
> >>>
> >>> This is not so much a criticism of this series as it is a criticism
> >>> of the earlier decision to simply disable s0ix on all devices
> >>> with the i219-LM + and active ME.
> >>
> >> I was not happy with that decision either as it did cause regressions
> >> on all of the "named" Comet Lake laptops that were in the market at
> >> the time.  The "unnamed" ones are not yet released, and I don't feel
> >> it's fair to call it a regression on "unreleased" hardware.
> >>
> >>>
> >>> AFAIK there was a perfectly acceptable patch to workaround those
> >>> broken devices, which increased a timeout:
> >>> https://patchwork.ozlabs.org/project/intel-wired-
> >>> lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
> >>>
> >>> That patch was nacked because it increased the resume time
> >>> *on broken devices*.
> >>>
> > Officially CSME/ME not POR for Linux and we haven't interface to the ME=
. Nobody can tell how long (and why) ME will hold PHY access semaphore ant =
just increasing the resuming time (ULP configure) won't be solve the proble=
m. This is not reliable approach.
> > I would agree users can add ME system on their responsibilities.
>
> It is not clear to me what you are trying to say here.

Based on the earlier thread you had referenced and his comment here it
sounds like while adding time will work for most cases, it doesn't
solve it for all cases. The problem is as a vendor you are usually
stuck looking for a solution that will work for all cases which can
lead to things like having to drop features because they can be
problematic for a few cases.

> Are you saying that you insist on keeping the e1000e_check_me check and
> thus needlessly penalizing 100s of laptops models with higher
> power-consumption unless these 100s of laptops are added manually
> to an allow list for this?
>
> I'm sorry but that is simply unacceptable, the maintenance burden
> of that is just way too high.

Think about this the other way though. If it is enabled and there are
cases where adding a delay doesn't resolve it then it still doesn't
really solve the issue does it?

> Testing on the models where the timeout issue was first hit has
> shown that increasing the timeout does actually fix it on those
> models. Sure in theory the ME on some buggy model could hold the
> semaphore even longer, but then the right thing would be to
> have a deny-list for s0ix where we can add those buggy models
> (none of which we have encountered sofar). Just like we have
> denylist for buggy hw in other places in the kernel.

This would actually have a higher maintenance burden then just
disabling the feature. Having to individually test for and deny-list
every one-off system with this bad configuration would be a pretty
significant burden. That also implies somebody would have access to
such systems and that is not normally the case. Even Intel doesn't
have all possible systems that would include this NIC.

> Maintaining an ever growing allow list for the *theoretical*
> case of encountering a model where things do not work with
> the increased timeout is not a workable and this not an
> acceptable solution.

I'm not a fan of the allow-list either, but it is preferable to a
deny-list where you have to first trigger the bug before you realize
it is there. Ideally there should be another solution in which the ME
could somehow set a flag somewhere in the hardware to indicate that it
is alive and the driver could read that order to determine if the ME
is actually alive and can skip this workaround. Then this could all be
avoided and it can be safely assumed the system is working correctly.

> The initial addition of the e1000e_check_me check instead
> of just going with the confirmed fix of bumping the timeout
> was already highly controversial and should IMHO never have
> been done.

How big was the sample size for the "confirmed" fix? How many
different vendors were there within the mix? The problem is while it
may have worked for the case you encountered you cannot say with
certainty that it worked in all cases unless you had samples of all
the different hardware out there.

> Combining this with an ever-growing allow-list on which every
> new laptop model needs to be added separately + a new
> "s0ix-enabled" ethertool flag, which existence is basically
> an admission that the allow-list approach is flawed goes
> from controversial to just plain not acceptable.

I don't view this as problematic, however this is some overhead to it.
One thing I don't know is if anyone has looked at is if the issue only
applies to a few specific system vendors. Currently the allow-list is
based on the subdevice ID. One thing we could look at doing is
enabling it based on the subvendor ID in which case we could
allow-list in large swaths of hardware with certain trusted vendors.
The only issue is that it pulls in any future parts as well so it puts
the onus on that manufacturer to avoid misconfiguring things in the
future.
