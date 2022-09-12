Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7DD5B5698
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 10:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiILItB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 04:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiILIsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 04:48:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D4F2AE0B;
        Mon, 12 Sep 2022 01:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g+tkkia51Dbf+lNosZ821AZKwHX/crm9rQ3idB3HQEQ=; b=QBHDoS3Wjm12RXb2SZBhi7xXs9
        82WD2L5W538AnvK4RscywNvV1gDKO2CDJ7uts7g/yDB9RAZXRJeZVWM5N8i5FvDLQEEo7bsMoDhCC
        3EMZ7bZCA7qBA0AbP01ae+z2BXF7FERvGpbYR+9pep4yWutdl0F4xhtWRXLHpv6h34yJdNWPF3Jzr
        btPsjUHh/dipbqmjQd3IrmZcEHm7edSx4wII5HVdfWeTxHINIRrRNr1/Fc0ibrQAvJu/7NtpQ51tG
        oT5GyTQRLOTxogg0FRKWIEXPhGlTd5ziputTKPlvrLIBGpl4uSzRUVxQXN0a2CWrqtLK6Y3iL7+bp
        KL+rimHw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34250)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXf7Q-0001Mh-I1; Mon, 12 Sep 2022 09:48:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXf7M-0007yX-Ny; Mon, 12 Sep 2022 09:48:36 +0100
Date:   Mon, 12 Sep 2022 09:48:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Message-ID: <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220911200244.549029-7-colin.foster@in-advantage.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 01:02:42PM -0700, Colin Foster wrote:
> phylink_generic_validate() requires that mac_capabilities is correctly
> populated. While no existing drivers have used phylink_generic_validate(),
> the ocelot_ext.c driver will. Populate this element so the use of existing
> functions is possible.

Ocelot always fills in the .phylink_validate method in struct
dsa_switch_ops, mac_capabilities won't be used as
phylink_generic_validate() will not be called by
dsa_port_phylink_validate().

Also "no existing drivers have used phylink_generic_validate()" I
wonder which drivers you are referring to there. If you are referring
to DSA drivers, then it is extensively used. The following is from
Linus' tree as of today:

$ grep -rl 'dsa_switch_ops' drivers/net/dsa | xargs grep -l phylink_mac_ | xargs grep -L phylink_validate
drivers/net/dsa/xrs700x/xrs700x.c
drivers/net/dsa/mt7530.c
drivers/net/dsa/qca/ar9331.c
drivers/net/dsa/qca/qca8k-8xxx.c
drivers/net/dsa/bcm_sf2.c
drivers/net/dsa/rzn1_a5psw.c
drivers/net/dsa/b53/b53_common.c
drivers/net/dsa/mv88e6xxx/chip.c
drivers/net/dsa/microchip/ksz_common.c
drivers/net/dsa/sja1105/sja1105_main.c
drivers/net/dsa/lantiq_gswip.c
drivers/net/dsa/realtek/rtl8366rb.c
drivers/net/dsa/realtek/rtl8365mb.c

So, I don't think the commit description is anywhere near correct.

Secondly, I don't see a purpose for this patch in the following
patches, as Ocelot continues to always fill in .phylink_validate,
and as I mentioned above, as long as that member is filled in,
mac_capabilities won't be used unless you explicitly call
phylink_generic_validate() in your .phylink_validate() callback.

Therefore, I think you can drop this patch from your series and
you won't see any functional change.

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v1 from previous RFC:
>     * New patch
> 
> ---
>  drivers/net/dsa/ocelot/felix.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 95a5c5d0815c..201bf3bdd67d 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -958,6 +958,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
>  
>  	__set_bit(ocelot->ports[port]->phy_mode,
>  		  config->supported_interfaces);
> +
> +	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
> +				   MAC_100 | MAC_1000FD | MAC_2500FD;
>  }
>  
>  static void felix_phylink_validate(struct dsa_switch *ds, int port,
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
