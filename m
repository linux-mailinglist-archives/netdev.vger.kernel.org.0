Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E82442482
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhKBAMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhKBAMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1052660EDF;
        Tue,  2 Nov 2021 00:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635811775;
        bh=EfZ9nBGWld8QFbfvoTqAhXWUe2i3SVh73ovScpJwvk4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ZZhtr1r0n9W4Q5dJ/4squPwswHOmfQjaTpoeZ+ZVh4jR+3CN1KFQS4CQxy+Nuxvr7
         SNWNhwNE7hQTbk1du3DWdTHY9gxHjOowm5C1LwELaE3HY0OPXDLi1qFEM2HaTWuJ+O
         CmfHhuJyPJPz3Ggz20FPsXlUnVoYDnap56r07cDx6ivfu0nPFLn9Ic14kntT8fB9PK
         opIcmdLKqPC3Lfewz2qxv8skbbV9YG76sLyFhZwgTZpaP+PVw4XxKsEW/R+KD8MnWz
         K0iz0Q9kt3293NAPQ7AopR3ZTxct4aRkSYG8VL8FE8pWAAwYJp/NeK8naK0lvamU9v
         Tcmgbz/vKDSIA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D06115C037F; Mon,  1 Nov 2021 17:09:34 -0700 (PDT)
Date:   Mon, 1 Nov 2021 17:09:34 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Wiesner <jwiesner@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211102000934.GG880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211027164352.GA23273@incl>
 <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
 <20211028162025.GA1068@incl>
 <20211028184209.GH880162@paulmck-ThinkPad-P17-Gen-1>
 <20211101102803.GA16089@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101102803.GA16089@incl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 11:28:03AM +0100, Jiri Wiesner wrote:
> On Thu, Oct 28, 2021 at 11:42:09AM -0700, Paul E. McKenney wrote:
> > On Thu, Oct 28, 2021 at 06:20:25PM +0200, Jiri Wiesner wrote:
> > > On Wed, Oct 27, 2021 at 02:38:29PM -0700, Paul E. McKenney wrote:
> > > > I had something like this pending, but people came up with other workloads
> > > > that resulted in repeated delays.  In those cases, it does not make sense
> > > > to ever mark the affected clocksource unstable.  This led me to the patch
> > > > shown below, which splats after about 100 consecutive long-delay retries,
> > > > but which avoids marking the clocksource unstable.  This is queued on -rcu.
> > > > 
> > > > Does this work for you?
> > > > 
> > > > commit 9ec2a03bbf4bee3d9fbc02a402dee36efafc5a2d
> > > > Author: Paul E. McKenney <paulmck@kernel.org>
> > > > Date:   Thu May 27 11:03:28 2021 -0700
> > > > 
> > > >     clocksource: Forgive repeated long-latency watchdog clocksource reads
> > > 
> > > Yes, it does. I have done 100 reboots of the testing machine (running
> > > 5.15-rc5 with the above patch applied) and TSC was stable every time. I
> > > am going to start a longer test of 300 reboots for good measure and
> > > report back next week. J.
> > 
> > Very good, and thank you for giving it a go!
> 
> Thank you for the fix! It resolves several strange results we got in our performance testing.
> 
> > If it passes the upcoming tests
> 
> I have done 300 reboots of the testing machine. Again, TSC was stable every time.
> 
> > may I have your Tested-by?
> 
> Absolutely:
> Tested-by: Jiri Wiesner <jwiesner@suse.de>

Applied, thank you!

							Thanx, Paul
