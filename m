Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1200A192E57
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgCYQjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgCYQjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:39:20 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6311D2073E;
        Wed, 25 Mar 2020 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585154359;
        bh=A1GPX4wlECfGGG7gTSHHrGt3spoxTdKZ1xy9utwV/BA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=APOdz2w7EH+7D58vqGoNgP8mOHfbNma8Ty1WIG8jpBICPSinl9OycWqb0OdtxkciV
         gxpkAVRwhIe+WxIGCYwXBH73yF99ZY9v+QEk7Sp75Ev8c6B1ujrOAxGnV4ZUKw4afx
         Pt8nI6CO51v4M2JmrHTqBAusgH99DwWPqLUsLFTU=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 325E9352094D; Wed, 25 Mar 2020 09:39:19 -0700 (PDT)
Date:   Wed, 25 Mar 2020 09:39:19 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Sebastian Siewior <bigeasy@linutronix.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: Documentation/locking/locktypes: Further clarifications and
 wordsmithing
Message-ID: <20200325163919.GU19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200323025501.GE3199@paulmck-ThinkPad-P72>
 <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
 <20200325002811.GO19865@paulmck-ThinkPad-P72>
 <87wo78y5yy.fsf@nanos.tec.linutronix.de>
 <20200325160212.oavrni7gmzudnczv@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200325160212.oavrni7gmzudnczv@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 05:02:12PM +0100, Sebastian Siewior wrote:
> On 2020-03-25 13:27:49 [+0100], Thomas Gleixner wrote:
> > The documentation of rw_semaphores is wrong as it claims that the non-owner
> > reader release is not supported by RT. That's just history biased memory
> > distortion.
> > 
> > Split the 'Owner semantics' section up and add separate sections for
> > semaphore and rw_semaphore to reflect reality.
> > 
> > Aside of that the following updates are done:
> > 
> >  - Add pseudo code to document the spinlock state preserving mechanism on
> >    PREEMPT_RT
> > 
> >  - Wordsmith the bitspinlock and lock nesting sections
> > 
> > Co-developed-by: Paul McKenney <paulmck@kernel.org>
> > Signed-off-by: Paul McKenney <paulmck@kernel.org>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> > --- a/Documentation/locking/locktypes.rst
> > +++ b/Documentation/locking/locktypes.rst
> …
> > +rw_semaphore
> > +============
> > +
> > +rw_semaphore is a multiple readers and single writer lock mechanism.
> > +
> > +On non-PREEMPT_RT kernels the implementation is fair, thus preventing
> > +writer starvation.
> > +
> > +rw_semaphore complies by default with the strict owner semantics, but there
> > +exist special-purpose interfaces that allow non-owner release for readers.
> > +These work independent of the kernel configuration.
> 
> This reads funny, could be my English. "This works independent …" maybe?

The "These" refers to "interfaces", which is plural, so "These" rather
than "This".  But yes, it is a bit awkward, because you have to skip
back past "readers", "release", and "non-owner" to find the implied
subject of that last sentence.

So how about this instead, making the implied subject explicit?

rw_semaphore complies by default with the strict owner semantics, but there
exist special-purpose interfaces that allow non-owner release for readers.
These interfaces work independent of the kernel configuration.

							Thanx, Paul
