Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04871369AED
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbhDWTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 15:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWTad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 15:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107286134F;
        Fri, 23 Apr 2021 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619206196;
        bh=ikzGb+8FgMM5E+UXyiyzMOROEMO+CNXykpkkBbepjm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NIzx/5eCMVVtm4AJM102X9KO2qHDSz+Aul45b4EMeDbQDu4C66vCLColnWz7AdRPw
         2zyXZMMH1pdI+PR+MrAoINvOmsnNhJxU4EPfq298jYqHiH5RmVaRH/sIsYpWE0h7lx
         N950L7r1vBrIYR+O6JLnrkjw5AX1vILGLlKb4NaDDSbyBqeyToNYCiJn7FXf3VUjU5
         xsYWyoKup6RctsBga+G+vJZ9Y/9AndFHfcrkv3J13ImdzxMM0n5n2Az+4LsEXTemL7
         wTP5DzUhusiat/7txRfZ6Q/xuR+19uzHmU5yRvkW5+JYOlEsmhgwHskZy1WW5NvXnj
         t4G5C7kfGUutg==
Date:   Fri, 23 Apr 2021 22:29:52 +0300
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
Message-ID: <YIMgMHwYkVBdrICs@unreal>
References: <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423180727.GD10457@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 02:07:27PM -0400, J. Bruce Fields wrote:
> On Fri, Apr 23, 2021 at 08:25:28PM +0300, Leon Romanovsky wrote:
> > On Thu, Apr 22, 2021 at 03:39:50PM -0400, J. Bruce Fields wrote:
> > > On Wed, Apr 21, 2021 at 09:56:37AM -0400, J. Bruce Fields wrote:
> > > > On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> > > > > If you want to see another accepted patch that is already part of
> > > > > stable@, you are invited to take a look on this patch that has "built-in bug":
> > > > > 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")
> > > > 
> > > > Interesting, thanks.
> > > 
> > > Though looking at it now, I'm not actually seeing the bug--probably I'm
> > > overlooking something obvious.
> > 
> > It was fixed in commit 31634bf5dcc4 ("net/mlx5: FPGA, tls, hold rcu read lock a bit longer")
> 
> So is the "Fixes:" line on that commit wrong?  It claims the bug was
> introduced by an earlier commit, ab412e1dd7db ("net/mlx5: Accel, add TLS
> rx offload routines").

Yes, I think that Fixes line is misleading.

> 
> Looks like Aditya Pakki's commit may have widened the race a little, but
> I find it a little hard to fault him for that.

We can argue about severity of this bug, but the whole paper talks about
introduction of UAF bugs unnoticed.

Thanks

> 
> --b.
