Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA556762D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiGESIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiGESIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:08:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D334B1DC;
        Tue,  5 Jul 2022 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657044510; x=1688580510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IEFt1EjrRztOccUEkjfY+bs8M0akMX+TErxhSQ5fFHQ=;
  b=UKX7lrbabtFpjxG8eeDlDV5CRd43uqWlk2kxZ0ej5/uQGHdW9FRTEAur
   c920FtxchnHq1BYvFAUHvGOhBQkFdeWxKj9r6wvgu8WaAQsArUzjeYu/e
   rC8mKizx2nTgRXSxzRmY/aCv0HW58Upilrqnze101AtK2no51+pdEdHIL
   w9kwD6Ohxzrs7lh96rxvucLXemRR6R+/yxvnS/ijHdSLBem/A4uYNlurP
   2B981uTeNk3WqIqqZlyKshN/urvF+YDwgKHlMiN69V+B+RVC7rMFosXsl
   ooDekgEhxnXyoh4QXXDvpXDVjsOf27spbETg0ROnroQjiWCffs+4NEyRU
   A==;
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="170857307"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2022 11:08:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Jul 2022 11:08:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Jul 2022 11:08:29 -0700
Date:   Tue, 5 Jul 2022 20:12:26 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: lan966x: hardcode the number of external
 ports
Message-ID: <20220705181226.jcnwjqcmfsypr4q6@soft-dev3-1.localhost>
References: <20220704153654.1167886-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220704153654.1167886-1-michael@walle.cc>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/04/2022 17:36, Michael Walle wrote:
> 
> Instead of counting the child nodes in the device tree, hardcode the
> number of ports in the driver itself.  The counting won't work at all
> if an ethernet port is marked as disabled, e.g. because it is not
> connected on the board at all.
> 
> It turns out that the LAN9662 and LAN9668 use the same switching IP
> with the same synthesis parameters. The only difference is that the
> output ports are not connected. Thus, we can just hardcode the
> number of physical ports to 8.
> 
> Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
> changes since v1:
>  - add fixes tag since the fix is simple
>  - switch from new specific compatible to "just use 8 for all"
> 
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 ++------
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 5784c4161e5e..1d6e3b641b2e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -994,7 +994,7 @@ static int lan966x_probe(struct platform_device *pdev)
>         struct fwnode_handle *ports, *portnp;
>         struct lan966x *lan966x;
>         u8 mac_addr[ETH_ALEN];
> -       int err, i;
> +       int err;
> 
>         lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
>         if (!lan966x)
> @@ -1025,11 +1025,7 @@ static int lan966x_probe(struct platform_device *pdev)
>         if (err)
>                 return dev_err_probe(&pdev->dev, err, "Reset failed");
> 
> -       i = 0;
> -       fwnode_for_each_available_child_node(ports, portnp)
> -               ++i;
> -
> -       lan966x->num_phys_ports = i;
> +       lan966x->num_phys_ports = NUM_PHYS_PORTS;
>         lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
>                                       sizeof(struct lan966x_port *),
>                                       GFP_KERNEL);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 3b86ddddc756..2787055c1847 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -34,6 +34,7 @@
>  /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
>  #define QSYS_Q_RSRV                    95
> 
> +#define NUM_PHYS_PORTS                 8
>  #define CPU_PORT                       8
> 
>  /* Reserved PGIDs */
> --
> 2.30.2
> 

-- 
/Horatiu
