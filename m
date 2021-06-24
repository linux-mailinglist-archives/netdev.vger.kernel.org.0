Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BABA3B266F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhFXEtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhFXEtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:49:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34553C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 21:46:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ji1so7426670ejc.4
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 21:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qV+mylXL/2SS4mJCMLehWyslEuC3Qq8x/PXCguBgY/I=;
        b=yLsRfVae0FF0DXCc80Qe7rbCzVIrdmQDyeaVXSgU7731bg1QMqw4lgqLCxjyZUZjwu
         TDH7cb0lIajOurwizpXzJMb1Ld/YEZ/vOZ/tKUWon1ytyFmk7qtEyniUaT9wfomHXaCZ
         Q5k7DOlqy4oW2+TRbKidZkfTZk1foP9dbr9CEZLKOgBzOUjNXSWZEPhSFmyl+eKMt16P
         UetkLAJ4Ll73DccWxMTSvwQYbyiWwHF4SXeF68p10765hT8FeXCxeTOqWo6XDYYUASaW
         U0fLxWjMmOWM2r455SZayrz6m1rBoWQox1axwCaI6sMaC6VcTv4xi2V6T6wMsgxpGUUR
         4qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qV+mylXL/2SS4mJCMLehWyslEuC3Qq8x/PXCguBgY/I=;
        b=HyGh1a+5ajYvjXvWLxRqsKx4o7RjeVVbP9Ob73rTb9Gbjtar4bsWUesoEmkOtKZRn0
         riMMVHZbX7qGHwAsFn8xQ0t4okgr6CfVS8omh5YIAE/MQOg3H/NrEFMYPY2V5cwZjeB+
         OZN0jff8la45Rt18Hh5nIhjXDZvg4dFO9rjikM3TFVLZy3HezEKvXISR5TD8oTTM7cJJ
         2K78rKGJMi1KboA5bT4INna3OlkBInQCNsFu0wg7tuHdFeli9ZkF9r7iu3kTqcGs46jm
         hcZ20d7DazI4141Oiku4su1zf54iCso+SymfCCBDL7L3FijzkBb0qQ2f+sPUY+vGx72o
         CbXA==
X-Gm-Message-State: AOAM533b0dhh/ALHb+U6b+ri0ycVmv0kZZIy8TvZ1+vwnb3CqeTDKj8C
        yOnEkJkm5MK8i8GZUnKaeAgo3KRO+36K1d5O5QEq
X-Google-Smtp-Source: ABdhPJxLv6gMYjF4IzwXDzBGPms1QJcwsfrq54qSD0tH6LJ386sUw0R2U1ERHQHkfRm0DArekdU8YwZzZP3+ubsA+P4=
X-Received: by 2002:a17:906:3c4a:: with SMTP id i10mr3283231ejg.372.1624510001769;
 Wed, 23 Jun 2021 21:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com> <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com> <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com>
In-Reply-To: <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 24 Jun 2021 12:46:30 +0800
Message-ID: <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:35 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/23 =E4=B8=8B=E5=8D=881:50, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Wed, Jun 23, 2021 at 11:31 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=884:14, Yongji Xie =E5=86=99=E9=81=
=93:
> >>> On Tue, Jun 22, 2021 at 3:50 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> =E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=883:22, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>>>> We need fix a way to propagate the error to the userspace.
> >>>>>>
> >>>>>> E.g if we want to stop the deivce, we will delay the status reset =
until
> >>>>>> we get respose from the userspace?
> >>>>>>
> >>>>> I didn't get how to delay the status reset. And should it be a DoS
> >>>>> that we want to fix if the userspace doesn't give a response foreve=
r?
> >>>> You're right. So let's make set_status() can fail first, then propag=
ate
> >>>> its failure via VHOST_VDPA_SET_STATUS.
> >>>>
> >>> OK. So we only need to propagate the failure in the vhost-vdpa case, =
right?
> >>
> >> I think not, we need to deal with the reset for virtio as well:
> >>
> >> E.g in register_virtio_devices(), we have:
> >>
> >>           /* We always start by resetting the device, in case a previo=
us
> >>            * driver messed it up.  This also tests that code path a
> >> little. */
> >>         dev->config->reset(dev);
> >>
> >> We probably need to make reset can fail and then fail the
> >> register_virtio_device() as well.
> >>
> > OK, looks like virtio_add_status() and virtio_device_ready()[1] should
> > be also modified if we need to propagate the failure in the
> > virtio-vdpa case. Or do we only need to care about the reset case?
> >
> > [1] https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedan=
ce.com/
>
>
> My understanding is DRIVER_OK is not something that needs to be validated=
:
>
> "
>
> DRIVER_OK (4)
> Indicates that the driver is set up and ready to drive the device.
>
> "
>
> Since the spec doesn't require to re-read the and check if DRIVER_OK is
> set in 3.1.1 Driver Requirements: Device Initialization.
>
> It's more about "telling the device that driver is ready."
>
> But we don have some status bit that requires the synchronization with
> the device.
>
> 1) FEATURES_OK, spec requires to re-read the status bit to check whether
> or it it was set by the device:
>
> "
>
> Re-read device status to ensure the FEATURES_OK bit is still set:
> otherwise, the device does not support our subset of features and the
> device is unusable.
>
> "
>
> This is useful for some device which can only support a subset of the
> features. E.g a device that can only work for packed virtqueue. This
> means the current design of set_features won't work, we need either:
>
> 1a) relay the set_features request to userspace
>
> or
>
> 1b) introduce a mandated_device_features during device creation and
> validate the driver features during the set_features(), and don't set
> FEATURES_OK if they don't match.
>
>
> 2) Some transports (PCI) requires to re-read the status to ensure the
> synchronization.
>
> "
>
> After writing 0 to device_status, the driver MUST wait for a read of
> device_status to return 0 before reinitializing the device.
>
> "
>
> So we need to deal with both FEATURES_OK and reset, but probably not
> DRIVER_OK.
>

OK, I see. Thanks for the explanation. One more question is how about
clearing the corresponding status bit in get_status() rather than
making set_status() fail. Since the spec recommends this way for
validation which is done in virtio_dev_remove() and
virtio_finalize_features().

Thanks,
Yongji
