Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A92256EC
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 07:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgGTFDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 01:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgGTFDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 01:03:01 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6981EC0619D2;
        Sun, 19 Jul 2020 22:03:01 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ed14so6845972qvb.2;
        Sun, 19 Jul 2020 22:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SKuWOvu4VbdqYcZbOfIacq7j20jr5pNvTCqQn6BBnfw=;
        b=t45aCkMIz9AQRLTEqr4u9fXvQ1BOQEgmouGBEfe8zqjsBaMPnImsvXT50GpMt/+uSg
         GWN9ImFF+fcUgpEvoBSqe1uON2IcG7v9wzcKqi7UwDd9kHfuBvgTQ5dQb7YVHB3110lT
         E5BJxA9rPb3jXp2F78vbUxjNEMaqN08dg5eKksQLuuT76Dy0CTDHXA1dJwdtFLWeXqmj
         3usHqojCN/48QeasYPoEQ9j7k3XG1yYU3Mt0lQd1p9F4GB1Y8o8/LahsHvzg4FVSEwSA
         4Ioj6W0e/+jQIlEotdWAbVYk5DB90tBqN0nLjHSmMcVHh8IXcEpEurb85s6d0vKah3OT
         9eFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SKuWOvu4VbdqYcZbOfIacq7j20jr5pNvTCqQn6BBnfw=;
        b=kuGVRV2bdOy09Iov20y1Dhl8Jvs3XaNByxL0GwTIGDbjhjufB+n12ngokBnSgNLiQM
         KcjOkNN6hCYIenm9UsMrGkcEOMI6eUntlngGz/CjprNW9KaS4Gj/Rqc+dWoyXNNTylcj
         lOpK62bQUgtEJyrzF+vsz/WAaMp9dw+Gnxbd+DIFNC1BmKK+DCyxLza6hUeOiDGwCXOL
         lxhm9JudY2uxcsO8yBPstxXD78m/7oXoT0U8+g451zNIduOfM/XXQMhi5qwWCIc6nzIq
         c41dtguiLzu2BpV2GSFqryR3aLSBgb4lpDcJW1RHsJqz4F4rL13i6n6dfOoHACprE7sI
         DFug==
X-Gm-Message-State: AOAM531Fe08yhCJd/PcE2jwHZRrQBrdrF9OEZkrGI9bPQJ8f6q/+niM8
        2NgX/cbRE8cb8OQOZdSuJh77sYUq7zF4GWgTsZ0=
X-Google-Smtp-Source: ABdhPJxVnahQ05XQZ/QlYqh65ItoS4QzgJdgd7CYQzgoqJY7DAzFjKyVhLW0Iu41LlZon03QJySBHMWMNB+JfvJ0F8o=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr19851180qvb.196.1595221380285;
 Sun, 19 Jul 2020 22:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk> <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk> <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 19 Jul 2020 22:02:48 -0700
