Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C40A42FCCF
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbhJOUOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:14:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242943AbhJOUOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 16:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634328725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=whcOO+02FvXs+Sz1ciQayugdA3SWFyNzKb7YhenlZf8=;
        b=cJR9nHeuqe5x3yqF1d7D8T/qrT0BJVVfRqdtoGDu1Ouv1A0neB2qm0zVaXB2KMcNquS71k
        rvS4WVbpdPM1KlcVdFa/1ZKlJ4VRXFCbEtfd2dmyU8j7LW3Ygg6h3mnlLkXdIywgUndYs1
        UYDOJSGchCZhZS6yGKRqZ5Y8rYNveB8=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-LywHxdg8PsuMfdejmvg8og-1; Fri, 15 Oct 2021 16:12:04 -0400
X-MC-Unique: LywHxdg8PsuMfdejmvg8og-1
Received: by mail-ot1-f70.google.com with SMTP id u19-20020a0568301f1300b005472c85a1feso6228999otg.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 13:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whcOO+02FvXs+Sz1ciQayugdA3SWFyNzKb7YhenlZf8=;
        b=o0QR6D68S7PMDNJjKcMCqnOB2YJ5z/Jirs65OlyiFAMxHpQSXvOH1IegEnRjR+uJJ1
         tGQfue4r058QJQstpEVsjnlxgLtINTaIvth7pAsRA2cW79Xhiu9fPREH/eiAWxs51CUT
         b2r75SoenLm6EcFALts0p5toMy+RnY9wCkfkvesXqP+DYHSERJ5L47qe4DkFESshn1Wl
         K6F5HuBZHmQV7bCztBxqcp31+CuwH/X09bA5QOYhdmPRvUPJofFnloeFrjFE8AyXQpzK
         OVL4Y2bYs9jUZolHLdUQGQD5cpPqmbQ/gJHzhr918hiWp3h/sQIAQNfjGHNiPmB9D3MW
         cGUA==
X-Gm-Message-State: AOAM530vS5FUN0Uh2ItFcS2DLakMmRKKNGB+otjsWp36l7oWTbhfHPmG
        mNXqkKhMCtQxKOSDpuFh7ySAWl/X05B4K4uxDeC+uOmB4evI7Nmq9fAmFnfegMu4XyFz97IjC8/
        Y4e5ycoOKzUb0P4si
X-Received: by 2002:aca:4283:: with SMTP id p125mr17745909oia.81.1634328723733;
        Fri, 15 Oct 2021 13:12:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfjhkeaYzT5JNHixixDnWGpW5N2lS54odgXxz4p4f3bD9+jTvu9sEvy0IZ2WRdaO7kGopYqw==
X-Received: by 2002:aca:4283:: with SMTP id p125mr17745898oia.81.1634328723500;
        Fri, 15 Oct 2021 13:12:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w17sm1330684otu.53.2021.10.15.13.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 13:12:03 -0700 (PDT)
Date:   Fri, 15 Oct 2021 14:12:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211015141201.617049e9.alex.williamson@redhat.com>
In-Reply-To: <20211015195937.GF2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-12-yishaih@nvidia.com>
        <20211015134820.603c45d0.alex.williamson@redhat.com>
        <20211015195937.GF2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 16:59:37 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
> > > +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> > > +				       u32 state)
> > > +{
> > > +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> > > +	u32 old_state = vmig->vfio_dev_state;
> > > +	int ret = 0;
> > > +
> > > +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> > > +		return -EINVAL;  
> > 
> > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))  
> 
> AFAICT this macro doesn't do what is needed, eg
> 
> VFIO_DEVICE_STATE_VALID(0xF000) == true
> 
> What Yishai implemented is at least functionally correct - states this
> driver does not support are rejected.


if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))

old_state is controlled by the driver and can never have random bits
set, user state should be sanitized to prevent setting undefined bits.


> > > +	/* Running switches off */
> > > +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
> > > +	    (state & VFIO_DEVICE_STATE_RUNNING) &&  
> > 
> > ((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) ?  
> 
> It is not functionally the same, xor only tells if the bit changed, it
> doesn't tell what the current value is, and this needs to know that it
> changed to 1

That's why I inserted my comment after the "it changed" test and not
after the "and the old old value was..." test below.

> > > +	    (old_state & VFIO_DEVICE_STATE_RUNNING)) {
> > > +		ret = mlx5vf_pci_quiesce_device(mvdev);
> > > +		if (ret)
> > > +			return ret;
> > > +		ret = mlx5vf_pci_freeze_device(mvdev);
> > > +		if (ret) {
> > > +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;  
> > 
> > 
> > No, the invalid states are specifically unreachable, the uAPI defines
> > the error state for this purpose.  
> 
> Indeed
> 
> > The states noted as invalid in the
> > uAPI should be considered reserved at this point.  If only there was a
> > macro to set an error state... ;)  
> 
> It should just assign a constant value, there is only one error state.

Fair enough.  Thanks,

Alex

