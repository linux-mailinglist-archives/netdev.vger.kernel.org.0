Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BED824D8EA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgHUPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgHUPln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 11:41:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9092063A;
        Fri, 21 Aug 2020 15:41:42 +0000 (UTC)
Date:   Fri, 21 Aug 2020 11:41:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200821114141.4b564190@oasis.local.home>
In-Reply-To: <20200821113831.340ba051@oasis.local.home>
References: <20200821063043.1949509-1-elver@google.com>
        <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
        <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
        <20200821113831.340ba051@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 11:38:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > At some point we're going to have to introduce noinstr to idle as well.
> > > But until that time this should indeed cure things.    
> > 

What the above means, is that ideally we will get rid of all
tracepoints and kasan checks from these RCU not watching locations. But
to do so, we need to move the RCU not watching as close as possible to
where it doesn't need to be watching, and that is not as trivial of a
task as one might think. Once we get to a minimal code path for RCU not
to be watching, it will become "noinstr" and tracing and "debugging"
will be disabled in these sections.

Peter, please correct the above if it's not accurate.

-- Steve
