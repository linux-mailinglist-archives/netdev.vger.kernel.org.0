Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5CF149F17
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgA0GqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgA0GqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:46:04 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE0F62071E;
        Mon, 27 Jan 2020 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580107563;
        bh=VWfxKMgYxtmft2I94grJMun2sEl4Bw81GpK4/84mS0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRm/bzQAOhn8EOAE9fKpN91v6dAqDfWtkT214YAX6TBlZ35B+mJom9EeHKPTeC9qb
         fd2aC3MjV39E68vFuhhLrNYvdlkhIKX4/TZxJ0h7GN4LxoJ/Eq+L+d9QaU/6GSL7ms
         zKSfGIikA8VJ6aGtAJzvCGG6yFYFXgpEWs6KsJRk=
Date:   Mon, 27 Jan 2020 08:45:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127064534.GJ3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <20200126133353.77f5cb7e@cakuba>
 <2a8d0845-9e6d-30ab-03d9-44817a7c2848@pensando.io>
 <20200127053433.GF3870@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200127053433.GF3870@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 07:34:33AM +0200, Leon Romanovsky wrote:
> On Sun, Jan 26, 2020 at 02:21:58PM -0800, Shannon Nelson wrote:
> > On 1/26/20 1:33 PM, Jakub Kicinski wrote
> > > > The long-standing policy in kernel that we don't really care about
> > > > out-of-tree code.
> > > Yeah... we all know it's not that simple :)
> > >
> > > The in-tree driver versions are meaningless and cause annoying churn
> > > when people arbitrarily bump them. If we can get people to stop doing
> > > that we'll be happy, that's all there is to it.
> > >
> > Perhaps it would be helpful if this standard was applied to all the drivers
> > equally?  For example, I see that this week's ice driver update from Intel
> > was accepted with no comment on their driver version bump.
>
> Thanks, it is another great example of why trusting driver authors,
> even experienced, on specific topics is not an option.
>
> >
> > Look, if we want to stamp all in-kernel drivers with the kernel version,
> > fine.  But let's do it in a way that doesn't break the out-of-tree driver
> > ability to report something else.  Can we set up a macro for in-kernel
> > drivers to use in their get_drvinfo callback and require drivers to use that
> > macro?  Then the out-of-tree drivers are able to replace that macro with
> > whatever they need.  Just don't forcibly bash the value from higher up in
> > the stack.
>
> The thing is that we don't consider in-kernel API as stable one, so
> addition of new field which is not in use in upstream looks sketchy to
> me, but I have an idea how to solve it.

Actually, it looks like my idea is Jakub's and Michal's idea. I will use
this opportunity and remove MODULE_VERSION() too.

Thanks

>
> Thanks
>
> >
> > sln
> >
