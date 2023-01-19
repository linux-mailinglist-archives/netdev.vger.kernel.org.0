Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E165673FCB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjASRWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjASRWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:22:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D5393F4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gHTUhXp1oIOUR/fxnoi4uPGWxB/25tr2xPFfXTm8eeo=; b=U0o/AH9tgh1ezvkriq/AGZ8p5/
        eBzNhngupxZ+3BvbRc7pu2yxXSPRYtRSsKED20CMM7k2RgBqFyb8idKHQcqywbUdkvc3H53BsovAA
        qOxo7br07bif1q9Jl+kp1o8TaXbIpwN5Yf+vPH07R2BPRoDS45f3dNvlbgjyzUNU7ylNt8X0bwY/k
        nhdJCEAdHDM/qxlCAR+ui2OxovCHkQyCvxiKRCSPq0bbHXdsC/kCcrCRuofeJjATkcM8pqT4RKuiS
        MwXBAKtnQgMa5xeIDMFF78TKXth/wwUfE5BWm+1U146ysl0iBh7adSvQdNjR4rcwez5Agkl0Je7sw
        dO+b+gLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36212)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIYbw-0004jx-9e; Thu, 19 Jan 2023 17:21:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIYbt-0000eT-KS; Thu, 19 Jan 2023 17:21:57 +0000
Date:   Thu, 19 Jan 2023 17:21:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 2/3] net: mediatek: sgmii: autonegotiation is required
Message-ID: <Y8l8NRmFfm/a8LFv@shell.armlinux.org.uk>
References: <20230119171248.3882021-1-bjorn@mork.no>
 <20230119171248.3882021-3-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230119171248.3882021-3-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 06:12:47PM +0100, Bjørn Mork wrote:
> sgmii mode fails if autonegotiation is disabled.
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 481f2f1e39f5..d1f2bcb21242 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -62,14 +62,9 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  	 * other words, 1000Mbps or 2500Mbps).
>  	 */
>  	if (interface == PHY_INTERFACE_MODE_SGMII) {
> -		sgm_mode = SGMII_IF_MODE_SGMII;
> -		if (phylink_autoneg_inband(mode)) {
> -			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
> -				    SGMII_SPEED_DUPLEX_AN;
> -			use_an = true;
> -		} else {
> -			use_an = false;
> -		}
> +		sgm_mode = SGMII_IF_MODE_SGMII | SGMII_REMOTE_FAULT_DIS |
> +			   SGMII_SPEED_DUPLEX_AN;
> +		use_an = true;

I wasn't actually suggesting in our discussion that this is something
which should be changed.

The reference implementation for the expected behaviour is
phylink_mii_c22_pcs_config(), and it only enables in-band if "mode"
says so. If we have a PHY which has in-band disabled (yes, they do
exist) then having SGMII in-band unconditionally enabled breaks them,
and yes, those PHYs appear on SFP modules.

The proper answer is to use 'managed = "in-band-status";' in your DT
to have in-band used with SGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
