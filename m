Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FE7126F22
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfLSUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:50:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSUuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:50:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C984153A9D54;
        Thu, 19 Dec 2019 12:50:12 -0800 (PST)
Date:   Thu, 19 Dec 2019 12:50:10 -0800 (PST)
Message-Id: <20191219.125010.1105219757379875134.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 12:50:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 17 Dec 2019 12:53:05 +0000

> phy_error() is called from phy_interrupt() or phy_state_machine(), and
> uses WARN_ON() to print a backtrace. The backtrace is not useful when
> reporting a PHY error.
> 
> However, a system may contain multiple ethernet PHYs, and phy_error()
> gives no clue which one caused the problem.
> 
> Replace WARN_ON() with a call to phydev_err() so that we can see which
> PHY had an error, and also inform the user that we are halting the PHY.
> 
> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

I think I agree with Heiner that it is valuable to know whether the
error occurred from the interrupt handler or the state machine (and
if the state machine, where that got called from).

So I totally disagree with removing the backtrace, sorry.
