Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0CC27386
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfEWAoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:44:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730325AbfEWAoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:44:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FAB114577841;
        Wed, 22 May 2019 17:44:16 -0700 (PDT)
Date:   Wed, 22 May 2019 17:44:15 -0700 (PDT)
Message-Id: <20190522.174415.819566506731031282.davem@davemloft.net>
To:     tpiepho@impinj.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 4/8] net: phy: dp83867: Rework delay rgmii
 delay handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522184255.16323-4-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
        <20190522184255.16323-4-tpiepho@impinj.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:44:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trent Piepho <tpiepho@impinj.com>
Date: Wed, 22 May 2019 18:43:23 +0000

> The code was assuming the reset default of the delay control register
> was to have delay disabled.  This is what the datasheet shows as the
> register's initial value.  However, that's not actually true: the
> default is controlled by the PHY's pin strapping.
> 
> If the interface mode is selected as RX or TX delay only, insure the
> other direction's delay is disabled.
> 
> If the interface mode is just "rgmii", with neither TX or RX internal
> delay, one might expect that the driver should disable both delays.  But
> this is not what the driver does.  It leaves the setting at the PHY's
> strapping's default.  And that default, for no pins with strapping
> resistors, is to have delay enabled and 2.00 ns.
> 
> Rather than change this behavior, I've kept it the same and documented
> it.  No delay will most likely not work and will break ethernet on any
> board using "rgmii" mode.  If the board is strapped to have a delay and
> is configured to use "rgmii" mode a warning is generated that "rgmii-id"
> should have been used.
> 
> Also validate the delay values and fail if they are not in range.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Applied.
