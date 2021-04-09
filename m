Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E0359FC7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhDIN1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232286AbhDIN1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 09:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A8461105;
        Fri,  9 Apr 2021 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974829;
        bh=nKeHRuV5ymkEE4MF/NvZwM3D4+Kpkmi60AA4GEp/lxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZKMEUfRgF+cTTCGQSVZvtyf7Mk+1WDaNgzOGt4vZlr+tvIH/S7FlxdZMN2BRO4vu
         iaykpC0N/jH72qcco8nqGaBmXYOqLMGUrORGfKnCRyf3cMv0HNSvxoexVMWmpmq0PZ
         F9JyM8CsNjogKdYEwaCZ6aqoLvM8v5ej6S7DJHOo=
Date:   Fri, 9 Apr 2021 15:27:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Koen Vandeputte <koen.vandeputte@citymesh.com>,
        linux-can@vger.kernel.org, wg@grandegger.com,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com
Subject: Re: flexcan introduced a DIV/0 in kernel
Message-ID: <YHBWKzZyuUhMr0fj@kroah.com>
References: <5bdfcccb-0b02-e46b-eefe-7df215cc9d02@citymesh.com>
 <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
 <f7ba143a-58c8-811a-876e-d494c4681537@citymesh.com>
 <20210409131001.7r36v2vd3zmceloj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409131001.7r36v2vd3zmceloj@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:10:01PM +0200, Marc Kleine-Budde wrote:
> On 09.04.2021 14:55:59, Koen Vandeputte wrote:
> > 
> > On 09.04.21 13:21, Marc Kleine-Budde wrote:
> > > On 4/9/21 12:18 PM, Koen Vandeputte wrote:
> > > > Hi All,
> > > > 
> > > > I just updated kernel 4.14 within OpenWRT from 4.14.224 to 4.14.229
> > > > Booting it shows the splat below on each run. [1]
> > > > 
> > > > 
> > > > It seems there are 2 patches regarding flexcan which were introduced in
> > > > 4.14.226
> > > > 
> > > > --> ce59ffca5c49 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
> > > > --> bb7c9039a396 ("can: flexcan: assert FRZ bit in flexcan_chip_freeze()")
> > > > 
> > > > Reverting these fixes the splat.
> > > This patch should fix the problem:
> > > 
> > > 47c5e474bc1e can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing
> > > bitrate
> > > 
> > > Greg, can you pick this up for v4.14?
> > > 
> > > regards,
> > > Marc
> > > 
> > Checking kernels 4.4 & 4.9 shows that this fix is also missing over there.
> > 
> > Marc,
> > Can you confirm that it's also required for these?
> 
> ACK, the fix is needed for v4.4.265 and v4.9.265.

Now queued up there too, thanks!

greg k-h
