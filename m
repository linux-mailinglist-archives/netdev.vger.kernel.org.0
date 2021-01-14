Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86C2F6885
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbhANR4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbhANR4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:56:15 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78CBC061574;
        Thu, 14 Jan 2021 09:55:35 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o6so12854861iob.10;
        Thu, 14 Jan 2021 09:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67DQJ4NzfsuMMaMoSQKf8A9YGMViRLloPVu4JKfJspU=;
        b=SEZSRRLIN5/ffeCw/jbEh8+UxH/AbBLcQT5hgZrYIab1LN++Xx/Vr+w7c5e+3pyALa
         jjRza21FnVLbATUPa+jkmvE9RLZnyzSFbAIOwPX619FbuYuic4rJf/QexVrp2SsQU2Tn
         xo5EFBjo269YyZYx9T0lxmL/RW9zsP+xk62hAG5bBkMfGb/jnSxEpvKFI55jdM7d6mnm
         D4Sdvt0FDQwt8kUY98FaBipjJhnSIG9VRABsO0JeUMyEB7dUFOYaS0SkXzX/O58kMGFC
         JJnIJ955l+VfAqFjMD5lRtqvZrOXYn0vpZ6sXAHihHy7NSdZg3a+FQp5uQwIvnCd6F4x
         Bqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67DQJ4NzfsuMMaMoSQKf8A9YGMViRLloPVu4JKfJspU=;
        b=C4BzK89r6Bp6uLpDzRtzIJZjc+ukaOUy3B0ghDlXkMQ05e/t4TUryrVkK2fczw2ZSP
         pNwVGhIlbXkrYV8vCIv8KYGv5Nx1fcp6jluT9F0y+cc9f+XLBRfc5rPMrxJzDG9hC8Lk
         ytQPut9frVIktBmbs5UPpGrF7vUJ/ryxzrjswqo4E/EGeazd6NlHcITe8orTUhxIAAMj
         yMX8dcjUxjnZirQaEd+EeR52sLFP+L/iqmC3y04RaOpoLcjXYxwrF/0uw7LPuaKBfj/a
         sHjQPBQ0Bqe7k74riId0VyzLCLTULK1Tw/60FtAKgKdpviVvtwVcqA5IysGJ0ICFsnij
         a9gw==
X-Gm-Message-State: AOAM532ZYZwP1YFp49VS8av4mvpU6xf/ZKocpaFI8PZEO7sWtMSVFutv
        toyTQDtI3cGTrRzT/ldb6cwLKGCZ5Lp38cO0Cdc=
X-Google-Smtp-Source: ABdhPJzfTKyiXkoG2S8TYpSj5Alx+3WrJ4Tgl0TbdE8GM6jccfBiN+ZFexSpk9u/wc53N1YXDa4Dg4Q1GBvedXBiMeA=
X-Received: by 2002:a92:b6c7:: with SMTP id m68mr7544514ill.95.1610646935156;
 Thu, 14 Jan 2021 09:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal> <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal> <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal> <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
In-Reply-To: <20210114164857.GN4147@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 09:55:24 -0800
Message-ID: <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 8:49 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Jan 14, 2021 at 08:40:14AM -0800, Alexander Duyck wrote:
>
> > Where I think you and I disagree is that I really think the MSI-X
> > table size should be fixed at one value for the life of the VF.
> > Instead of changing the table size it should be the number of vectors
> > that are functional that should be the limit. Basically there should
> > be only some that are functional and some that are essentially just
> > dummy vectors that you can write values into that will never be used.
>
> Ignoring the PCI config space to learn the # of available MSI-X
> vectors is big break on the how the device's programming ABI works.
>
> Or stated another way, that isn't compatible with any existing drivers
> so it is basically not a useful approach as it can't be deployed.
>
> I don't know why you think that is better.
>
> Jason

First off, this is technically violating the PCIe spec section 7.7.2.2
because this is the device driver modifying the Message Control
register for a device, even if it is the PF firmware modifying the VF.
The table size is something that should be set and fixed at device
creation and not changed.

The MSI-X table is essentially just an MMIO resource, and I believe it
should not be resized, just as you wouldn't expect any MMIO BAR to be
dynamically resized. Many drivers don't make use of the full MSI-X
table nor do they bother reading the size. We just populate a subset
of the table based on the number of interrupt causes we will need to
associate to interrupt handlers. You can check for yourself. There are
only a handful of drivers such as vfio that ever bother reading at the
offset "PCI_MSIX_FLAGS". Normally it is the number of interrupt causes
that determine how many we need, not the size of the table. In
addition the OS may restrict us further since there are only so many
MSI-X interrupts that are supported per system/socket.

As far as the programming ABI, having support for some number of MSI-X
vectors isn't the same as having that number of MSI-X vectors. The
MSI-X vector table entry is nothing more than a spot to write an
address/data pair with the ability to mask the value to prevent it
from being triggered. The driver/OS will associate some handler to
that address/data pair. Populating an entry doesn't guarantee the
interrupt will ever be used. The programming model for the device is
what defines what trigger will be associated with it and when/how it
will be used.

What I see this patch doing is trying to push driver PF policy onto
the VF PCIe device configuration space dynamically. Having some
limited number of interrupt causes should really be what is limiting
things here. I see that being mostly a thing between the firmware and
the VF in terms of configuration and not something that necessarily
has to be pushed down onto the PCIe configuration space itself.
