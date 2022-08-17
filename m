Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4900D597715
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbiHQTtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiHQTtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:49:09 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5C8C4B;
        Wed, 17 Aug 2022 12:49:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i77so7879911ioa.7;
        Wed, 17 Aug 2022 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=mXFey7C5rzzvTMUksyCcA8ZY/wSq+1n66jBTevjrzBA=;
        b=SaQTQc/v1bGFNoI0owSVWDCBSoJm6zhNQI9pvvqGEdAUhHo+tdhLqGw8KBEJfGcS+c
         IGky5xDHOhRG3ujrF5Bo8wlowFflJb3E7zzFYYKdlAvitehEMiFqM/8MKRIKuGX2QL/x
         gPw3FKljTEc5GK38Xi4abt1YD9rEH87UgQaabsTNlHNf2On0lchQMTmISh9kRYMdjeBX
         5FMn+Pl+ATjjPnYyEMge4gS6QLBO9V5BdOBw1PfPR0ZZcn8DVh2QXkH8vPDXC7NbNXet
         ue8Iue+exSK3rqWb8/Css62Iqzw3X87clI0qnYRfxj/MrAlHXUV/Qt3tsIZ8IaurIBP2
         r3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=mXFey7C5rzzvTMUksyCcA8ZY/wSq+1n66jBTevjrzBA=;
        b=bPi2BCNIcMlZMmHGmAi6QBNiH1xs9LTq7nCdvoS09IIN6O9N7oWa1E2PJ1l7ingdTQ
         t7nZlr5+6JyuC6vxS3+RjRIPcYZ6QrZd1Ge5uBwkPamf/CefipvJMx5DBJ/slALs7AR+
         C3aI+UyuAiXmnMDdyWjY8dUnVqY4GZ0evaqOLxx23BqyPL8Z1Ha9aC7HDEA3dJlRjwQt
         kKMpQMw9P5V+IoIynJU0tAo+qDpMezEOFifYZVa/dUgUstx+cB5VjTQauzEeq7BKwPbB
         d2Y+XXGw8RWGe86Whd2qA/lMVzMDxmJr4wh5E2pK79u8ss2UQTX+MsSPkxd/QgwXkJDl
         vfhQ==
X-Gm-Message-State: ACgBeo1M9fAGxRK/UJwyRDZb9BNwGgdvgg3pFJP/2N6S0nKBnLpMPpX/
        Zo9lj539Rpsz266zJIqIwlLdDdQ9xXSbeY3tazc=
X-Google-Smtp-Source: AA6agR7nMSfswbVek6fZZukATioKLNT79I451ZIVOtDn7mB/ZDCgbqjh1KUts3HB4RAT+BUFiQYTBMcCeDKoPX+9YAM=
X-Received: by 2002:a05:6638:238b:b0:343:ff4:a62 with SMTP id
 q11-20020a056638238b00b003430ff40a62mr12473899jat.124.1660765747640; Wed, 17
 Aug 2022 12:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
In-Reply-To: <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 17 Aug 2022 21:48:31 +0200
Message-ID: <CAP01T75P5uM9EyX38bcoF4L2cbQ8orNVNhZsdoMXRThX5fd6JQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 17 Aug 2022 at 20:43, Daniel Xu <dxu@dxuuu.xyz> wrote:
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
>  include/net/netfilter/nf_conntrack_bpf.h | 18 +++++++++
>  net/core/filter.c                        | 34 ++++++++++++++++
>  net/netfilter/nf_conntrack_bpf.c         | 50 ++++++++++++++++++++++++
>  3 files changed, 102 insertions(+)
>
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index a473b56842c5..0f584c2bd475 100644
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
> @@ -10,6 +11,12 @@
>      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>
>  extern int register_nf_conntrack_bpf(void);
> +extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                         const struct btf *btf,
> +                                         const struct btf_type *t, int off,
> +                                         int size, enum bpf_access_type atype,
> +                                         u32 *next_btf_id,
> +                                         enum bpf_type_flag *flag);
>
>  #else
>
> @@ -18,6 +25,17 @@ static inline int register_nf_conntrack_bpf(void)
>         return 0;
>  }
>
> +static inline int
> +nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                              const struct btf *btf,
> +                              const struct btf_type *t, int off,
> +                              int size, enum bpf_access_type atype,
> +                              u32 *next_btf_id,
> +                              enum bpf_type_flag *flag)
> +{
> +       return -EACCES;
> +}
> +

