Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6643BDA72
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhGFPrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhGFPrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:47:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4717C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 08:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2wKE9phWCmUe4y2nochu0CWKczymhRnTd631xxpp5BM=; b=YjJvEzrVFlmQg/Img7Ig+pH/E
        r5EA16W0oMYWtQs+DRxmpOEMwylzDggCSbkp/b5vkL8C/c6t/0DLCdijCSjCn1wjeBsbjh339HfT3
        p/mepu0pQcQd1h7KW+g7I2H6k6y33LEnFSGote124nBHIuEB9Tr4xVz0jAHKyr44RXTTqAH/PaW1y
        vEYgXGIcy5JGKjA2vUym/PfBTurEPvKhXPFNJfQnLUtUCoOLwEaSH5/ptLZBM8C2H7LryR7u1fTQK
        Qez4T3y74Ncefs+FxzKuSVieDuwrBt82vUimNEUVz1X+zwpWwxWmo/b3do/hJ59EBTLmGAPqYNYyd
        XUp4Xdz8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45800)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m0nFo-0006wO-UN; Tue, 06 Jul 2021 16:44:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m0nFm-00027u-Qb; Tue, 06 Jul 2021 16:44:54 +0100
Date:   Tue, 6 Jul 2021 16:44:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <20210706154454.GR22278@shell.armlinux.org.uk>
References: <20210701082658.21875-1-lxu@maxlinear.com>
 <20210701082658.21875-2-lxu@maxlinear.com>
 <7e2b16b4-839c-0e1d-4d36-3b3fbf5be9eb@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e2b16b4-839c-0e1d-4d36-3b3fbf5be9eb@maxlinear.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 03:34:56PM +0000, Liang Xu wrote:
> On 1/7/2021 4:26 pm, Xu Liang wrote:
> > Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> > GPY241, GPY245 PHYs. Separate from XWAY PHY driver because this series
> > has different register layout and new features not supported in XWAY PHY.
> >
> > Signed-off-by: Xu Liang <lxu@maxlinear.com>
> > ---
> > v2 changes:
> >   Fix format warning from checkpath and some comments.
> >   Use smaller PHY ID mask.
> >   Split FWV register mask.
> >   Call phy_trigger_machine if necessary when clear interrupt.
> > v3 changes:
> >   Replace unnecessary phy_modify_mmd_changed with phy_modify_mmd
> >   Move firmware version print to probe.
> > v4 changes:
> >   Separate PHY ID for new silicon.
> >   Use full Maxlinear name in Kconfig.
> >   Add and use C45 ID read API, and use genphy_c45_pma_read_abilities.
> >   Use my name instead of company as author.
> > v5 changes:
> >   Fix comment for link speed 2.5G.
> 
> Hi Andrew,
> 
> 
> Need your help on this patch.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210701082658.21875-1-lxu@maxlinear.com/
> 
> I see the status is "Not applicable" and description "Guessing tree name 
> failed - patch did not apply".
> 
> How should I fix the problem?

For netdev, the subject line should contain the tree that you want
the patch applied to.

So, "[PATCH net n/N] ..." or "[PATCH net-next n/N] ..."

In this case, because it isn't a fix, you want net-next. However, as
we are in the upstream merge window, the net-next tree is currently
closed to new submissions. Please wait until it has reopened, which
will after -rc1 has been released.

You can check the current status of net-next at:
	http://vger.kernel.org/~davem/net-next.html

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
