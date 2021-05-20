Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC1E389EA7
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhETHKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhETHKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:10:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A2AC061760
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:08:42 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lg14so23565277ejb.9
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPPDvbdoZYkF98kJEXLJL5DQM+/NDzpAbyD+0wj0y0A=;
        b=Se9KYEfzncKvZO5zuibSZNbij3GfLYq8vJWZIp5Rt7L9U5AyliRF9b0kqfP6IAmgge
         7Krig9HpLukT74foF5zhNSAlQwK2yDEcBbVOWe5ziBdJ8l8A4E0m1P87IPiYFuaIY6UE
         k79Xf3InR5zOQmjg8jMvS37YGVQm94PGO0lIcvXbhWGWr30k+pNFNRDadGZk8bu2lu9+
         tTLWF0hTnA816jLyuweb3DM1RTEi+87p0Qe9+TImwfmI+OmewWBM/i8IMHK5U7pWkFGC
         AbjI3ivFGlXwBO+7i1ZCHXmWnoxS9VFDTqlUmnwJ0M5G8JFKs2Hx0HMa19GMvyknHXal
         Q+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPPDvbdoZYkF98kJEXLJL5DQM+/NDzpAbyD+0wj0y0A=;
        b=nTGYi3FKIvCxYeCLIxf/0DzaBnwqaoBOR274gKibRSKXzFFTODatqk/EGnSrfwmi9g
         mrglwuWNag7DGOvF0hHVT1NNF2/kIMa/v23kofxqIDOz9CkBVQtsa7iqtmXAVoXqn0ff
         /6N9aRVEBHi1LiHayLcR+j5Y3mxo/WJFbrrZ9IIcT1rtSavDmqclkDoZkALP7p1aQ0nx
         d2TW7WDi4vyadXDccewwcxlNSgFliDP2EzH9MtDUZKOWC+0LJJc7Lge8aKmhiKalEI3c
         BgC7NUnI4WoeqQQi4HsbRhgeCCIfQfOzlVwv/uFFtiL91N2/ABwLqJUSbg2xxsagFTVk
         Pcww==
X-Gm-Message-State: AOAM533Q0uXQI3oz411FuMftFh4VdCWrmnRrNGjKsClb8YA6HxfnXqw7
        bZPPblRJdgebC49Xv9PQa8CtFrcNB3Fyo+4eXuWE
X-Google-Smtp-Source: ABdhPJw1qaVXgdxcGdVjGAKmjj/w5JqA2hGu9Vaio3k3hOBCyVJZ7/UOZ9K52sSkcUhiotF7loRy9jJ04HYXeZSSc/k=
X-Received: by 2002:a17:906:456:: with SMTP id e22mr3125837eja.427.1621494521280;
 Thu, 20 May 2021 00:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-5-xieyongji@bytedance.com>
 <CACycT3s1rEvNnNkJKQsHGRsyLPADieFdVkb1Sp3GObR0Vox5Fg@mail.gmail.com>
 <20210519144206.GF32682@kadam> <CACycT3veubBFCg9omxLDJJFP7B7QH8++Q+tKmb_M_hmNS45cmw@mail.gmail.com>
 <20210520013921-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210520013921-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 20 May 2021 15:08:30 +0800
Message-ID: <CACycT3v=JDH4SE=2GyeTJVZ7iywhpJoKCYhZ0tAvZTxgfSoOWQ@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v7 04/12] virtio-blk: Add validation for block
 size in config space
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
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
        joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 1:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, May 20, 2021 at 01:25:16PM +0800, Yongji Xie wrote:
> > On Wed, May 19, 2021 at 10:42 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > >
> > > On Wed, May 19, 2021 at 09:39:20PM +0800, Yongji Xie wrote:
> > > > On Mon, May 17, 2021 at 5:56 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > > > >
> > > > > This ensures that we will not use an invalid block size
> > > > > in config space (might come from an untrusted device).
> > >
> > > I looked at if I should add this as an untrusted function so that Smatch
> > > could find these sorts of bugs but this is reading data from the host so
> > > there has to be some level of trust...
> > >
> >
> > It would be great if Smatch could detect this case if possible. The
> > data might be trusted in traditional VM cases. But now the data can be
> > read from a userspace daemon when VDUSE is enabled.
> >
> > > I should add some more untrusted data kvm functions to Smatch.  Right
> > > now I only have kvm_register_read() and I've added kvm_read_guest_virt()
> > > just now.
> > >
> > > > >
> > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > ---
> > > > >  drivers/block/virtio_blk.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > index ebb4d3fe803f..c848aa36d49b 100644
> > > > > --- a/drivers/block/virtio_blk.c
> > > > > +++ b/drivers/block/virtio_blk.c
> > > > > @@ -826,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> > > > >         err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
> > > > >                                    struct virtio_blk_config, blk_size,
> > > > >                                    &blk_size);
> > > > > -       if (!err)
> > > > > +       if (!err && blk_size > 0 && blk_size <= max_size)
> > > >
> > > > The check here is incorrect. I will use PAGE_SIZE as the maximum
> > > > boundary in the new version.
> > >
> > > What does this bug look like to the user?
> >
> > The kernel will panic if the block size is larger than PAGE_SIZE.
>
> Kernel panic at this point is par for the course IMHO.

But it seems better if we can avoid this kind of panic. Because this
might also be triggered by a buggy VDUSE daemon.

> Let's focus on eliminating data corruption for starters.

OK, now the incorrect used length might cause data corruption in
virtio-net and virtio-console drivers as I mentioned in another mail.
I will send a fix ASAP.

Thanks,
Yongji
