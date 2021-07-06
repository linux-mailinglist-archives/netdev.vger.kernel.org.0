Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431FE3BC4F6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 05:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhGFDHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 23:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhGFDHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 23:07:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51063C061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 20:04:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l2so6554098edt.1
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 20:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LCgUQ9YXkJh4ceT+VmUThz5I8QlmLbs1I7Jug0v7X9c=;
        b=AniVf1hg8E84bf88GbqvkjR+BefQ1f0lgfPF37iHtxf/YNkU0AyXPnMQYAxXb02mbo
         G48TrGfyovbNsFXOaWMWb/wyYJ2otEbO4ALwFWjEp+ou6S1UnsrushF1eZx06kGNzJN8
         ZE+sG3ukhj23G3+11XF15U8C53r0c8X3EEc4Ok4kOBRxqvzy8189Ucu76sgW34Wbm8+X
         cTKFYWmWxoprLOtkLuVBPTW79tw5zhQYEEPwKl+lmcbOagdDirWCGWdkJ6EIa0dQXVy8
         dgnLZv4WULOteK3YLraIZY9wXPfWdUjgUnwLaGWun0yx5ionzoeg2EP/vsiH019ipKeh
         +bSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LCgUQ9YXkJh4ceT+VmUThz5I8QlmLbs1I7Jug0v7X9c=;
        b=PckznWgiSFamD4NB64oh4WFTWGFL+FmwlshHRjRupD0q/zp6t5RaPyQj97oSfaOO57
         4y6DtdnVO190SsMVcxzM9HNSw2amf4azWnHi1MT8BZPQYM9W9uGJsVa6n1UTprGOLtpt
         WN4Sx75MPRy3xQCKuf20GYXc3bt4CYWMIMALRtNlADBab+/JvyEawC07kXZLA+x+gh8a
         p9KzWzU5+jFmKxv/4bg8sUCvCKP5JIFYtfSKKEEJbyWTv81zbb9dL6xtdJ7Vi+MGbAYj
         AaZ83C+YADDh9WEW+iFN1bQkYMCibHOUHoi/lzvqAzcQ2NaB1tpzoHMQnGq31k72yDyA
         aOpw==
X-Gm-Message-State: AOAM533NVH1u3PCT5cJ+DJ5UewcnVwFHcy27UFBme5qDU8JPw3qBR3Ps
        haUa7aQpl0TGMDWkfwgqxNgasFhTQb8iQIBhiRBE
X-Google-Smtp-Source: ABdhPJxK8aaodUmVuDEfTR7oD0ZVR0H0WNfCSx96KkTtw1Uj+YwvZnEo/lcejGfXLnkvlfTU0w/nA3UorXy0nyt0lC8=
X-Received: by 2002:a50:ff01:: with SMTP id a1mr19688860edu.253.1625540668739;
 Mon, 05 Jul 2021 20:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain> <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain> <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain> <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com> <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
In-Reply-To: <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 6 Jul 2021 11:04:18 +0800
Message-ID: <CACycT3t-BTMrpNTwBUfbvaxTh6tLthxbo3OJwMk_iuiSpMuZPg@mail.gmail.com>
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

On Mon, Jul 5, 2021 at 8:50 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie =E5=86=99=E9=81=
=93:
> > > > > OK, I get you now. Since the VIRTIO specification says "Device
> > > > > configuration space is generally used for rarely-changing or
> > > > > initialization-time parameters". I assume the VDUSE_DEV_SET_CONFI=
G
> > > > > ioctl should not be called frequently.
> > > > The spec uses MUST and other terms to define the precise requiremen=
ts.
> > > > Here the language (especially the word "generally") is weaker and m=
eans
> > > > there may be exceptions.
> > > >
> > > > Another type of access that doesn't work with the VDUSE_DEV_SET_CON=
FIG
> > > > approach is reads that have side-effects. For example, imagine a fi=
eld
> > > > containing an error code if the device encounters a problem unrelat=
ed to
> > > > a specific virtqueue request. Reading from this field resets the er=
ror
> > > > code to 0, saving the driver an extra configuration space write acc=
ess
> > > > and possibly race conditions. It isn't possible to implement those
> > > > semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but=
 it
> > > > makes me think that the interface does not allow full VIRTIO semant=
ics.
> >
> >
> > Note that though you're correct, my understanding is that config space =
is
> > not suitable for this kind of error propagating. And it would be very h=
ard
> > to implement such kind of semantic in some transports.  Virtqueue shoul=
d be
> > much better. As Yong Ji quoted, the config space is used for
> > "rarely-changing or intialization-time parameters".
> >
> >
> > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
> > > handle the message failure, I'm going to add a return value to
> > > virtio_config_ops.get() and virtio_cread_* API so that the error can
> > > be propagated to the virtio device driver. Then the virtio-blk device
> > > driver can be modified to handle that.
> > >
> > > Jason and Stefan, what do you think of this way?
>
> Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
>

We add a timeout and return error in case userspace never replies to
the message.

> The VIRTIO spec provides no way for the device to report errors from
> config space accesses.
>
> The QEMU virtio-pci implementation returns -1 from invalid
> virtio_config_read*() and silently discards virtio_config_write*()
> accesses.
>
> VDUSE can take the same approach with
> VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
>

I noticed that virtio_config_read*() only returns -1 when we access a
invalid field. But in the VDUSE case, VDUSE_DEV_GET_CONFIG might fail
when we access a valid field. Not sure if it's ok to silently ignore
this kind of error.

Thanks,
Yongji
