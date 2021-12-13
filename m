Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F322471F75
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 04:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhLMDCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 22:02:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231396AbhLMDCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 22:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639364573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxOabwkEindQZF6MGwQBuVfsE6zoaQZTzHZYhX63BQo=;
        b=GOpgqNfXTutkdm88/h2FItW2pNLUyU6nPNUSaJ5SMFxKiRSb2oXuZSXFsYBfJkUBDccM6d
        j6quUTcQWAUfDF6bq/r4aiJES4Pu7C9y07+PmsoHu87MJaVrZmilRRu6arAr8wfjKj953C
        Re1z2Sq3AbqEwz/yqbNLxSI2ku1oHDQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-Y89oifpZNEOoCgEpkpF1CQ-1; Sun, 12 Dec 2021 22:02:52 -0500
X-MC-Unique: Y89oifpZNEOoCgEpkpF1CQ-1
Received: by mail-lf1-f71.google.com with SMTP id f15-20020a056512228f00b004037c0ab223so6897771lfu.16
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 19:02:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nxOabwkEindQZF6MGwQBuVfsE6zoaQZTzHZYhX63BQo=;
        b=LK5dsTreA3DfgxGz+18I0W19R61tXoUsIHJCrJ0XCd8dpMrd4FTtp8qIrCeG3s5nA6
         yRfz06svXhkXeEzkq6maS2Za19HF5hjlcGSAE4rRuvjwWroutDwiD6b5Ex+g72O0QvEg
         qNsP857er5uyaXzfv+si45QUogQgn57xcgtcYdxP8cpFnd3uiuYHzfZsbOVFmVnRotUz
         ElQK8xEjeQICWrGxSxeQ0qPt2q4UynApmFCIgL1FTd3aKUsI1x8KJ/az5Avyul+42IRD
         ME47UEzqjrvF7/4XVkJJENhBRtMFGJa0fmbh98TEkxRa1cv4hxHBk/lJpO8NtPEJZk86
         U+UA==
X-Gm-Message-State: AOAM532DcaM12zKp9OTr5wlbdNLFn+1RLN4QgtfFRYsHwexXAHNJRrgF
        ou251JNfPTju9UdUDGEhtyUpN67AAWEqHmF5/gMHrAobh1QXnQN8rKYFS18d1zlybRbByUIs1Bv
        9fkkG1j7fvl1AxQGU3ltiuXcOntdBAp4x
X-Received: by 2002:a05:6512:685:: with SMTP id t5mr26856512lfe.84.1639364570844;
        Sun, 12 Dec 2021 19:02:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5YjAaU+iCN3crQtYXKFT1QFcD9uiG0DVl+ekuAMuR8f5VXyCMPs5sUjKsAPXinXqyC3IjWG913Ka1GX6K2p4=
X-Received: by 2002:a05:6512:685:: with SMTP id t5mr26856481lfe.84.1639364570566;
 Sun, 12 Dec 2021 19:02:50 -0800 (PST)
MIME-Version: 1.0
References: <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org> <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org> <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org> <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211212042311-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 13 Dec 2021 11:02:39 +0800
Message-ID: <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 5:26 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > Sorry for reviving this ancient thread. I was kinda lost for the conclu=
sion
> > it ended up with. I have the following questions,
> >
> > 1. legacy guest support: from the past conversations it doesn't seem th=
e
> > support will be completely dropped from the table, is my understanding
> > correct? Actually we're interested in supporting virtio v0.95 guest for=
 x86,
> > which is backed by the spec at
> > https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm not =
sure
> > if there's request/need to support wilder legacy virtio versions earlie=
r
> > beyond.
>
> I personally feel it's less work to add in kernel than try to
> work around it in userspace. Jason feels differently.
> Maybe post the patches and this will prove to Jason it's not
> too terrible?

That's one way, other than the config access before setting features,
we need to deal with other stuffs:

1) VIRTIO_F_ORDER_PLATFORM
2) there could be a parent device that only support 1.0 device

And a lot of other stuff summarized in spec 7.4 which seems not an
easy task. Various vDPA parent drivers were written under the
assumption that only modern devices are supported.

Thanks

>
> > 2. suppose some form of legacy guest support needs to be there, how do =
we
> > deal with the bogus assumption below in vdpa_get_config() in the short =
term?
> > It looks one of the intuitive fix is to move the vdpa_set_features call=
 out
> > of vdpa_get_config() to vdpa_set_config().
> >
> >         /*
> >          * Config accesses aren't supposed to trigger before features a=
re
> > set.
> >          * If it does happen we assume a legacy guest.
> >          */
> >         if (!vdev->features_valid)
> >                 vdpa_set_features(vdev, 0);
> >         ops->get_config(vdev, offset, buf, len);
> >
> > I can post a patch to fix 2) if there's consensus already reached.
> >
> > Thanks,
> > -Siwei
>
> I'm not sure how important it is to change that.
> In any case it only affects transitional devices, right?
> Legacy only should not care ...
>
>
> > On 3/2/2021 2:53 AM, Jason Wang wrote:
> > >
> > > On 2021/3/2 5:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> > > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > > On 2021/3/1 5:34 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote:
> > > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > > Detecting it isn't enough though, we will need a new ioctl =
to notify
> > > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > > know what the use
> > > > > > > case there will be for kernel to leverage such info
> > > > > > > directly? Is there a
> > > > > > > case QEMU can't do with dedicate ioctls later if there's inde=
ed
> > > > > > > differentiation (legacy v.s. modern) needed?
> > > > > > BTW a good API could be
> > > > > >
> > > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > >
> > > > > > we did it per vring but maybe that was a mistake ...
> > > > >
> > > > > Actually, I wonder whether it's good time to just not support
> > > > > legacy driver
> > > > > for vDPA. Consider:
> > > > >
> > > > > 1) It's definition is no-normative
> > > > > 2) A lot of budren of codes
> > > > >
> > > > > So qemu can still present the legacy device since the config
> > > > > space or other
> > > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > > accessed by
> > > > > guest directly. Qemu can do the endian conversion when necessary
> > > > > in this
> > > > > case?
> > > > >
> > > > > Thanks
> > > > >
> > > > Overall I would be fine with this approach but we need to avoid bre=
aking
> > > > working userspace, qemu releases with vdpa support are out there an=
d
> > > > seem to work for people. Any changes need to take that into account
> > > > and document compatibility concerns.
> > >
> > >
> > > Agree, let me check.
> > >
> > >
> > > >   I note that any hardware
> > > > implementation is already broken for legacy except on platforms wit=
h
> > > > strong ordering which might be helpful in reducing the scope.
> > >
> > >
> > > Yes.
> > >
> > > Thanks
> > >
> > >
> > > >
> > > >
> > >
>

