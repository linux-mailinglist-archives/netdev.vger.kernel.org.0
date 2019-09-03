Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533B6A7212
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfICSAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 14:00:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45889 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICSAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 14:00:16 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1i5D6A-00011R-80; Tue, 03 Sep 2019 14:00:10 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x83HoNAS011808;
        Tue, 3 Sep 2019 13:50:23 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x83HoEDt011805;
        Tue, 3 Sep 2019 13:50:14 -0400
Date:   Tue, 3 Sep 2019 13:50:14 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH 0/4] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
Message-ID: <20190903175014.GB29528@tuxdriver.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 07:06:22PM +0300, Alexandru Ardelean wrote:
> This patch series is actually 2 series in 1.
> 
> First 2 patches implement the kernel support for controlling Energy Detect
> Powerdown support via phy-tunable, and the next 2 patches implement the
> ethtool user-space control.
> Hopefully, this combination of 2 series is an acceptable approach; if not,
> I am fine to re-update it based on feedback.

I understand your reasoning, but do keep in mind that userland ethtool
and the kernel are managed in different git trees. Seperate patchsets
would be preferable in general, although in some cases having an
initial userland implementation to show against proposed kernel
changes could be helpful.

It would not be unusual for someone to ask for changes on the kernel
patches. If that happens, just repost the kernel changes until you get
a final merge. Once that happens, then repost the userland patches as
a seperate patchset. But I'll keep an eye here -- if Dave merges the
existing kernel patches as-is, I can take the already posted patchs
(unless problems are found in code review).

John
 
> The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
> this feature is common across other PHYs (like EEE), and defining
> `ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.
>     
> The way EDPD works, is that the RX block is put to a lower power mode,
> except for link-pulse detection circuits. The TX block is also put to low
> power mode, but the PHY wakes-up periodically to send link pulses, to avoid
> lock-ups in case the other side is also in EDPD mode.
>     
> Currently, there are 2 PHY drivers that look like they could use this new
> PHY tunable feature: the `adin` && `micrel` PHYs.
> 
> This series updates only the `adin` PHY driver to support this new feature,
> as this chip has been tested. A change for `micrel` can be proposed after a
> discussion of the PHY-tunable API is resolved.
> 
> -- 
> 2.20.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
