Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7BB46D12
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfFOACv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:02:51 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40469 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFOACu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:02:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id a9so2822614lff.7;
        Fri, 14 Jun 2019 17:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsY6YLZQisEzKpYTeNLm01WC17BqF5LKGI3d/XbnNP0=;
        b=UR1QnVhGiR8PpSdixLr1ZY2LlolPMrTaeg0etSU230cB0RlUJSxRENatRyVNrlXoBU
         xpTlp7mGCaTHqHtmyblx+SJ745lARNI96hCRc6jo/9CKU1GxujPlTAbPQ8Cp2nUinl/3
         PHBI/6QBvGfXmbmdiaeb05+EJkgt3ob5m5nB1RE4JQXGTBVgFVWt9a3VN5GuuC5BK3sy
         qwlCs2sGIDKYSlenqbEMICe3VQnI2DbK8Ik/swOLfG1ZskAdZtpTYGvrzkn3fvUv0WBo
         71+3nZOSvogZWciMISYM9+ss4Yqfb96goglgIhNrRSdHzx4fGdYtdmo4rbAH9iSC9iI0
         kuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsY6YLZQisEzKpYTeNLm01WC17BqF5LKGI3d/XbnNP0=;
        b=OGg5s57bY3f7k2oaBqS7P4YJQqcF5pjEeiu9IqpQmwitGg2me99Cl0mmZL6QzSCfXa
         Squynm6DrZbREI8BIbXqbHbWkVFXecY0ldcHa/CCxsHo+EhSVUa8o7xML4i/4NEPE5zL
         vu+hYLDbbTkZU30mr8p0B0Ir1EERsRzCofmZ5pIf7+tjhvJu1Edt4YIcAMS1C57E9yBV
         W/W8J68h/awJDsZzka9cX47tnfWL3ovmCZgZ6II+HY1txz3IghE1YpGWuG3MsZH5bcRH
         4Zswh1e7g/prf7Vaq6gdJ6VcDNGvPyL7nkfSznhXjSe8koZ30/5VD6gIzt6As8wcSpdz
         Qd0g==
X-Gm-Message-State: APjAAAULenL12YHr0AJrEeKFujTujkg6hK3gXIs2GBAIYZ7wRojg3mtm
        NcH+bDF9wQTTLPtjJCwU36pdddxScA2mLbXkCpQ=
X-Google-Smtp-Source: APXvYqz5xMz7BB7ENjdB+9sn/VlhgT3dOKs3ovwxItexLSk5E5buLe4GKS4LW+5cbmDnWGlKS06tnqE/oKxS8EhYBxs=
X-Received: by 2002:a19:ca0e:: with SMTP id a14mr23925879lfg.19.1560556967892;
 Fri, 14 Jun 2019 17:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble> <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble> <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
 <20190614235417.7oagddee75xo7otp@treble>
In-Reply-To: <20190614235417.7oagddee75xo7otp@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 17:02:36 -0700
Message-ID: <CAADnVQ+mjtgZExhtKDu6bbaVSHUfOYb=XeJodPB5+WdjtLYvCA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:54 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 04:23:41PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 4:13 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Fri, Jun 14, 2019 at 02:27:30PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > >
> > > > > On Fri, Jun 14, 2019 at 02:05:56PM -0700, Alexei Starovoitov wrote:
> > > > > > Have you tested it ?
> > > > > > I really doubt, since in my test both CONFIG_UNWINDER_ORC and
> > > > > > CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.
> > > > >
> > > > > Hm, are you seeing selftest failures?  They seem to work for me.
> > > > >
> > > > > > Here is much simple patch that I mentioned in the email yesterday,
> > > > > > but you failed to listen instead of focusing on perceived 'code readability'.
> > > > > >
> > > > > > It makes one proper frame and both frame and orc unwinders are happy.
> > > > >
> > > > > I'm on my way out the door and I just skimmed it, but it looks fine.
> > > > >
> > > > > Some of the code and patch description look familiar, please be sure to
> > > > > give me proper credit.
> > > >
> > > > credit means something positive.
> > >
> > > So you only give credit for *good* stolen code.  I must have missed that
> > > section of the kernel patch guidelines.
> >
> > what are you talking about?
> > you've posted one bad patch. I pointed out multiple issues in it.
> > Then proposed another bad idea. I pointed out another set of issues.
> > Than David proposed yet another idea that you've implemented
> > and claimed that it's working when it was not.
> > Then I got fed up with this thread and fix it for real by reverting
> > that old commit that I mentioned way earlier.
> > https://patchwork.ozlabs.org/patch/1116307/
> > Where do you see your code or ideas being used?
> > I see none.
>
> Obviously I wasn't referring to this new whitewashed patch for which I
> wasn't even on Cc, despite being one of the people (along with Peter Z)
> who convinced you that there was a problem to begin with.

vger has a small limit on cc list. I always trim it to the minimum.

> The previous patch you posted has my patch description, push/pop and
> comment changes, with no credit:

I'm sorry for reusing one sentence from your commit log and
not realizing you want credit for that.
Will not happen again.
I also suggest you never touch anything bpf related.
Just to avoid this credit claims and threads like this one.
