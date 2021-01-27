Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB5D305664
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhA0JDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbhA0JAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:00:32 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3EDC06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:59:51 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f1so1439267edr.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rw8yUZegb4yxEqGgwbp3Nqb3zTKD2qO65+bJx8qvjDQ=;
        b=rxoSgpUALgCJbFIFKiPhxXAPyX8odUJ6YF7W7K1OO80Lqa2/eyBBguWA1Cmx2+9qIi
         eDM4GyvWFQh8BJv9awijipeIMNCIzJoavvmrAu1KgXpoN0nZMbhTYPuQfSK6Yn0OJ5HD
         YX9GTbpMFtzEZx+vVNCedpruNziRt2sNYtmU2nolnVylIuF15e5FX0mg1LHYVAJCUY1A
         ZQD0ydpwb8flTReZClu2d5oNuj8bQrC6yJSUYgycf6iDIfSuVOqmqWNFauWpcV+qjbuu
         xaHa6DmRFnrnrommb8x9U7p/NRCX6JnzK+IQFIYqJxmC8mLicgfXrj23FFCT0OmewJjk
         VxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rw8yUZegb4yxEqGgwbp3Nqb3zTKD2qO65+bJx8qvjDQ=;
        b=n6NWLWamKq3trWX/LDE18JCoidE9byaDnaLzc5I+ujTQ6OQVYq+xP4EswQKfiPGSop
         Kj3yj9BkAO0Ohbaf9pJLUw86Z2IsUiJEnHQmNTXqmznFv2YWyvOb3ElyccNwsAgsSnBQ
         iKAKGMht1LlgsaMbcQRUEVWg9nAnYKft+ySiFYcmKQciSgSlV1jt1wF1gEdvalkmDBEy
         W4Cpx5mX/yL4U+vHdZjDlTjFwNj36TPab0aEkzj5c/K5qJCaLjCl2cgm1tPnnGThgmkj
         d+vHC2io3ucWDxCwZbGxx/2oCjPDBYP8z7yIm06oye76Y802jqKtCMvMPovoPrYi1xL1
         mFsw==
X-Gm-Message-State: AOAM533bM8o7F/opgjtrsFeX1blz2ONdY25c9UT4au+DI8mL/JZ3LYsT
        Hax9QojsBDPWWepk9XHPWaWIL8upphyl1sAIq4Gz
X-Google-Smtp-Source: ABdhPJx51mihWsWUedzTQ87/wxlPosUbhcgbkadydrgOhjI8COenRfD2+yCv8E4CENKpyt9SeWNbKozPfxnYbMhHWss=
X-Received: by 2002:a05:6402:228a:: with SMTP id cw10mr7789120edb.195.1611737990371;
 Wed, 27 Jan 2021 00:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com> <1f419a24-cd53-bd73-5b8a-8ab5d976a490@redhat.com>
In-Reply-To: <1f419a24-cd53-bd73-5b8a-8ab5d976a490@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 27 Jan 2021 16:59:39 +0800
Message-ID: <CACycT3uOpYd37F7ZAE0cQxbKvpbsWszmDY_jh4RFKyeJFKQdsg@mail.gmail.com>
Subject: Re: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 4:19 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=881:07, Xie Yongji wrote:
> > This VDUSE driver enables implementing vDPA devices in userspace.
> > Both control path and data path of vDPA devices will be able to
> > be handled in userspace.
> >
> > In the control path, the VDUSE driver will make use of message
> > mechnism to forward the config operation from vdpa bus driver
> > to userspace. Userspace can use read()/write() to receive/reply
> > those control messages.
> >
> > In the data path, VDUSE_IOTLB_GET_FD ioctl will be used to get
> > the file descriptors referring to vDPA device's iova regions. Then
> > userspace can use mmap() to access those iova regions. Besides,
> > the eventfd mechanism is used to trigger interrupt callbacks and
> > receive virtqueue kicks in userspace.
> >
> > Signed-off-by: Xie Yongji<xieyongji@bytedance.com>
> > ---
> >   Documentation/driver-api/vduse.rst                 |   85 ++
> >   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >   drivers/vdpa/Kconfig                               |    7 +
> >   drivers/vdpa/Makefile                              |    1 +
> >   drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >   drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
> >   drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
> >   drivers/vdpa/vdpa_user/iova_domain.c               |  426 +++++++
> >   drivers/vdpa/vdpa_user/iova_domain.h               |   68 ++
> >   drivers/vdpa/vdpa_user/vduse.h                     |   62 +
> >   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1217 +++++++++++=
+++++++++
> >   include/uapi/linux/vdpa.h                          |    1 +
> >   include/uapi/linux/vduse.h                         |  125 ++
> >   13 files changed, 2267 insertions(+)
> >   create mode 100644 Documentation/driver-api/vduse.rst
> >   create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >   create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
> >   create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse.h
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >   create mode 100644 include/uapi/linux/vduse.h
>
>
> Btw, if you could split this into three parts:
>
> 1) iova domain
> 2) vduse device
> 3) doc
>
> It would be more easier for the reviewers.
>

Make sense to me. Will do it in v4.

Thanks,
Yongji
