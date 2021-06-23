Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E433B1366
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 07:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFWFwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 01:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFWFwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 01:52:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2771C061760
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 22:50:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd37so2106402ejc.3
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 22:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4GiuBeValxmP+XXrOzcRmIGN8AohLiEvZ/1N4xkfEsc=;
        b=1ojgGgahexzFXE9RdNLyeoPjvzgy1FuMSknCgn9K5GwXoXKChPXHlt8RFqJU6xJGuF
         Cgrqzm5EDspyu9pceCZQxvmPvCVRPYcOLwyyVOaWAFc+/73Sd1ei8PUVLb3hMJg85yGd
         OoiS+Tom58BzQ4gVjO0sTB3pg1TBBl4FTS0KCFKWgNCJHr3b6clNKWi9sch5PBKWSbC5
         hdgylXBSI1fEHL65mcL5+HqoUj0DqlN+Vgg5BbVMgsnjT5z5R29YjArWCkkrPQkSQcTP
         G0euaC5g3D/chfHTH21pgGDle3JiDm7q2fqGYTk+72WN78OHY9b3+JAT5mbt83TyJaUN
         rngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4GiuBeValxmP+XXrOzcRmIGN8AohLiEvZ/1N4xkfEsc=;
        b=X3/+ctNFNmMt+OX8V4D4kKOCcEN71EzWHPOSF8hJLjeIal8UNPy0lho4Xxc45VzhfL
         fpA4uadKcKnlY/RLJ5iVPD+iVvWKyFdiW9Z/XM5Xxyrfc9YqLTUJRQQxNMDNH9HhSR6G
         yKOYBoXy43iYlrsKn+0ZP4pae8KUE0KJuPfKMz0+o34cmm4+SoKiGzOlHsjQdxAgal7y
         LCpt+mWtpFy62HPpH4CvAUkpLLw4+PrCI9H2KKJr4z2Ix7vmuGpXBMXBRYQkNCpHuGA9
         J/sCD1s5AFRJ1vnrjPOjxuNOnexvRgz6RFb8EKr/aXv+fKVsTW54/Rp6pG6AMbrfjfQC
         D+9g==
X-Gm-Message-State: AOAM532EGcYueoUjmjYEV+5Unui9TIcfCYet2DoIF62D3CaYZqw/lLHP
        c9vVzVjo5O5Yf3oWanXQTbjvwcRd3pmAdqZ8Ev50
X-Google-Smtp-Source: ABdhPJwbg3yWypQN4cxrZmP3uYn4KoXMLaW0oW+bJJtUlpWP6iDiZd3Hcvf9/eWyaRh10eQQqnKlblyzvYXHH4O6Z7k=
X-Received: by 2002:a17:906:9a4f:: with SMTP id aj15mr7921850ejc.197.1624427411326;
 Tue, 22 Jun 2021 22:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com> <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
In-Reply-To: <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Jun 2021 13:50:00 +0800
Message-ID: <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
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

On Wed, Jun 23, 2021 at 11:31 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=884:14, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Tue, Jun 22, 2021 at 3:50 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=883:22, Yongji Xie =E5=86=99=E9=81=
=93:
> >>>> We need fix a way to propagate the error to the userspace.
> >>>>
> >>>> E.g if we want to stop the deivce, we will delay the status reset un=
til
> >>>> we get respose from the userspace?
> >>>>
> >>> I didn't get how to delay the status reset. And should it be a DoS
> >>> that we want to fix if the userspace doesn't give a response forever?
> >>
> >> You're right. So let's make set_status() can fail first, then propagat=
e
> >> its failure via VHOST_VDPA_SET_STATUS.
> >>
> > OK. So we only need to propagate the failure in the vhost-vdpa case, ri=
ght?
>
>
> I think not, we need to deal with the reset for virtio as well:
>
> E.g in register_virtio_devices(), we have:
>
>          /* We always start by resetting the device, in case a previous
>           * driver messed it up.  This also tests that code path a
> little. */
>        dev->config->reset(dev);
>
> We probably need to make reset can fail and then fail the
> register_virtio_device() as well.
>

OK, looks like virtio_add_status() and virtio_device_ready()[1] should
be also modified if we need to propagate the failure in the
virtio-vdpa case. Or do we only need to care about the reset case?

[1] https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedance.c=
om/

Thanks,
Yongji
