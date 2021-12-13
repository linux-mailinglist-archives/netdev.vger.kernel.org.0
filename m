Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694E1472216
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhLMIG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:06:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232733AbhLMIG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 03:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639382815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppFYv3R1teHWfY7IoGI+J3KcvC+92KTAnR33CqYPNrM=;
        b=b573VVKbB3337UybGzRHv8djg/byDvi0SVqLtDcXZyplcjrDRqVyr/Ylt6pN8Kkgw40mlF
        BtB5OGnWQFRkcZ7PqFARSTh63tIY65QI3FnLkC7xgExtFV0/NuskZ+4FtzST/yhfMWvkDM
        7IYDSlot84GGHWKxEbVkXmZbGO58NhY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-vLOB3lr8MuaWe_TNK0pI4g-1; Mon, 13 Dec 2021 03:06:54 -0500
X-MC-Unique: vLOB3lr8MuaWe_TNK0pI4g-1
Received: by mail-ed1-f70.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so13121112edq.16
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:06:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ppFYv3R1teHWfY7IoGI+J3KcvC+92KTAnR33CqYPNrM=;
        b=b5bz6tCuAG8Dmtl6PjDA3UtuxXXirPuX8g4rOsN51tbGHtBM7R2nxa1QiAEv3TK8ui
         gqzFW1JkzazIEKx8cYNWsHXEux8GGvt/2CYkMZLbv5CFIe4tJSUo3+HthxLq2paq8slS
         m4fR5DYWQ0mIEzT4A20dZ71NeWeRbG3+qssBX1rq+c+GHuYOE6rUaS3ndzuLPjWgnI4P
         GuCW/tiHoKkSUSbpQuyXK+FQNf0xFr2eJSfhtobvo+dEuJl5GV4+E4fi0WF0BZnFDsHl
         90EX6YpgP8h0V3PzftJnAX6MNMRVqlFIEJIR/KPMVjcppXror9SVT6zQA7mpSgSx+rPF
         ZJZA==
X-Gm-Message-State: AOAM5327gRRPdlkgLAgmgOZyeguLw1GJc2+naR0rdOH/3LT5BqVy/RQh
        48GQu7czY1x/kCb2Yxz97LEEsiuv6pkIEt0vw7hv7+xtbG3aBLspJyAlaV4KETXuCviFqfUs5La
        iXijnyxGOqwCRF5qS
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr60671504edw.74.1639382813057;
        Mon, 13 Dec 2021 00:06:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzLix4rVHAPEUnAuCm8F6B/tu/kAFRPY4UjJuE0IRdt+98l2KDOnJD1Bi6Ev1zJJARNW1hlQ==
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr60671484edw.74.1639382812833;
        Mon, 13 Dec 2021 00:06:52 -0800 (PST)
Received: from redhat.com ([2.55.148.125])
        by smtp.gmail.com with ESMTPSA id w5sm5992484edc.58.2021.12.13.00.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 00:06:52 -0800 (PST)
Date:   Mon, 13 Dec 2021 03:06:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Message-ID: <20211213030535-mutt-send-email-mst@kernel.org>
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 11:02:39AM +0800, Jason Wang wrote:
> On Sun, Dec 12, 2021 at 5:26 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > > Sorry for reviving this ancient thread. I was kinda lost for the conclusion
> > > it ended up with. I have the following questions,
> > >
> > > 1. legacy guest support: from the past conversations it doesn't seem the
> > > support will be completely dropped from the table, is my understanding
> > > correct? Actually we're interested in supporting virtio v0.95 guest for x86,
> > > which is backed by the spec at
> > > https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm not sure
> > > if there's request/need to support wilder legacy virtio versions earlier
> > > beyond.
> >
> > I personally feel it's less work to add in kernel than try to
> > work around it in userspace. Jason feels differently.
> > Maybe post the patches and this will prove to Jason it's not
> > too terrible?
> 
> That's one way, other than the config access before setting features,
> we need to deal with other stuffs:
> 
> 1) VIRTIO_F_ORDER_PLATFORM
> 2) there could be a parent device that only support 1.0 device
> 
> And a lot of other stuff summarized in spec 7.4 which seems not an
> easy task. Various vDPA parent drivers were written under the
> assumption that only modern devices are supported.
> 
> Thanks

Limiting things to x86 will likely address most issues though, won't it?

> >
> > > 2. suppose some form of legacy guest support needs to be there, how do we
> > > deal with the bogus assumption below in vdpa_get_config() in the short term?
> > > It looks one of the intuitive fix is to move the vdpa_set_features call out
> > > of vdpa_get_config() to vdpa_set_config().
> > >
> > >         /*
> > >          * Config accesses aren't supposed to trigger before features are
> > > set.
> > >          * If it does happen we assume a legacy guest.
> > >          */
> > >         if (!vdev->features_valid)
> > >                 vdpa_set_features(vdev, 0);
> > >         ops->get_config(vdev, offset, buf, len);
> > >
> > > I can post a patch to fix 2) if there's consensus already reached.
> > >
> > > Thanks,
> > > -Siwei
> >
> > I'm not sure how important it is to change that.
> > In any case it only affects transitional devices, right?
> > Legacy only should not care ...
> >
> >
> > > On 3/2/2021 2:53 AM, Jason Wang wrote:
> > > >
> > > > On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> > > > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > > > On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > > > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > > > know what the use
> > > > > > > > case there will be for kernel to leverage such info
> > > > > > > > directly? Is there a
> > > > > > > > case QEMU can't do with dedicate ioctls later if there's indeed
> > > > > > > > differentiation (legacy v.s. modern) needed?
> > > > > > > BTW a good API could be
> > > > > > >
> > > > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > >
> > > > > > > we did it per vring but maybe that was a mistake ...
> > > > > >
> > > > > > Actually, I wonder whether it's good time to just not support
> > > > > > legacy driver
> > > > > > for vDPA. Consider:
> > > > > >
> > > > > > 1) It's definition is no-normative
> > > > > > 2) A lot of budren of codes
> > > > > >
> > > > > > So qemu can still present the legacy device since the config
> > > > > > space or other
> > > > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > > > accessed by
> > > > > > guest directly. Qemu can do the endian conversion when necessary
> > > > > > in this
> > > > > > case?
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > Overall I would be fine with this approach but we need to avoid breaking
> > > > > working userspace, qemu releases with vdpa support are out there and
> > > > > seem to work for people. Any changes need to take that into account
> > > > > and document compatibility concerns.
> > > >
> > > >
> > > > Agree, let me check.
> > > >
> > > >
> > > > >   I note that any hardware
> > > > > implementation is already broken for legacy except on platforms with
> > > > > strong ordering which might be helpful in reducing the scope.
> > > >
> > > >
> > > > Yes.
> > > >
> > > > Thanks
> > > >
> > > >
> > > > >
> > > > >
> > > >
> >

