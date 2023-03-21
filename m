Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBCD6C2E80
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCUKQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUKQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:16:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE16A1;
        Tue, 21 Mar 2023 03:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G4bA1V6h3W3C/Q7+Zf9wOX1NPXtBmFDA7jSiEHk/5bg=; b=v8xQdR6VkgOBH1q6DaV//dcr/a
        WVJNyND191DFZPL5np9/lTVKm3jc3cqWvFp7emkIUR16UeJbqFBhcVCXZiutMKdgd1US4Ciz/2+yD
        eNy549fJeNvZFmKVUSW25ca8Tyz60bKCHtMrEi/Ac2Mr0Aj5xr5zkKhwDJqV1TDkIOWEkSyY5QNkk
        U7T6anvpELEHy9+QQRDiKrv5Zs0yzmwmRSf3WsH5vAHwFXVO3aiABh6bBEoxuNMJo2J+zSD5AVe4G
        JLAfOyrL8Oa+OyEuGsIj7gvKxMZw5IDrjVQl7HPYI8iPcqWwQGqscXKg1YhqSvH1NPGowTc7ZV0Yu
        F1PdH1JA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33580)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peZ2e-0000pr-BU; Tue, 21 Mar 2023 10:16:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peZ2Z-0007e7-CX; Tue, 21 Mar 2023 10:16:27 +0000
Date:   Tue, 21 Mar 2023 10:16:27 +0000
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
Message-ID: <ZBmD+7pinpTzayep@shell.armlinux.org.uk>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
 <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
 <20230320133431.GB2673958@google.com>
 <ZBhtOw4Ftj3Sa3JU@shell.armlinux.org.uk>
 <20230320164136.GC2673958@google.com>
 <ZBiRFNAqd94tbEJ9@shell.armlinux.org.uk>
 <20230321082658.GD2673958@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321082658.GD2673958@google.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:26:58AM +0000, Lee Jones wrote:
> On Mon, 20 Mar 2023, Russell King (Oracle) wrote:
> 
> > On Mon, Mar 20, 2023 at 04:41:36PM +0000, Lee Jones wrote:
> > > On Mon, 20 Mar 2023, Russell King (Oracle) wrote:
> > >
> > > > On Mon, Mar 20, 2023 at 01:34:31PM +0000, Lee Jones wrote:
> > > > > Once again netdev seems to have applied patches from other subsystems
> > > > > without review/ack.  What makes netdev different to any other kernel
> > > > > subsystem?  What would happen if other random maintainers started
> > > > > applying netdev patches without appropriate review?  I suspect someone
> > > > > would become understandably grumpy.
> > > >
> > > > Why again are you addressing your whinge to me? I'm not one of the
> > > > netdev maintainers, but I've pointed out what happens in netdev
> > > > land. However, you seem to *not* want to discuss it directly with
> > > > DaveM/Jakub/Paolo - as illustrated again with yet another response
> > > > to *me* rather than addressing your concerns *to* the people who
> > > > you have an issue with.
> > > >
> > > > This is not communication. Effectively, this is sniping, because
> > > > rather than discussing it with the individuals concerned, you are
> > > > instead preferring to discuss it with others.
> > > >
> > > > Please stop this.
> > >
> > > Read the above paragraph again.
> >
> > You sent your email _TO_ me, that means you addressed your comments
> > primarily _to_ me. RFC2822:
> >
> >    The "To:" field contains the address(es) of the primary recipient(s)
> >    of the message.
> >
> >    The "Cc:" field (where the "Cc" means "Carbon Copy" in the sense of
> >    making a copy on a typewriter using carbon paper) contains the
> >    addresses of others who are to receive the message, though the
> >    content of the message may not be directed at them.
> 
> You're over-thinking it.  I replied to all.

I've been thinking about this entire situation and there's something
that summarises it. Kettle. Pot. Black.

You complain about how netdev is run, but you also complain about how
people interpret your emails.

Sorry, but no. I think you need to be more accomodating towards how
others perceive your emails, especially when there are widespread
accepted conventions. The fact that you are seemingly not even willing
to entertain that someone _might_ interpret your emails according to
standard normals is frankly a problem for you.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
