Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9D368962
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbhDVXde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:33:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVXdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:33:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZioX-000YlM-A7; Fri, 23 Apr 2021 01:32:53 +0200
Date:   Fri, 23 Apr 2021 01:32:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YIIHpfW4nF/H/GJe@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void lan937x_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
> +			      u64 *cnt)
> +{
> +	unsigned int val;
> +	u32 data;
> +	int ret;
> +
> +	/* Enable MIB Counter read*/
> +	data = MIB_COUNTER_READ;
> +	data |= (addr << MIB_COUNTER_INDEX_S);
> +	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, data);
> +
> +	ret = regmap_read_poll_timeout(dev->regmap[2],
> +				       PORT_CTRL_ADDR(port,
> +						      REG_PORT_MIB_CTRL_STAT__4),
> +					   val, !(val & MIB_COUNTER_READ), 10, 1000);
> +	/* failed to read MIB. get out of loop */

Another loop which is not a loop. Please review your comments and
check they make sense.

      Andrew
