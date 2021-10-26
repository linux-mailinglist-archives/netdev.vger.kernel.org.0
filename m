Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D977443B4D1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJZOyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:54:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbhJZOyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635259934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T3DVTWtNGq2QrB5FfajrN5UrC6srYwyWJ01LjyrOPSs=;
        b=FCDbAvGJozllRWGKc/zl+ppC526nStz7/DXzJf4Pzln9Koiz/jXshDMUggGH6A4O8D0KYL
        TcfZxT3RtR6k7/R0Vq/at568vNwiXivx1XrpRFaMMLdC8DHFy2CmOsadNemRHxxMN94aC+
        jp9QrBT9W/xl+2p4N367o3o8c2xp/VE=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-T6QQk7SqNCG6QlSyeoZhqA-1; Tue, 26 Oct 2021 10:52:13 -0400
X-MC-Unique: T6QQk7SqNCG6QlSyeoZhqA-1
Received: by mail-ot1-f70.google.com with SMTP id b22-20020a056830311600b00552b48856bdso2721438ots.6
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3DVTWtNGq2QrB5FfajrN5UrC6srYwyWJ01LjyrOPSs=;
        b=A32KRTwL55wqFLSsYbE9uUokOhKWY6htKCnvPtK5DN9qHxt0FECB8FnLpd1pvLf1Ca
         5BwmQmppfe/rlqdPOrctcNlb/vZRIW9CPNDUv/98GuvPKNTc5HchSF21nnxw7czLIdx8
         NI0tBzfqxya5Nw+Q9hHXd++75LFzMnQfFOFKO6WUpnB3Qlt4W0bBRYIM19tfGoHkk5ZX
         +1iO7abibumVepvQGdC7bWj+HQtLnZRZiOBWQNMdjnV/C7mcF46VF9+caIW7fHpa94DW
         cLipJ24hUjYsSruaMYZiXpXpoF0vIlXi5pxinHEnksHYxjQTaZR/Im1cFcjRvhG4fEkz
         WwzQ==
X-Gm-Message-State: AOAM53027a3cZvee8GCRqBuBUvbIt0vHzuS4A8YL8ltMcqr70sK7bmYe
        tHR7cpgV9U/2FjgqHLGLbcL7IV46PjAMx9loLzKEqWuhmt15Vr0vlwXcXVnBbKPBru3dgG0Tjl3
        9jRVEOlqtusj7AmHF
X-Received: by 2002:a05:6830:1af0:: with SMTP id c16mr19471588otd.16.1635259932617;
        Tue, 26 Oct 2021 07:52:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyThT8eyPPQ8unPM1ZyhVDxxqj6w0ptUlI7/UnRnEG1ZGmmkygz7HHXWNIWKyWD09IVK3ntmQ==
X-Received: by 2002:a05:6830:1af0:: with SMTP id c16mr19471566otd.16.1635259932424;
        Tue, 26 Oct 2021 07:52:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e23sm4572613oih.40.2021.10.26.07.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:52:12 -0700 (PDT)
Date:   Tue, 26 Oct 2021 08:52:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026085210.000dc19b.alex.williamson@redhat.com>
In-Reply-To: <20211026121353.GP2744544@nvidia.com>
References: <20211019192328.GZ2744544@nvidia.com>
        <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <YXbceaVo0q6hOesg@work-vm>
        <20211025115535.49978053.alex.williamson@redhat.com>
        <YXb7wejD1qckNrhC@work-vm>
        <20211025191509.GB2744544@nvidia.com>
        <YXe/AvwQcAxJ/hXQ@work-vm>
        <20211026121353.GP2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 09:13:53 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Oct 26, 2021 at 09:40:34AM +0100, Dr. David Alan Gilbert wrote:
> > * Jason Gunthorpe (jgg@nvidia.com) wrote:  
> > > On Mon, Oct 25, 2021 at 07:47:29PM +0100, Dr. David Alan Gilbert wrote:
> > >   
> > > > It may need some further refinement; for example in that quiesed state
> > > > do counters still tick? will a NIC still respond to packets that don't
> > > > get forwarded to the host?  
> > > 
> > > At least for the mlx5 NIC the two states are 'able to issue outbound
> > > DMA' and 'all internal memories and state are frozen and unchanging'.  
> > 
> > Yeh, so my point was just that if you're adding a new state to this
> > process, you need to define the details like that.  
> 
> We are not planning to propose any patches/uAPI specification for this
> problem until after the mlx5 vfio driver is merged..

I'm not super comfortable with that.  If we're expecting to add a new
bit to define a quiescent state prior to clearing the running flag and
this is an optional device feature that userspace migration needs to be
aware of and it's really not clear from a hypervisor when p2p DMA might
be in use, I think that leaves userspace in a pickle how and when
they'd impose restrictions on assignment with multiple assigned
devices.  It's likely that the majority of initial use cases wouldn't
need this feature, which would make it difficult to arbitrarily impose
later.

OTOH, if we define !_RUNNING as quiescent and userspace reading
pending_bytes as the point by which the user is responsible for
quiescing all devices and the device state becomes stable (or drivers
can generate errors during collection of device state if that proves
otherwise), then I think existing userspace doesn't care about this
issue.  Thanks,

Alex

