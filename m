Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31EB462D4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFNPcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:32:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44318 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNPcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:32:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id k18so2801171ljc.11;
        Fri, 14 Jun 2019 08:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GcqXQfqn90yOgwxpieyhK7oJ0+aumlHQ0634Nn5J4Kw=;
        b=atDCfPz3yHekwYhj4lxblgLO9VqoIo8enhnrXl5IOQjptNffqOHulgaokeINr9ij6A
         zeXQ0m1S0Ioopw66Vw1JSh/45sSBGILm0jbXuDvjf7MwZdPWA5fvv2rA3XFacLDgQhJ2
         C3xadlyjmRIFt688FtHLKr8TzOxs+nGQbZe992YqytLyIBoHzCD6lLvrmW+jnTPFh8NP
         HtDjHwtkq+P8oxkppl24onW5QZujZX8sSh+5d/IFQdXlznax5Oj3V+e9+vXlxJ5v7jC2
         NfZz6zTKubVwwRDLy87Ek/7rjWx+womQPUGpLw4jRPikrr6wtrR1ui0+q3KYCXLw49Lf
         uAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GcqXQfqn90yOgwxpieyhK7oJ0+aumlHQ0634Nn5J4Kw=;
        b=mIACwlLq4FmNied0gM3TD/IR5XO8z/MFvh5CSwphJniQ2WGgha7bJGT/qCGdLqoaur
         F2/eO0Ybujr2ncA95TbzJthves2pidL9x6sqSBTDnBDlLgg8eCi/2NEXLrxpULnh+WkT
         cJEIV9ASxwPuJIE3EyjXfscHJvi7BSqRD7IKNRdagW2TsKGuW7Arkd9WdmnNd0yMq5N0
         q4zjbLiroKHO+OxGsRp2grY6WafJW6AswaZTFGqoaVBNe9ge6U5EzXuvp/SwvOrjqk4/
         DYC1Obj8TURMsojd0RKF/n4F4rcusyGnkg6cjkSn4gj0fwcbMwmTDdYOj01Xdy2Z0ZV8
         91Hg==
X-Gm-Message-State: APjAAAWDFJh2YESWWV4JIWUEVWRAUu9EdpYezmzyd3D1qPHHn4hGh4ZP
        oCHbWcTDlwww4Vdmnj7ZV9PTNcTYcXoJzXnmFTI=
X-Google-Smtp-Source: APXvYqy2q4R1NoVMU3Bs13d6spTKthxrJFzD1KeNaQlccuA4qR72SixDpeARjEfKwq3cVtYZmI6m5Ube96wir0uXDWo=
X-Received: by 2002:a2e:86d1:: with SMTP id n17mr28267616ljj.58.1560526325382;
 Fri, 14 Jun 2019 08:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560431531.git.jpoimboe@redhat.com> <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble> <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble> <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble> <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
 <20190614133004.gopjz64vbqmbbzqn@treble>
In-Reply-To: <20190614133004.gopjz64vbqmbbzqn@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 08:31:53 -0700
Message-ID: <CAADnVQLp+Eq3fz6u+Q3_2UxDwdn1hKESwS5O856BabJE4wfPJw@mail.gmail.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers for
 generated code
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 6:34 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:
> > > +   if (src_reg == BPF_REG_FP) {
> > > +           /*
> > > +            * If the value was copied from RBP (real frame pointer),
> > > +            * adjust it to the BPF program's frame pointer value.
> > > +            *
> > > +            * add dst, -40
> > > +            */
> > > +           EMIT4(add_1mod(0x48, dst_reg), 0x83, add_1reg(0xC0, dst_reg),
> > > +                 0xD8);
> > > +   }
> > > +
> >
> > That won't work. Any register can point to a stack.
>
> Right, but if the stack pointer comes from BPF_REG_FP then won't the
> above correct it?  Then if the pointer gets passed around to other
> registers it will have the correct value.  Or did I miss your point?

At the beginning of the program frame pointer is bpf_reg_fp,
but later it can be in any register. It can be spilled into stack.
Some math done on it and that adjusted pointer passed into
another jited function.
It's perfectly fine for one bpf program to modify stack of
another bpf program. The verifier checks the safety bounds, etc.
