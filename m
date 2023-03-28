Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD76CCC3C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjC1VnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjC1VnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:43:15 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE52D68;
        Tue, 28 Mar 2023 14:43:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn12so55431918edb.4;
        Tue, 28 Mar 2023 14:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680039789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvPLTtKlU0vNaz9725r81EHFLKAu4AQ65dj5fg+SF9o=;
        b=PHzYOgN3kiUberFUFRdpHlY1IeaKO2su/u4MjPlENAtPs1jUgI9VRf8otOVAos+JcL
         U/FDVRJbNVs8TslMAMqO9wdBebDufzTpB5j60GkblJyBQaoEOi3Ze9eWuIT7bZxcLl2Q
         21G10Z793p2Nc7DYKBDuugDswH94Be+y0UNE1o01YawDMpf5VX7m3Ni3jOwKPsLsU/vY
         lpm6XDmbaWDhkda3EldQLNUx+ie3pjhSmvQeAxw1uuJM8kMDQzfWv9QFXG7IpnOBukVE
         WZcAPWZuRt5JD4ronusHFxNw1xLZOoI8NFyDz2UtWkxk/SBQ0Bgw7e/T42x60fEh1BLW
         ARAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680039789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvPLTtKlU0vNaz9725r81EHFLKAu4AQ65dj5fg+SF9o=;
        b=f6jYh0RqQWchPPjmbCUAP944sEymPP7QbhCwqxMkvWxwbNs8lmpncf74zrg8s9Uspt
         pZYNNnpRs/JS9auVJ39wd1uX4DCl1NE4toO8qR0Fmy5zp6LrYtqISD88GeM8bUKgmoL5
         9LOGaowMEaGDKLOFuNASsGxMT6UfOi5UyH88DHqjxXdfKaYB7qk7Jh2jrte3BNcjIt4S
         HkEB6beY5ZwK2qifWdBXu2OlcrOvsYzmTW+LLYQNxLKp2wdX7i2r/hKIQB2pED9t84++
         wXJDzqcQlZyKgR/k540jjYwsexJHyIxWXfrDMps6T0tovW7RVGg9Vno1+A8994QYAPFV
         nXjA==
X-Gm-Message-State: AAQBX9fmpl1Rzy3THEd3yg4N5Bm91CgQSpOoBNnj673s/sik5BVznrFg
        hEpYzj6kpZkpK/ibx24sT/8qY97tfePFcR+eT7c=
X-Google-Smtp-Source: AKy350aySh1k6SU2Zakrc+HUzPRxbOk4VjgCQEdQFoUpBC1PHkeludEjEA0Yeiy88DUuJzO1DQIycIJ2jhyLZppxeg0=
X-Received: by 2002:a50:d6c3:0:b0:501:d489:f797 with SMTP id
 l3-20020a50d6c3000000b00501d489f797mr8806073edj.1.1680039789534; Tue, 28 Mar
 2023 14:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230306071006.73t5vtmxrsykw4zu@apollo> <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
 <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
 <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com>
 <20230313144135.5xvgdfvfknb4liwh@apollo> <CAEf4BzacF6pj7wHJ4NH3GBe4rtkaLSZUU1xahhQ37892Ds2ZmA@mail.gmail.com>
 <CAJnrk1Y=u_9sVo1QhNopRu7F7tRsmZmcNDMeiUw+QF3rtQQ2og@mail.gmail.com>
In-Reply-To: <CAJnrk1Y=u_9sVo1QhNopRu7F7tRsmZmcNDMeiUw+QF3rtQQ2og@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Mar 2023 14:42:57 -0700
Message-ID: <CAEf4BzaLmKr4Jc_Hmoqc=uWnpcGXJMzzZVt9nrU8pvhXOPzbmQ@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 12:47=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Thu, Mar 16, 2023 at 11:55=E2=80=AFAM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Mar 13, 2023 at 7:41=E2=80=AFAM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> [...]
> > > > > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > > > > poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
> > > > > Then as soon as first spillable reg touches that poisoned stack a=
rea
> > > > > we can invalidate all PTR_TO_MEM's with that dynptr_id.
> > > >
> > > > Okay, this makes sense to me. are you already currently working or
> > > > planning to work on a fix for this Kumar, or should i take a stab a=
t
> > > > it?
> > >
> > > I'm not planning to do so, so go ahead. One more thing I noticed just=
 now is
> > > that we probably need to update regsafe to perform a check_ids compar=
ison for
> > > dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when f806=
4ab90d66
> > > ("bpf: Invalidate slices on destruction of dynptrs on stack") was add=
ed but
> > > 567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_B=
UFFER}")
> > > added PTR_TO_MEM in the switch statement.
> >
> > I can take care of this. But I really would like to avoid these
> > special cases of extra dynptr_id, exactly for reasons like this
> > omitted check.
> >
> > What do people think about generalizing current ref_obj_id to be more
> > like "lifetime id" (to borrow Rust terminology a bit), which would be
> > an object (which might or might not be a tracked reference) defining
> > the scope/lifetime of the current register (whatever it represents).
> >
> > I haven't looked through code much, but I've been treating ref_obj_id
> > as that already in my thinking before, and it seems to be a better
> > approach than having a special-case of dynptr_id.
> >
> > Thoughts?
>
> Thanks for taking care of this (and apologies for the late reply). i
> think the dynptr_id field would still be needed in this case to
> associate a slice with a dynptr, so that when a dynptr is invalidated
> its slices get invalidated as well. I'm not sure we could get away
> with just having ref_obj_id symbolize that in the case where the
> underlying object is a tracked reference, because for example, it
> seems like a dynptr would need both a unique reference id to the
> object (so that if for example there are two dynptrs pointing to the
> same object, they will both be assignedthe same reference id so the
> object can't for example be freed twice) and also its own dynptr id so
> that its slices get invalidated if the dynptr is invalidated

Can you elaborate on specific example? Because let's say dynptr is
created from some refcounted object. Then that dynptr's id field will
be a unique "dynptr id", dynptr's ref_obj_id will point to that
refcounted object from which we derived dynptr itself. And then when
we create slices from dynptrs, then each slice gets its own unique id,
but records dynptr's id as slice's ref_obj_id. So we end up with this
hierarchy of id + ref_obj_id forming a tree.

Or am I missing something?

I want to take a look at simplifying this at some point, so I'll know
more details once I start digging into code. Right now I still fail to
see why we need a third ID for dynptr.
