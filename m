Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125F83D1EEB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhGVGnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhGVGnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 02:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F356161279;
        Thu, 22 Jul 2021 07:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626938644;
        bh=B6CYSSIfwFnW6Rrkfx2ye/ODs6fFnkzK4VSqq6033yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWeunvuRDB4fxnb3KD1Ef7v/tI8jqqsLG+15CfMeMH04xZ15mfk0L69xsAFZUnJ8U
         YOZlzHtcHuAxXzTthcShuGGMVnRMw9cw+VXyQYbVEVP8oDVz5GDgpNYtBJj7kVW5hY
         +LytrTF0GzU8YA+YNPeTcEJShfGskm3Z/UXWNX5aUHyI1uFI+eHB78wF+TdlSMaN4v
         bd/dzgrN5nh9rQld6qBkKwqkejUVStqS9KIOOLSFZ3u3kicJMcZ6rxLKrAysHgzNpr
         MdZwGQFXdKSAj1ssHeyvd5FkhWhtC4iCHKjq58ukCQEe7qDgH7lqh3oVlA1O8MZvUO
         JKaRr3NWex6Hw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m6T3Q-00040Q-8Y; Thu, 22 Jul 2021 09:23:37 +0200
Date:   Thu, 22 Jul 2021 09:23:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] usb: hso: fix error handling code of
 hso_create_net_device
Message-ID: <YPkc+HNUPcXQglpG@hovoldconsulting.com>
References: <20210714091327.677458-1-mudongliangabcd@gmail.com>
 <YPfOZp7YoagbE+Mh@kroah.com>
 <CAD-N9QVi=TvS6sM+jcOf=Y5esECtRgTMgdFW+dqB-R_BuNv6AQ@mail.gmail.com>
 <YPgwkEHzmxSPSLVA@hovoldconsulting.com>
 <YPhOcwiEUW+cchJ1@hovoldconsulting.com>
 <CAD-N9QVD6BcWVRbsXJ8AV0nMmCetpE6ke0wWxogXpwihnjTvRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QVD6BcWVRbsXJ8AV0nMmCetpE6ke0wWxogXpwihnjTvRA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 01:32:48PM +0800, Dongliang Mu wrote:
> On Thu, Jul 22, 2021 at 12:42 AM Johan Hovold <johan@kernel.org> wrote:

> > > A version of this patch has already been applied to net-next.
> >
> > That was apparently net (not net-next).
> >
> > > No idea which version that was or why the second patch hasn't been
> > > applied yet.
> 
> It seems because I only sent the 1/2 patch in the v3. Also due to
> this, gregkh asked me to resend the whole patchset again.

Yeah, it's hard to keep track of submissions sometimes, especially if
not updating the whole series.

> > > Dongliang, if you're resending something here it should first be rebased
> > > on linux-next (net-next).
> >
> > And the resend of v3 of both patches has now also been applied to
> > net-next.
> >
> > Hopefully there are no conflicts between v2 and v3 but we'll see soon.
> 
> You mean you apply a v2 patch into one tree? This thread already
> contains the v3 patch, and there is no v2 patch in the mailing list
> due to one incomplete email subject.
> 
> BTW, v2->v3 only some label change due to naming style.

Ok, I can't keep track of this either. I just noticed that this patch
shows up in both net (for 5.14):

	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a6ecfb39ba9d7316057cea823b196b734f6b18ca

and net-next (for 5.15):

	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=788e67f18d797abbd48a96143511261f4f3b4f21

The net one was applied on the 15th and the net-next one yesterday. 

Judging from a quick look it appears to be the same diff so no damage
done.

Johan
