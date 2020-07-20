Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FB32272F4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGTXfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgGTXfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:35:00 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57129C0619D2;
        Mon, 20 Jul 2020 16:35:00 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p1so9426302pls.4;
        Mon, 20 Jul 2020 16:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6KRCFmF3hLqJHYylUwePR1kcbQHWM60aVOcvJOVTpE4=;
        b=qU/P3NKsIowL7fbT5Pv7cDyBOgpVd/PhgkAK9NATeyfCkkCDy2ti4IMb0mt9L4I59H
         g9akX0+wv5efTXvt8flTx/wkn7V7e4l+GbVkmrqXB4FXQ9LMssZEGGbmxc+Na3W1n3M5
         Buj8y41j5uAUFHpKUc4BONzwcbibmHRPkz1QibcpOJQ4qLOuiQFxSFN4xqJLkx/uwLXb
         bHLP8piRRqj5ZiC9Y3vsOQVW6/U0HRl0cfiuhlkOnBHNzx6/MMRT7XZMP0sMN3yYzzxZ
         ugRLFdcWcfkzM86JQQAlCtrdFVaJ4ghsZI251NgN/Sw27QC07rfs59xYfGOjqSqoKY3A
         6cIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6KRCFmF3hLqJHYylUwePR1kcbQHWM60aVOcvJOVTpE4=;
        b=H7xZUehrJ6EtwP7CAni6qrYarOmNBFLp1r1JOyMwQ+Fgxsk75qoF8ATrarUckWJlBg
         6+DV4CLxN0yJo+lMBJ0KXF4lYE0stkHVyXfOl7ry7a4SZG2gz3OSCXA+6j3RYweLlxEE
         lPMwtraB5ExpHgRKOZ3aRsi9P+CfSyDk2+UQTUUBgKrwDFyh+C+pAlNi9ous5hrBe4OY
         OM4lt9ExoAjojMkMqTrUimHHco8BhkpjpslURaBLgIdl5XPHTIyeMWDmJUp2bHsIaDYn
         EebIcgvf/L/lMj26LmxzyYO+WH32yWkBZ2onrbZv8by/cYDZuqraQBO/070vy8rOtaKA
         tuCg==
X-Gm-Message-State: AOAM533iiLCEL+MPVKRC05MFXzIFINMh/lBi/Imn48YWI2tZ2L2s0qTC
        gBrGA+8V/+uH2TFkQV/84tyh/2xV
X-Google-Smtp-Source: ABdhPJw4B1OyLJWjpo/uxh7oNl6RZCx8B1k01hqTsd/1UWApbhMi9YOK7DI/86hfUckDSFEk8EXfkQ==
X-Received: by 2002:a17:90a:350e:: with SMTP id q14mr1710929pjb.155.1595288099657;
        Mon, 20 Jul 2020 16:34:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id nl8sm739598pjb.13.2020.07.20.16.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 16:34:58 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:34:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
 <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk>
 <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 10:02:48PM -0700, Andrii Nakryiko wrote:
