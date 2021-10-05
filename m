Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F87422E2E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhJEQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhJEQoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:44:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F301611C5;
        Tue,  5 Oct 2021 16:42:11 +0000 (UTC)
Date:   Tue, 5 Oct 2021 12:42:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005124209.42fefb03@gandalf.local.home>
In-Reply-To: <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 09:18:04 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 5, 2021 at 6:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Also had to update a lot of the function pointer initialization in the
> > networking code, as a function address must be passed as an argument in
> > RCU_INIT_POINTER() and not just the function name, otherwise the following
> > error occurs:  
> 
> Ugh.
> 
> I think this is a sign of why we did it the way we did with that odd
> "typeof(*p)*" thing in the first place.
> 

Oh, which was also compiler specific.

On my fedora box, which has:

  gcc version 10.3.1 20210422 (Red Hat 10.3.1-1) (GCC)

It compiled fine, with no errors.

But on my Debian box with:

  gcc version 10.2.1 20210110 (Debian 10.2.1-6)

The function pointers were an issue :-/


-- Steve
