Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F600298EB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403769AbfEXN3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391395AbfEXN3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:29:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F75D217F9;
        Fri, 24 May 2019 13:28:58 +0000 (UTC)
Date:   Fri, 24 May 2019 09:28:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524092855.356020f7@gandalf.local.home>
In-Reply-To: <20190524040527.GU2422@oracle.com>
References: <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
        <20190521184137.GH2422@oracle.com>
        <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
        <20190521173618.2ebe8c1f@gandalf.local.home>
        <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
        <20190521174757.74ec8937@gandalf.local.home>
        <20190522052327.GN2422@oracle.com>
        <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
        <20190523054610.GR2422@oracle.com>
        <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
        <20190524040527.GU2422@oracle.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 00:05:27 -0400
Kris Van Hees <kris.van.hees@oracle.com> wrote:

> No, no, that is not at all what I am saying.  In DTrace, the particulars of
> how you get to e.g. probe arguments or current task information are not
> something that script writers need to concern themselves about.  Similar to
> how BPF contexts have a public (uapi) declaration and a kernel-level context
> declaration taht is used to actually implement accessing the data (using the
> is_valid_access and convert_ctx_access functions that prog types implement).
> DTrace exposes an abstract probe entity to script writers where they can
> access probe arguments as arg0 through arg9.  Nothing in the userspace needs
> to know how you obtain the value of those arguments.  So, scripts can be
> written for any kind of probe, and the only information that is used to
> verify programs is obtained from the abstract probe description (things like
> its unique id, number of arguments, and possible type information for each
> argument).  The knowledge of how to get to the value of the probe arguments
> is only known at the level of the kernel, so that when the implementation of
> the probe in the kernel is modified, the mapping from actual probe to abstract
> representation of the probe (in the kernel) can be modified along with it,
> and userspace won't even notice that anything changed.
> 
> Many parts of the kernel work the same way.  E.g. file system implementations
> change, yet the API to use the file systems remains the same.

Another example is actually the tracefs events directory. It represents
normal trace events (tracepoints), kprobes, uprobes, and synthetic
events. You don't need to know what they are to use them as soon as
they are created. You can even add triggers and such on top of each,
and there shouldn't be any difference.

-- Steve
