Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D3B63BBD0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiK2Iif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiK2IiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:38:00 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1EA5ADF1;
        Tue, 29 Nov 2022 00:36:43 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3bfd998fa53so78739827b3.5;
        Tue, 29 Nov 2022 00:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pfkOEndp/yx+JRjSBn9cHN5l3i+pxuuJ2RW6geOPhYw=;
        b=ZR+jEz0dzvk6xpPXj53lxM8aL/yM5BPKAlEKuEb2t2ZaMZ1JH83eYMMAMZehcWRpmG
         kw46HaFKI48cro0faLI2xks648p73ZPWsjxjhNeVUov/LMYm/F1W8r3tUSmgufoRvcZw
         Q+PxLywuZwFkwAjfImeVfX9QTz75wNwFWAP74bf84Sp24JPHIBxl2YJj4dsJGIVkEblU
         PoDQZjAcp0pERxMYnggb5Potc6S9sL4Odyxb5PGnBNz6J+y1WHDdhCNlTsvNugvLf3UZ
         i52QonMdSY/eGGRGj5v+zu9PVsy4/7tm04ktjA/bK5jzszlseIK5aBL/jDtBmozyKaDr
         LnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfkOEndp/yx+JRjSBn9cHN5l3i+pxuuJ2RW6geOPhYw=;
        b=zudvzIqIQfn2s590F1ALKkI2n5DaqI8kGGy9DVXDRdBfzfkvtKQy9YrPfEDS4hWGYd
         RJbbikj2bOmzj0z9HXdr8dHRDkanoZqbWfGVqiQjz0rRGGhJRAvwftSGxCXrda1v6cef
         VGWOQ7icuPtxzk0TCXKQc29ctP0A+bKuORTiv8Wq1EKiFOWWe66Du2+eME9YPnLfpy0+
         KzArG0eej9NkaVervM7ifyamPClrEoS0xr12c73ULu5YIvdX0S6rLRsfwCH3oDkdwvMA
         Fk6Z7kCmfkKKtzG6w5b6IMRzYhdoVDML4X+iN7Y05vhGa5QvIspVG5eC3LsodYwlPyAy
         RUZQ==
X-Gm-Message-State: ANoB5pl5Kk1F+xCha25QRJvgWZlXgtjR+qlXcm4rMtKYwrIBhasWregj
        i/gqcE1diQn/NJOedW/VA2UZJq34c156IxzoaYbFh52oGA10tg==
X-Google-Smtp-Source: AA0mqf4DCk0ParghyE4fj9eZZvvy0WbsGmVGy4yuDDXlIYdulWkpQwpmAj3+HsVlzh+fSws2ifKlC2iPCo+5pyrHq5c=
X-Received: by 2002:a81:9bc6:0:b0:373:45d9:2263 with SMTP id
 s189-20020a819bc6000000b0037345d92263mr52738017ywg.507.1669711002850; Tue, 29
 Nov 2022 00:36:42 -0800 (PST)
MIME-Version: 1.0
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com> <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
In-Reply-To: <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 29 Nov 2022 10:36:31 +0200
Message-ID: <CAHsH6Gtfe-nPTpquN=25gWuGL3ZGg9tBeQ=nFJGmtPNbMM0ghQ@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(sent again in plain text, sorry for the noise).

Hi Martin.

On Tue, Nov 29, 2022 at 3:58 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/28/22 8:05 AM, Eyal Birger wrote:
> > This change adds xfrm metadata helpers using the unstable kfunc call
> > interface for the TC-BPF hooks. This allows steering traffic towards
> > different IPsec connections based on logic implemented in bpf programs.
> >
> > This object is built based on the availabilty of BTF debug info.
> >
> > The metadata percpu dsts used on TX take ownership of the original skb
> > dsts so that they may be used as part of the xfrm transmittion logic -
> > e.g.  for MTU calculations.
>
> A few quick comments and questions:

Thanks for your comments!

>
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
> >   include/net/dst_metadata.h     |  1 +
> >   include/net/xfrm.h             | 20 ++++++++
> >   net/core/dst.c                 |  4 ++
> >   net/xfrm/Makefile              |  6 +++
> >   net/xfrm/xfrm_interface_bpf.c  | 92 ++++++++++++++++++++++++++++++++++
>
> Please tag for bpf-next
Sure. I wasn't totally sure which tree this belongs to.

