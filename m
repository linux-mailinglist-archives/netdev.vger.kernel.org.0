Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5855C227733
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgGUDsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgGUDsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:48:17 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA2EC061794;
        Mon, 20 Jul 2020 20:48:17 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t7so8726789qvl.8;
        Mon, 20 Jul 2020 20:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hgpEJLmGdB1vk/4Ot80nHSgBm4YLANo8JRsnEVLIrG8=;
        b=IPgWs7QgQ8VK0/sgSKI4jJ7M7DFvndiTNB/g08dGsgF/OeuM1X61xAhVVZJUh0nszj
         KoVu9JeDKLOUe96Y/Y4OKq947KCxr6AGDVruweLFOPRrbQnXxmZIfPREFPLbflqHtLag
         3oN/ZN4bYvlLWZeZ/TwPslgtr2EgoMst3iGUgk7X68SGF2G6asi7v9DepHLrSgf2GhqH
         61UmUvgoQQeGBaHgeQIgIMWkSDyKPi2eO10V0ZxkuoVszH8rHT/ee4jNeeTLO8aoxwcn
         HyLXdXCvSWcDYtZhSlALSodqY75pwuRKx2k7Q6zYaTtv+4yLkERSyCAMghJmq6glH3s3
         e+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hgpEJLmGdB1vk/4Ot80nHSgBm4YLANo8JRsnEVLIrG8=;
        b=rSZx0jjf73CVld7xZEmSQj9smPyw8Tv/7HnNRGj/Vxf35QFtOJvHox+SAgelgwNRpj
         YdRxV5gUERhkMERQwdsQ/h6yhTObXuocwf33sJAfiILj6j/oxpJFgpwMPG2bZj9n+hvY
         uPQTE2iJgyH/mOerok6cNddCio0x+9mSfc0MHmf0f1H3ZsyO6VaQfUS6vSFKfQoHeChD
         EmMp1x5zq1bFKFZ0qsp7QzcwovJRqrtp3lLcosN4VENUfQWjJ0RIu9vBffqyAQ4MoGdj
         ij0+AEE3oN5MTkBomVF5c4uWmFU6EXFno+eVzeb71hUdH+5viWE1/iiJP4hAH0nlGF7N
         8zig==
X-Gm-Message-State: AOAM532gSj5bAfnhVQ4ZbyGwv7+K5il92Kejla5CEzzI2fOSBIOpTulT
        7GoG30KWNE/sBlv4eVJ1/dqEK46qzjIuxFXi9XQ=
X-Google-Smtp-Source: ABdhPJwrZwHYDabFsL4dMJkIsYJ444Qw/o03GMXc34eJCGVrEwzrpxXzYYnePdZzq/3nBkux0SJuRVDhrUuXPITjuY8=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr23663216qvb.228.1595303295693;
 Mon, 20 Jul 2020 20:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk> <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk> <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com> <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jul 2020 20:48:04 -0700
Message-ID: <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com>
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

