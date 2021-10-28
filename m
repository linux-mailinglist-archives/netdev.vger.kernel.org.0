Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6343E490
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJ1PIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhJ1PIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C388D61038;
        Thu, 28 Oct 2021 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635433569;
        bh=MS1scbmuF1tyOfvIezMFF707hVjRtjPcMDr3B6srUto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hlqDYdRCT+7olX6D60Qo/LCiG894cbWqxvyD7nrKUNLPwSq2ibT+cnS1M2Z+8POlT
         aC5fzrTxXeYuAeOLCs1+2sMVwuTk4Uo2A9u7OeNhXnV0y/96YYFGiot2nDJ2iUdiuZ
         LY5zMcFELnHFCEu8lpn10KafSYFkchg5EyU8pF5SMYCQ5NLfb961ifbbT4t1PB8X/v
         Rwq5Vn6mLjuF0ysbc+csVJKevgjTifO6UOqB4vBhDZuX/wezEpJj1n7ao9OzpGqrWx
         hbcQQZoUMzpu+bAoMHOkk+261arAokX2oE9FbDSvfhTI/FkAhT0FwMrDov4Y/BXl3A
         ebMROjI02mdew==
Date:   Thu, 28 Oct 2021 08:06:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: avoid mvneta warning when setting
 pause parameters
Message-ID: <20211028080607.6226a83a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
References: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 15:55:34 +0100 Russell King (Oracle) wrote:
> mvneta does not support asymetric pause modes, and it flags this by the
> lack of AsymPause in the supported field. When setting pause modes, we
> check that pause->rx_pause == pause->tx_pause, but only when pause
> autoneg is enabled. When pause autoneg is disabled, we still allow
> pause->rx_pause != pause->tx_pause, which is incorrect when the MAC
> does not support asymetric pause, and causes mvneta to issue a warning.
> 
> Fix this by removing the test for pause->autoneg, so we always check
> that pause->rx_pause == pause->tx_pause for network devices that do not
> support AsymPause.

Fixes..?
