Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9071C1CBC41
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgEIB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:57:43 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34878 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgEIB5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 21:57:43 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 10A1129922;
        Fri,  8 May 2020 21:57:38 -0400 (EDT)
Date:   Sat, 9 May 2020 11:57:44 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
In-Reply-To: <20200508175701.4eee970d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <alpine.LNX.2.22.394.2005091143590.8@nippy.intranet>
References: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr> <20200508175701.4eee970d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 8 May 2020, Jakub Kicinski wrote:

> On Fri,  8 May 2020 19:25:57 +0200 Christophe JAILLET wrote:
> > Only macsonic has been compile tested. I don't have the needed setup to
> > compile xtsonic
> 
> Well, we gotta do that before we apply the patch :S
> 

I've compiled xtsonic.c with this patch.

> Does the driver actually depend on some platform stuff,

xtsonic.c looks portable enough but it has some asm includes that I 
haven't looked at. It is really a question for the arch maintainers.

>  or can we do this:
> 
> diff --git a/drivers/net/ethernet/natsemi/Kconfig b/drivers/net/ethernet/natsemi/Kconfig
> @@ -58,7 +58,7 @@ config NS83820
>  
>  config XTENSA_XT2000_SONIC
>         tristate "Xtensa XT2000 onboard SONIC Ethernet support"
> -       depends on XTENSA_PLATFORM_XT2000
> +       depends on XTENSA_PLATFORM_XT2000 || COMPILE_TEST
>         ---help---
>           This is the driver for the onboard card of the Xtensa XT2000 board.
>  
> ?
> 

That's effectively what I did to compile test xtsonic.c (I removed the 
line to get the same effect).
