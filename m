Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5583956E2
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhEaI0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhEaIZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:25:50 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333A9C061760
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:24:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k7so5902211ejv.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AMGF9A8NxX5xFp88g1oq61PA7j73RZ9YA7ACwFU1V+Y=;
        b=t/b9iXIrxu/JhKkcetsLcVbf2g4krNVZWx3+IVeEMFw0sT4uEsCq2s1mb1rXSouKd5
         8vGX9l9EoyWU23XlOf6fbpTGEKT244+RAxx0pkIALHCSijxRIfLq+I/0vorhbC4LzH7c
         bsCW4UE+tho2K+PD0vu71vAeCOJOAIuPKtxqhH7g46apcPDd81Te5nAJVySLXax9PSzu
         B1GbsPIFOeR8m0t506LH1nMU04VAF4SQ4/9BJdTlq+rcNOjZlFo0imU8nBfv6LVe5W2i
         ZiIkppTZCx+QLvL+HmbmWN8taFPbZoND8j5ze+Zc+pAaxBSseBUdjkgiM4177f/51gNZ
         mZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AMGF9A8NxX5xFp88g1oq61PA7j73RZ9YA7ACwFU1V+Y=;
        b=OK6KPOG3lLzw08zjzrsoL0qnb7jvdgVI0zFCRQyRJSr84qMajRXRqdMgL7ykWZhTbS
         T5lmiLl9c3Ko5ViEjbdveXc7dGGg07Hjt6rv3TUR2aUTNcWND2l4WwWhL7XCkqQ/i63U
         tO2QMD/OcTj43vk4bf6/L1FsqStyGMBKJzaz8SViXhR3LRp27G+WyxZh1B1LH0TPHTns
         u2TqB8s9WHwRMpXHexEnoQLCBSgP6VpQxptpI+F4tECBgObX9q610wbDzKf4wKEep9Dx
         Nnc5hUNruQp7P9AAuWfDc5IKCyFk6Nu3WW69CcGCIkTSZj1j+nNbX0s5fSOOLJzr2hO/
         0Dtw==
X-Gm-Message-State: AOAM532/1+p1EyiXT9Zia4O+HjhmgefLeMHSFpcJaBGmbUTq8CBU4qYD
        dAfkwtYTqmQubAajBeCf/BU6b6R26Y6sIajVqoKc
X-Google-Smtp-Source: ABdhPJyLXTMInE0lOUyC+YYVTDrsstRUXgMnU1e7dlRtQMym/NrAjnWfJ0HslXQMiem1oFI8/USmGvJadwSNN/fSxw4=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr21157495ejy.395.1622449449822;
 Mon, 31 May 2021 01:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210528121157.105-1-xieyongji@bytedance.com> <49ab3d41-c5d8-a49d-3ff4-28ebfdba0181@redhat.com>
 <CACycT3uo-J3MYdEo0TscENewp3Xnjce8yFLtt6JkK8uZrvsMjg@mail.gmail.com> <4ff90e78-0c7a-def6-ef84-367bcce4cea5@redhat.com>
In-Reply-To: <4ff90e78-0c7a-def6-ef84-367bcce4cea5@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 31 May 2021 16:23:59 +0800
Message-ID: <CACycT3vrngdkrocvegMGMyp8AGq9HRBx7mXD7o49m6TUDfh_BQ@mail.gmail.com>
Subject: Re: Re: [PATCH v3] virtio-net: Add validation for used length
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 3:51 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/31 =E4=B8=8B=E5=8D=883:19, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Mon, May 31, 2021 at 2:49 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/28 =E4=B8=8B=E5=8D=888:11, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> This adds validation for used length (might come
> >>> from an untrusted device) to avoid data corruption
> >>> or loss.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    drivers/net/virtio_net.c | 28 +++++++++++++++++++++-------
> >>>    1 file changed, 21 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index 073fec4c0df1..01f15b65824c 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -732,6 +732,17 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
> >>>
> >>>        rcu_read_lock();
> >>>        xdp_prog =3D rcu_dereference(rq->xdp_prog);
> >>> +     if (unlikely(len > GOOD_PACKET_LEN)) {
> >>> +             pr_debug("%s: rx error: len %u exceeds max size %d\n",
> >>> +                      dev->name, len, GOOD_PACKET_LEN);
> >>> +             dev->stats.rx_length_errors++;
> >>> +             if (xdp_prog)
> >>> +                     goto err_xdp;
> >>> +
> >>> +             rcu_read_unlock();
> >>> +             put_page(page);
> >>> +             return NULL;
> >>> +     }
> >>>        if (xdp_prog) {
> >>>                struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_=
offset;
> >>>                struct xdp_frame *xdpf;
> >>> @@ -888,6 +899,16 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
> >>>
> >>>        rcu_read_lock();
> >>>        xdp_prog =3D rcu_dereference(rq->xdp_prog);
> >>> +     if (unlikely(len > truesize)) {
> >>> +             pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> >>> +                      dev->name, len, (unsigned long)ctx);
> >>> +             dev->stats.rx_length_errors++;
> >>> +             if (xdp_prog)
> >>> +                     goto err_xdp;
> >>> +
> >>> +             rcu_read_unlock();
> >>> +             goto err_skb;
> >>> +     }
> >>
> >> Patch looks correct but I'd rather not bother XDP here. It would be
> >> better if we just do the check before rcu_read_lock() and use err_skb
> >> directly() to avoid RCU/XDP stuffs.
> >>
> > If so, we will miss the statistics of xdp_drops. Is it OK?
>
>
> It should be ok, we still had drops and it was dropped before dealing
> with XDP.
>
> The motivation is to have simple codes.
>

OK, will send v4 soon.

Thanks,
Yongji
