Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E378243B483
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhJZOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:44:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236855AbhJZOok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635259336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiAOMFFmr8a+X0LpJnX8Lz9+s9dbAEJz1395MTiVhXQ=;
        b=CCaG1lAwdcQPW12jmqxSqty6dHq9SBiEeQzsMrxhMZyHSDNXkXC1ok/pjudSrDS/nDaEyU
        vIFpM2oHEqJgKZVWAwkuiTO3S+U93DCJHk6DWIP+J7JT4maHfI3fol2tLqhYo+O4Jhzhe+
        rMO/EKwOdi1jnMu3aaxFLxShO18wvKI=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-yjweJ-MiN9qPRoeZTTJO2Q-1; Tue, 26 Oct 2021 10:42:15 -0400
X-MC-Unique: yjweJ-MiN9qPRoeZTTJO2Q-1
Received: by mail-oo1-f70.google.com with SMTP id k3-20020a4a3103000000b002b733cd21e6so5979798ooa.19
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiAOMFFmr8a+X0LpJnX8Lz9+s9dbAEJz1395MTiVhXQ=;
        b=EtYjwWkFJE9+lWMqO+sxb+H2XDVEd++2WEffPLKAMtweZalqpVbwfPUU1SDTGKja5q
         p4ULu/A5n9NWTdDXPU8VaUz3U78vFuhYdAJVUNruQf7HkYBfYTwd9LHaywHx+Ho++GzK
         gYVu+4X8ktulQ92zen/Mssd8E0lcHPMEfTGaw9v7PAuqzLJ2aJ4CHUlvh0yaswVa0VQA
         Hn13mM+cdYPgdrAkrZwv/kcWND/7cXo51QJv6AXkacQATSzpO9l9I7iakMseE4kkM4F7
         PftM/qet2d/WddnnhpryaZHZ6ghC6x0qji8c/K+R2uCu3HzyBikVlFiLF5IwuufNqmtw
         5jEw==
X-Gm-Message-State: AOAM533CxUgEfL4i039ZA5yqtiBLS63Ru9X7sSbJcK4LtJU6xqGyNtzb
        Nn5eFKb0+8dJaJsScjsw/K7U3DsSicdFtwEFxjSf8UHAQvmtLqACnJy/HmWTTrBZxMxXv1LA/07
        yUr6RvwtR5+MmuuI+
X-Received: by 2002:a9d:60dd:: with SMTP id b29mr19581599otk.117.1635259334751;
        Tue, 26 Oct 2021 07:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyST1/XzJTg/5DfqLHtgP59NLmCW5cCEnBVzPC+ydnvMqHEPhvPl7zdCTaW1rzIoB4jsSg6sg==
X-Received: by 2002:a9d:60dd:: with SMTP id b29mr19581565otk.117.1635259334446;
        Tue, 26 Oct 2021 07:42:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w12sm3544794oor.42.2021.10.26.07.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:42:14 -0700 (PDT)
Date:   Tue, 26 Oct 2021 08:42:12 -0600
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
Message-ID: <20211026084212.36b0142c.alex.williamson@redhat.com>
In-Reply-To: <20211025145646.GX2744544@nvidia.com>
References: <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <20211020185919.GH2744544@nvidia.com>
        <20211020150709.7cff2066.alex.williamson@redhat.com>
        <87o87isovr.fsf@redhat.com>
        <20211021154729.0e166e67.alex.williamson@redhat.com>
        <20211025122938.GR2744544@nvidia.com>
        <20211025082857.4baa4794.alex.williamson@redhat.com>
        <20211025145646.GX2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 11:56:46 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 25, 2021 at 08:28:57AM -0600, Alex Williamson wrote:
> > On Mon, 25 Oct 2021 09:29:38 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, Oct 21, 2021 at 03:47:29PM -0600, Alex Williamson wrote:  
> > > > I recall that we previously suggested a very strict interpretation of
> > > > clearing the _RUNNING bit, but again I'm questioning if that's a real
> > > > requirement or simply a nice-to-have feature for some undefined
> > > > debugging capability.  In raising the p2p DMA issue, we can see that a
> > > > hard stop independent of other devices is not really practical but I
> > > > also don't see that introducing a new state bit solves this problem any
> > > > more elegantly than proposed here.  Thanks,    
> > > 
> > > I still disagree with this - the level of 'frozenness' of a device is
> > > something that belongs in the defined state exposed to userspace, not
> > > as a hidden internal state that userspace can't see.
> > > 
> > > It makes the state transitions asymmetric between suspend/resume as
> > > resume does have a defined uAPI state for each level of frozeness and
> > > suspend does not.
> > > 
> > > With the extra bit resume does:
> > >   
> > >   0000, 0100, 1000, 0001
> > > 
> > > And suspend does:
> > > 
> > >   0001, 1001, 0010, 0000
> > > 
> > > However, without the extra bit suspend is only
> > >   
> > >   001,  010, 000
> > > 
> > > With hidden state inside the 010  
> > 
> > And what is the device supposed to do if it receives a DMA while in
> > this strictly defined stopped state?  If it generates an unsupported
> > request, that can trigger a fatal platform error.    
> 
> I don't see that this question changes anything, we always have a
> state where the device is unable to respond to incoming DMA.

I think that depends on the device implementation.  If all devices can
receive incoming DMA, but all devices are also quiesced not to send
DMA, there's not necessarily a need to put the device in a state where
it errors TLPs.  This ventures into conversations about why assigning
VFs can be considered safer than assigning PFs, users cannot disable
memory space of VFs and therefore cannot generate URs on writes to
MMIO, which may generate fatal faults on some platforms.  If we create
a uAPI that requires dropping TLPs, then we provide userspace with a
means to specifically generate those faults.

> In all cases entry to this state is triggered only by user space
> action, if userspace does the ioctls in the wrong order then it will
> hit it.

And if userspace does not quiesce DMA and gets an intermediate device
state, that's a failure to follow the protocol.

> > If it silently drops the DMA, then we have data loss.  We're
> > defining a catch-22 scenario for drivers versus placing the onus on
> > the user to quiesce the set of devices in order to consider the
> > migration status as valid.    
> 
> The device should error the TLP.

That's a bit of a landmine as outlined above.
 
> Userspace must globally fence access to the device before it enters
> the device into the state where it errors TLPs.
> 
> This is also why I don't like it being so transparent as it is
> something userspace needs to care about - especially if the HW cannot
> support such a thing, if we intend to allow that.

Userspace does need to care, but userspace's concern over this should
not be able to compromise the platform and therefore making VF
assignment more susceptible to fatal error conditions to comply with a
migration uAPI is troublesome for me.  Thanks,

Alex

