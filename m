Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D153532E346
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCEH70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhCEH7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:59:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD2EC06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 23:59:14 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b7so1289045edz.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 23:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kfcdi5i4Dla+kLcu7HczxYYRqU9dNa/w3fqv/WIar8k=;
        b=ulZpSNIJCkHo3znvU2/lQnVodWmIUwSNKFlZlnAUvgJg1FujRXyV/u5SsqIoc231/x
         qc89Dz4kf62UhSw8YIPzpGccZGr9T/rpEQEEk7P4JbQ9p5g/Ik5pEzB8vxJJz4WIVChV
         j219LU19EmZH6GNrK8gkL4KWeKt91uUQwmbEs7iTJuan0jkvTtgaHctT4uyb+Q2ugM7Q
         /2dTHc35nGuk5QJkBSlalrqX9VfSVt8UTE/vozNxHIHaC+SpHpgj1N5VSu78AmMXSd/x
         YAfef4RG6Bbcif+ajErrhNun78fPOPNZm2l6QE6lIGcxSZMtxxjprATsjT1A8juKMBvE
         UJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kfcdi5i4Dla+kLcu7HczxYYRqU9dNa/w3fqv/WIar8k=;
        b=Sx3VNLgr/KNHa/NnyMi1bM5viu4llg3sIAQ6KyuDkYRAJ9sJIHCL1dDqmvZBZ08ksN
         5fC6+lpSAqeo3bYEPWoY//JlCCKW1QqaapaIGDj4Bv6CrXPztihmfbbX172oEYttlRTL
         wolZOiB9WCRkYbe1cLiAoBIL1Y1oq2/DJuGC/+2oEZuzzGJ16u44ryhMIMMS98r3l7Cw
         xNhsnrG5s94/035RW+xdfKRzYcJVQndFi7Ifolx2/mOj13Uc5XaHQo2G9n6ju7Wxv82q
         FgSB21YNtOPwX/sm/k16pPBe6U3woAqn8k0xup2zoGZs+qJi08Wy1gfVEZqaQaT0AUDE
         mULA==
X-Gm-Message-State: AOAM533QPiM/Rbv6CqQuu5lGQ+eU8z8ciTR/ssNL7ujuuNLZ+z8CrVe8
        Sr18sHVJUclJ2DYY0RN5nwocbHlrFt7j50gsXd9N
X-Google-Smtp-Source: ABdhPJxo2IyKxqbcHc4crFIXpHbr8uovLre7lWJCxwDJZflxxsWu1WDgrAtMQt1ymCeFzENr1Ydroi1DBvTLEstPGNA=
X-Received: by 2002:a05:6402:180b:: with SMTP id g11mr7896239edy.195.1614931153317;
 Thu, 04 Mar 2021 23:59:13 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com> <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com> <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
 <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com> <CACycT3sUJNmi2BdLsi3W72+qTKQaCo_nQYu-fdxg9y4pAvBMow@mail.gmail.com>
 <2652f696-faf7-26eb-a8b2-c4cfe3aaed15@redhat.com>
In-Reply-To: <2652f696-faf7-26eb-a8b2-c4cfe3aaed15@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 15:59:02 +0800
Message-ID: <CACycT3uMV9wg5yVKmEJpbZrs3x0b4+b9eNcUTh3+CjxsG7x2LA@mail.gmail.com>
Subject: Re: Re: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 3:27 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 3:13 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 2:52 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 2:15 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>
> >> Sorry if I've asked this before.
> >>
> >> But what's the reason for maintaing a dedicated IOTLB here? I think we
> >> could reuse vduse_dev->iommu since the device can not be used by both
> >> virtio and vhost in the same time or use vduse_iova_domain->iotlb for
> >> set_map().
> >>
> >> The main difference between domain->iotlb and dev->iotlb is the way to
> >> deal with bounce buffer. In the domain->iotlb case, bounce buffer
> >> needs to be mapped each DMA transfer because we need to get the bounce
> >> pages by an IOVA during DMA unmapping. In the dev->iotlb case, bounce
> >> buffer only needs to be mapped once during initialization, which will
> >> be used to tell userspace how to do mmap().
> >>
> >> Also, since vhost IOTLB support per mapping token (opauqe), can we use
> >> that instead of the bounce_pages *?
> >>
> >> Sorry, I didn't get you here. Which value do you mean to store in the
> >> opaque pointer=EF=BC=9F
> >>
> >> So I would like to have a way to use a single IOTLB for manage all kin=
ds
> >> of mappings. Two possible ideas:
> >>
> >> 1) map bounce page one by one in vduse_dev_map_page(), in
> >> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd. The=
n
> >> for bounce pages, userspace still only need to map it once and we can
> >> maintain the actual mapping by storing the page or pa in the opaque
> >> field of IOTLB entry.
> >>
> >> Looks like userspace still needs to unmap the old region and map a new
> >> region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD ioctl.
> >>
> >>
> >> I don't get here. Can you give an example?
> >>
> > For example, userspace needs to process two I/O requests (one page per
> > request). To process the first request, userspace uses
> > VDUSE_IOTLB_GET_FD ioctl to query the iova region (0 ~ 4096) and mmap
> > it.
>
>
> I think in this case we should let VDUSE_IOTLB_GET_FD return the maximum
> range as far as they are backed by the same fd.
>

But now the bounce page is mapped one by one. The second page (4096 ~
8192) might not be mapped when userspace is processing the first
request. So the maximum range is 0 ~ 4096 at that time.

Thanks,
Yongji
