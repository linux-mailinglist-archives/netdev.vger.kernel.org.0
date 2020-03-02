Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5313F175629
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCBImy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:42:54 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39164 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBImy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:42:54 -0500
Received: by mail-qk1-f195.google.com with SMTP id e16so9246878qkl.6
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 00:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r8aSF5MeqDQUW8YKb8YbsbsupScDDHgnONeFSMF1J5M=;
        b=B/KNoxaQBGiH3PD1NpEzCo1O0oK4E7EK+1S3evPRu02hz84J4NBnPjObI8b1gKqd4p
         c1hs9hOlTU4U3f1nxTLhByHL1nWKv73jKdbN6fOKC1q6atwvoOAxFgV1YWZJm0VoENj0
         z7VBgyGWyTbTRoSkSpLOAe0ZBovE60dzdlycqAbec+ttpuz4989oFrgKBUsRyN7N5ucu
         Bz3PiXGf1+EXZHg+suW1UR8i5GirjuSp2OlsCh54mr8OnXEu5Cmdwb/4NTHwZc7RJ6r+
         oz9RH21mh4B5udlNT2u1CHarVJgtk7XeMmXpmn1yaF8OMCT+6+vdHLMAuBtDs7o6vO0+
         tVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r8aSF5MeqDQUW8YKb8YbsbsupScDDHgnONeFSMF1J5M=;
        b=J6RNO1G57O+s4h9k1PS7GAfK+PRANBMiZRhUBuUi70NDeCHTPzCBNxWrTs7oghFJn3
         GqIyD6yu4HX79k6/nLZ7zGUetkgLxhzrrJlXKmf5+XE+Ir2H3LHfT53Umh64RtK1+FbV
         EoyTxGLiqZn7ICzznpIImK2rrkpTYv0L4JjzPU7BDHOFfkwbZN5kHwiXkAXeqdLMnmJp
         9XekqVn6024l0tnKMS2Bu8u29pJSTJ1vvPGs4LmVkSZiJZttdvmzGRxiyNeUp8vnAHEq
         wcnhdjUwyY38kUYjMLfWOh4XTgWud4DQmnkwi6K7VqItoERp5YloMucV1D+HZBr+K52I
         Wy/g==
X-Gm-Message-State: APjAAAWEGq4o9iAi4VJQIcO52h7yROOPEIOsrGFPhzij96Ey1fHj2pPh
        mvjdecPzsQP+5msKsweztj/Yq25yhSa1LUiYorB3Ow==
X-Google-Smtp-Source: APXvYqztcu29n10/zsKgII0AqR3Fc9rw71b3zIoTvJYDp6H3lPYF0NTShZJmpjhfeX5F1NoW+jLeFauy7Qb3dxiFWO0=
X-Received: by 2002:ae9:e003:: with SMTP id m3mr15639507qkk.250.1583138573164;
 Mon, 02 Mar 2020 00:42:53 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003cbb40059f4e0346@google.com> <CAHC9VhQVXk5ucd3=7OC=BxEkZGGLfXv9bESX67Mr-TRmTwxjEg@mail.gmail.com>
 <17916d0509978e14d9a5e9eb52d760fa57460542.camel@redhat.com>
 <CAHC9VhQnbdJprbdTa_XcgUJaiwhzbnGMWJqHczU54UMk0AFCtw@mail.gmail.com>
 <CACT4Y+azQXLcPqtJG9zbj8hxqw4jE3dcwUj5T06bdL3uMaZk+Q@mail.gmail.com> <CAHC9VhRRDJzyene2_40nhnxRV_ufgyaU=RrFxYGsnxR4Z_AWWw@mail.gmail.com>
In-Reply-To: <CAHC9VhRRDJzyene2_40nhnxRV_ufgyaU=RrFxYGsnxR4Z_AWWw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 2 Mar 2020 09:42:41 +0100
Message-ID: <CACT4Y+YkJSLt+-0_wvSHfxi8J1Tn=H-NBeZ+E3h-TAKu53vyqw@mail.gmail.com>
Subject: Re: kernel panic: audit: backlog limit exceeded
To:     Paul Moore <paul@paul-moore.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Paris <eparis@redhat.com>,
        syzbot <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Miller <davem@davemloft.net>, fzago@cray.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        john.hammond@intel.com, linux-audit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 1:14 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Thu, Feb 27, 2020 at 10:40 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > On Mon, Feb 24, 2020 at 11:47 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Mon, Feb 24, 2020 at 5:43 PM Eric Paris <eparis@redhat.com> wrote:
> > > > https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000 (the
> > > > reproducer listed) looks like it is literally fuzzing the AUDIT_SET.
> > > > Which seems like this is working as designed if it is setting the
> > > > failure mode to 2.
> > >
> > > So it is, good catch :)  I saw the panic and instinctively chalked
> > > that up to a mistaken config, not expecting that it was what was being
> > > tested.
> >
> > Yes, this audit failure mode is quite unpleasant for fuzzing. And
> > since this is not a top-level syscall argument value, it's effectively
> > impossible to filter out in the fuzzer. Maybe another use case for the
> > "fuzer lockdown" feature +Tetsuo proposed.
> > With the current state of the things, I think we only have an option
> > to disable fuzzing of audit. Which is pity because it has found 5 or
> > so real bugs in audit too.
> > But this happened anyway because audit is only reachable from init pid
> > namespace and syzkaller always unshares pid namespace for sandboxing
> > reasons, that was removed accidentally and that's how it managed to
> > find the bugs. But the unshare is restored now:
> > https://github.com/google/syzkaller/commit/5e0e1d1450d7c3497338082fc28912fdd7f93a3c
> >
> > As a side effect all other real bugs in audit will be auto-obsoleted
> > in future if not fixed because they will stop happening.
>
> On the plus side, I did submit fixes for the other real audit bugs
> that syzbot found recently and Linus pulled them into the tree today
> so at least we have that small victory.

+1!

> We could consider adding a fuzz-friendly build time config which would
> disable the panic failsafe, but it probably isn't worth it at the
> moment considering the syzbot's pid namespace limitations.
>
> --
> paul moore
> www.paul-moore.com
