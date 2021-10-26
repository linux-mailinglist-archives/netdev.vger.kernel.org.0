Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF11D43B4CC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhJZOxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhJZOxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635259887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QiyqNdatw3NhazMeX0fRhEhJxRWOX6NB4RyRlxaJtOo=;
        b=CJTNyxjEjxajVy+bxeJtcR7deSuasp7rw9ea3QnRKTFFXt/7n3ypr7LLifWLxf7VQ/FMnu
        X9hVwkJXyLO6ihNIzsj94M+WSOZpwS2e9bpBPq2Zsvcqrxqk5QI22sabjDIPwn/0JnpWNH
        XVGpB6xXaoDqLHa41+K1m9YoJ+RV/ko=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-IBgTCTkKN0ucr5i-bsFY8A-1; Tue, 26 Oct 2021 10:51:26 -0400
X-MC-Unique: IBgTCTkKN0ucr5i-bsFY8A-1
Received: by mail-wm1-f70.google.com with SMTP id d73-20020a1c1d4c000000b0032ca7ec21a4so1096723wmd.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QiyqNdatw3NhazMeX0fRhEhJxRWOX6NB4RyRlxaJtOo=;
        b=OCfOg5MvzaczeQkH3L1jNwyUZEbh+ylLLHlHXNbJzCepuRHosduvwNJoeHc8R9agq7
         z1k2zQhB3J7tF6x6rYGLBbccEdcHGYYNh+HoR1bv71wwmqGnHX+r6TO7e1fUjL4bmkhC
         jail5YhyHYugt1W/6iRFPKD1lTwVvgNrxkzoi6/r4vNL7tvP4WCxxdplLzp5DbL3ImlK
         CPRKVYNVFiPdpar0yFqK0zeji5/3gttLkSbNCiKNtjo/yaPGd+yPcE0oEDjMz2TAN378
         2MG5kdHIPRDH+8yg54HZWC2iPIoSLMvvoTSo0+uEHXoAiTJAwR+x/o27rQiFSyxK6M4q
         qZoA==
X-Gm-Message-State: AOAM531FHVAlUQ8oOJ7a9FyNDIr6q9CuP0dVuVoobIcS0JPMBjf9k++3
        3h3QJGYhiqVAGY+0Zxv348dYgXM7PwzFxewmsBjxnSh5q290TVC8jHm94ZpTwj7LvNLr3esVw9+
        wJQ1i3IUwNVwaY0q5
X-Received: by 2002:a7b:cb56:: with SMTP id v22mr33926998wmj.77.1635259884719;
        Tue, 26 Oct 2021 07:51:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmzKviO2aTymPZ9XHNdwt+tg8/6pDTBfRAG1Cu7P2+mHxfgMMP94xGln5DErv9xT3PJAICxw==
X-Received: by 2002:a7b:cb56:: with SMTP id v22mr33926975wmj.77.1635259884518;
        Tue, 26 Oct 2021 07:51:24 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id n15sm2162091wmq.3.2021.10.26.07.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:51:23 -0700 (PDT)
Date:   Tue, 26 Oct 2021 15:51:21 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <YXgV6ehhsSlydiEl@work-vm>
References: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
 <20211026082920.1f302a45.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026082920.1f302a45.alex.williamson@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Mon, 25 Oct 2021 19:47:29 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > On Mon, 25 Oct 2021 17:34:01 +0100
> > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > >   
> > > > * Alex Williamson (alex.williamson@redhat.com) wrote:  
> > > > > [Cc +dgilbert, +cohuck]
> > > > > 
> > > > > On Wed, 20 Oct 2021 11:28:04 +0300
> > > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > >     

<snip>

> > > In a way.  We're essentially recognizing that we cannot stop a single
> > > device in isolation of others that might participate in peer-to-peer
> > > DMA with that device, so we need to make a pass to quiesce each device
> > > before we can ask the device to fully stop.  This new device state bit
> > > is meant to be that quiescent point, devices can accept incoming DMA
> > > but should cease to generate any.  Once all device are quiesced then we
> > > can safely stop them.  
> > 
> > It may need some further refinement; for example in that quiesed state
> > do counters still tick? will a NIC still respond to packets that don't
> > get forwarded to the host?
> 
> I'd think no, but I imagine it's largely device specific to what extent
> a device can be fully halted yet minimally handle incoming DMA.

That's what worries me; we're adding a new state here as we understand
more about trying to implement a device; but it seems that we need to
nail something down as to what the state means.

> > Note I still think you need a way to know when you have actually reached
> > these states; setting a bit in a register is asking nicely for a device
> > to go into a state - has it got there?
> 
> It's more than asking nicely, we define the device_state bits as
> synchronous, the device needs to enter the state before returning from
> the write operation or return an errno.

I don't see how it can be synchronous in practice; can it really wait to
complete if it has to take many cycles to finish off an inflight DMA
before it transitions?

> > > > Now, you could be a *little* more sloppy; you could allow a device carry
> > > > on doing stuff purely with it's own internal state up until the point
> > > > it needs to serialise; but that would have to be strictly internal state
> > > > only - if it can change any other devices state (or issue an interrupt,
> > > > change RAM etc) then you get into ordering issues on the serialisation
> > > > of multiple devices.  
> > > 
> > > Yep, that's the proposal that doesn't require a uAPI change, we loosen
> > > the definition of stopped to mean the device can no longer generate DMA
> > > or interrupts and all internal processing outside or responding to
> > > incoming DMA should halt (essentially the same as the new quiescent
> > > state above).  Once all devices are in this state, there should be no
> > > incoming DMA and we can safely collect per device migration data.  If
> > > state changes occur beyond the point in time where userspace has
> > > initiated the collection of migration data, drivers have options for
> > > generating errors when userspace consumes that data.  
> > 
> > How do you know that last device has actually gone into that state?
> 
> Each device cannot, the burden is on the user to make sure all devices
> are stopped before proceeding to read migration data.

Yeh this really ties to the previous question; if it's synchronous
you're OK.

> > Also be careful; it feels much more delicate where something might
> > accidentally start a transaction.
> 
> This sounds like a discussion of theoretically broken drivers.  Like
> the above device_state, drivers still have a synchronization point when
> the user reads the pending_bytes field to initiate retrieving the
> device state.  If the implementation requires the device to be fully
> stopped to snapshot the device state to provide to the user, this is
> where that would happen.  Thanks,

Yes, but I worry that some ways of definining it are harder to get right
in drivers, so less likely to be theoretical.

Dave

> Alex
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

