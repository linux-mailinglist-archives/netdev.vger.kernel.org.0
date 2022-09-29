Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6BD5EF0B0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiI2IiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiI2IiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:38:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407CB12DE8E
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664440688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XCejEhOZeEz4lRq8eB7eRjuOrzlC81ktVxPeHJ8t7qA=;
        b=OMlKwrm20fXyyrXcJAZqUfPsrV/vhE2O4/8M4C07yS7HLS1j9gyOX+4OSz7aLvMDwJP9iT
        4XZCIAE8DaVWXPNIDxcg5oiNkp8L6hHW2dR5egaorA/KoSfZ88CDlG8OA5M0Rc/1+kuJwD
        thqyFYVkvxoxXQ4qsq8fiLsb40KiD3E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-274-jCZ7xNPPMQaGdNPgPFMxEg-1; Thu, 29 Sep 2022 04:38:07 -0400
X-MC-Unique: jCZ7xNPPMQaGdNPgPFMxEg-1
Received: by mail-wr1-f72.google.com with SMTP id d18-20020adfa352000000b0022cbe33d2a5so246435wrb.11
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=XCejEhOZeEz4lRq8eB7eRjuOrzlC81ktVxPeHJ8t7qA=;
        b=zXVTCNY3sOtvo90tImXuF8jkIX7MF7h6T4qleOhKGLjHWN8CN0E7lqjHOfT967v03J
         JRj5qFAU5hHQO7wwJAhObLaGkjACKBU7tEkq6zgkJHY8oZHZzGzBKhbYPD1irCWmpvDZ
         5ecchCd58lkZF8DMueg8jrGgwyfDcRaV8dlOs25gOPXtrQsLDUCZo4Tdzu8qHHhDr8yG
         HO6PGlwa6B1HInNSLtJvH3WiW05Qiq1hd137Hx3Kv9Z1Rf5Wey0We76fMKvBsF3Oo2Jf
         4KtUqnQkv4aDoBViy7IgWVdYMYv29+ssZulBPxFbrCsAu1K0a+eznX0Mynu/l+dH1Z9V
         rPbg==
X-Gm-Message-State: ACrzQf2yRvCPdA2gVzXGVxga+lrz0t5LWXWT4wrgpRWc7arkD5pntlnq
        Cmq1XckIuUKXsY4AaTVYC7G2uNfuWYaqOGBnnAzt7Uhtrf/1tLMDRj0f3COusb4q9XqXDA5/qOj
        6Y0/InBk3q6hReP0cK6e+dEIX/jGQ/JCe
X-Received: by 2002:a05:6000:184e:b0:228:bc3a:8e35 with SMTP id c14-20020a056000184e00b00228bc3a8e35mr1310722wri.443.1664440685986;
        Thu, 29 Sep 2022 01:38:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4m8/ZPNZDCLAnP6JQdsaOW9OGZVvqHY8iEty+ntfHNZtB3G4XLZkfhAggzN/lIGjtSbNJoPsCBmBM26YqhzYQ=
X-Received: by 2002:a05:6000:184e:b0:228:bc3a:8e35 with SMTP id
 c14-20020a056000184e00b00228bc3a8e35mr1310700wri.443.1664440685683; Thu, 29
 Sep 2022 01:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <ddd17d808fe25917893eb035b20146479810124c.1664111646.git.lorenzo@kernel.org>
In-Reply-To: <ddd17d808fe25917893eb035b20146479810124c.1664111646.git.lorenzo@kernel.org>
From:   Yauheni Kaliuta <ykaliuta@redhat.com>
Date:   Thu, 29 Sep 2022 11:37:49 +0300
Message-ID: <CANoWswkJwZ0mLVmA5npm6Zty=CXJ1dupKvOjAU5G+Y19xM9T0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc
 in nf_nat_bpf.c
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Brouer <brouer@redhat.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The patch leads to

depmod: ERROR: Cycle detected: nf_conntrack -> nf_nat -> nf_conntrack

when it is built as modules (due to nf_nat_setup_info() dependency)

