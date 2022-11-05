Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D176F61A6DD
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKECSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKECSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:18:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1542A6240
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:18:29 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d123so5161851iof.7
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 19:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vlXOj5MocV+7j2J0r0yDju0fVByz61R39gYcEdjRXes=;
        b=fRQvOybtcoLCNdvGGwrRp02DG3Z2JCPWdVflmk7O+/mBIMrrzVIJxKZQBLpRFP8gIh
         Daiw/4TQOCyhncwnwCzLhcX4+M+anYFSESneAZw9QiQ70m0JUxyt+BK94bIFLDzaNnZ+
         f1A21efTVX3yx+j+NnS7C13eNVVLPWnK37YIOXlZaPWFu68DYUcDxsYYwjCmTzOwol8e
         dV8I+iGc/W7YmbAIxgXfSMj+WxHjBL+VOnSu+VHMtlD2qh+9W+v4WI5ztXQL+ga8qQtx
         qGo8lTghWtj99oAAHYx+Os80DnnEEm7R/A75V37TdhjDC9dU/7lfycwYHRkjVy1580cH
         0fNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlXOj5MocV+7j2J0r0yDju0fVByz61R39gYcEdjRXes=;
        b=eMQKJwPlehoZZB1q2wEzgkf+hE/UaxMaYtn6i5MysqBPmeDa+tNqKMYhet87X9t6W0
         FdtQn1cwaLVvgnEler6kN+d6Ouy/KcQYuaOQ5PAN/+RrxWArvLTZ1+krL01GpDR+fql6
         NHgV9LgKoY4nScVf4W62DStWm/Pqmkf1lakfOli7TbGiU4RktSqKbD0tKAmbBBK2mgqV
         S4gLEDj814HUn7PyuMBw6avGUDwJuNQSpRP6e7mrRB3pku/sS6DK82Rb1Wb3KsVgUMpl
         GauffiKJEcUo7mKWujpfLGPvyuuM40QFKcCV8/mxxH3n9gFDvDOp17SQ61TJXOZAMQxZ
         LhvA==
X-Gm-Message-State: ACrzQf0DHoVKOnMtn4VbkgYwRCDZtV3vnpDAiJGl5shPybrCtO1hbv8T
        Rq+53AXrBcjZ6y9+6NoNg3FxDq4/7Lxjvg9FioUq/w==
X-Google-Smtp-Source: AMsMyM48bgP0Dan1h8g0cahxIrEN+T1KZb3R1Q8t5sqp9yOs3kBWpJsbc03Y0mj4LVXf89nrCmRzcS1e3d8h5cEEwbc=
X-Received: by 2002:a02:a910:0:b0:374:9954:6454 with SMTP id
 n16-20020a02a910000000b0037499546454mr23221440jam.277.1667614708349; Fri, 04
 Nov 2022 19:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-9-sdf@google.com>
 <20221105004005.pfdsaitg6phb6vxm@macbook-pro-5.dhcp.thefacebook.com>
In-Reply-To: <20221105004005.pfdsaitg6phb6vxm@macbook-pro-5.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 4 Nov 2022 19:18:17 -0700
Message-ID: <CAKH8qBuf+fXAW3GXzW_CO+us382vYK1PZUihH+A+ZArFzi-gtQ@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 08/14] bpf: Helper to simplify calling kernel
 routines from unrolled kfuncs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
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

On Fri, Nov 4, 2022 at 5:40 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 03, 2022 at 08:25:26PM -0700, Stanislav Fomichev wrote:
> > When we need to call the kernel function from the unrolled
> > kfunc, we have to take extra care: r6-r9 belong to the callee,
> > not us, so we can't use these registers to stash our r1.
> >
> > We use the same trick we use elsewhere: ask the user
> > to provide extra on-stack storage.
> >
> > Also, note, the program being called has to receive and
> > return the context.
> >
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
> >  include/net/xdp.h |  4 ++++
> >  net/core/xdp.c    | 24 +++++++++++++++++++++++-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 8c97c6996172..09c05d1da69c 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -440,10 +440,14 @@ static inline u32 xdp_metadata_kfunc_id(int id)
> >       return xdp_metadata_kfunc_ids.pairs[id].id;
> >  }
> >  void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
> > +void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> > +                               void *kfunc);
> >  #else
> >  #define xdp_metadata_magic 0
> >  static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> >  static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
> > +static void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> > +                                      void *kfunc) {}
> >  #endif
> >
> >  #endif /* __LINUX_NET_XDP_H__ */
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 8204fa05c5e9..16dd7850b9b0 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -737,6 +737,7 @@ BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
> >  XDP_METADATA_KFUNC_xxx
> >  #undef XDP_METADATA_KFUNC
> >  BTF_SET8_END(xdp_metadata_kfunc_ids)
> > +EXPORT_SYMBOL(xdp_metadata_kfunc_ids);
> >
> >  /* Make sure userspace doesn't depend on our layout by using
> >   * different pseudo-generated magic value.
> > @@ -756,7 +757,8 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
> >   *
> >   * The above also means we _cannot_ easily call any other helper/kfunc
> >   * because there is no place for us to preserve our R1 argument;
> > - * existing R6-R9 belong to the callee.
> > + * existing R6-R9 belong to the callee. For the cases where calling into
> > + * the kernel is the only option, see xdp_kfunc_call_preserving_r1.
> >   */
> >  void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
> >  {
> > @@ -832,6 +834,26 @@ void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *p
> >
> >       bpf_patch_resolve_jmp(patch);
> >  }
> > +EXPORT_SYMBOL(xdp_metadata_export_to_skb);
> > +
> > +/* Helper to generate the bytecode that calls the supplied kfunc.
> > + * The kfunc has to accept a pointer to the context and return the
> > + * same pointer back. The user also has to supply an offset within
> > + * the context to store r0.
> > + */
> > +void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> > +                               void *kfunc)
> > +{
> > +     bpf_patch_append(patch,
> > +             /* r0 = kfunc(r1); */
> > +             BPF_EMIT_CALL(kfunc),
> > +             /* r1 = r0; */
> > +             BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> > +             /* r0 = *(r1 + r0_offset); */
> > +             BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, r0_offset),
> > +     );
> > +}
> > +EXPORT_SYMBOL(xdp_kfunc_call_preserving_r1);
>
> That's one twisted logic :)
> I guess it works for preserving r1, but r2-r5 are gone and r6-r9 cannot be touched.
> So it works for the most basic case of returning single value from that additional
> kfunc while preserving single r1.
> I'm afraid that will be very limiting moving forward.
> imo we need push/pop insns. It shouldn't difficult to add to the interpreter and JITs.
> Since this patching is done after verificaiton they will be kernel internal insns.
> Like we have BPF_REG_AX internal reg.

Heh, having push/pop would help a lot, agree :-)
Good suggestion, will look into that, thank you!
