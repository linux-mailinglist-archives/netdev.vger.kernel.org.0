Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC93E3F79
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 07:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhHIF5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 01:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhHIF5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 01:57:03 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E85C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 22:56:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b15so2834596ejg.10
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 22:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1QKCwJXH7b2bV95pG+j9QIMKAhZHvf1ykyTmniZz1n8=;
        b=Tz23BY9lPnQ3vIL8d7cY3bYV2IhYyaRUOu6xQBORJN4cz8W0au9Gfbaf8lAUsNVPjB
         tAe8PYHGpUriBFSopttHCQqPoMMqR1rexL5EnAAhvV7l1kBuiWYPDjMEaayMcy4xi6aA
         5uuCDZ/qs9RJhz3WH8weHBsQyMPk7q4EdO+FETqAWaWTUAwpTlufojrgm+S4Uy1A1zXZ
         ZIxfVRVGOJA3AjSm25fOEwYePUK2HcOeOIwdB6uMCtposnKf/XtfViVOX2BxRLFe5OIJ
         L4Gu9IBkOOJTcyhBSto5DUifQ4gSNns3GbgdZ0iDqXV+q6HNfQZu9lYsJfT7RE/U4CCP
         sTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1QKCwJXH7b2bV95pG+j9QIMKAhZHvf1ykyTmniZz1n8=;
        b=NvRqAtqXygjx9CpKG7ZYlTFML7IuEAJ6gjV+7xVLUbWC1ULqe6Dc9Cx4KoAMmEy7Jz
         1vQ3qMKLvn980UetIoI7RVAf5mkN/0lW9KK5OmrJayjVtXzMQR9jiwQ+RN3dlx03sTKA
         WKKA+pjtfwH7sMXQznHrsIfmJUJhGz5tiAK6b4GRKIi7DeI/NA45juduQM6icO/Epq0D
         6Lryw8Ru85Dp78UfqilEvIeBz0eZA8LYkNlMSfuM5mqKmlp7G2g4bn/P0HT+SNjzxzIl
         Vi8Rr55iebF9UyEKqk/Wiyxm7LQhLmvBQMz6OcIUPTWYpcrKgIkvm87kMn4yfUO+8mwt
         AxoA==
X-Gm-Message-State: AOAM532IByYyWLGC1N8IGsmbc/ejigGVKeDd3CLBuFLx+cBwTH14/Aup
        Jg4nxEV7sDJdsdJTgKSLGxv/izO1EsopAm6rAfdL
X-Google-Smtp-Source: ABdhPJytSHJOcxF9+rpBixPa7fMmae2NjP3sPUJopLOrs0pFpyMSkYVK2NfzI4kxhNLm4dqCFsDdPFoJRqjc++Vk9j4=
X-Received: by 2002:a17:907:3e0d:: with SMTP id hp13mr20504923ejc.372.1628488602064;
 Sun, 08 Aug 2021 22:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com> <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com> <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
 <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com> <CACycT3vARzvd4-dkZhDHqUkeYoSxTa2ty0z0ivE1znGti+n1-g@mail.gmail.com>
 <8c381d3d-9bbd-73d6-9733-0f0b15c40820@redhat.com>
In-Reply-To: <8c381d3d-9bbd-73d6-9733-0f0b15c40820@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 9 Aug 2021 13:56:31 +0800
Message-ID: <CACycT3steXFeg7NRbWpo2J59dpYcumzcvM2zcPJAVe40-EvvEg@mail.gmail.com>
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and free_iova_fast()
To:     Jason Wang <jasowang@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 9:31 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/8/5 =E4=B8=8B=E5=8D=888:34, Yongji Xie =E5=86=99=E9=81=93:
> >> My main point, though, is that if you've already got something else
> >> keeping track of the actual addresses, then the way you're using an
> >> iova_domain appears to be something you could do with a trivial bitmap
> >> allocator. That's why I don't buy the efficiency argument. The main
> >> design points of the IOVA allocator are to manage large address spaces
> >> while trying to maximise spatial locality to minimise the underlying
> >> pagetable usage, and allocating with a flexible limit to support
> >> multiple devices with different addressing capabilities in the same
> >> address space. If none of those aspects are relevant to the use-case -
> >> which AFAICS appears to be true here - then as a general-purpose
> >> resource allocator it's rubbish and has an unreasonably massive memory
> >> overhead and there are many, many better choices.
> >>
> > OK, I get your point. Actually we used the genpool allocator in the
> > early version. Maybe we can fall back to using it.
>
>
> I think maybe you can share some perf numbers to see how much
> alloc_iova_fast() can help.
>

I did some fio tests[1] with a ram-backend vduse block device[2].

Following are some performance data:

                            numjobs=3D1   numjobs=3D2    numjobs=3D4   numj=
obs=3D8
iova_alloc_fast    145k iops      265k iops      514k iops      758k iops

iova_alloc            137k iops     170k iops      128k iops      113k iops

gen_pool_alloc   143k iops      270k iops      458k iops      521k iops

The iova_alloc_fast() has the best performance since we always hit the
per-cpu cache. Regardless of the per-cpu cache, the genpool allocator
should be better than the iova allocator.

[1] fio jobfile:

[global]
rw=3Drandread
direct=3D1
ioengine=3Dlibaio
iodepth=3D16
time_based=3D1
runtime=3D60s
group_reporting
bs=3D4k
filename=3D/dev/vda
[job]
numjobs=3D..

[2]  $ qemu-storage-daemon \
      --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server,nowait =
\
      --monitor chardev=3Dcharmonitor \
      --blockdev
driver=3Dhost_device,cache.direct=3Don,aio=3Dnative,filename=3D/dev/nullb0,=
node-name=3Ddisk0
\
      --export type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0,writable=3Don,n=
ame=3Dvduse-null,num-queues=3D16,queue-size=3D128

The qemu-storage-daemon can be builded based on the repo:
https://github.com/bytedance/qemu/tree/vduse-test.

Thanks,
Yongji
