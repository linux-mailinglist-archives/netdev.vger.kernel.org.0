Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26DB41C822
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345117AbhI2PS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345089AbhI2PS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632928636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJdqVhfU2lEDy7K+qwgUFw8t05s+Wh549DqDME5rELw=;
        b=KiQkdn6RyPKansGVpiC2GAlyOE/t1D1U5Y14OIbeNaC0EGUqe3vkmdGi+gNtKBm3hYucEF
        GuxNlsGeBXNWxHHVcnXxQE5ub0YGJ4puptA9/Nh8JIN0yZ3DrYYDXsI8yuSBBYChKveT72
        yeYqd1japg8lBxoR7OPP7ocqlsx6A2A=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-C66J71fYO7mUqwmSk9zP9w-1; Wed, 29 Sep 2021 11:17:14 -0400
X-MC-Unique: C66J71fYO7mUqwmSk9zP9w-1
Received: by mail-ot1-f69.google.com with SMTP id p7-20020a056830318700b0054749cce9bcso2103661ots.18
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KJdqVhfU2lEDy7K+qwgUFw8t05s+Wh549DqDME5rELw=;
        b=JrrMnupFDiMsmE3ry+mQtRjsWnvs/kYo3vfAgrVbmB0O/QgXxksWSCueP1JRkSV/xC
         BDsVj2UQ8AGPs7mP6PTC10Ar2c/fT6ojAlki5vPP2bx2e4a8eQLF6cOX+pEYXcO9Rgf/
         XBE4ocKx0fXzvtZXD5pCRfmmr1Gar2AvXeAM4SwJ187ILMQdkBp+c539WJ946Pp7XpqO
         05PB2bjlmVTz1ztCcBORbG4H8b9nwqv1XS4obYWczY49hNn9Xkm306iantUJd+Qsypp9
         UCTiAacysSDQjhZel4ZmjUkhmWT9PBXX654BV0ntcy9+Vbeo9AgANbCH7Xf7jptrZ301
         5VRw==
X-Gm-Message-State: AOAM531CiYX4wo30FvAD4JkrWp82fKUMZaEC99Xtf2VQiPgO/sZ3duXk
        rAcKKPqr9pTKgr2F/D/7qRXTQ8gFQQFDOZ1SzwRZCDZKI3YPjpVcQzQ1msr6hIl9d77iKNesQRf
        2fFnKmMHbIYaKtPIg
X-Received: by 2002:a05:6808:2003:: with SMTP id q3mr358694oiw.173.1632928633976;
        Wed, 29 Sep 2021 08:17:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrWi5uNUHq2Qo0KN0Jf8EQ89vT/YbWyPvtA3dX8CT03MREY/+avCjKTfnNw+zB4bp4T5UiTQ==
X-Received: by 2002:a05:6808:2003:: with SMTP id q3mr358670oiw.173.1632928633757;
        Wed, 29 Sep 2021 08:17:13 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id j4sm2288oia.56.2021.09.29.08.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:17:13 -0700 (PDT)
Date:   Wed, 29 Sep 2021 09:17:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210929091712.6390141c.alex.williamson@redhat.com>
In-Reply-To: <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
        <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
        <20210927164648.1e2d49ac.alex.williamson@redhat.com>
        <20210927231239.GE3544071@ziepe.ca>
        <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
        <20210929063551.47590fbb.alex.williamson@redhat.com>
        <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
        <20210929075019.48d07deb.alex.williamson@redhat.com>
        <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 17:36:59 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 9/29/2021 4:50 PM, Alex Williamson wrote:
> > On Wed, 29 Sep 2021 16:26:55 +0300
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >  
> >> On 9/29/2021 3:35 PM, Alex Williamson wrote:  
> >>> On Wed, 29 Sep 2021 13:44:10 +0300
> >>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >>>     
> >>>> On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:  
> >>>>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:  
> >>>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
> >>>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
> >>>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
> >>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> >>>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
> >>>>>>> +		},  
> >>>>>> Our state transition diagram is pretty weak on reachable transitions
> >>>>>> out of the _STOP state, why do we select only these two as valid?  
> >>>>> I have no particular opinion on specific states here, however adding
> >>>>> more states means more stuff for drivers to implement and more risk
> >>>>> driver writers will mess up this uAPI.  
> >>>> _STOP == 000b => Device Stopped, not saving or resuming (from UAPI).
> >>>>
> >>>> This is the default initial state and not RUNNING.
> >>>>
> >>>> The user application should move device from STOP => RUNNING or STOP =>
> >>>> RESUMING.
> >>>>
> >>>> Maybe we need to extend the comment in the UAPI file.  
> >>> include/uapi/linux/vfio.h:
> >>> ...
> >>>    *  +------- _RESUMING
> >>>    *  |+------ _SAVING
> >>>    *  ||+----- _RUNNING
> >>>    *  |||
> >>>    *  000b => Device Stopped, not saving or resuming
> >>>    *  001b => Device running, which is the default state
> >>>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>> ...
> >>>    * State transitions:
> >>>    *
> >>>    *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> >>>    *                (100b)     (001b)     (011b)        (010b)       (000b)
> >>>    * 0. Running or default state
> >>>    *                             |
> >>>                    ^^^^^^^^^^^^^
> >>> ...
> >>>    * 0. Default state of VFIO device is _RUNNING when the user application starts.
> >>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>>
> >>> The uAPI is pretty clear here.  A default state of _STOP is not
> >>> compatible with existing devices and userspace that does not support
> >>> migration.  Thanks,  
> >> Why do you need this state machine for userspace that doesn't support
> >> migration ?  
> > For userspace that doesn't support migration, there's one state,
> > _RUNNING.  That's what we're trying to be compatible and consistent
> > with.  Migration is an extension, not a base requirement.  
> 
> Userspace without migration doesn't care about this state.
> 
> We left with kernel now. vfio-pci today doesn't support migration, right 
> ? state is in theory is 0 (STOP).
> 
> This state machine is controlled by the migration SW. The drivers don't 
> move state implicitly.
> 
> mlx5-vfio-pci support migration and will work fine with non-migration SW 
> (it will stay with state = 0 unless someone will move it. but nobody 
> will) exactly like vfio-pci does today.
> 
> So where is the problem ?

So you have a device that's actively modifying its internal state,
performing I/O, including DMA (thereby dirtying VM memory), all while
in the _STOP state?  And you don't see this as a problem?

There's a major inconsistency if the migration interface is telling us
something different than we can actually observe through the behavior of
the device.  Thanks,

Alex

