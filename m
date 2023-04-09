Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510726DBE37
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 02:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjDIAWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 20:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIAWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 20:22:17 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DAD35A0;
        Sat,  8 Apr 2023 17:22:15 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id h198so8245287ybg.12;
        Sat, 08 Apr 2023 17:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680999734; x=1683591734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vn7RL5hfNFJMMZWJ8mBy/bAjctKEAyfiFKSB98P8o08=;
        b=jPEBcjph7a2im38RuT3s8mH4dJIGT7g2DkijOE0U3OA4HLrwk65NXsPqAp53F+G3in
         oM4CqGUTc80qanBli92XXC/1w7KhsHc1AkpBIbOh01Lam7K88lQ7qKncO/HeLMhdPBK+
         WjQAX/V+Se9vTFbXp9nUc+Sg5RGIpytMVsNLlK6zD4SkE+u89BQRpYY12AoBArf9P6ys
         Jea8ZaSo94I5as8gHAdOncKpPma0q2/3daDao1kn7DLMZqvlE45xAN94qhJx5hWoKeUG
         YSGiYXXImto8XBBUBWUy08O+aDFOjkhMYfwKuHR5oEIQLNORMpHExqvJ+9rfX3rA2kK9
         oXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680999734; x=1683591734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vn7RL5hfNFJMMZWJ8mBy/bAjctKEAyfiFKSB98P8o08=;
        b=ardHdixpWUthRY2TKUa+bHIY5Epfc5iwRab5Dcwjmw6LltRuUV7eUERBAY7UhKClw5
         ZoVU5TTlJvPnQArdqWqf65ujA3dx55yUVfs3p9zKOvrWCH+gZeF82NQWbiDw4nWLFhFu
         tvrPgDVJCkXnZzaBNBHySbwbi0D/eJSl46pmh6PiDtRwIim49j4RK+peTfFBPG+UEtfF
         Cxi84R2aeRXmSh1mHG+Ofcox+i5pTgASJr6Ybp+gpVT1HAgFUYCQf9q7dqtwdTGWy9Sd
         fJM1jyKStITOXBorG3YenrgL6bkkILjfUgPXKMhCNT9nSN2xeGDQZdmxe3Tnjzsk0hzj
         L9QQ==
X-Gm-Message-State: AAQBX9eXlpoCsFTudKAUbYlAXmPz9u4g+0ML9DzLILxIMPNIti4oejpn
        ciEo9DqWidl9yAyUrWRAEkqVLijS3J/D34K5Q+g=
X-Google-Smtp-Source: AKy350bqE8CDRfdX7BO2Hh+CpUGSLrmi1+Ek5WLxD5CwtyMrJdxyMX0gQoB+cOzeQf5oKSYWz6jnO04ZtwhOd5u5Hio=
X-Received: by 2002:a25:cad3:0:b0:b8c:ab9:e3f with SMTP id a202-20020a25cad3000000b00b8c0ab90e3fmr4283214ybg.10.1680999734162;
 Sat, 08 Apr 2023 17:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230306071006.73t5vtmxrsykw4zu@apollo> <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
 <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
 <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com>
 <20230313144135.5xvgdfvfknb4liwh@apollo> <CAEf4BzacF6pj7wHJ4NH3GBe4rtkaLSZUU1xahhQ37892Ds2ZmA@mail.gmail.com>
 <CAJnrk1Y=u_9sVo1QhNopRu7F7tRsmZmcNDMeiUw+QF3rtQQ2og@mail.gmail.com> <CAEf4BzaLmKr4Jc_Hmoqc=uWnpcGXJMzzZVt9nrU8pvhXOPzbmQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaLmKr4Jc_Hmoqc=uWnpcGXJMzzZVt9nrU8pvhXOPzbmQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Sat, 8 Apr 2023 17:22:03 -0700
Message-ID: <CAJnrk1YsHa5J5b5qVZ6CuXF+2LyBVbezb09USEXrmJ-fu6UzfQ@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Mar 28, 2023 at 2:43=E2=80=AFPM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Mar 27, 2023 at 12:47=E2=80=AFAM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> >
> > On Thu, Mar 16, 2023 at 11:55=E2=80=AFAM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Mar 13, 2023 at 7:41=E2=80=AFAM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > [...]
> > > > > > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > > > > > poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
> > > > > > Then as soon as first spillable reg touches that poisoned stack=
 area
