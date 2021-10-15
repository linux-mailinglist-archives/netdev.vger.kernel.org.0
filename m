Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14DA42FD2A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhJOVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231545AbhJOVBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 17:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634331564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v99JWcKKrqW7DU+3CyphAVwqwj1tzyLiI7G6EPgS3Vo=;
        b=g0uvGgDaLqO0LTb49rnr8MuSVE8Bhbh9oh/8Wqn7q7lV85wPjoi8cprCtG6AQQUMgPInY7
        tJIbXnactUq+AcK3mVOuuHhEDIVLhUlVeZrDy8+mm1CvOlMiAzQzRXPH6yIziCGhuws2ro
        +uXmIX+9sBuL9Wf8xvgno+VXEvYAS+Y=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-amK1z8GEPO-rcZBUVFEZNA-1; Fri, 15 Oct 2021 16:59:23 -0400
X-MC-Unique: amK1z8GEPO-rcZBUVFEZNA-1
Received: by mail-ot1-f71.google.com with SMTP id i14-20020a056830402e00b0054dd0ce0d1dso6292440ots.19
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 13:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v99JWcKKrqW7DU+3CyphAVwqwj1tzyLiI7G6EPgS3Vo=;
        b=JdeoLpihJos9+FMz6PhqPVydHkfHrrHXfpcCTHXM0OcQljEPBcOjydASuuNDSVlg9S
         7sBRVV97Vhriv+MTgxSmJP0AtHuKzA0ph8/06NDiLvOufqKpOjWYghkpOeyrCtIo0z3S
         /di8lFFPZV1xYo1FkUTkn11krmpKPOZ7PrDzZiQe/8o71CBPp7smU8OyGfBw/ZMQo2Zu
         7elH9F7bZoO+TGZ33jdbZZwsX83QQAEPCnpSwY1n1fnxVOHGdpG5ZCrjTmyb1Bft9/+e
         6KsgCdQ6EK1AEj9TezouykINfS+sTlQh9k9V15XqqOlkoQORt8SB37pu5CQ96zw8kBiz
         LRIQ==
X-Gm-Message-State: AOAM5304vHDaTiclgA3Ga0GyPztM1AueqV3afl/RW+oUfUnZqf1OVdMr
        culwamzzDI5qZyywuh2uh6P95NNP85K4bS5ZLTVsjdl3uXspWCUAa3pJCNZFQjP4qcXUAbT3kmE
        ykxwZMCWTE+DA0ck0
X-Received: by 2002:aca:3e86:: with SMTP id l128mr12942167oia.120.1634331562758;
        Fri, 15 Oct 2021 13:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym7mNH86TE1dnlVg0esBKlyshh5+PxNWaTruNOVWx7TNl3EVM2DUbqX/P4AtRyh3rRBx9L6Q==
X-Received: by 2002:aca:3e86:: with SMTP id l128mr12942152oia.120.1634331562564;
        Fri, 15 Oct 2021 13:59:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v5sm1415847oix.6.2021.10.15.13.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 13:59:22 -0700 (PDT)
Date:   Fri, 15 Oct 2021 14:59:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211015145921.0abf7cb0.alex.williamson@redhat.com>
In-Reply-To: <20211015201654.GH2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-12-yishaih@nvidia.com>
        <20211015134820.603c45d0.alex.williamson@redhat.com>
        <20211015195937.GF2744544@nvidia.com>
        <20211015141201.617049e9.alex.williamson@redhat.com>
        <20211015201654.GH2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 17:16:54 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
> > On Fri, 15 Oct 2021 16:59:37 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:  
> > > > > +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> > > > > +				       u32 state)
> > > > > +{
> > > > > +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> > > > > +	u32 old_state = vmig->vfio_dev_state;
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> > > > > +		return -EINVAL;    
> > > > 
> > > > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))    
> > > 
> > > AFAICT this macro doesn't do what is needed, eg
> > > 
> > > VFIO_DEVICE_STATE_VALID(0xF000) == true
> > > 
> > > What Yishai implemented is at least functionally correct - states this
> > > driver does not support are rejected.  
> > 
> > 
> > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
> > 
> > old_state is controlled by the driver and can never have random bits
> > set, user state should be sanitized to prevent setting undefined bits.  
> 
> In that instance let's just write
> 
> old_state != VFIO_DEVICE_STATE_ERROR
> 
> ?

Not quite, the user can't set either of the other invalid states
either.

> 
> I'm happy to see some device specific mask selecting the bits it
> supports.

There are currently no optional bits within the mask, but the
RESUME|RUNNING state is rather TBD.  I figured we'd use flags in the
region info to advertise additional feature bits when it comes to that.
Thanks,

Alex

