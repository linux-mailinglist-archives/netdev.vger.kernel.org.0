Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02596AA9C3
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCDNEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 08:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDNEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 08:04:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F03AF777;
        Sat,  4 Mar 2023 05:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o1V4bPDp9RjOX5IVjz87L3/JjhTGESn2h01X3jbS3fc=; b=lhkvKBDDL7Mdqv+FXEr7lOJzuV
        zycE44M2CTYcUo4mJzXyTs+7itC5K0PO5qD9qsvFm2QUngqIQmOaJIvHUE0mZ1RKQAyIcaRXtB3au
        Q3O5/oSzR7MjMlHHwoe2wEu555n7kX7uw0Sm7T9N0ns/bNrbR1NnGyzpn4grw++WQ8jIVDjkeBHpv
        yT1RCd5rneafkVz/vUrxAszHCbD8wDawbGGOtEZOax+fHgvXJJHTN34kj63tYWpigrMtM7jfI2VgP
        596gGVaxH6OwRU6jpxD0N2q9DT7EPsi4HULAi8MFG1ony9OINusemamaHrQG6ryiC90ENyLkPQIx8
        3Vx05wdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53642)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pYRYW-0002cK-A5; Sat, 04 Mar 2023 13:04:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pYRYP-0006uV-Dy; Sat, 04 Mar 2023 13:04:01 +0000
Date:   Sat, 4 Mar 2023 13:04:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
Message-ID: <ZANBwZryFXDEVEtG@shell.armlinux.org.uk>
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230304125453.53476-1-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 03:54:54PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Move the PLL setup of the MT7530 switch out of the pad configuration of
> port 6 to mt7530_setup, after reset.
> 
> This fixes the improper initialisation of the switch when only port 5 is
> used as a CPU port.
> 
> Add supported phy modes of port 5 on the PLL setup.
> 
> Remove now incorrect comment regarding P5 as GMAC5.

If this is what is necessary, you're taking some of the configuration
out of phylink's control, effectively making port 6 a fixed-interface
mode port. In that case, there should only ever be one interface
mode set in port 6's supported_interface mask, so that phylink knows
that no other interface modes can be selected for that port.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
