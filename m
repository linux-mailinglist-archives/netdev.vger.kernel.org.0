Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C406C456F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCVIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVIzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:55:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC35372F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679475341; x=1711011341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GgE8o2sDaWvb5zankj4uXm1x0vaj1Fdfq5BzCejBMJY=;
  b=rgwfFtD9/eKWf+fSOBcsrXYWgdNGWtDF30a6bwB4sVJ6YrRPjMTVG++T
   KmDwwoj32nscXesht8asEJ0LKJsyCXoQrgVqKhMSJ+F1bz07Hg3tBPbfP
   Ax3WjXvjPndc2MYlQ7IAV9l/TXaheq/BSdRAk5lPIudQb0rP3F8U0cgzm
   yoHgzeZo9+VORBAWC/qcoue5ifcdCTvgT1R/xsMnQhnxutVfFIctMgYQ1
   ThQ9DLtGmTuUNtic+WNl8IouOO16o9Rk8d/5zNx7is7YpRTtIfiFeML5v
   YG9XyIhT3AYGyRi9227ngpRTpWsN3RKfpjevf0gWas5ZP32Llru2u1ilK
   w==;
X-IronPort-AV: E=Sophos;i="5.98,281,1673938800"; 
   d="scan'208";a="143285585"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2023 01:55:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 01:55:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 22 Mar 2023 01:55:38 -0700
Date:   Wed, 22 Mar 2023 09:55:38 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Liang He <windhl@126.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <david.daney@cavium.com>
Subject: Re: [PATCH] net: mdio: thunder: Add missing fwnode_handle_put()
Message-ID: <20230322085538.pn57j2b5dyxizb4o@soft-dev3-1>
References: <20230322062057.1857614-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230322062057.1857614-1-windhl@126.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/22/2023 14:20, Liang He wrote:
> 
> In device_for_each_child_node(), we should add fwnode_handle_put()
> when break out of the iteration device_for_each_child_node()
> as it will automatically increase and decrease the refcounter.

Don't forget to mention the tree which you are targeting.
It shoud be something like:
"[PATCH net] net: mdio: thunder: Add missing fwnode_handle_put()" and
you can achieve this using option --subject-prefix when you create your
patch:
git format-patch ... --subject-prefix "PATCH net"


> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/net/mdio/mdio-thunder.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
> index 822d2cdd2f35..394b864aaa37 100644
> --- a/drivers/net/mdio/mdio-thunder.c
> +++ b/drivers/net/mdio/mdio-thunder.c
> @@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>                 if (i >= ARRAY_SIZE(nexus->buses))
>                         break;
>         }
> +       fwnode_handle_put(fwn);

Can you declare only 1 mdio bus in the DT under this pci device?
Because in that case, I don't think this is correct, because then
'device_for_each_child_node' will exit before all 4 mdio buses are probed.
And according to the comments for 'fwnode_handle_put' you need to use
with break or return.

>         return 0;
> 
>  err_release_regions:
> --
> 2.25.1
> 

-- 
/Horatiu
