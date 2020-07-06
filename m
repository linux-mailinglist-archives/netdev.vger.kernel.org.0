Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F582161F5
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGFXQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGFXQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:16:00 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD40C061755;
        Mon,  6 Jul 2020 16:15:59 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u12so30363595qth.12;
        Mon, 06 Jul 2020 16:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wOe0O3XAXWFs6Fu2z3KEqZYGB4zBSPOsfKkwu0dWssI=;
        b=udZOtFS3K/Mc+7vtkSwge+SGSJESBgBiEgTO5lwh8LnLbMSDecU2YndlEio6rXe7Tq
         lPaimqrdFrZQ94+QNbfVS1b50ykBacZKXRFdazvl8sgVnImh8zVh9vF+fpHYEGceU3wH
         KblNijav9I/udwdMDBObzMTJozyW3W0S4LEd7AKQn7mRWLKrcWREEuFtFGgYRphg2YHW
         6K4y9Ek+c4SAJcrlX31fdex6k5TiIshcYl3Ow+0zMnICLSzxx0bzqqLlKDOo+EfbwBUn
         cbqs/HpKYPAstCo6s2jsm2G1zXwVUOD2cPBR+CdMDBhVbKMPNfvpVu0ELhPnZYE1yWbg
         CzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wOe0O3XAXWFs6Fu2z3KEqZYGB4zBSPOsfKkwu0dWssI=;
        b=p68voomu8+8PI865oQSUzzP+keq3NCl+NXk/edQgIB42DBzDQsc7WmCun5z225NujN
         6zP/HM1owsxjCmt7KEOY9dMpmGtwrma+CoDj2bHO+NmIvVlBlLoX+OFziDrV1L1kXp2m
         srGkLjEJRx9wt3/d+nNL/FQ3GS0o7wFOWfj1eREGGFVQlKRzdw8D21YKCc9ir5blGEaK
         oH9l91//pG8ThmZW/u8McE6ca5UPB3kOE2BpwLgJNdHNMBbd4GDHbuUQPBCbRHp5F8oD
         9j72SSNTTNHKTxnB02uxJ+6qyO6bsPfFtWw9fpBpgcMA+UJNTae6QXPv2Hy7asGVwKj8
         AnfQ==
X-Gm-Message-State: AOAM532anX8/FXPq1gmUHWV04nCqvIlti9++7b3yQpZ9rVp28AZyX7wN
        qT0/hadgyHhbG8c0ji1XiI1FraxTs7lEBJAno18=
X-Google-Smtp-Source: ABdhPJyd3Q7dBqRSozKBPAz/EgPNELHjPw0MF/76hNVuHIUpF1yFSKbo9d/J41v6kb+Yc+hLytBE/LXNw4yACBGWKF4=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr47663610qtk.117.1594077359041;
 Mon, 06 Jul 2020 16:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-8-jolsa@kernel.org>
 <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com> <20200702100859.GC3144378@krava>
In-Reply-To: <20200702100859.GC3144378@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:15:47 -0700
Message-ID: <CAEf4BzYR59T5_kjFRSQ4pUxzmA5i02nCt_V5YqY0dXQwMRSjtA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be
 refferenced by BTF object + offset
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 3:09 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 30, 2020 at 01:05:52PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding btf_struct_address function that takes 2 BTF objects
> > > and offset as arguments and checks whether object A is nested
> > > in object B on given offset.
> > >
> > > This function will be used when checking the helper function
> > > PTR_TO_BTF_ID arguments. If the argument has an offset value,
> > > the btf_struct_address will check if the final address is
> > > the expected BTF ID.
> > >
> > > This way we can access nested BTF objects under PTR_TO_BTF_ID
> > > pointer type and pass them to helpers, while they still point
> > > to valid kernel BTF objects.
> > >
> > > Using btf_struct_access to implement new btf_struct_address
> > > function, because it already walks down the given BTF object.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---

[...]

> >
> > Ok, I think I'm grasping this a bit more. How about we actually don't
> > have two different cases (btf_struct_access and btf_struct_address),
> > but instead make unified btf_struct_access that will return the
> > earliest field that register points to (so it sort of iterates deeper
> > and deeper with each invocation). So e.g., let's assume we have this
> > type:
> >
> >
> > struct A {
> >   struct B {
> >     struct C {
> >       int x;
> >     } c;
> >   } b;
> >   struct D { int y; } d;
> > };
> >
> > Now consider the extreme case of a BPF helper that expects a pointer
> > to the struct C or D (so uses a custom btf_id check function to say if
> > a passed argument is acceptable or not), ok?
> >
> > Now you write BPF program as such, r1 has pointer to struct A,
> > originally (so verifier knows btf_id points to struct A):
> >
> > int prog(struct A *a) {
> >    return fancy_helper(&a->b.c);
> > }
> >
> > Now, when verifier checks fancy_helper first time, its btf_id check
> > will say "nope". But before giving up, verifier calls
> > btf_struct_access, it goes into struct A field, finds field b with
> > offset 0, it matches register's offset (always zero in this scenario),
> > sees that that field is a struct B, so returns that register now
> > points to struct B. Verifier passed that updated BTF ID to
> > fancy_helper's check, it still says no. Again, don't give up,
> > btf_struct_access again, but now register assumes it starts in struct
> > B. It finds field c of type struct C, so returns successfully. Again,
> > we are checking with fancy_helper's check_btf_id() check, now it
> > succeeds, so we keep register's BTF_ID as struct C and carry on.
> >
> > Now assume fancy_helper only accepts struct D. So once we pass struct
> > C, it rejects. Again, btf_struct_access() is called, this time find
> > field x, which is int (and thus register is SCALAR now).
> > check_btf_id() rejects it, we call btf_struct_access() again, but this
> > time we can't really go deeper into type int, so we give up at this
> > point and return error.
> >
> > Now, when register's offset is non-zero, the process is exactly the
> > same, we just need to keep locally adjusted offset, so that when we
> > find inner struct, we start with the offset within that struct, not
> > origin struct A's offset.
> >
> > It's quite verbose explanation, but hopefully you get the idea. I
> > think implementation shouldn't be too hard, we might need to extend
> > register's state to have this extra local offset to get to the start
> > of a type we believe register points to (something like inner_offset,
> > or something). Then btf_struct_access can take into account both
> > register's off and inner_off to maintain this offset to inner type.
> >
> > It should nicely work in all cases, not just partially as it is right now. WDYT?
>
> I think above should work nicely for my case, but we need
> to keep the current btf_struct_access usage, which is to
> check if we point to a pointer type and return the ID it
> points to
>
> I think it's doable with the functionality you described,
> we'll just check of the returned type is pointer and get
> the ID it points to.. which makes me think we still need
> functions like below (again bad names probably ;-) )
>
>   btf_struct_walk
>     - implements the walk through the type as you described
>       above.. returns the type we point to and we can call
>       it again to resolve the next type at the same offset
>
>   btf_struct_address
>     - calls btf_struct_walk and checks if the returned type ID
>       matches the requested BTF ID of the helper argument if not
>       and the returned type is struct, call btf_struct_walk again
>       to get the next layer and repeat..
>
>   btf_struct_access
>     - calls btf_struct_walk repeatedly until the returned type is
>       a pointer and then it returns the BTF ID it points to
>

Sure, as long as all the BTF walking is contained in one place (in
btf_struct_walk), which was my main objection on your very first
version. All the other wrapper functions can have their own extra
restrictions, but still use the same struct-walking primitive
operation. Ok, glad we figured it out :)

> thanks,
> jirka
>
