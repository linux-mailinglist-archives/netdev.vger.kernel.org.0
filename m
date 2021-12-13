Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E850472A76
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbhLMKnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:43:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236693AbhLMKnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639392182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfuPpOABuCOUfJ766e10nvZWJe+DxQ1giE4QiO5fk8I=;
        b=EISxTI4ljbF/O2a1OiS/4XXfuqcadqcecWJKNYlg5venORvtqFa3iDVZZEbq8GtqoGQoue
        5YIneM5i+TKSAxoUdxrfa4ctBXadXWa3ItIJt7c07301bEobrkZYfhDVoBKeNgnN52lpd3
        sp63kGwg0Iqh8+zClC2r3UpsQTlOZzk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-yO5zo5UZPlKRph09YAW1pQ-1; Mon, 13 Dec 2021 05:43:00 -0500
X-MC-Unique: yO5zo5UZPlKRph09YAW1pQ-1
Received: by mail-ed1-f71.google.com with SMTP id n11-20020aa7c68b000000b003e7d68e9874so13549389edq.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 02:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PfuPpOABuCOUfJ766e10nvZWJe+DxQ1giE4QiO5fk8I=;
        b=WqetQEqVkwatd5olGCMRm3cP/ZxxZ2miNRKoUlX+apBRxk4Cii++JMTfX4gnUpFIZc
         l2y3OwvrtVQeoK0A/6TB5KBU5FxVblZ7lUIe4b02FBl3hIsnfRXclZai9o0jrz+bRF1K
         EyiQB8rdsplvqDIpXJChWSqGTRqvn6X6H2hWS6AOtiUBwAA7a+JxIvsC9DiureoIUzcs
         bsi9kUkkKQcb8TeafWhIczRs4pibNTakiZqwrJygdyWDo+iPAQhhWD+Vkzd7jZzukSvE
         XauHhRReqkBQaJIHTE9QTYhnzOLFdJQDkpM1I1DZ+7Qb0GY2ikrNoTmSkszMyTOQeWwy
         PIHw==
X-Gm-Message-State: AOAM530B3hQjm89UVb7eEYPFhylxlWZJW8J+D2Zr7vPOBhKuv5zkFBDq
        yLIO68+1zBf0hl0ufLlAmCVQnkRHu88Jd0jtU9ShXjy8ylQC9AXOCdRa/052CC5ptrXeZXfM7GT
        q8nVHhhFUUfvw9B7q
X-Received: by 2002:a50:bb2a:: with SMTP id y39mr61671542ede.348.1639392179559;
        Mon, 13 Dec 2021 02:42:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJye188DD7VOBZu1z7K1fsIYJwVvhudMERb9VekFgUrFgqwmr0f6OoIDcHbVxO67vqs6b5qZUg==
X-Received: by 2002:a50:bb2a:: with SMTP id y39mr61671520ede.348.1639392179371;
        Mon, 13 Dec 2021 02:42:59 -0800 (PST)
Received: from redhat.com ([2.55.148.125])
        by smtp.gmail.com with ESMTPSA id r11sm6278620edd.70.2021.12.13.02.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 02:42:58 -0800 (PST)
Date:   Mon, 13 Dec 2021 05:42:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Message-ID: <20211213053420-mutt-send-email-mst@kernel.org>
References: <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
 <20211213030535-mutt-send-email-mst@kernel.org>
 <CACGkMEtRfqRDPxXS2T-a0u4Aji3KtUq7-2iUD8Z-X1k84EgOZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtRfqRDPxXS2T-a0u4Aji3KtUq7-2iUD8Z-X1k84EgOZA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 04:57:38PM +0800, Jason Wang wrote:
