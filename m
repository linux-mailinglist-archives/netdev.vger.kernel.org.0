Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2144B10B
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhKIQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhKIQXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 11:23:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37806103C;
        Tue,  9 Nov 2021 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636474846;
        bh=4pOLreVzXokeYjCJddXh8QZj6wy/qqmtkTv96o1Y4pU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPAClu2DMa0PzfLnj4Ke6MShEnGwgzjLonoMOvU5PeCU9u8j9Ad5Q0nUJ2xGJZJW7
         oGeJfd95fk5kTEUA0zVYXq5mjK4/A6//VCanWYWkN+zxEAyoMwM/xPJfibvC76LEt8
         wTJdqKsLudYECGLGAl1YQN8Tc+tju40/7SbuYMxEelI0x3/LKTAAkBFdXa6UdnVrfj
         RkKu2lBjgkoSsRzmpa6yUXL0neetbRx4rKEUFyx5ruZ5Me+IgW/5bLVoCLXXkB9lkQ
         J1AM3wsCT31T8U/r+oMgi8/5QoTOmFLO2xL6m+MUZOPvng5FtkyhcnnWOkOqX6Zoz5
         C1Y7/cLx/FEXg==
Date:   Tue, 9 Nov 2021 08:20:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211109153335.GH1740502@nvidia.com>
References: <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
        <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211109144358.GA1824154@nvidia.com>
        <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211109153335.GH1740502@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> > > I once sketched out fixing this by removing the need to hold the
> > > per_net_rwsem just for list iteration, which in turn avoids holding it
> > > over the devlink reload paths. It seemed like a reasonable step toward
> > > finer grained locking.  
> > 
> > Seems to me the locking is just a symptom.  
> 
> My fear is this reload during net ns destruction is devlink uAPI now
> and, yes it may be only a symptom, but the root cause may be unfixable
> uAPI constraints.

If I'm reading this right it locks up 100% of the time, what is a uAPI
for? DoS? ;)

Hence my questions about the actual use cases.
