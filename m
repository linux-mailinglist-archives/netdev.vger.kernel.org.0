Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9231143E88E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhJ1Soj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhJ1Soi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3457E60D43;
        Thu, 28 Oct 2021 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635446531;
        bh=SboHfhcSgEu89q/WeWXtm8dc6nU6gwSG0s9zPHpPbC8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Yl0d6Q4zYZsWfly6S/R6iVDY+GoeHwrPdZ7Bjn+zgrOfGAdT+eReQQfhmTsrsdHIQ
         PSureovShXFFLqphcrYeesHwNrZgwQdCEfhE7OIOyWHAvt8XAth2KzCQnW73DDTllQ
         D+BMUGpk9kVjRFSP3TyWY+nO9eNKBX0y11XfoA/PnYd7MABRERr1DGmzPcU5xoAGEd
         4Igv/TtxPm7mjJvoCBqhsMT1/KbBYtHi1nB15NwEYq8mYnTgMtuQ91ybjT5PdqJncw
         +/Y26bS+Jzupr6azPaoAZTaPbVJkzIjpIrhXnJLN9W+c18d+50r0LFo+4eCbr7YQrl
         KBffNa3rSMvfw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D67395C04B3; Thu, 28 Oct 2021 11:42:09 -0700 (PDT)
Date:   Thu, 28 Oct 2021 11:42:09 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Wiesner <jwiesner@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211028184209.GH880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211027164352.GA23273@incl>
 <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
 <20211028162025.GA1068@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028162025.GA1068@incl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 06:20:25PM +0200, Jiri Wiesner wrote:
> On Wed, Oct 27, 2021 at 02:38:29PM -0700, Paul E. McKenney wrote:
> > I had something like this pending, but people came up with other workloads
> > that resulted in repeated delays.  In those cases, it does not make sense
> > to ever mark the affected clocksource unstable.  This led me to the patch
> > shown below, which splats after about 100 consecutive long-delay retries,
> > but which avoids marking the clocksource unstable.  This is queued on -rcu.
> > 
> > Does this work for you?
> > 
> > commit 9ec2a03bbf4bee3d9fbc02a402dee36efafc5a2d
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Thu May 27 11:03:28 2021 -0700
> > 
> >     clocksource: Forgive repeated long-latency watchdog clocksource reads
> 
> Yes, it does. I have done 100 reboots of the testing machine (running
> 5.15-rc5 with the above patch applied) and TSC was stable every time. I
> am going to start a longer test of 300 reboots for good measure and
> report back next week. J.

Very good, and thank you for giving it a go!  If it passes the upcoming
tests, may I have your Tested-by?

							Thanx, Paul
