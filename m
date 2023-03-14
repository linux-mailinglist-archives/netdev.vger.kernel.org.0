Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EFD6BA370
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCNXMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCNXMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:12:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE062A6C2;
        Tue, 14 Mar 2023 16:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tQPhhNBlCS6fcUFwNOTfLKKm1TR9Z5ixAZW9T52AJ9g=; b=XTCf5LQ0AL2PtBceVjBzHBzMcP
        9uuW7FreifwFbq8YHCPpuji3oM4j4FmJIJx29DCbDAuB+04bEKMhtugeaPkXyAkjYudnhr7kUpED8
        dbwCop4pHOB9gYbpg8ln1cb1Jx2Ywj5FUTqlyYf60G1x1DN1LM9eng93KlWv8VfFDeuYygXeDQQYg
        Qjul8HmNHC0fZQMj4WUISJngU8ou23L2wEAUzKjOUiVlfvK9PuNBw+oV7YCUukHJyn2IQKkl4ayD+
        AYVlgZ5o2SQGGb+nKMNN2loOlOP1WYbqcj/L1bUX9cR9p2qGgMsLgxrPrGQMzTs968mGhTw+3mPs/
        9KNtqAWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57834)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcDoM-00065K-4C; Tue, 14 Mar 2023 23:12:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcDoE-0000m1-Qn; Tue, 14 Mar 2023 23:11:58 +0000
Date:   Tue, 14 Mar 2023 23:11:58 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
Message-ID: <ZBD/PrMM7vxae5gY@shell.armlinux.org.uk>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
 <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
 <ZBCyqdfaeF/q8oZr@makrotopia.org>
 <c07651cd-27b4-5ba4-8116-398522327d27@arinc9.com>
 <20230314195322.tsciinumrxtw64o5@skbuf>
 <3e3e6a1e-61ba-a6e8-5503-258fb8e949bb@arinc9.com>
 <20230314223413.velxur7gi7snpdei@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314223413.velxur7gi7snpdei@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:34:13AM +0200, Vladimir Oltean wrote:
> But the mt7530 maintainers have gone
> pretty silent as of late, and I, as a fallback maintainer with no
> hardware, have had to send 2 bug fixes to the mt7530 and 1 to the
> mtk_eth_soc driver in the past month, to address the reports.

That's an under-statement, and not just the DSA driver, but the
ethernet driver too. It's been years trying to get the attention
of anyone to sort out the pre-March 2020 crud in this driver, and
no one seems to care, and none of the alleged maintainers bother
replying.

I don't believe anyone who claims to be a maintainer for either the
DSA or Ethernet driver has commented on any of my patches or provided
any review.

In my mind, these drivers do not have maintainers.

What I have to resort to is spotting potential victims^wtesters on
the mailing lists to try stuff out for me - which is really not
how this should work.

It seems to me that this is the old "chuck code over the wall into
mainline, then do a runner" approach to kernel maintenance.

So, honestly, the sooner these drivers get proper maintainers, the
better - and if someone wants to step up to do that amongst those
who are involved in the current work, I'm all for that - it would
be a hell of a lot better than the current situation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
