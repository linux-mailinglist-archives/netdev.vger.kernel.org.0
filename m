Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77497621EBB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 22:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKHVy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 16:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKHVy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 16:54:58 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46F63164
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 13:54:53 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h206so12556027iof.10
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 13:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wJw7dUyTQ/kSM/LgDsfH6662JpZHpPR4MTrASZnPAAY=;
        b=rsRuvSwiM1PvHvUlS3h5AXXAOSatkIGwx3us0QmTTtQ3N/EH7E13CSkXNmYBDLAFfj
         ZaBmBKrA5SUN5nK7VjI0JYn9V8ndX3Lvwaus5dCZZWA0XJNgdvnjB8PfSjQ+kV8GFCvJ
         QLX+0x14k8IhuUScnrmsbEZK3VqXNTtHEHCvgzowA2sKn8YRR8OIsaXAy2VK/ny+XRD7
         7cWu6tHy+qGNuU/DWTkM7CVBfAbQCZLdJx4YTikj37Mg2o64sbSSWHT/DLkXWsQXp4Zc
         zQrQQAciCZrzcisqNob4AKp6jzyRo17sPHp/fb4wdrhgGdmiyOfDkLXCE51REjGZqgLt
         B+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJw7dUyTQ/kSM/LgDsfH6662JpZHpPR4MTrASZnPAAY=;
        b=MDHP7jhVK7u1mowltROZpNTRwJ+UmW3d4zqwkg2E5jmg/8R9Fmuz3W+IyOxXVQi0LG
         U8kwFMMlJmq1iD3P4IXzyVbL6wUQWIIDP8J3rBIDmVzQ5v7939bIjQp1pZQpY5B6v8jd
         2Gk/0PJxsFnUGYxfK2/PWuutoONVLDfG1xPBuBGuYgb9SOk5AHKAtGoCQJ1QsttdTYOg
         2msg2QkwM7/H3x17KfBzpLgQlYtaEJLFgSPUu1BORH6VSdrd3l2+9TQtz5BKMEu7/Pt0
         1pRooB8h0leC0XATSYBX5djQLz30Q9l0+zabQh6SeDDzlndOzw5qhdMGUdPJBQECXJwD
         cL8Q==
X-Gm-Message-State: ACrzQf3bbC4G9jCMv/BcubZYHbAcw46WNcbdn3EvLxoXmK4NOEyfYpuo
        yxuj7iONh6m27L3VbsvBddIROUTmu4xi1n87VttRAw==
X-Google-Smtp-Source: AMsMyM5inAjGP5aW3gKcGUsL0qc+y7ufgG48iVUvb8COUL0n92UFv/6koC7l7Z+yLxnh06eEteGE/ffB6OTS4SGtGRk=
X-Received: by 2002:a05:6638:3043:b0:341:d8a4:73e8 with SMTP id
 u3-20020a056638304300b00341d8a473e8mr34008716jak.239.1667944492914; Tue, 08
 Nov 2022 13:54:52 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
In-Reply-To: <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 8 Nov 2022 13:54:41 -0800
Message-ID: <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb context
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Mon, Nov 7, 2022 at 2:02 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/3/22 8:25 PM, Stanislav Fomichev wrote:
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 59c9fd55699d..dba857f212d7 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
> >              true : __skb_metadata_differs(skb_a, skb_b, len_a);
> >   }
> >
> > +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
> > +
> >   static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
> >   {
> >       skb_shinfo(skb)->meta_len = meta_len;
> > +     if (meta_len)
> > +             skb_metadata_import_from_xdp(skb, meta_len);
> >   }
> >
> [ ... ]
>
> > +struct xdp_to_skb_metadata {
> > +     u32 magic; /* xdp_metadata_magic */
> > +     u64 rx_timestamp;
> > +} __randomize_layout;
> > +
> > +struct bpf_patch;
> > +
>
> [ ... ]
>
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
>
> Considering the metadata will affect the gro, should the meta be cleared after
> importing to the skb?

Yeah, good suggestion, will clear it here.

