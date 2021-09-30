Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7106041DA0B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351015AbhI3Mn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350999AbhI3Mn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633005703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Unbty8nNkK7YONUoWOx1LklE7WdRs1VG0UIIrgjCenI=;
        b=HGZRWHAwRiMg7xk6aBelgvJMRTdsfxx6pOdYxyugg70517rkmMaJvhPh0tDcdPUvfcrA8I
        PJ9JOHX0o+fNt/dnEWM3YvHcyiKU3ogIZnC9owsGPNhGVE87Js2gkLVPQ7QsWoNW8nVKJr
        HbAwnMGjmW3jfXoBImcMpsc5pDgKpUM=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-sEikP_QwMXy37XIuG82OUQ-1; Thu, 30 Sep 2021 08:41:42 -0400
X-MC-Unique: sEikP_QwMXy37XIuG82OUQ-1
Received: by mail-oi1-f200.google.com with SMTP id d4-20020a05680805c400b00275f7bc59feso4118019oij.9
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Unbty8nNkK7YONUoWOx1LklE7WdRs1VG0UIIrgjCenI=;
        b=DIHJZ7vc1S2U8EJy/I7ougQVQ3RuWIu6WPH+LvRmS1x+ikC0C/FdCqHfYT6kDxeZHi
         x14CD8HURDfEmPMeuAvcP6AfapQxksFo/OEOlVt/5flFGqnTp1Vq/WHOo/mZMbFhKl9u
         Vwy291S/qn5D3n11F8SQnvA9Al8YsdqnhPDpJ7usR6iiv1dZhjY/vYTjP+QP/AO0OqdL
         Px8UhEknVHWi+FG70+Bb+9FO5jFuvMHOkqx6lGugMAEWng7zVDQTP5dmVVVkbWkNliry
         wGVbc9hxAzddx5JFPNsIeLtaQLy5TkCT3H2MTaT93CR1mmLVoyJ3ffbGUdMr65Cpy2xW
         1KNA==
X-Gm-Message-State: AOAM53090xWGrXAPkpSQyvdpvLwaokoh8CXogQ8mkrbm3AIyekWcAWru
        oKgHlD3zezFlxLAmXdZqPHYTMXRCy6Uyqpmad0oNkcFzVB3BObyQ1MFxdCh5B3HrYprSiPCxakQ
        2nIB0+4yG7WVYQoQS
X-Received: by 2002:a05:6808:46:: with SMTP id v6mr2547337oic.72.1633005701662;
        Thu, 30 Sep 2021 05:41:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMRYKLy+B+MpdesoWZkxr5N1driI4Zy8XmLACnQxDaRZIHqyWhxnO2lDZUxuKPwWjg5RQWJg==
X-Received: by 2002:a05:6808:46:: with SMTP id v6mr2547322oic.72.1633005701417;
        Thu, 30 Sep 2021 05:41:41 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id e6sm530698otr.79.2021.09.30.05.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 05:41:40 -0700 (PDT)
Date:   Thu, 30 Sep 2021 06:41:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210930064139.57bb74c0.alex.williamson@redhat.com>
In-Reply-To: <bad28179-cbca-9337-8e6b-d730f06c6c58@nvidia.com>
References: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
        <20210927164648.1e2d49ac.alex.williamson@redhat.com>
        <20210927231239.GE3544071@ziepe.ca>
        <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
        <20210929063551.47590fbb.alex.williamson@redhat.com>
        <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
        <20210929075019.48d07deb.alex.williamson@redhat.com>
        <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
        <20210929091712.6390141c.alex.williamson@redhat.com>
        <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
        <20210929161433.GA1808627@ziepe.ca>
        <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
        <20210929164409.3c33e311.alex.williamson@redhat.com>
        <bad28179-cbca-9337-8e6b-d730f06c6c58@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 12:25:23 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 9/30/2021 1:44 AM, Alex Williamson wrote:
> > On Thu, 30 Sep 2021 00:48:55 +0300
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >  
> >> On 9/29/2021 7:14 PM, Jason Gunthorpe wrote:  
> >>> On Wed, Sep 29, 2021 at 06:28:44PM +0300, Max Gurtovoy wrote:
> >>>     
> >>>>> So you have a device that's actively modifying its internal state,
> >>>>> performing I/O, including DMA (thereby dirtying VM memory), all while
> >>>>> in the _STOP state?  And you don't see this as a problem?  
> >>>> I don't see how is it different from vfio-pci situation.  
> >>> vfio-pci provides no way to observe the migration state. It isn't
> >>> "000b"  
> >> Alex said that there is a problem of compatibility.
> >>
> >> I migration SW is not involved, nobody will read this migration state.  
> > The _STOP state has a specific meaning regardless of whether userspace
> > reads the device state value.  I think what you're suggesting is that
> > the device reports itself as _STOP'd but it's actually _RUNNING.  Is
> > that the compatibility workaround, create a self inconsistency?  
> 
>  From migration point of view the device is stopped.

The _RESUMING and _SAVING bits control the migration activity, the
_RUNNING bit controls the ability of the device to modify its internal
state and affect external state.  The initial state of the device is
absolutely not stopped.

> > We cannot impose on userspace to move a device from _STOP to _RUNNING
> > simply because the device supports the migration region, nor should we
> > report a device state that is inconsistent with the actual device state.  
> 
> In this case we can think maybe moving to running during enabling the 
> bus master..

There are no spontaneous state transitions, device_state changes only
via user manipulation of the register.

> >>>> Maybe we need to rename STOP state. We can call it READY or LIVE or
> >>>> NON_MIGRATION_STATE.  
> >>> It was a poor choice to use 000b as stop, but it doesn't really
> >>> matter. The mlx5 driver should just pre-init this readable to running.  
> >> I guess we can do it for this reason. There is no functional problem nor
> >> compatibility issue here as was mentioned.
> >>
> >> But still we need the kernel to track transitions. We don't want to
> >> allow moving from RESUMING to SAVING state for example. How this
> >> transition can be allowed ?
> >>
> >> In this case we need to fail the request from the migration SW...  
> > _RESUMING to _SAVING seems like a good way to test round trip migration
> > without running the device to modify the state.  Potentially it's a
> > means to update a saved device migration data stream to a newer format
> > using an intermediate driver version.  
> 
> what do you mean by "without running the device to modify the state." ?

If a device is !_RUNNING it should not be advancing its internal state,
therefore state-in == state-out.
 
> did you describe a case where you migrate from source to dst and then 
> back to source with a new migration data format ?

I'm speculating that as the driver evolves, the migration data stream
generated from the device's migration region can change.  Hopefully in
compatible ways.  The above sequence of restoring and extracting state
without the complication of the device running could help to validate
compatibility.  Thanks,

Alex

