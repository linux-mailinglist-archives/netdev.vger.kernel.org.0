Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C537B4C00ED
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiBVSGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiBVSGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:06:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FF317289C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645553173; x=1677089173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hcJg7znHdlRDfULTWRGefwENEWaM3wBUHz9LUPa7rPk=;
  b=RwETHNjsk18CP4D8EuC3zqmGKbaK/etsr9YL9/kqJa0I1qndxHvUxUhs
   ImTI0b3R7wV/a2PgCJcQVycXyTcJG66VWE2vA3eq2MlZxIop0EgtGLI6/
   Z6Xsimewh87oWyMEFNgUyzyQ34m2tyXkNURuMIQONLnLKInI8/FPio8dR
   66Wm+bEu3Rf8pxwmnFSr0h6lZfxVevUj17G1bMgSDajMrXoVUEhm7ddot
   pnYqY89a7kCzAP5DuYn2cnIleUHX/YUkMG4HID0Mw5d/AvNBUDeibevos
   oz5fJrGtIGfboNoVmK2EB1VdXLGXUqc6D6DDfmChbsrPKvk6/iJdRNW45
   A==;
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="86613050"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Feb 2022 11:06:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Feb 2022 11:06:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 22 Feb 2022 11:06:11 -0700
Date:   Tue, 22 Feb 2022 19:08:54 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: sparx5: Support offloading of bridge
 port flooding flags
Message-ID: <20220222180854.ah3klvdgffpmk26n@soft-dev3-1.localhost>
References: <20220222143525.ubtovkknjxfiflij@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220222143525.ubtovkknjxfiflij@wse-c0155>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/22/2022 15:35, Casper Andersson wrote:
> [Some people who received this message don't often get email from casper.casan@gmail.com. Learn why this is important at http://aka.ms/LearnAboutSenderIdentification.]
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
> multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
> Since Protonmail apparently caused issues with certain email clients
> I have now switched to using gmail. Hopefully, there will be no issues
> this time.
> 
> Changes in v2:
>  - Added SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback
> 
>  .../microchip/sparx5/sparx5_switchdev.c       | 21 ++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index 649ca609884a..dc79791201d8 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -19,11 +19,27 @@ struct sparx5_switchdev_event_work {
>         unsigned long event;
>  };
> 
> +static int sparx5_port_attr_pre_bridge_flags(struct sparx5_port *port,
> +                                            struct switchdev_brport_flags flags)
> +{
> +       if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
>                                           struct switchdev_brport_flags flags)
>  {
> +       int pgid;
> +
>         if (flags.mask & BR_MCAST_FLOOD)
> -               sparx5_pgid_update_mask(port, PGID_MC_FLOOD, true);
> +               for (pgid = PGID_MC_FLOOD; pgid <= PGID_IPV6_MC_CTRL; pgid++)
> +                       sparx5_pgid_update_mask(port, pgid, !!(flags.val & BR_MCAST_FLOOD));
> +       if (flags.mask & BR_FLOOD)
> +               sparx5_pgid_update_mask(port, PGID_UC_FLOOD, !!(flags.val & BR_FLOOD));
> +       if (flags.mask & BR_BCAST_FLOOD)
> +               sparx5_pgid_update_mask(port, PGID_BCAST, !!(flags.val & BR_BCAST_FLOOD));
>  }
> 
>  static void sparx5_attr_stp_state_set(struct sparx5_port *port,
> @@ -72,6 +88,9 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
>         struct sparx5_port *port = netdev_priv(dev);
> 
>         switch (attr->id) {
> +       case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
> +               return sparx5_port_attr_pre_bridge_flags(port,
> +                                                        attr->u.brport_flags);
>         case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
>                 sparx5_port_attr_bridge_flags(port, attr->u.brport_flags);
>                 break;
> --
> 2.30.2
> 

-- 
/Horatiu