>
> >   net/xfrm/xfrm_interface_core.c | 15 ++++++
> >   6 files changed, 138 insertions(+)
> >   create mode 100644 net/xfrm/xfrm_interface_bpf.c
> >
> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> > index a454cf4327fe..1b7fae4c6b24 100644
> > --- a/include/net/dst_metadata.h
> > +++ b/include/net/dst_metadata.h
> > @@ -26,6 +26,7 @@ struct macsec_info {
> >   struct xfrm_md_info {
> >       u32 if_id;
> >       int link;
> > +     struct dst_entry *dst_orig;
> >   };
> >
> >   struct metadata_dst {
>
> [ ... ]
>
> > diff --git a/net/core/dst.c b/net/core/dst.c
> > index bc9c9be4e080..4c2eb7e56dab 100644
> > --- a/net/core/dst.c
> > +++ b/net/core/dst.c
> > @@ -315,6 +315,8 @@ void metadata_dst_free(struct metadata_dst *md_dst)
> >   #ifdef CONFIG_DST_CACHE
> >       if (md_dst->type == METADATA_IP_TUNNEL)
> >               dst_cache_destroy(&md_dst->u.tun_info.dst_cache);
> > +     else if (md_dst->type == METADATA_XFRM)
> > +             dst_release(md_dst->u.xfrm_info.dst_orig);
>
> Why only release dst_orig under CONFIG_DST_CACHE?
It's a relic from a previous version where I'd used dst cache.
Will move out of this ifdef.

>
> >   #endif
> >       kfree(md_dst);
> >   }
> > @@ -348,6 +350,8 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
> >
> >               if (one_md_dst->type == METADATA_IP_TUNNEL)
> >                       dst_cache_destroy(&one_md_dst->u.tun_info.dst_cache);
> > +             else if (one_md_dst->type == METADATA_XFRM)
> > +                     dst_release(one_md_dst->u.xfrm_info.dst_orig);
>
> Same here.

Likewise.

>
> [ ... ]
>
> > diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> > new file mode 100644
> > index 000000000000..d3997ab7cc28
> > --- /dev/null
> > +++ b/net/xfrm/xfrm_interface_bpf.c
> > @@ -0,0 +1,92 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Unstable XFRM Helpers for TC-BPF hook
> > + *
> > + * These are called from SCHED_CLS BPF programs. Note that it is
> > + * allowed to break compatibility for these functions since the interface they
> > + * are exposed through to BPF programs is explicitly unstable.
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> > +
> > +#include <net/dst_metadata.h>
> > +#include <net/xfrm.h>
> > +
> > +struct bpf_xfrm_info {
> > +     u32 if_id;
> > +     int link;
> > +};
> > +
> > +static struct metadata_dst __percpu *xfrm_md_dst;
> > +__diag_push();
> > +__diag_ignore_all("-Wmissing-prototypes",
> > +               "Global functions as their definitions will be in xfrm_interface BTF");
> > +
> > +__used noinline
> > +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
> > +{
> > +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > +     struct xfrm_md_info *info;
> > +
> > +     memset(to, 0, sizeof(*to));
> > +
> > +     info = skb_xfrm_md_info(skb);
> > +     if (!info)
> > +             return -EINVAL;
> > +
> > +     to->if_id = info->if_id;
> > +     to->link = info->link;
> > +     return 0;
> > +}
> > +
> > +__used noinline
> > +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> > +                       const struct bpf_xfrm_info *from)
> > +{
> > +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > +     struct metadata_dst *md_dst;
> > +     struct xfrm_md_info *info;
> > +
> > +     if (unlikely(skb_metadata_dst(skb)))
> > +             return -EINVAL;
> > +
> > +     md_dst = this_cpu_ptr(xfrm_md_dst);
> > +
> > +     info = &md_dst->u.xfrm_info;
> > +     memset(info, 0, sizeof(*info));
> > +
> > +     info->if_id = from->if_id;
> > +     info->link = from->link;
> > +     info->dst_orig = skb_dst(skb);
> However, the dst_orig init is not done under CONFIG_DST_CACHE though...
>
> Also, is it possible that skb->_skb_refdst has SKB_DST_NOREF set and later below
> ... (contd)
Nice catch! will force dst is refcounted.

>
> > +
> > +     dst_hold((struct dst_entry *)md_dst);
> > +     skb_dst_set(skb, (struct dst_entry *)md_dst);
> > +     return 0;
> > +}
> > +
> > +__diag_pop()
> > +
> > +BTF_SET8_START(xfrm_ifc_kfunc_set)
> > +BTF_ID_FLAGS(func, bpf_skb_get_xfrm_info)
> > +BTF_ID_FLAGS(func, bpf_skb_set_xfrm_info)
> > +BTF_SET8_END(xfrm_ifc_kfunc_set)
> > +
> > +static const struct btf_kfunc_id_set xfrm_interface_kfunc_set = {
> > +     .owner = THIS_MODULE,
> > +     .set   = &xfrm_ifc_kfunc_set,
> > +};
> > +
> > +int __init register_xfrm_interface_bpf(void)
> > +{
> > +     xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
> > +                                             GFP_KERNEL);
> > +     if (!xfrm_md_dst)
> > +             return -ENOMEM;
> > +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> > +                                      &xfrm_interface_kfunc_set);
>
> Will cleanup_xfrm_interface_bpf() be called during error ?
No. Will fix in v2.

Thanks!
Eyal.
