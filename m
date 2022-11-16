Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94FC62B20E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiKPEJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiKPEJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:09:37 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F6011461
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:09:36 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id a7-20020a056830008700b0066c82848060so9741720oto.4
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4x7mjeQl2Jz24wHOq/2fvXva/J1mGhACRnJol7jPpY=;
        b=deo8WWn+fuUZIplwxsmJEh9XzsmWYNj2tGzi6rVsWWtsKIogoTqgryb3b1EGGy9Hh/
         NCk1r4JWOPU1m19XuZdjB32WY+nSsSN9Uzge5TSWw0DRj2jpfQMCK1ljxmP+Cl/9z/Dr
         fglOGIot/CWkcl0ngvnl9GCkLmZOfnIU3DU9cl8D+sKgRRapgq9FxNznYgdP7g3/BYKT
         6pEuGZpk1fCgabOI7KZAvmU4gqTe5pAzhWkVeXD1vJPEojZV2fqGNknT+4Dq8iVfBbGr
         P/fm6RlHMrGF8RKMvsChIGMI2CBK8+51joRutf85pdgAQFMp2Lx21Q72/g/tkAJToxf9
         tI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b4x7mjeQl2Jz24wHOq/2fvXva/J1mGhACRnJol7jPpY=;
        b=P8o6dVpunZ3rYDlPBtHuB5JNaHj2MkYsyebi+nJ7imSOV1Ld7JqbzSww5B+LGocBTn
         RqYRmAsSap0ckZLnN3N1QF1jiYFsAHVGP11OwYOFU581EvjXJc5oZKQPd1gpl3Z4Vj33
         cdqjLGpBowV7nK/5SVJg+3PCkKL6t5m88+FiF1evjzN2TurRe+ViOTkKNV3ikdnen/Aa
         Zczp0Ygql2Z6PheZYB3pe5oDW5Mwt1wr7/9pMeTRqjLlVb8G06zvp2FBlzcXOKPTM6Qj
         zdv1MAWj4XAky2z/x27uxJ8EqdDZ8o6AbeV20fW6JJFMIQpeMosmK1FpwcYMMpgA8cSU
         51dw==
X-Gm-Message-State: ANoB5pmEGf2+abD2OwRK+bvShwuABvJ5XocUBPoJDdAHa7bDvrnbZG7D
        +4ir0YoUSeCdtftiEg/gtk4TAQzNP98cUyOHoXiQFQ==
X-Google-Smtp-Source: AA0mqf6FwxC+oVGRJqnspRiAVKRG4pQlNEbazfh78TgxFxaOZod5nbfv5x1oWe39FiMi423yr6oK2iAbH11LbspDACQ=
X-Received: by 2002:a9d:4f06:0:b0:66c:794e:f8c6 with SMTP id
 d6-20020a9d4f06000000b0066c794ef8c6mr10312938otl.343.1668571775397; Tue, 15
 Nov 2022 20:09:35 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
In-Reply-To: <8735ajet05.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Nov 2022 20:09:24 -0800
Message-ID: <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
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

On Tue, Nov 15, 2022 at 2:46 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Tue, Nov 15, 2022 at 8:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > The goal is to enable end-to-end testing of the metadata
> >> > for AF_XDP. Current rx_timestamp kfunc returns current
> >> > time which should be enough to exercise this new functionality.
> >> >
> >> > Cc: John Fastabend <john.fastabend@gmail.com>
> >> > Cc: David Ahern <dsahern@gmail.com>
> >> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >> > Cc: Jakub Kicinski <kuba@kernel.org>
> >> > Cc: Willem de Bruijn <willemb@google.com>
> >> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> >> > Cc: xdp-hints@xdp-project.net
> >> > Cc: netdev@vger.kernel.org
> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> > ---
> >> >  drivers/net/veth.c | 14 ++++++++++++++
> >> >  1 file changed, 14 insertions(+)
> >> >
> >> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> >> > index 2a4592780141..c626580a2294 100644
> >> > --- a/drivers/net/veth.c
> >> > +++ b/drivers/net/veth.c
> >> > @@ -25,6 +25,7 @@
> >> >  #include <linux/filter.h>
> >> >  #include <linux/ptr_ring.h>
> >> >  #include <linux/bpf_trace.h>
> >> > +#include <linux/bpf_patch.h>
> >> >  #include <linux/net_tstamp.h>
> >> >
> >> >  #define DRV_NAME     "veth"
> >> > @@ -1659,6 +1660,18 @@ static int veth_xdp(struct net_device *dev, s=
truct netdev_bpf *xdp)
> >> >       }
> >> >  }
> >> >
> >> > +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func=
_id,
> >> > +                           struct bpf_patch *patch)
> >> > +{
> >> > +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX=
_TIMESTAMP_SUPPORTED)) {
> >> > +             /* return true; */
> >> > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> >> > +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_K=
FUNC_RX_TIMESTAMP)) {
> >> > +             /* return ktime_get_mono_fast_ns(); */
> >> > +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_f=
ast_ns));
> >> > +     }
> >> > +}
> >>
> >> So these look reasonable enough, but would be good to see some example=
s
> >> of kfunc implementations that don't just BPF_CALL to a kernel function
> >> (with those helper wrappers we were discussing before).
> >
> > Let's maybe add them if/when needed as we add more metadata support?
> > xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
> > examples, so it shouldn't be a problem to resurrect them back at some
> > point?
>
> Well, the reason I asked for them is that I think having to maintain the
> BPF code generation in the drivers is probably the biggest drawback of
> the kfunc approach, so it would be good to be relatively sure that we
> can manage that complexity (via helpers) before we commit to this :)

Right, and I've added a bunch of examples in v2 rfc so we can judge
whether that complexity is manageable or not :-)
Do you want me to add those wrappers you've back without any real users?
Because I had to remove my veth tstamp accessors due to John/Jesper
objections; I can maybe bring some of this back gated by some
static_branch to avoid the fastpath cost?
