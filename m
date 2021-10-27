Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF143D161
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbhJ0THv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:07:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbhJ0THv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635361524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4yfqS02aUffRcN2ytxZ7WbUoLeVw/KvRKeeY+nzKuw=;
        b=TsVS2XSFm198BxfauoXFM9v9iM3XT4BEVRoMVFkkfCh9LspHPU1W9Smy3Nk7HSJlLsCDkD
        9OXieZYRlKeqVvFq864oT6IKmNAwdoLgaEVSuDlf45Pr2+//yrmx+m1ZWuQhnM4Vr9sn7E
        eeX6CT1Ts9QImLQiUDF7UfOHyIRjC6k=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-AGvvIL-xMVOmtVH-hbE2IA-1; Wed, 27 Oct 2021 15:05:23 -0400
X-MC-Unique: AGvvIL-xMVOmtVH-hbE2IA-1
Received: by mail-oo1-f71.google.com with SMTP id s19-20020a4aead3000000b002b8da937741so1691004ooh.14
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 12:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O4yfqS02aUffRcN2ytxZ7WbUoLeVw/KvRKeeY+nzKuw=;
        b=hKd6S5n1YDk5lZDumefM74tCcljh+8Y9baH31qHD/6QG2wj6fFcVAZIecWLFYvGhcl
         bwU3/cNe9AplqUeveIHLRtO5tD3zx5h9oPvqfAzeBMktzgNul9fyerSPy8KcMof41+oN
         D8NPMgE+fVBlre6HBw4gMI57fIs5HZiqvQd2uV/eoJ2COc41CUjoTWTB446OP7cmMiag
         PP/jycQ8rQZYZv0ppx38vLfb5piNBrRMfOrUckg1tK/r+G9fl7qOzkcbVcGIxYCNR2oo
         aqPB2z4HiE02+sUCKev9acTUVY32SL8KJvQaMDHhzkDMv0AhSdDeP4+L+MjTdPWXcKWH
         0clQ==
X-Gm-Message-State: AOAM5325NXy1YL5qcdgHFLg1bK2WHg5uyCdzmxKHD/OJzWhrbyELr8bF
        ymZPFGOzgGf1KQcDKKdtsc6ukczab1FX+taATDifC4j0E0f4i2BmVWZKdRHG1CKbf6pZXTeGgM3
        SjqM0qTtT4hj0oQJk
X-Received: by 2002:a54:4616:: with SMTP id p22mr5021279oip.96.1635361523013;
        Wed, 27 Oct 2021 12:05:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFM+Cz5lXh23pqTW76bAGRqwtXY3wmttTlhsrmR78I98eJDUGGmUd4LUJuJppVWjEQ1+MClA==
X-Received: by 2002:a54:4616:: with SMTP id p22mr5021246oip.96.1635361522696;
        Wed, 27 Oct 2021 12:05:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 187sm276901oig.19.2021.10.27.12.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 12:05:22 -0700 (PDT)
Date:   Wed, 27 Oct 2021 13:05:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211027130520.33652a49.alex.williamson@redhat.com>
In-Reply-To: <20211026234300.GA2744544@nvidia.com>
References: <20211020185919.GH2744544@nvidia.com>
        <20211020150709.7cff2066.alex.williamson@redhat.com>
        <87o87isovr.fsf@redhat.com>
        <20211021154729.0e166e67.alex.williamson@redhat.com>
        <20211025122938.GR2744544@nvidia.com>
        <20211025082857.4baa4794.alex.williamson@redhat.com>
        <20211025145646.GX2744544@nvidia.com>
        <20211026084212.36b0142c.alex.williamson@redhat.com>
        <20211026151851.GW2744544@nvidia.com>
        <20211026135046.5190e103.alex.williamson@redhat.com>
        <20211026234300.GA2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 20:43:00 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Oct 26, 2021 at 01:50:46PM -0600, Alex Williamson wrote:
