Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F483591954
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 09:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbiHMHwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 03:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiHMHwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 03:52:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C88312A85;
        Sat, 13 Aug 2022 00:52:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so2723802pjf.5;
        Sat, 13 Aug 2022 00:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=maPUir0VcPvhh/9jwsQwdhOHtzFMLZNIvg3FsfxGeqQ=;
        b=PyhEFXOQG/6/nnY73No372hMsgU2sLjrsbcC1ELl6/y/yDP6JlWtz6hljP4gMYccTB
         IrerN6OJ32GFm53BmndzfUPYLG83NR514yt+7ueApyCaGPsorfRpxBXT2Y+TYM6CK5zl
         d85aQBC68LV786pPG0NCD2wy87Wk8ejHA5zksQGtbq5z32/zBuNHhcfLcaT/HP2ZiUeF
         xHrdm4P4eNIiFEL0hwV6SqplYsSrmMhLv0LBZn4tl7S+Ex/w91YsqDlowtMqr/sfZ2oq
         n6ouCgsIhLTQE23HWDP2r6ZOWEazgKTo4qsbFd33lRsXnDYw6hYQhk5FtOU3ZQYV7TNC
         Rjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=maPUir0VcPvhh/9jwsQwdhOHtzFMLZNIvg3FsfxGeqQ=;
        b=QWCXtSEM+dQTv283d28BMbmnphLOMj43AabJIBDguexmbKcWc+s7345iXCzXP/icLB
         tA3jjXSKjHID14JLW4W6BYbZm9B0HjMC5OHG80oz0cfgC3y1c/LROUBbtd+956sy8EGm
         95uURYYz62z7gMYv7foH12wrCjY3qMPKIRDgQPN7QSiMspn2gbXwAHVa66s8i5qKLzmc
         VsOtMJ08fY8HHfUh5PBXS67mf7nrtw6VA46BSQEBLbTpAzLxwmOvNL6kbyTeSqazr7Zp
         puN5igbMYoUQ5bb94SxHxfdmxBWPXKJVTX0mbVvAEOqG9Q2IgyOzn5zPGM9pqNWDZfVu
         WSvQ==
X-Gm-Message-State: ACgBeo1OjI3Z3pHk7MUxXNks3GUQYAvlj0ZdN6ulVkwXamRgf3xzMMwV
        hb6KmheHu88Tq9LRX9ZsQ9Smdmy6KHYi7+JMOEY=
X-Google-Smtp-Source: AA6agR5PeUlpamSOI/dBt37J84Sd28rZQgGA1JKZHmvaJaCcv94r+mo7ciB+NcGP9HAbe2TGFh51is5A8ShkACGEQiQ=
X-Received: by 2002:a17:902:e805:b0:16f:4a25:b5bd with SMTP id
 u5-20020a170902e80500b0016f4a25b5bdmr7413389plg.85.1660377162860; Sat, 13 Aug
 2022 00:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-OoxwQ3fO3brKw0MSNcQtW5Ynr8LUJoANU_TFeOAQkP1RAA@mail.gmail.com>
 <CAKH8qBuiGU91htP5C4N_zCeRVSF9cgPFy7gh55YMA29sbtJHhw@mail.gmail.com>
In-Reply-To: <CAKH8qBuiGU91htP5C4N_zCeRVSF9cgPFy7gh55YMA29sbtJHhw@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 13 Aug 2022 00:52:30 -0700
Message-ID: <CAHo-Oox-rA7qHH+b0EB1U0==eWHSzSt_Z2+OrupOCOHyRu337w@mail.gmail.com>
Subject: Re: Query on reads being flagged as direct writes...
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Lina Wang <lina.wang@mediatek.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I haven't tried figuring it out yet (via printks)... as I can't
currently trigger this myself, so I'm basically stuck with code
spelunking.
(I do know we currently legitimately do at least one dpa write... and
converting that one line to use bpf_skb_store_bytes results in the
program not even loading...
https://android-review.googlesource.com/c/platform/packages/modules/Connect=
ivity/+/2181376
- but I haven't yet had the opportunity to figure out what, likely
obvious, mistake I made)

