Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A101C4B3DE8
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 23:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiBMWKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 17:10:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiBMWKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 17:10:00 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C4454199
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 14:09:54 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id l14so8015789vko.12
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 14:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=655hBZv76V+mrSinPrNjP8l8aP2PjNxTSfwFsXq8kKw=;
        b=EgsyC3C3wfNT+ZC4PsLdvJGD1LBMmBNknllDyLdwe8wxW8zD7WvXDvGw0HfEvaGVx6
         hkAb3D4NTB9S36yWBvho1x9xYu/4/hFoZZUV76+pRybqJ4xJTuv2aAaLOh/1m71Sx+pU
         GDt+figOp2KoDp26N4fHxIBisEKNSnXZ6AkdTuo6+SQPNRbqixnLxP1vdt2+uE57eumk
         xZx0PfC8asPnragQw54IKS+1WPhNEMKgGQsE1m27+zP7LZm2T0CLCyMhoLWKFJrWmVaX
         dK2kETWlDXQXyiWlRrQ6kBLR73U5zfhsZmaceF4ppBvN1zNYSqYkjQj4AdUh2Ccfkpfb
         TU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=655hBZv76V+mrSinPrNjP8l8aP2PjNxTSfwFsXq8kKw=;
        b=numKVMJFh0Gpuwv6ZSKCf6hOFdLRe9wvlQ03ojxMO3xd7ICs5gu+yPLN/GwzXzp5U4
         zLysK++bvQgmHrbnnAj8nBqaqm1a40SGK3FtPy4Yf/CYpigV/WyPbwnM+pQFLmo93RJk
         YqBnhsjH6nAWTP60XUw7Q/Y+yhVvE1zPpT4ew0+47u+OApx2UeP+tp+eB+4UtsxkIlOf
         4B0cemV7QqykgiuNJ/Glx3HybXyOZahTh/dbQVU0ZpblKSJB8Gh2bEykfix2tRezsowD
         LZQ310136VHuH6H88uYTuerhy+ClHDHSXkl7YYcYlQcxYsoJeSqQk1RmaNR1uBFYLDHU
         rvQg==
X-Gm-Message-State: AOAM533/al5Xt55Zl92T6nY0cIIbq04nwKVmp6tuRWAA+AnTwumYKCzC
        bfuoG4PMDY/aH8MwZklX3gaC3MumFI8=
X-Google-Smtp-Source: ABdhPJybtKrMt1akw7/DoHxt4yF3aLGmVH+X4IJ2py399hPYqZawmnXddNy4ypCDdIOh2emcB/EYjg==
X-Received: by 2002:a05:6122:990:: with SMTP id g16mr3171121vkd.3.1644790193342;
        Sun, 13 Feb 2022 14:09:53 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id n8sm1237525vsl.22.2022.02.13.14.09.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 14:09:52 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id u10so3808571vsu.13
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 14:09:52 -0800 (PST)
X-Received: by 2002:a67:cc14:: with SMTP id q20mr487373vsl.74.1644790191828;
 Sun, 13 Feb 2022 14:09:51 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-3-andrew@daynix.com>
 <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com> <CABcq3pFLXUMi3ctr6WyJMaXbPjKregTzQ2fG1fwDU7tvk2uRFg@mail.gmail.com>
In-Reply-To: <CABcq3pFLXUMi3ctr6WyJMaXbPjKregTzQ2fG1fwDU7tvk2uRFg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Feb 2022 17:09:15 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfJS6b3ba7eW_u4TAHCq=ctpHDJUrb-Yc3iDwpJHHuBMw@mail.gmail.com>
Message-ID: <CA+FuTSfJS6b3ba7eW_u4TAHCq=ctpHDJUrb-Yc3iDwpJHHuBMw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drivers/net/virtio_net: Added basic RSS support.
To:     Andrew Melnichenko <andrew@daynix.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >         u16 max_queue_pairs;
> > >         int mtu;
> > >
> > > -       /* Find if host supports multiqueue virtio_net device */
> > > -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> > > -                                  struct virtio_net_config,
> > > -                                  max_virtqueue_pairs, &max_queue_pairs);
> > > +       /* Find if host supports multiqueue/rss virtio_net device */
> > > +       max_queue_pairs = 1;
> > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> > > +               max_queue_pairs =
> > > +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
> >
> > Instead of testing either feature and treating them as somewhat equal,
> > shouldn't RSS be dependent on MQ?
>
> No, RSS is dependent on CTRL_VQ. Technically RSS and MQ are similar features.

RSS depends on having multiple queues.

What would enabling VIRTIO_NET_F_RSS without VIRTIO_NET_F_MQ do?

> >
> > >
> > >         /* We need at least 2 queue's */
> > > -       if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> > > +       if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> > >             max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
> > >             !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> > >                 max_queue_pairs = 1;
> > > @@ -3207,6 +3365,23 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> > >                 vi->mergeable_rx_bufs = true;
> > >
> > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> > > +               vi->has_rss = true;
> > > +               vi->rss_indir_table_size =
> > > +                       virtio_cread16(vdev, offsetof(struct virtio_net_config,
> > > +                               rss_max_indirection_table_length));
> > > +               vi->rss_key_size =
> > > +                       virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> > > +
> > > +               vi->rss_hash_types_supported =
> > > +                   virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
> > > +               vi->rss_hash_types_supported &=
> > > +                               ~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
> > > +                                 VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
> > > +                                 VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
> > > +
> > > +               dev->hw_features |= NETIF_F_RXHASH;
> >
> > Only make the feature visible when the hash is actually reported in
> > the skb, patch 3.
>
> VirtioNET has two features: RSS(steering only) and hash(hash report in
> vnet header)
> Both features may be enabled/disabled separately:
> 1. rss on and hash off - packets steered to the corresponding vqs
> 2. rss off and hash on - packets steered by tap(like mq) but headers
> have properly calculated hash.
> 3. rss on and hash on - packets steered to corresponding vqs and hash
> is present in the header.
>
> RXHASH feature allows the user to enable/disable the rss/hash(any combination).

I find that confusing, but.. I see that there is prior art where some
drivers enable/disable entire RSS load balancing based on this flag.
So ok.

> I think it's a good idea to leave RXHASH in patch 2/4 to give the user
> ability to manipulate the rss only feature.
> But, if you think that it requires to move it to the 3/4, I'll do it.
>
> >
> > Also, clearly separate the feature patches (2) rss, (3) rxhash, (4)
> > rxhash config.
>
> Currently:
> Patch 2/4 - adds VirtioNet rss feature.
> Patch 3/4 - adds VirtioNet hash report feature.
> Patch 4/4 - adds the ability to manipulate supported hash types.
>
> Can you provide more detailed suggestions on how to move hunks?

I gave one in the follow-on patch, to which you responded. That's probably it.
