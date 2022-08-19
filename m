Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7959A3FA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354456AbiHSRVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352751AbiHSRVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:21:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F4314D065;
        Fri, 19 Aug 2022 09:40:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c39so6341086edf.0;
        Fri, 19 Aug 2022 09:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Fya4fZM01wtpV6jSWWXM/JoqlH2BGCdszj83hyqTE9Q=;
        b=a/OpAIk/kN1DVTd5wBYF+F7EgMXvFSvBuTaOGIBJxkeaU8wKI4dpl3ipvq1YyIb3A9
         nrqBZAIr8x029+uxX0c19j1Bu7RPlwwbp0N+N9FYHNbYVjaULrG/wI91keaVSZs8dLeP
         UZJJBqZRaTln9uAFaklc0MmXBdPK254cAHipMS9AzpffDHST92WPwjkXWoV3t9GaHVhz
         U/U9RBBOJu+dEmuba0S/fliA3OQ00hZZtvsMWKreQ/WjRjjWBxJFWND5CvsmxkazTBdo
         oYg8NWCpRNn8Pe3SebfAYINWGdfJ66+PexCUqNYQl99Zk44ZdjhTgAalyi5mviVVcZ4H
         +Gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Fya4fZM01wtpV6jSWWXM/JoqlH2BGCdszj83hyqTE9Q=;
        b=Uh3HyiW7BAU/wRVGlAYNEsGOxdAisHoSV3tSgthCPq2gp00tqzNMtffgzxC/UYI2FN
         Ws5Z2oxaIyuvcXAR3vrTvYbKBpojTRWhzENJ4vFpuDOrPJ5bSb0D6cAauQJ7k3zbH+Cf
         IeuymnOYAAzp1iGZ0FTqVGO2wW4iQ8WmRGi4MURYvLYFRTDk0KrXOYQi+Njkoh6RxcmX
         nXWm8Ger54AesXmWkCy8GVW2plH2p/oG0ETC1IAhaLdeRQI6bevUo4Po7PxMMYAwUnrx
         j+IpOhasNbQC/WVYzageMPWkn2es3hzByuqrMcBuGPFfXq1l6h4yJBMpl9aWZoVAhJMH
         +/6w==
X-Gm-Message-State: ACgBeo37iW80cHRU8oKkCvfhgfudfI0RmxS7VcDW2aS/yHe0ryzKKWUa
        BsyFHKEeKiI0u8Oa7vWzaaRGM82GaefX+5dhyH4=
X-Google-Smtp-Source: AA6agR5lfMOKEBoDzHA6/bVtt1G+RY9+YHXqTlh41y4Yzsem3FQcp824i65YTAGU77Xssxh3e5ilE2fVkRoq6psxDq8=
X-Received: by 2002:a05:6402:298c:b0:446:a97:1800 with SMTP id
 eq12-20020a056402298c00b004460a971800mr6829163edb.421.1660927211176; Fri, 19
 Aug 2022 09:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <87pmgxuy6v.fsf@toke.dk> <20220818221032.7b4lcpa7i4gchdvl@kashmir.localdomain>
 <87wnb4tmc0.fsf@toke.dk>
In-Reply-To: <87wnb4tmc0.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Aug 2022 09:39:59 -0700
Message-ID: <CAADnVQ+YtLQPa3fifFn5vazydP1fZtE2RmjOBY4F5tF2t8MmSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to nf_conn:mark
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Fri, Aug 19, 2022 at 6:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kern=
el.org> wrote:
>
> Daniel Xu <dxu@dxuuu.xyz> writes:
>
> > Hi Toke,
> >
> > On Thu, Aug 18, 2022 at 09:52:08PM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >> Daniel Xu <dxu@dxuuu.xyz> writes:
> >>
> >> > Support direct writes to nf_conn:mark from TC and XDP prog types. Th=
is
> >> > is useful when applications want to store per-connection metadata. T=
his
> >> > is also particularly useful for applications that run both bpf and
> >> > iptables/nftables because the latter can trivially access this
> >> > metadata.
> >>
> >> Looking closer at the nf_conn definition, the mark field (and possibly
> >> secmark) seems to be the only field that is likely to be feasible to
> >> support direct writes to, as everything else either requires special
> >> handling (like status and timeout), or they are composite field that
> >> will require helpers anyway to use correctly.
> >>
> >> Which means we're in the process of creating an API where users have t=
o
> >> call helpers to fill in all fields *except* this one field that happen=
s
> >> to be directly writable. That seems like a really confusing and
> >> inconsistent API, so IMO it strengthens the case for just making a
> >> helper for this field as well, even though it adds a bit of overhead
> >> (and then solving the overhead issue in a more generic way such as by
> >> supporting clever inlining).
> >>
> >> -Toke
> >
> > I don't particularly have a strong opinion here. But to play devil's
> > advocate:
> >
> > * It may be confusing now, but over time I expect to see more direct
> >   write support via BTF, especially b/c there is support for unstable
> >   helpers now. So perhaps in the future it will seem more sensible.
>
> Right, sure, for other structs. My point was that it doesn't look like
> this particular one (nf_conn) is likely to grow any other members we can
> access directly, so it'll be a weird one-off for that single field...
>
> > * The unstable helpers do not have external documentation. Nor should
> >   they in my opinion as their unstableness + stale docs may lead to
> >   undesirable outcomes. So users of the unstable API already have to
> >   splunk through kernel code and/or selftests to figure out how to wiel=
d
> >   the APIs. All this to say there may not be an argument for
> >   discoverability.
>
> This I don't buy at all. Just because it's (supposedly) "unstable" is no

They're unstable. Please don't start this 'but can we actually remove
them' doubts. You're only confusing yourself and others.
We tweaked kfuncs already. We removed tracepoints too after they
were in a full kernel release.

> excuse to design a bad API, or make it actively user-hostile by hiding

'bad API'? what? It's a direct field write.
We do allow it in other data structures.

> things so users have to go browse kernel code to know how to use it. So
> in any case, we should definitely document everything.
>
> > * Direct writes are slightly more ergnomic than using a helper.
>
> This is true, and that's the main argument for doing it this way. The
> point of my previous email was that since it's only a single field,
> consistency weighs heavier than ergonomics :)

I don't think the 'consistency' argument applies here.
We already allow direct read of all fields.
Also the field access is easier to handle with CO-RE.
