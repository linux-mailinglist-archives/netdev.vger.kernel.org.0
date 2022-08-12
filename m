Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69959147B
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiHLQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiHLQ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:58:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C661B0B37
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:58:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pm17so1515003pjb.3
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=+f5IVkLmxPAdSrPLVQKceLE4RrdFfUluwAfavCLUiYA=;
        b=iRXFiaSvxVxLJGkNMZUCXcVQrzqNgRMKTOk36AzJqL4oMF8DS8np6hoHZTtxgjubBK
         ffI4K2XgUD4cJQxtgQ16WPmu4DTr7IACvS34qg3Nr/Cw8rXiARLEcBmjXzbo6UZX6znj
         5kl0or76MgRndK5gYhKrcKLQlnGTTyTigBwfnuee88S+7h9nAeoMxoatfLkUWLrcEg6m
         diKxe13MNyPqp5PJljQPCuoeSHIvYzfG7NpbZOIMV8b/99lT4ZvqmoYtL0ViivdX1XeH
         rtDUyw5a0ILyDULKm949XBB70kDBBVaMkyKb7/MZrndb+bUtJ4nUDtuk96dL2WdMBw8R
         VCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=+f5IVkLmxPAdSrPLVQKceLE4RrdFfUluwAfavCLUiYA=;
        b=wrdO/s/mznAPHEJmYPzk+Sb6bl7w9N5OB5LRGwtuOmcQLF1gm65xjiWwVB5TKiuvMF
         t6NwdxQtF1MyddbXfEgblP3fSP0MWaWY6m2rVQT5uC6RwLsLEvKJcHxF/XBGKESsPnl9
         1gv2eGbE+FyD8WfMTFy/sWdDtVPR5uf8c66m+Mb+iP0jTfd3ervh2mDO0Shnb6jIxAsy
         1UyoJBclFlAXmjAUIPgGMrAhLzF3QFGFe5Uw3tjRrjIoJ38h+et8QXQE11yOQN1zvziu
         qb22DafdIBozx0WOi3MzHHqswG4BnuI+7jZz/4fpKo8YYrmyNdgyYfMLUeqQLHsDRbuG
         cxjQ==
X-Gm-Message-State: ACgBeo1RwALdhAuvSSkmpRY6uEmwHFXzwxwM7h/tOBT6b82r32S1rhO2
        jQKFBg24C3qZ/JWc1/MW/Kf8hEWR1ebvOojwndsdRw==
X-Google-Smtp-Source: AA6agR7diqR0cZ+CZSQOu/2aNeVNG57tNZqQNClOZLdvsaq2FanPGoxirsIq5hldtXiHZSc3uj9U6YMefMO3GeuqLHw=
X-Received: by 2002:a17:903:4ce:b0:171:2cbb:ba27 with SMTP id
 jm14-20020a17090304ce00b001712cbbba27mr4899862plb.72.1660323506720; Fri, 12
 Aug 2022 09:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-OoxwQ3fO3brKw0MSNcQtW5Ynr8LUJoANU_TFeOAQkP1RAA@mail.gmail.com>
In-Reply-To: <CAHo-OoxwQ3fO3brKw0MSNcQtW5Ynr8LUJoANU_TFeOAQkP1RAA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 12 Aug 2022 09:58:15 -0700
Message-ID: <CAKH8qBuiGU91htP5C4N_zCeRVSF9cgPFy7gh55YMA29sbtJHhw@mail.gmail.com>
Subject: Re: Query on reads being flagged as direct writes...
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Lina Wang <lina.wang@mediatek.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 5:06 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From kernel/bpf/verifier.c with some simplifications (removed some of
> the cases to make this shorter):
>
> static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
> const struct bpf_call_arg_meta *meta, enum bpf_access_type t)
> {
>   enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
>   switch (prog_type) {
>     /* Program types only with direct read access go here! */
>     case BPF_PROG_TYPE_CGROUP_SKB: (and some others)
>       if (t =3D=3D BPF_WRITE) return false;
>       fallthrough;
>     /* Program types with direct read + write access go here! */
>     case BPF_PROG_TYPE_SCHED_CLS: (and some others)
>       if (meta) return meta->pkt_access;
>       env->seen_direct_write =3D true;
>       return true;
>     case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>       if (t =3D=3D BPF_WRITE) env->seen_direct_write =3D true;
>       return true;
>   }
> }
>
> why does the above set env->seen_direct_write to true even when t !=3D
> BPF_WRITE, even for programs that only allow (per the comment) direct
> read access.
>
> Is this working correctly?  Is there some gotcha this is papering over?
>
> Should 'env->seen_direct_write =3D true; return true;' be changed into
> 'fallthrough' so that write is only set if t =3D=3D BPF_WRITE?
>
> This matters because 'env->seen_direct_write =3D true' then triggers an
> unconditional unclone in the bpf prologue, which I'd like to avoid
> unless I actually need to modify the packet (with
> bpf_skb_store_bytes)...
>
> may_access_direct_pkt_data() has two call sites, in one it only gets
> called with BPF_WRITE so it's ok, but the other one is in
> check_func_arg():
>
> if (type_is_pkt_pointer(type) && !may_access_direct_pkt_data(env,
> meta, BPF_READ)) { verbose(env, "helper access to the packet is not
> allowed\n"); return -EACCES; }
>
> and I'm not really following what this does, but it seems like bpf
> helper read access to the packet triggers unclone?

There seems to be a set of helpers (pkt_access=3Dtrue) which accept
direct packet pointers and are known to be doing only reads of the skb
data (safe without clone).
You seem to be hitting the case where you're passing that packet
pointer to one of the "unsafe" (pkt_acces=3Dfalse) helpers which
triggers that seen_direct_write=3Dtrue condition.
So it seems like it's by design? Which helper are you calling? Maybe
that one should also have pkt_access=3Dtrue?

Tangential: I wish there was an explicit BPF_F_MAY_ATTEMPT_TO_CLONE
flag that gates this auto-clone. I think at some point we also
accidentally hit it :-(

> (side note: all packets ingressing from the rndis gadget driver are
> clones due to how it deals with usb packet deaggregation [not to be
> mistaken with lro/tso])
>
> Confused...
