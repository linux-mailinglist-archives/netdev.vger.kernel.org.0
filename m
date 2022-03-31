Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AEE4ED595
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiCaI3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiCaI3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:29:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C194E1C8878;
        Thu, 31 Mar 2022 01:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648715253; x=1680251253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lx3Akt2XgQBGgPwZQOjCdTFVnMM6p3ONMYke/VZbCfA=;
  b=HR5H6cPT+Kqa1+nVNR7G8b7V4QwWosY+3s95dleERfEpnycYP5NDqgsa
   RWBJ5PU8R78FlkKnKqdHrJAJYoiH2JE/LtdJ4Nrj/Tk8aQahqLTxWYToH
   PKhheuuq1zvicq+M+3ACMaIPCuSvPoS2oR189M4fMh+T5BPI7q5pJVyF9
   WucuSZ8dP0LQ2jKkt0px0LaM+ZEBK19h+1Bj+fwh4ZW63VjwS7wDJHV0H
   sHHJdtd83x5bowtx9R4yF3HDDbUKYKwK6DTKkXrJ2HShEzXtvoP2z41nM
   eyneGgbf2S6TWH3lj3YP46fPpO4zdKwAQWzRtDdhn/UXAcvLfJbfzLwXu
   g==;
X-IronPort-AV: E=Sophos;i="5.90,224,1643698800"; 
   d="scan'208";a="158789272"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Mar 2022 01:27:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 31 Mar 2022 01:27:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 31 Mar 2022 01:27:31 -0700
Date:   Thu, 31 Mar 2022 10:30:38 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC net-next] net: lan966x: make PHY reset support
 optional
Message-ID: <20220331083038.eorhpmhydadujfft@soft-dev3-1.localhost>
References: <20220330110210.3374165-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220330110210.3374165-1-michael@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/30/2022 13:02, Michael Walle wrote:

Hi Michael,

> 
> The PHY subsystem as well as the MIIM mdio driver (in case of the
> integrated PHYs) will already take care of the resets of any external
> and internal PHY. There is no need for this reset anymore, so mark it
> optionally to be backwards compatible.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> 
> Horatiu, what do you think, should it be removed altogether? 

I think it is OK to remove it altogether. If you get both [1] and [2]
in.

> There is
> no user for that in mainline and I don't know about downstream but the
> reset driver doesn't really work (as it also resets the GPIO/SGPIO)

Yes because I didn't manage to send yet those patches. But if your get
yours in that is fine for me.
My problem was, if after the probe of the MDIO controller it was probed
the SGPIO then the PHYs will be in reset because the SGPIO was resetting
the swich. But you put the reset of the swich on the pinctrl which will
be probed before the MDIO, so that should be fine.

> and conceptionally the property is on the wrong DT node. All of the
> drawbacks should have been addressed by my patches for the miim [1]
> and the pinctrl driver [2].
> 
> [1] https://lore.kernel.org/netdev/20220318201324.1647416-1-michael@walle.cc/
> [2] https://lore.kernel.org/linux-gpio/20220313154640.63813-1-michael@walle.cc/
> 
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 1f8c67f0261b..0765064d2845 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -916,7 +916,7 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
>                 return dev_err_probe(lan966x->dev, PTR_ERR(switch_reset),
>                                      "Could not obtain switch reset");
> 
> -       phy_reset = devm_reset_control_get_shared(lan966x->dev, "phy");
> +       phy_reset = devm_reset_control_get_optional_shared(lan966x->dev, "phy");
>         if (IS_ERR(phy_reset))
>                 return dev_err_probe(lan966x->dev, PTR_ERR(phy_reset),
>                                      "Could not obtain phy reset\n");
> --
> 2.30.2
> 

-- 
/Horatiu
