Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B64288C5C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbgJIPPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388533AbgJIPPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:15:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A329C222E8;
        Fri,  9 Oct 2020 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602256534;
        bh=RgMQBwpmy5MlFcvUkDn9qO1CvId+AKtihNUN6+5xg0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1j5wnR3gDaSWnXjPA6d1kqWTsfqE70x5q0VL0gWPU55p+U7itn+pjKaBunSjMO7Li
         6aaSQtqPOhJlGfpSzDtCEV9/CO/sExbwM9bUteJ8nI+LVDOpCm1fAmROrKrFkgNtO2
         MLjbZi/XCnGEgUHbCkVywAA/LE7LN4dwZEbnGhBM=
Date:   Fri, 9 Oct 2020 08:15:32 -0700
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
Message-ID: <20201009081532.30411d62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <da024643-e7bc-3470-64ad-96277655f494@denx.de>
References: <20201006202029.254212-1-marex@denx.de>
        <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
        <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
        <20201008174619.282b3482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <da024643-e7bc-3470-64ad-96277655f494@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 09:20:30 +0200 Marek Vasut wrote:
> > Can you describe your problem in detail?  
> 
> Yes, I tried to do that in the commit message and the extra detailed
> comment above the code. What exactly do you not understand from that?

Why it's not bound on the first open (I'm guessing it's the first open
that has the ndev->phydev == NULL? I shouldn't have to guess).

> > To an untrained eye this looks pretty weird.  
> 
> I see, I'm not quite sure how to address this comment.

If ndev->phydev sometimes is not-NULL on open, then that's a valid
state to be in. Why not make sure that we're always in that state 
and can depend on ndev->phydev rather than rummaging around for 
the phy_device instance.
