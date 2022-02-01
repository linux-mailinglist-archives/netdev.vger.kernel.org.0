Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431704A61D8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbiBAREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:04:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241374AbiBAREO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643735054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaP8KxAvLh1LNosubcUnzm5ADA1WUWrY6mLgom77lbw=;
        b=DIkrgDShfgO+NkC30zUtvvoOuhfRsKYxYcKF6do0fIMWltpTbhcYlhqA0uyJKFLjta0HBt
        bJsDyXx0fbp/3DRsWZib7fszJ77uWXhsDLzRLY+uCIDNwCGJKDPJoQCwleT5IC6zZfb0Xd
        wajZcy48ZLEkZtb2hlgAgHa8/JIEMJw=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-pnPoGNcwNROosCLZ1XaGcA-1; Tue, 01 Feb 2022 12:04:13 -0500
X-MC-Unique: pnPoGNcwNROosCLZ1XaGcA-1
Received: by mail-oi1-f197.google.com with SMTP id bd39-20020a056808222700b002cd93cfaad4so10699520oib.12
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 09:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HaP8KxAvLh1LNosubcUnzm5ADA1WUWrY6mLgom77lbw=;
        b=HOVSFdUTJ0zq+reINk/ZW4bgRsPzbSTJ4czUT6kLvBuZv9xvfTD9jPbLOIlwJ2rwK+
         up50HRBCmoOAEXmKz0VJ2PsqiDz/o8qY2+8mlJQHCjkddYg5r9VdjEQopqrNjPZASK0z
         Ma3KRY5b8oQHk0O397DNLAXl2CE/hzANLRu8ZR+1WnrFx+gbYol3s7V6lnYfePugjSen
         4bWj24CXM4NY9848SVYDjCzRaMXGRsWu+FNpNsahMSlSfEFg05wmFNh1IqZ7E+cBm5g/
         1xfaa/C7A04Z7JL6/h8fRM1Xe9H+6zMwOJ2kwP2UxOhNwlDd3vCm7ACgsmLeAEAvd3fD
         N5ww==
X-Gm-Message-State: AOAM531GRUhBbKkM4ziH35DxQXkjekDB5GMQh9MgvtuI9Pe3VhK7LcrP
        ueEGAc/NRYwsCWoFBFAorN12RVHbCGioMvymi3N3j2ChJ0LuutTnKYbwieZioDJDpYFRJE5bdhu
        rgaA2x6vzZzsBMHxD
X-Received: by 2002:a05:6808:1590:: with SMTP id t16mr1823484oiw.232.1643735051759;
        Tue, 01 Feb 2022 09:04:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMjDQDxU4HmO3Y8DyO6BaAYkGGKEcpgCS6V05gNDO7FGcol+auJ8qLU06UxCLWL/4533WeAA==
X-Received: by 2002:a05:6808:1590:: with SMTP id t16mr1823463oiw.232.1643735051432;
        Tue, 01 Feb 2022 09:04:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d21sm5504515otq.68.2022.02.01.09.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:04:11 -0800 (PST)
Date:   Tue, 1 Feb 2022 10:04:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201100408.4a68df09.alex.williamson@redhat.com>
In-Reply-To: <20220201003124.GZ1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-9-yishaih@nvidia.com>
        <20220131164318.3da9eae5.alex.williamson@redhat.com>
        <20220201003124.GZ1786498@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 20:31:24 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jan 31, 2022 at 04:43:18PM -0700, Alex Williamson wrote:
