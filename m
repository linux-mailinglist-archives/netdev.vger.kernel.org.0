Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D632E6484E2
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiLIPUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiLIPUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:20:14 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B87487C90;
        Fri,  9 Dec 2022 07:20:11 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso6119710wmb.0;
        Fri, 09 Dec 2022 07:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fnk658isXxLTRluECFguKQ5bgT0PCiJCrq5n84WC07k=;
        b=K+MfZumAJSaZQU1TD0ojk0O4rZR4zyXk4o19xiXGIkgO0zljC848vH1YNA8nsRUruz
         AmWSFlqsd87TXySGrkkelC3YO7qeI062ivQulcmZ8U0hYOjRWW2qS5/Xk+m1njtCQso5
         8EiPRL+x0q96nAk6XwvCUdx0t+TJjsfGTBq2p/8e3xbuTtlnPA2nsxXLxdoYpJzi/Sxx
         1+SAKV7fE8rmwlT7NdT4pYpe9a4ltVu7e3XniB+qGyB2PMLyXW4W2eUawVSQkY/UQ1ww
         1nkpFETZp2x7ld1assaFBudSkAR02IgTHImdoPez9XQS0ZfVOQCSn4hTbhbzqCbEZJkq
         Le9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fnk658isXxLTRluECFguKQ5bgT0PCiJCrq5n84WC07k=;
        b=eh9i/Y9JyzNBwwRZgsKSJE7jhZ5fM+YdsQ/UH0yBUNFnsZLOJzMGGdEypezXI3hi25
         upV4CFC60YDIejH6sceOXD4x+n2S1MaP0Qe7L5Sp+P/vKQDI/B3Xmn2rj9OFK74Nm221
         tjG//kYhD/W6IOkVIyZEh0tCGwI4JEB2CkxnRD8zUIiL4vvD0m4uTE2XUQ054wgWO9n+
         9HaGwmLIFaqttyeRkTQfJrIyrj9lCow8fhFOo3+wrDcaWBZ9HkGf2xEWQoglVYlMPdCg
         L3Cp3SL1cHS8kJwQzb0Zr1+oBg72infDE+rb9mgbS8VChBu+iTQDNwP2//frYlq4barV
         FDkg==
X-Gm-Message-State: ANoB5pmYPrkY+Ds7SMJem0Om2Qs2kR4L88P0LNjIz2LVf7dM031vLTfn
        WzWSuWU9HQxh/4m/wjk1YZHPl5LSzEhe8PKt0No=
X-Google-Smtp-Source: AA0mqf75/IKiFawBHnsg+wdRfijf2g8/Yt4wRqWY1Ci4HTXUXTORl7sQ8Ldy0g2LkgQjXLzLkpRoHXIgHla20z0BzL8=
X-Received: by 2002:a7b:c3d3:0:b0:3d1:cec6:75a8 with SMTP id
 t19-20020a7bc3d3000000b003d1cec675a8mr11511149wmj.206.1670599209880; Fri, 09
 Dec 2022 07:20:09 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk> <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk> <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk> <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk> <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
 <Y5LGlgpxpzSu701h@x130> <66fa1861-30dd-6d00-ed14-0cf4a6b39f3c@redhat.com>
In-Reply-To: <66fa1861-30dd-6d00-ed14-0cf4a6b39f3c@redhat.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 9 Dec 2022 07:19:57 -0800
Message-ID: <CAA93jw6NVU5FpLY13VrA7buaBCQ=+0=Cv2M-OkkXDBeZ-mgqjA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, brouer@redhat.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 9, 2022 at 5:29 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 09/12/2022 06.24, Saeed Mahameed wrote:
> > On 08 Dec 18:57, Stanislav Fomichev wrote:
> >> On Thu, Dec 8, 2022 at 4:54 PM Toke H=C3=B8iland-J=C3=B8rgensen
> >> <toke@redhat.com> wrote:
> >>>
> >>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>>
> >>> > On Thu, Dec 8, 2022 at 4:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >>> >>
> >>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>> >>
> >>> >> > On Thu, Dec 8, 2022 at 4:02 PM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
> >>> >> >>
> >>> >> >> Stanislav Fomichev <sdf@google.com> writes:
> >>> >> >>
> >>> >> >> > On Thu, Dec 8, 2022 at 2:59 PM Toke H=C3=B8iland-J=C3=B8rgens=
en <toke@redhat.com> wrote:
> >>> >> >> >>
> >>> >> >> >> Stanislav Fomichev <sdf@google.com> writes:
> >>> >> >> >>
> >>> >> >> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> >> >> >> >
> >>> >> >> >> > Support RX hash and timestamp metadata kfuncs. We need to =
pass in the cqe
> >>> >> >> >> > pointer to the mlx5e_skb_from* functions so it can be retr=
ieved from the
> >>> >> >> >> > XDP ctx to do this.
> >>> >> >> >>
> >>> >> >> >> So I finally managed to get enough ducks in row to actually =
benchmark
> >>> >> >> >> this. With the caveat that I suddenly can't get the timestam=
p support to
> >>> >> >> >> work (it was working in an earlier version, but now
> >>> >> >> >> timestamp_supported() just returns false). I'm not sure if t=
his is an
> >>> >> >> >> issue with the enablement patch, or if I just haven't gotten=
 the
