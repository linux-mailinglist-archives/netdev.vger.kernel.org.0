Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36332E2D1
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCEHNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEHNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:13:40 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2121C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 23:13:39 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bm21so1456022ejb.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 23:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k1GfTiPAP3QZiMezcecwZbftT/v+/+G0GQNlw9iF1Ak=;
        b=pmG1VLEtzCTKjfxq4dvRG0atKEQugo8UZglmPbqC81gK/Fr5g+VGvMy/76JrfwSnLK
         07ykIzzTOuFoepQPKk7p6Vj60RBlJY5qtREhe65ZTSPOPXv+H0w2jsT7w5UNGiztkQmd
         g4Q084P94zp8sphtPlgEA/utS/O8oWOpcIf0wPlScxsYpEw1uyCLibdZhxGlMopSPC2z
         oKYKzDN3Q66GasHigeCt/lsKGTEWYksz7jqB8MHG8X17DkgLsJlVJB8hTyLWMVw+YXyb
         Y1c6B2Y8L5ohzyyhTMVcbATDQqRvHZngtO6lKd/sJssMJ1Z+yu81kIuNa39NFTD5lEIe
         wH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k1GfTiPAP3QZiMezcecwZbftT/v+/+G0GQNlw9iF1Ak=;
        b=YIWhcEUkTlG5dtBIkvL3sbWZY4heieF+u3cWqfPUS30jPR9kG+vZeyQiTjH9MF6ZLG
         14wTrVu6AYgoR0wOj16NLtTnL8CxoPfXwNLb60W4nuYCAihzdt/K8fDKYPk5yDoGeDYP
         Wh3HnFwhJceP3vqcJhdOoykUvo8iW6BRp6XzrBpy88eVpSZAZlqagZk97H3AUbAhT7f9
         u7Q5faWWA9z4XT/PsGiniVJPDVBxlb6RzodWXPBAgS+/CTvJqMIn6RP2rPRvLM7NVULy
         oZ784byxJhSPMg4z5Jk/sg/DCfPtmcHOaat151Aip6dx+1XHcOopbRIoKp8Aylhh8d8v
         S/dQ==
X-Gm-Message-State: AOAM531AC9Xilng0agrCOEChKMf5SFhjENE/Ir1trJRuW3rkxEahEHTw
        syvvo3TQlNlVU63UBMka/eA9HKsM9w4mq0L/1uUg
X-Google-Smtp-Source: ABdhPJwOgBKbc0p5luilLmC4G89tHxGpyiaJAx9UN/RKh/4o9Q+xxcmiIznAZfnEymjZhfuQfBa9Zffil+Sryg0rgOA=
X-Received: by 2002:a17:906:311a:: with SMTP id 26mr1076610ejx.395.1614928418569;
 Thu, 04 Mar 2021 23:13:38 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com> <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com> <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
 <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com>
In-Reply-To: <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 15:13:27 +0800
Message-ID: <CACycT3sUJNmi2BdLsi3W72+qTKQaCo_nQYu-fdxg9y4pAvBMow@mail.gmail.com>
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

On Fri, Mar 5, 2021 at 2:52 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 2:15 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
>
> Sorry if I've asked this before.
>
> But what's the reason for maintaing a dedicated IOTLB here? I think we
> could reuse vduse_dev->iommu since the device can not be used by both
> virtio and vhost in the same time or use vduse_iova_domain->iotlb for
> set_map().
>
> The main difference between domain->iotlb and dev->iotlb is the way to
> deal with bounce buffer. In the domain->iotlb case, bounce buffer
> needs to be mapped each DMA transfer because we need to get the bounce
> pages by an IOVA during DMA unmapping. In the dev->iotlb case, bounce
> buffer only needs to be mapped once during initialization, which will
> be used to tell userspace how to do mmap().
>
> Also, since vhost IOTLB support per mapping token (opauqe), can we use
> that instead of the bounce_pages *?
>
> Sorry, I didn't get you here. Which value do you mean to store in the
> opaque pointer=EF=BC=9F
>
> So I would like to have a way to use a single IOTLB for manage all kinds
> of mappings. Two possible ideas:
>
> 1) map bounce page one by one in vduse_dev_map_page(), in
> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd. Then
> for bounce pages, userspace still only need to map it once and we can
> maintain the actual mapping by storing the page or pa in the opaque
> field of IOTLB entry.
>
> Looks like userspace still needs to unmap the old region and map a new
> region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD ioctl.
>
>
> I don't get here. Can you give an example?
>

For example, userspace needs to process two I/O requests (one page per
request). To process the first request, userspace uses
VDUSE_IOTLB_GET_FD ioctl to query the iova region (0 ~ 4096) and mmap
it. To process the second request, userspace uses VDUSE_IOTLB_GET_FD
ioctl to query the new iova region and map a new region (0 ~ 8192).
Then userspace needs to traverse the list of iova regions and unmap
the old region (0 ~ 4096). Looks like this is a little complex.

Thanks,
Yongji