> > On Sun, 30 Jan 2022 18:08:19 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:  
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index ef33ea002b0b..d9162702973a 100644
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -605,10 +605,10 @@ struct vfio_region_gfx_edid {
> > >  
> > >  struct vfio_device_migration_info {
> > >  	__u32 device_state;         /* VFIO device state */
> > > -#define VFIO_DEVICE_STATE_STOP      (0)
> > > -#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> > > -#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> > > -#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> > > +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> > > +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> > > +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> > > +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)  
> > 
> > I assume the below is kept until we rip out all the references, but I'm
> > not sure why we're bothering to define V1 that's not used anywhere
> > versus just deleting the above to avoid collision with the new enum.  
> 
> I felt adding the deletion made this patch too big so I shoved it into
> its own patch after the v2 stuff is described. The rename here is only
> because we end up with a naming conflict with the enum below.

Right, but we could just as easily delete the above 4 lines here to
avoid the conflict rather than renaming them to V1.

> > > + * If this function fails and returns -1 then the device_state is updated with
> > > + * the current state the device is in. This may be the original operating state
> > > + * or some other state along the combination transition path. The user can then
> > > + * decide if it should execute a VFIO_DEVICE_RESET, attempt to return to the
> > > + * original state, or attempt to return to some other state such as RUNNING or
> > > + * STOP. If errno is set to EOPNOTSUPP, EFAULT or ENOTTY then the device_state
> > > + * output is not reliable.  
> > 
> > I haven't made it through the full series yet, but it's not clear to me
> > why these specific errnos are being masked above.  
> 
> Basically, we can't return the device_state unless we properly process
> the ioctl. Eg old kernels that do not support this will return ENOTTY
> and will not update it. If userspace messed up the pointer EFAULT will
> be return and it will not be updated, finally EOPNOTSUPP is a generic
> escape for any future reason the kernel might not want to update it.
> 
> In practice, I found no use for using the device_state in the error
> path in qemu, but it seemed useful for debugging.


Ok, let me parrot back to see if I understand.  -ENOTTY will be
returned if the ioctl doesn't exist, in which case device_state is
untouched and cannot be trusted.  At the same time, we expect the user
to use the feature ioctl to make sure the ioctl exists, so it would
seem that we've reclaimed that errno if we believe the user should
follow the protocol.

-EOPNOTSUPP is returned both if the driver doesn't support migration
(which should be invalid based on the protocol).  ie. this:

+       if (!device->ops->migration_set_state)
+               return -EOPNOTSUPP;

Should return -ENOTTY, just as the feature does.  But it's also for
future unsupported ops, but couldn't we also specify that the driver
must fill final_state with the current device state for any such case.
We also have this:

+       if (set_state.argsz < minsz || set_state.flags)
+               return -EOPNOTSUPP;

Which I think should be -EINVAL.

That leaves -EFAULT, for example:

+       if (copy_from_user(&set_state, arg, minsz))
+               return -EFAULT;

Should we be able to know the current device state in core code such
that we can fill in device state here?

I think those changes would go a ways towards fully specified behavior
instead of these wishy washy unreliable return values.  Then we could
also get rid of this paranoia protection of those errnos:

+       if (IS_ERR(filp)) {
+               if (WARN_ON(PTR_ERR(filp) == -EOPNOTSUPP ||
+                           PTR_ERR(filp) == -ENOTTY ||
+                           PTR_ERR(filp) == -EFAULT))
+                       filp = ERR_PTR(-EINVAL);
+               goto out_copy;
+       }

Also, the original text of this uapi paragraph reads:

 "If this function fails and returns -1 then..."

Could we clarify that to s/function/ioctl/?  It caused me a moment of
confusion for the returned -errnos.

> > > + * If the new_state starts a new data transfer session then the FD associated
> > > + * with that session is returned in data_fd. The user is responsible to close
> > > + * this FD when it is finished. The user must consider the migration data
> > > + * segments carried over the FD to be opaque and non-fungible. During RESUMING,
> > > + * the data segments must be written in the same order they came out of the
> > > + * saving side FD.  
> > 
> > The lifecycle of this FD is a little sketchy.  The user is responsible
> > to close the FD, are they required to?  
> 
> No. Detecting this in the kernel would be notable added complexity to
> the drivers.
> 
> Let's clarify it:
> 
>  "close this FD when it no longer has data to
>  read/write. data_fds are not re-used, every data transfer session gets
>  a new FD."
> 
> ?


Better


> > ie. should the migration driver fail transitions if there's an
> > outstanding FD?  
> 
> No, the driver should orphan that FD and use a fresh new one the next
> cycle. mlx5 will sanitize the FD, free all the memory, and render it
> inoperable which I'd view as best practice.

Agreed, can we add a second sentence to the above clarification to
outline those driver responsibilities?


> > Should the core code mangle the f_ops or force and EOF or in some
> > other way disconnect the FD to avoid driver bugs/exploits with users
> > poking stale FDs?    
> 
> We looked at swapping f_ops of a running fd for the iommufd project
> and decided it was not allowed/desired. It needs locking.
> 
> Here the driver should piggy back the force EOF using its own existing
> locking protecting concurrent read/write, like mlx5 did. It is
> straightforward.

Right, sounded ugly but I thought I'd toss it out.  If we define it as
the driver's responsibility, I think I'm ok.

> > Should we be bumping a reference on the device FD such that we can't
> > have outstanding migration FDs with the device closed (and
> > re-assigned to a new user)?  
> 
> The driver must ensure any activity triggered by the migration FD
> against the vfio_device is halted before close_device() returns, just
> like basically everything else connected to open/close_device(). mlx5
> does this by using the same EOF sanitizing the FSM logic uses.
> 
> Once sanitized the f_ops should not be touching the vfio_device, or
> even have a pointer to it, so there is no reason to connect the two
> FDs together. I'd say it is a red flag if a driver proposes to do
> this, likely it means it has a problem with the open/close_device()
> lifetime model.

Maybe we just need a paragraph somewhere to describe the driver
responsibilities and expectations in managing the migration FD,
including disconnecting it after end of stream and access relative to
the open state of the vfio_device.  Seems an expanded descriptions
somewhere near the declaration in vfio_device_ops would be appropriate.

> > > + * Setting device_state to VFIO_DEVICE_STATE_ERROR will always fail with EINVAL,
> > > + * and take no action. However the device_state will be updated with the current
> > > + * value.
> > > + *
> > > + * Return: 0 on success, -1 and errno set on failure.
> > > + */
> > > +struct vfio_device_mig_set_state {
> > > +	__u32 argsz;
> > > +	__u32 device_state;
> > > +	__s32 data_fd;
> > > +	__u32 flags;
> > > +};  
> > 
> > argsz and flags layout is inconsistent with all other vfio ioctls.  
> 
> OK
> 
> >   
> > > +
> > > +#define VFIO_DEVICE_MIG_SET_STATE _IO(VFIO_TYPE, VFIO_BASE + 21)  
> > 
> > Did you consider whether this could also be implemented as a
> > VFIO_DEVICE_FEATURE?  Seems the feature struct would just be
> > device_state and data_fd.  Perhaps there's a use case for GET as well.
> > Thanks,  
> 
> Only briefly..
> 
> I'm not sure what the overall VFIO vision is here.. Are we abandoning
> traditional ioctls in favour of a multiplexer? Calling the multiplexer
> ioctl "feature" is a bit odd..

Is it really?  VF Token support is a feature that a device might have
and we can use the same interface to probe that it exists as well as
set the UUID token.  We're using it to manipulate the state of a device
feature.

If we're only looking for a means to expose that a device has support
for something, our options are a flag bit on the vfio_device_info or a
capability on that ioctl.  It's arguable that the latter might be a
better option for VFIO_DEVICE_FEATURE_MIGRATION since its purpose is
only to return a flags field, ie. we're not interacting with a feature,
we're exposing a capability with fixed properties.

However as we move to MIG_SET_SET, well now we are interacting with a
feature of the device and there's really nothing unique about the
calling convention that would demand that we define a stand alone ioctl.

> It complicates the user code a bit, it is more complicated to invoke the
> VFIO_DEVICE_FEATURE (check the qemu patch to see the difference).

Is it really any more than some wrapper code?  Are there objections to
this sort of multiplexer?  As I was working on the VF Token support, it
felt like a fairly small device feature and I didn't want to set a
precedent of cluttering our ioctl space with every niche little
feature.  The s390 folks have some proposals on list for using features
and I'm tempted to suggest it to Abhishek as well for their
implementation of D3cold support.
 
> Either way I don't have a strong opinion, please have a think and let
> us know which you'd like to follow.

I'm leaning towards a capability for migration support flags and a
feature for setting the state, but let me know if this looks like a bad
idea for some reason.  Thanks,

Alex

