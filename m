Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0104946CBE
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfFNXR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNXR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 19:17:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31D74368E3;
        Fri, 14 Jun 2019 23:17:26 +0000 (UTC)
Received: from treble (ovpn-112-39.rdu2.redhat.com [10.10.112.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C2B65C29A;
        Fri, 14 Jun 2019 23:17:20 +0000 (UTC)
Date:   Fri, 14 Jun 2019 18:17:17 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Message-ID: <20190614231717.xukbfpc2cy47s4xh@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
 <20190614210745.kwiqm5pkgabruzuj@treble>
 <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
 <20190614211929.drnnawbi7guqj2ck@treble>
 <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 14 Jun 2019 23:17:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:22:59PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > > >
> > > > > > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> > > > >
> > > > > since external tool will be looking at it should it be named
> > > > > "bpf_jump_table." to avoid potential name conflicts?
> > > > > Or even more unique name?
> > > > > Like "bpf_interpreter_jump_table." ?
> > > >
> > > > No, the point is that it's a generic feature which can also be used any
> > > > non-BPF code which might also have a jump table.
> > >
> > > and you're proposing to name all such jump tables in the kernel
> > > as static foo jump_table[] ?
> >
> > That's the idea.
> 
> Then it needs much wider discussion.

Why would it need wider discussion?  It only has one user.  If you
honestly believe that it will be controversial to require future users
to call a static jump table "jump_table" then we can have that
discussion when it comes up.

-- 
Josh
