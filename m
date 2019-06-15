Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1882D46D1E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfFOAIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:08:02 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38890 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFOAIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:08:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so4016824ljg.5;
        Fri, 14 Jun 2019 17:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMuHhicoOxTAPFE9bnFneN8d6+FK2VEGSek198YPmPE=;
        b=ABuGBYXUO9WQYuqEIZqijiWQ0yzeMEeSU8iFE2yZUoEiEXEcDMIibgSGLQYyXH6IGN
         zU+ZfXl/y6OMjVBOmFSY1A7vZU1CtfpvzHiDLeMG8AYIHQ+1mq9ZMA24mVWaInetYa5q
         jQON4dHJ0XID7QxPKab2Xe/fa0RN5zD10daSsddLznd8KNTuYmEjrUKgrn4W82sJ3bNF
         6nIDiWhH9jRz8EXyhhi0orcZThYp38dxiq8E8sU8BbuvCQJB3notOmkZo5DjGRWaNwGu
         Yud8pIMLArb2vZA78NaOE7+c0J/YguNoWZRSMZVKgJmfnc1ABIE9PSiodFIEDL0haU6P
         K2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMuHhicoOxTAPFE9bnFneN8d6+FK2VEGSek198YPmPE=;
        b=H9l3NwntxqdCQsAAeHc3XV2lV3Pv+T2u3cVRHrE3yI+b4lM+Yp+2lfBYxtQEK3BZk0
         IVa1eQOXJJk3utqjqBbvolf5+LPoatZWHJjRPJvFFRaGLwOH1A81BpBtubEccBcetX16
         vSA5scn96xbcckKf93hPtGNKVkO07HNMkUwCasUvB+oEi7B9NHwNcr0ZhqdcPo8oT/+i
         BnT8AIwhacrQHPfGRbMLY1MdoFKYbbmGaV31OM+0qfUB+qjmc72CU5XkyRm9i3/KcIxG
         Iz67ZIaDp8c206CZroK6vatxZp+Lf++YA70VQj/H1WWu9Ke3WVYtUVtsoMafU3OZRbBI
         ZLsQ==
X-Gm-Message-State: APjAAAWSrCiOAzcXo6R8SUnYD9CbLvfkBRP1kHFw+NHy1HOAEjp35CpD
        A+JIizWdIP4q1Bqh2JKhnlNIQG6pL9n+OrnH45g=
X-Google-Smtp-Source: APXvYqz06Ojw3v5QNieqmgknT26FRRsKiCHOLmB+DNqZWJkWnORe4tvRACG4Hx3hbE3azwDext4csLEaXF6r8Ozd7e0=
X-Received: by 2002:a2e:94c9:: with SMTP id r9mr6524812ljh.210.1560557279650;
 Fri, 14 Jun 2019 17:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
 <20190614210745.kwiqm5pkgabruzuj@treble> <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
 <20190614211929.drnnawbi7guqj2ck@treble> <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
 <20190614231717.xukbfpc2cy47s4xh@treble> <CAADnVQJn+TnSj82MJ0ry1UTNGXD0qzESqfp7E1oi_HAYC-xTXg@mail.gmail.com>
 <20190615000242.e5tcogffvyuuhnrs@treble>
In-Reply-To: <20190615000242.e5tcogffvyuuhnrs@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 17:07:48 -0700
Message-ID: <CAADnVQ+jhza8bsBNAdayk=tcXN4nJt+fVAxtoVZNDPbVPveR8A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
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

On Fri, Jun 14, 2019 at 5:02 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 04:30:15PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Fri, Jun 14, 2019 at 02:22:59PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> > > > > > > >
> > > > > > > > since external tool will be looking at it should it be named
> > > > > > > > "bpf_jump_table." to avoid potential name conflicts?
> > > > > > > > Or even more unique name?
> > > > > > > > Like "bpf_interpreter_jump_table." ?
> > > > > > >
> > > > > > > No, the point is that it's a generic feature which can also be used any
> > > > > > > non-BPF code which might also have a jump table.
> > > > > >
> > > > > > and you're proposing to name all such jump tables in the kernel
> > > > > > as static foo jump_table[] ?
> > > > >
> > > > > That's the idea.
> > > >
> > > > Then it needs much wider discussion.
> > >
> > > Why would it need wider discussion?  It only has one user.  If you
> > > honestly believe that it will be controversial to require future users
> > > to call a static jump table "jump_table" then we can have that
> > > discussion when it comes up.
> >
> > It's clearly controversial.
> > I nacked it already on pointless name change
> > from "jumptable" to "jump_table" and now you're saying
> > that no one will complain about "jump_table" name
> > for all jump tables in the kernel that will ever appear?
>
> Let me get this straight.  You're saying that "jumptable" and
> "bpf_interpreter_jump_table" are both acceptable.
>
> But NACK to "jump_table".
>
> Ok...

Correct. I think I explained the reasons behind, right?
