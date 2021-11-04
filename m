Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A077445975
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhKDSSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhKDSSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 14:18:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B809C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=44JK5jZSdaEoySOJK+3VMsxP4//qzIt8zzR6/J4I3FQ=; b=JM5N/S30PrczUVBWyFCthDWeG2
        H2FWGtgihP5Qj/xiqQyg3ugsyW92Y88eHBAN1uO52OyfWWo10vjtzn51f0nFJK8hO5FQ9J+0e4/iK
        JjwP20rnmsolQDWbae2yogouFe4iA5S3MNpQnK/efMrdc08n7PwR3n2IN3YCju+1A3EHHETbs3iEt
        /TGrpMFLDmNb5p5zCOG2HiOT0BvwZ7b+cYaEMiDbXdDzfCea9esEWKip5MeYy4/oIk9mGwhIxniry
        qYnJTcL2ZJIAeEWIZwovL/9hlJMULgWbOSee7u8lvmNAefVuza+msWI9rTWcAEv8JcgNHTEgDyOuB
        Rq2BxYkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55486)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mihHL-0006Dc-5Z; Thu, 04 Nov 2021 18:15:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mihHK-0007Wi-0M; Thu, 04 Nov 2021 18:15:58 +0000
Date:   Thu, 4 Nov 2021 18:15:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Don't support >1G speeds on
 6191X on ports other than 10
Message-ID: <YYQjXVsLTRsTBBHa@shell.armlinux.org.uk>
References: <20211104171747.10509-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104171747.10509-1-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 06:17:47PM +0100, Marek Behún wrote:
> Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
> only 1G.

Interesting. The original commit says:

SERDESes can do USXGMII, 10GBASER and 5GBASER (on 6191X only one
SERDES is capable of more than 1g; USXGMII is not yet supported
with this change)

which is ambiguously worded - so I guess we now know that it's only
port 10 that supports speeds above 1G.

Can ports 0 / 1 / 10 be changed at runtime (iow, is the C_Mode field
writable on these ports?)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
