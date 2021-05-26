Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7439178F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhEZMl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbhEZMlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:41:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00101C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:39:45 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j10so1260696edw.8
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JxMjjfVMw+oBaLrmrUE0qkwXmyYluhhXJ7AcWez4o4A=;
        b=ENMDhHIaE4hE/AaMhDi6fdMXB6yMQyWxjuz7U8g+j9b8/Pa3hbECUMP0PRxDuFnpvD
         zFAK6JDYgYejy50KvImiNIG/ML+ICi/g3ouaPSey7S8S3imEEKQIPITkrAr5PD9KGGQn
         WFgM5RRaowXrsIUN9DhNRZYtBE3FOBE9LjWoXjMbjfBfVvIre/KLxWZTQj5X9TRiD7fY
         PZ0MlU28wsSlzazXRqXY74NVWcAP3TYI3kogdJv3ZD9qBran6U+A+JC+huGMlLMLjvea
         bhEjxd1Pj+utTHL4EsuC+lGEprekysWJuGfpWSTA9lryBkaYyKWWMr1UWP2msXkYfbAe
         jT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JxMjjfVMw+oBaLrmrUE0qkwXmyYluhhXJ7AcWez4o4A=;
        b=PgLxiIfDnWIWGSQxO+qsgx37YMFMRENrCXYVNCoLhqmUfuZRF0hxchy0YCLDM0qD87
         o6p4D7koz+IF7UxRpqAGM5eJ2CgRbeomGJCiX80IN4dmGPlOqOFD4OPnZAYebizdHPn+
         FdQAoZgrs8CsUhYnQf03BhWh4YF8YvDqda9+yRIpH7fiocO4jAPouH1akYoNu3/3FX0O
         Zf6e+NA/myHS9h/27oO1xqzBGWKkqNtC05Cfg3FkTqhUdN2MYhnOJ2CksjLelUkwEmFj
         blq3Z/8e80yaqPcLVGUg22e6xbQU27GykmBJ2LcfhVFJJCFQVpj3qgbB3nZyUwMoYk1F
         hjug==
X-Gm-Message-State: AOAM533TmM+2tr+FYxGC7Vbz/h8X3ZvcXDfwVFJZDdtMsDZwyJqm+mL9
        IpT7y1bU8sK+yw0mee3FVvHKBAhrbj5T8yD31ZVD
X-Google-Smtp-Source: ABdhPJw4xaHMmxGiMlFlCfC8aGJjoE+FBWVp2YhwOZSbCcEmdu/V9jAOmHoT4oKUP6XD0OCcTvejB4aXtrqi6Zp4EgE=
X-Received: by 2002:aa7:cd55:: with SMTP id v21mr38264279edw.344.1622032784595;
 Wed, 26 May 2021 05:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210525045838.1137-1-xieyongji@bytedance.com>
 <75e26cf1-6ee8-108c-ff48-8a23345b3ccc@redhat.com> <CACycT3s1VkvG7zr7hPciBx8KhwgtNF+CM5GeSJs2tp-2VTsWRw@mail.gmail.com>
 <efb7d2e0-39b0-129d-084b-122820c93138@redhat.com>
In-Reply-To: <efb7d2e0-39b0-129d-084b-122820c93138@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 26 May 2021 20:39:33 +0800
Message-ID: <CACycT3txvyLP=ZBn-wo6_ZCz+h4-cuJ6Y1F9nJ+C9a5BYPZ47g@mail.gmail.com>
Subject: Re: Re: [PATCH] virtio-net: Add validation for used length
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 3:52 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/25 =E4=B8=8B=E5=8D=884:45, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Tue, May 25, 2021 at 2:30 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/25 =E4=B8=8B=E5=8D=8812:58, Xie Yongji =E5=86=99=E9=
=81=93:
> >>> This adds validation for used length (might come
> >>> from an untrusted device) to avoid data corruption
> >>> or loss.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> >>>    1 file changed, 22 insertions(+)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index c4711e23af88..2dcdc1a3c7e8 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -668,6 +668,13 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
> >>>                void *orig_data;
> >>>                u32 act;
> >>>
> >>> +             if (unlikely(len > GOOD_PACKET_LEN)) {
> >>> +                     pr_debug("%s: rx error: len %u exceeds max size=
 %lu\n",
> >>> +                              dev->name, len, GOOD_PACKET_LEN);
> >>> +                     dev->stats.rx_length_errors++;
> >>> +                     goto err_xdp;
> >>> +             }
> >>
> >> Need to count vi->hdr_len here?
> >>
> > We did len -=3D vi->hdr_len before.
>
>
> Right.
>
>
> >
> >>> +
> >>>                if (unlikely(hdr->hdr.gso_type))
> >>>                        goto err_xdp;
> >>>
> >>> @@ -739,6 +746,14 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
> >>>        }
> >>>        rcu_read_unlock();
> >>>
> >>> +     if (unlikely(len > GOOD_PACKET_LEN)) {
> >>> +             pr_debug("%s: rx error: len %u exceeds max size %lu\n",
> >>> +                      dev->name, len, GOOD_PACKET_LEN);
> >>> +             dev->stats.rx_length_errors++;
> >>> +             put_page(page);
> >>> +             return NULL;
> >>> +     }
> >>> +
> >>>        skb =3D build_skb(buf, buflen);
> >>>        if (!skb) {
> >>>                put_page(page);
> >>> @@ -822,6 +837,13 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
> >>>                void *data;
> >>>                u32 act;
> >>>
> >>> +             if (unlikely(len > truesize)) {
> >>> +                     pr_debug("%s: rx error: len %u exceeds truesize=
 %lu\n",
> >>> +                              dev->name, len, (unsigned long)ctx);
> >>> +                     dev->stats.rx_length_errors++;
> >>> +                     goto err_xdp;
> >>> +             }
> >>
> >> There's a similar check after the XDP, let's simply move it here?
> > Do we still need that in non-XDP cases?
>
>
> I meant we check once for both XDP and non-XDP if we do it before if
> (xdp_prog)
>

Will do it in v2.

Thanks,
Yongji
