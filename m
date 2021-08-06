Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B273E23EA
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbhHFHVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:21:45 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:54937 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243567AbhHFHVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:21:42 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A4FC322239;
        Fri,  6 Aug 2021 09:21:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1628234483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUttS+GWKev5a88nTDm24dqUBW82rfvG+Q3c4z0QO88=;
        b=nu40klJT1csH3kR8IjmlldQTAWXDw1SUSXLvu4c1EYFy19zY44ErCxbJPkWXi5VvUz28mY
        ip1NxyQMQmyhc4Q0aKImd/K+KmT3OD1aDe6crqws+Z+nnHRruJISp2t+XNp07U3HD914/G
        tkH1zPW3fcGKSwzjVEhy5m5LJAvLhbM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Aug 2021 09:21:17 +0200
From:   Michael Walle <michael@walle.cc>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] ARM: kirkwood: add missing <linux/if_ether.h> for
 ETH_ALEN
In-Reply-To: <YQxk4jrbm31NM1US@makrotopia.org>
References: <YQxk4jrbm31NM1US@makrotopia.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cde9de20efd3a75561080751766edbec@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2021-08-06 00:23, schrieb Daniel Golle:
> After commit 83216e3988cd1 ("of: net: pass the dst buffer to
> of_get_mac_address()") build fails for kirkwood as ETH_ALEN is not
> defined.
> 
> arch/arm/mach-mvebu/kirkwood.c: In function 'kirkwood_dt_eth_fixup':
> arch/arm/mach-mvebu/kirkwood.c:87:13: error: 'ETH_ALEN' undeclared
> (first use in this function); did you mean 'ESTALE'?
>    u8 tmpmac[ETH_ALEN];
>              ^~~~~~~~
>              ESTALE
> arch/arm/mach-mvebu/kirkwood.c:87:13: note: each undeclared identifier
> is reported only once for each function it appears in
> arch/arm/mach-mvebu/kirkwood.c:87:6: warning: unused variable 'tmpmac'
> [-Wunused-variable]
>    u8 tmpmac[ETH_ALEN];
>       ^~~~~~
> make[5]: *** [scripts/Makefile.build:262:
> arch/arm/mach-mvebu/kirkwood.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
> 
> Add missing #include <linux/if_ether.h> to fix this.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Michael Walle <michael@walle.cc>
> Reported-by:
> https://buildbot.openwrt.org/master/images/#/builders/56/builds/220/steps/44/logs/stdio
> Fixes: 83216e3988cd1 ("of: net: pass the dst buffer to 
> of_get_mac_address()")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

What kernel is this? I've just tested with this exact commit as
base and it compiles just fine.

I'm not saying including the file is wrong, but it seems it isn't
needed in the upstream kernel and I don't know if it qualifies for
the stable queue therefore.

-michael
