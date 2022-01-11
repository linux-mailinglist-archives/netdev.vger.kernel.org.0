Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A658448AAEF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348389AbiAKJ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 04:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348351AbiAKJ4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:56:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D086C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5JOKzPtTz8O8TTRM2hK3co42J8kT60lyhYSXAyJ2Ock=; b=bMpyAkXjgLqV9HfHr6+XlHyjfV
        joS4Wp0kOfqgeq6JF4x6cNvj3gwaxTbkvZeuWQM7vSLGaM2IV8EStTCu1z9VP/V6bzt94X7wIyS9e
        SkU1wTqywHeE6eayjr1c/YKBoxJv6cppHGJXQZD9/q/fEbCYR/NaDNmkrdj+I0AoQ3h2XvLF+hx2z
        DNj4P29RzTz2s8XdR4hCKAon0Vb74J6LKBpQP3ms7fhzu6g9H2uutkfcvMqSU+eUCQ+tLEfR5YAbo
        dXZ5APjdLQi2CEZ7dQ2pRp7uouETqDfqrT5lYoNCkyiBsifZqTIU1Icl9NDqxV3eNAiUhJyNQfp/o
        2UQXclSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56660)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n7Dt0-0004ey-Rr; Tue, 11 Jan 2022 09:56:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n7Dsy-0005pq-5I; Tue, 11 Jan 2022 09:56:12 +0000
Date:   Tue, 11 Jan 2022 09:56:12 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Message-ID: <Yd1UPIVsQfshafop@shell.armlinux.org.uk>
References: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
 <YdhDAHxFaUhiQFbd@shell.armlinux.org.uk>
 <AM9PR04MB83977DD63CD3DB191E79DC7D96509@AM9PR04MB8397.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB83977DD63CD3DB191E79DC7D96509@AM9PR04MB8397.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 05:37:55PM +0000, Claudiu Manoil wrote:
> Hi Russell,
> 
> drivers/net/ethernet/freescale/enetc/enetc_pf.c: In function 'enetc_pl_mac_select_pcs':
> drivers/net/ethernet/freescale/enetc/enetc_pf.c:942:27: error: 'struct phylink_pcs' has no member named 'pcs'
>   942 |  return pf->pcs ? &pf->pcs->pcs : NULL;
> 
> I suppose you meant:
> -       return pf->pcs ? &pf->pcs->pcs : NULL;
> +       return pf->pcs;
> 
> With this correction I could bring up the SGMII link on my ls1028rdb.

Thanks.

> The patch needs also rebase.

Yes, due to other patches have been merged into net-next since the patch
was sent for testing. However, now is not the time to be sending it for
net-next as the merge window is open, so there's little point rebasing
it until after the merge window has closed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
