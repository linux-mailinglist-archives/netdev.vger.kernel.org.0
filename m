Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35C15C929
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBMRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:08:43 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58298 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgBMRIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YQ0mnhZ4ts3PmJOP25Bq1ziIb/467uYYhxuJybIHnZg=; b=lW+qeWyYxCWdZi+uaYgOOh+rF
        jl837ufvVcSFWoLGpJ7MJNLZWhZX69L4NYLhP96eQw3vq4T81GcvLua3smp9BApyrQwQUaNfKocQ6
        hJJElM/Z5mrT0B4/S6gRE72U3meOdU2Dk+ynBIjbVjGp4UD8tubCRCZai6cnPtqWEVdzFtoMh+79A
        I3krUsO8XCc62uBmm7PYJM5yj14S44cqLM55wfjXSc7Bh38tKscsv5CxbvUGX/+vbvp3vq7DsEaNB
        3rSuGR49Iam4EKqu65AVvJ2eo5/btwxh9eQfSYKkB8TJqEf5R/uhhfOkSIyUDzMT6EYO1T0OlFLMh
        1T85joMmw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47368)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2Hyb-0001qb-99; Thu, 13 Feb 2020 17:08:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2HyU-0002Wf-Sj; Thu, 13 Feb 2020 17:08:26 +0000
Date:   Thu, 13 Feb 2020 17:08:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200213170826.GN25745@shell.armlinux.org.uk>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 05:57:36PM +0200, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Thu, 13 Feb 2020 at 16:46, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > [Recipient list updated; removed addresses that bounce, added Ioana
> > Ciornei for dpaa2 and DSA issue mentioned below.]
> >
> > On Thu, Feb 13, 2020 at 01:38:31PM +0000, Russell King - ARM Linux admin wrote:
> > > Hi,
> >
> > I should also have pointed out that with mv88e6xxx, the patch
> > "net: mv88e6xxx: use resolved link config in mac_link_up()" "fixes" by
> > side-effect an issue that Andrew has mentioned, where inter-DSA ports
> > get configured down to 10baseHD speed.  This is by no means a true fix
> > for that problem - which is way deeper than this series can address.
> > The reason it fixes it is because we no longer set the speed/duplex
> > in mac_config() but set it in mac_link_up() - but mac_link_up() is
> > never called for CPU and DSA ports.
> >
> > However, I think there may be another side-effect of that - any fixed
> > link declaration in DT may not be respected after this patch.
> >
> > I believe the root of this goes back to this commit:
> >
> >   commit 0e27921816ad99f78140e0c61ddf2bc515cc7e22
> >   Author: Ioana Ciornei <ioana.ciornei@nxp.com>
> >   Date:   Tue May 28 20:38:16 2019 +0300
> >
> >   net: dsa: Use PHYLINK for the CPU/DSA ports
> >
> > and, in the case of no fixed-link declaration, phylink has no idea what
> > the link parameters should be (and hence the initial bug, where
> > mac_config gets called with speed=0 duplex=0, which gets interpreted as
> > 10baseHD.)  Moreover, as far as phylink is concerned, these links never
> > come up. Essentially, this commit was not fully tested with inter-DSA
> > links, and probably was never tested with phylink debugging enabled.
> >
> > There is currently no fix for this, and it is not an easy problem to
> > resolve, irrespective of the patches I'm proposing.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> Correct me if I'm wrong, but if the lack of fixed-link specifier for
> CPU and DSA ports was not a problem before, but has suddenly started
> to become a problem with that patch, then simply reverting to the old
> "legacy" logic from dsa_port_link_register_of() should restore the
> behavior for those device tree blobs that don't specify an explicit
> fixed-link?

That's a good idea, but presumably the change was done in order to
be able to support something, so reverting it may also cause
regressions.  For example, the mv88e6xxx driver has no adjust_link
support anymore as of:

commit 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Author: Hubert Feurstein <h.feurstein@gmail.com>
Date:   Wed Jul 31 17:42:39 2019 +0200

    net: dsa: mv88e6xxx: drop adjust_link to enabled phylink

Since DSA has been whinging about adjust_link being set, I suspect
this is not the only DSA driver to have dropped adjust_link support.

The problem has basically been spotted way too late, and there's
too much on top for a simple revert to work.

> In the longer term, can't we just require fixed-link specifiers for
> non-netdev ports on new boards, keep the adjust_link code in DSA for
> the legacy blobs (which works through some sort of magic), and be done
> with it?

That would be a nice idea - making them behave exactly the same way
as any other network connection, but that is something for the DSA
maintainers to decide.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
