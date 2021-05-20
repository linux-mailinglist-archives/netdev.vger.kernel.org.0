Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604E7389D18
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhETF0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhETF0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 01:26:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE405C061761
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 22:25:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id et19so16194689ejc.4
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 22:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWBM5AU+ZMmhfuFgx+3Y6a4UcjGbnQI1cx3aK/uVkZc=;
        b=GL+WlKsfyUHY8seOawsA4s5AlWavihDlxxMiz4lqDQkGQ3TCLutMAu4lMNn1Jxl1jd
         y6HZQBYQq4ioIg5e1Lo1gqt31jawj5s1SHuxpLit2ITf+CLm+kWietUyVpKk9w4fmD2p
         H1mq2ZWQ+t44wxCCc60m/5A3JNEqMh/2fd2x9LhB3LxkVed1yMz8Mpz7F/P0y2G397sv
         VSQF7iSQ5NJLrAtBZr6BqKr6Rz+PbkPQ/INLOdyfBiVRt3/wYV7gh1O0NplzDAANxyj3
         lbLjDfxqrMTZkAS3Dv9Xk96J7MuslFrqt1MYHRbQds+nk19xlmKW/1bKi0HXgU5HEy19
         xy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWBM5AU+ZMmhfuFgx+3Y6a4UcjGbnQI1cx3aK/uVkZc=;
        b=oioe9+NYRrVAqrEYOCxHqxEqN/+mlkiN4fPI/md7URjXYu7M0tLJNICjpCtJ4I6Djj
         w9XqH7tjj0wriUHm6ChRuFgG/24GJUrWGh9/loQGUM4U7p0h28Vit0gJlQeAKRkhZ/CY
         Bd59z67HZwAv3E44lKSmcWAOtpsPZBGjGzQyk+0DKmE3hxp1ZKqc9UvMXc+KEHkX5J6p
         jekV2zqq2QEX96DjTF+mNMTPAV4rCKs7PGg3+lxCjV+FZd/HT3ilzMKujskbDIZWxOcw
         9F37CyUDTFhpboQks8tamRaCDakHNLuMs93xSMGjTikczttzBOa562u6eD2bjQ7sZTaT
         xXdQ==
X-Gm-Message-State: AOAM530VXqASeTwczzqrHwh/bQA9egFGwJ6OICVNHv1gRlsNlJz64Pa2
        WTBimpWD0LcFz3RpGtVaA6W/nM2BdD1ukqVK8syi
X-Google-Smtp-Source: ABdhPJyvwWWA7f5Fzvsx4TdTu7nIvH6pnRUuPJ62OuR0bCAchfYi7vwKGliv4oVBF/L7UoIrnWNYnk0fkzFFBOuZgj8=
X-Received: by 2002:a17:906:edaf:: with SMTP id sa15mr2877318ejb.174.1621488327265;
 Wed, 19 May 2021 22:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-5-xieyongji@bytedance.com>
 <CACycT3s1rEvNnNkJKQsHGRsyLPADieFdVkb1Sp3GObR0Vox5Fg@mail.gmail.com> <20210519144206.GF32682@kadam>
In-Reply-To: <20210519144206.GF32682@kadam>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 20 May 2021 13:25:16 +0800
Message-ID: <CACycT3veubBFCg9omxLDJJFP7B7QH8++Q+tKmb_M_hmNS45cmw@mail.gmail.com>
Subject: Re: Re: [PATCH v7 04/12] virtio-blk: Add validation for block size in
 config space
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 10:42 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Wed, May 19, 2021 at 09:39:20PM +0800, Yongji Xie wrote:
> > On Mon, May 17, 2021 at 5:56 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > >
> > > This ensures that we will not use an invalid block size
> > > in config space (might come from an untrusted device).
>
> I looked at if I should add this as an untrusted function so that Smatch
> could find these sorts of bugs but this is reading data from the host so
> there has to be some level of trust...
>

It would be great if Smatch could detect this case if possible. The
data might be trusted in traditional VM cases. But now the data can be
read from a userspace daemon when VDUSE is enabled.

> I should add some more untrusted data kvm functions to Smatch.  Right
> now I only have kvm_register_read() and I've added kvm_read_guest_virt()
> just now.
>
> > >
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > ---
> > >  drivers/block/virtio_blk.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > index ebb4d3fe803f..c848aa36d49b 100644
> > > --- a/drivers/block/virtio_blk.c
> > > +++ b/drivers/block/virtio_blk.c
> > > @@ -826,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> > >         err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
> > >                                    struct virtio_blk_config, blk_size,
> > >                                    &blk_size);
> > > -       if (!err)
> > > +       if (!err && blk_size > 0 && blk_size <= max_size)
> >
> > The check here is incorrect. I will use PAGE_SIZE as the maximum
> > boundary in the new version.
>
> What does this bug look like to the user?

The kernel will panic if the block size is larger than PAGE_SIZE.

> A minimum block size of 1 seems pretty crazy.  Surely the minimum should be > higher?
>

Yes, 512 is better here.

Thanks,
Yongji
