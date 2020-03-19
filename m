Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911BF18AFF7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 10:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgCSJWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 05:22:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:50068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgCSJWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 05:22:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2697EAE59;
        Thu, 19 Mar 2020 09:22:15 +0000 (UTC)
Date:   Thu, 19 Mar 2020 02:21:07 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
Message-ID: <20200319092107.6brm26peh3h2n4sk@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200318204408.102694393@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020, Thomas Gleixner wrote:
>AFAICT the kthread uses TASK_INTERRUPTIBLE to not increase loadavg, kthreads
>cannot receive signals by default and this one doesn't look different. Use
>TASK_IDLE instead.

Hmm it seems in general this needs to be done kernel-wide. This kthread abuse of
TASK_INTERRUPTIBLE seems to be a common thing. There's also the users doing
schedule_timeout_interruptible()...

Thanks,
Davidlohr
