Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E4A2F8B40
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbhAPEdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbhAPEdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:33:38 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09811C061798;
        Fri, 15 Jan 2021 20:32:31 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id u17so22352321iow.1;
        Fri, 15 Jan 2021 20:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJ2p9Ww5rd/yhMfWY5ZWGoQK8wMPRFoNHSmKhGOMcVI=;
        b=kmlmIVagRPI+Qb/uDh4n7FNosnYBVV1ClrERDGx7EDOMJudxmJV1gq/N+9ZppOWgdp
         dpySx0LARDT/HgIwDz0wlmTdLkYgIsU+9n2dyYu+ezM9uy5erP+3S0RogMtFvCdjj5Wj
         6FU8F5ESDdQU2xrjnaMf/y3yngeXxqUCopZQgNG/yYw8b80SbSaocDhvhMx8sM63mi8L
         qyMWcsJBV+vINF7XDSZiYqNEfy1CVpbRdcQBB0qceC+S9G0DSPG51pGMPzTrUFaSIcJr
         3ZUYqdT85Yj95R2Wq4QNNNmxazPrxWFnqnHvPjmpaX1mPNbIl8cRKmyy6aLbW/sTwsCP
         NgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJ2p9Ww5rd/yhMfWY5ZWGoQK8wMPRFoNHSmKhGOMcVI=;
        b=EKLJWmI4psuIzU1I9WV3hIv1Lpfsuz4QIqNib2XUaunjkjl/H/YDly6oXx8XEfYIMG
         sG6FQ5vyp3Xq967jekVlTh5WqguEaR4BHHv2qSI5RjnTvJCFMWiB8LCOG6CVQT3nwUok
         7S9KTTu+oNKXJSdG5AXy9JZ/ZMBEHM/jenpVSphgFb0fMc1Q/VK5HuxqcVMJmCZnD41f
         fr19TA2ct0Vxqfp6MQ1CO2WMEkYnhBu+ddo1+he/YjQP7MXCaRsDSboiwW5Nm7ewWU08
         ZvH2aLXBiC6mX0zSnCQGslOpYT+ogTVPMlLtPeKojWJXa27fgL2k0uplKcdQ6I+CbM4Y
         26TQ==
X-Gm-Message-State: AOAM531qB7DFwyLLbQgShqoaUGnUrlLoOIlXZBN9lJddy+dU5BM5C3O8
        z22HWtmX8KSAgMO4Kcfcv8ht5zcUekYoBEBrmi1RUVd8EXQ=
X-Google-Smtp-Source: ABdhPJxb7fh0nwxA2y9YCqKrj+uTLePU8bhkb6SiUVarA5atGkrZzd0kohK6AyhZBseiryf2KchIX45Jn+h3Fc9BYZE=
X-Received: by 2002:a02:b38f:: with SMTP id p15mr3632651jan.83.1610771550239;
 Fri, 15 Jan 2021 20:32:30 -0800 (PST)
MIME-Version: 1.0
References: <20210114065024.GK4678@unreal> <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com> <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com> <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com> <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org> <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
In-Reply-To: <20210115140619.GA4147@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 20:32:19 -0800
Message-ID: <CAKgT0UfAoGXQp9C0uL124GZfdhY6vvpk3NmCDqCpLET9dzAdRg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
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

On Fri, Jan 15, 2021 at 6:06 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
>
> > That said, it only works at the driver level. So if the firmware is
> > the one that is having to do this it also occured to me that if this
> > update happened on FLR that would probably be preferred.
>
> FLR is not free, I'd prefer not to require it just for some
> philosophical reason.

It wasn't so much a philosophical thing as the fact that it can sort
of take the place as a reload. Essentially with an FLR we are
rewriting the configuration so if the driver were involved it would be
a good time to pull in the MSI-X table update. However looking over
the mlx5 code I don't see any handling of FLR in there so I am
assuming that is handled by the firmware.

> > Since the mlx5 already supports devlink I don't see any reason why the
> > driver couldn't be extended to also support the devlink resource
> > interface and apply it to interrupts.
>
> So you are OK with the PF changing the VF as long as it is devlink not
> sysfs? Seems rather arbitary?

It is about the setup of things. The sysfs existing in the VF is kind
of ugly since it is a child device calling up to the parent and
telling it how it is supposed to be configured. I'm sure in theory we
could probably even have the VF request something like that itself
through some sort of mailbox and cut out the middle-man but that would
be even uglier.

If you take a look at the usage of pci_physfn it is usually in spots
where the PF is being looked for in order to find the policy that is
supposed to be applied to the VF. This is one of the first few cases
where it is being used to set the policy for the VF.

> Leon knows best, but if I recall devlink becomes wonky when the VF
> driver doesn't provide a devlink instance. How does it do reload of a
> VF then?

In my mind it was the PF driver providing a devlink instance for the
VF if a driver isn't loaded. Then if the mlx5 driver was loaded on the
VF you would replace that instance with one supported by the VF itself
in order to coordinate with the VF driver. That way if the mlx5 driver
is loaded on the VF you can still change the settings instead of being
blocked by your own driver.

As far as a reload the non-driver loaded case would probably look a
lot like how things are handled now with the taking of the device
lock, verifying no driver is loaded, notifying the firmware, and
releasing the lock when it is complete. If the mlx5 driver is loaded
on the VF it could be a more complete setup that would probably look
more like your standard driver reinit.

> I think you end up with essentially the same logic as presented here
> with sysfs.

It is similar, however the big difference is how the control is setup.
With the VF sysfs file running things it feels sort of like the tail
wagging the dog. You are having to go through and verify that this is
a VF, that the PF is present, that the PF supports this operation and
so on. If the PF is in charge of managing the configuration it should
be the one registering the interfaces, not the VF. That is my view on
this anyway as I feel it simplifies this quite a bit as the interface
won't be there if it isn't supported.:

> > > It is possible for vfio to fake the MSI-X capability and limit what a
> > > user can access, but I don't think that's what is being done here.
> >
> > Yeah, I am assuming that is what is being done here.
>
> Just to be really clear, that assumption is wrong

I misspoke and meant to agree with Alex's comment. If you are saying I
was wrong, then yes, I was wrong. I meant that I was assuming you were
resizing the actual table in the MMIO region where the MSI-X table and
PBA bits are present.
