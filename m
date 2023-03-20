Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6056C14AC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjCTO1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjCTO1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 10:27:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3102313A;
        Mon, 20 Mar 2023 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8fPPhONKXpfhnsctRBM2wF3dukjuZcFloNfgvYDQNno=; b=gsz1m64uduKoHHN5tk3c6hFyyr
        M8+Wo2WSTcFgcCatp8JUetMGQzOCmAXpTe3bf/bSl9+ydw2uk7Xfaillu4oiYbPQSB9/sNNX9gqz9
        8srwL7s/FZanQpNw1bna6EggeB5hSjNXj6DvNJuqCoDpbHckNlZ7lJ622mcb0JIOEDFLA9tea+l+3
        fVavjtgIcJxghju+roZfsKPqJ2yfg1Y3G1HKrzS+UZil3KMS1EyjC0SHLMcDHeruujAj5zVgnpq98
        iXtUL0zf3OdFIxm5Wh0s6cD2VSGDfEQy/7tNIEemsF/qRGdoLTbdbYEfGPgZTF2AJIltyYyKXg7Vd
        ybgTrH7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39434)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peGTf-0007bQ-6U; Mon, 20 Mar 2023 14:27:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peGTb-0006aT-ET; Mon, 20 Mar 2023 14:27:07 +0000
Date:   Mon, 20 Mar 2023 14:27:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lee Jones <lee@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to
 be used in a non-syscon configuration
Message-ID: <ZBhtOw4Ftj3Sa3JU@shell.armlinux.org.uk>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
 <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
 <20230320133431.GB2673958@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320133431.GB2673958@google.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 01:34:31PM +0000, Lee Jones wrote:
> On Mon, 20 Mar 2023, Russell King (Oracle) wrote:
> 
> > On Mon, Mar 20, 2023 at 02:19:44PM +0530, Vinod Koul wrote:
> > > On 17-03-23, 11:54, Colin Foster wrote:
> > > > The phy-ocelot-serdes module has exclusively been used in a syscon setup,
> > > > from an internal CPU. The addition of external control of ocelot switches
> > > > via an existing MFD implementation means that syscon is no longer the only
> > > > interface that phy-ocelot-serdes will see.
> > > >
> > > > In the MFD configuration, an IORESOURCE_REG resource will exist for the
> > > > device. Utilize this resource to be able to function in both syscon and
> > > > non-syscon configurations.
> > >
> > > Applied to phy/next, thanks
> >
> > Please read the netdev FAQ. Patches sent to netdev contain the tree that
> > the submitter wishes the patches to be applied to.
> >
> > As a result, I see davem has just picked up the *entire* series which
> > means that all patches are in net-next now. net-next is immutable.
> >
> > In any case, IMHO if this kind of fly-by cherry-picking from patch
> > series is intended, it should be mentioned during review to give a
> > chance for other maintainers to respond and give feedback. Not all
> > submitters will know how individual maintainers work. Not all
> > maintainers know how other maintainers work.
> 
> Once again netdev seems to have applied patches from other subsystems
> without review/ack.  What makes netdev different to any other kernel
> subsystem?  What would happen if other random maintainers started
> applying netdev patches without appropriate review?  I suspect someone
> would become understandably grumpy.

Why again are you addressing your whinge to me? I'm not one of the
netdev maintainers, but I've pointed out what happens in netdev
land. However, you seem to *not* want to discuss it directly with
DaveM/Jakub/Paolo - as illustrated again with yet another response
to *me* rather than addressing your concerns *to* the people who
you have an issue with.

This is not communication. Effectively, this is sniping, because
rather than discussing it with the individuals concerned, you are
instead preferring to discuss it with others.

Please stop this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