We should make it work when nf_conntrack is a kernel module as well,
not just when it is compiled in. The rest of the stuff already works
when it is a module. For that, you can have a global function pointer
for this callback, protected by a mutex. register/unregister sets
it/unsets it. Each time you call it requires mutex to be held during
the call.

Later when we have more modules that supply btf_struct_access callback
for their module types we can generalize it, for now it should be ok
to hardcode it for nf_conn.

>  #endif
>
>  #endif /* _NF_CONNTRACK_BPF_H */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5669248aff25..d7b768fe9de7 100644
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
> @@ -8710,6 +8712,21 @@ static bool tc_cls_act_is_valid_access(int off, int size,
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
> @@ -8769,6 +8786,21 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
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
> @@ -10663,6 +10695,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
>         .convert_ctx_access     = tc_cls_act_convert_ctx_access,
>         .gen_prologue           = tc_cls_act_prologue,
>         .gen_ld_abs             = bpf_gen_ld_abs,
> +       .btf_struct_access      = tc_cls_act_btf_struct_access,
>  };
>
>  const struct bpf_prog_ops tc_cls_act_prog_ops = {
> @@ -10674,6 +10707,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
>         .is_valid_access        = xdp_is_valid_access,
>         .convert_ctx_access     = xdp_convert_ctx_access,
>         .gen_prologue           = bpf_noop_prologue,
> +       .btf_struct_access      = xdp_btf_struct_access,
>  };
>
>  const struct bpf_prog_ops xdp_prog_ops = {
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 1cd87b28c9b0..8010cc542d17 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -6,6 +6,7 @@
>   * are exposed through to BPF programs is explicitly unstable.
>   */
>
> +#include <linux/bpf_verifier.h>
>  #include <linux/bpf.h>
>  #include <linux/btf.h>
>  #include <linux/types.h>
> @@ -15,6 +16,8 @@
>  #include <net/netfilter/nf_conntrack_bpf.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>
> +static const struct btf_type *nf_conn_type;
> +
>  /* bpf_ct_opts - Options for CT lookup helpers
>   *
>   * Members:
> @@ -184,6 +187,53 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>         return ct;
>  }
>
> +/* Check writes into `struct nf_conn` */
> +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                  const struct btf *btf,
> +                                  const struct btf_type *t, int off,
> +                                  int size, enum bpf_access_type atype,
> +                                  u32 *next_btf_id,
> +                                  enum bpf_type_flag *flag)
> +{
> +       const struct btf_type *nct = READ_ONCE(nf_conn_type);
> +       s32 type_id;
> +       size_t end;
> +
> +       if (!nct) {
> +               type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
> +               if (type_id < 0)
> +                       return -EINVAL;
> +
> +               nct = btf_type_by_id(btf, type_id);
> +               WRITE_ONCE(nf_conn_type, nct);

Instead of this, why not just use BTF_ID_LIST_SINGLE to get the
type_id and then match 't' to the result of btf_type_by_id?
btf_type_by_id is not expensive.

> +       }
> +
> +       if (t != nct) {
> +               bpf_log(log, "only read is supported\n");
> +               return -EACCES;
> +       }
> +
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
> +       return NOT_INIT;
> +}
> +
>  __diag_push();
>  __diag_ignore_all("-Wmissing-prototypes",
>                   "Global functions as their definitions will be in nf_conntrack BTF");
> --
> 2.37.1
>
