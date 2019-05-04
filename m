Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3B1378A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfEDEsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:48:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfEDEsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:48:20 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1119714D97234;
        Fri,  3 May 2019 21:48:15 -0700 (PDT)
Date:   Sat, 04 May 2019 00:48:11 -0400 (EDT)
Message-Id: <20190504.004811.237662972933481916.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: improve pause handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d437c5d8-e683-4d69-7818-c6f69053bc02@gmail.com>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
        <d437c5d8-e683-4d69-7818-c6f69053bc02@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:48:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 1 May 2019 21:34:43 +0200

> When probing the phy device we set sym and asym pause in the "supported"
> bitmap (unless the PHY tells us otherwise). However we don't know yet
> whether the MAC supports pause. Simply copying phy->supported to
> phy->advertising will trigger advertising pause, and that's not
> what we want. Therefore add phy_advertise_supported() that copies all
> modes but doesn't touch the pause bits.
> 
> In phy_support_(a)sym_pause we shouldn't set any bits in the supported
> bitmap because we may set a bit the PHY intentionally disabled.
> Effective pause support should be the AND-combined PHY and MAC pause
> capabilities. If the MAC supports everything, then it's only relevant
> what the PHY supports. If MAC supports sym pause only, then we have to
> clear the asym bit in phydev->supported.
> Copy the pause flags only and don't touch the modes, because a driver
> may have intentionally removed a mode from phydev->advertising.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - removed patch 2 from the series

Applied.
