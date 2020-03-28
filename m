Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0151964C5
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 10:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgC1JS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 05:18:57 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:46580 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgC1JS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 05:18:57 -0400
Received: by mail-vs1-f66.google.com with SMTP id z125so7767081vsb.13;
        Sat, 28 Mar 2020 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWGCUs9Twi1dHOwTh9evVshDNb9RGDkgYpcpyU7JNHU=;
        b=Ye3XkGzGbFxh6NNoFhs4irBFsYNJWbQqrYVybicR4NPaIyDfsS/RnPW4Pa+NGa281q
         aYF9TSaKfSH8nbhFY4M/s7vphOWoalyr2U446S5INPCpFYsX+0nkAvFBCbWEfWr4Bka4
         FawGNzwKReKd0gwSFSw7vUamrHJH/1xXzTIEE8Rbs6yEkH0kAVW82tpiOO2aIT9Imv3e
         Hf8w20cE1paGtdszZWakB/xwXL8tuArsUE1K7ya0Dzy9yP3MPaY5CawCV59BCRS6ao85
         2WWurHLAHCiN1OjenkPgHKPiwvCSORQjy4pOnZUzNXzifXjudWirQfOY/IeiHz0IqeVd
         5jGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWGCUs9Twi1dHOwTh9evVshDNb9RGDkgYpcpyU7JNHU=;
        b=Dmi6YGhHkwb27cSy0JdydejkDkNGTcwYhU1IzsBBnr5WymkNK7tYfgQRcYCWfJTt9l
         Z3AVxMItDdHv2kcyA2YAuc0gknsfw3an0ufVCVFkI/O94LANvIq17DJvWbOEAkxXIpx3
         2iI31ZxvHPQi6dvfHa0BlBEw9eHu/Y7YPDgcL6AHmD3zOeBnur2Zm3/fbfyDBi20Unjw
         EhfD41bUoGYw1I0GZ+XbaqjOvvY8U6wcrgcKVoIeYlzMX/bo1igqZXOz3D4qtCzW+ks7
         v/bJyDJzDX7SL+CB+DR+7DLhgOrN1+qW27wgy3E8ELKnR1JyowK+QIQr+CBw/wK2/+Ll
         1Ukg==
X-Gm-Message-State: AGi0PuYU9jv7HjLR6KxQBiUNxk0YIBcO5i21e8ptIJWgw6qhvR4Zgu2i
        roqNl4Ty3T2/j+jh8zjj6b6MQhxHmHGrpgrDfGA=
X-Google-Smtp-Source: APiQypIWPDpLkb+aZjaUHXi/rjG/0Sj5qzuJ0B7q1C8bVCyIubk7MXiCnjFk7620ij6rO6rpLTuwncVVyfkg9HA18po=
X-Received: by 2002:a05:6102:104b:: with SMTP id h11mr2047534vsq.182.1585387136417;
 Sat, 28 Mar 2020 02:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <85f12913cde94b19bfcb598344701c38@valvesoftware.com>
In-Reply-To: <85f12913cde94b19bfcb598344701c38@valvesoftware.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sat, 28 Mar 2020 10:18:45 +0100
Message-ID: <CAJ8uoz2M0Xj_maD3jZeZedrUXGNJqvbV_DyC2A8Yh9R6z7gfsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: Init all ring members in xsk_umem__create
 and xsk_socket__create
To:     Fletcher Dunn <fletcherd@valvesoftware.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Brandon Gilmore <bgilmore@valvesoftware.com>,
        Steven Noonan <steven@valvesoftware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 4:40 AM Fletcher Dunn
<fletcherd@valvesoftware.com> wrote:
>
> Fix a sharp edge in xsk_umem__create and xsk_socket__create.  Almost all of
> the members of the ring buffer structs are initialized, but the "cached_xxx"
> variables are not all initialized.  The caller is required to zero them.
> This is needlessly dangerous.  The results if you don't do it can be very bad.
> For example, they can cause xsk_prod_nb_free and xsk_cons_nb_avail to return
> values greater than the size of the queue.  xsk_ring_cons__peek can return an
> index that does not refer to an item that has been queued.
>
> I have confirmed that without this change, my program misbehaves unless I
> memset the ring buffers to zero before calling the function.  Afterwards,
> my program works without (or with) the memset.

Thank you Flecther for catching this. Appreciated.

/Magnus

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Fletcher Dunn <fletcherd@valvesoftware.com>
>
> ---
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 9807903f121e..f7f4efb70a4c 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -280,7 +280,11 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>         fill->consumer = map + off.fr.consumer;
>         fill->flags = map + off.fr.flags;
>         fill->ring = map + off.fr.desc;
> -       fill->cached_cons = umem->config.fill_size;
> +       fill->cached_prod = *fill->producer;
> +       /* cached_cons is "size" bigger than the real consumer pointer
> +        * See xsk_prod_nb_free
> +        */
> +       fill->cached_cons = *fill->consumer + umem->config.fill_size;
>
>         map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
>                    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
> @@ -297,6 +301,8 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>         comp->consumer = map + off.cr.consumer;
>         comp->flags = map + off.cr.flags;
>         comp->ring = map + off.cr.desc;
> +       comp->cached_prod = *comp->producer;
> +       comp->cached_cons = *comp->consumer;
>
>         *umem_ptr = umem;
>         return 0;
> @@ -672,6 +678,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>                 rx->consumer = rx_map + off.rx.consumer;
>                 rx->flags = rx_map + off.rx.flags;
>                 rx->ring = rx_map + off.rx.desc;
> +               rx->cached_prod = *rx->producer;
> +               rx->cached_cons = *rx->consumer;
>         }
>         xsk->rx = rx;
>
> @@ -691,7 +699,11 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>                 tx->consumer = tx_map + off.tx.consumer;
>                 tx->flags = tx_map + off.tx.flags;
>                 tx->ring = tx_map + off.tx.desc;
> -               tx->cached_cons = xsk->config.tx_size;
> +               tx->cached_prod = *tx->producer;
> +               /* cached_cons is r->size bigger than the real consumer pointer
> +                * See xsk_prod_nb_free
> +                */
> +               tx->cached_cons = *tx->consumer + xsk->config.tx_size;
>         }
>         xsk->tx = tx;
>
