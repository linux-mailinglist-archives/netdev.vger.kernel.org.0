Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A47132DC1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgAGR6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:58:18 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33947 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgAGR6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:58:18 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so281038iof.1;
        Tue, 07 Jan 2020 09:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NzyUSCy3qDJRvRAQxGeNLwY1zexwoqlQ1M5XcFl5brg=;
        b=TgCwBYVNhgQLIZFxGDKoRGhWQBHTK85TDCCWXuqrCzyet+yWuPkCUBQkiLduLbkJkw
         J2MVWQqrLX/cTvRYCE/3Up1ybBIjm4EpuLfbgGvVvjAej90Ab3ib9h+0i5fMWq5csr7n
         dF+Zjx2P6+r5KQWd+7Ide4NI+BthmG3WkfNjliwCVNReAi9NpLJEj1/xVlNgHoSBhyi9
         wKYsEzz0y9PN3guXAOejJXe25llc0Bp1JPGRvFFIzbIdpcpcsXTz3UO2fOmSSxMAtvQv
         +NCoP2ETDnOZr3U3wsJDt4kHFyNjIClQZ8LQEIhGKqtbPxd/uo8XWpVIZyphG6M5alQv
         IEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NzyUSCy3qDJRvRAQxGeNLwY1zexwoqlQ1M5XcFl5brg=;
        b=Chdi/I/PbZnKcDXfLCn9JvikbNO5rs7/pfE9JGk5uFYJ15/OL/Mv9cxRCQ0K5936SB
         dYLmziy7sKe1kVdwYGRR2BfN7foVzlFXsulReMOfaiFxeUILKv2dUUYC/lpbe6Y4ih2B
         TJC24bZjojyfxxXVDGVT6ZLjeXGmOpRLZdNP+feOcFTjl60Q2NvU30ZW9n5ebuYiXzbr
         Fa/qqnYPRkFe/heE6X5X9M2awbXLdHl4fPT1K/i8ppkyK+ykLDQwvjc83AuuNBnKj8D3
         cQLP6y6Yja9T9NQrNlcdi7gc0Alcj1HzixuhUi9L8pNgX3+ykGdzx17u03eNM2U0vvH0
         604w==
X-Gm-Message-State: APjAAAXqOKtxwR0tIQZF0GWH35+WszDf2NtNNaDMomlW/49jefJBi3pp
        EQoTydZb1jHMECXBnUx/28Y=
X-Google-Smtp-Source: APXvYqwlgu9wQtX3wAaDwZdCeC5JFXQBNGRweTyV9+C5wvDJbi8sjC41PO0SluDt/8f0Z8HdPvMgJw==
X-Received: by 2002:a6b:7e02:: with SMTP id i2mr134821iom.172.1578419897983;
        Tue, 07 Jan 2020 09:58:17 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y11sm48845iot.19.2020.01.07.09.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:58:17 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:58:08 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14c6b07e670_67962afd051fc5c05d@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-6-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-6-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 5/8] xdp: make devmap flush_list common for
 all map instances
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> The devmap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all devmaps, which simplifies __dev_map_flush()
> and dev_map_init_map().
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/bpf.h |  4 ++--
>  kernel/bpf/devmap.c | 35 +++++++++++++----------------------
>  net/core/filter.c   |  2 +-
>  3 files changed, 16 insertions(+), 25 deletions(-)
> =

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index d467983e61bb..31191804ca09 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -959,7 +959,7 @@ struct sk_buff;
>  =

>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32=
 key);
>  struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map=
, u32 key);
> -void __dev_map_flush(struct bpf_map *map);
> +void __dev_map_flush(void);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,=

>  		    struct net_device *dev_rx);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_bu=
ff *skb,
> @@ -1068,7 +1068,7 @@ static inline struct net_device  *__dev_map_hash_=
lookup_elem(struct bpf_map *map
>  	return NULL;
>  }
>  =

> -static inline void __dev_map_flush(struct bpf_map *map)
> +static inline void __dev_map_flush(void)

How about __dev_flush(void) then sense its not map specific anymore?
Probably same in patch 4/5.

>  {
>  }
>  =

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index b7595de6a91a..da9c832fc5c8 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c

[...]
 =

> @@ -384,10 +371,9 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, =
u32 flags)
>   * net device can be torn down. On devmap tear down we ensure the flus=
h list
>   * is empty before completing to ensure all flush operations have comp=
leted.
>   */
> -void __dev_map_flush(struct bpf_map *map)
> +void __dev_map_flush(void)

__dev_flush()?

>  {
> -	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
> -	struct list_head *flush_list =3D this_cpu_ptr(dtab->flush_list);
> +	struct list_head *flush_list =3D this_cpu_ptr(&dev_map_flush_list);
>  	struct xdp_bulk_queue *bq, *tmp;
>  =

>  	rcu_read_lock();

[...]

Looks good changing the function name would make things a bit cleaner IMO=
.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
