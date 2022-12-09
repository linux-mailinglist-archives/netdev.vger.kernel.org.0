Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E48647C7B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLIC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLIC6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:58:03 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180531350
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 18:58:03 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id jl24so3485570plb.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 18:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKFHfUNbYBaa8oKF+epCKn9yW4OwAypIKkFW/BCqpKU=;
        b=hpXGnyf+L4YzgW/W3/aEHFmd8/pB/NlhkSQkPQss8b73GvqXMVRX23UGZ8ufA3/72W
         51nhQWqSqivU0wndwI8dQ5+tGjh/gNJnmKcvyklRuiot7OcxaTpRR+DdpKOiB9mnwipt
         Cotb8elUm3XHINM/CKtYJH0nt6ksukVpDE2DpwmfLdOjXzviZc6+bk/zC5YsKgD0N5PK
         m86zo69+yy0GjfYhZqH7y+xOc0nw46epdFLRkzGIS+PRY4GYP8c3n1FqLCTZQp7mmymI
         ETog2TaC1gi3DiBiweXbgaXQmUKP0fvNvSrzgbPc797lfUwJJ09n7tsApHSb2a/WiS1m
         xWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKFHfUNbYBaa8oKF+epCKn9yW4OwAypIKkFW/BCqpKU=;
        b=2oS6czi1tv9qDCqrdOgeOYooR2jgXkNJoGqK4tBFNioRfG0BM6NwXBsBOjEDRvwev7
         FH2VwmsiPoDdJlrttIM0sXTOjKwj9n08jqOY/o1R3hRj46Wrafm2M0oipxxz4z14fhDL
         y+ysoOeAG7s8zspBipkZ8cLfjC6XPRqr/puDl3VQh5b61DDApjj57THs3oXM7H99PvJm
         gTp5TjU3u/oPNWgoj+eCHy9wdLKvav6NuYGdF24WsFlgKP0x4YReO4R28SwKszrMB8hg
         t9WpimOAesPMYlnM21T+9uBM4bey6DcoBQ+BL/YOeZRzAP0gb7+XjcQQOzs3vH1aRBpI
         RHpg==
X-Gm-Message-State: ANoB5pnRlBq9ML4+/9UWQHCUf0b1YFcerxHk2dEajB8BkUSfGFx4FEZ8
        hoaT8cAyEFWjREK3wgALeI+zsoVG4UIr1c40VYrWCA==
X-Google-Smtp-Source: AA0mqf4YpNhtzL7P+J0KFu6DARjkf2bT6zsSChOOlyAGB8Y3RVsoHgQiWB0Oa1rSQbwTN5EhQg4F7pQai6ZYu/ZHgo4=
X-Received: by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr79283207ply.88.1670554682328; Thu, 08
 Dec 2022 18:58:02 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk> <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk> <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk> <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk>
In-Reply-To: <87o7sdjt20.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 18:57:50 -0800
Message-ID: <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
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

On Thu, Dec 8, 2022 at 4:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Dec 8, 2022 at 4:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Thu, Dec 8, 2022 at 4:02 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >> >>
> >> >> Stanislav Fomichev <sdf@google.com> writes:
> >> >>
> >> >> > On Thu, Dec 8, 2022 at 2:59 PM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> >> >> >>
> >> >> >> Stanislav Fomichev <sdf@google.com> writes:
> >> >> >>
> >> >> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> >> >
> >> >> >> > Support RX hash and timestamp metadata kfuncs. We need to pass=
 in the cqe
> >> >> >> > pointer to the mlx5e_skb_from* functions so it can be retrieve=
d from the
> >> >> >> > XDP ctx to do this.
> >> >> >>
> >> >> >> So I finally managed to get enough ducks in row to actually benc=
hmark
> >> >> >> this. With the caveat that I suddenly can't get the timestamp su=
pport to
> >> >> >> work (it was working in an earlier version, but now
> >> >> >> timestamp_supported() just returns false). I'm not sure if this =
is an
> >> >> >> issue with the enablement patch, or if I just haven't gotten the
> >> >> >> hardware configured properly. I'll investigate some more, but fi=
gured
> >> >> >> I'd post these results now:
> >> >> >>
> >> >> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
> >> >> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
> >> >> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
> >> >> >>
> >> >> >> As per the above, this is with calling three kfuncs/pkt
> >> >> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So th=
at's
> >> >> >> ~0.95 ns per function call, which is a bit less, but not far off=
 from
