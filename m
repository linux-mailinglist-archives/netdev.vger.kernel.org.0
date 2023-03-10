Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21C26B5378
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjCJVyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjCJVyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:54:05 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4671F13B956;
        Fri, 10 Mar 2023 13:50:39 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id k10so26029558edk.13;
        Fri, 10 Mar 2023 13:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678484956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RoV3PGMyV6NfLVhZbTRmImIRKH3YuVH2//UBu/EBkeo=;
        b=W9R1mfWb0/925s+VFRjlti8HVHv1zwtbU/bIDxjxLDk2LqStCvhUqVJ8LRxY3jbER7
         Cqxyu/czJC5731sdFb+BihnAZam6dTIiho8ITsbxCXrJZ+/YKjjK+/c+onLHXVZNaPZr
         jAy0JBhBZ4Kl/u8uBuleOiClq1xZRrIOsCiGC9Fi/xEEigVFcLv88x8Qt2jiFVGjfnDO
         hB8225x88+QIn2djeCAixK81Dz3nY4u5znfyHNhvXo6z+TIGMtD38CtGHtGrSt/C2Ruc
         ms0WsdvTj8sf9lfxr0eVtdBpF/ykoKneHMPdAR95ZW4bCsTTHcYeJNFnQQ/LANws6qnR
         P5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RoV3PGMyV6NfLVhZbTRmImIRKH3YuVH2//UBu/EBkeo=;
        b=PC0axxorOYnOIo+mCKEXt8u7s1l4CLVKXt9P8W3hD9WvfH4iiEMjCtfjIioGTMgf2q
         crCNemDTNhppAK86gxjEa4p7h2KRqHidHF7XCP9mw+FDyO9Z+0mkFdkYfZVI+htghlQQ
         jECpHO5LrbnPzSPE/0F9WNjNA4hOZOV+a1vPWEUaK7oKJVS+tS0Ebdp8fIoNExnCpe3d
         rsn0wbbEI7I/mdlnbbVckmNIILTYxSKxoGVeOgMkWncMTu+sNvjlHvf22j+aMwFIRDJh
         lqPrsXVmYPTwX1IafOYa5meaYnj9LXRKG/X9vdSIflHQrbFwXxd7fd0fUg0NIOXb4Hc5
         TwXQ==
X-Gm-Message-State: AO0yUKXt3jkCzzydQvgH8czjnlcX+2xia1NLmB4estM/ah6FeGI8wIiw
        Zf9CzG/BygTA536TM6ii1OUxwcGk6uhpV7ZOFwwFwb3F8Xo=
X-Google-Smtp-Source: AK7set/r+8y4v2aT9Vo81gFbH3ZZE/p1ZeEFHpm/ivOsz150OD8iU1bcoIsYDvWGYh1gKqeSRitdVyoPbAWIV9Dzd88=
X-Received: by 2002:a17:906:5910:b0:8b1:78b8:4207 with SMTP id
 h16-20020a170906591000b008b178b84207mr14168104ejq.3.1678484956094; Fri, 10
 Mar 2023 13:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com> <20230310213839.zsiz7sky7q3zmjcp@apollo>
In-Reply-To: <20230310213839.zsiz7sky7q3zmjcp@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Mar 2023 13:49:04 -0800
Message-ID: <CAADnVQJXwDLNsJ9GW4cZM44=gCsqm_tVkQ+eyaH_vpehNyVzcw@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 1:38=E2=80=AFPM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Mar 10, 2023 at 10:15:41PM CET, Alexei Starovoitov wrote:
> > On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > > >
> > > > > > I agree this is simpler, but I'm not sure it will work properly=
. Verifier won't
> > > > > > know when the lifetime of the buffer ends, so if we disallow sp=
ills until its
> > > > > > written over it's going to be a pain for users.
> > > > > >
> > > > > > Something like:
> > > > > >
> > > > > > for (...) {
> > > > > >         char buf[64];
> > > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > > >         ...
> > > > > > }
> > > > > >
> > > > > > .. and then compiler decides to spill something where buf was l=
ocated on stack
> > > > > > outside the for loop. The verifier can't know when buf goes out=
 of scope to
> > > > > > unpoison the slots.
> > > > >
> > > > > You're saying the "verifier doesn't know when buf ...".
> > > > > The same applies to the compiler. It has no visibility
> > > > > into what bpf_dynptr_slice_rdwr is doing.
> > > >
> > > > That is true, it can't assume anything about the side effects. But =
I am talking
> > > > about the point in the program when the buffer object no longer liv=
es. Use of
> > > > the escaped pointer to such an object any longer is UB. The compile=
r is well
> > > > within its rights to reuse its stack storage at that point, includi=
ng for
> > > > spilling registers. Which is why "outside the for loop" in my earli=
er reply.
> > > >
> > > > > So it never spills into a declared C array
> > > > > as I tried to explain in the previous reply.
> > > > > Spill/fill slots are always invisible to C.
> > > > > (unless of course you do pointer arithmetic asm style)
> > > >
> > > > When the declared array's lifetime ends, it can.
> > > > https://godbolt.org/z/Ez7v4xfnv
> > > >
> > > > The 2nd call to bar as part of unrolled loop happens with fp-8, the=
n it calls
> > > > baz, spills r0 to fp-8, and calls bar again with fp-8.
> >
> > Right. If user writes such program and does explicit store of spillable
> > pointer into a stack.
> > I was talking about compiler generated spill/fill and I still believe
> > that compiler will not be reusing variable's stack memory for them.
> >
>
> But that example on godbolt is about the _compiler_ doing spill into a
> variable's stack memory, once it is dead. There is no explicit store to s=
pill
> from the user happening there.

Where do you see it?
It's
p =3D baz();
and subsequent &p.
That is user requested store.
Your example has other undefined behavior.
I tweaked it like this for clarity:
https://godbolt.org/z/qhcKdeWjb