> On Mon, Dec 13, 2021 at 4:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 13, 2021 at 11:02:39AM +0800, Jason Wang wrote:
> > > On Sun, Dec 12, 2021 at 5:26 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > > > > Sorry for reviving this ancient thread. I was kinda lost for the conclusion
> > > > > it ended up with. I have the following questions,
> > > > >
> > > > > 1. legacy guest support: from the past conversations it doesn't seem the
> > > > > support will be completely dropped from the table, is my understanding
> > > > > correct? Actually we're interested in supporting virtio v0.95 guest for x86,
> > > > > which is backed by the spec at
> > > > > https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm not sure
> > > > > if there's request/need to support wilder legacy virtio versions earlier
> > > > > beyond.
> > > >
> > > > I personally feel it's less work to add in kernel than try to
> > > > work around it in userspace. Jason feels differently.
> > > > Maybe post the patches and this will prove to Jason it's not
> > > > too terrible?
> > >
> > > That's one way, other than the config access before setting features,
> > > we need to deal with other stuffs:
> > >
> > > 1) VIRTIO_F_ORDER_PLATFORM
> > > 2) there could be a parent device that only support 1.0 device
> > >
> > > And a lot of other stuff summarized in spec 7.4 which seems not an
> > > easy task. Various vDPA parent drivers were written under the
> > > assumption that only modern devices are supported.
> > >
> > > Thanks
> >
> > Limiting things to x86 will likely address most issues though, won't it?
> 
> For the ordering, yes. But it means we need to introduce a config
> option for legacy logic?
> And we need to deal with, as you said in another thread, kick before DRIVER_OK:
> 
> E.g we had thing like this:
> 
>         if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
>             !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
>                 ret = ifcvf_request_irq(adapter);
>                 if (ret) {
> 
> Similar issues could be found in other parents.

The driver ok thing is mostly an issue for block where it
expects to access the disk directly during probe.

> We also need to consider whether we should encourage the vendor to
> implement the logic.
> 
> I think we can try and see how hard it is.
> 
> Thanks

Right. My point exactly.

> >
> > > >
> > > > > 2. suppose some form of legacy guest support needs to be there, how do we
> > > > > deal with the bogus assumption below in vdpa_get_config() in the short term?
> > > > > It looks one of the intuitive fix is to move the vdpa_set_features call out
> > > > > of vdpa_get_config() to vdpa_set_config().
> > > > >
> > > > >         /*
> > > > >          * Config accesses aren't supposed to trigger before features are
> > > > > set.
> > > > >          * If it does happen we assume a legacy guest.
> > > > >          */
> > > > >         if (!vdev->features_valid)
> > > > >                 vdpa_set_features(vdev, 0);
> > > > >         ops->get_config(vdev, offset, buf, len);
> > > > >
> > > > > I can post a patch to fix 2) if there's consensus already reached.
> > > > >
> > > > > Thanks,
> > > > > -Siwei
> > > >
> > > > I'm not sure how important it is to change that.
> > > > In any case it only affects transitional devices, right?
> > > > Legacy only should not care ...
> > > >
> > > >
> > > > > On 3/2/2021 2:53 AM, Jason Wang wrote:
> > > > > >
> > > > > > On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> > > > > > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > > > > > On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > > > > > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > > > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > > > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > > > > > know what the use
> > > > > > > > > > case there will be for kernel to leverage such info
> > > > > > > > > > directly? Is there a
> > > > > > > > > > case QEMU can't do with dedicate ioctls later if there's indeed
> > > > > > > > > > differentiation (legacy v.s. modern) needed?
> > > > > > > > > BTW a good API could be
> > > > > > > > >
> > > > > > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > > >
> > > > > > > > > we did it per vring but maybe that was a mistake ...
> > > > > > > >
> > > > > > > > Actually, I wonder whether it's good time to just not support
> > > > > > > > legacy driver
> > > > > > > > for vDPA. Consider:
> > > > > > > >
> > > > > > > > 1) It's definition is no-normative
> > > > > > > > 2) A lot of budren of codes
> > > > > > > >
> > > > > > > > So qemu can still present the legacy device since the config
> > > > > > > > space or other
> > > > > > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > > > > > accessed by
> > > > > > > > guest directly. Qemu can do the endian conversion when necessary
> > > > > > > > in this
> > > > > > > > case?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > > Overall I would be fine with this approach but we need to avoid breaking
> > > > > > > working userspace, qemu releases with vdpa support are out there and
> > > > > > > seem to work for people. Any changes need to take that into account
> > > > > > > and document compatibility concerns.
> > > > > >
> > > > > >
> > > > > > Agree, let me check.
> > > > > >
> > > > > >
> > > > > > >   I note that any hardware
> > > > > > > implementation is already broken for legacy except on platforms with
> > > > > > > strong ordering which might be helpful in reducing the scope.
> > > > > >
> > > > > >
> > > > > > Yes.
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > >
> > > > > > >
> > > > > > >
> > > > > >
> > > >
> >

