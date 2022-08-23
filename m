Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2759CE66
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 04:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbiHWCTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 22:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWCTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 22:19:33 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CB757235;
        Mon, 22 Aug 2022 19:19:31 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 9A5E33200A27;
        Mon, 22 Aug 2022 22:19:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Aug 2022 22:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1661221168; x=1661307568; bh=TLwpmg8vHO
        B4GXzZydz9UyD4FFMxizILcM5xJmtqCLo=; b=RGhXHmVIwEwXgAOQlm0+TOtraL
        SgSIrGOcy27P9hIo47PPNmnjp0QB1hOB3TY9IXJB+NDAiTwi0FRAiXsY1XqlLvUU
        WW/3OSbo1+xvpP6QdtQLJeY88fnEcbSUWENahCwbHlXOnbq1CcmQ1nwKoBHZ7+6F
        iaTGcArdWbaFAftWeugFbIWdb/48hpCc+iCRK3yUIr1btEFz1zGZda8hJo2/s93N
        Vo5qy30Okzn0Bz8rLkKWd47JG12mzNkR3xyyGGi0Ra/BwldiDyj+I+HGHIHZ1z8Y
        ZIoSMpdgjPdOhkI/+2ucjtwOR8FeQqon4f6gJQER6PoYq7w/dr+8QOzb3fjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661221168; x=1661307568; bh=TLwpmg8vHOB4GXzZydz9UyD4FFMx
        izILcM5xJmtqCLo=; b=PDRCDqbP0cfj6D9e/XgnRaHoVf+KaqvF/bgiY330x+sl
        Hginuge/ZtLKGPkYO1xsyoTOKgINxW2I20X0kle5y/MF6fGsIakTDtz26R3H85kc
        bhqJpMo2PSStBDvUugAy8DlkqWqng1loesvEDdEPsy/Eacaa1r0m8WXTBNds5KoS
        AejhbzAs7Ti7pZncOzxssEoYDc5oSB5oBx13NmwinVbr7u9+wmIO5bRPUIDmRFjp
        yJaubk+YsFnLspH4PcWrQdhtHH59alsql8xdMUlW1r7At5EzyEmagH31/XfRXRzB
        7NXoUXeD4Xkdc4t/yXV5w10H57FVLLOFgs2swjN/Aw==
X-ME-Sender: <xms:LzkEYyCjaZlrr3rb1gXCwNEjQDIUgm0vOYrAGEkpumFt4KLPP8SejA>
    <xme:LzkEY8hQ_6Owodujg1qsD6MUOeBOOgqARq-B5RRpqqXrMAH1xLaoG01Sff4YKMp7q
    U_Ibg9AIMnfkLdN9A>
X-ME-Received: <xmr:LzkEY1ltCRb2uwEqfa5b5kqIs8_h7FGplE5ycoLr_sXAfKxffHafPSZTNjKqgAfzil4WXzR2e4Gwt61NRMebrqu4m9OZqSBUNX-q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeikedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepveduudegiefhtdffhe
    fggfdugeeggeehtefgvefhkeekieelueeijeelkeeivdfgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:LzkEYwzxMBvZyDw2OzdGwCzsPTrtrgm5I3rwYoZ1wzkFBMD5-H-zGg>
    <xmx:LzkEY3Quu2cn8eCcgjxs3-ioH5YHYkVgsmZkGCJEw0aH6HHmmiM7xg>
    <xmx:LzkEY7abRUIvQOQ5HZCU0dUZNRzHpjzcywRfKl09FK3b3PcPjKeYeg>
    <xmx:MDkEY8JF2ul_8MRFOxk8EVhKLV7LUO7qU1yAtyaFA7jCO7g8hs0njg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 22:19:26 -0400 (EDT)
Date:   Mon, 22 Aug 2022 20:19:23 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220823021923.vmhp5r76dvgwvh2j@kashmir.localdomain>
References: <cover.1661192455.git.dxu@dxuuu.xyz>
 <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
 <CAP01T74XK_6wMi+tzReTkBqmZkKbUqCmV6pVwcbCMrHrv0X0SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T74XK_6wMi+tzReTkBqmZkKbUqCmV6pVwcbCMrHrv0X0SA@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 02:16:42AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Mon, 22 Aug 2022 at 20:26, Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
