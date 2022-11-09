Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FCA6235DF
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiKIVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiKIVeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:34:19 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CDA2AD5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:34:16 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 63so15012730iov.8
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 13:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCKAwu4bCVG9TGZygS9B/zBZa3cEyi6pjEuB8HyjidI=;
        b=YuWbyjeyw8Sd4e2WnAEJGyPjCZRsTyS+9XzZinHMsh5Mv3CI6hkDiYzHkcmo24joAJ
         nNFZmCrJbH3Accs0y4rqHajtY3tjxDtNynWoKq+j9A8ClPF88c5dlrE28DuIO0pHQ58N
         wzzfAOM5nIw0h8mwVbFCRbB6z9QfZ8YSnmQhjQEdI6I7aQL3kzP2jTrjY622RFNRwQW1
         JNjK0aUxNNlsu26imIDp1/tmLCpQQTXx2kW3Zgzoa56iT3gJWHcdPiO1IuH8So/HgIaJ
         li+ZuPshQdu3Y+O8dWUyAxh33bhRt5gPXm5K8Bw8+hly3svPNg8jiFhFY2LDlsr1Enk5
         ROsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCKAwu4bCVG9TGZygS9B/zBZa3cEyi6pjEuB8HyjidI=;
        b=4iFU0nXZsQ+JL1vj/m07bvDCKAtSmbDHsv0IcqoStzXBWM3ABaKMUGIBAUjgzVrngC
         gOIrW61F4hBkuOYL/fjoDk4yJKClx4g+yq0i+GbpzhktSchiKHO2JVHBGIEUEVY041YX
         GklwVSU9l3MobvT+JZaHsrV4gISDIrd+HSiMKheymR8KunPD7V60/pXQk45frpq67xMv
         Tkkwng45PURN20ezXVJbHWxI2ng2aPZtuMtqDPibWW2UTJfbGx/14x7aMhcYKhW6Yi9V
         K0h5fEYf2Ahg83rREV4QxirfCO9pOyf8AkH4F46vX7amir3Z+rtuD0A75xj3Gmr9fQ42
         7fpQ==
X-Gm-Message-State: ACrzQf0G0xSbLZa4p7mwq/BogEsskUsJn3+5bks+0DsCyMX74ApGLRwu
        g03r6+zto1zPNwdM93x9ueX7rrWBIxOTBBAk72oP9Q==
X-Google-Smtp-Source: AMsMyM5i7DK3klvFZuKjaIEdAy/Ka5PHJoe5YnH4EEZnYS5XskMl09c8KrWbkVUvPf+PYqL3SEh/EZ5vZUHlujBADhA=
X-Received: by 2002:a02:9401:0:b0:375:6e82:482b with SMTP id
 a1-20020a029401000000b003756e82482bmr25457585jai.84.1668029655904; Wed, 09
 Nov 2022 13:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-5-sdf@google.com>
 <87iljoz83d.fsf@toke.dk>
In-Reply-To: <87iljoz83d.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Nov 2022 13:34:05 -0800
Message-ID: <CAKH8qBt0qDLUC7GHg_6Lys8OfOkruq92Sf6iK6R1ciW2R9JD=w@mail.gmail.com>
Subject: Re: [xdp-hints] [RFC bpf-next v2 04/14] veth: Support rx timestamp
 metadata for xdp
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
Content-Transfer-Encoding: quoted-printable
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

On Wed, Nov 9, 2022 at 3:21 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > xskxceiver conveniently setups up veth pairs so it seems logical
> > to use veth as an example for some of the metadata handling.
> >
> > We timestamp skb right when we "receive" it, store its
> > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > reach it from the BPF program.
> >
> > This largely follows the idea of "store some queue context in
> > the xdp_buff/xdp_frame so the metadata can be reached out
> > from the BPF program".
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
> >  drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 917ba57453c1..0e629ceb087b 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/filter.h>
> >  #include <linux/ptr_ring.h>
> >  #include <linux/bpf_trace.h>
> > +#include <linux/bpf_patch.h>
> >  #include <linux/net_tstamp.h>
> >
> >  #define DRV_NAME     "veth"
> > @@ -118,6 +119,7 @@ static struct {
> >
> >  struct veth_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct sk_buff *skb;
> >  };
> >
> >  static int veth_get_link_ksettings(struct net_device *dev,
> > @@ -602,6 +604,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct ve=
th_rq *rq,
> >
> >               xdp_convert_frame_to_buff(frame, xdp);
> >               xdp->rxq =3D &rq->xdp_rxq;
> > +             vxbuf.skb =3D NULL;
> >
> >               act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> >
> > @@ -826,6 +829,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth=
_rq *rq,
> >
> >       orig_data =3D xdp->data;
> >       orig_data_end =3D xdp->data_end;
> > +     vxbuf.skb =3D skb;
> >
> >       act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> >
> > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int bud=
get,
> >                       struct sk_buff *skb =3D ptr;
> >
> >                       stats->xdp_bytes +=3D skb->len;
> > +                     __net_timestamp(skb);
> >                       skb =3D veth_xdp_rcv_skb(rq, skb, bq, stats);
> >                       if (skb) {
> >                               if (skb_shared(skb) || skb_unclone(skb, G=
FP_ATOMIC))
> > @@ -1665,6 +1670,31 @@ static int veth_xdp(struct net_device *dev, stru=
ct netdev_bpf *xdp)
> >       }
> >  }
> >
> > +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id=
,
> > +                           struct bpf_patch *patch)
> > +{
> > +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TI=
MESTAMP_SUPPORTED)) {
> > +             /* return true; */
> > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> > +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUN=
C_RX_TIMESTAMP)) {
> > +             bpf_patch_append(patch,
> > +                     /* r5 =3D ((struct veth_xdp_buff *)r1)->skb; */
> > +                     BPF_LDX_MEM(BPF_DW, BPF_REG_5, BPF_REG_1,
> > +                                 offsetof(struct veth_xdp_buff, skb)),
> > +                     /* if (r5 =3D=3D NULL) { */
> > +                     BPF_JMP_IMM(BPF_JNE, BPF_REG_5, 0, 2),
> > +                     /*      return 0; */
> > +                     BPF_MOV64_IMM(BPF_REG_0, 0),
> > +                     BPF_JMP_A(1),
> > +                     /* } else { */
> > +                     /*      return ((struct sk_buff *)r5)->tstamp; */
> > +                     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_5,
> > +                                 offsetof(struct sk_buff, tstamp)),
> > +                     /* } */
>
> I don't think it's realistic to expect driver developers to write this
> level of BPF instructions for everything. With the 'patch' thing it
> should be feasible to write some helpers that driver developers can use,
> right? E.g., this one could be:
>
> bpf_read_context_member_u64(size_t ctx_offset, size_t member_offset)
>
> called as:
>
> bpf_read_context_member_u64(offsetof(struct veth_xdp_buff, skb), offsetof=
(struct sk_buff, tstamp));
>
> or with some macro trickery we could even hide the offsetof so you just
> pass in types and member names?

Definitely; let's start with the one you're proposing, we'll figure
out the rest as we go; thx!

> -Toke
>
