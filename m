Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE6483EA2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiADJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiADJBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:01:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F87C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 01:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W8Jz48f7bRk1ckbh4lsS0Wqn9maF4BXhcKl5LWNLDcE=; b=rKPFBLWVfgwe1ZR7mZ4fAzfexV
        CM+neKQzyz7koeftNBXpsry0RaGRmOqF7zTj3pU0bzG6c6+P7m+cOxyA0FVLDCXqayEIdl3+Xe/U/
        3wR7qz4qRpgQ1ueeJOHYOuuuz44cmKoSD+vbCXSvoclRIg1rA1CdBhPqHmoIjLVUDbdY6idLUX/l+
        QRDb2K7+vW917cWR89mCcE4fP/IdK+t5HHkvruDSkj0q2fIKBia7lPulVvfOYMBK3rKZw0Gobi7sx
        Rq0MzJMujVMZnOp3RE5zT2HZ3qdsh2WBF/zMT4Ad0DirE0JXzcMiMjj7FlBXzjTVBFUJaAmjhlnqD
        b9cPUyTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56546)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4fgh-0006nD-G9; Tue, 04 Jan 2022 09:00:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4fgf-00075v-EL; Tue, 04 Jan 2022 09:00:57 +0000
Date:   Tue, 4 Jan 2022 09:00:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Message-ID: <YdQMyfYU0wxHrT40@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
 <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
 <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
 <CAFcVEC+N0Y7ESFe-qcfpmkbPjRSvCJ=AOXoM6XSK6xGo=J1YNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVEC+N0Y7ESFe-qcfpmkbPjRSvCJ=AOXoM6XSK6xGo=J1YNw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 01:26:28PM +0530, Harini Katakam wrote:
> On Fri, Dec 17, 2021 at 1:55 PM Harini Katakam <harinik@xilinx.com> wrote:
> >
> > Hi Russell,
> >
> > On Fri, Dec 17, 2021 at 5:26 AM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > > > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > > > Convert axienet to use the phylink_pcs layer, resulting in it no longer
> > > > > being a legacy driver.
> > > > >
> > > > > One oddity in this driver is that lp->switch_x_sgmii controls whether
> > > > > we support switching between SGMII and 1000baseX. However, when clear,
> > > > > this also blocks updating the 1000baseX advertisement, which it
> > > > > probably should not be doing. Nevertheless, this behaviour is preserved
> > > > > but a comment is added.
> > > > >
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > >
> > > > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function parameter or member 'pcs' not described in 'axienet_local'
> > >
> > > Fixed that and the sha1 issue you raised in patch 2. Since both are
> > > "documentation" issues, I won't send out replacement patches until
> > > I've heard they've been tested on hardware though.
> >
> > Thanks for the patches.
> > Series looks good and we're testing at our end; will get back to you
> > early next week.
> 
> Thanks Russell. I've tested AXI Ethernet and it works fine.

Happy new year!

Thanks - can I use that as a tested-by please, and would you be happy
for me to send the patches for merging this week?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
