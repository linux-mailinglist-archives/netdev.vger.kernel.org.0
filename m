Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3863E982
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLAFzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLAFzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:55:14 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EDE9583B;
        Wed, 30 Nov 2022 21:55:13 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d128so703478ybf.10;
        Wed, 30 Nov 2022 21:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yChL7yIzCEnt3FjAwYUfXFZMG8wFD6K7PQfVtNZ56BI=;
        b=PUXMai9A1+c/BuiVcJUtuJu9PJnM364XcRVPfOyptdLUg+n9WJw9VO5lv83UPNiPo2
         cHWvZ560kSWkgIYmiGCfe0GX/SMkBiat9WUsWKUS0+gU+h721HGmSZgjC+DvAC5/rOWD
         x9XtYOtfbN/PVQrS7EjaBfgz+vHd4KKit+Dw5x+BljTtYoxyJNQy8k6ZmZammc+O/t/G
         m+JWnWEc2Zf4YE4tsFuJ7EbV5lKnJJ0eqRALiNSX2cQ/HrCK5L94kxhDUaxlBx4AcutZ
         /REApkFNxZw+Q/3snHFOzNp85T1AW8UO56ZeYArE5gSYcqAY6gwPxNxngESbINkrAFdS
         3gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yChL7yIzCEnt3FjAwYUfXFZMG8wFD6K7PQfVtNZ56BI=;
        b=kO2c5dSYl6tj+0Y9rSUriWBz7KwbHIA6bvVkwrrNmy5gCB0MSuwCuLtlWXLdVAq3Xp
         qlMdM6VIzapSa/Vq70VmP/7NQIPEZH53KgTXLKzuwsWSvaBv5U1VKa4zaMxpS48FMfkz
         Zi0CvTyLKM/lyU6lb4BWsTDoyibNiLEUZKRovBzRrN6SmyIdYHmKqJThOjPPpSlk/HnK
         7J/AUIOajWRsLCC8fQZoV2RgbJz35z3Ls1Y2Et7AxVmPMjEooYguMKWGRo3NCJExKJgH
         ZRfVJ9YH+myH/Bh4qv0SFsNF7TDUAceG3QW8e5YPfHpvomI82noKMTqiDTXkv3H5Y9OV
         kKHA==
X-Gm-Message-State: ANoB5plWyAi6+dwBQEVk0AgBYwB46M33UbnHy6stYksOti/6cPNj4kdW
        4AahfI7ykDeXg1LrfejzUkNqvz2j2KKyIMhqmb4=
X-Google-Smtp-Source: AA0mqf6QHww4klkODIMKsBdjtBa8m8YVL/lhkBwWrXCeKJoAAu/2zmYb7QyLPx2e8ttHEgggj0mp1AtBGiTmFB1XuLw=
X-Received: by 2002:a05:6902:b1f:b0:6bd:b8f1:1495 with SMTP id
 ch31-20020a0569020b1f00b006bdb8f11495mr52365332ybb.160.1669874112445; Wed, 30
 Nov 2022 21:55:12 -0800 (PST)
MIME-Version: 1.0
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-3-eyal.birger@gmail.com> <b3306950-bea9-e914-0491-54048d6d55e4@linux.dev>
In-Reply-To: <b3306950-bea9-e914-0491-54048d6d55e4@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 1 Dec 2022 07:55:01 +0200
Message-ID: <CAHsH6Gs4OajjoXauDw9zERx=+tUqpbpnP_8SxzmKKDQ3r8xmJA@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: Add unstable helpers
 for setting/getting XFRM metadata from TC-BPF
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

Hi Martin,

On Wed, Nov 30, 2022 at 8:15 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/29/22 5:20 AM, Eyal Birger wrote:
> > diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> > new file mode 100644
> > index 000000000000..757e15857dbf
> > --- /dev/null
> > +++ b/net/xfrm/xfrm_interface_bpf.c
> > @@ -0,0 +1,100 @@
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
> No need to introduce a bpf variant of the "struct xfrm_md_info" (more on this
> later).
>
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
>
> This kfunc is not needed.  It only reads the skb->_skb_refdst.  The new kfunc
> bpf_rdonly_cast() can be used.  Take a look at the bpf_rdonly_cast() usages in
> the selftests/bpf/progs/type_cast.c.  It was in bpf-next only but should also be
> in net-next now.

I'm somewhat concerned with this approach.
Indeed it would remove the kfunc, and the API is declared "unstable", but
still the implementation as dst isn't relevant to the user and would make
the programs less readable.

Also note that the helper can be also used as it is to get the xfrm info at
egress from an lwt route (which stores the xfrm_info in the dst lwstate).

>
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
>
> Directly use "const struct xfrm_md_info *from" instead.  This kfunc can check
> from->dst_orig != NULL and return -EINVAL.  It will then have a consistent API
> with the bpf_rdonly_cast() mentioned above.

See above.

>
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
>
> Unnecessary memset here.  Everything should have been initialized below.
> bpf_skb_set_tunnel_key() needs memset but not here.

Ok.

>
> > +
> > +     info->if_id = from->if_id;
> > +     info->link = from->link;
> > +     skb_dst_force(skb);
> > +     info->dst_orig = skb_dst(skb);
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
> > +     int err;
> > +
> > +     xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
> > +                                             GFP_KERNEL);
>
> May be DEFINE_PER_CPU() instead?

Are you suggesting duplicating the dst init/cleanup logic here?
Personally given that this happens once at module load, I think it's best to
use the existing infrastructure, but am willing to add this here if you think
it's better.

Thanks for the review!
Eyal.
