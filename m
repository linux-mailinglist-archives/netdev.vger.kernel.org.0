Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810056011A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfGEGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:43:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43966 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfGEGnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:43:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so7020002qto.10;
        Thu, 04 Jul 2019 23:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=swKFyl1Mf/5O9xSZN9816MAkarsTElOMsmp/B3xHLTU=;
        b=OixdgawKakxbcPW/B3nm7ThpZyyj4849Rnwe/iKe6lB80wLa40HwpnUrxCsRGl6Ash
         zcAcLIFNx7/BKKBMLaBVHcGSpM2x2ftivGOyJl8vvpcGbngHirGf1eWGWYbL+SkxJmDR
         Zoj4XxGzsMMgIdCC7WGMK6n8L/M8Yq+M03WJSwBBFFSrF/jL3a8Kig33BOLn2SHCTqEk
         eTr8QpBIAZwVL8l6BqLS28vZROqCwMWvinF17JRj0NymczehVXtSfgE2WuGHf1GXHVKW
         IZzhF852T3dmqYyFaJ0quAlSnkLn9O4vgD6mCGwSQ3zakPkASfGmJh4bRiZvh7SHB2+u
         FV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=swKFyl1Mf/5O9xSZN9816MAkarsTElOMsmp/B3xHLTU=;
        b=a+AGc+dBvT6HFt8ib7E39dhO+qxye9yglDbFuDCBmDt2LOJ0rw/3AJmWm2m4JG/Uqr
         X7PbfxEiwdUwUQ2pzDsNB06pASxkgpkr2tTHcJcFH65n/yB1cX/+5fMEet+pdm7KnyZG
         sqbSA54yk0vwTYK83daDmkAGRtS/b8rv2H2NxsB6HAR+URHyvNaM+tgIcELDYtWMriNy
         mRTYs1GjKVAty1NuZLLJYW+A9PkPMKMoO7xBhwh2iYVk48NXQ4N2ZymVT7+G0mbMi4Hz
         BlNhrPnHwp9H2dTQw0rwLSJGWtTXmWBbj3il6BSrG6SG7ciylaDlCpTil8jo1GIVDC/F
         vUuw==
X-Gm-Message-State: APjAAAWsLCDQd9+E9XyGrwTKspJ6CQYGE03DxGTb0h2Z0tU7M0B8V67E
        59u80GR6OVM5JVt5n3d/N4m9x93p2v4yEAxpSnOYjZGr4vg=
X-Google-Smtp-Source: APXvYqxg01UgjLVPz8TDzoJ+bYdZ1P/W5rf+cEyou/FudaS8d+puT2sC/p+LMi1+18Te/UmqV50+hwhIBKA1ngwgE2I=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr1375964qtn.107.1562308987980;
 Thu, 04 Jul 2019 23:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com>
In-Reply-To: <20190704142503.23501-1-i.maximets@samsung.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 5 Jul 2019 08:42:56 +0200
Message-ID: <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 at 16:25, Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Completion queue address reservation could not be undone.
> In case of bad 'queue_id' or skb allocation failure, reserved entry
> will be leaked reducing the total capacity of completion queue.
>
> Fix that by moving reservation to the point where failure is not
> possible. Additionally, 'queue_id' checking moved out from the loop
> since there is no point to check it there.
>

Good catch, Ilya! Thanks for the patch!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>  net/xdp/xsk.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f53a6ef7c155..703cf5ea448b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -226,6 +226,9 @@ static int xsk_generic_xmit(struct sock *sk, struct m=
sghdr *m,
>
>         mutex_lock(&xs->mutex);
>
> +       if (xs->queue_id >=3D xs->dev->real_num_tx_queues)
> +               goto out;
> +
>         while (xskq_peek_desc(xs->tx, &desc)) {
>                 char *buffer;
>                 u64 addr;
> @@ -236,12 +239,6 @@ static int xsk_generic_xmit(struct sock *sk, struct =
msghdr *m,
>                         goto out;
>                 }
>
> -               if (xskq_reserve_addr(xs->umem->cq))
> -                       goto out;
> -
> -               if (xs->queue_id >=3D xs->dev->real_num_tx_queues)
> -                       goto out;
> -
>                 len =3D desc.len;
>                 skb =3D sock_alloc_send_skb(sk, len, 1, &err);
>                 if (unlikely(!skb)) {
> @@ -253,7 +250,7 @@ static int xsk_generic_xmit(struct sock *sk, struct m=
sghdr *m,
>                 addr =3D desc.addr;
>                 buffer =3D xdp_umem_get_data(xs->umem, addr);
>                 err =3D skb_store_bits(skb, 0, buffer, len);
> -               if (unlikely(err)) {
> +               if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
>                         kfree_skb(skb);
>                         goto out;
>                 }
> --
> 2.17.1
>
