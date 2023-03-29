Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1FC6CD5C7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjC2JCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjC2JCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:02:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67B49D5;
        Wed, 29 Mar 2023 02:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tULeCImj22IMpn1LFutB65KLYjJBkR/cczPAM6gdrqA=; b=DzIT2I0wbJp6To2GXSnad+4CKg
        iQZvhFjjwCV7ipWxDY1pIlN/t3/SAjDAAqyxf9NtpBRvEAMh1CzqGUv3S6OBcFMiK8QpYGD3osbSa
        Zu1ajz47K9cKrqZJs6z/+EXPrJyXa+cw9gw0NuSvP3+oxiXOTwIKAnDYnbkX6bQKVeYlliH+FOd4k
        mMwGYcsuose9Mb4dePkOuelQOKwFRoJVM9YCJLgKRNHJJcpHQ3xNFNvDLyVEkG2geNcQShnd+hDja
        RuBTVjcTrKnsMpg/TBKTIib22jV0E6z0NzuY1PS2qw8aVm6ApGfyCW1hbOwgLaurw1Cu8MhOcasYq
        7E0uTDrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46564)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1phRgS-0008EI-Sk; Wed, 29 Mar 2023 10:01:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1phRgO-0007Nn-DX; Wed, 29 Mar 2023 10:01:28 +0100
Date:   Wed, 29 Mar 2023 10:01:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy() method
Message-ID: <ZCP+aIoUTw2laZ3/@shell.armlinux.org.uk>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
 <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
 <20230328185720.6239e4a7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328185720.6239e4a7@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:57:20PM -0700, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 16:16:54 +0800 Michael Sit Wei Hong wrote:
> > Provide phylink_expects_phy() to allow MAC drivers to check if it
> > is expecting a PHY to attach to. Since fixed-linked setups do not
> > need to attach to a PHY.
> > 
> > Provides a boolean value as to if the MAC should expect a PHY.
> > returns true if a PHY is expected.
> > 
> > Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> 
> Russell, looks good?

Not really, given that phylink_attach_phy() will refuse to attach a PHY
when:

        if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
                    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
                     phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)))
                return -EINVAL;

So, if we introduce a helper named "phylink_expects_phy" that returns
true when cfg_link_an_mode == MLO_AN_INBAND and the interface mode
is e.g. 1000base-X, but then someone tries to attach a PHY, the kernel
spits out a warning, backtrace, and a return value of -EINVAL, things
are going to look really rather stupid.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
