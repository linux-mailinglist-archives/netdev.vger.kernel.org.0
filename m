Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB93359CD18
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbiHWARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiHWARW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:17:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19ED1AE;
        Mon, 22 Aug 2022 17:17:20 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t17so2284878ilp.13;
        Mon, 22 Aug 2022 17:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Q1e6J5MEZ22W6voao2fUVGiYKAXZ68HBiqOCl6kZ8+g=;
        b=Oc8FV9uFE/koUzEiq5yuXW/Ueo5n/dqHvEKy2vXdhmdL+YuUSm0gwnSPV/sqiBnwe3
         +udyuuSbsh3OrQPA6WKG7nnVfqCWdZnAhImjYwtOnvxXdF1RsuHXxqWNqaNLm7XHAhIG
         jqD2z3TfOG6k/F4hYx1Lrnzw/jVQwsldylgY15araiWPZWLvO/kijKm2dayEXDnBGNyp
         dwN2pjjleNK6T/aFSSonMoTXs33OUWBldvpE3gtiReSIu14M+n8BYtN9ShtdnjJ+ZdQB
         kwMWKWeFGI5j6V8ti3+wNztpU+BfT4bKP6ZQUH+uaQWb0xLAWqC2p7ldEPpjqtfCV1GW
         iT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Q1e6J5MEZ22W6voao2fUVGiYKAXZ68HBiqOCl6kZ8+g=;
        b=e3dId6LlVxGum1vS4n8HJHhwH+rXFS1TE9khWhsS74dXhbsL24dmyKFp9rJ15B2oBO
         hEepS2LUyCPDPeozGb0QFfYhM6fExY+IqvPqBYaqrwWrhXH2PQlgG8xaLumrHK8t/DjI
         1/Z6Hj+mcRo+zv+002/bDhODj6gB/22iixNCueI9/gHJWlZyhy8Fnuc2G4gemol1ZSRx
         9W6Gvp3hAhBcJq3ZILOI7eGFqgtWlkvI/7KhyXdYsiSJKYV0xWW0bDshZ2dHtQwVghus
         mr9h0nW2wPcoBWo/geImKek59M7p1EjPcPEJ3UuXcgb0LvuHAeDbXVrcE9Sdr80gnw5x
         7oKw==
X-Gm-Message-State: ACgBeo1HNb2Qc4gWirLGtd89x9GSDrxRoMmgqfYzxzu5OJcxEJ4UctFd
        4fl/iokZSD/tONM/mtetWNS40+OPnZhaoQz0gQtAXBt0xKg=
X-Google-Smtp-Source: AA6agR4RWu51SsS2QRW3pRf/omz5hfFeHMf5WRKN1yIdhHnMISRXu+dIdkbZr70jvwyFHWw+tvMUYNDrB/ToV17uSWI=
X-Received: by 2002:a05:6e02:661:b0:2e2:be22:67f0 with SMTP id
 l1-20020a056e02066100b002e2be2267f0mr11250109ilt.91.1661213840141; Mon, 22
 Aug 2022 17:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1661192455.git.dxu@dxuuu.xyz> <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
In-Reply-To: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 23 Aug 2022 02:16:42 +0200
Message-ID: <CAP01T74XK_6wMi+tzReTkBqmZkKbUqCmV6pVwcbCMrHrv0X0SA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/5] bpf: Add support for writing to nf_conn:mark
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

