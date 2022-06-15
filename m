Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D0154C737
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344435AbiFOLOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241474AbiFOLOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:14:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC9F3B3DC;
        Wed, 15 Jun 2022 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qdb9YPnb/twwg1FQqyaKfeEHs8AHeqgZRmcpcNyXcvI=; b=O6Yk/Sogop8DV+PPXVWJGeKnhC
        r2AJrrmFOr9iFHFenDjxnrGO/Nb6bzU9WS5enQkHTtWunkAeeZ1/ecEDK6ZIk1rWPWhWaaS/rGCoc
        F+vd0vuiSxblAzYH1nzz7TlgBUIxg0cIx305LrCPCDsuGc1OVkvDIcvu/F2Q10KQoWBV99gZkLfnA
        62Pd1NvbB7H9n8XR/YFEEtU7R4EwFivFRoj7VOOn0X3ary/iAq1fyAxpqODLO/ZRui8IWyevZW0FM
        t0FzuVbKw59/wOqD4trUOXqvMfiuSCM0mdBtKq5w1YhGFHe1EMS+4w2fgYvUDQ2CNSCoDm6+1yHmO
        LTh/1r0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32874)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o1Qyp-0004Pe-Vx; Wed, 15 Jun 2022 12:14:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o1Qyn-0008NC-Ca; Wed, 15 Jun 2022 12:14:33 +0100
Date:   Wed, 15 Jun 2022 12:14:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next v2 12/15] net: dsa: microchip: ksz9477:
 separate phylink mode from switch register
Message-ID: <Yqm/Gb6icBxgBjcE@shell.armlinux.org.uk>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-13-arun.ramadoss@microchip.com>
 <20220614082429.x2ger7aysr4j4zbo@skbuf>
 <187a694e61bfda132e512ac1c046d584249e85f1.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <187a694e61bfda132e512ac1c046d584249e85f1.camel@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 08:49:46AM +0000, Arun.Ramadoss@microchip.com wrote:
> On Tue, 2022-06-14 at 11:24 +0300, Vladimir Oltean wrote:
> > I wonder why the driver did not just remove these from the supported
> > mask in the phylink validation procedure in the first place?
> > Adding these link mode fixups to a dev_ops callback named "dsa_init"
> > does not sound quite right.
> 
> So, it means if the link modes are updated correctly in the
> phylink_get_caps then we don't need these link mode removal. Is my
> understanding correct?

Yes.

If you tell phylink what you support, then phylink will use that to
restrict what is supported by e.g. the PHY.

If you find that isn't the case, then I definitely want to know,
because that's probably a bug that needs to be fixed!

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
