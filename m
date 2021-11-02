Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F252A44371D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhKBUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230293AbhKBUSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 16:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635884169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xrr7Nswb1zSUeN/enXyBsdfTuUeQZHbFjkSfA/cUnkk=;
        b=KZ3Gp2Q8RzUjiXzTvazlnIwkr/TRkP4OXZceUjLZQ1VzWEfAV2aPE+Ch+ol43gokqlxu6Y
        Vh3CWM218Rz0/uA4a5+faNl/jMgx9eJfb63/hDysaHiViJ/ytpuj11pphREjFyZWM3UhLG
        SVcVjoxJdbYaknb1A3lZ82V6k/GVFTY=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-feRt9FQAO5OuO4djYZ8KJw-1; Tue, 02 Nov 2021 16:15:51 -0400
X-MC-Unique: feRt9FQAO5OuO4djYZ8KJw-1
Received: by mail-oi1-f198.google.com with SMTP id r8-20020acac108000000b002a78cec0558so195540oif.10
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 13:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xrr7Nswb1zSUeN/enXyBsdfTuUeQZHbFjkSfA/cUnkk=;
        b=L2PLcJWh59L10sar+U2D5Ax/35CZX83EvUXdpTT3gLlWSx5mC7dUvTAP4s0TLAygns
         05yQa4l92ipUp5KT6QKiGUUDeeXV6PQ5vDFRQ7ExLZoMp2zylOUs+C5UZ2Y2TL3F5ESv
         VDGQj9GfbEdex4fo3kBAZPFJnWQNWTro3iJkLMQZv/YuwT225zKs4YS44kAEa+VzOkBp
         EaJv9tlUodlSjCJaFZmLE6TNGk4nlGmcR0Yr+xuVDBldvY9YMOrYGLjAELA0DAi7BvJt
         ocb3jNpMntT/a3V/nd7V0NZfs9V0mGyKTdwmwtW7YrMKff511qwb4LBd2H0FVQ4CKrEN
         uXgQ==
X-Gm-Message-State: AOAM533sxbVsgvaftAY9Y0uM3JcCprR7nYgR0wW3vDrwGC3IQHgKVFdI
        KIBI7WSm5F9hGEQcoGDeFsl1gOOoysL+TQPPa8pQ6JOyF0UsYoGzkVmNfQH6MOnH7UmkGkUJUJs
        vGJMZkRO+nEWW3y/K
X-Received: by 2002:aca:502:: with SMTP id 2mr6911485oif.121.1635884150177;
        Tue, 02 Nov 2021 13:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB1YIom/qnGCnU3mQ5wd7qinnolUIYz9BC2zuiV9Oo21uixIulObHuoTWjbBeBw4sEtvoYGg==
X-Received: by 2002:aca:502:: with SMTP id 2mr6911462oif.121.1635884149950;
        Tue, 02 Nov 2021 13:15:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m16sm1632822oiw.13.2021.11.02.13.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:15:49 -0700 (PDT)
Date:   Tue, 2 Nov 2021 14:15:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
In-Reply-To: <20211102163610.GG2744544@nvidia.com>
References: <20211026234300.GA2744544@nvidia.com>
        <20211027130520.33652a49.alex.williamson@redhat.com>
        <20211027192345.GJ2744544@nvidia.com>
        <20211028093035.17ecbc5d.alex.williamson@redhat.com>
        <20211028234750.GP2744544@nvidia.com>
        <20211029160621.46ca7b54.alex.williamson@redhat.com>
        <20211101172506.GC2744544@nvidia.com>
        <20211102085651.28e0203c.alex.williamson@redhat.com>
        <20211102155420.GK2744544@nvidia.com>
        <20211102102236.711dc6b5.alex.williamson@redhat.com>
        <20211102163610.GG2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 13:36:10 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 02, 2021 at 10:22:36AM -0600, Alex Williamson wrote:
> 
> > > > There's no point at which we can do SET_IRQS other than in the
> > > > _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> > > > guest driver based on actions to the device, we can't be mucking
> > > > with IRQs while the device is presumed running and already
> > > > generating interrupt conditions.    
> > > 
> > > We need to do it in state 000
> > > 
> > > ie resume should go 
> > > 
> > >   000 -> 100 -> 000 -> 001
> > > 
> > > With SET_IRQS and any other fixing done during the 2nd 000, after the
> > > migration data has been loaded into the device.  
> > 
> > Again, this is not how QEMU works today.  
> 
> I know, I think it is a poor choice to carve out certain changes to
> the device that must be preserved across loading the migration state.
> 
> > > The uAPI comment does not define when to do the SET_IRQS, it seems
> > > this has been missed.
> > > 
> > > We really should fix it, unless you feel strongly that the
> > > experimental API in qemu shouldn't be changed.  
> > 
> > I think the QEMU implementation fills in some details of how the uAPI
> > is expected to work.  
> 
> Well, we already know QEMU has problems, like the P2P thing. Is this a
> bug, or a preferred limitation as designed?
> 
> > MSI/X is expected to be restored while _RESUMING based on the
> > config space of the device, there is no intermediate step between
> > _RESUMING and _RUNNING.  Introducing such a requirement precludes
> > the option of a post-copy implementation of (_RESUMING | _RUNNING).  
> 
> Not precluded, a new state bit would be required to implement some
> future post-copy.
> 
> 0000 -> 1100 -> 1000 -> 1001 -> 0001
> 
> Instead of overloading the meaning of RUNNING.
> 
> I think this is cleaner anyhow.
> 
> (though I don't know how we'd structure the save side to get two
> bitstreams)

The way this is supposed to work is that the device migration stream
contains the device internal state.  QEMU is then responsible for
restoring the external state of the device, including the DMA mappings,
interrupts, and config space.  It's not possible for the migration
driver to reestablish these things.  So there is a necessary division
of device state between QEMU and the migration driver.

If we don't think the uAPI includes the necessary states, doesn't
sufficiently define the states, and we're not following the existing
QEMU implementation as the guide for the intentions of the uAPI spec,
then what exactly is the proposed mlx5 migration driver implementing
and why would we even considering including it at this point?  Thanks,

Alex