> > On Tue, 26 Oct 2021 12:18:51 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> > >   
> > > > > This is also why I don't like it being so transparent as it is
> > > > > something userspace needs to care about - especially if the HW cannot
> > > > > support such a thing, if we intend to allow that.    
> > > > 
> > > > Userspace does need to care, but userspace's concern over this should
> > > > not be able to compromise the platform and therefore making VF
> > > > assignment more susceptible to fatal error conditions to comply with a
> > > > migration uAPI is troublesome for me.    
> > > 
> > > It is an interesting scenario.
> > > 
> > > I think it points that we are not implementing this fully properly.
> > > 
> > > The !RUNNING state should be like your reset efforts.
> > > 
> > > All access to the MMIO memories from userspace should be revoked
> > > during !RUNNING
> > > 
> > > All VMAs zap'd.
> > > 
> > > All IOMMU peer mappings invalidated.
> > > 
> > > The kernel should directly block userspace from causing a MMIO TLP
> > > before the device driver goes to !RUNNING.
> > > 
> > > Then the question of what the device does at this edge is not
> > > relevant as hostile userspace cannot trigger it.
> > > 
> > > The logical way to implement this is to key off running and
> > > block/unblock MMIO access when !RUNNING.
> > > 
> > > To me this strongly suggests that the extra bit is the correct way
> > > forward as the driver is much simpler to implement and understand if
> > > RUNNING directly controls the availability of MMIO instead of having
> > > an irregular case where !RUNNING still allows MMIO but only until a
> > > pending_bytes read.
> > > 
> > > Given the complexity of this can we move ahead with the current
> > > mlx5_vfio and Yishai&co can come with some followup proposal to split
> > > the freeze/queice and block MMIO?  
> > 
> > I know how much we want this driver in, but I'm surprised that you're
> > advocating to cut-and-run with an implementation where we've identified
> > a potentially significant gap with some hand waving that we'll resolve
> > it later.  
> 
> I don't view it as cut and run, but making reasonable quanta of
> progress with patch series of reviewable size and scope.
> 
> At a certain point we need to get the base level of functionality,
> that matches the currently defined ABI merged so we can talk about
> where the ABI needs to go.
> 
> If you are uncomfortable about this from a uABI stability perspective
> then mark the driver EXPERIMENTAL and do not merge any other migration
> drivers until the two details are fully sorted out.
> 
> As far as the actual issue, if you hadn't just discovered it now
> nobody would have known we have this gap - much like how the very
> similar reset issue was present in VFIO for so many years until you
> plugged it.

But the fact that we did discover it is hugely important.  We've
identified that the potential use case is significantly limited and
that userspace doesn't have a good mechanism to determine when to
expose that limitation to the user.  We're tossing around solutions
that involve extensions, if not changes to the uAPI.  It's Wednesday of
rc7.

I feel like we've already been burned by making one of these
"reasonable quanta of progress" to accept and mark experimental
decisions with where we stand between defining the uAPI in the kernel
and accepting an experimental implementation in QEMU.  Now we have
multiple closed driver implementations (none of which are contributing
to this discussion), but thankfully we're not committed to supporting
them because we have no open implementations.  I think we could get away
with ripping up the uAPI if we really needed to.  

> > Deciding at some point in the future to forcefully block device MMIO
> > access from userspace when the device stops running is clearly a user
> > visible change and therefore subject to the don't-break-userspace
> > clause.    
> 
> I don't think so, this was done for reset retroactively after
> all. Well behaved qmeu should have silenced all MMIO touches as part
> of the ABI contract anyhow.

That's not obvious to me and I think it conflates access to the device
and execution of the device.  If it's QEMU's responsibility to quiesce
access to the device anyway, why does the kernel need to impose this
restriction.  I'd think we'd generally only impose such a restriction
if the alternative allows the user to invoke bad behavior outside the
scope of their use of the device or consistency of the migration data.
It appears that any such behavior would be implementation specific here.

> The "don't-break-userspace" is not an absolute prohibition, Linus has
> been very clear this limitation is about direct, ideally demonstrable,
> breakage to actually deployed software.

And if we introduce an open driver that unblocks QEMU support to become
non-experimental, I think that's where we stand.

> > That might also indicate that "freeze" is only an implementation
> > specific requirement.  Thanks,  
> 
> It doesn't matter if a theoretical device can exist that doesn't need
> "freeze" - this device does, and so it is the lowest common
> denominator for the uAPI contract and userspace must abide by the
> restriction.

Sorry, "to the victor go the spoils" is not really how I strictly want
to define a uAPI contract with userspace.  If we're claiming that
userspace is responsible for quiescing devices and we're providing a
means for that to occur, and userspace is already responsible for
managing MMIO access, then the only reason the kernel would forcefully
impose such a restriction itself would be to protect the host and the
implementation of that would depend on whether this is expected to be a
universal or device specific limitation.  Thanks,

Alex