We do make use of at least the following helpers:

bpf_map_lookup_elem
bpf_map_update_elem

which AFAICT are all marked as pkt_access =3D=3D true, even though we
don't use them to read nor write to the packet.

Having said that, and having dug deeper into the code I think only
may_access_direct_pkt_data(env, meta, BPF_READ) is the problematic
call site, and AFAICT it always has meta !=3D NULL since it is called
via check_func_arg(env, i, &meta, fn).
So maybe this does just work? even if it is super confusing... and
should probably be documented better.

ie. right now we have two callers of may_access_direct_pkt_data():
  may_access_direct_pkt_data(env, NULL, BPF_WRITE)
  may_access_direct_pkt_data(env, non-NULL, BPF_READ)
so meta !=3D NULL implies t =3D=3D BPF_WRITE, and using fallthrough would b=
e
a no-op (with current callers)

Maybe this is just a single function that does two very different
things in the two call sites...

On Fri, Aug 12, 2022 at 9:58 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Aug 12, 2022 at 5:06 AM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > From kernel/bpf/verifier.c with some simplifications (removed some of
> > the cases to make this shorter):
> >
> > static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
> > const struct bpf_call_arg_meta *meta, enum bpf_access_type t)
> > {
> >   enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
> >   switch (prog_type) {
> >     /* Program types only with direct read access go here! */
> >     case BPF_PROG_TYPE_CGROUP_SKB: (and some others)
> >       if (t =3D=3D BPF_WRITE) return false;
> >       fallthrough;
> >     /* Program types with direct read + write access go here! */
> >     case BPF_PROG_TYPE_SCHED_CLS: (and some others)
> >       if (meta) return meta->pkt_access;
> >       env->seen_direct_write =3D true;
> >       return true;
> >     case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >       if (t =3D=3D BPF_WRITE) env->seen_direct_write =3D true;
> >       return true;
> >   }
> > }
> >
> > why does the above set env->seen_direct_write to true even when t !=3D
> > BPF_WRITE, even for programs that only allow (per the comment) direct
> > read access.
> >
> > Is this working correctly?  Is there some gotcha this is papering over?
> >
> > Should 'env->seen_direct_write =3D true; return true;' be changed into
> > 'fallthrough' so that write is only set if t =3D=3D BPF_WRITE?
> >
> > This matters because 'env->seen_direct_write =3D true' then triggers an
> > unconditional unclone in the bpf prologue, which I'd like to avoid
> > unless I actually need to modify the packet (with
> > bpf_skb_store_bytes)...
> >
> > may_access_direct_pkt_data() has two call sites, in one it only gets
> > called with BPF_WRITE so it's ok, but the other one is in
> > check_func_arg():
> >
> > if (type_is_pkt_pointer(type) && !may_access_direct_pkt_data(env,
> > meta, BPF_READ)) { verbose(env, "helper access to the packet is not
> > allowed\n"); return -EACCES; }
> >
> > and I'm not really following what this does, but it seems like bpf
> > helper read access to the packet triggers unclone?
>
> There seems to be a set of helpers (pkt_access=3Dtrue) which accept
> direct packet pointers and are known to be doing only reads of the skb
> data (safe without clone).
> You seem to be hitting the case where you're passing that packet
> pointer to one of the "unsafe" (pkt_acces=3Dfalse) helpers which
> triggers that seen_direct_write=3Dtrue condition.
> So it seems like it's by design? Which helper are you calling? Maybe
> that one should also have pkt_access=3Dtrue?
>
> Tangential: I wish there was an explicit BPF_F_MAY_ATTEMPT_TO_CLONE
> flag that gates this auto-clone. I think at some point we also
> accidentally hit it :-(
>
> > (side note: all packets ingressing from the rndis gadget driver are
> > clones due to how it deals with usb packet deaggregation [not to be
> > mistaken with lro/tso])
> >
> > Confused...
