Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA76A18DF69
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 11:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgCUK0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 06:26:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37966 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgCUK0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 06:26:53 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFbKR-0001Rx-D7; Sat, 21 Mar 2020 11:26:07 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C6E72FFC8D; Sat, 21 Mar 2020 11:26:06 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting documentation
In-Reply-To: <20200321022930.GU3199@paulmck-ThinkPad-P72>
References: <20200320160145.GN3199@paulmck-ThinkPad-P72> <87mu8apzxr.fsf@nanos.tec.linutronix.de> <20200320210243.GT3199@paulmck-ThinkPad-P72> <874kuipsbw.fsf@nanos.tec.linutronix.de> <20200321022930.GU3199@paulmck-ThinkPad-P72>
Date:   Sat, 21 Mar 2020 11:26:06 +0100
Message-ID: <875zeyrold.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:
> On Fri, Mar 20, 2020 at 11:36:03PM +0100, Thomas Gleixner wrote:
>> I agree that what I tried to express is hard to parse, but it's at least
>> halfways correct :)
>
> Apologies!  That is what I get for not looking it up in the source.  :-/
>
> OK, so I am stupid enough not only to get it wrong, but also to try again:
>
>    ... Other types of wakeups would normally unconditionally set the
>    task state to RUNNING, but that does not work here because the task
>    must remain blocked until the lock becomes available.  Therefore,
>    when a non-lock wakeup attempts to awaken a task blocked waiting
>    for a spinlock, it instead sets the saved state to RUNNING.  Then,
>    when the lock acquisition completes, the lock wakeup sets the task
>    state to the saved state, in this case setting it to RUNNING.
>
> Is that better?

Definitely!

Thanks for all the editorial work!

       tglx