> >>> >> >> >> hardware configured properly. I'll investigate some more, bu=
t figured
> >>> >> >> >> I'd post these results now:
> >>> >> >> >>
> >>> >> >> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
> >>> >> >> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
> >>> >> >> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
> >>> >> >> >>
> >>> >> >> >> As per the above, this is with calling three kfuncs/pkt
> >>> >> >> >> (metadata_supported(), rx_hash_supported() and rx_hash()). S=
o that's
> >>> >> >> >> ~0.95 ns per function call, which is a bit less, but not far=
 off from
> >>> >> >> >> the ~1.2 ns that I'm used to. The tests where I accidentally=
 called the
> >>> >> >> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so i=
t's
> >>> >> >> >> definitely in that ballpark.
> >>> >> >> >>
> >>> >> >> >> I'm not doing anything with the data, just reading it into a=
n on-stack
> >>> >> >> >> buffer, so this is the smallest possible delta from just get=
ting the
> >>> >> >> >> data out of the driver. I did confirm that the call instruct=
ions are
> >>> >> >> >> still in the BPF program bytecode when it's dumped back out =
from the
> >>> >> >> >> kernel.
> >>> >> >> >>
> >>> >> >> >> -Toke
> >>> >> >> >>
> >>> >> >> >
> >>> >> >> > Oh, that's great, thanks for running the numbers! Will defini=
tely
> >>> >> >> > reference them in v4!
> >>> >> >> > Presumably, we should be able to at least unroll most of the
> >>> >> >> > _supported callbacks if we want, they should be relatively ea=
sy; but
> >>> >> >> > the numbers look fine as is?
> >>> >> >>
> >>> >> >> Well, this is for one (and a half) piece of metadata. If we ext=
rapolate
> >>> >> >> it adds up quickly. Say we add csum and vlan tags, say, and may=
be
> >>> >> >> another callback to get the type of hash (l3/l4). Those would p=
robably
> >>> >> >> be relevant for most packets in a fairly common setup. Extrapol=
ating
> >>> >> >> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of th=
e
> >>> >> >> baseline of 39 ns.
> >>> >> >>
> >>> >> >> So in that sense I still think unrolling makes sense. At least =
for the
> >>> >> >> _supported() calls, as eating a whole function call just for th=
at is
> >>> >> >> probably a bit much (which I think was also Jakub's point in a =
sibling
> >>> >> >> thread somewhere).
> >>> >> >
> >>> >> > imo the overhead is tiny enough that we can wait until
> >>> >> > generic 'kfunc inlining' infra is ready.
> >>> >> >
> >>> >> > We're planning to dual-compile some_kernel_file.c
> >>> >> > into native arch and into bpf arch.
> >>> >> > Then the verifier will automatically inline bpf asm
> >>> >> > of corresponding kfunc.
> >>> >>
> >>> >> Is that "planning" or "actively working on"? Just trying to get a =
sense
> >>> >> of the time frames here, as this sounds neat, but also something t=
hat
> >>> >> could potentially require quite a bit of fiddling with the build s=
ystem
> >>> >> to get to work? :)
> >>> >
> >>> > "planning", but regardless how long it takes I'd rather not
> >>> > add any more tech debt in the form of manual bpf asm generation.
> >>> > We have too much of it already: gen_lookup, convert_ctx_access, etc=
.
> >>>
> >>> Right, I'm no fan of the manual ASM stuff either. However, if we're
> >>> stuck with the function call overhead for the foreseeable future, may=
be
> >>> we should think about other ways of cutting down the number of functi=
on
> >>> calls needed?
> >>>
> >>> One thing I can think of is to get rid of the individual _supported()
> >>> kfuncs and instead have a single one that lets you query multiple
> >>> features at once, like:
> >>>
> >>> __u64 features_supported, features_wanted =3D XDP_META_RX_HASH |
> >>> XDP_META_TIMESTAMP;
> >>>
> >>> features_supported =3D bpf_xdp_metadata_query_features(ctx,
> >>> features_wanted);
> >>>
> >>> if (features_supported & XDP_META_RX_HASH)
> >>>   hash =3D bpf_xdp_metadata_rx_hash(ctx);
> >>>
> >>> ...etc
> >>
> >> I'm not too happy about having the bitmasks tbh :-(
> >> If we want to get rid of the cost of those _supported calls, maybe we
> >> can do some kind of libbpf-like probing? That would require loading a
> >> program + waiting for some packet though :-(
> >>
> >> Or maybe they can just be cached for now?
> >>
> >> if (unlikely(!got_first_packet)) {
> >>  have_hash =3D bpf_xdp_metadata_rx_hash_supported();
> >>  have_timestamp =3D bpf_xdp_metadata_rx_timestamp_supported();
> >>  got_first_packet =3D true;
> >> }
> >
> > hash/timestap/csum is per packet .. vlan as well depending how you look=
 at
> > it..
>
> True, we cannot cache this as it is *per packet* info.
>
> > Sorry I haven't been following the progress of xdp meta data, but why d=
id
> > we drop the idea of btf and driver copying metdata in front of the xdp
> > frame ?
> >
>
> It took me some time to understand this new approach, and why it makes
> sense.  This is my understanding of the design direction change:
>
> This approach gives more control to the XDP BPF-prog to pick and choose
> which XDP hints are relevant for the specific use-case.  BPF-prog can
> also skip storing hints anywhere and just read+react on value (that e.g.
> comes from RX-desc).
>
> For the use-cases redirect, AF_XDP, chained BPF-progs, XDP-to-TC,
> SKB-creation, we *do* need to store hints somewhere, as RX-desc will be
> out-of-scope.  I this patchset hand-waves and says BPF-prog can just
> manually store this in a prog custom layout in metadata area.  I'm not
> super happy with ignoring/hand-waving all these use-case, but I
> hope/think we later can extend this some more structure to support these
> use-cases better (with this patchset as a foundation).
>
> I actually like this kfunc design, because the BPF-prog's get an
> intuitive API, and on driver side we can hide the details of howto
> extract the HW hints.
>
>
> > hopefully future HW generations will do that for free ..
>
> True.  I think it is worth repeating, that the approach of storing HW
> hints in metadata area (in-front of packet data) was to allow future HW
> generations to write this.  Thus, eliminating the 6 ns (that I showed it
> cost), and then it would be up-to XDP BPF-prog to pick and choose which
> to read, like this patchset already offers.

As a hope for future generators of hw, being able to choose a cpu to interr=
upt
from a LPM table would be great. I keep hoping to find a card that can
do this already...

Also I would like to thank everyone working on this project so far for
what you've
accomplished. We're now pushing 20Gbit (through a vlan even) through
libreqos.io for thousands of ISP subscribers using all this great stuff, on
16 cores at only 24% of cpu through CAKE and also successfully monitoring
TCP RTTs at this scale via ebpf pping.

( https://www.yahoo.com/now/libreqoe-releases-version-1-3-214700756.html )
"Our hat is off to the creators of CAKE and the new Linux XDP and eBPF
subsystems!"

In our case, timestamp, and *3* hashes, are needed for cake, and interrupti=
ng
the right cpu would be great...

>
> This patchset isn't incompatible with future HW generations doing this,
> as the kfunc would hide the details and point to this area instead of
> the RX-desc.  While we get the "store for free" from hardware, I do
> worry that reading this memory area (which will part of DMA area) is
> going to be slower than reading from RX-desc.
>
> > if btf is the problem then each vendor can provide a bpf func(s) that w=
ould
> > parse the metdata inside of the xdp/bpf prog domain to help programs
> > extract the vendor specific data..
> >
>
> In some sense, if unroll will becomes a thing, then this patchset is
> partly doing this.
>
> I did imagine that after/followup on XDP-hints with BTF patchset, we
> would allow drivers to load an BPF-prog that changed/selected which HW
> hints were relevant, to reduce those 6 ns overhead we introduced.
>
> --Jesper
>


--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
