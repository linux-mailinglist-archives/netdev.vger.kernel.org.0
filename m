Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D93369FF3
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 09:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhDXHW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 03:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhDXHWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 03:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B4D961404;
        Sat, 24 Apr 2021 07:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619248905;
        bh=2IBg5lD3luughl/O28DyG4n7IZAasZN8SR4zzP9umVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/mUlID+VCER99XBM7rxiCQNaW22mN7Z9/USnqDT/ucOQZLn/mdh5SGMKbidSefPX
         Rf4JbhOcoL4tb9Re3uYHLlHl405t2+ACO38WozZiBdnghBgrlL0+knAQgOcgxQsow9
         tKrQyhEpqsFPE55ZO7eFU2u5M8FBmeAv6eCj2qzbyLHVsBpyI05T96Xj2WOxWcnILH
         eOqQkNOcvW954sHM6pK6cOtV/meI6/tEy72I3zH2Tca4107mNyvoNBnO3TvezyJtzT
         Gr9GVMy8LvrUdClP+rFTp5os6X7AM7ND8Ah71hFsvMUCBWiz5zwBrakoHqqLBnQcmB
         mKEQSv/CNzfXA==
Date:   Sat, 24 Apr 2021 10:21:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     "Shelat, Abhi" <a.shelat@northeastern.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIPHBZj/0Tn4nWVe@unreal>
References: <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423214850.GI10457@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 05:48:50PM -0400, J. Bruce Fields wrote:
> Have umn addresses been blocked from posting to kernel lists?

It is very unlikely.

> 
> Anyway:
> 
> On Fri, Apr 23, 2021 at 10:29:52PM +0300, Leon Romanovsky wrote:
> > On Fri, Apr 23, 2021 at 02:07:27PM -0400, J. Bruce Fields wrote:
> > > On Fri, Apr 23, 2021 at 08:25:28PM +0300, Leon Romanovsky wrote:
> > > > On Thu, Apr 22, 2021 at 03:39:50PM -0400, J. Bruce Fields wrote:
> > > > > On Wed, Apr 21, 2021 at 09:56:37AM -0400, J. Bruce Fields wrote:
> > > > > > On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> > > > > > > If you want to see another accepted patch that is already part of
> > > > > > > stable@, you are invited to take a look on this patch that has "built-in bug":
> > > > > > > 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")
> > > > > > 
> > > > > > Interesting, thanks.
> > > > > 
> > > > > Though looking at it now, I'm not actually seeing the bug--probably I'm
> > > > > overlooking something obvious.
> > > > 
> > > > It was fixed in commit 31634bf5dcc4 ("net/mlx5: FPGA, tls, hold rcu read lock a bit longer")
> > > 
> > > So is the "Fixes:" line on that commit wrong?  It claims the bug was
> > > introduced by an earlier commit, ab412e1dd7db ("net/mlx5: Accel, add TLS
> > > rx offload routines").
> > 
> > Yes, I think that Fixes line is misleading.
> > 
> > > 
> > > Looks like Aditya Pakki's commit may have widened the race a little, but
> > > I find it a little hard to fault him for that.
> > 
> > We can argue about severity of this bug, but the whole paper talks about
> > introduction of UAF bugs unnoticed.
> 
> Aditya Pakki points out in private mail that this patch is part of the
> work described in this paper:
> 
> 	https://www-users.cs.umn.edu/~kjlu/papers/crix.pdf
> 
> (See the list of patches in the appendix.)
> 
> I mean, sure, I suppose they could have created that whole second line
> of research just as a cover to submit malicious patches, but I think
> we're running pretty hard into Occam's Razor at that point.

Let's not speculate here.

The lack of trust, due to unethical research that was done by UMN researchers,
amount of bugs already introduced by @umn, and multiple attempts to repeat the
same pattern (see Al Viro responses on patches like this SUNRPC patch) is enough
to stop waste our time.

Thanks

> 
> --b.