> [ ... ]
>
> > +/* Since we're not actually doing a call but instead rewriting
> > + * in place, we can only afford to use R0-R5 scratch registers.
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
> > +     u32 func_id;
> > +
> > +     /*
> > +      * The code below generates the following:
> > +      *
> > +      * void bpf_xdp_metadata_export_to_skb(struct xdp_md *ctx)
> > +      * {
> > +      *      struct xdp_to_skb_metadata *meta;
> > +      *      int ret;
> > +      *
> > +      *      ret = bpf_xdp_adjust_meta(ctx, -sizeof(*meta));
> > +      *      if (!ret)
> > +      *              return;
> > +      *
> > +      *      meta = ctx->data_meta;
> > +      *      meta->magic = xdp_metadata_magic;
> > +      *      meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> > +      * }
> > +      *
> > +      */
> > +
> > +     bpf_patch_append(patch,
> > +             /* r2 = ((struct xdp_buff *)r1)->data_meta; */
> > +             BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
> > +                         offsetof(struct xdp_buff, data_meta)),
> > +             /* r3 = ((struct xdp_buff *)r1)->data; */
> > +             BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
> > +                         offsetof(struct xdp_buff, data)),
> > +             /* if (data_meta != data) return;
> > +              *
> > +              *      data_meta > data: xdp_data_meta_unsupported()
> > +              *      data_meta < data: already used, no need to touch
> > +              */
> > +             BPF_JMP_REG(BPF_JNE, BPF_REG_2, BPF_REG_3, S16_MAX),
> > +
> > +             /* r2 -= sizeof(struct xdp_to_skb_metadata); */
> > +             BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
> > +                           sizeof(struct xdp_to_skb_metadata)),
> > +             /* r3 = ((struct xdp_buff *)r1)->data_hard_start; */
> > +             BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
> > +                         offsetof(struct xdp_buff, data_hard_start)),
> > +             /* r3 += sizeof(struct xdp_frame) */
> > +             BPF_ALU64_IMM(BPF_ADD, BPF_REG_3,
> > +                           sizeof(struct xdp_frame)),
> > +             /* if (data-sizeof(struct xdp_to_skb_metadata) < data_hard_start+sizeof(struct xdp_frame)) return; */
> > +             BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, S16_MAX),
> > +
> > +             /* ((struct xdp_buff *)r1)->data_meta = r2; */
> > +             BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2,
> > +                         offsetof(struct xdp_buff, data_meta)),
> > +
> > +             /* *((struct xdp_to_skb_metadata *)r2)->magic = xdp_metadata_magic; */
> > +             BPF_ST_MEM(BPF_W, BPF_REG_2,
> > +                        offsetof(struct xdp_to_skb_metadata, magic),
> > +                        xdp_metadata_magic),
> > +     );
> > +
> > +     /*      r0 = bpf_xdp_metadata_rx_timestamp(ctx); */
> > +     func_id = xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP);
> > +     prog->aux->xdp_kfunc_ndo->ndo_unroll_kfunc(prog, func_id, patch);
> > +
> > +     bpf_patch_append(patch,
> > +             /* r2 = ((struct xdp_buff *)r1)->data_meta; */
> > +             BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
> > +                         offsetof(struct xdp_buff, data_meta)),
> > +             /* *((struct xdp_to_skb_metadata *)r2)->rx_timestamp = r0; */
> > +             BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0,
> > +                         offsetof(struct xdp_to_skb_metadata, rx_timestamp)),
>
> Can the xdp prog still change the metadata through xdp->data_meta? tbh, I am not
> sure it is solid enough by asking the xdp prog not to use the same random number
> in its own metadata + not to change the metadata through xdp->data_meta after
> calling bpf_xdp_metadata_export_to_skb().

What do you think the usecase here might be? Or are you suggesting we
reject further access to data_meta after
bpf_xdp_metadata_export_to_skb somehow?

If we want to let the programs override some of this
bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
more kfuncs instead of exposing the layout?

bpf_xdp_metadata_export_to_skb(ctx);
bpf_xdp_metadata_export_skb_hash(ctx, 1234);
...

> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7) or the
> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?

XDP_PASS cases where we convert xdp_buff into skb in the drivers right
now usually have C code to manually pull out the metadata (out of hw
desc) and put it into skb.

So, currently, if we're calling bpf_xdp_metadata_export_to_skb() for
XDP_PASS, we're doing a double amount of work:
skb_metadata_import_from_xdp first, then custom driver code second.

In theory, maybe we should completely skip drivers custom parsing when
there is a prog with BPF_F_XDP_HAS_METADATA?
Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driven
and won't require any mental work (plus, the drivers won't have to
care either in the future).

WDYT?

> > +     );
> > +
> > +     bpf_patch_resolve_jmp(patch);
> > +}
> > +
> >   static int __init xdp_metadata_init(void)
> >   {
> > +     xdp_metadata_magic = get_random_u32() | 1;
> >       return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
> >   }
> >   late_initcall(xdp_metadata_init);
