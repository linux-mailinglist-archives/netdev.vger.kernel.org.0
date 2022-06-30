Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB67561953
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiF3Lgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiF3Lgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:36:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7E5A446;
        Thu, 30 Jun 2022 04:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YUegSAtrHJuf++oLd2AkDHyUJS1bF226T9zeUPibzdI=; b=a7IyqWkdA70BWwqXqNN4nS6fTV
        52K3yOWMROiMYthiioE0NOH9Ir1XwJG5ltYsjVradu9PNBobke0xtZqhLqFjls/9RKQR56sB49MrW
        UYUziAQa0i7ekm0yvuTbY0H2eeMjLvComguGJCv7m4g410lnooasvXKDqntBVQx98MsSy9rP+DFtH
        o2EK19blD/VcqDrCuffcK/Up1avcHPtMBF1Aa1x01aIlWqtC+C7emT76eSYTUdp08/x4ZNczFdWPL
        dRPwpftJN3R++G3Ac//nPYu5d3WJDfL8VpUNVA+p/YzfUMztYnIBtQrIWQySDu3wOyE55YtMIPaB4
        pFXs5xRg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33114)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6sTI-0004Lw-8e; Thu, 30 Jun 2022 12:36:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6sTB-0006kW-4c; Thu, 30 Jun 2022 12:36:25 +0100
Date:   Thu, 30 Jun 2022 12:36:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Message-ID: <Yr2KuQonUBo74As+@shell.armlinux.org.uk>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
 <20220630102041.25555-11-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630102041.25555-11-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 03:50:38PM +0530, Arun Ramadoss wrote:
> The internal phy of the LAN937x are capable of 100Mbps speed. And the

Good English grammar suggests never to start a sentence with "And".

> xMII port of switch is capable of 10/100/1000Mbps.

... and supports flow control?

> +void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
> +			      struct phylink_config *config)
> +{
> +	config->mac_capabilities = MAC_100FD;
> +
> +	if (dev->info->supports_rgmii[port]) {
> +		/* MII/RMII/RGMII ports */
> +		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +					    MAC_100HD | MAC_10 | MAC_1000FD;

And SGMII too? (Which seems to be a given because from your list in the
series cover message, SGMII ports also support RGMII).

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
