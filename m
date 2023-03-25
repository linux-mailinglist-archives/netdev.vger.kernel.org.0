Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCDA6C8ED3
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCYO0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 10:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCYO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 10:26:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99118132DE;
        Sat, 25 Mar 2023 07:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hGPPOu6tzPZecPZ2YOGmeFoFk/cqWEJCj6purl1gZTQ=; b=aSTuT1mvx73Aum4BAWiRtF3jNX
        aqHt/gHyo6oT18qm/3YrGqajtPCETKZI7B9jGY7MXyjQ3Yj0BN+Cc2NOFO6P/Ix2tw+u34GR7rX1C
        QhFe/Oye5PEvG0j6nSFbtWRNeYNXIcaUE/BQVXMme3pXLw4N1OsQ+ntu3/6ueJYscFjf1UbFsOYD4
        Qu/wyP8sVvx4QAUpuw8i+Ifo9TxKNt37SRvSHVKKyPgIgOcYfF7qORDMhiVpSN4vdg8CUhKKsVq82
        I7qDCV5Z+DArT34eIoeerMe+6u1q1FcjmNNjNpCN5zKXSGiGI/+wCjm6oweobVQVDUSwJTszG/VEw
        43/obtJQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32884)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pg4qd-0000ac-NA; Sat, 25 Mar 2023 14:26:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pg4qa-0003WK-EM; Sat, 25 Mar 2023 14:26:20 +0000
Date:   Sat, 25 Mar 2023 14:26:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Ben Hutchings <ben.hutchings@mind.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <ZB8EjAVRj5xpZuxZ@shell.armlinux.org.uk>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
 <20230317114646.GA15269@pengutronix.de>
 <20230317125022.ujbnwf2k5uvhyx53@skbuf>
 <20230317132140.GB15269@pengutronix.de>
 <20230317140722.wtobrtpgazutykaj@skbuf>
 <20230325121655.oz3afcempaaniqc4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325121655.oz3afcempaaniqc4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 02:16:55PM +0200, Vladimir Oltean wrote:
> Russell, you've expressed that this driver is "vile" for permitting
> access to the same hardware register through 2 different ksz8795_regs[]
> elements. Does the approach used in this patch set address your concerns,
> or in other words, do you believe is it worth extending the conversion
> to the KSZ switches that other people can test, such that the entire
> driver ultimately benefits from the conversion?

Thanks for pointing it out - I'll look at it next week.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
