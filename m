Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A3057B597
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiGTLf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiGTLf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:35:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05D1838B;
        Wed, 20 Jul 2022 04:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hoc3SZ+a6cRMEV4dB3AWnbJTTC3nfLgS/xRzs04z7hg=; b=W3bqgC4atmjinJIsHmrzqz0PRG
        VdQarQ+8WG5T7XWBl5k/gL4YP+gOSjn0Vuidw1joFx6mX3gatujP8OabM9KsFfCZ223wTVwLM9QCp
        16DkFRkXeAj4sU/QaaAq9S2pYTgRu9VO80LTELaQum+YJJGuoGg7fQc7zFrq1256eXhbZ5iPOdVol
        DCQS9Mp7tc8+tsMYQMmiiTrQwQbx6x3wgbSFxtTFucTZkCalFScuqERAA8zi7duCrtgVoP2po7Vy2
        sm/iZtNbj1NJsTA5p94NeKmcKuBcuEAvW/u7YnQ58QmnYK7WvTnx+UNFsHD7RI78DP8dBJdaybtGo
        B39z/dhQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33460)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oE7z7-00042D-I7; Wed, 20 Jul 2022 12:35:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oE7z5-0003ro-9G; Wed, 20 Jul 2022 12:35:19 +0100
Date:   Wed, 20 Jul 2022 12:35:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 10/11] net: phy: aquantia: Add some additional phy
 interfaces
Message-ID: <YtfodwyLc5pMw4Gb@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-11-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-11-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 07:50:00PM -0400, Sean Anderson wrote:
> +/* The following registers all have similar layouts; first the registers... */
> +#define VEND1_GLOBAL_CFG_10M			0x0310
> +#define VEND1_GLOBAL_CFG_100M			0x031b
> +#define VEND1_GLOBAL_CFG_1G			0x031c
> +#define VEND1_GLOBAL_CFG_2_5G			0x031d
> +#define VEND1_GLOBAL_CFG_5G			0x031e
> +#define VEND1_GLOBAL_CFG_10G			0x031f
> +/* ...and now the fields */
> +#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
> +

Shouldn't these definitions be in patch 11? They don't appear to be used
in this patch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
