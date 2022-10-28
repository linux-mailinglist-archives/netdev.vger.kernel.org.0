Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7A1611A6A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiJ1Sql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJ1Sqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:46:39 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76285244C5E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:46:29 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b79so5339034iof.5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aVQrfsCj0EaYjV3S0UqwAeu50/dS1NKsyMUdIHSnM/s=;
        b=qEkgAsj/QcSREQburHKS+spqzZnET8VrT9NbFaeeVTjD7goyPi+5HPAUk6H+/CkbGO
         ODhY1VjG1mtzqc4Ya5zJ8yMY0Fs4jyfgt6HcBDuWo3NWkzRi0ViGUAxnCobsk2IdUNTq
         kfd+Vm2ZlhwG8c9Jqfm96PlRerg7cBcqHB/Ey6KRpgEdLgwl7IsIyC7vr3Lug353gOTo
         Gwizj/zAoON73kkiR69aaeNX2ymvMHXZmayv4LVB+Jm03R8xKGujy20SEtka3+dHJ1UN
         u9NzgwCrQd7tuLeSRh2F6eklvtuX5jw4RTxkZ509/sLbUPnRr0g8JrX2FfK8QIKOPlSL
         gLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aVQrfsCj0EaYjV3S0UqwAeu50/dS1NKsyMUdIHSnM/s=;
        b=sSWpqBB+ud4JcYEqKRweYWQg4ZgjezYGMZnA0fLtoAywK4TzkqIpv/8sDKQPIhf3hY
         awpyEYVwbIJwiOBpA4I6DeRwllKoiYC1LT/uXRoE3d8f+UCSPwaCfTfxpOFhcP5OfGiM
         d8qQQmpwbIguCrrRJzi2YcK9olO2rFOfbkOADr47tQcNMlA5auEK53HCLlAzxRAlt6j2
         l++6Gz5nhjNov6xPCmCYLSH/3wKmwZQlwxvGPFXgRmt3yWX1fb1bFmHZrVXKneLq0bmX
         AwmIiYd0N/ebM1C6nI24VhUiyhxuQsfmy/yBMfBytU8zd2bccAS+TugNIWzxlGvn7gLC
         TCFg==
X-Gm-Message-State: ACrzQf0vVEE55bSU0c3lJEYYej413WRmoLdnWgEKHo2LNPNSYwac6dHv
        tlbw67crerV3ihLNZ/gFUUN1pG9q9mYhzDQx28oMeA==
X-Google-Smtp-Source: AMsMyM4U34xFFcPDyDaprpp+LkLtrVocW1uB+sGwbl8D3fbiQD95p8+5lVfAf4aQf5iO4ae7FRQeuxRt1qPsZmXocKA=
X-Received: by 2002:a6b:e707:0:b0:6bc:8875:4229 with SMTP id
 b7-20020a6be707000000b006bc88754229mr465828ioh.37.1666982788757; Fri, 28 Oct
 2022 11:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-3-sdf@google.com>
 <1596dd80-246b-80d0-b482-4248691de68e@redhat.com>
In-Reply-To: <1596dd80-246b-80d0-b482-4248691de68e@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 28 Oct 2022 11:46:17 -0700
Message-ID: <CAKH8qBsPHFy3E94a7VGXXzoKXL9GMnf=ggT8Ne3EO_uCcgajOA@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/5] veth: Support rx timestamp metadata for xdp
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
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

On Fri, Oct 28, 2022 at 1:40 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 27/10/2022 22.00, Stanislav Fomichev wrote:
> > xskxceiver conveniently setups up veth pairs so it seems logical
> > to use veth as an example for some of the metadata handling.
> >
> > We timestamp skb right when we "receive" it, store its
> > pointer in xdp_buff->priv and generate BPF bytecode to
> > reach it from the BPF program.
> >
> > This largely follows the idea of "store some queue context in
> > the xdp_buff/xdp_frame so the metadata can be reached out
> > from the BPF program".
> >
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
> >   drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
> >   1 file changed, 31 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 09682ea3354e..35396dd73de0 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -597,6 +597,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
> >
> >               xdp_convert_frame_to_buff(frame, &xdp);
> >               xdp.rxq = &rq->xdp_rxq;
> > +             xdp.priv = NULL;
>
> So, why doesn't this supported for normal XDP mode?!?
> e.g. Where veth gets XDP redirected an xdp_frame.

