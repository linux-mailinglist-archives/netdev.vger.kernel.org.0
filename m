Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E2659A9AC
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbiHSXqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiHSXql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:46:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86FC108968;
        Fri, 19 Aug 2022 16:46:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p9so3022880ilq.13;
        Fri, 19 Aug 2022 16:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ciaIRFjxJgwWQk4FZ9TLXWaq2XObOfBUrupVf0qUl/U=;
        b=OLRJTH/0s+9H+0/1l/4JgfDU46IgB+R+76qm7nlO/h8miTy069mE2GJN1qoQ9ER8zp
         cedaB33WWIGDzjnOVVu64qVpESqTogSiDDTCK44jLu3ScYrqkF5aIVOMDJB3CKd0rfc/
         r5Atc79IkUQC6t2Uv2lIlpZ/rDF2TRg2XS2TwdtMLkKLG8ywCiSoXDVQHHwVoehDeEFy
         OQ+/1PDDdDnjm0cXll5Dk+TmOTWpRRvDXQVfhgLX/ZhzwHmjDAMmU1nEelPCRC6G8uzJ
         Ghceck87L++GpFQ7lp2+nhXK/bkPmwJgyXxIFdtNWzy/8SBBv4/q7ne78wMJYXuaaFcc
         GqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ciaIRFjxJgwWQk4FZ9TLXWaq2XObOfBUrupVf0qUl/U=;
        b=cpkloYTQoRYWgBsI21yG14keYtH/jnrb8KbuCSNpiCIA8o5d4IeoEIo8vNjHVCLWNz
         oDuWbdOffJNsixGol4sEDjaePHSCPhAkF5fAblRjHCtWnqGlaPnet5POIFnTldrO+oPJ
         JTfNslgcCqilSuBNGefmyoR9poUsJY34Q+zUDu1I9Pa0PrOlJWSL0jnF7oYk5AYUkPf1
         CEk6z1/TsGKlgyDnQfBx1MIA+kSSnN6xySs1Thd0cSo2fKlsLkR7SKLye6I7QGIv1dvW
         1Z+TuwAA5VixvxZfvfjpDJbUztRk2f+cEIcZjj5EhG2LSLILWHqKO65GfOSAj1ndkYMm
         NS8A==
X-Gm-Message-State: ACgBeo33/2qsoB5G/VIIc9iH1LBEYEZHB3m8yoFsJ5TheE/NE4ufgH0T
        NvKbhCJGWfWtKM1YsKlNiQ55di8fLD/An88F3YI=
X-Google-Smtp-Source: AA6agR5pcSY/S5nlAyKMZAceBx8UB6SisICUd/x6Jxz4WBNu23K8M2aQjqjKQQPyD39zpmcq9WSJ3dR/ctIUgBopZW4=
X-Received: by 2002:a05:6e02:1c04:b0:2df:6b58:5fe8 with SMTP id
 l4-20020a056e021c0400b002df6b585fe8mr4916468ilh.68.1660952800281; Fri, 19 Aug
 2022 16:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660951028.git.dxu@dxuuu.xyz> <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
In-Reply-To: <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 20 Aug 2022 01:46:04 +0200
Message-ID: <CAP01T74fSh6Z=54O+ORKJD7i_izb7rUe3-mHKLgRdrckcisvkw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add support for writing to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Aug 2022 at 01:23, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Support direct writes to nf_conn:mark from TC and XDP prog types. This
> is useful when applications want to store per-connection metadata. This
> is also particularly useful for applications that run both bpf and
> iptables/nftables because the latter can trivially access this metadata.
>
> One example use case would be if a bpf prog is responsible for advanced
> packet classification and iptables/nftables is later used for routing
> due to pre-existing/legacy code.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  include/net/netfilter/nf_conntrack_bpf.h | 13 +++++
>  net/core/filter.c                        | 50 ++++++++++++++++++
>  net/netfilter/nf_conntrack_bpf.c         | 64 +++++++++++++++++++++++-
>  net/netfilter/nf_conntrack_core.c        |  1 +
>  4 files changed, 127 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index a473b56842c5..4ef89ee5b5a9 100644
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -3,13 +3,22 @@
>  #ifndef _NF_CONNTRACK_BPF_H
>  #define _NF_CONNTRACK_BPF_H
>
> +#include <linux/bpf.h>
>  #include <linux/btf.h>
>  #include <linux/kconfig.h>
>
> +extern int (*nf_conntrack_btf_struct_access)(struct bpf_verifier_log *log,
> +                                            const struct btf *btf,
> +                                            const struct btf_type *t, int off,
> +                                            int size, enum bpf_access_type atype,
> +                                            u32 *next_btf_id,
> +                                            enum bpf_type_flag *flag);
> +
>  #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
>      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>
>  extern int register_nf_conntrack_bpf(void);
> +extern void cleanup_nf_conntrack_bpf(void);
>
>  #else
>
> @@ -18,6 +27,10 @@ static inline int register_nf_conntrack_bpf(void)
>         return 0;
>  }
>
> +static inline void cleanup_nf_conntrack_bpf(void)
> +{
> +}
> +
>  #endif
>
>  #endif /* _NF_CONNTRACK_BPF_H */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1acfaffeaf32..e5f48e6030b7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -18,6 +18,7 @@
>   */
>
>  #include <linux/atomic.h>
> +#include <linux/bpf_verifier.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
> @@ -55,6 +56,7 @@
>  #include <net/sock_reuseport.h>
>  #include <net/busy_poll.h>
>  #include <net/tcp.h>
> +#include <net/netfilter/nf_conntrack_bpf.h>
>  #include <net/xfrm.h>
>  #include <net/udp.h>
>  #include <linux/bpf_trace.h>
> @@ -8628,6 +8630,32 @@ static bool tc_cls_act_is_valid_access(int off, int size,
>         return bpf_skb_is_valid_access(off, size, type, prog, info);
>  }
>
> +typedef int (*btf_struct_access_t)(struct bpf_verifier_log *log,
> +                                const struct btf *btf,
> +                                const struct btf_type *t, int off, int size,
> +                                enum bpf_access_type atype,
> +                                u32 *next_btf_id, enum bpf_type_flag *flag);
> +
> +static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
> +                                       const struct btf *btf,
> +                                       const struct btf_type *t, int off,
> +                                       int size, enum bpf_access_type atype,
> +                                       u32 *next_btf_id,
> +                                       enum bpf_type_flag *flag)
> +{
> +       btf_struct_access_t sa;
> +
> +       if (atype == BPF_READ)
> +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> +                                        flag);
> +
> +       sa = READ_ONCE(nf_conntrack_btf_struct_access);

This looks unsafe. How do you prevent this race?

CPU 0                                              CPU 1
sa = READ_ONCE(nf_ct_bsa);

delete_module("nf_conntrack", ..);

WRITE_ONCE(nf_ct_bsa, NULL);
                                                         // finishes
successfully
if (sa)
    return sa(...); // oops

i.e. what keeps the module alive while we execute its callback?

Using a mutex is one way (as I suggested previously), either you
acquire it before unload, or after. If after, you see cb as NULL,
otherwise if unload is triggered concurrently it waits to acquire the
mutex held by us. Unsetting the cb would be the first thing the module
would do.

You can also hold a module reference, but then you must verify it is
nf_conntrack's BTF before using btf_try_get_module.
But _something_ needs to be done to prevent the module from going away
while we execute its code.

> +       if (sa)
> +               return sa(log, btf, t, off, size, atype, next_btf_id, flag);
> +
> +       return -EACCES;
> +}
> +
> [...]
