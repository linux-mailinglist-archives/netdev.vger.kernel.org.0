Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA55846CF5
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfFNXa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:30:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39398 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfFNXa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:30:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so3970698ljh.6;
        Fri, 14 Jun 2019 16:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hLRvRyseCoNTnINKGx1gbhdzgE1HlmQyXykkBiBseG4=;
        b=XsbynDbDNwALY52CArTK5cnvk4mmYDaryXGQacSxkuCC0C8D65Z1opswYES2F8hqFg
         CFQ84p+YGY1zGY2h+9tqYn6+0MoWuMrQarVQmuoy8vDOEVM+cQrGs8+zFuGOktT5ohLd
         OUbDI+uM8jrivKmiy6Jo5kJlh9zuJrafznOYrKm5vbV6sjk3saWgdzXVZXEDifzNldEQ
         znvklcvpQYIiycEhvllN7AdQgxTJBhe1lkDPFy7NtT1q0+iL2/QR9igFkKB25K3ip37h
         0L6A/n4zRVSwEBIKu0Fh8JGoquUtbaktaShO4Ut63P1MnDFD3JKy6bbu4LGnhM8N8oho
         P3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hLRvRyseCoNTnINKGx1gbhdzgE1HlmQyXykkBiBseG4=;
        b=Dt0WPn1g0Y/aPaj/RYz7+JVZ0g3u0iHugwhPpvZCZUomV7Fn2U2fgcJ6b/BPwLz/Je
         wLb82i0yCecrIt9sNP5iC3dF3xwdDoervKjF9GckYW4w5GHkKnjSRUj0ovDDgxNEoTHK
         tIqWE6syWqToCrOBxBz978gzwR0znsPbQhWdvBYQb8nb4pMzME9PJx0AugQpVnvUFkhF
         XWE7stvcaQyV3EW9U3EqGtVm3SAgAjgMhViH2CEhLAJgvTz6PCwt1Bm2lOr+LZqhKlaU
         zPDSvTepILPjCnsEMngaiRKMeUHfb56yNLGiHs/cz90fnHJg0od6EAYIfRyL5zpB6y7I
         aaNg==
X-Gm-Message-State: APjAAAUDtqomHqk32X8Vzwi9NN1u3JhLE1TGAzKh0zIxgwTdmPOU5rwP
        XF9LqMGBDu64mRRfnXOdSfeMwmPV3JpPM4Y4iZc=
X-Google-Smtp-Source: APXvYqwbIBfbtHpDcKSqlvtFREHBX4scDcT301yjzhza69EW1cROJWTQO5zNXq0ejKhNBgymyKw0elbWtSfI8kvJ+ys=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr10593386lji.195.1560555026608;
 Fri, 14 Jun 2019 16:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
 <20190614210745.kwiqm5pkgabruzuj@treble> <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
 <20190614211929.drnnawbi7guqj2ck@treble> <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
 <20190614231717.xukbfpc2cy47s4xh@treble>
In-Reply-To: <20190614231717.xukbfpc2cy47s4xh@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 16:30:15 -0700
Message-ID: <CAADnVQJn+TnSj82MJ0ry1UTNGXD0qzESqfp7E1oi_HAYC-xTXg@mail.gmail.com>
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

On Fri, Jun 14, 2019 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 02:22:59PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > > > >
> > > > > > > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> > > > > >
> > > > > > since external tool will be looking at it should it be named
> > > > > > "bpf_jump_table." to avoid potential name conflicts?
> > > > > > Or even more unique name?
> > > > > > Like "bpf_interpreter_jump_table." ?
> > > > >
> > > > > No, the point is that it's a generic feature which can also be used any
> > > > > non-BPF code which might also have a jump table.
> > > >
> > > > and you're proposing to name all such jump tables in the kernel
> > > > as static foo jump_table[] ?
> > >
> > > That's the idea.
> >
> > Then it needs much wider discussion.
>
> Why would it need wider discussion?  It only has one user.  If you
> honestly believe that it will be controversial to require future users
> to call a static jump table "jump_table" then we can have that
> discussion when it comes up.

It's clearly controversial.
I nacked it already on pointless name change
from "jumptable" to "jump_table" and now you're saying
that no one will complain about "jump_table" name
for all jump tables in the kernel that will ever appear?
