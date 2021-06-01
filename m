Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112793971CA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhFAKtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:49:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:16965 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhFAKtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 06:49:21 -0400
IronPort-SDR: +871oqcBKBUXNQaxC01aDNGFR6KYAsegNUpwo+Ww4MatVUDSBMQ1hA6mmsyvwfzzHaQjZJjFDq
 l/TD9t3srhNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="264704884"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="264704884"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 03:47:39 -0700
IronPort-SDR: 4dz5RWE3XnQmA2D6YORw1o99YC7CHNzPDp/4/z3HvfNreZaDZNh+ASlL+6LhcBfk2sJXLGXbHE
 wazFijaQATsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="445285860"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 01 Jun 2021 03:47:39 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A2F245807FC;
        Tue,  1 Jun 2021 03:47:37 -0700 (PDT)
Date:   Tue, 1 Jun 2021 18:47:34 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210601104734.GA18984@linux.intel.com>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKz86iMwoP3VT4uh@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 03:34:34PM +0200, Andrew Lunn wrote:
> On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> > Synopsys MAC controller is capable of pairing with external PHY devices
> > that accessible via Clause-22 and Clause-45.
> > 
> > There is a problem when it is paired with Marvell 88E2110 which returns
> > PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> > function, but this will break swphy, as swphy_reg_reg() return 0. [1]
> 
> Is it possible to identify it is a Marvell PHY? Do any of the other
> C22 registers return anything unique? I'm wondering if adding
> .match_phy_device to genphy would work to identify it is a Marvell PHY
> and not bind to it. Or we can turn it around, make the
> .match_phy_device specifically look for the fixed-link device by
> putting a magic number in one of the vendor registers.
>

I checked the Marvell and did not see any unique register values.
Also, since get_phy_c22_id() returns a *phy_id== 0, it is not bind to
any PHY driver, so I don't think adding the match_phy_device check in
getphy would help.

 VK
