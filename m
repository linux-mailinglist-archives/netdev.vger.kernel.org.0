Return-Path: <netdev+bounces-7856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F88721D87
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F1A21C20B11
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949FA17FC;
	Mon,  5 Jun 2023 05:34:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6EB17F4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:34:08 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB37D3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 22:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685943246; x=1717479246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hSGY5yP+GLYnKDAjBuRmiqQxTYxVL9UtHMOWJllYykc=;
  b=VTP2j+pXoKivuPiM01ejFiU9Hsgifx+mAckb6NcqvWBfSeLiETYAId7/
   rO0Nq+wEc3HUuuEbobsnV9CL/wInlQOEHQrgXc4f9uP9Txtf8chjRX+ql
   XgsYGwc1qpgdtLdK8sg/axw4D4Ft/Fe36y9WxS7dntQZgzfsPu+1D9Rd6
   le8rbnqwLBnFZzDHVl1N0Gzmb4CbzYx9a/LgjqjEG0XzHoJEYq6rtCC3p
   mblACAyeRLO0j2o0Lk5VMPT1/vVyVpa17Kt7gU036ubGsMxAkahnVR91c
   VlOrQD4k0rGnHhmWESZhAskr4QdFT1tSEF073ijBsNKe86sh99fAZeBOM
   g==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="155501138"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2023 22:34:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 4 Jun 2023 22:34:04 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 4 Jun 2023 22:34:01 -0700
Date: Mon, 5 Jun 2023 11:04:00 +0530
From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: phylink: actually fix ksettings_set() ethtool
 call
Message-ID: <20230605053400.GA273955@raju-project-pc>
References: <E1q4eLm-00Ayxk-GZ@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <E1q4eLm-00Ayxk-GZ@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/01/2023 10:12, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Raju Lakkaraju reported that the below commit caused a regression
> with Lan743x drivers and a 2.5G SFP. Sadly, this is because the commit
> was utterly wrong. Let's fix this properly by not moving the
> linkmode_and(), but instead copying the link ksettings and then
> modifying the advertising mask before passing the modified link
> ksettings to phylib.
> 
> Fixes: df0acdc59b09 ("net: phylink: fix ksettings_set() ethtool call")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Raju,
> 
> Given the number of cockups I've made with this so far, it would be a
> really good idea if you can explicitly test this patch and provide a
> tested-by. Also it would be good to have a reported-by as well.

Tested this patch with 1G Speed Cu SFP (Axcen Photonics - AXGT-R1T4-05I1) with
different speeds (1G/100M/10M bps) changes.. Working as expected.

Tested-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reported-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Thanks,
Raju
> 
> Thanks.
> 
>  drivers/net/phy/phylink.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index e237949deee6..b4831110003c 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2225,11 +2225,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
> 
>         ASSERT_RTNL();
> 
> -       /* Mask out unsupported advertisements */
> -       linkmode_and(config.advertising, kset->link_modes.advertising,
> -                    pl->supported);
> -
>         if (pl->phydev) {
> +               struct ethtool_link_ksettings phy_kset = *kset;
> +
> +               linkmode_and(phy_kset.link_modes.advertising,
> +                            phy_kset.link_modes.advertising,
> +                            pl->supported);
> +
>                 /* We can rely on phylib for this update; we also do not need
>                  * to update the pl->link_config settings:
>                  * - the configuration returned via ksettings_get() will come
> @@ -2248,10 +2250,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
>                  *   the presence of a PHY, this should not be changed as that
>                  *   should be determined from the media side advertisement.
>                  */
> -               return phy_ethtool_ksettings_set(pl->phydev, kset);
> +               return phy_ethtool_ksettings_set(pl->phydev, &phy_kset);
>         }
> 
>         config = pl->link_config;
> +       /* Mask out unsupported advertisements */
> +       linkmode_and(config.advertising, kset->link_modes.advertising,
> +                    pl->supported);
> 
>         /* FIXME: should we reject autoneg if phy/mac does not support it? */
>         switch (kset->base.autoneg) {
> --
> 2.30.2
> 