On Mon, Jul 20, 2020 at 4:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Jul 19, 2020 at 10:02:48PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jul 16, 2020 at 7:06 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jul 16, 2020 at 12:50:05PM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > >
> > > > > On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke H=C3=83=C6=92=C3=
=82=C2=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> > > > >>
> > > > >> +  if (tgt_prog_fd) {
> > > > >> +          /* For now we only allow new targets for BPF_PROG_TYP=
E_EXT */
> > > > >> +          if (prog->type !=3D BPF_PROG_TYPE_EXT ||
> > > > >> +              !btf_id) {
> > > > >> +                  err =3D -EINVAL;
> > > > >> +                  goto out_put_prog;
> > > > >> +          }
> > > > >> +          tgt_prog =3D bpf_prog_get(tgt_prog_fd);
> > > > >> +          if (IS_ERR(tgt_prog)) {
> > > > >> +                  err =3D PTR_ERR(tgt_prog);
> > > > >> +                  tgt_prog =3D NULL;
> > > > >> +                  goto out_put_prog;
> > > > >> +          }
> > > > >> +
> > > > >> +  } else if (btf_id) {
> > > > >> +          err =3D -EINVAL;
> > > > >> +          goto out_put_prog;
> > > > >> +  } else {
> > > > >> +          btf_id =3D prog->aux->attach_btf_id;
> > > > >> +          tgt_prog =3D prog->aux->linked_prog;
> > > > >> +          if (tgt_prog)
> > > > >> +                  bpf_prog_inc(tgt_prog); /* we call bpf_prog_p=
ut() on link release */
> > > > >
> > > > > so the first prog_load cmd will beholding the first target prog?
> > > > > This is complete non starter.
> > > > > You didn't mention such decision anywhere.
> > > > > The first ext prog will attach to the first dispatcher xdp prog,
> > > > > then that ext prog will multi attach to second dispatcher xdp pro=
g and
> > > > > the first dispatcher prog will live in the kernel forever.
> > > >
> > > > Huh, yeah, you're right that's no good. Missing that was a think-o =
on my
> > > > part, sorry about that :/
> > > >
> > > > > That's not what we discussed back in April.
> > > >
> > > > No, you mentioned turning aux->linked_prog into a list. However onc=
e I
> > > > started looking at it I figured it was better to actually have all =
this
> > > > (the trampoline and ref) as part of the bpf_link structure, since
> > > > logically they're related.
> > > >
> > > > But as you pointed out, the original reference sticks. So either th=
at
> > > > needs to be removed, or I need to go back to the 'aux->linked_progs=
 as a
> > > > list' idea. Any preference?
> > >
> > > Good question. Back then I was thinking about converting linked_prog =
into link
> > > list, since standalone single linked_prog is quite odd, because attac=
hing ext
> > > prog to multiple tgt progs should have equivalent properties across a=
ll
> > > attachments.
> > > Back then bpf_link wasn't quite developed.
> > > Now I feel moving into bpf_tracing_link is better.
> > > I guess a link list of bpf_tracing_link-s from 'struct bpf_prog' migh=
t work.
> > > At prog load time we can do bpf_link_init() only (without doing bpf_l=
ink_prime)
> > > and keep this pre-populated bpf_link with target bpf prog and trampol=
ine
> > > in a link list accessed from 'struct bpf_prog'.
> > > Then bpf_tracing_prog_attach() without extra tgt_prog_fd/btf_id would=
 complete
> > > that bpf_tracing_link by calling bpf_link_prime() and bpf_link_settle=
()
> > > without allocating new one.
> > > Something like:
> > > struct bpf_tracing_link {
> > >         struct bpf_link link;  /* ext prog pointer is hidding in ther=
e */
> > >         enum bpf_attach_type attach_type;
> > >         struct bpf_trampoline *tr;
> > >         struct bpf_prog *tgt_prog; /* old aux->linked_prog */
> > > };
> > >
> > > ext prog -> aux -> link list of above bpf_tracing_link-s
> > >
> > > It's a circular reference, obviously.
> > > Need to think through the complications and locking.
> > >
> > > bpf_tracing_prog_attach() with tgt_prog_fd/btf_id will alloc new bpf_=
tracing_link
> > > and will add it to a link list.
> > >
> > > Just a rough idea. I wonder what Andrii thinks.
> > >
> >
> > I need to spend more time reading existing and new code to see all the
> > details, but I'll throw a slightly different proposal and let you guys
> > shoot it down.
> >
> > So, what if instead of having linked_prog (as bpf_prog *, refcnt'ed),
> > at BPF_PROG_LOAD time we just record the target prog's ID. BPF
> > verifier, when doing its target prog checks would attempt to get
> > bpf_prog * reference; if by that time the target program is gone,
> > fail, of course. If not, everything proceeds as is, at the end of
> > verification target_prog is put until attach time.
> >
> > Then at attach time, we either go with pre-recorded (in
> > prog->aux->linked_prog_id) target prog's ID or we get a new one from
> > RAW_TP_OPEN tgt_prog_fd. Either way, we bump refcnt on that target
> > prog and keep it with bpf_tracing_link (so link on detach would put
> > target_prog, that way it doesn't go away while EXT prog is attached).
> > Then do all the compatibility checks, and if everything works out,
> > bpf_tracing_link gets created, we record trampoline there, etc, etc.
> > Basically, instead of having an EXT prog holding a reference to the
> > target prog, only attachment (bpf_link) does that, which conceptually
> > also seems to make more sense to me. For verification we store prog ID
> > and don't hold target prog at all.
> >
> >
> > Now, there will be a problem once you attach EXT prog to a new XDP
> > root program and release a link against the original XDP root program.
> > First, I hope I understand the desired sequence right, here's an
> > example:
> >
> > 1. load XDP root prog X
> > 2. load EXT prog with target prog X
> > 3. attach EXT prog to prog X
> > 4. load XDP root prog Y
> > 5. attach EXT prog to prog Y (Y and X should be "compatible")
> > 6. detach prog X (close bpf_link)
> >
> > Is that the right sequence?
> >
> > If yes, then the problem with storing ID of prog X in EXT
> > prog->aux->linked_prog_id is that you won't be able to re-attach to
> > new prog Z, because there won't be anything to check compatibility
> > against (prog X will be long time gone).
> >
> > So we can do two things here:
> >
> > 1. on attach, replace ext_prog->aux->linked_prog_id with the latest
> > attached prog (prog Y ID from above example)
> > 2. instead of recording target program FD/ID, capture BTF FD and/or
> > enough BTF information for checking compatibility.
> >
> > Approach 2) seems like conceptually the right thing to do (record type
> > info we care about, not an **instance** of BPF program, compatible
> > with that type info), but technically might be harder.
>
> I've read your proposal couple times and still don't get what you're
> trying to solve with either ID or BTF info recording.
> So that target prog doesn't get refcnt-ed? What's a problem with it?
> Currently it's being refcnt-d in aux->linked_prog.
> What I'm proposing about is to convert aux->linked_prog into a link list
> of bpf_tracing_links which will contain linked_prog inside.
> Conceptually that's what bpf_link is doing. It links two progs.
> EXT prog is recorded in 'struct bpf_link' and
> the target prog is recorded in 'struct bpf_tracing_link'.
> So from bpf_link perspective everything seems clean to me.
> The link list of bpf_tracing_link-s in EXT_prog->aux is only to preserve
> existing api of prog_load cmd.

Right, I wanted to avoid taking a refcnt on aux->linked_prog during
PROG_LOAD. The reason for that was (and still is) that I don't get who
and when has to bpf_prog_put() original aux->linked_prog to allow the
prog X to be freed. I.e., after you re-attach to prog Y, how prog X is
released (assuming no active bpf_link is keeping it from being freed)?
That's my biggest confusion right now.

I also didn't like the idea of half-creating bpf_tracing_link on
PROG_LOAD and then turning it into a real link with bpf_link_settle on
attach. That sounded like a hack to me.

But now I'm also confused why we need to turn aux->linked_prog into a
list. Seems like we need it only for old-style attach that doesn't
specify tgt_prog_fd, no? Only in that case we'll use aux->linked_prog.
Otherwise we know the target prog from tgt_prog_fd. So I'll be honest
that I don't get the whole idea of maintaining a list of
bpf_tracing_links. It seems like it should be possible to make
bpf_tracing_link decoupled from any prog's aux and have their own
independent lifetime.

>
> As far as step 5: attach EXT prog to prog Y (Y and X should be "compatibl=
e")
> The chance of failure there should be minimal. libxdp/libdispatcher will
> prepare rootlet XDP prog. It should really make sure that Y and X are com=
patible.
> This should be invisible to users.

Right, of course, but the kernel needs to validate that anyways, which
is why I pointed that out. Or are you saying we should just assume
that they are valid?

>
> In addition we still need bpf_link_update_hook() I was talking about in A=
pril.
> The full sequence is:
> first user process:
>  1. load XDP root prog X
>  1' root_link =3D attach X to eth0
>  2. load EXT prog with target prog X
>  3. app1_link_fd =3D attach EXT prog to prog X
> second user process:
>  4. load XDP root prog Y
>  4'. find EXT prog of the first user process
>  5. app2_link_fd =3D attach EXT prog to prog Y (Y and X should be "compat=
ible")
>  6. bpf_link_update(root_link, X, Y); // now packet flows into Y and into=
 EXT
>    // while EXT is attached in two places
>  7. app1_link_fd' =3D FD in second process that points to the same tracin=
g link
>     as app1_link_fd in the first process.
>    bpf_link_update_hook(app1_link_fd', app2_link_fd)
> the last operation need to update bpf_tracing_link that is held by app1
> (which is the first user process) from the second user process. It needs =
to
> retarget (update_hook) inside bpf_tracing_link from X to Y.
> Since the processes are more or less not aware of each other.
> One firewall holds link_fd that connects EXT to X,
> but the second firewall (via libxdp) is updaing that tracing link
> to re-hook EXT into Y.

Yeah, should be doable given that bpf_trampoline is independently refcounte=
d.
