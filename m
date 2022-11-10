Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6311623C0D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiKJGoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiKJGoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:44:23 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B032A71D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 22:44:21 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 63so576368iov.8
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 22:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5bf6bt7To7+uIiImDY/kcrFWVGhqWA2erlbEn2Utd/Q=;
        b=ehPDfCoeu+kUiMuXvybvk3DCKo/FK+xAblxspgWwNaHhcD0UShDzamNvpsBOSEZHQs
         Qkz3T3vES4VIQ/nVDLkNhcUYYFn8S/i3pvxbpqZPSxayCGmoRZSsvsamySBUxQ9L6bdM
         rDPgRpH5WgMf9f9ELkr/0OqndbMtc5xR+M/eSZL2z+0Ena7goiUBBcCnsxJEvdT+W0CR
         qglFaRIA5bfF/J91tvrDCOreZTaKoF2BvKx+ZbhzY2SN/ZJFaFviCxo+4A343QB9tK4l
         kddZHKnuqRC+V9zJLwkSrLdI9I3OxJmCCAToRMPnRr00Tb7G17O+ZSCPmBv4dVT9LzCD
         W2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5bf6bt7To7+uIiImDY/kcrFWVGhqWA2erlbEn2Utd/Q=;
        b=bzFOSlx6dDvv4ydTvygelvBhgInQ2Y2xrLw6ivbhIwQ8D7Y51mL6nsHPAookpm7vga
         CsDKxpMffQA6MYjJL8fbffa0uLPcNLS9cHA0v586e/vatfYyzzm2aXaP75pZfwT9PMop
         2YiqvjjyR12mMO+yv1pywJqs6/SN0/eo9SZiWprj1X+KiYD+SvGMTsuyXrNtj0EOiOLk
         j0g4wnbnb7chl1FANr5mQogAyEXUTbE6Me7DHh/zdffv7ODSQpuSxDjzfEIdIFyjioNV
         hUk0sKwgU7OE+0xUyEo0dB5qdIJYvv2g8bL6kPPjhdDdWq+3qwcfyCFOczKs169e+TFw
         HKGg==
X-Gm-Message-State: ANoB5pmHn1zFO9+Mu9DJaAjjMeTj4YPY87fpAFh/pqMIRFNuy7uWGfyo
        frZMixM3jqdl88+fMF8bD+Cw1ldo7/YkjnXZvWTVOA==
X-Google-Smtp-Source: AA0mqf7N7c80Csp9qwafAp6SGXwL+tDbHL6Vy8RFPZ9xEC+7D/Bp3Yx5IOXcfkcp0HNyMNgE2TlhE+tJGQti7T82Yyg=
X-Received: by 2002:a6b:6908:0:b0:6dd:2d6e:18f1 with SMTP id
 e8-20020a6b6908000000b006dd2d6e18f1mr4731555ioc.92.1668062660966; Wed, 09 Nov
 2022 22:44:20 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <636c4f5a3812f_13c9f4208b1@john.notmuch>
In-Reply-To: <636c4f5a3812f_13c9f4208b1@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Nov 2022 22:44:09 -0800
Message-ID: <CAKH8qBuv29gSDme+XUaFOMvPWcsrar+U0GjhT9y7ZcKaPrsydA@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb context
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 5:09 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > Implement new bpf_xdp_metadata_export_to_skb kfunc which
> > prepares compatible xdp metadata for kernel consumption.
> > This kfunc should be called prior to bpf_redirect
> > or (unless already called) when XDP_PASS'ing the frame
> > into the kernel.
>
> Hi,
>
> Had a couple high level questions so starting a new thread thought
> it would be more confusing than helpful to add to the thread on
> this patch.
>
> >
> > The implementation currently maintains xdp_to_skb_metadata
> > layout by calling bpf_xdp_metadata_rx_timestamp and placing
> > small magic number. From skb_metdata_set, when we get expected magic number,
> > we interpret metadata accordingly.
>
> From commit message side I'm not able to parse this paragraph without
> reading code. Maybe expand it a bit for next version or it could
> just be me.

Sure, will try to reword. In another thread we've discussed removing
the magic number, so I'll have to rewrite this part anyway :-)

> >
> > Both magic number and struct layout are randomized to make sure
> > it doesn't leak into the userspace.
>
> Are we worried about leaking pointers into XDP program here? We already
> leak pointers into XDP through helpers so I'm not sure it matters.

I wasn't sure here whether we want to have that xdp->skb (redirect)
path to be completely opaque or it's ok to expose this to the
bpf/af_xdp.
Seems like everybody's on board about exposing, so I'll be most likely
removing that randomization part.
(see my recent reply to Martin/Toke)

