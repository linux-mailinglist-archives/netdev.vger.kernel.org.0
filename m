Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3A4A64BB
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiBATN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:13:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231952AbiBATN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643742806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Bv8VoBLV+1VuzuPIGW0d5N9XYcMTF/luFk9G3XTO14=;
        b=AMISmdryrUA0ekdZFGQ7ddAs8TIU8iZ6P+cKXL89BsW953xp1r8/AFxPBqKVbatV2UdyDL
        o5avPYfCppjoKR8Nk9PD4QCVaNn1DQxB422081sWGXb2meLwFBcaiSVaAoGw+dWALGuZYv
        umUJCxcFvg6oYI3UJeIjpcwlMdx1NVI=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-MeMiG3ecP0W7TFINlhFaaQ-1; Tue, 01 Feb 2022 14:13:25 -0500
X-MC-Unique: MeMiG3ecP0W7TFINlhFaaQ-1
Received: by mail-ot1-f70.google.com with SMTP id p17-20020a0568301d5100b005a3cd7c1e0bso6260732oth.7
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 11:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Bv8VoBLV+1VuzuPIGW0d5N9XYcMTF/luFk9G3XTO14=;
        b=QyyXn81hOehrgQLkBhJvvvjLU2OUg7UhTKGeGv2/rBFIRTQ2afDmca1rGa3p3N5lPQ
         3PRArOyIMAmiLq3+MAOWhxXEzo5PAKdGv+KlQc1rt/EHDDXaD6knHotHTxy7EXJVzH/5
         PBHd1WNewKLL97GmnBfcMYbC61/rgrHi3ktfq/DPZwKljX9+K8zuadBDkzZSZaJuTxTO
         wVwTukxb77itLqfcQ4F7hBU0tJ8Bez6W8CF258/wFepTG00VFF7NMWofgzQF1nTEnrKE
         5nrCE7Xx6WMTaagAdgRy9T1Ls9cC6j86P84chKVHdcvE7P44ZSckUUKP5sm0coJua11T
         6FjA==
X-Gm-Message-State: AOAM530P9EH/ZpFWl+X8znmEGrBwBeJIf2FARE/AyJEJgw+ucyutu4Oh
        buzWjHSRtLjZ3aBdwyVqjbUcQ/qeCctkQ6satljWNaqGnE+vCFzuzGawWV+xlDndLWEiV3MuLdt
        xvraLg2MJX7Gy6zwz
X-Received: by 2002:a05:6830:2304:: with SMTP id u4mr15013027ote.348.1643742804782;
        Tue, 01 Feb 2022 11:13:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQBKS3W6IUxBmPQTOQau2z0tBXaVcUDsVqIVj/M1dRNufpS6jseTjwATRhdirl/LBF777R4g==
X-Received: by 2002:a05:6830:2304:: with SMTP id u4mr15013011ote.348.1643742804541;
        Tue, 01 Feb 2022 11:13:24 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y19sm4928296oti.49.2022.02.01.11.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 11:13:23 -0800 (PST)
Date:   Tue, 1 Feb 2022 12:13:22 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220201121322.2f3ceaf2.alex.williamson@redhat.com>
In-Reply-To: <20220201185321.GM1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-10-yishaih@nvidia.com>
        <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
        <20220201185321.GM1786498@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 14:53:21 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 11:31:44AM -0700, Alex Williamson wrote:
> > > +	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
> > > +
> > >  	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
> > >  	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
> > >  		return VFIO_DEVICE_STATE_ERROR;
> > >  
> > > -	return vfio_from_fsm_table[cur_fsm][new_fsm];
> > > +	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
> > > +			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
> > > +		return VFIO_DEVICE_STATE_ERROR;  
> > 
> > new_fsm is provided by the user, we pass set_state.device_state
> > directly to .migration_set_state.  We should do bounds checking and
> > compatibility testing on the end state in the core so that we can  
> 
> This is the core :)

But this is the wrong place, we need to do it earlier rather than when
we're already iterating next states.  I only mention core to avoid that
I'm suggesting a per driver responsibility.

> 
> > return an appropriate -EINVAL and -ENOSUPP respectively, otherwise
> > we're giving userspace a path to put the device into ERROR state, which
> > we claim is not allowed.  
> 
> Userspace can never put the device into error. As the function comment
> says VFIO_DEVICE_STATE_ERROR is returned to indicate the arc is not
> permitted. The driver is required to reflect that back as an errno
> like mlx5 shows:
> 
> +		next_state = vfio_mig_get_next_state(vdev, mvdev->mig_state,
> +						     new_state);
> +		if (next_state == VFIO_DEVICE_STATE_ERROR) {
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> 
> We never get the driver into error, userspaces gets an EINVAL and no
> change to the device state.

Hmm, subtle.  I'd argue that if we do a bounds and support check of the
end state in vfio_ioctl_mig_set_state() before calling
.migration_set_state() then we could remove ERROR from
vfio_from_fsm_table[] altogether and simply begin
vfio_mig_get_next_state() with:

	if (cur_fsm = ERROR)
		return ERROR;

Then we only get to ERROR by the driver placing us in ERROR and things
feel a bit more sane to me.

> It is organized this way because the driver controls the locking for
> its current state and thus the core code caller along the ioctl path
> cannot validate the arc before passing it to the driver. The code is
> shared by having the driver callback to the core to validate the
> entire fsm arc under its lock.

P2P is defined in a way that if the endpoint is valid then the arc is
valid.  We skip intermediate unsupported states.  We need to do that
for compatibility.  So why do we care about driver locking to do that?
Thanks,

Alex

