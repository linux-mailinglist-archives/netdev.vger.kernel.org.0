Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B928F32
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387654AbfEXCkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbfEXCkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 22:40:12 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1263F2177E;
        Fri, 24 May 2019 02:40:09 +0000 (UTC)
Date:   Thu, 23 May 2019 22:40:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523224008.55f6d3ab@oasis.local.home>
In-Reply-To: <20190524020849.vxg3hqjtnhnicyzp@ast-mbp.dhcp.thefacebook.com>
References: <20190521173618.2ebe8c1f@gandalf.local.home>
        <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
        <20190521174757.74ec8937@gandalf.local.home>
        <20190522052327.GN2422@oracle.com>
        <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
        <20190523054610.GR2422@oracle.com>
        <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
        <20190523190243.54221053@gandalf.local.home>
        <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
        <20190523215737.6601ab7c@oasis.local.home>
        <20190524020849.vxg3hqjtnhnicyzp@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Added Linus and Al ]

On Thu, 23 May 2019 19:08:51 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > > > 
> > > > I wish that was totally true, but tracepoints *can* be an abi. I had
> > > > code reverted because powertop required one to be a specific
> > > > format. To this day, the wakeup event has a "success" field that
> > > > writes in a hardcoded "1", because there's tools that depend on it,
> > > > and they only work if there's a success field and the value is 1.    
> > > 
> > > I really think that you should put powertop nightmares to rest.
> > > That was long ago. The kernel is different now.  
> > 
> > Is it?
> >   
> > > Linus made it clear several times that it is ok to change _all_
> > > tracepoints. Period. Some maintainers somehow still don't believe
> > > that they can do it.  
> > 
> > From what I remember him saying several times, is that you can change
> > all tracepoints, but if it breaks a tool that is useful, then that
> > change will get reverted. He will allow you to go and fix that tool and
> > bring back the change (which was the solution to powertop).  
> 
> my interpretation is different.
> We changed tracepoints. It broke scripts. People changed scripts.

Scripts are different than binary tools.

> 
> >   
> > > 
> > > Some tracepoints are used more than others and more people will
> > > complain: "ohh I need to change my script" when that tracepoint
> > > changes. But the kernel development is not going to be hampered by a
> > > tracepoint. No matter how widespread its usage in scripts.  
> > 
> > That's because we'll treat bpf (and Dtrace) scripts like modules (no
> > abi), at least we better. But if there's a tool that doesn't use the
> > script and reads the tracepoint directly via perf, then that's a
> > different story.  
> 
> absolutely not.
> tracepoint is a tracepoint. It can change regardless of what
> and how is using it.

Instead of putting words into Linus's mouth, I'll just let him speak
for himself. If a useful tool that reads a tracepoint breaks because we
changed the tracepoint, and Linus is fine with that. Then great, we can
start adding them to VFS and not worry about them being an ABI.

-- Steve


