Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED434A3EC
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCZJOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhCZJOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:14:23 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EFFC0613AA;
        Fri, 26 Mar 2021 02:14:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id i22so4192044pgl.4;
        Fri, 26 Mar 2021 02:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ISFXlhhQ0K2lxAEBKCoI272OB+TykgqUPhYBrA3KA8=;
        b=m1qEggRFqWDvOl+yhyvk0BfXY37Sgio5zozy4HFAVBugp1SWfm8knXkLCTDVc9qhcv
         Uqwc5OkNa3JGuuzQLjdeFqO8+ciDeeLc1MKrC3+nacRdKZ2nGd7/+/3HHArr5nwKtyCC
         ricbihpjoDp+JIUnUIFBFSPM43VTlUnOQGYS62yZxFT4Wd77Pqu6d5NhyDwBVNzQ3naf
         7cxD8/Z2my4A1EKckthr3r5EuAovjmGGJKUTx1s1zPjcJiqFZTq+L4n3wgEFFyaPlacs
         QUvBUlKql95y3GJQBtiAVcimLcnna6ilmLnsDzGRV0SBEUx/g7FRPg5M0YJ6s0i7nMZe
         +lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ISFXlhhQ0K2lxAEBKCoI272OB+TykgqUPhYBrA3KA8=;
        b=BWBsBjKXe0PEPpjjpNz+C8Y/Aj058qrd2RO54ySRF0GGbNObka3Lmpyj0rFCM43Orm
         e43NjEkXG409h4qOiVLyOgzKiQnz5JHMQ2E4d8AXDsolw2WdYXwJ3Q0ONM6XdbJNOCbs
         UtDzyhRe3yrXkeAI6CyGSWNaY6uyN/khQgh7L29WD6m4P7+Rh/wOmpRjgKyXROclhjNd
         AuN45Og6NL8K1Z+ye17FohmJ/9seriYmQhg2TkZtEbyPSwtV809lW1qr2rmy6bp+kEHd
         GhycYJzhdXrdCk67HBG5b3nvKlN7zzHkJPaldTC+eRX4gjvo7vx/VC/opx9/udVFBJkt
         ASRg==
X-Gm-Message-State: AOAM5329SniPqqlB8raVvWEAPiXpPkkp4N7FL/ave7CC61T0c2AbqIZb
        iCjCnyGZrVGDac4qcFbeZAh/b3M18cyW7UPONbD7zZErmMPVl2FX
X-Google-Smtp-Source: ABdhPJzNsyRIaf5H/Ny0Sg1v3GuB5jtlP8/SMEnbq5x90JRaZ/U5GA8olQ4gwL3/zZ6FZJCpHXAUHbjE46//VoASCrQ=
X-Received: by 2002:aa7:9852:0:b029:211:6824:6c7d with SMTP id
 n18-20020aa798520000b029021168246c7dmr12289840pfq.19.1616750062703; Fri, 26
 Mar 2021 02:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210324141337.29269-1-ciara.loftus@intel.com> <20210324141337.29269-4-ciara.loftus@intel.com>
In-Reply-To: <20210324141337.29269-4-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 26 Mar 2021 10:14:11 +0100
Message-ID: <CAJ8uoz1ebJd9mj7rMmBfOot102Lrtj4TBo7vZhxK0=dEK3oFCg@mail.gmail.com>
Subject: Re: [PATCH bpf 3/3] libbpf: ignore return values of setsockopt for
 XDP rings.
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 3:46 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> During xsk_socket__create the XDP_RX_RING and XDP_TX_RING setsockopts
> are called to create the rx and tx rings for the AF_XDP socket. If the ring
> has already been set up, the setsockopt will return an error. However,
> in the event of a failure during xsk_socket__create(_shared) after the
> rings have been set up, the user may wish to retry the socket creation
> using these pre-existing rings. In this case we can ignore the error
> returned by the setsockopts. If there is a true error, the subsequent
> call to mmap() will catch it.
>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index ec3c23299329..1f1c4c11c292 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -904,24 +904,22 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         }
>         xsk->ctx = ctx;
>
> -       if (rx) {
> -               err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> -                                &xsk->config.rx_size,
> -                                sizeof(xsk->config.rx_size));
> -               if (err) {
> -                       err = -errno;
> -                       goto out_put_ctx;
> -               }
> -       }
> -       if (tx) {
> -               err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> -                                &xsk->config.tx_size,
> -                                sizeof(xsk->config.tx_size));
> -               if (err) {
> -                       err = -errno;
> -                       goto out_put_ctx;
> -               }
> -       }
> +       /* The return values of these setsockopt calls are intentionally not checked.
> +        * If the ring has already been set up setsockopt will return an error. However,
> +        * this scenario is acceptable as the user may be retrying the socket creation
> +        * with rings which were set up in a previous but ultimately unsuccessful call
> +        * to xsk_socket__create(_shared). The call later to mmap() will fail if there
> +        * is a real issue and we handle that return value appropriately there.
> +        */
> +       if (rx)
> +               setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> +                          &xsk->config.rx_size,
> +                          sizeof(xsk->config.rx_size));
> +
> +       if (tx)
> +               setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> +                          &xsk->config.tx_size,
> +                          sizeof(xsk->config.tx_size));

Thanks Ciara!

This is a pragmatic solution, but I do not see any better way around
it since these operations are irreversible. And it works without any
fix to the kernel which is good and you have a comment explaining
things clearly. With that said, it would be nice as a follow up to
bpf-next to actually return a unique error value (among the ones that
this function can return) when the rings have already been mapped.
This way the user can react to this in a more informed way in the
future.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

>
>         err = xsk_get_mmap_offsets(xsk->fd, &off);
>         if (err) {
> --
> 2.17.1
>
