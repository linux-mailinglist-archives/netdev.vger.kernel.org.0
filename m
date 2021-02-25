Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A07324BE3
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 09:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhBYIR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 03:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235686AbhBYIRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 03:17:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B492A64EC8;
        Thu, 25 Feb 2021 08:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614240995;
        bh=Me+eOGwQpSJjEdPdPym5v1pyap07D7Pxx1ypb60NhXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wTVbhkDGe6+qtOXmdxYrdNRK+FOPUhSENsXDIsFLygdfckk8237n+83p428FBILnr
         O5HOAXggYNNHjPRc68OMmlLuIUuFqQHlSkzSK91ktQaUpmHEFv0OTgOluMHw/ysmOA
         TJzRCHVpmiFkBUzdMDB+vsOQMZF+kDdkAWvpnEVA=
Date:   Thu, 25 Feb 2021 09:16:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, olteanv@gmail.com, sashal@kernel.org
Subject: Re: [PATCH stable-5.9.y] net: dsa: b53: Correct learning for
 standalone ports
Message-ID: <YDdc4PlMJjPhivLv@kroah.com>
References: <20210225010853.946338-1-f.fainelli@gmail.com>
 <20210225010956.946545-1-f.fainelli@gmail.com>
 <20210225010956.946545-6-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225010956.946545-6-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 05:09:54PM -0800, Florian Fainelli wrote:
> Standalone ports should not have learning enabled since all the frames
> are always copied to the CPU port. This is particularly important in
> case an user-facing port intentionally spoofs the CPU port's MAC
> address. With learning enabled we would end up with the switch having
> incorrectly learned the address of the CPU port which typically results
> in a complete break down of network connectivity until the address
> learned ages out and gets re-learned, from the correct port this time.
> 
> There was no control of the BR_LEARNING flag until upstream commit
> 4098ced4680a485c5953f60ac63dff19f3fb3d42 ("Merge branch 'brport-flags'")
> which is why we default to enabling learning when the ports gets added
> as a bridge member.
> 
> Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_common.c | 18 ++++++++++++++++++
>  drivers/net/dsa/b53/b53_regs.h   |  1 +
>  drivers/net/dsa/bcm_sf2.c        | 15 +--------------
>  3 files changed, 20 insertions(+), 14 deletions(-)

Note, 5.9.y and 5.8.y are long end-of-life.  You can see that at the
front page of www.kernel.org if you ever are curious about it.

thanks,

greg k-h
