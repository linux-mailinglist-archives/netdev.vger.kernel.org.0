Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14DF3698D4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbhDWSIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWSIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:08:04 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316FCC061574;
        Fri, 23 Apr 2021 11:07:28 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 542AE72B7; Fri, 23 Apr 2021 14:07:27 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 542AE72B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619201247;
        bh=1HWABe1pBrZRNSlmKUpJ27EmxvYwRlFblgJzINxdFHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlB/RqCRZaUXv2F0AHjVjc3KWpwwU4LxrmDVK6vAeG1GIUxukeByBcG/m9U9lC07c
         0nDtoSvfa03M+d6ch3T1BXdAOl8dHXLZ172qYuet4JoV6VO+GtC56Mt1/ezM3QR+cC
         Fuwo+9UJBWVIK3HYFSB/yqdy+ACYYvsRkJE8MURs=
Date:   Fri, 23 Apr 2021 14:07:27 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20210423180727.GD10457@fieldses.org>
References: <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIMDCNx4q6esHTYt@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 08:25:28PM +0300, Leon Romanovsky wrote:
> On Thu, Apr 22, 2021 at 03:39:50PM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 21, 2021 at 09:56:37AM -0400, J. Bruce Fields wrote:
> > > On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> > > > If you want to see another accepted patch that is already part of
> > > > stable@, you are invited to take a look on this patch that has "built-in bug":
> > > > 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")
> > > 
> > > Interesting, thanks.
> > 
> > Though looking at it now, I'm not actually seeing the bug--probably I'm
> > overlooking something obvious.
> 
> It was fixed in commit 31634bf5dcc4 ("net/mlx5: FPGA, tls, hold rcu read lock a bit longer")

So is the "Fixes:" line on that commit wrong?  It claims the bug was
introduced by an earlier commit, ab412e1dd7db ("net/mlx5: Accel, add TLS
rx offload routines").

Looks like Aditya Pakki's commit may have widened the race a little, but
I find it a little hard to fault him for that.

--b.
