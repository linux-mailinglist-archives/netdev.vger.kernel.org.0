Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F14233DEBA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCPU1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhCPU1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B831A64D9D;
        Tue, 16 Mar 2021 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615926431;
        bh=a/wKNvnQeClTwwX3Zb1sG+qaYu9jbLv7DBvliGxU3DU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yv8zJVDMP4Z59fDbse6DO0bUJh58EAdgk+fpz1cCqfAX7T7wyEAINSMCqnfZQtMs3
         wW+vxgvoRgaX8stUOeAO/rvxAPtrYlYHcRjGHimsuiVspW6Mtcqqfy61Vep2dRsHhD
         0z7kuFG8Oe77b0Gjo57Tzo5m7CprlvWhrROljmJEY9IMmEhHha8cexdoy+3qySnzW0
         lPUv2u7nWCVFNYPYcgjqEzxBn+OBkQbLi+SOHj2aWsD6cIskLOx2MUZKovfXBz5jA7
         R9SwC+CvrU6SOw4bQx7KpMWCwVS9EZF0fzvLR26O7yf+3kDHcCk1gSgdKwWLVFrZv2
         02XmaKVBdVXgw==
Date:   Tue, 16 Mar 2021 13:27:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>,
        jerinj@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH 3/9] octeontx2-af: Do not allocate memory for
 devlink private
Message-ID: <20210316132709.6b55bcf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupARnUK5PgRjv9-TmFd9mNUg0Ms55zZEC2VuDcaEBZYLQ@mail.gmail.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
        <1615886833-71688-4-git-send-email-hkelam@marvell.com>
        <20210316100432.666d9bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupARnUK5PgRjv9-TmFd9mNUg0Ms55zZEC2VuDcaEBZYLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 23:33:40 +0530 sundeep subbaraya wrote:
> On Tue, Mar 16, 2021 at 10:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 16 Mar 2021 14:57:07 +0530 Hariprasad Kelam wrote:  
> > > From: Subbaraya Sundeep <sbhatta@marvell.com>
> > >
> > > Memory for driver private structure rvu_devlink is
> > > also allocated during devlink_alloc. Hence use
> > > the allocated memory by devlink_alloc and access it
> > > by devlink_priv call.
> > >
> > > Fixes: fae06da4("octeontx2-af: Add devlink suppoort to af driver")
> > > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>  
> >
> > Does it fix any bug? Looks like a coding improvement.  
> 
> Without this we cannot fetch our private struct 'rvu_devlink'  from any
> of the functions in devlink_ops which may get added in future.

"which may get added in future" does not sound like it's fixing 
an existing problem to me :(

If you have particular case where the existing setup is problematic
please describe it in more detail, or mention what other fix depends 
on this patch. Otherwise sending this one patch for net-next would 
be better IMHO.
