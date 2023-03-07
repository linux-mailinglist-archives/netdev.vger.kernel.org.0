Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562D46ADE41
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjCGMBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCGMBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:01:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556D232530
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 04:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/DdiJJW2KMfOiNRsqXeyzvsPa+tiQ685iR7M7gsvOIw=; b=R2Qb1TE8dqEBMGg7VF0Dpe19ee
        hwjqzoiTKKi07io0ZMqiVYyM5u9bzjnQQTVVoSzx9jZ65pIh40pUSAT0gKdLJxqle8PKE1orcHzsy
        F3KgegTzmjJhVakafY4SuCJioqn0+3aevIpZN87oxB9nTRFIANxkHKYggDcz7niX4UxmA+fImIsvI
        7eXgUBImPC62skToo1ycHrXW2WkdpF3zU2gPzWKFGoUYMmbihzmKImoxY7/D00OvEe+dFn2aVGaA4
        h/Z8fBdrklVOc+qizDVNHSWSVOrK2wvj+3OEagH8vXQuVoskHe/yRjdibMLMTVG6xGEHGJZwFd/Qi
        PVwF2npg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36490)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZW0R-00007V-Bc; Tue, 07 Mar 2023 12:01:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZW0L-0001Ub-7W; Tue, 07 Mar 2023 12:01:17 +0000
Date:   Tue, 7 Mar 2023 12:01:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <ZAcnjXxLfeE9UIsO@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To any of those with Mediatek hardware... Any opinions on what we should
do concerning these modes?

If I don't get a reply, then I'll delete these. There's no point having
this code if it's been unreachable for a while and no one's complained.

Thanks.

On Fri, Feb 24, 2023 at 12:36:26PM +0000, Russell King (Oracle) wrote:
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index f78810717f66..280490942fa4 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -530,9 +530,11 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
>  		case PHY_INTERFACE_MODE_GMII:
>  			ge_mode = 1;
>  			break;
> +		/* FIXME: RMII is not set in the phylink capabilities */
>  		case PHY_INTERFACE_MODE_REVMII:
>  			ge_mode = 2;
>  			break;
> +		/* FIXME: RMII is not set in the phylink capabilities */
>  		case PHY_INTERFACE_MODE_RMII:
>  			if (mac->id)
>  				goto err_phy;
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