> > > > > > we can invalidate all PTR_TO_MEM's with that dynptr_id.
> > > > >
> > > > > Okay, this makes sense to me. are you already currently working o=
r
> > > > > planning to work on a fix for this Kumar, or should i take a stab=
 at
> > > > > it?
> > > >
> > > > I'm not planning to do so, so go ahead. One more thing I noticed ju=
st now is
> > > > that we probably need to update regsafe to perform a check_ids comp=
arison for
> > > > dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when f8=
064ab90d66
> > > > ("bpf: Invalidate slices on destruction of dynptrs on stack") was a=
dded but
> > > > 567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP=
_BUFFER}")
> > > > added PTR_TO_MEM in the switch statement.
> > >
> > > I can take care of this. But I really would like to avoid these
> > > special cases of extra dynptr_id, exactly for reasons like this
> > > omitted check.
> > >
> > > What do people think about generalizing current ref_obj_id to be more
> > > like "lifetime id" (to borrow Rust terminology a bit), which would be
> > > an object (which might or might not be a tracked reference) defining
> > > the scope/lifetime of the current register (whatever it represents).
> > >
> > > I haven't looked through code much, but I've been treating ref_obj_id
> > > as that already in my thinking before, and it seems to be a better
> > > approach than having a special-case of dynptr_id.
> > >
> > > Thoughts?
> >
> > Thanks for taking care of this (and apologies for the late reply). i
> > think the dynptr_id field would still be needed in this case to
> > associate a slice with a dynptr, so that when a dynptr is invalidated
> > its slices get invalidated as well. I'm not sure we could get away
> > with just having ref_obj_id symbolize that in the case where the
> > underlying object is a tracked reference, because for example, it
> > seems like a dynptr would need both a unique reference id to the
> > object (so that if for example there are two dynptrs pointing to the
> > same object, they will both be assignedthe same reference id so the
> > object can't for example be freed twice) and also its own dynptr id so
> > that its slices get invalidated if the dynptr is invalidated
>
> Can you elaborate on specific example? Because let's say dynptr is
> created from some refcounted object. Then that dynptr's id field will
> be a unique "dynptr id", dynptr's ref_obj_id will point to that
> refcounted object from which we derived dynptr itself. And then when
> we create slices from dynptrs, then each slice gets its own unique id,
> but records dynptr's id as slice's ref_obj_id. So we end up with this
> hierarchy of id + ref_obj_id forming a tree.
>
> Or am I missing something?
>
> I want to take a look at simplifying this at some point, so I'll know
> more details once I start digging into code. Right now I still fail to
> see why we need a third ID for dynptr.

My mental model is that
* dynptr's ref_obj_id is set whenver there's a refcounted object
(right now, only ringbuf dynptrs are refcounted), to enforce that the
reference gets released by the time the program exits (dynptr
ref_obj_id is set in mark_stack_slots_dynptr())
* dynptr's dynptr id is set for all dynptrs, so that if a dynptr gets
overwritten/invalidated, all slices for that dynptr get invalidated
(dynptr id is set in mark_dynptr_stack_regs(), called in
mark_stack_slots_dynptr())
* when there's a data slice, both the slice's dynptr id and ref_obj_id
get set to the dynptr's dynptr id and ref_obj_id, so that the slice
gets invalidated when either the dynptr is released or when the dynptr
is overwritten (two separate cases) (the slice's dynptr id and ref obj
id get set in check_helper_call()). The data slice also has its own
unique id, but this is to handle the case where the data slice may be
null.

"And then when we create slices from dynptrs, then each slice gets its
own unique id, but records dynptr's id as slice's ref_obj_id. So we
end up with this hierarchy of id + ref_obj_id forming a tree." I don't
think I'm following the tree part. I think it records the dynptr's id
as slice's id (and dynptr's ref obj id as slice's ref obj id) in
check_helper_call().

"Right now I still fail to see why we need a third ID for dynptr". I
think for dynptrs, there are two IDs:
state->stack[spi].spilled_ptr.ref_obj_id and
state->stack[spi].spilled_ptr.id (where ref_obj_id is used to
invalidate slices when dynptr is released and id is used to
invalidates slices when dynptr is overwritten), and then for dynptr
slices there are 3 IDs: reg->id, reg->dynptr_id, reg->ref_obj_id
(where id is used for the data slice returning NULL case, and
ref_obj_id / dynptr_id are used when dynptrs are invalidated).