I wanted to have something simple for the demonstration purposes
(hence the re-usage of xskxceiver + veth without redirection).
But also see my cover letter:

Cons:
- forwarding has to be handled explicitly; the BPF programs have to
  agree on the metadata layout (IOW, the forwarding program
  has to be aware of the final AF_XDP consumer metadata layout)

> My main use case (for veth) is to make NIC hardware hints available to
> containers.  Thus, creating a flexible fast-path via XDP-redirect
> directly into containers veth device.  (This is e.g. for replacing the
> inflexible SR-IOV approach with SR-IOV net_devices in the container,
> with a more cloud friendly approach).
>
> How can we extend this approach to handle xdp_frame's from different
> net_device's ?

 So for this case, your forwarding program will have to call a bunch
of kfuncs and assemble the metadata.
It can also put some info about this metadata format. In theory, it
can even put some external btf-id for the struct that describes the
layout; or it can use some tlv format.
And then the final consumer will have to decide what to do with that metadata.

Or do you want xdp->skb conversion to also be transparently handled?
In this case, the last program will have to convert this to some new
xdp_hints_skb so the kernel can understand it. We might need some
extra helpers to signal those, but seems doable?

> >
> >               act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >
> > @@ -820,6 +821,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> >
> >       orig_data = xdp.data;
> >       orig_data_end = xdp.data_end;
> > +     xdp.priv = skb;
> >
>
> So, enabling SKB based path only.
>
> >       act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >
> > @@ -936,6 +938,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> >                       struct sk_buff *skb = ptr;
> >
> >                       stats->xdp_bytes += skb->len;
> > +                     __net_timestamp(skb);
> >                       skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> >                       if (skb) {
> >                               if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
> > @@ -1595,6 +1598,33 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> >       }
> >   }
> >
> > +static int veth_unroll_kfunc(struct bpf_prog *prog, struct bpf_insn *insn)
> > +{
> > +     u32 func_id = insn->imm;
> > +
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_HAVE_RX_TIMESTAMP)) {
> > +             /* return true; */
> > +             insn[0] = BPF_MOV64_IMM(BPF_REG_0, 1);
> > +             return 1;
> > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > +             /* r1 = ((struct xdp_buff *)r1)->priv; [skb] */
> > +             insn[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1,
> > +                                   offsetof(struct xdp_buff, priv));
> > +             /* if (r1 == NULL) { */
> > +             insn[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1);
> > +             /*      return 0; */
> > +             insn[2] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > +             /* } else { */
> > +             /*      return ((struct sk_buff *)r1)->tstamp; */
> > +             insn[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> > +                                   offsetof(struct sk_buff, tstamp));
>
> Just to be clear, this skb->tstamp is a software timestamp, right?

Yes, see above, this is just to showcase how the bpf/af_xdp side will
look. The 1st patch and the last one are the interesting ones. The
rest is boring plumbing we can ignore for now.




> > +             /* } */
> > +             return 4;
> > +     }
>
> I'm slightly concerned with driver developers maintaining BPF-bytecode
> on a per-driver bases, but I can certainly live with this if BPF
> maintainers can.
>
> > +
> > +     return 0;
> > +}
> > +
> >   static const struct net_device_ops veth_netdev_ops = {
> >       .ndo_init            = veth_dev_init,
> >       .ndo_open            = veth_open,
> > @@ -1614,6 +1644,7 @@ static const struct net_device_ops veth_netdev_ops = {
> >       .ndo_bpf                = veth_xdp,
> >       .ndo_xdp_xmit           = veth_ndo_xdp_xmit,
> >       .ndo_get_peer_dev       = veth_peer_dev,
> > +     .ndo_unroll_kfunc       = veth_unroll_kfunc,
> >   };
> >
> >   #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
>
