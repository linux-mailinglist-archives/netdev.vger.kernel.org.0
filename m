Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113174354EB
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhJTVJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:09:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhJTVJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634764035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LudZt1LikP2qvwJT5NV0ZH9XpRMU1nt0Zd6YW0CIgBk=;
        b=hZkMnLikmnN1HWB9pbRldxVfAOYLTh8c57Bk8rFf/kETT/I75Q2KekZc5oYoH26aObBDSf
        AZNrdcFUSQhCCGVFRGiPQrYCuWoEERQ/rQprqbRvGI6aht1nAm+/hE4HfDsBl45wbiHVZt
        Y+VwWEkgJR0awESFGbzD9AqTI6ynjvk=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-Pr_O2J8yPwCMlxefafi9GQ-1; Wed, 20 Oct 2021 17:07:13 -0400
X-MC-Unique: Pr_O2J8yPwCMlxefafi9GQ-1
Received: by mail-oo1-f71.google.com with SMTP id o8-20020a4aabc8000000b002b601d1fb33so3790718oon.23
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 14:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LudZt1LikP2qvwJT5NV0ZH9XpRMU1nt0Zd6YW0CIgBk=;
        b=pPdmLtq7DJKy6DrjyPhTXBM1hgQ951b2HOyhucg/BFmqm4fH7gYjhBcrSQfaZSeVKN
         kKzCUJg2t6mkTDE8rUogarnUPMzs3j3o2JDzBEPT6sdP1lFSv7axXwrILRxjetDc7/W9
         w0Vf3r6hDQdHKVshO6WG/xoCQXjc96S9r8EYmbkkqu9k2a0058nX9h+BecSBQhKBfNSz
         Pgc5EfXSj5ptPRdhg32sL4IIiHTvRLH2lk5lkTEfHVYxxM+ZyI+8igz6jN7M9qq45fFM
         r30s7E4ydO/xqcOBqX4L5Qoldmg+6xzf0VZV2wcsK79a8WQoE5v9yXkG4u3MOmywdeRb
         5GZg==
X-Gm-Message-State: AOAM533n35eZUmlwip7hPPjUzZjqNfivqqaySLPWFDXvETuPXZDLoVc/
        DhsNhTPG9sWVColYWKKekmygEzPOnahq+Fryf4V4EDbG4V7l0gNL4gFnJ/e1Rurr7wzazEnlGTu
        Ibr54V9RHvmAk5Efu
X-Received: by 2002:a05:6808:124b:: with SMTP id o11mr1433370oiv.1.1634764032652;
        Wed, 20 Oct 2021 14:07:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSqTE6Jsjle0a7eGnYIXixW4xhZALBq3/tyZIF8DSzw72ba7CeI6EE3sHXL8OySnKnEaUa6w==
X-Received: by 2002:a05:6808:124b:: with SMTP id o11mr1433350oiv.1.1634764032381;
        Wed, 20 Oct 2021 14:07:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o21sm598520oou.21.2021.10.20.14.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:07:12 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:07:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211020150709.7cff2066.alex.williamson@redhat.com>
In-Reply-To: <20211020185919.GH2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-13-yishaih@nvidia.com>
        <20211019124352.74c3b6ba.alex.williamson@redhat.com>
        <20211019192328.GZ2744544@nvidia.com>
        <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <20211020185919.GH2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 15:59:19 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 20, 2021 at 10:52:30AM -0600, Alex Williamson wrote:
> 
> > I'm wondering if we're imposing extra requirements on the !_RUNNING
> > state that don't need to be there.  For example, if we can assume that
> > all devices within a userspace context are !_RUNNING before any of the
> > devices begin to retrieve final state, then clearing of the _RUNNING
> > bit becomes the device quiesce point and the beginning of reading
> > device data is the point at which the device state is frozen and
> > serialized.  No new states required and essentially works with a slight
> > rearrangement of the callbacks in this series.  Why can't we do that?  
> 
> It sounds worth checking carefully. I didn't come up with a major
> counter scenario.
> 
> We would need to specifically define which user action triggers the
> device to freeze and serialize. Reading pending_bytes I suppose?

The first read of pending_bytes after clearing the _RUNNING bit would
be the logical place to do this since that's what we define as the start
of the cycle for reading the device state.

"Freezing" the device is a valid implementation, but I don't think it's
strictly required per the uAPI.  For instance there's no requirement
that pending_bytes is reduced by data_size on each iteratio; we
specifically only define that the state is complete when the user reads
a pending_bytes value of zero.  So a driver could restart the device
state if the device continues to change (though it's debatable whether
triggering an -errno on the next migration region access might be a
more supportable approach to enforce that userspace has quiesced
external access).

> Since freeze is a device command we need to be able to report failure
> and to move the state to error, that feels bad hidden inside reading
> pending_bytes.

That seems like the wrong model.  Reading pending_bytes can return
-errno should an error occur during freeze/serialize, but device_state
is never implicitly modified.  Upon encountering an error reading
pending_bytes, userspace would abort the migration and move the
device_state to a new value.  This is the point at which the driver
would return another -errno to indicate an unrecoverable internal
error, or honor the requested new state.

> > Maybe a clarification of the uAPI spec is sufficient to achieve this,
> > ex. !_RUNNING devices may still update their internal state machine
> > based on external access.  Userspace is expected to quiesce all external
> > access prior to initiating the retrieval of the final device state from
> > the data section of the migration region.  Failure to do so may result
> > in inconsistent device state or optionally the device driver may induce
> > a fault if a quiescent state is not maintained.  
> 
> But on the other hand this seem so subtle and tricky way to design a
> uAPI that devices and users are unlikely to implement it completely
> correctly.

I think it's only tricky if device_state is implicitly modified by
other actions, stopping all devices before collecting the state of any
of them seems like a reasonable requirement.  It's the same requirement
we'd add with an NDMA bit.

> IMHO the point of the state is to control the current behavior of the
> device - yes we can control behavior on other operations, but it feels
> obfuscated.

It is, don't do that.  Fail the migration region operation, fail the
next device state transition if the internal error is irrecoverable.
 
> Especially when the userspace that needs to know about this isn't even
> deployed yet, let's just do it cleanly?

That's an option, but again I'm wondering if we're imposing a
requirement on the !_RUNNING state that doesn't really exist and a
clean solution exists already.  Thanks,

Alex

