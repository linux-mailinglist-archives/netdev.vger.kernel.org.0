Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8746BD2
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfFNVXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:23:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42571 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNVXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:23:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id t28so3732308lje.9;
        Fri, 14 Jun 2019 14:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bep/4mrWNUML8peUzi7R1Kq2GEeDW29a39K0NjVrOn0=;
        b=K2sw0VY5k9n/J2JOh13BitvJ3EmXOKmOv47A1wo3Qvc1/6Fwyh3Tgr9z563c8cUD3K
         V1kmSXq5dUNjcv4AXSTg+8cRsuFl+KumG+g6ppjRADdhMRjhfv+J1nGQ7BzEfQo/rRbr
         l/J+Tx11/GOfLvvkRmrRBV1oj7Ky7DBUFR0TJ52tMefzWNbjORIKmjrvBTrkSXyDv0ou
         SC6eXnLCeAvFt4BKu/avKeRVmhXpvK120SJa8OVqi8lJq06SQsnbb+QYWcvkotxeFYr3
         D+vQ8YJJ95PUSN1ZLsZTbt6jVxdyl7Xs4S38f9pF1u5qIOi2gB+KO1LiA1x63lHPzAuO
         VoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bep/4mrWNUML8peUzi7R1Kq2GEeDW29a39K0NjVrOn0=;
        b=b49yp7hGqyxypcoRiiqRliT4A1i+KO/l95P+5NeYk9fq5/qRl7f3HuVnJYZTBLG18i
         2kCL4xbIb80WG0fLx2uCFg9ZC/oNsC0jwpF9MjaBpQBSh6lFoUaGZcStRFDtGB36m7nc
         UWT1hFpOcqO7j2XJezd2I7ouxEXqnOcIl8XMIPVhkK4DmAb6E0yERvW8/d3H6hDFPiGZ
         CmoDZexD0sB+AwXOHVyAPAHcanl902ixMLvw/iAa94rLJJk6WBFcEhqNIbZSaAQI0giB
         sHG3OoB2HkR1pza3J1L4QwCpBJxQ8K+Dz2zxJ2jvN5PaW3ZGGIjsr4qQFD/0N0dxejdz
         NkVw==
X-Gm-Message-State: APjAAAU5Vt7r880Jp6uQbRbL1TGPD2CEMC/hhFcFhQ8etpsZfer639sF
        qDYrQ0UVOrXzT9H8aQ2HbILJq5L9CK3ytv2WPp4=
X-Google-Smtp-Source: APXvYqwHVrR1Siq3X5Tl6ZvgYWmmA7hWQVfuMQhfHfIDK9o7BR+sFZQmdjSryoTryG79obaAZf0/ZPS12q6hWntNj5M=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr31548658lje.214.1560547390878;
 Fri, 14 Jun 2019 14:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
 <20190614210745.kwiqm5pkgabruzuj@treble> <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
 <20190614211929.drnnawbi7guqj2ck@treble>
In-Reply-To: <20190614211929.drnnawbi7guqj2ck@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 14:22:59 -0700
Message-ID: <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
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

On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > >
> > > > > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> > > >
> > > > since external tool will be looking at it should it be named
> > > > "bpf_jump_table." to avoid potential name conflicts?
> > > > Or even more unique name?
> > > > Like "bpf_interpreter_jump_table." ?
> > >
> > > No, the point is that it's a generic feature which can also be used any
> > > non-BPF code which might also have a jump table.
> >
> > and you're proposing to name all such jump tables in the kernel
> > as static foo jump_table[] ?
>
> That's the idea.

Then it needs much wider discussion.
I suggest to rename it to "bpf_interpreter_jump_table."
so it can be resolved now for this specific issue.
While bigger kernel-wide naming convention get resolved.
Later we can rename it to whatever the "standard name for jump table"
will be.
