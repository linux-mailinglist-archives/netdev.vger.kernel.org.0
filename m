Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCF2F666C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbhANQwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbhANQwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:52:14 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0618C0613CF;
        Thu, 14 Jan 2021 08:51:34 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q1so12447706ion.8;
        Thu, 14 Jan 2021 08:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=No260T1laXogOZfXD8LZZkXGEVwp8vuv+8mBbMt0m0c=;
        b=S/17ryYcGdJaXWA1cohFwDYj7ccPadJW58QizPdzvlBmascJ5LQvzbRTQJViLT+LnI
         gcGwR0j9EQJc4wWoeDCx31wvu3WtZP5F2THhIDWJp8Ybb5KlRXRpe/z9j0QFW0qso/3z
         H42tTBhtQO78EGtPOaAAGQbkC1/2/sgwkox/ygImheTZF1rm9lkm9t/J14VTwI3stjCj
         yp57gezX6X+ZWNoR0dkxposbcpmcpoCWqVdbyg2d/OJPCSSJJAEEWetN2vJLpm44leEq
         HjKapM+mfXIJzF751CMLRKkg2RZXXV+1F0Kd9Cqn/OSaE+ThnNpWatO2Z2bY4FiPSEZw
         iRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=No260T1laXogOZfXD8LZZkXGEVwp8vuv+8mBbMt0m0c=;
        b=HZ3gUPwdd4mDoc0wdZPZpRuOPqFgaT2MyD6q7A9lkc44++Mxfd9scCSxnRWCnpcdXv
         SVYbRKmGYbd+tTOj5TF/P3k+iQlH0u3EMSOpFUVKJcGaJA8WxnYa1R6CFZUnc6OhDaqE
         WYcf1ong2i8zAc94Jor88ZNPD9ns//oUXV+Nuhf08yUWGeLpJHS+NgO3GJ6h1m4uFFSX
         aeuQiFd3TdmF72rLBFuUx94x5f3ZXZoDXgBhGjMN+hA0r7k22xKYjYBuZfz3iQsa/oj/
         ocdIYi/Ty+7iEkPxos4dlzIuF7FYey5dn8BZS+LQoJXc6odU5titV4/zfeLsETH4r0fd
         6kGQ==
X-Gm-Message-State: AOAM531PkRdHKJbBkDFIDrF36F12UCqeW1O/g9tK4//g0MszVoafTKRZ
        UFY4YLMSCielmAzUerTMJFNoaEQVPhj23ezfGbM=
X-Google-Smtp-Source: ABdhPJwcCHcdAOT0FoXKFkbVYesfcDpLc36ihm4AVd6+AgUAgXfY7lq8i0Tp3uQcu8kL2Qrzo9Jpua+C9YRKYDYm/HU=
X-Received: by 2002:a02:5d85:: with SMTP id w127mr7116666jaa.83.1610643093834;
 Thu, 14 Jan 2021 08:51:33 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
 <20210112063925.GC4678@unreal> <CAKgT0Udxd01agBMruooMi8TfAE+QkMt8n7-a2QrZ7Pj6-oFEAg@mail.gmail.com>
 <20210113060938.GF4678@unreal> <CAKgT0UecBX+LTR9GuxFb=P+pcUkjU5RYNNjeynExS-9Pik1Hsg@mail.gmail.com>
 <20210114071649.GL4678@unreal>
In-Reply-To: <20210114071649.GL4678@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 08:51:22 -0800
Message-ID: <CAKgT0UdPZvSf0qSsU1NGcVcK_j6rPZQ8YT_UcygU+2FEq_dGpQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:16 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Jan 13, 2021 at 12:00:00PM -0800, Alexander Duyck wrote:
> > On Tue, Jan 12, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 01:59:51PM -0800, Alexander Duyck wrote:
> > > > On Mon, Jan 11, 2021 at 10:39 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Mon, Jan 11, 2021 at 11:30:33AM -0800, Alexander Duyck wrote:
> > > > > > On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > >
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >

<snip>

