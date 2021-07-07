Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B0E3BE554
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhGGJMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhGGJMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:12:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A788C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 02:09:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id l24so2408956edr.11
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 02:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FtdRj0uqhbWYJv1fXc78UI5Oym+NbdH9ODlpZg+9HZI=;
        b=UP2gxo7E+OXts94W4XG8ov25acIgy16F7Xuv5WNUryBRLvnB1SUdOumUACfAPoJmFS
         52RE8R7P3qzg1tarx6KjKAKEHb0Dj5puUCLSt4CliZJpugu/J1PeSwvG09Sv8SfFplGU
         DBap5eLBxTmFKW9K2PAgbKQ4UW5jIafViUeCgIHHk0GQV9Tv4AoOXsa2pQcvvdtk0UEk
         qzg8jcE6bFOHgPnYLfHRZZTw0XzS/1JMmDSF7Xh2WYY8wHkQJK4LhvVclPWJCWFgWaoK
         6TQcVcEEhAqleM8ofZK+PMsZBBDsQDwSyML/MSyfSeinKDg97GhQwRNlPXflVJHElUst
         mqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FtdRj0uqhbWYJv1fXc78UI5Oym+NbdH9ODlpZg+9HZI=;
        b=TuYnqiMNT6Qk0JZRYcLb0uLoqENzT13QULTnjLgs1EIhhGXH9r+t4byco6YhDcQVQb
         0XgX1TQ3fVMtQWsQcGDRrN5EOHhxYdEf9rvhzc7XGbVwdv3DW26FyTbz1kcoSmB7wynG
         8MN0vZKoy+70l0SXH3At5sO5LSsJDbDCTnj0hzL8R6ScuwhHgv6C+0VBNvQifhPY7peN
         oI+upS9y8drIUKH8bfNOLMaFbbVN+8Bc90RFc8djSMDZwlkGEQvZWRNH7dXp8P2jF6sU
         MIgkvercHIztExbi7DW4hn79ljM4rWL4t/X0dfcBLDTRO+vyN+lIEiPJS5wAT5Mhk58f
         kH9A==
X-Gm-Message-State: AOAM532ZRpIDm4wkPsfADvwDTi+SllstuHA1Wmfn8muZk9HZ5IcXPj94
        xvwyfHib/DlW3Zhmd0kg7Zj0e9KaYg90V6PD3rU+
X-Google-Smtp-Source: ABdhPJwtLvo0kWOr3LJJHVAL2cWB4hYaaS7KjefICks1FsWVhmQrnAQXN0teABT1P1UQsj+keI5UW3/FiAWPPwjYY38=
X-Received: by 2002:a05:6402:31ae:: with SMTP id dj14mr23195138edb.145.1625648964822;
 Wed, 07 Jul 2021 02:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain> <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain> <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain> <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com> <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <CACycT3t-BTMrpNTwBUfbvaxTh6tLthxbo3OJwMk_iuiSpMuZPg@mail.gmail.com> <YOQu8dB6tlb9juNz@stefanha-x1.localdomain>
In-Reply-To: <YOQu8dB6tlb9juNz@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 7 Jul 2021 17:09:13 +0800
Message-ID: <CACycT3t=V-VV7LYDda8mt=QxN_Ay-N+3dgWp382TObkeei9MOg@mail.gmail.com>
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Tue, Jul 6, 2021 at 6:22 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jul 06, 2021 at 11:04:18AM +0800, Yongji Xie wrote:
> > On Mon, Jul 5, 2021 at 8:50 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> > >
> > > On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
> > > >
> > > > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie =E5=86=99=E9=
=81=93:
> > > > > > > OK, I get you now. Since the VIRTIO specification says "Devic=
e
> > > > > > > configuration space is generally used for rarely-changing or
> > > > > > > initialization-time parameters". I assume the VDUSE_DEV_SET_C=
ONFIG
> > > > > > > ioctl should not be called frequently.
> > > > > > The spec uses MUST and other terms to define the precise requir=
ements.
> > > > > > Here the language (especially the word "generally") is weaker a=
nd means
> > > > > > there may be exceptions.
> > > > > >
> > > > > > Another type of access that doesn't work with the VDUSE_DEV_SET=
_CONFIG
> > > > > > approach is reads that have side-effects. For example, imagine =
a field
> > > > > > containing an error code if the device encounters a problem unr=
elated to
> > > > > > a specific virtqueue request. Reading from this field resets th=
e error
> > > > > > code to 0, saving the driver an extra configuration space write=
 access
> > > > > > and possibly race conditions. It isn't possible to implement th=
ose
> > > > > > semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case,=
 but it
> > > > > > makes me think that the interface does not allow full VIRTIO se=
mantics.
> > > >
> > > >
> > > > Note that though you're correct, my understanding is that config sp=
ace is
> > > > not suitable for this kind of error propagating. And it would be ve=
ry hard
> > > > to implement such kind of semantic in some transports.  Virtqueue s=
hould be
> > > > much better. As Yong Ji quoted, the config space is used for
> > > > "rarely-changing or intialization-time parameters".
> > > >
> > > >
> > > > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And =
to
> > > > > handle the message failure, I'm going to add a return value to
> > > > > virtio_config_ops.get() and virtio_cread_* API so that the error =
can
> > > > > be propagated to the virtio device driver. Then the virtio-blk de=
vice
> > > > > driver can be modified to handle that.
> > > > >
> > > > > Jason and Stefan, what do you think of this way?
> > >
> > > Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
> > >
> >
> > We add a timeout and return error in case userspace never replies to
> > the message.
> >
> > > The VIRTIO spec provides no way for the device to report errors from
> > > config space accesses.
> > >
> > > The QEMU virtio-pci implementation returns -1 from invalid
> > > virtio_config_read*() and silently discards virtio_config_write*()
> > > accesses.
> > >
> > > VDUSE can take the same approach with
> > > VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
> > >
> >
> > I noticed that virtio_config_read*() only returns -1 when we access a
> > invalid field. But in the VDUSE case, VDUSE_DEV_GET_CONFIG might fail
> > when we access a valid field. Not sure if it's ok to silently ignore
> > this kind of error.
>
> That's a good point but it's a general VIRTIO issue. Any device
> implementation (QEMU userspace, hardware vDPA, etc) can fail, so the
> VIRTIO specification needs to provide a way for the driver to detect
> this.
>
> If userspace violates the contract then VDUSE needs to mark the device
> broken. QEMU's device emulation does something similar with the
> vdev->broken flag.
>
> The VIRTIO Device Status field DEVICE_NEEDS_RESET bit can be set by
> vDPA/VDUSE to indicate that the device is not operational and must be
> reset.
>

It might be a solution. But DEVICE_NEEDS_RESET  is not implemented
currently. So I'm thinking whether it's ok to add a check of
DEVICE_NEEDS_RESET status bit in probe function of virtio device
driver (e.g. virtio-blk driver). Then VDUSE can make use of it to fail
device initailization when configuration space access failed.

Thanks,
Yongji