> On Thu, Jul 16, 2020 at 7:06 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 16, 2020 at 12:50:05PM +0200, Toke Høiland-Jørgensen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >
> > > > On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
> > > >>
> > > >> +  if (tgt_prog_fd) {
> > > >> +          /* For now we only allow new targets for BPF_PROG_TYPE_EXT */
> > > >> +          if (prog->type != BPF_PROG_TYPE_EXT ||
> > > >> +              !btf_id) {
> > > >> +                  err = -EINVAL;
> > > >> +                  goto out_put_prog;
> > > >> +          }
> > > >> +          tgt_prog = bpf_prog_get(tgt_prog_fd);
> > > >> +          if (IS_ERR(tgt_prog)) {
> > > >> +                  err = PTR_ERR(tgt_prog);
> > > >> +                  tgt_prog = NULL;
> > > >> +                  goto out_put_prog;
> > > >> +          }
> > > >> +
> > > >> +  } else if (btf_id) {
> > > >> +          err = -EINVAL;
> > > >> +          goto out_put_prog;
> > > >> +  } else {
> > > >> +          btf_id = prog->aux->attach_btf_id;
> > > >> +          tgt_prog = prog->aux->linked_prog;
> > > >> +          if (tgt_prog)
> > > >> +                  bpf_prog_inc(tgt_prog); /* we call bpf_prog_put() on link release */
> > > >
> > > > so the first prog_load cmd will beholding the first target prog?
> > > > This is complete non starter.
> > > > You didn't mention such decision anywhere.
> > > > The first ext prog will attach to the first dispatcher xdp prog,
> > > > then that ext prog will multi attach to second dispatcher xdp prog and
> > > > the first dispatcher prog will live in the kernel forever.
> > >
> > > Huh, yeah, you're right that's no good. Missing that was a think-o on my
> > > part, sorry about that :/
> > >
> > > > That's not what we discussed back in April.
> > >
> > > No, you mentioned turning aux->linked_prog into a list. However once I
> > > started looking at it I figured it was better to actually have all this
> > > (the trampoline and ref) as part of the bpf_link structure, since
> > > logically they're related.
> > >
> > > But as you pointed out, the original reference sticks. So either that
> > > needs to be removed, or I need to go back to the 'aux->linked_progs as a
> > > list' idea. Any preference?
> >
> > Good question. Back then I was thinking about converting linked_prog into link
> > list, since standalone single linked_prog is quite odd, because attaching ext
> > prog to multiple tgt progs should have equivalent properties across all
> > attachments.
> > Back then bpf_link wasn't quite developed.
> > Now I feel moving into bpf_tracing_link is better.
> > I guess a link list of bpf_tracing_link-s from 'struct bpf_prog' might work.
> > At prog load time we can do bpf_link_init() only (without doing bpf_link_prime)
> > and keep this pre-populated bpf_link with target bpf prog and trampoline
> > in a link list accessed from 'struct bpf_prog'.
> > Then bpf_tracing_prog_attach() without extra tgt_prog_fd/btf_id would complete
> > that bpf_tracing_link by calling bpf_link_prime() and bpf_link_settle()
> > without allocating new one.
> > Something like:
> > struct bpf_tracing_link {
> >         struct bpf_link link;  /* ext prog pointer is hidding in there */
> >         enum bpf_attach_type attach_type;
> >         struct bpf_trampoline *tr;
> >         struct bpf_prog *tgt_prog; /* old aux->linked_prog */
> > };
> >
> > ext prog -> aux -> link list of above bpf_tracing_link-s
> >
> > It's a circular reference, obviously.
> > Need to think through the complications and locking.
> >
> > bpf_tracing_prog_attach() with tgt_prog_fd/btf_id will alloc new bpf_tracing_link
> > and will add it to a link list.
> >
> > Just a rough idea. I wonder what Andrii thinks.
> >
> 
> I need to spend more time reading existing and new code to see all the
> details, but I'll throw a slightly different proposal and let you guys
> shoot it down.
> 
> So, what if instead of having linked_prog (as bpf_prog *, refcnt'ed),
> at BPF_PROG_LOAD time we just record the target prog's ID. BPF
> verifier, when doing its target prog checks would attempt to get
> bpf_prog * reference; if by that time the target program is gone,
> fail, of course. If not, everything proceeds as is, at the end of
> verification target_prog is put until attach time.
> 
> Then at attach time, we either go with pre-recorded (in
> prog->aux->linked_prog_id) target prog's ID or we get a new one from
> RAW_TP_OPEN tgt_prog_fd. Either way, we bump refcnt on that target
> prog and keep it with bpf_tracing_link (so link on detach would put
> target_prog, that way it doesn't go away while EXT prog is attached).
> Then do all the compatibility checks, and if everything works out,
> bpf_tracing_link gets created, we record trampoline there, etc, etc.
> Basically, instead of having an EXT prog holding a reference to the
> target prog, only attachment (bpf_link) does that, which conceptually
> also seems to make more sense to me. For verification we store prog ID
> and don't hold target prog at all.
> 
> 
> Now, there will be a problem once you attach EXT prog to a new XDP
> root program and release a link against the original XDP root program.
> First, I hope I understand the desired sequence right, here's an
> example:
> 
> 1. load XDP root prog X
> 2. load EXT prog with target prog X
> 3. attach EXT prog to prog X
> 4. load XDP root prog Y
> 5. attach EXT prog to prog Y (Y and X should be "compatible")
> 6. detach prog X (close bpf_link)
> 
> Is that the right sequence?
> 
> If yes, then the problem with storing ID of prog X in EXT
> prog->aux->linked_prog_id is that you won't be able to re-attach to
> new prog Z, because there won't be anything to check compatibility
> against (prog X will be long time gone).
> 
> So we can do two things here:
> 
> 1. on attach, replace ext_prog->aux->linked_prog_id with the latest
> attached prog (prog Y ID from above example)
> 2. instead of recording target program FD/ID, capture BTF FD and/or
> enough BTF information for checking compatibility.
> 
> Approach 2) seems like conceptually the right thing to do (record type
> info we care about, not an **instance** of BPF program, compatible
> with that type info), but technically might be harder.

I've read your proposal couple times and still don't get what you're
trying to solve with either ID or BTF info recording.
So that target prog doesn't get refcnt-ed? What's a problem with it?
Currently it's being refcnt-d in aux->linked_prog.
What I'm proposing about is to convert aux->linked_prog into a link list
of bpf_tracing_links which will contain linked_prog inside.
Conceptually that's what bpf_link is doing. It links two progs.
EXT prog is recorded in 'struct bpf_link' and
the target prog is recorded in 'struct bpf_tracing_link'.
So from bpf_link perspective everything seems clean to me.
The link list of bpf_tracing_link-s in EXT_prog->aux is only to preserve
existing api of prog_load cmd.

As far as step 5: attach EXT prog to prog Y (Y and X should be "compatible")
The chance of failure there should be minimal. libxdp/libdispatcher will
prepare rootlet XDP prog. It should really make sure that Y and X are compatible.
This should be invisible to users.

In addition we still need bpf_link_update_hook() I was talking about in April.
The full sequence is:
first user process:
 1. load XDP root prog X
 1' root_link = attach X to eth0
 2. load EXT prog with target prog X
 3. app1_link_fd = attach EXT prog to prog X
second user process:
 4. load XDP root prog Y
 4'. find EXT prog of the first user process
 5. app2_link_fd = attach EXT prog to prog Y (Y and X should be "compatible")
 6. bpf_link_update(root_link, X, Y); // now packet flows into Y and into EXT
   // while EXT is attached in two places
 7. app1_link_fd' = FD in second process that points to the same tracing link
    as app1_link_fd in the first process.
   bpf_link_update_hook(app1_link_fd', app2_link_fd)
the last operation need to update bpf_tracing_link that is held by app1
(which is the first user process) from the second user process. It needs to
retarget (update_hook) inside bpf_tracing_link from X to Y.
Since the processes are more or less not aware of each other.
One firewall holds link_fd that connects EXT to X,
but the second firewall (via libxdp) is updaing that tracing link
to re-hook EXT into Y.
