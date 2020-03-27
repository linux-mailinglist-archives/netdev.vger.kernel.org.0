Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F22194F32
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgC0Cnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:43:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Cnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:43:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B19C15CE4E1C;
        Thu, 26 Mar 2020 19:43:48 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:43:46 -0700 (PDT)
Message-Id: <20200326.194346.703735533771589560.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: probe PHY drivers synchronously
From:   David Miller <davem@davemloft.net>
In-Reply-To: <612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com>
References: <612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:43:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 27 Mar 2020 01:00:22 +0100

> If we have scenarios like
> 
> mdiobus_register()
> 	-> loads PHY driver module(s)
> 	-> registers PHY driver(s)
> 	-> may schedule async probe
> phydev = mdiobus_get_phy()
> <phydev action involving PHY driver>
> 
> or
> 
> phydev = phy_device_create()
> 	-> loads PHY driver module
> 	-> registers PHY driver
> 	-> may schedule async probe
> <phydev action involving PHY driver>
> 
> then we expect the PHY driver to be bound to the phydev when triggering
> the action. This may not be the case in case of asynchronous probing.
> Therefore ensure that PHY drivers are probed synchronously.
> 
> Default still is sync probing, except async probing is explicitly
> requested. I saw some comments that the intention is to promote
> async probing for more parallelism in boot process and want to be
> prepared for the case that the default is changed to async probing.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
