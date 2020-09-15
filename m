Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736326ACDC
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgIOTBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgIORLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 13:11:42 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 253A92193E;
        Tue, 15 Sep 2020 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600189339;
        bh=IUpCyffZBng6VxFe1zQQa34I+E1YixGJRW8ke5R6BkU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=US2HCjeq5zZ7QUapdgMHz7lBhcKDI8o4/0gc5V48E3u5ZnY7Qry05+cAsbbP6UK8w
         GL0/27NqNOhjC+Ugi35BkiO5QL1ozuwuULmKDZECcGDyvL4AJpmMGghqBLqUs9bVei
         zAYnUjwmkJNBd1b/FPKRilsTyAC9MnKfC1Ii/Kkg=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id E824235226B7; Tue, 15 Sep 2020 10:02:18 -0700 (PDT)
Date:   Tue, 15 Sep 2020 10:02:18 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        nikolay@cumulusnetworks.com, davem@davemloft.net,
        netdev@vger.kernel.org, josh@joshtriplett.org,
        peterz@infradead.org, christian.brauner@ubuntu.com,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, roopa@nvidia.com
Subject: Re: [PATCH net-next] rcu: prevent RCU_LOCKDEP_WARN() from swallowing
 the condition
Message-ID: <20200915170218.GN29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200908173624.160024-1-kuba@kernel.org>
 <5ABC15D5-3709-4CA4-A747-6A7812BB12DD@cumulusnetworks.com>
 <20200908172751.4da35d60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200914202122.GC2579423@google.com>
 <20200914154738.3f4b980a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200915002011.GJ29330@paulmck-ThinkPad-P72>
 <20200914173029.60bdfc02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914173029.60bdfc02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 05:30:29PM -0700, Jakub Kicinski wrote:
> On Mon, 14 Sep 2020 17:20:11 -0700 Paul E. McKenney wrote:
> > > Seems like quite a few places depend on the macro disappearing its
> > > argument. I was concerned that it's going to be had to pick out whether
> > > !LOCKDEP builds should return true or false from LOCKDEP helpers, but
> > > perhaps relying on the linker errors even more is not such poor taste?
> > > 
> > > Does the patch below look acceptable to you?  
> > 
> > The thing to check would be whether all compilers do sufficient
> > dead-code elimination (it used to be that they did not).  One way to
> > get a quick sniff test of this would be to make sure that a dead-code
> > lockdep_is_held() is in common code, and then expose this patch to kbuild
> > test robot.
> 
> I'm pretty sure it's in common code because kbuild bot complaints were
> the reason I gave up the first time around ;) 
> 
> I'll expose this to kbuild bot via my kernel.org tree in case it
> doesn't consider scissored patches and report back!

Sounds good, thank you!

							Thanx, Paul
