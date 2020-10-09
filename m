Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8AB289078
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbgJISCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390309AbgJISCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:02:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A77C2158C;
        Fri,  9 Oct 2020 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602266553;
        bh=+Qlo7BolLAP9m6Ffv6w+9hC2SebSQMTwGubJY69Tx9E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mbunbG2gaaeqfcH+fWpSY1NoZwW31I8jJwez6dTIwDm5xAGRyB3PMkjgRpztRsPWG
         eIyR4HXu5q9WqX+kkYE4JKkwOJi4Ql9bQFfZ8ClEimiCFYP4T+DZmorb2BdWM5fqIQ
         7YkJtFbbpKbZOn4Ui1I4icCrVwIEP/g3U6HBJOWA=
Date:   Fri, 9 Oct 2020 11:02:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
Message-ID: <20201009110230.3d8693df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6b8ec5fe-ca93-d2cf-3060-4f087fcdc85a@denx.de>
References: <20201006202029.254212-1-marex@denx.de>
        <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
        <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
        <20201008174619.282b3482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <da024643-e7bc-3470-64ad-96277655f494@denx.de>
        <20201009081532.30411d62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6b8ec5fe-ca93-d2cf-3060-4f087fcdc85a@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 19:34:10 +0200 Marek Vasut wrote:
> >>> To an untrained eye this looks pretty weird.    
> >>
> >> I see, I'm not quite sure how to address this comment.  
> > 
> > If ndev->phydev sometimes is not-NULL on open, then that's a valid
> > state to be in. Why not make sure that we're always in that state 
> > and can depend on ndev->phydev rather than rummaging around for 
> > the phy_device instance.  
> 
> Nope, the problem is in probe() in this case.

In that case it would be cleaner to pass fep and phydev as arguments
into fec_enet_clk_enable(), rather than netdev, and have only probe()
do the necessary dance.
