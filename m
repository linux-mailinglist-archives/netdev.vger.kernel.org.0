Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CE318928
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBKLMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhBKLJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:09:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958E8C061786;
        Thu, 11 Feb 2021 03:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v7B7fHaW3Pp4ZozkuVSMVbnsnAHO8uAyG66cNYc6odE=; b=PoyX2SqGSZloO83H2r4Lv2qQw
        gUZDFSKrKQaoILac4/+411OM9BpxjKH8U3cvAy8a5aWGKpIAhEFFbrSvbC9yui7iq+7ZZGLV6zCpg
        4QU1IlbVa8uL04CB8d9bczbZj8Nex8eBkUjtaGO2FFovXEVNYP/d89MTzvbyIloanQ1lGix19m7Is
        y20gAPrMtBalJ4tzQLAILBqAxcz9zCguhruaxAZnUo3pWWOqYaUnh0P4aM23WvbEit4PjHDBkQDxZ
        nxuH2WD9I/KJbjBxjK9CiFNgAwTBstXZYFV7Tx8JH4gF3bzq//RT1m3tzGnxQodgh4b9MCgvYxCUy
        pgoCGzFaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41990)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lA9pS-00061k-NH; Thu, 11 Feb 2021 11:08:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lA9pR-00061W-Qj; Thu, 11 Feb 2021 11:08:09 +0000
Date:   Thu, 11 Feb 2021 11:08:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 04/15] net: mvpp2: always compare hw-version
 vs MVPP21
Message-ID: <20210211110809.GB1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-5-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-5-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:51PM +0200, stefanc@marvell.com wrote:
> @@ -1199,7 +1199,7 @@ static bool mvpp2_port_supports_xlg(struct mvpp2_port *port)
>  
>  static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
>  {
> -	return !(port->priv->hw_version == MVPP22 && port->gop_id == 0);
> +	return !(port->priv->hw_version != MVPP21 && port->gop_id == 0);

I'm still very much of the opinion (as raised several revisions back)
that using > MVPP21 or >= MVPP22 would be a lot better - especially
when we have situations like this. Having negatives within negatives
does not help readability.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
