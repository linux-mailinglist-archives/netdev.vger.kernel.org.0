Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1974327DD3E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgI3AJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgI3AJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:09:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06BB5206CD;
        Wed, 30 Sep 2020 00:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601424590;
        bh=w0adgeog+0dkgFliFwGKJWbgBzEgbKMRsAfJ2/EnKek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2Mb1+E02RyUL45D5D7qfUyXF5tOVwgye5zV/LyRkgG5pYAlbT0CFG1xjv5ci3BUmV
         MLZcftCL/tMgBnX+SA7sBgv99wViTdudP/OjARIdtKcunrU+7BKVsA15UxIt1XUAlZ
         FpH5ESMduyAEVupggefUftlIbBTK6F7wxi8xY1bU=
Date:   Tue, 29 Sep 2020 17:09:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] net: atlantic: phy tunables from mac
 driver
Message-ID: <20200929170948.545826c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929184723.GE3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
        <20200929170413.GA3996795@lunn.ch>
        <20200929103320.6a5de6f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200929184723.GE3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 20:47:23 +0200 Andrew Lunn wrote:
> > Do you mean report supported range via extack?  
> 
> Yes.
> 
> 811ac400ea33 ("net: phy: dp83869: Add speed optimization feature")
> 
> was merged recently. It has:
> 
> +       default:
> +               phydev_err(phydev,
> +                          "Downshift count must be 1, 2, 4 or 8\n");
> +               return -EINVAL;
> 
> and there are more examples in PHY drivers where it would be good to
> tell the uses what the valid values are. I guess most won't see this
> kernel message, but if netlink ethtool printed:
> 
> Invalid Argument: Downshift count must be 1, 2, 4 or 8
> 
> it would be a lot more user friendly.

Ah, now I recall, we already discussed this.

FWIW we could provision for the extack and just pass NULL for now?
Would that be too ugly?