> >
> > > >
> > > > Also I am not a big fan of the VF groping around looking for a PF
> > > > interface as it means the interface will likely be exposed in the
> > > > guest as well, but it just won't work.
> > >
> > > If you are referring to VF exposed to the VM, so in this case VF must be
> > > bound too vfio driver, or any other driver, and won't allow MSI-X change.
> > > If you are referring to PF exposed to the VM, it is very unlikely scenario
> > > in real world and reserved for braves among us. Even in this case, the
> > > set MSI-X won't work, because PF will be connected to the hypervisor driver
> > > that doesn't support set_msix.
> > >
> > > So both cases are handled.
> >
> > I get that they are handled. However I am not a huge fan of the sysfs
> > attributes for one device being dependent on another device. When you
> > have to start searching for another device it just makes things messy.
>
> This is pretty common way, nothing new here.

This is how writable fields within the device are handled. I am pretty
sure this is the first sysfs entry that is providing a workaround via
a device firmware to make the field editable that wasn't intended to
be.

So if in the future I define a device that has an MMIO register that
allows me to edit configuration space should I just tie it into the
same framework? That is kind of where I am going with my objection to
this. It just seems like you are adding a backdoor to allow editing
read-only configuration options.

> >
> > > >
> > > > > >
> > > > > > If you are calling this on the VFs then it doesn't really make any
> > > > > > sense anyway since the VF is not a "VF PCI dev representor" and
> > > > > > shouldn't be treated as such. In my opinion if we are going to be
> > > > > > doing per-port resource limiting that is something that might make
> > > > > > more sense as a part of the devlink configuration for the VF since the
> > > > > > actual change won't be visible to an assigned device.
> > > > >
> > > > > https://lore.kernel.org/linux-pci/20210112061535.GB4678@unreal/
> > > >
> > > > So the question I would have is if we are spawning the VFs and
> > > > expecting them to have different configs or the same configuration?
> > >
> > > By default, they have same configuration.
> > >
> > > > I'm assuming in your case you are looking for a different
> > > > configuration per port. Do I have that correct?
> > >
> > > No, per-VF as represents one device in the PCI world. For example, mlx5
> > > can have more than one physical port.
> >
> > Sorry, I meant per virtual function, not per port.
>
> Yes, PCI spec is clear, MSI-X vector count is per-device and in our case
> it means per-VF.

I think you overlooked the part about it being "read-only". It isn't
really meant to be changed and that is what this patch set is
providing.

> >
> > > >
> > > > Where this gets ugly is that SR-IOV assumes a certain uniformity per
> > > > VF so doing a per-VF custom limitation gets ugly pretty quick.
> > >
> > > I don't find any support for this "uniformity" claim in the PCI spec.
> >
> > I am referring to the PCI configuration space. Each VF ends up with
> > some fixed amount of MMIO resources per function. So typically when
> > you spawn VFs we had things setup so that all you do is say how many
> > you want.
> >
> > > > I wonder if it would make more sense if we are going this route to just
> > > > define a device-tree like schema that could be fed in to enable VFs
> > > > instead of just using echo X > sriov_numvfs and then trying to fix
> > > > things afterwards. Then you could define this and other features that
> > > > I am sure you would need in the future via json-schema like is done in
> > > > device-tree and write it once enabling the set of VFs that you need.
> > >
> > > Sorry, but this is overkill, it won't give us much and it doesn't fit
> > > the VF usage model at all.
> > >
> > > Right now, all heavy users of SR-IOV are creating many VFs up to the maximum.
> > > They do it with autoprobe disabled, because it is too time consuming to wait
> > > till all VFs probe themselves and unbind them later.
> > >
> > > After that, they wait for incoming request to provision VM on VF, they set MAC
> > > address, change MSI-X according to VM properties and bind that VF to new VM.
> > >
> > > So MSI-X change is done after VFs were created.
> >
> > So if I understand correctly based on your comments below you are
> > dynamically changing the VF's MSI-X configuration space then?
>
> I'm changing "Table Size" from "7.7.2.2 Message Control Register for
> MSI-X (Offset 02h)" and nothing more.
>
> If you do raw PCI read before and after, only this field will be changed.

I would hope there is much more going on. Otherwise the VF hardware
will be exploitable by a malicious driver in the guest since you could
read/write to registers beyond the table and see some result. I am
assuming the firmware doesn't allow triggering of any interrupts
beyond the ones defined as being in the table.
