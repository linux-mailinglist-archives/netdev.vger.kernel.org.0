Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0209174BDB
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCAFq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:46:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgCAFq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:46:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6001C15BDA6D6;
        Sat, 29 Feb 2020 21:46:57 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:46:56 -0800 (PST)
Message-Id: <20200229.214656.1463089628684062690.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix lockup on warm boot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j7lU5-0003px-JX@rmk-PC.armlinux.org.uk>
References: <E1j7lU5-0003px-JX@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:46:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 28 Feb 2020 19:39:41 +0000

> If the switch is not hardware reset on a warm boot, interrupts can be
> left enabled, and possibly pending. This will cause us to enter an
> infinite loop trying to service an interrupt we are unable to handle,
> thereby preventing the kernel from booting.
> 
> Ensure that the global 2 interrupt sources are disabled before we claim
> the parent interrupt.
> 
> Observed on the ZII development revision B and C platforms with
> reworked serdes support, and using reboot -f to reboot the platform.
> 
> Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable, thanks.