> >> >> >> the ~1.2 ns that I'm used to. The tests where I accidentally cal=
led the
> >> >> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
> >> >> >> definitely in that ballpark.
> >> >> >>
> >> >> >> I'm not doing anything with the data, just reading it into an on=
-stack
> >> >> >> buffer, so this is the smallest possible delta from just getting=
 the
> >> >> >> data out of the driver. I did confirm that the call instructions=
 are
> >> >> >> still in the BPF program bytecode when it's dumped back out from=
 the
> >> >> >> kernel.
> >> >> >>
> >> >> >> -Toke
> >> >> >>
> >> >> >
> >> >> > Oh, that's great, thanks for running the numbers! Will definitely
> >> >> > reference them in v4!
> >> >> > Presumably, we should be able to at least unroll most of the
> >> >> > _supported callbacks if we want, they should be relatively easy; =
but
> >> >> > the numbers look fine as is?
> >> >>
> >> >> Well, this is for one (and a half) piece of metadata. If we extrapo=
late
> >> >> it adds up quickly. Say we add csum and vlan tags, say, and maybe
> >> >> another callback to get the type of hash (l3/l4). Those would proba=
bly
> >> >> be relevant for most packets in a fairly common setup. Extrapolatin=
g
> >> >> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
> >> >> baseline of 39 ns.
> >> >>
> >> >> So in that sense I still think unrolling makes sense. At least for =
the
> >> >> _supported() calls, as eating a whole function call just for that i=
s
> >> >> probably a bit much (which I think was also Jakub's point in a sibl=
ing
> >> >> thread somewhere).
> >> >
> >> > imo the overhead is tiny enough that we can wait until
> >> > generic 'kfunc inlining' infra is ready.
> >> >
> >> > We're planning to dual-compile some_kernel_file.c
> >> > into native arch and into bpf arch.
> >> > Then the verifier will automatically inline bpf asm
> >> > of corresponding kfunc.
> >>
> >> Is that "planning" or "actively working on"? Just trying to get a sens=
e
> >> of the time frames here, as this sounds neat, but also something that
> >> could potentially require quite a bit of fiddling with the build syste=
m
> >> to get to work? :)
> >
> > "planning", but regardless how long it takes I'd rather not
> > add any more tech debt in the form of manual bpf asm generation.
> > We have too much of it already: gen_lookup, convert_ctx_access, etc.
>
> Right, I'm no fan of the manual ASM stuff either. However, if we're
> stuck with the function call overhead for the foreseeable future, maybe
> we should think about other ways of cutting down the number of function
> calls needed?
>
> One thing I can think of is to get rid of the individual _supported()
> kfuncs and instead have a single one that lets you query multiple
> features at once, like:
>
> __u64 features_supported, features_wanted =3D XDP_META_RX_HASH | XDP_META=
_TIMESTAMP;
>
> features_supported =3D bpf_xdp_metadata_query_features(ctx, features_want=
ed);
>
> if (features_supported & XDP_META_RX_HASH)
>   hash =3D bpf_xdp_metadata_rx_hash(ctx);
>
> ...etc

I'm not too happy about having the bitmasks tbh :-(
If we want to get rid of the cost of those _supported calls, maybe we
can do some kind of libbpf-like probing? That would require loading a
program + waiting for some packet though :-(

Or maybe they can just be cached for now?

if (unlikely(!got_first_packet)) {
  have_hash =3D bpf_xdp_metadata_rx_hash_supported();
  have_timestamp =3D bpf_xdp_metadata_rx_timestamp_supported();
  got_first_packet =3D true;
}

if (have_hash) {}
if (have_timestamp) {}

That should hopefully work until generic inlining infra?

> -Toke
>
