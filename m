Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90F383C94
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhEQSpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbhEQSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:45:12 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4513C061573;
        Mon, 17 May 2021 11:43:54 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h11so6933362ili.9;
        Mon, 17 May 2021 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lhz9D+4Hmsj2IYsFNTcfwhNT/yj5LxHuzYyX8yHCazs=;
        b=RoFp/Xou2tBzEIS0PJ5higbeUhZNkt7DjYv3TiySBuJU5/LxLgaBc/Uo52xF34vk02
         yJJAYFXBg9AJSyU8wWrm5sUpNkdQbdvzPM8GbD8q4jlXndx4lLNqQZLBbrVJWDpoQC/m
         aj+jkcB8HiTrNeBQ1rk1IyZ5B88+IP8rOfU2qV/gCVo2OJT1gOBulCdHL0Ru2heZxxBK
         rzt+z0/w3AAWLzldYnTTYbpLtNQTmNthRkB9xJTOvauTwkz0tw9mSux+iR369yBJmAUF
         4+nYRp8acHF2aXLi7wsrWkstMr/et+usCZxHAismjR5IG2T1WlrzE5zj6gsNLFdulKTY
         yxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lhz9D+4Hmsj2IYsFNTcfwhNT/yj5LxHuzYyX8yHCazs=;
        b=TXynOQMF+nBHtZVwpADq7CxSSHF0hipEPbXvP8sInGOfnS8LtaPPzqJwtniVcOPtb7
         3v6biYRj+/luRLzsej1aupekg/B1KZHtJvvCCa79meQHaWvWTv58CFJdLMwGzx5XyFG+
         tRM2R2D/pKAGwHbp9IixlCyjbaTiIgqlIBwMFxwMjaJykg+w/jKWdO5B7i9b2k3e9dx/
         lxYxHPiXBHYZZC0f0daindkeVNO5HGBvOIKtiIbdN7tGWP3aSVkG9xZwDL25dtwmTo00
         5Fs8N+dOn64XG5PgN7RYHf5Htqu77pLCFZyR1ZXzzDzeDN34g4LkShbbDuGuzKWOUHFJ
         09ww==
X-Gm-Message-State: AOAM532d0ZxCj2uuPi/Oxyb0CXvnZY6IXhI/sev01Xf5OWjCHgb2Cb0P
        kdssC6ZljchdIH3CJAZkJqDCMl/3s2Z0yFOoeIM=
X-Google-Smtp-Source: ABdhPJx0L6Eum49ErlCgRNLCv0T46JqEQRPsyyyA6Y87SHSEJN5+yeSXLzLzt2cIFvaLuNBCZTvNNt4ZjYsw9yRqFOo=
X-Received: by 2002:a05:6e02:d41:: with SMTP id h1mr912406ilj.0.1621277034344;
 Mon, 17 May 2021 11:43:54 -0700 (PDT)
MIME-Version: 1.0
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
In-Reply-To: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 17 May 2021 11:43:43 -0700
Message-ID: <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
Subject: virtio_net: BQL?
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not really related to this patch, but is there some reason why virtio
has no support for BQL?

On Mon, May 17, 2021 at 11:41 AM Xianting Tian
<xianting.tian@linux.alibaba.com> wrote:
>
> BUG_ON() uses unlikely in if(), which can be optimized at compile time.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c921ebf3ae82..212d52204884 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct
> sk_buff *skb)
>         else
>                 hdr =3D skb_vnet_hdr(skb);
>
> -       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> +       BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
>                                     virtio_is_little_endian(vi->vdev), fa=
lse,
> -                                   0))
> -               BUG();
> +                                   0));
>
>         if (vi->mergeable_rx_bufs)
>                 hdr->num_buffers =3D 0;
> --
> 2.17.1
>


--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