> >
> > skb_metadata_set is amended with skb_metadata_import_from_xdp which
> > tries to parse out the metadata and put it into skb.
> >
> > See the comment for r1 vs r2/r3/r4/r5 conventions.
>
> I think for next version an expanded commit message with use
> cases would help. I had to follow the thread to get some ideas
> why this might be useful.

Sure. I was planning to put together
Documentation/bpf/xdp_metadata.rst with more
details/assumptions/use-cases for the final non-rfc submissions..
Maybe that's better to help build up a full picture?

> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  drivers/net/veth.c        |   4 +-
> >  include/linux/bpf_patch.h |   2 +
> >  include/linux/skbuff.h    |   4 ++
> >  include/net/xdp.h         |  13 +++++
> >  kernel/bpf/bpf_patch.c    |  30 +++++++++++
> >  kernel/bpf/verifier.c     |  18 +++++++
> >  net/core/skbuff.c         |  25 +++++++++
> >  net/core/xdp.c            | 104 +++++++++++++++++++++++++++++++++++---
> >  8 files changed, 193 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 0e629ceb087b..d4cd0938360b 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -1673,7 +1673,9 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> >  static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> >                             struct bpf_patch *patch)
> >  {
> > -     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
> > +             return xdp_metadata_export_to_skb(prog, patch);
> > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> >               /* return true; */
> >               bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> >       } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > diff --git a/include/linux/bpf_patch.h b/include/linux/bpf_patch.h
> > index 81ff738eef8d..359c165ad68b 100644
> > --- a/include/linux/bpf_patch.h
> > +++ b/include/linux/bpf_patch.h
> > @@ -16,6 +16,8 @@ size_t bpf_patch_len(const struct bpf_patch *patch);
> >  int bpf_patch_err(const struct bpf_patch *patch);
> >  void __bpf_patch_append(struct bpf_patch *patch, struct bpf_insn insn);
> >  struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch);
> > +void bpf_patch_resolve_jmp(struct bpf_patch *patch);
> > +u32 bpf_patch_magles_registers(const struct bpf_patch *patch);
> >
> >  #define bpf_patch_append(patch, ...) ({ \
> >       struct bpf_insn insn[] = { __VA_ARGS__ }; \
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 59c9fd55699d..dba857f212d7 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
> >              true : __skb_metadata_differs(skb_a, skb_b, len_a);
> >  }
> >
> > +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
> > +
> >  static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
> >  {
> >       skb_shinfo(skb)->meta_len = meta_len;
> > +     if (meta_len)
> > +             skb_metadata_import_from_xdp(skb, meta_len);
> >  }
> >
> >  static inline void skb_metadata_clear(struct sk_buff *skb)
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 2a82a98f2f9f..8c97c6996172 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -411,6 +411,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
> >  #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
> >
> >  #define XDP_METADATA_KFUNC_xxx       \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_EXPORT_TO_SKB, \
> > +                        bpf_xdp_metadata_export_to_skb) \
> >       XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> >                          bpf_xdp_metadata_rx_timestamp_supported) \
> >       XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> > @@ -423,14 +425,25 @@ XDP_METADATA_KFUNC_xxx
> >  MAX_XDP_METADATA_KFUNC,
> >  };
> >
> > +struct xdp_to_skb_metadata {
> > +     u32 magic; /* xdp_metadata_magic */
> > +     u64 rx_timestamp;
>
> Slightly confused. I thought/think most drivers populate the skb timestamp
> if they can already? So why do we need to bounce these through some xdp
> metadata? Won't all this cost more than the load/store directly from the
> descriptor into the skb? Even if drivers are not populating skb now
> shouldn't an ethtool knob be enough to turn this on?

dsahern@ pointed out that it might be useful for the program to be
able to override some of that metadata.
Or, for example, if there is no rx vlan offload, the program can strip
it (as part of parsing) and put the vlan tag into that
xdp_to_skb_metadata.

> I don't see the value of getting this in veth side its just a sw
> timestamp there.

(veth is there so we can have some selftests)

> If its specific to cpumap shouldn't we land this in cpumap code paths
> out of general XDP code paths?

See above, if we run this at cpumap time it's too late?

> > +} __randomize_layout;
> > +
> > +struct bpf_patch;
> > +
> >  #ifdef CONFIG_DEBUG_INFO_BTF
> > +extern u32 xdp_metadata_magic;
> >  extern struct btf_id_set8 xdp_metadata_kfunc_ids;
> >  static inline u32 xdp_metadata_kfunc_id(int id)
> >  {
> >       return xdp_metadata_kfunc_ids.pairs[id].id;
> >  }
> > +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
> >  #else
> > +#define xdp_metadata_magic 0
> >  static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> > +static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
> >  #endif
> >
> >  #endif /* __LINUX_NET_XDP_H__ */
> > diff --git a/kernel/bpf/bpf_patch.c b/kernel/bpf/bpf_patch.c
> > index 82a10bf5624a..8f1fef74299c 100644
> > --- a/kernel/bpf/bpf_patch.c
> > +++ b/kernel/bpf/bpf_patch.c
> > @@ -49,3 +49,33 @@ struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch)
> >  {
> >       return patch->insn;
> >  }
>
> [...]
>
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 42a35b59fb1e..37e3aef46525 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -72,6 +72,7 @@
> >  #include <net/mptcp.h>
> >  #include <net/mctp.h>
> >  #include <net/page_pool.h>
> > +#include <net/xdp.h>
> >
> >  #include <linux/uaccess.h>
> >  #include <trace/events/skb.h>
> > @@ -6672,3 +6673,27 @@ nodefer:       __kfree_skb(skb);
> >       if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
> >               smp_call_function_single_async(cpu, &sd->defer_csd);
> >  }
> > +
> > +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len)
> > +{
> > +     struct xdp_to_skb_metadata *meta = (void *)(skb_mac_header(skb) - len);
> > +
> > +     /* Optional SKB info, currently missing:
> > +      * - HW checksum info           (skb->ip_summed)
> > +      * - HW RX hash                 (skb_set_hash)
> > +      * - RX ring dev queue index    (skb_record_rx_queue)
> > +      */
> > +
> > +     if (len != sizeof(struct xdp_to_skb_metadata))
> > +             return;
> > +
> > +     if (meta->magic != xdp_metadata_magic)
> > +             return;
> > +
> > +     if (meta->rx_timestamp) {
> > +             *skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
> > +                     .hwtstamp = ns_to_ktime(meta->rx_timestamp),
> > +             };
> > +     }
> > +}
> > +EXPORT_SYMBOL(skb_metadata_import_from_xdp);
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 22f1e44700eb..8204fa05c5e9 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -653,12 +653,6 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
> >       /* Essential SKB info: protocol and skb->dev */
> >       skb->protocol = eth_type_trans(skb, dev);
> >
> > -     /* Optional SKB info, currently missing:
> > -      * - HW checksum info           (skb->ip_summed)
> > -      * - HW RX hash                 (skb_set_hash)
> > -      * - RX ring dev queue index    (skb_record_rx_queue)
> > -      */
> > -
> >       /* Until page_pool get SKB return path, release DMA here */
> >       xdp_release_frame(xdpf);
> >
> > @@ -712,6 +706,13 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> >       return nxdpf;
> >  }
> >
> > +/* For the packets directed to the kernel, this kfunc exports XDP metadata
> > + * into skb context.
> > + */
> > +noinline void bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
> > +{
> > +}
> > +
> >  /* Indicates whether particular device supports rx_timestamp metadata.
> >   * This is an optional helper to support marking some branches as
> >   * "dead code" in the BPF programs.
> > @@ -737,13 +738,104 @@ XDP_METADATA_KFUNC_xxx
> >  #undef XDP_METADATA_KFUNC
> >  BTF_SET8_END(xdp_metadata_kfunc_ids)
> >
> > +/* Make sure userspace doesn't depend on our layout by using
> > + * different pseudo-generated magic value.
> > + */
> > +u32 xdp_metadata_magic;
> > +
> >  static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
> >       .owner = THIS_MODULE,
> >       .set   = &xdp_metadata_kfunc_ids,
> >  };
> >
> > +/* Since we're not actually doing a call but instead rewriting
> > + * in place, we can only afford to use R0-R5 scratch registers.
>
> Why not just do a call? Its neat to inline this but your going
> to build an skb next. Thats not cheap and the cost of a call
> should be complete noise when hitting the entire stack?
>
> Any benchmark to convince us this is worthwhile optimizations?

I do have a suspicion that a non-zero amount of drivers will actually
resort to calling kernel instead of writing bpf bytecode (especially
since there might be some locks involved).

However if we prefer to go back to calls, there still has to be some
translation table.
I'm assuming we want to at least resolve indirect
netdev->kfunc_rx_metatada() calls at prog load time.
So we still need a per-netdev map from kfunc_id to real implementation func.
And I don't think that it would be more simple than the switch
statement that I have?



> > + *
> > + * We reserve R1 for bpf_xdp_metadata_export_to_skb and let individual
> > + * metadata kfuncs use only R0,R4-R5.
> > + *
> > + * The above also means we _cannot_ easily call any other helper/kfunc
> > + * because there is no place for us to preserve our R1 argument;
> > + * existing R6-R9 belong to the callee.
> > + */
> > +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
> > +{
>
> [...]
>
> >  }
> >  late_initcall(xdp_metadata_init);
>
> Thanks,
> John
>
>
