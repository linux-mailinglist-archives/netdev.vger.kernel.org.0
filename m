Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF76647ACD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLIAch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiLIAcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:32:36 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323E0CC3;
        Thu,  8 Dec 2022 16:32:34 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d14so1079969edj.11;
        Thu, 08 Dec 2022 16:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGZfLZ2nTw4+7WcF8MKsXwmI8yeURQq4sWvGDzZribo=;
        b=FhApbE6r3Q6+yY/M5ycQQHdtNFhn4uC9nBMrvGgusyIl99IUUU384ubR+g70IF6Kmd
         gGbDM5+RlUBgzaAIKHd9pAuZqMUKMAUKXIZ8GhAL2qyT93nJKBiHVBPcEXmhlCvvZHXW
         qMLcWY9CSY29xuLz5GhO2I6ajrReDHBM/G0mahgBWNbv2vXDKWMAabsno1wK0MkfSQ5m
         a6Ilvl2jPRa157rFgdFHByqXQXU7dk4rlwepv9UpJiylc52rlCicAfgjHinQDsKxT+6y
         suJ7hb9nIxVX2LM5JfFwbO6Pu+M/Rve9yC9A+byRZBWOBgBP+cKxE/5/AsHOhDViVPY1
         QjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGZfLZ2nTw4+7WcF8MKsXwmI8yeURQq4sWvGDzZribo=;
        b=Ken2K60a0v/jXa2LMcGGSQCmZ55PGnvm07dQd7GbkwcnijFZ4RFvbzT3nKnCoqlNQh
         oZSVC0Rv4HMWNO6PE5mpbTfUSNVHtcWrCBiE3xLJ1+FfGlQK0ygUmmC8HFKGbZmKcR7r
         bfNpNjz08mwA5EHXuK395hoK9eFlitS9effeIdsG1eiqlj02j0pki26mwWRdYc1nWg39
         hIQbk8f/ysY1hmLGrsnn5WNjZoLJMZIkl1g/IEPco+XeP7GUbId/hVgoMNRV/hCzw26n
         sHwBoplwuVG5EvoJNQ1H3KuM0z16dgB8xOjlbUB4HttjSjG8d/bAdIZGNMzaiedqoHMq
         InfQ==
X-Gm-Message-State: ANoB5pny0QUAVsHYly9/+AflM2DDbpq6cigIhBPL1CArhC1/Zr6JnKsD
        1Qm1/XQwGAQF1TmH+UNy+HAWIcY7YiPrsFcR2SA=
X-Google-Smtp-Source: AA0mqf5by7IbjW7virQjidaMt05Q6Ne4TP/ba+OJZAVV/QLqqsQKex6uhRFQIJ2xWilbknC6yDBOGtZ0w4kBqmKOt/Y=
X-Received: by 2002:a05:6402:142:b0:461:7fe6:9ea7 with SMTP id
 s2-20020a056402014200b004617fe69ea7mr4544644edu.94.1670545952547; Thu, 08 Dec
 2022 16:32:32 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk> <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk> <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk>
In-Reply-To: <87tu25ju77.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 8 Dec 2022 16:32:21 -0800
Message-ID: <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 4:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Dec 8, 2022 at 4:02 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > On Thu, Dec 8, 2022 at 2:59 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >> >>
> >> >> Stanislav Fomichev <sdf@google.com> writes:
> >> >>
> >> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> >
> >> >> > Support RX hash and timestamp metadata kfuncs. We need to pass in=
 the cqe
> >> >> > pointer to the mlx5e_skb_from* functions so it can be retrieved f=
rom the
> >> >> > XDP ctx to do this.
> >> >>
> >> >> So I finally managed to get enough ducks in row to actually benchma=
rk
> >> >> this. With the caveat that I suddenly can't get the timestamp suppo=
rt to
> >> >> work (it was working in an earlier version, but now
> >> >> timestamp_supported() just returns false). I'm not sure if this is =
an
> >> >> issue with the enablement patch, or if I just haven't gotten the
> >> >> hardware configured properly. I'll investigate some more, but figur=
ed
> >> >> I'd post these results now:
> >> >>
> >> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
> >> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
> >> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
> >> >>
> >> >> As per the above, this is with calling three kfuncs/pkt
> >> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So that'=
s
> >> >> ~0.95 ns per function call, which is a bit less, but not far off fr=
om
> >> >> the ~1.2 ns that I'm used to. The tests where I accidentally called=
 the
> >> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
> >> >> definitely in that ballpark.
> >> >>
> >> >> I'm not doing anything with the data, just reading it into an on-st=
ack
> >> >> buffer, so this is the smallest possible delta from just getting th=
e
> >> >> data out of the driver. I did confirm that the call instructions ar=
e
> >> >> still in the BPF program bytecode when it's dumped back out from th=
e
> >> >> kernel.
> >> >>
> >> >> -Toke
> >> >>
> >> >
> >> > Oh, that's great, thanks for running the numbers! Will definitely
> >> > reference them in v4!
> >> > Presumably, we should be able to at least unroll most of the
> >> > _supported callbacks if we want, they should be relatively easy; but
> >> > the numbers look fine as is?
> >>
> >> Well, this is for one (and a half) piece of metadata. If we extrapolat=
e
> >> it adds up quickly. Say we add csum and vlan tags, say, and maybe
> >> another callback to get the type of hash (l3/l4). Those would probably
> >> be relevant for most packets in a fairly common setup. Extrapolating
> >> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
> >> baseline of 39 ns.
> >>
> >> So in that sense I still think unrolling makes sense. At least for the
> >> _supported() calls, as eating a whole function call just for that is
> >> probably a bit much (which I think was also Jakub's point in a sibling
> >> thread somewhere).
> >
> > imo the overhead is tiny enough that we can wait until
> > generic 'kfunc inlining' infra is ready.
> >
> > We're planning to dual-compile some_kernel_file.c
> > into native arch and into bpf arch.
> > Then the verifier will automatically inline bpf asm
> > of corresponding kfunc.
>
> Is that "planning" or "actively working on"? Just trying to get a sense
> of the time frames here, as this sounds neat, but also something that
> could potentially require quite a bit of fiddling with the build system
> to get to work? :)

"planning", but regardless how long it takes I'd rather not
add any more tech debt in the form of manual bpf asm generation.
We have too much of it already: gen_lookup, convert_ctx_access, etc.
