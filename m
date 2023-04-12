Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D06DFE57
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjDLTGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDLTGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:06:13 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490E37D85;
        Wed, 12 Apr 2023 12:05:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qa44so31116591ejc.4;
        Wed, 12 Apr 2023 12:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681326351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlxAhFR7eRSZtNfcao3vMkRIxdKfidDP6poJ5y4FIY4=;
        b=QZuyQ1eiYrD8AsZbfphltNsCl0P6+Aa+p4OtWSqUtQQcimKjG39vj240zhBXdjnRjk
         lQDRowyMLQVthygpKMu9u7hV6IVhF4TRVmeOU2xgjIv1//08mHn+BxWv0Qx+EbLpo8IC
         JR6z5kTvMdkX5BNePHo1t+1ChNdWSlnpVLb49ZMFstEQmSz5b9SGO2h8B6yvfXrs8ya8
         GzcukDszBXBxQEl+7RZ4J+buAhjL87odBmJU+ekS/Tr78hwDGC5iKfe8DJH0+EtBUOXK
         GKHO0AVCOKr/0TLR5Sr8cRF+6RgnBr47/VCY4BhBE+emzwxjUorEfn0oyrL/3fkEL4Zz
         GgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681326351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlxAhFR7eRSZtNfcao3vMkRIxdKfidDP6poJ5y4FIY4=;
        b=RnwUVjp6FvsVYjkgo6aAp05bRTzNqnFMGAxM2+ixaZkJTWRnmgGZbM4vCiSOh5bSvA
         vp1sh3EOYhLJWI/2o6gkjnUn0obz24aHj0C6d34Ft81hHjaam+Mev5bgyDkeY8CK3M/W
         OnY438jW+x1sbsw1AlgrqHufNlREa6uMcCq2Xt8DPwxiN1qRGuYgzBPK1VV7TltIVCbz
         801+0UuhzshGzOJZYhXIMHwus+VD4nJbWAZA9F2V9msQqTfzINymOBZF501Xg0ZCrObG
         PmnM6i5A2hY6fxwB6VrDuYsNM710Z6diBa95no5CRJ0S35+WX2d0m4RURxsKFKI01bMk
         lzAg==
X-Gm-Message-State: AAQBX9fy0uhzRMYz3jmIIZcnce2Cxu5TvjE2QyNOz/ww2FNcIA0Hjg4q
        OdyEEuEtDpgMzDIpjzyT0EzHBgMm66Q2DoUws8w=
X-Google-Smtp-Source: AKy350Z+kfjV7/9be/Jea3dWMRF2xKFyrZrPZaOxMcabYgnxKYmdNr/QV5lN/Jy/zGFx7zhpI0vO+sbUl59OFZ41KM0=
X-Received: by 2002:a17:906:5913:b0:931:fb3c:f88d with SMTP id
 h19-20020a170906591300b00931fb3cf88dmr1871292ejq.5.1681326351105; Wed, 12 Apr
 2023 12:05:51 -0700 (PDT)
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
 <CAEf4BzaLmKr4Jc_Hmoqc=uWnpcGXJMzzZVt9nrU8pvhXOPzbmQ@mail.gmail.com> <CAJnrk1YsHa5J5b5qVZ6CuXF+2LyBVbezb09USEXrmJ-fu6UzfQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YsHa5J5b5qVZ6CuXF+2LyBVbezb09USEXrmJ-fu6UzfQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Apr 2023 12:05:39 -0700
Message-ID: <CAEf4BzZxS94KZDhX1dQk0Np=r3SJvAtX_7y9gF=pCPLVQAF8aw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 8, 2023 at 5:22=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Tue, Mar 28, 2023 at 2:43=E2=80=AFPM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Mar 27, 2023 at 12:47=E2=80=AFAM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > >
> > > On Thu, Mar 16, 2023 at 11:55=E2=80=AFAM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Mon, Mar 13, 2023 at 7:41=E2=80=AFAM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > [...]
> > > > > > > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > > > > > > poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
> > > > > > > Then as soon as first spillable reg touches that poisoned sta=
ck area
> > > > > > > we can invalidate all PTR_TO_MEM's with that dynptr_id.
> > > > > >
> > > > > > Okay, this makes sense to me. are you already currently working=
 or
> > > > > > planning to work on a fix for this Kumar, or should i take a st=
ab at
> > > > > > it?
> > > > >
> > > > > I'm not planning to do so, so go ahead. One more thing I noticed =
just now is
> > > > > that we probably need to update regsafe to perform a check_ids co=
mparison for
> > > > > dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when =
f8064ab90d66
> > > > > ("bpf: Invalidate slices on destruction of dynptrs on stack") was=
 added but
