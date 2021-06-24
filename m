Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A663B2537
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFXC6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:58:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:15767 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXC6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 22:58:33 -0400
IronPort-SDR: /c09j9racwkajhn+fYOwHiYcU4gpl8BFRzHewQWByqS1HikOPNNxm1C8g2nlAnveec6qJxpMYs
 ctCEOQsn55xg==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="293012451"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="293012451"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 19:56:14 -0700
IronPort-SDR: xtb9n9qEL3B0fL6bYOm7ZIMzNjHxBFRLJbmWtIhVhK0xo4O+EIGm1id8xJIFD+V9MYWUATH02j
 kPcytLF1LlJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="474351170"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jun 2021 19:56:13 -0700
Received: from linux.intel.com (vwong3-ilbpg3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 109A058060A;
        Wed, 23 Jun 2021 19:56:10 -0700 (PDT)
Date:   Thu, 24 Jun 2021 10:56:07 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Ling Pei Lee <pei.lee.ling@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        vee.khee.wong@intel.com
Subject: Re: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210624025607.GA21875@linux.intel.com>
References: <20210623130929.805559-1-pei.lee.ling@intel.com>
 <20210623233854.03ed9240@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623233854.03ed9240@thinkpad>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Wed, Jun 23, 2021 at 11:38:54PM +0200, Marek Behun wrote:
> On Wed, 23 Jun 2021 21:09:29 +0800
> Ling Pei Lee <pei.lee.ling@intel.com> wrote:
> 
> > +		/* Enable the WOL interrupt */
> > +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> > +				       MV_V2_PORT_INTR_MASK,
> > +				       MV_V2_WOL_INTR_EN);
> > +
> > +		if (ret < 0)
> > +			return ret;
> 
> Hi, in addition to what Russell said, please remove the extra newline
> between function call and return value check, i.e. instead of
>   ret = phy_xyz(...);
> 
>   if (ret)
>      return ret;
> 
>   ret = phy_xyz(...);
> 
>   if (ret)
>      return ret;
> 
> do
>   ret = phy_xyz(...);
>   if (ret)
>      return ret;
> 
>   ret = phy_xyz(...);
>   if (ret)
>      return ret;
> 
> This is how this driver does this everywhere else.
> 
> Do you have a device that uses this WoL feature?
>

Yes. We have Intel Elkhart Lake platform with Integrated Sypnosys MAC
controller(STMMAC) paired with External PHY device (in this case the
Marvell Alaska 88E2110).

BR,
 VK

