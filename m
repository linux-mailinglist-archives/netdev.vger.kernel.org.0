Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9C294E3F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443240AbgJUOIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:08:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440702AbgJUOIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 10:08:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVEnM-002pJA-It; Wed, 21 Oct 2020 16:08:52 +0200
Date:   Wed, 21 Oct 2020 16:08:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexaundru.ardelean@analog.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, ardeleanalex@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH 2/2] net: phy: adin: implement cable-test support
Message-ID: <20201021140852.GN139700@lunn.ch>
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135140.51300-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021135140.51300-2-alexandru.ardelean@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Hi Alexandru

Overall, this looks good.

> +static int adin_cable_test_report_trans(int result)
> +{
> +	int mask;
> +
> +	if (result & ADIN1300_CDIAG_RSLT_GOOD)
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	if (result & ADIN1300_CDIAG_RSLT_OPEN)
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> +
> +	/* short with other pairs */
> +	mask = ADIN1300_CDIAG_RSLT_XSHRT3 |
> +	       ADIN1300_CDIAG_RSLT_XSHRT2 |
> +	       ADIN1300_CDIAG_RSLT_XSHRT1;
> +	if (result & mask)
> +		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;

The nice thing about the netlink API is that it is extendable without
breaking backwards compatibility. You could if you want add another
attribute, indicating what pair it is shorted to.

	Andrew
