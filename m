Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD42495017
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346025AbiATO1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:27:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345906AbiATO1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QlRBgHDtH1t8t3EKEvfJ1X6FtsLtUv3emyzOJ4rrF8c=; b=EToP8Dsc/LNXw9PN7LInKXnVPB
        weZbLFelE1F4KTy9N6+Yc7UFwhTaru4lCpWNwDjzTh4FJ0Wavrz8Nj5kOyodedk/BQNEqlkdXIeWA
        YuM84KiVWJY9cC7IUGEBMDhmxmkH8KS71fEaVlXH1zrfbhJ2hNyRfC6Z/mp6BVSnxfz8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAYOu-001zuH-KQ; Thu, 20 Jan 2022 15:26:56 +0100
Date:   Thu, 20 Jan 2022 15:26:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YelxMFOiqnfIVmyy@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
> BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> instead of setting another value, keep it untouched and restore the saved
> value on system resume.
> 
> Introduce config_led() callback in phy_driver() to make the implemtation
> generic.

I'm also wondering if we need to take a step back here and get the
ACPI guys involved. I don't know much about ACPI, but shouldn't it
provide a control method to configure the PHYs LEDs?

We already have the basics for defining a PHY in ACPI. See:

https://www.kernel.org/doc/html/latest/firmware-guide/acpi/dsd/phy.html

so you could extend this to include a method to configure the LEDs for
a specific PHY.

  Andrew