On Mon, 22 Aug 2022 at 20:26, Daniel Xu <dxu@dxuuu.xyz> wrote:
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
>  include/net/netfilter/nf_conntrack_bpf.h | 22 ++++++
>  net/core/filter.c                        | 34 +++++++++
>  net/netfilter/nf_conntrack_bpf.c         | 91 +++++++++++++++++++++++-
>  net/netfilter/nf_conntrack_core.c        |  1 +
>  4 files changed, 147 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index a473b56842c5..6fc03066846b 100644
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -3,6 +3,7 @@
>  #ifndef _NF_CONNTRACK_BPF_H
>  #define _NF_CONNTRACK_BPF_H
>
> +#include <linux/bpf.h>
>  #include <linux/btf.h>
>  #include <linux/kconfig.h>
>
> @@ -10,6 +11,13 @@
>      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>
>  extern int register_nf_conntrack_bpf(void);
> +extern void cleanup_nf_conntrack_bpf(void);
> +extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                         const struct btf *btf,
> +                                         const struct btf_type *t, int off,
> +                                         int size, enum bpf_access_type atype,
> +                                         u32 *next_btf_id,
> +                                         enum bpf_type_flag *flag);
>
>  #else
>
> @@ -18,6 +26,20 @@ static inline int register_nf_conntrack_bpf(void)
>         return 0;
>  }
>
> +static inline void cleanup_nf_conntrack_bpf(void)
> +{
> +}
> +
> +static inline int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                                const struct btf *btf,
> +                                                const struct btf_type *t, int off,
> +                                                int size, enum bpf_access_type atype,
> +                                                u32 *next_btf_id,
> +                                                enum bpf_type_flag *flag)
> +{
> +       return -EACCES;
> +}
> +
>  #endif
>
>  #endif /* _NF_CONNTRACK_BPF_H */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1acfaffeaf32..25bdbf6dc76b 100644
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
> @@ -8628,6 +8630,21 @@ static bool tc_cls_act_is_valid_access(int off, int size,
>         return bpf_skb_is_valid_access(off, size, type, prog, info);
>  }
>
> +static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
> +                                       const struct btf *btf,
> +                                       const struct btf_type *t, int off,
> +                                       int size, enum bpf_access_type atype,
> +                                       u32 *next_btf_id,
> +                                       enum bpf_type_flag *flag)
> +{
> +       if (atype == BPF_READ)
> +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> +                                        flag);
> +
> +       return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
> +                                             next_btf_id, flag);
> +}
> +
>  static bool __is_valid_xdp_access(int off, int size)
>  {
>         if (off < 0 || off >= sizeof(struct xdp_md))
> @@ -8687,6 +8704,21 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
>  }
>  EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
>
> +static int xdp_btf_struct_access(struct bpf_verifier_log *log,
> +                                const struct btf *btf,
> +                                const struct btf_type *t, int off,
> +                                int size, enum bpf_access_type atype,
> +                                u32 *next_btf_id,
> +                                enum bpf_type_flag *flag)
> +{
> +       if (atype == BPF_READ)
> +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> +                                        flag);
> +
> +       return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
> +                                             next_btf_id, flag);
> +}
> +
>  static bool sock_addr_is_valid_access(int off, int size,
>                                       enum bpf_access_type type,
>                                       const struct bpf_prog *prog,
> @@ -10581,6 +10613,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
>         .convert_ctx_access     = tc_cls_act_convert_ctx_access,
>         .gen_prologue           = tc_cls_act_prologue,
>         .gen_ld_abs             = bpf_gen_ld_abs,
> +       .btf_struct_access      = tc_cls_act_btf_struct_access,
>  };
>
>  const struct bpf_prog_ops tc_cls_act_prog_ops = {
> @@ -10592,6 +10625,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
>         .is_valid_access        = xdp_is_valid_access,
>         .convert_ctx_access     = xdp_convert_ctx_access,
>         .gen_prologue           = bpf_noop_prologue,
> +       .btf_struct_access      = xdp_btf_struct_access,
>  };
>
>  const struct bpf_prog_ops xdp_prog_ops = {
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 1cd87b28c9b0..da54355927d4 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -6,8 +6,10 @@
>   * are exposed through to BPF programs is explicitly unstable.
>   */
>
> +#include <linux/bpf_verifier.h>
>  #include <linux/bpf.h>
>  #include <linux/btf.h>
> +#include <linux/mutex.h>
>  #include <linux/types.h>
>  #include <linux/btf_ids.h>
>  #include <linux/net_namespace.h>
> @@ -184,6 +186,79 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>         return ct;
>  }
>
> +BTF_ID_LIST(btf_nf_conn_ids)
> +BTF_ID(struct, nf_conn)
> +BTF_ID(struct, nf_conn___init)
> +
> +static DEFINE_MUTEX(btf_access_lock);
> +static int (*nfct_bsa)(struct bpf_verifier_log *log,
> +                      const struct btf *btf,
> +                      const struct btf_type *t, int off,
> +                      int size, enum bpf_access_type atype,
> +                      u32 *next_btf_id,
> +                      enum bpf_type_flag *flag);
> +
> +/* Check writes into `struct nf_conn` */
> +static int _nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                          const struct btf *btf,
> +                                          const struct btf_type *t, int off,
> +                                          int size, enum bpf_access_type atype,
> +                                          u32 *next_btf_id,
> +                                          enum bpf_type_flag *flag)
> +{
> +       const struct btf_type *ncit;
> +       const struct btf_type *nct;
> +       size_t end;
> +
> +       ncit = btf_type_by_id(btf, btf_nf_conn_ids[1]);
> +       nct = btf_type_by_id(btf, btf_nf_conn_ids[0]);
> +
> +       if (t != nct && t != ncit) {
> +               bpf_log(log, "only read is supported\n");
> +               return -EACCES;
> +       }
> +
> +       /* `struct nf_conn` and `struct nf_conn___init` have the same layout
> +        * so we are safe to simply merge offset checks here
> +        */
> +       switch (off) {
> +#if defined(CONFIG_NF_CONNTRACK_MARK)
> +       case offsetof(struct nf_conn, mark):
> +               end = offsetofend(struct nf_conn, mark);
> +               break;
> +#endif
> +       default:
> +               bpf_log(log, "no write support to nf_conn at off %d\n", off);
> +               return -EACCES;
> +       }
> +
> +       if (off + size > end) {
> +               bpf_log(log,
> +                       "write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
> +                       off, size, end);
> +               return -EACCES;
> +       }
> +
> +       return 0;
> +}
> +
> +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                  const struct btf *btf,
> +                                  const struct btf_type *t, int off,
> +                                  int size, enum bpf_access_type atype,
> +                                  u32 *next_btf_id,
> +                                  enum bpf_type_flag *flag)
> +{
> +       int ret = -EACCES;
> +
> +       mutex_lock(&btf_access_lock);
> +       if (nfct_bsa)
> +               ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
> +       mutex_unlock(&btf_access_lock);
> +
> +       return ret;
> +}

Did you test this for CONFIG_NF_CONNTRACK=m? For me it isn't building :P.

It won't work like this. When nf_conntrack is a module, the vmlinux.o
of the kernel isn't linked to the object file nf_conntrack_bpf.o.
Hence it would be an undefined reference error. You don't see it in
BPF CI as we set CONFIG_NF_CONNTRACK=y (to simplify testing).

So you need to have code that locks and checks the cb pointer when
calling it outside the module, which means the global lock variable
and global cb pointer also need to be in the kernel. The module then
takes the same lock and sets cb pointer when loading. During unload,
it takes the same lock and sets it back to NULL.

You can have global variables in vmlinux that you reference from
modules. The compiler will emit a relocation for the module object
file which will be handled by the kernel during module load.

So please test it once with nf_conntrack built as a module before
sending the next revision. The only thing you need to do before
running ./test_progs -t bpf_nf is loading the module nf_conntrack.ko
(and its dependencies, nf_defrag_ipv{4,6}.ko).
