Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFDB39CD5E
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 07:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhFFFH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 01:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFFFH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 01:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A45D61186;
        Sun,  6 Jun 2021 05:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622955968;
        bh=1pRd3PUJmxWH0xFOe34qsLGnOaIyBtt1Zt0gUhUXH50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hLnXuX/rGaq9+6i4FsE1NXUM+o1R52Q39QUoo0QCfmrPiBCZg2VuPeYbx2Bnh8G/f
         KJ+sZjZSBxnBxFyQg6QXjuAfWvjTn2SGx6r+LIGw3vblcphCgvV2qUEFfWiS/s9emW
         EH0tcw0n8Dii/8RmR9dffGiGUkE8snl0t2llHomxar9MGxauiNz9SqdXGhWjgKYaMv
         2Vdy9LgAbmwRfFt3XXq1KeKhCPWIninL4tcxy54nSM6FYmYtdkY7fgJSBckdjnTZQo
         n4yxbsB7vTcSgaKqzj7a+b/5NKM41sXPW7AgvwZ3rK0/iX81n6zo4gaQaGrn09hfc0
         uDUwkYocEH0zg==
Date:   Sun, 6 Jun 2021 08:06:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     SyzScope <syzscope@gmail.com>, davem@davemloft.net,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLxXvfi1P8qZdQH3@unreal>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YLsrLz7otkQAkIN7@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 09:43:43AM +0200, Greg KH wrote:
> On Fri, Jun 04, 2021 at 10:11:03AM -0700, SyzScope wrote:
> > Hi Greg,
> > 
> > > Who is working on and doing this "reseach project"?
> > We are a group of researchers from University of California, Riverside (we
> > introduced ourselves in an earlier email to security@kernel.org if you
> > recall).
> 
> I do not recall that, sorry, when was that?
> 
> > Please allow us to articulate the goal of our research. We'd be
> > happy to hear your feedback and suggestions.
> > 
> > > And what is it
> > > doing to actually fix the issues that syzbot finds?  Seems like that
> > > would be a better solution instead of just trying to send emails saying,
> > > in short "why isn't this reported issue fixed yet?"
> > From our limited understanding, we know a key problem with syzbot bugs is
> > that there are too many of them - more than what can be handled by
> > developers and maintainers. Therefore, it seems some form of prioritization
> > on bug fixing would be helpful. The goal of the SyzScope project is to
> > *automatically* analyze the security impact of syzbot bugs, which helps with
> > prioritizing bug fixes. In other words, when a syzbot bug is reported, we
> > aim to attach a corresponding security impact "signal" to help developers
> > make an informed decision on which ones to fix first.
> 
> Is that really the reason why syzbot-reported problems are not being
> fixed?  Just because we don't know which ones are more "important"?
> 
> As someone who has been managing many interns for a year or so working
> on these, I do not think that is the problem, but hey, what do I know...

My 2 cents, as the one who is fixing these external and internal syzkaller bugs
in RDMA. I would say that the main reason is lack of specific knowledge to fix
them or/and amount of work to actually do it.

Many of such failures are in neglected parts of code.

And no, I personally won't care if someone adds security score or not to
syzkaller report, all reports should be fixed.

Thanks