On Sun, Sep 25, 2022 at 4:26 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Remove circular dependency between nf_nat module and nf_conntrack one
> moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
>
> Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/netfilter/nf_conntrack_bpf.h |  5 ++
>  include/net/netfilter/nf_nat.h           | 14 +++++
>  net/netfilter/Makefile                   |  6 ++
>  net/netfilter/nf_conntrack_bpf.c         | 49 ---------------
>  net/netfilter/nf_nat_bpf.c               | 79 ++++++++++++++++++++++++
>  net/netfilter/nf_nat_core.c              |  2 +-
>  6 files changed, 105 insertions(+), 50 deletions(-)
>  create mode 100644 net/netfilter/nf_nat_bpf.c
>
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index c8b80add1142..1ce46e406062 100644
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -4,6 +4,11 @@
>  #define _NF_CONNTRACK_BPF_H
>
>  #include <linux/kconfig.h>
> +#include <net/netfilter/nf_conntrack.h>
> +
> +struct nf_conn___init {
> +       struct nf_conn ct;
> +};
>
>  #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
>      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
> index e9eb01e99d2f..cd084059a953 100644
> --- a/include/net/netfilter/nf_nat.h
> +++ b/include/net/netfilter/nf_nat.h
> @@ -68,6 +68,20 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
>  #endif
>  }
>
> +#if (IS_BUILTIN(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> +    (IS_MODULE(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> +
> +extern int register_nf_nat_bpf(void);
> +
> +#else
> +
> +static inline int register_nf_nat_bpf(void)
> +{
> +       return 0;
> +}
> +
> +#endif
> +
>  int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
>                        const struct nf_hook_ops *nat_ops, unsigned int ops_count);
>  void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 06df49ea6329..0f060d100880 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -60,6 +60,12 @@ obj-$(CONFIG_NF_NAT) += nf_nat.o
>  nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
>  nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
>
> +ifeq ($(CONFIG_NF_NAT),m)
> +nf_nat-$(CONFIG_DEBUG_INFO_BTF_MODULES) += nf_nat_bpf.o
> +else ifeq ($(CONFIG_NF_NAT),y)
> +nf_nat-$(CONFIG_DEBUG_INFO_BTF) += nf_nat_bpf.o
> +endif
> +
>  # NAT helpers
>  obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
>  obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 756ea818574e..f4ba4ff3a63b 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -14,7 +14,6 @@
>  #include <linux/types.h>
>  #include <linux/btf_ids.h>
>  #include <linux/net_namespace.h>
> -#include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_bpf.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_nat.h>
> @@ -239,10 +238,6 @@ __diag_push();
>  __diag_ignore_all("-Wmissing-prototypes",
>                   "Global functions as their definitions will be in nf_conntrack BTF");
>
> -struct nf_conn___init {
> -       struct nf_conn ct;
> -};
> -
>  /* bpf_xdp_ct_alloc - Allocate a new CT entry
>   *
>   * Parameters:
> @@ -476,49 +471,6 @@ int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
>         return nf_ct_change_status_common(nfct, status);
>  }
>
> -/* bpf_ct_set_nat_info - Set source or destination nat address
> - *
> - * Set source or destination nat address of the newly allocated
> - * nf_conn before insertion. This must be invoked for referenced
> - * PTR_TO_BTF_ID to nf_conn___init.
> - *
> - * Parameters:
> - * @nfct       - Pointer to referenced nf_conn object, obtained using
> - *               bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
> - * @addr       - Nat source/destination address
> - * @port       - Nat source/destination port. Non-positive values are
> - *               interpreted as select a random port.
> - * @manip      - NF_NAT_MANIP_SRC or NF_NAT_MANIP_DST
> - */
> -int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
> -                       union nf_inet_addr *addr, int port,
> -                       enum nf_nat_manip_type manip)
> -{
> -#if ((IS_MODULE(CONFIG_NF_NAT) && IS_MODULE(CONFIG_NF_CONNTRACK)) || \
> -     IS_BUILTIN(CONFIG_NF_NAT))
> -       struct nf_conn *ct = (struct nf_conn *)nfct;
> -       u16 proto = nf_ct_l3num(ct);
> -       struct nf_nat_range2 range;
> -
> -       if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
> -               return -EINVAL;
> -
> -       memset(&range, 0, sizeof(struct nf_nat_range2));
> -       range.flags = NF_NAT_RANGE_MAP_IPS;
> -       range.min_addr = *addr;
> -       range.max_addr = range.min_addr;
> -       if (port > 0) {
> -               range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> -               range.min_proto.all = cpu_to_be16(port);
> -               range.max_proto.all = range.min_proto.all;
> -       }
> -
> -       return nf_nat_setup_info(ct, &range, manip) == NF_DROP ? -ENOMEM : 0;
> -#else
> -       return -EOPNOTSUPP;
> -#endif
> -}
> -
>  __diag_pop()
>
>  BTF_SET8_START(nf_ct_kfunc_set)
> @@ -532,7 +484,6 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_ct_set_nat_info, KF_TRUSTED_ARGS)
>  BTF_SET8_END(nf_ct_kfunc_set)
>
>  static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
> diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
> new file mode 100644
> index 000000000000..0fa5a0bbb0ff
> --- /dev/null
> +++ b/net/netfilter/nf_nat_bpf.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Unstable NAT Helpers for XDP and TC-BPF hook
> + *
> + * These are called from the XDP and SCHED_CLS BPF programs. Note that it is
> + * allowed to break compatibility for these functions since the interface they
> + * are exposed through to BPF programs is explicitly unstable.
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <net/netfilter/nf_conntrack_bpf.h>
> +#include <net/netfilter/nf_conntrack_core.h>
> +#include <net/netfilter/nf_nat.h>
> +
> +__diag_push();
> +__diag_ignore_all("-Wmissing-prototypes",
> +                 "Global functions as their definitions will be in nf_nat BTF");
> +
> +/* bpf_ct_set_nat_info - Set source or destination nat address
> + *
> + * Set source or destination nat address of the newly allocated
> + * nf_conn before insertion. This must be invoked for referenced
> + * PTR_TO_BTF_ID to nf_conn___init.
> + *
> + * Parameters:
> + * @nfct       - Pointer to referenced nf_conn object, obtained using
> + *               bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
> + * @addr       - Nat source/destination address
> + * @port       - Nat source/destination port. Non-positive values are
> + *               interpreted as select a random port.
> + * @manip      - NF_NAT_MANIP_SRC or NF_NAT_MANIP_DST
> + */
> +int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
> +                       union nf_inet_addr *addr, int port,
> +                       enum nf_nat_manip_type manip)
> +{
> +       struct nf_conn *ct = (struct nf_conn *)nfct;
> +       u16 proto = nf_ct_l3num(ct);
> +       struct nf_nat_range2 range;
> +
> +       if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
> +               return -EINVAL;
> +
> +       memset(&range, 0, sizeof(struct nf_nat_range2));
> +       range.flags = NF_NAT_RANGE_MAP_IPS;
> +       range.min_addr = *addr;
> +       range.max_addr = range.min_addr;
> +       if (port > 0) {
> +               range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> +               range.min_proto.all = cpu_to_be16(port);
> +               range.max_proto.all = range.min_proto.all;
> +       }
> +
> +       return nf_nat_setup_info(ct, &range, manip) == NF_DROP ? -ENOMEM : 0;
> +}
> +
> +__diag_pop()
> +
> +BTF_SET8_START(nf_nat_kfunc_set)
> +BTF_ID_FLAGS(func, bpf_ct_set_nat_info, KF_TRUSTED_ARGS)
> +BTF_SET8_END(nf_nat_kfunc_set)
> +
> +static const struct btf_kfunc_id_set nf_bpf_nat_kfunc_set = {
> +       .owner = THIS_MODULE,
> +       .set   = &nf_nat_kfunc_set,
> +};
> +
> +int register_nf_nat_bpf(void)
> +{
> +       int ret;
> +
> +       ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP,
> +                                       &nf_bpf_nat_kfunc_set);
> +       if (ret)
> +               return ret;
> +
> +       return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> +                                        &nf_bpf_nat_kfunc_set);
> +}
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 7981be526f26..1ed09c9af5e5 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -1152,7 +1152,7 @@ static int __init nf_nat_init(void)
>         WARN_ON(nf_nat_hook != NULL);
>         RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
>
> -       return 0;
> +       return register_nf_nat_bpf();
>  }
>
>  static void __exit nf_nat_cleanup(void)
> --
> 2.37.3
>


-- 
WBR, Yauheni

