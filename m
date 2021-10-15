Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C242EAB0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbhJOH5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhJOH5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:57:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2393C061570;
        Fri, 15 Oct 2021 00:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+s4DkuJzbd93nRi4ilegPIH9sOXH6/eoHaUfmFKjyfI=; b=RqMZ8GyIYYcgnSr27St+djU57e
        r++o9EoFVz6kcPXf0UkIgMhpFsUpXooMEmwj+0+IuQUlPI7yPprh3UVN8wNgX+JS4SR5lioqBKnyQ
        rsKLkNDSLFAPN+XIqeAiU+MalorcTOfHHboDPJJdy0pi7utAI9ZgwSEXNT77bi+DXjNcBjdt/NOrv
        g2g+icoSoc/YZLpTcN7xbs2T94Ilx/+T3Gjm0S5Tm0Sh+2/q1Yy964cIyaXqCtDnCk73UhKvbJXwL
        IT6sDo9kzK/EZKEAfaHUN84KT5D0hrVle4v1QTf17ku3rV8Dgzojc8+Awv+2TBoYSMngvkOiMHLWE
        YQ3283Wg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55126)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mbI3E-0002AK-6o; Fri, 15 Oct 2021 08:54:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mbI3B-0002wu-Qm; Fri, 15 Oct 2021 08:54:45 +0100
Date:   Fri, 15 Oct 2021 08:54:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v2 05/13] net: phy: add qca8081 ethernet phy driver
Message-ID: <YWkzxd7xzTDngoT9@shell.armlinux.org.uk>
References: <20211015073505.1893-1-luoj@codeaurora.org>
 <20211015073505.1893-6-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015073505.1893-6-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 03:34:57PM +0800, Luo Jie wrote:
> @@ -1431,6 +1433,18 @@ static struct phy_driver at803x_driver[] = {
>  	.get_sset_count = at803x_get_sset_count,
>  	.get_strings = at803x_get_strings,
>  	.get_stats = at803x_get_stats,
> +}, {
> +	/* Qualcomm QCA8081 */
> +	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
> +	.name			= "Qualcomm QCA8081 PHY",

I don't think we need the " PHY" suffix. This name gets printed in a
context where it's obvious it's a network PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
