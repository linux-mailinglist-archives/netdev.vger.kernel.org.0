Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90171401636
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 08:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbhIFGKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 02:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbhIFGKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 02:10:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B26C061757
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 23:09:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v5so7961070edc.2
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 23:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLQZhgxKgfIDFt5lvdc2MzHzo2TIxIc31ByxAdyguDw=;
        b=odHfcBGsXMMsYB2K8Do9ItkBkMTq6LWsGfzwSwjDSZ150IpQF83y0vfBln5L7YVgiw
         3MpZwyeS+QD8McxuPPxYxbm0B8uAK5/6bNVzGCQ3vsq1gUyf9m37Tv+e5qVdZqDNjAev
         Xaqo2CLPu9Y3meToLpI9B7J78zGlu+7JUYZ4izYbDZgP2XtyOGajNL0pzHncLqlgsEVm
         4bIszAuRtDUfeh0uGsQB/wMMzlHe4FXMtOXP7CcKYI3X3EKfrVxan8x6W96Lfrgxnfnf
         VkoHn8zk2d48PQu1VwJZG2YCEYOwA1Adig/icsv06Ld2WfJcAwY0GQAelyk08s8IO8Ul
         YFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLQZhgxKgfIDFt5lvdc2MzHzo2TIxIc31ByxAdyguDw=;
        b=ByCNcbou+T0wl9RaG8+YMGKwdlV5ozgBMjf8vP0rp5ra07w4b3fvsFSgAzjXOMgUwC
         ryNZ2KaRjt7VG9HyUIw1ctzXwbSF/FJeCDvaL6vE8zaPm9RivohX2RCtB57sR66nKAy/
         y94/msvfZrLf1fey96lvSpmyKxVTa6URtgs3VuhM0OyPfhTniF2uIBjsHMzQXtKg991J
         nYJW4r0Th3fy4rHllrFe1y4we0Jjm+TXtrbKOoanzk9VXedVWDdsOevroxKIdDSUi+tg
         F0eR7su1ONJ0Cft4pVttxnXOT+h3LiqtVgH92JTnjee0SG6s/vRXoZyFEk010NYAPs2f
         yT2w==
X-Gm-Message-State: AOAM533AiAllr3D+EsHIEZ4Edv/CY8MSCdEdz4gFQGsYKwcy4zwGp7hz
        ObBjXvJw9MCnJF0IuBpsbKqURj35JFC7xY6T6FX/
X-Google-Smtp-Source: ABdhPJwAFlEIMtTqX/FnP+Pe+DBoVGCsW7XaaIAidi/YyhHjkzk2b+1T+9ejMprIIKa+g3AudWKBbxIRe912O1wmSz0=
X-Received: by 2002:a05:6402:4247:: with SMTP id g7mr11700392edb.287.1630908576144;
 Sun, 05 Sep 2021 23:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210831103634.33-1-xieyongji@bytedance.com> <20210831103634.33-6-xieyongji@bytedance.com>
 <20210906015524-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210906015524-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 6 Sep 2021 14:09:25 +0800
Message-ID: <CACycT3v4ZVnh7DGe_RtAOx4Vvau0km=HWyCM=KzKhD+ahYKafQ@mail.gmail.com>
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 1:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> > This adds a new callback to support device specific reset
> > behavior. The vdpa bus driver will call the reset function
> > instead of setting status to zero during resetting.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> This does gloss over a significant change though:
>
>
> > ---
> > @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
> >       return vdev->dma_dev;
> >  }
> >
> > -static inline void vdpa_reset(struct vdpa_device *vdev)
> > +static inline int vdpa_reset(struct vdpa_device *vdev)
> >  {
> >       const struct vdpa_config_ops *ops = vdev->config;
> >
> >       vdev->features_valid = false;
> > -     ops->set_status(vdev, 0);
> > +     return ops->reset(vdev);
> >  }
> >
> >  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>
>
> Unfortunately this breaks virtio_vdpa:
>
>
> static void virtio_vdpa_reset(struct virtio_device *vdev)
> {
>         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>
>         vdpa_reset(vdpa);
> }
>
>
> and there's no easy way to fix this, kernel can't recover
> from a reset failure e.g. during driver unbind.
>

Yes, but it should be safe with the protection of software IOTLB even
if the reset() fails during driver unbind.

Thanks,
Yongji
