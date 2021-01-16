Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8292F8A93
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbhAPBtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAPBtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:49:50 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A8C061757;
        Fri, 15 Jan 2021 17:49:10 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y19so21875261iov.2;
        Fri, 15 Jan 2021 17:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1zayavVbq3iSvACkTO58+KKKj1sT8Ehi03im+U3oD4=;
        b=WBcpXeLugtpr+//TrkyJXRabUizzZBQOo616BFNftjSreHlFQ7FWr0i6QJr2Vq3LG2
         eE0/UHrkuaL4h5GqdtJb5PxTw5eYxWKOLH2fhMR80+Kem2vwwQtrf8LFlTsA0ws2AhFT
         oumb0yz4aABME2XpyDfqK+bPUyhIBEVoY/vdLG9jO0M2uye9ETlOD2m50w180jNOp7K4
         uVCx3LwcK71A1jS2c0oQMvrMV6ipUHcnXWBwTz3sDv32cl7ix7oXcM4gnvkIQAxoRHEe
         mYzxjcER1Q5Q8Mn6Eq6jyt1J6k+/xHmi8hf7YGrXyV1EiU0ObI3M7FAl7ag+0nVeRA3F
         Yztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1zayavVbq3iSvACkTO58+KKKj1sT8Ehi03im+U3oD4=;
        b=D05iCYAVBkgsLzbjmcL1bsqs4W0pv2CY7ZDwEVzA0R5aslRp1BA+4IA4Hcs6S2JkPB
         kEkvQOAO5bRmm1xc3zz/jajBgsSgr6JARbpLBYonoRiyhk4yrgPuutZz3fCXxLHIgP4L
         5a0La42Xd5HladNEuHh+hwrRwBfcpMWcfzu7FM4/Pnnn0GmjivEFu/sh7SBxYZklie0P
         a4P+1BKUHR4QuRPfsJx4zC7WqS8BdiE5Dzba/BY7ghoVYFwKVPzOCwbVGNd46HPfj59o
         QGiOAgnu7oVuAVO/yTsXYMGm+yFxorI8EXVPUYykr7AK2BxhWFuDrJkNO7qoLIOmWKyU
         /kQQ==
X-Gm-Message-State: AOAM532u0RhuQ4H/hF1bPq9EyNWuKRJHqDGjYwzz+PdbyfEFVR92oejh
        GIexlem6S0WFYcW0pIGTkSXg15qCS7XNSWatGas=
X-Google-Smtp-Source: ABdhPJzPuWKa8CROW09mvJiMzdIhR9hAclb6kAx390J4xb899mBK6aAC1FIT9wvSIf9Qfzf/ZwyPE9QKYyF9vb7Sot4=
X-Received: by 2002:a05:6e02:68b:: with SMTP id o11mr13313974ils.237.1610761749939;
 Fri, 15 Jan 2021 17:49:09 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com> <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com> <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com> <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org> <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com> <20210115155315.GJ944463@unreal>
In-Reply-To: <20210115155315.GJ944463@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 17:48:59 -0800
Message-ID: <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
> >
> > > That said, it only works at the driver level. So if the firmware is
> > > the one that is having to do this it also occured to me that if this
> > > update happened on FLR that would probably be preferred.
> >
> > FLR is not free, I'd prefer not to require it just for some
> > philosophical reason.
> >
> > > Since the mlx5 already supports devlink I don't see any reason why the
> > > driver couldn't be extended to also support the devlink resource
> > > interface and apply it to interrupts.
> >
> > So you are OK with the PF changing the VF as long as it is devlink not
> > sysfs? Seems rather arbitary?
> >
> > Leon knows best, but if I recall devlink becomes wonky when the VF
> > driver doesn't provide a devlink instance. How does it do reload of a
> > VF then?
> >
> > I think you end up with essentially the same logic as presented here
> > with sysfs.
>
> The reasons why I decided to go with sysfs are:
> 1. This MSI-X table size change is applicable to ALL devices in the world,
> and not only netdev.

In the PCI world MSI-X table size is a read only value. That is why I
am pushing back on this as a PCI interface.

> 2. This is purely PCI field and apply equally with same logic to all
> subsystems and not to netdev only.

Again, calling this "purely PCI" is the sort of wording that has me
concerned. I would prefer it if we avoid that wording. There is much
more to this than just modifying the table size field. The firmware is
having to shift resources between devices and this potentially has an
effect on the entire part, not just one VF.

> 3. The sysfs interface is the standard way of configuring PCI/core, not
> devlink.

This isn't PCI core that is being configured. It is the firmware for
the device. You are working with resources that are shared between
multiple functions.

> 4. This is how orchestration software provisioning VFs already. It fits
> real world usage of SR-IOV, not the artificial one that is proposed during
> the discussion.

What do you mean this is how they are doing it already? Do you have
something out-of-tree and that is why you are fighting to keep the
sysfs? If so that isn't a valid argument.

> So the idea to use devlink just because mlx5 supports it, sound really
> wrong to me. If it was other driver from another subsystem without
> devlink support, the request to use devlink won't never come.
>
> Thanks

I am suggesting the devlink resources interface because it would be a
VERY good fit for something like this. By the definition of it:
``devlink`` provides the ability for drivers to register resources, which
can allow administrators to see the device restrictions for a given
resource, as well as how much of the given resource is currently
in use. Additionally, these resources can optionally have configurable size.
This could enable the administrator to limit the number of resources that
are used.

Even looking over the example usage I don't see there being much to
prevent you from applying it to this issue. In addition it has the
idea of handling changes that cannot be immediately applied already
included. Your current solution doesn't have a good way of handling
that and instead just aborts with an error.
