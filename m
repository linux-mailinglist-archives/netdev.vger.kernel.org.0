Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230F13E86DE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhHJX4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:56:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:23916 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235502AbhHJX4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 19:56:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="276054952"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="276054952"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 16:55:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="421996902"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 10 Aug 2021 16:55:36 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 42F28580922;
        Tue, 10 Aug 2021 16:55:32 -0700 (PDT)
Date:   Wed, 11 Aug 2021 07:55:29 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Message-ID: <20210810235529.GB30818@linux.intel.com>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
 <YREvDRkiuScyN8Ws@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YREvDRkiuScyN8Ws@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
On Mon, Aug 09, 2021 at 03:35:09PM +0200, Andrew Lunn wrote:
> On Mon, Aug 09, 2021 at 06:22:28PM +0800, Wong Vee Khee wrote:
> > From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> > 
> > Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
> > all the SerDes PLL configurations are controlled by the xPCS at the BIOS
> > level. If the driver perform a xPCS soft reset on initialization, these
> > settings will be switched back to the power on reset values.
> > 
> > This changes the xpcs_create function to take in an additional argument
> > to check if the platform request to skip xPCS soft reset during device
> > initialization.
> 
> Why not just call into the BIOS and ask it to configure the SERDES?
> Isn't that what ACPI is all about, hiding the details from the OS? Or
> did the BIOS writers not add a control method to do this?
> 
>     Andrew

BIOS does configured the SerDes. The problem here is that all the
configurations done by BIOS are being reset at xpcs_create().

We would want user of the pcs-xpcs module (stmmac, sja1105) to have
control whether or not we need to perform to the soft reset in the
xpcs_create() call.

Hope that explained.

Regards,
 VK