Message-ID: <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 7:06 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 16, 2020 at 12:50:05PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> > >>
> > >> +  if (tgt_prog_fd) {
> > >> +          /* For now we only allow new targets for BPF_PROG_TYPE_EX=
T */
> > >> +          if (prog->type !=3D BPF_PROG_TYPE_EXT ||
> > >> +              !btf_id) {
> > >> +                  err =3D -EINVAL;
> > >> +                  goto out_put_prog;
> > >> +          }
> > >> +          tgt_prog =3D bpf_prog_get(tgt_prog_fd);
> > >> +          if (IS_ERR(tgt_prog)) {
> > >> +                  err =3D PTR_ERR(tgt_prog);
> > >> +                  tgt_prog =3D NULL;
> > >> +                  goto out_put_prog;
> > >> +          }
> > >> +
> > >> +  } else if (btf_id) {
> > >> +          err =3D -EINVAL;
> > >> +          goto out_put_prog;
> > >> +  } else {
> > >> +          btf_id =3D prog->aux->attach_btf_id;
> > >> +          tgt_prog =3D prog->aux->linked_prog;
> > >> +          if (tgt_prog)
> > >> +                  bpf_prog_inc(tgt_prog); /* we call bpf_prog_put()=
 on link release */
> > >
> > > so the first prog_load cmd will beholding the first target prog?
> > > This is complete non starter.
> > > You didn't mention such decision anywhere.
> > > The first ext prog will attach to the first dispatcher xdp prog,
> > > then that ext prog will multi attach to second dispatcher xdp prog an=
d
> > > the first dispatcher prog will live in the kernel forever.
> >
> > Huh, yeah, you're right that's no good. Missing that was a think-o on m=
y
> > part, sorry about that :/
> >
> > > That's not what we discussed back in April.
> >
> > No, you mentioned turning aux->linked_prog into a list. However once I
> > started looking at it I figured it was better to actually have all this
> > (the trampoline and ref) as part of the bpf_link structure, since
> > logically they're related.
> >
> > But as you pointed out, the original reference sticks. So either that
> > needs to be removed, or I need to go back to the 'aux->linked_progs as =
a
> > list' idea. Any preference?
>
> Good question. Back then I was thinking about converting linked_prog into=
 link
> list, since standalone single linked_prog is quite odd, because attaching=
 ext
> prog to multiple tgt progs should have equivalent properties across all
> attachments.
> Back then bpf_link wasn't quite developed.
> Now I feel moving into bpf_tracing_link is better.
> I guess a link list of bpf_tracing_link-s from 'struct bpf_prog' might wo=
rk.
> At prog load time we can do bpf_link_init() only (without doing bpf_link_=
prime)
> and keep this pre-populated bpf_link with target bpf prog and trampoline
> in a link list accessed from 'struct bpf_prog'.
> Then bpf_tracing_prog_attach() without extra tgt_prog_fd/btf_id would com=
plete
> that bpf_tracing_link by calling bpf_link_prime() and bpf_link_settle()
> without allocating new one.
> Something like:
> struct bpf_tracing_link {
>         struct bpf_link link;  /* ext prog pointer is hidding in there */
>         enum bpf_attach_type attach_type;
>         struct bpf_trampoline *tr;
>         struct bpf_prog *tgt_prog; /* old aux->linked_prog */
> };
>
> ext prog -> aux -> link list of above bpf_tracing_link-s
>
> It's a circular reference, obviously.
> Need to think through the complications and locking.
>
> bpf_tracing_prog_attach() with tgt_prog_fd/btf_id will alloc new bpf_trac=
ing_link
> and will add it to a link list.
>
> Just a rough idea. I wonder what Andrii thinks.
>

I need to spend more time reading existing and new code to see all the
details, but I'll throw a slightly different proposal and let you guys
shoot it down.

So, what if instead of having linked_prog (as bpf_prog *, refcnt'ed),
at BPF_PROG_LOAD time we just record the target prog's ID. BPF
verifier, when doing its target prog checks would attempt to get
bpf_prog * reference; if by that time the target program is gone,
fail, of course. If not, everything proceeds as is, at the end of
verification target_prog is put until attach time.

Then at attach time, we either go with pre-recorded (in
prog->aux->linked_prog_id) target prog's ID or we get a new one from
RAW_TP_OPEN tgt_prog_fd. Either way, we bump refcnt on that target
prog and keep it with bpf_tracing_link (so link on detach would put
target_prog, that way it doesn't go away while EXT prog is attached).
Then do all the compatibility checks, and if everything works out,
bpf_tracing_link gets created, we record trampoline there, etc, etc.
Basically, instead of having an EXT prog holding a reference to the
target prog, only attachment (bpf_link) does that, which conceptually
also seems to make more sense to me. For verification we store prog ID
and don't hold target prog at all.


Now, there will be a problem once you attach EXT prog to a new XDP
root program and release a link against the original XDP root program.
First, I hope I understand the desired sequence right, here's an
example:

1. load XDP root prog X
2. load EXT prog with target prog X
3. attach EXT prog to prog X
4. load XDP root prog Y
5. attach EXT prog to prog Y (Y and X should be "compatible")
6. detach prog X (close bpf_link)

Is that the right sequence?

If yes, then the problem with storing ID of prog X in EXT
prog->aux->linked_prog_id is that you won't be able to re-attach to
new prog Z, because there won't be anything to check compatibility
against (prog X will be long time gone).

So we can do two things here:

1. on attach, replace ext_prog->aux->linked_prog_id with the latest
attached prog (prog Y ID from above example)
2. instead of recording target program FD/ID, capture BTF FD and/or
enough BTF information for checking compatibility.

Approach 2) seems like conceptually the right thing to do (record type
info we care about, not an **instance** of BPF program, compatible
with that type info), but technically might be harder.


That's my thoughts without digging too deep, so sorry if I'm making
some stupid assumptions.



[...]
