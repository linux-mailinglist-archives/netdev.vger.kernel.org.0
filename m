Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC72943BB3B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhJZTxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:53:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239029AbhJZTxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635277850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6YsqIJF4cmqUM5VoIFLtZ3R3oEYuHT98TJT5vDKLv0=;
        b=Spy7RLi+VXv1OVISDPx9VyIhQl2ur0hTZdzy9sGKfnhYNEwigumgx5kDY5EDKFDUDOndeQ
        W0646tvr0fKHLoDCqHQWhndfyAJVOi88PgDC+NWa+p0sCehVD7kgaMnnN0fHhlmxoBQuli
        SuLzs3CkPxd1FU6FmkfjTt/v0s646Uo=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-oJIDPeUrN5GN8hDIthamBA-1; Tue, 26 Oct 2021 15:50:49 -0400
X-MC-Unique: oJIDPeUrN5GN8hDIthamBA-1
Received: by mail-oo1-f70.google.com with SMTP id p2-20020a4a3c42000000b002b7138531a2so160903oof.10
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 12:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v6YsqIJF4cmqUM5VoIFLtZ3R3oEYuHT98TJT5vDKLv0=;
        b=h7X9Lhh4sf5GLTi9+m0itkDIYmmOFP3ULJXSHrECgQcSODFxFq9NZjmG+S4rhq2yn3
         XMgLEHj9nhx7LCyx5RCYnwvkXktpAxizs0oaZT62E0runf9CovB7pWmBNMR9TvKf0ylf
         2FF2XGuHswJIBNiPDpGSPBZNbT1Xhz9Roer1Jn6grYolGtsD6aw/feorLHV+j6Sz5I4Y
         qGWyxk+ljILcPT91pEO9cXIMy7Sp1XO9GqFZMDj+7hm44KdlS4WGTzqv4UGZn5vn3330
         vM4HDMRHcGtY987TFQY5LsUs9xK+0et5B1QWuQxMKXwmx3y8weAXS24nMigADoN/0TeC
         auNw==
X-Gm-Message-State: AOAM531ytM7Ilky0ad77Y5E21msHCTlI1JzH/qvTJ8Dsy9tHYn0pLsyu
        eZdCenXKyku2olyuW+sgFyklwhDfoLJbGEewVaraLh8z2LFBoVxaSKviXCx/8u2KkohJHkng5gN
        er1NGvQ/whe2N8g9i
X-Received: by 2002:a05:6830:2b11:: with SMTP id l17mr21915530otv.298.1635277848324;
        Tue, 26 Oct 2021 12:50:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP54OPC5IwSQShzWiwXn/t8EIhJAPy/ttWlrC47tIMalPERR7bNfkUdrFXsvQn1ejkueIxKw==
X-Received: by 2002:a05:6830:2b11:: with SMTP id l17mr21915507otv.298.1635277848077;
        Tue, 26 Oct 2021 12:50:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m7sm5109762oiw.49.2021.10.26.12.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:50:47 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:50:46 -0600
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
Message-ID: <20211026135046.5190e103.alex.williamson@redhat.com>
In-Reply-To: <20211026151851.GW2744544@nvidia.com>
References: <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <20211020185919.GH2744544@nvidia.com>
        <20211020150709.7cff2066.alex.williamson@redhat.com>
        <87o87isovr.fsf@redhat.com>
        <20211021154729.0e166e67.alex.williamson@redhat.com>
        <20211025122938.GR2744544@nvidia.com>
        <20211025082857.4baa4794.alex.williamson@redhat.com>
        <20211025145646.GX2744544@nvidia.com>
        <20211026084212.36b0142c.alex.williamson@redhat.com>
        <20211026151851.GW2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 12:18:51 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> 
> > > This is also why I don't like it being so transparent as it is
> > > something userspace needs to care about - especially if the HW cannot
> > > support such a thing, if we intend to allow that.  
> > 
> > Userspace does need to care, but userspace's concern over this should
> > not be able to compromise the platform and therefore making VF
> > assignment more susceptible to fatal error conditions to comply with a
> > migration uAPI is troublesome for me.  
> 
> It is an interesting scenario.
> 
> I think it points that we are not implementing this fully properly.
> 
> The !RUNNING state should be like your reset efforts.
> 
> All access to the MMIO memories from userspace should be revoked
> during !RUNNING
> 
> All VMAs zap'd.
> 
> All IOMMU peer mappings invalidated.
> 
> The kernel should directly block userspace from causing a MMIO TLP
> before the device driver goes to !RUNNING.
> 
> Then the question of what the device does at this edge is not
> relevant as hostile userspace cannot trigger it.
> 
> The logical way to implement this is to key off running and
> block/unblock MMIO access when !RUNNING.
> 
> To me this strongly suggests that the extra bit is the correct way
> forward as the driver is much simpler to implement and understand if
> RUNNING directly controls the availability of MMIO instead of having
> an irregular case where !RUNNING still allows MMIO but only until a
> pending_bytes read.
> 
> Given the complexity of this can we move ahead with the current
> mlx5_vfio and Yishai&co can come with some followup proposal to split
> the freeze/queice and block MMIO?

I know how much we want this driver in, but I'm surprised that you're
advocating to cut-and-run with an implementation where we've identified
a potentially significant gap with some hand waving that we'll resolve
it later.

Deciding at some point in the future to forcefully block device MMIO
access from userspace when the device stops running is clearly a user
visible change and therefore subject to the don't-break-userspace
clause.  It also seems to presume that the device relies on the
vfio-core to block device access, whereas device implementations may
not require such if they're able to snapshot device state.  That might
also indicate that "freeze" is only an implementation specific
requirement.  Thanks,

Alex