> > is useful when applications want to store per-connection metadata. This
> > is also particularly useful for applications that run both bpf and
> > iptables/nftables because the latter can trivially access this metadata.
> >
> > One example use case would be if a bpf prog is responsible for advanced
> > packet classification and iptables/nftables is later used for routing
> > due to pre-existing/legacy code.
> >
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > ---
> >  include/net/netfilter/nf_conntrack_bpf.h | 22 ++++++
> >  net/core/filter.c                        | 34 +++++++++
> >  net/netfilter/nf_conntrack_bpf.c         | 91 +++++++++++++++++++++++-
> >  net/netfilter/nf_conntrack_core.c        |  1 +
> >  4 files changed, 147 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> > index a473b56842c5..6fc03066846b 100644
> > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _NF_CONNTRACK_BPF_H
> >  #define _NF_CONNTRACK_BPF_H
> >
> > +#include <linux/bpf.h>
> >  #include <linux/btf.h>
> >  #include <linux/kconfig.h>
> >
> > @@ -10,6 +11,13 @@
> >      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> >
> >  extern int register_nf_conntrack_bpf(void);
> > +extern void cleanup_nf_conntrack_bpf(void);
> > +extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                         const struct btf *btf,
> > +                                         const struct btf_type *t, int off,
> > +                                         int size, enum bpf_access_type atype,
> > +                                         u32 *next_btf_id,
> > +                                         enum bpf_type_flag *flag);
> >
> >  #else
> >
> > @@ -18,6 +26,20 @@ static inline int register_nf_conntrack_bpf(void)
> >         return 0;
> >  }
> >
> > +static inline void cleanup_nf_conntrack_bpf(void)
> > +{
> > +}
> > +
> > +static inline int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                                const struct btf *btf,
> > +                                                const struct btf_type *t, int off,
> > +                                                int size, enum bpf_access_type atype,
> > +                                                u32 *next_btf_id,
> > +                                                enum bpf_type_flag *flag)
> > +{
> > +       return -EACCES;
> > +}
> > +
> >  #endif
> >
> >  #endif /* _NF_CONNTRACK_BPF_H */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 1acfaffeaf32..25bdbf6dc76b 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -18,6 +18,7 @@
> >   */
> >
> >  #include <linux/atomic.h>
> > +#include <linux/bpf_verifier.h>
> >  #include <linux/module.h>
> >  #include <linux/types.h>
> >  #include <linux/mm.h>
> > @@ -55,6 +56,7 @@
> >  #include <net/sock_reuseport.h>
> >  #include <net/busy_poll.h>
> >  #include <net/tcp.h>
> > +#include <net/netfilter/nf_conntrack_bpf.h>
> >  #include <net/xfrm.h>
> >  #include <net/udp.h>
> >  #include <linux/bpf_trace.h>
> > @@ -8628,6 +8630,21 @@ static bool tc_cls_act_is_valid_access(int off, int size,
> >         return bpf_skb_is_valid_access(off, size, type, prog, info);
> >  }
> >
> > +static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
> > +                                       const struct btf *btf,
> > +                                       const struct btf_type *t, int off,
> > +                                       int size, enum bpf_access_type atype,
> > +                                       u32 *next_btf_id,
> > +                                       enum bpf_type_flag *flag)
> > +{
> > +       if (atype == BPF_READ)
> > +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> > +                                        flag);
> > +
> > +       return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
> > +                                             next_btf_id, flag);
> > +}
> > +
> >  static bool __is_valid_xdp_access(int off, int size)
> >  {
> >         if (off < 0 || off >= sizeof(struct xdp_md))
> > @@ -8687,6 +8704,21 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
> >  }
> >  EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
> >
> > +static int xdp_btf_struct_access(struct bpf_verifier_log *log,
> > +                                const struct btf *btf,
> > +                                const struct btf_type *t, int off,
> > +                                int size, enum bpf_access_type atype,
> > +                                u32 *next_btf_id,
> > +                                enum bpf_type_flag *flag)
> > +{
> > +       if (atype == BPF_READ)
> > +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> > +                                        flag);
> > +
> > +       return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
> > +                                             next_btf_id, flag);
> > +}
> > +
> >  static bool sock_addr_is_valid_access(int off, int size,
> >                                       enum bpf_access_type type,
> >                                       const struct bpf_prog *prog,
> > @@ -10581,6 +10613,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
> >         .convert_ctx_access     = tc_cls_act_convert_ctx_access,
> >         .gen_prologue           = tc_cls_act_prologue,
> >         .gen_ld_abs             = bpf_gen_ld_abs,
> > +       .btf_struct_access      = tc_cls_act_btf_struct_access,
> >  };
> >
> >  const struct bpf_prog_ops tc_cls_act_prog_ops = {
> > @@ -10592,6 +10625,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
> >         .is_valid_access        = xdp_is_valid_access,
> >         .convert_ctx_access     = xdp_convert_ctx_access,
> >         .gen_prologue           = bpf_noop_prologue,
> > +       .btf_struct_access      = xdp_btf_struct_access,
> >  };
> >
> >  const struct bpf_prog_ops xdp_prog_ops = {
> > diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> > index 1cd87b28c9b0..da54355927d4 100644
> > --- a/net/netfilter/nf_conntrack_bpf.c
> > +++ b/net/netfilter/nf_conntrack_bpf.c
> > @@ -6,8 +6,10 @@
> >   * are exposed through to BPF programs is explicitly unstable.
> >   */
> >
> > +#include <linux/bpf_verifier.h>
> >  #include <linux/bpf.h>
> >  #include <linux/btf.h>
> > +#include <linux/mutex.h>
> >  #include <linux/types.h>
> >  #include <linux/btf_ids.h>
> >  #include <linux/net_namespace.h>
> > @@ -184,6 +186,79 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
> >         return ct;
> >  }
> >
> > +BTF_ID_LIST(btf_nf_conn_ids)
> > +BTF_ID(struct, nf_conn)
> > +BTF_ID(struct, nf_conn___init)
> > +
> > +static DEFINE_MUTEX(btf_access_lock);
> > +static int (*nfct_bsa)(struct bpf_verifier_log *log,
> > +                      const struct btf *btf,
> > +                      const struct btf_type *t, int off,
> > +                      int size, enum bpf_access_type atype,
> > +                      u32 *next_btf_id,
> > +                      enum bpf_type_flag *flag);
> > +
> > +/* Check writes into `struct nf_conn` */
> > +static int _nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                          const struct btf *btf,
> > +                                          const struct btf_type *t, int off,
> > +                                          int size, enum bpf_access_type atype,
> > +                                          u32 *next_btf_id,
> > +                                          enum bpf_type_flag *flag)
> > +{
> > +       const struct btf_type *ncit;
> > +       const struct btf_type *nct;
> > +       size_t end;
> > +
> > +       ncit = btf_type_by_id(btf, btf_nf_conn_ids[1]);
> > +       nct = btf_type_by_id(btf, btf_nf_conn_ids[0]);
> > +
> > +       if (t != nct && t != ncit) {
> > +               bpf_log(log, "only read is supported\n");
> > +               return -EACCES;
> > +       }
> > +
> > +       /* `struct nf_conn` and `struct nf_conn___init` have the same layout
> > +        * so we are safe to simply merge offset checks here
> > +        */
> > +       switch (off) {
> > +#if defined(CONFIG_NF_CONNTRACK_MARK)
> > +       case offsetof(struct nf_conn, mark):
> > +               end = offsetofend(struct nf_conn, mark);
> > +               break;
> > +#endif
> > +       default:
> > +               bpf_log(log, "no write support to nf_conn at off %d\n", off);
> > +               return -EACCES;
> > +       }
> > +
> > +       if (off + size > end) {
> > +               bpf_log(log,
> > +                       "write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
> > +                       off, size, end);
> > +               return -EACCES;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                  const struct btf *btf,
> > +                                  const struct btf_type *t, int off,
> > +                                  int size, enum bpf_access_type atype,
> > +                                  u32 *next_btf_id,
> > +                                  enum bpf_type_flag *flag)
> > +{
> > +       int ret = -EACCES;
> > +
> > +       mutex_lock(&btf_access_lock);
> > +       if (nfct_bsa)
> > +               ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
> > +       mutex_unlock(&btf_access_lock);
> > +
> > +       return ret;
> > +}
> 
> Did you test this for CONFIG_NF_CONNTRACK=m? For me it isn't building :P.
> 
> It won't work like this. When nf_conntrack is a module, the vmlinux.o
> of the kernel isn't linked to the object file nf_conntrack_bpf.o.
> Hence it would be an undefined reference error. You don't see it in
> BPF CI as we set CONFIG_NF_CONNTRACK=y (to simplify testing).

Sorry about that. Will make sure to test that config setting.

> So you need to have code that locks and checks the cb pointer when
> calling it outside the module, which means the global lock variable
> and global cb pointer also need to be in the kernel. The module then
> takes the same lock and sets cb pointer when loading. During unload,
> it takes the same lock and sets it back to NULL.
> 
> You can have global variables in vmlinux that you reference from
> modules. The compiler will emit a relocation for the module object
> file which will be handled by the kernel during module load.

Sure, I'll take a look. I was trying to keep conntrack symbols out of
the core object files as much as possible but looks like that won't be
possible.

However, I think to keep the globals symbols in vmlinux we'll need to
EXPORT_SYMBOL_GPL() some symbols. Hopefully that is OK.

There's also some other issues I'm uncovering with duplicate BTF IDs for
nf_conn. Might have to do a lookup by name instead of the BTF_ID_LIST().

> So please test it once with nf_conntrack built as a module before
> sending the next revision. The only thing you need to do before
> running ./test_progs -t bpf_nf is loading the module nf_conntrack.ko
> (and its dependencies, nf_defrag_ipv{4,6}.ko).

Will do.

Thanks again for the reviews,
Daniel
