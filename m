Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED841D025
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbhI2XuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347701AbhI2XuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 19:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0662261406;
        Wed, 29 Sep 2021 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632959321;
        bh=6LGCRh2a54DE+4CW/D1vYpAnD2PLO1BmCnkStylPMnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6Uld0klJBeQAccFUpZNUUa4ictS2UsaIv8lXRNjCnEJtOynhTiY7g9kIzSy52Bo5
         ZU6CXTs4ZvC7pxUMH7YwKzsrbX46NVY55FmNsul/ybAuezX4D4tAQ/pwqhGCvUnQ0l
         Hvv8LW6dJxy6YiiAyhKQxymRVBhPvnBCuwI1//Ie2t+4nTEMsniBkwtIKCEtjof47E
         Ifo9Et1EoyDehvM2A39rasM+zDniK6fxPuVJvf+LCA7NfaHu2jMI0qoUq/pWh+XEfM
         7nC0dCgjbdrZpk1gawwdLGUPqLRtmxVmgnh2JtnlxwpDwSjrtJoSGvgSdC64AzTn/G
         8EtD4RqK9VzTQ==
Date:   Wed, 29 Sep 2021 16:48:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, buytenh@marvell.com, afleming@freescale.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] phy: mdio: fix memory leak
Message-ID: <20210929164840.76afdec8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
References: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
        <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Sep 2021 23:40:15 +0300 Pavel Skripkin wrote:
> +	/* We need to set state to MDIOBUS_UNREGISTERED to correctly realese
> +	 * the device in mdiobus_free()
> +	 *
> +	 * State will be updated later in this function in case of success
> +	 */
> +	bus->state == MDIOBUS_UNREGISTERED;

IDK how syzbot has tested it but clearly we should blindly 
depend on that.

s/==/=/

Compiler would have told you this.
