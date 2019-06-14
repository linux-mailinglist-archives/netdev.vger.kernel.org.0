Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B576B46B87
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFNVGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:06:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNVGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 17:06:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C83D130917AA;
        Fri, 14 Jun 2019 21:06:22 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23B1719C4F;
        Fri, 14 Jun 2019 21:06:21 +0000 (UTC)
Date:   Fri, 14 Jun 2019 16:06:19 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86: Always store regs->ip in
 perf_callchain_kernel()
Message-ID: <20190614210619.su5cr55eah5ks7ur@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <81b0cdc5aa276dac315a0536df384cc82da86243.1560534694.git.jpoimboe@redhat.com>
 <20190614205614.zr6awljx3qdg2fnb@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614205614.zr6awljx3qdg2fnb@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 14 Jun 2019 21:06:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 01:56:15PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 12:56:40PM -0500, Josh Poimboeuf wrote:
> > From: Song Liu <songliubraving@fb.com>
> > 
> > The stacktrace_map_raw_tp BPF selftest is failing because the RIP saved
> > by perf_arch_fetch_caller_regs() isn't getting saved by
> > perf_callchain_kernel().
> > 
> > This was broken by the following commit:
> > 
> >   d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > 
> > With that change, when starting with non-HW regs, the unwinder starts
> > with the current stack frame and unwinds until it passes up the frame
> > which called perf_arch_fetch_caller_regs().  So regs->ip needs to be
> > saved deliberately.
> > 
> > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> It's not cool to remove people's SOB.
> It's Song's patch. His should be first and your second.

His original patch didn't have an SOB.  I preserved the "From" field.

-- 
Josh
