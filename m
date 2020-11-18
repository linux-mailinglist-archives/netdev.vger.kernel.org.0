Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341FB2B820E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKRQix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgKRQix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:38:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C378B2482C;
        Wed, 18 Nov 2020 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605717532;
        bh=QRPuukJJ9VK4qK50cpLa4TltAL6SWkINt7aoyLgZ/fU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vcYgc9tgY6jdghw/E4yKaUvYdo2I+VIZqhH7Xdvx0BaA0tfFcPs0nKhD7Nve30Y0+
         A9gzZ84S1IyTQ0fR/UbG+ttsNAets+WBmxZUdcuo9V4G9fBrKevdByJSjkVmDYe8gf
         o6Cdrw03fvjvQ6msT5OHrubOXPq5fU+3lyDzJDyE=
Date:   Wed, 18 Nov 2020 08:38:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     David Ahern <dsahern@gmail.com>, Florian Klink <flokli@flokli.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
Message-ID: <20201118083850.5cf28ab2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <0c2869ad-1176-9554-0c47-1f514981c6b4@infradead.org>
References: <20201115224509.2020651-1-flokli@flokli.de>
        <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
        <20201117170712.0e5a8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0c2869ad-1176-9554-0c47-1f514981c6b4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 19:09:16 -0800 Randy Dunlap wrote:
> On 11/17/20 5:07 PM, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 17:55:54 -0700 David Ahern wrote:  
> >> On 11/17/20 5:01 PM, Jakub Kicinski wrote:  
> >>> On Sun, 15 Nov 2020 23:45:09 +0100 Florian Klink wrote:    
> >>>> Checking for ifdef CONFIG_x fails if CONFIG_x=m.
> >>>>
> >>>> Use IS_ENABLED instead, which is true for both built-ins and modules.
> >>>>
> >>>> Otherwise, a    
> >>>>> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1      
> >>>> fails with the message "Error: IPv6 support not enabled in kernel." if
> >>>> CONFIG_IPV6 is `m`.
> >>>>
> >>>> In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.
> >>>>
> >>>> Cc: Kim Phillips <kim.phillips@arm.com>
> >>>> Signed-off-by: Florian Klink <flokli@flokli.de>    
> >>>
> >>> LGTM, this is the fixes tag right?
> >>>
> >>> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")    
> >>
> >> yep.
> >>  
> >>>
> >>> CCing David to give him a chance to ack.    
> >>
> >> Reviewed-by: David Ahern <dsahern@kernel.org>  
> > 
> > Great, applied, thanks!
> >   
> >> I looked at this yesterday and got distracted diving into the generated
> >> file to see the difference:
> >>
> >> #define CONFIG_IPV6 1
> >>
> >> vs
> >>
> >> #define CONFIG_IPV6_MODULE 1  
> 
> Digging up ancient history. ;)
> 
> > Interesting.
> > 
> > drivers/net/ethernet/netronome/nfp/flower/action.c:#ifdef CONFIG_IPV6
> > 
> > Oops.  
> 
> Notify the maintainer!

The joke was that I was the maintainer when it was added ;)

CCing Simon
