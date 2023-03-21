Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966B96C2E9F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCUKWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjCUKWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:22:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67973DBDB;
        Tue, 21 Mar 2023 03:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kn59vUHpGOPm+c/jf0dfjGiCEdXwgniLZIjifz674e4=; b=Edg4D7uCegCTpkNc3ynbO+Nz3K
        4GvnWDcIsWXFHrsiaAC0S8VziZS7NONO1Xi/vBnJLqT0hgH+IqKUE2+dmMkpHzEarOrztv1P2X92F
        +X/+cu4pQEu3eJn0r7oITTspYX6d73AzFWsHu5JNt/p6fRsVy5dSV93yS0+ZoRBFGlUy3rnK7ZmbL
        g4pZCgmw6eydAuEwzmwst4DpbV9xc7sZLUiw5PoUt+QTtCf33Q9BbJThYvPInhyKUMgzWwpjf9r8j
        a5EFbU/GZN30jWn2GzG+OnZ+xhsA0lv2Y6B2EaqVjbxbUj5YIuVSnKnOKIuej5lV1xmtPyaBovQXc
        Rw6bGbPg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52244)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peZ8C-0000qk-TZ; Tue, 21 Mar 2023 10:22:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peZ89-0007eK-9B; Tue, 21 Mar 2023 10:22:13 +0000
Date:   Tue, 21 Mar 2023 10:22:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 0/2] Fix PHY handle no longer parsing
Message-ID: <ZBmFVZD6rBA45hu3@shell.armlinux.org.uk>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <ZBTTg78Zc+Vdyxi4@shell.armlinux.org.uk>
 <PH0PR11MB75877BF4D0E96399CAA343549D819@PH0PR11MB7587.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB75877BF4D0E96399CAA343549D819@PH0PR11MB7587.namprd11.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:37:48AM +0000, Sit, Michael Wei Hong wrote:
> 
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Saturday, March 18, 2023 4:54 AM
> > To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> > Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> > Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> > <joabreu@synopsys.com>; David S . Miller
> > <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>; Maxime Coquelin
> > <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> > <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> > stm32@st-md-mailman.stormreply.com; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> > Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> > <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> > <peter.jun.ann.lai@intel.com>
> > Subject: Re: [PATCH net v2 0/2] Fix PHY handle no longer parsing
> > 
> > On Tue, Mar 14, 2023 at 03:02:06PM +0800, Michael Sit Wei Hong
> > wrote:
> > > After the fixed link support was introduced, it is observed that
> > PHY
> > > no longer attach to the MAC properly.
> > 
> > You are aware, I hope, that fixed-link and having a PHY are
> > mutually exclusive?
> > 
> > In other words, you can't use fixed-link to specify parameters for
> > a PHY.
> > 
> Yes but when the fixed-link support code was added, all our non
> fixed-link devices are not attaching the PHYs to the MACs, hence
> the reason for this patch series, to ensure both fixed-link and
> non fixed-link scenarios work properly.

Ah, it's the "there should be a PHY here" case you're trying to cater
for, rather than actually a fixed-link.

So, how about adding a helper that is basically:

bool phylink_expects_phy(struct phylink *phylink)
{
	return pl->cfg_link_an_mode == MLO_AN_PHY;
}
EXPORT_SYMBOL_GPL(phylink_expects_phy);

and use that to test whether you need to manually find a PHY to attach,
rather than trying to detect whether a fixed-link stanza appears in
firmware?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
