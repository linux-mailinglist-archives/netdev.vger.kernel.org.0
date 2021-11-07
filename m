Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9F4474B5
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhKGR5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 12:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhKGR5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 12:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C8A60F46;
        Sun,  7 Nov 2021 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636307664;
        bh=i7Fa0iAZl1MqjtaLTFMXixa2ShnAxcvJBwDGQaBsMHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POUhSQjmU/lLR4ywtCcNw/NhTKvYrGMP/oiSi6j3iTkFwCil4BBy61IScg/mipnf5
         tctjTykCt/HbGSm2z38fpHyy0MDx33AzybBI7+tphMhaU7n8BOwPNrtBQVYNybmmon
         4rMsI+U/EetknZwn82M/sZruMc27GWStQjupj6n8SotFS0ROMfY0tyRI6E16Vko56r
         GX6PxlU0oYUAHRi30/GRAdKQC0nK5vyosP3UEkAm/NgB4YluF131GJ7cV8IlZCxJMd
         +aRNktmmX7jo2mInzztEUoczRbNkg3C2sIXfjQ+XLPwweiALWAGsizPYPAcYX4f7vM
         NBI6d1ReGC5kA==
Date:   Sun, 7 Nov 2021 19:54:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYgSzEHppKY3oYTb@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
 <YYABqfFy//g5Gdis@nanopsycho>
 <YYBTg4nW2BIVadYE@shredder>
 <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYgJ1bnECwUWvNqD@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 07:16:05PM +0200, Ido Schimmel wrote:
> On Mon, Nov 01, 2021 at 04:11:22PM -0700, Jakub Kicinski wrote:
> > On Mon, 1 Nov 2021 22:52:19 +0200 Ido Schimmel wrote:
> > > > >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>  
> > > > 
> > > > Looks fine to me.
> > > > 
> > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>  
> > > 
> > > Traces from mlxsw / netdevsim below:
> > 
> > Thanks a lot for the testing Ido!
> > 
> > Would you mind giving my RFC a spin as well on your syzbot machinery?

<...>

> > 
> >  (3) should we let drivers take refs on the devlink instance?
> 
> I think it's fine mainly because I don't expect it to be used by too
> many drivers other than netdevsim which is somewhat special. Looking at
> the call sites of devlink_get() in netdevsim, it is only called from
> places (debugfs and trap workqueue) that shouldn't be present in real
> drivers.

Sorry, I'm obligated to ask. In which universe is it ok to create new
set of API that no real driver should use?

Thanks
