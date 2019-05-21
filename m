Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2715324D12
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfEUKpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:45:20 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34484 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfEUKpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 06:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FTzz7OWRvXlxG8one4ToUfIysCVkEwXpU2o6YloZMrI=; b=0XL7bLantOsLpR+awlykwcXWR
        d51q/GWcI+AcTAxN+9LdZWKACZhGbhWTc0mnYIIHJydORHmJyrbA0j5UXSQdgfHhvIOCdk5GSlZ6y
        Usg1BakwswAkb3MYHiHD+ZHFTjY7Ct5NDx3q3YMRoNtsZvmhY9qjTlefHMEpYvi4TJ7IXgEfWIu77
        E4FSDhLq+ov8gW6kzqTk+S3v/fFnl3YCGWL05CAEw4L8JszD8BHz22lUZ/km96PDdngy8n9II8f7S
        OvIRkqZbRQ2sANe4d078ndZQWIX5i2/3NpFIoNbhrZsqY+3Bv1B9iQgeqiHz36Nevzq2n9iiOgjIM
        BLJKjtMLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52560)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hT2Gh-0000XG-NK; Tue, 21 May 2019 11:45:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hT2Ge-0005lk-Co; Tue, 21 May 2019 11:45:12 +0100
Date:   Tue, 21 May 2019 11:45:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, John Crispin <john@phrozen.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>, Felix Fietkau <nbd@nbd.name>
Subject: Re: ARM router NAT performance affected by random/unrelated commits
Message-ID: <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 12:28:48PM +0200, Rafał Miłecki wrote:
> Hi,
> 
> I work on home routers based on Broadcom's Northstar SoCs. Those devices
> have ARM Cortex-A9 and most of them are dual-core.
> 
> As for home routers, my main concern is network performance. That CPU
> isn't powerful enough to handle gigabit traffic so all kind of
> optimizations do matter. I noticed some unexpected changes in NAT
> performance when switching between kernels.
> 
> My hardware is BCM47094 SoC (dual core ARM) with integrated network
> controller and external BCM53012 switch.

Guessing, I'd say it's to do with the placement of code wrt cachelines.
You could try aligning some of the cache flushing code to a cache line
and see what effect that has.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
