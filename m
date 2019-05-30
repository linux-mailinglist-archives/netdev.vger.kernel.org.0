Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A629B2F5AF
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfE3EtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:49:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfE3EtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:49:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FF5213AEF256;
        Wed, 29 May 2019 21:49:21 -0700 (PDT)
Date:   Wed, 29 May 2019 21:49:20 -0700 (PDT)
Message-Id: <20190529.214920.1942054615874126394.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/11] Decoupling PHYLINK from struct
 net_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:49:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Tue, 28 May 2019 20:38:06 +0300

> Following two separate discussion threads in:
>   https://www.spinics.net/lists/netdev/msg569087.html
> and:
>   https://www.spinics.net/lists/netdev/msg570450.html
> 
> Previous RFC patch set: https://www.spinics.net/lists/netdev/msg571995.html
> 
> PHYLINK was reworked in order to accept multiple operation types,
> PHYLINK_NETDEV and PHYLINK_DEV, passed through a phylink_config
> structure alongside the corresponding struct device.
> 
> One of the main concerns expressed in the RFC was that using notifiers
> to signal the corresponding phylink_mac_ops would break PHYLINK's API
> unity and that it would become harder to grep for its users.
> Using the current approach, we maintain a common API for all users.
> Also, printing useful information in PHYLINK, when decoupled from a
> net_device, is achieved using dev_err&co on the struct device received
> (in DSA's case is the device corresponding to the dsa_switch).
> 
> PHYLIB (which PHYLINK uses) was reworked to the extent that it does not
> crash when connecting to a PHY and the net_device pointer is NULL.
> 
> Lastly, DSA has been reworked in its way that it handles PHYs for ports
> that lack a net_device (CPU and DSA ports).  For these, it was
> previously using PHYLIB and is now using the PHYLINK_DEV operation type.
> Previously, a driver that wanted to support PHY operations on CPU/DSA
> ports has to implement .adjust_link(). This patch set not only gives
> drivers the options to use PHYLINK uniformly but also urges them to
> convert to it. For compatibility, the old code is kept but it will be
> removed once all drivers switch over.
 ...

Series applied, thank you.