> > > > > 567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,=
TP_BUFFER}")
> > > > > added PTR_TO_MEM in the switch statement.
> > > >
> > > > I can take care of this. But I really would like to avoid these
> > > > special cases of extra dynptr_id, exactly for reasons like this
> > > > omitted check.
> > > >
> > > > What do people think about generalizing current ref_obj_id to be mo=
re
> > > > like "lifetime id" (to borrow Rust terminology a bit), which would =
be
> > > > an object (which might or might not be a tracked reference) definin=
g
> > > > the scope/lifetime of the current register (whatever it represents)=
.
> > > >
> > > > I haven't looked through code much, but I've been treating ref_obj_=
id
> > > > as that already in my thinking before, and it seems to be a better
> > > > approach than having a special-case of dynptr_id.
> > > >
> > > > Thoughts?
> > >
> > > Thanks for taking care of this (and apologies for the late reply). i
> > > think the dynptr_id field would still be needed in this case to
> > > associate a slice with a dynptr, so that when a dynptr is invalidated
> > > its slices get invalidated as well. I'm not sure we could get away
> > > with just having ref_obj_id symbolize that in the case where the
> > > underlying object is a tracked reference, because for example, it
> > > seems like a dynptr would need both a unique reference id to the
> > > object (so that if for example there are two dynptrs pointing to the
> > > same object, they will both be assignedthe same reference id so the
> > > object can't for example be freed twice) and also its own dynptr id s=
o
> > > that its slices get invalidated if the dynptr is invalidated
> >
> > Can you elaborate on specific example? Because let's say dynptr is
> > created from some refcounted object. Then that dynptr's id field will
> > be a unique "dynptr id", dynptr's ref_obj_id will point to that
> > refcounted object from which we derived dynptr itself. And then when
> > we create slices from dynptrs, then each slice gets its own unique id,
> > but records dynptr's id as slice's ref_obj_id. So we end up with this
> > hierarchy of id + ref_obj_id forming a tree.
> >
> > Or am I missing something?
> >
> > I want to take a look at simplifying this at some point, so I'll know
> > more details once I start digging into code. Right now I still fail to
> > see why we need a third ID for dynptr.
>
> My mental model is that
> * dynptr's ref_obj_id is set whenver there's a refcounted object
> (right now, only ringbuf dynptrs are refcounted), to enforce that the
> reference gets released by the time the program exits (dynptr
> ref_obj_id is set in mark_stack_slots_dynptr())
> * dynptr's dynptr id is set for all dynptrs, so that if a dynptr gets
> overwritten/invalidated, all slices for that dynptr get invalidated
> (dynptr id is set in mark_dynptr_stack_regs(), called in
> mark_stack_slots_dynptr())

yeah, I understand that's how it works today and what the semantics of
ref_obj_id is. But I'm saying that we should look at whether we can
revise ref_obj_id semantics and generalize it to be "ID of the
<object> whose lifetime we are bound to". This refcount part could be
optional (again, will know for sure when I get to writing the code).

I'll get to this in time and will validate my own preconceptions. I
don't think we should spend too much time discussing this in abstract
right now.


> * when there's a data slice, both the slice's dynptr id and ref_obj_id
> get set to the dynptr's dynptr id and ref_obj_id, so that the slice
> gets invalidated when either the dynptr is released or when the dynptr
> is overwritten (two separate cases) (the slice's dynptr id and ref obj
> id get set in check_helper_call()). The data slice also has its own
> unique id, but this is to handle the case where the data slice may be
> null.
>
> "And then when we create slices from dynptrs, then each slice gets its
> own unique id, but records dynptr's id as slice's ref_obj_id. So we
> end up with this hierarchy of id + ref_obj_id forming a tree." I don't
> think I'm following the tree part. I think it records the dynptr's id
> as slice's id (and dynptr's ref obj id as slice's ref obj id) in
> check_helper_call().
>
> "Right now I still fail to see why we need a third ID for dynptr". I
> think for dynptrs, there are two IDs:
> state->stack[spi].spilled_ptr.ref_obj_id and
> state->stack[spi].spilled_ptr.id (where ref_obj_id is used to
> invalidate slices when dynptr is released and id is used to
> invalidates slices when dynptr is overwritten), and then for dynptr
> slices there are 3 IDs: reg->id, reg->dynptr_id, reg->ref_obj_id
> (where id is used for the data slice returning NULL case, and
> ref_obj_id / dynptr_id are used when dynptrs are invalidated).
