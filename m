Return-Path: <netdev+bounces-6379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 714C671608B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D16F280FC3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9592E1992B;
	Tue, 30 May 2023 12:52:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88622154B0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:52:41 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B8CE46
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685451132; x=1716987132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LRq38u3QQgU2FIbQKrkSVOikV0xBGgLon/1g05hOxKY=;
  b=q0mBoeYqb6Q1jzUkBp6Ph5N71iZxedVcI5lm6Kqb/Z23jLfFMka3cTYa
   DN07dGWUnmRkROPWm1s1gASlzGLDmcGmGgjKntZMoZVXUMfU0h5AT1yoc
   JdiFxDQwNxOaDyaTmK/AVv0Tim/RQQ0a1fdHUVK1u2Eo729NCZ6dgVlej
   0zW9uDCyWivKLQ+yST/ssIo9MgtHTDFE8dmMlXdL1SwF8Ve+nRPCeZ7og
   /sajjWBsF4cBuiuMK0B9m3Cq8kppPsNpBmZjEI1HQFwIrz1VlT2+o5HsA
   tzppdLAIp4D99Ib2/YzXOrQh0lombd8+f96BsBuT2t6/WNk5RSNvGZhzY
   A==;
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="215434789"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 05:49:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 05:49:44 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 05:49:40 -0700
Date: Tue, 30 May 2023 12:49:39 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Lars Povlsen <lars.povlsen@microchip.com>,
	<linux-arm-kernel@lists.infradead.org>, Madalin Bucur
	<madalin.bucur@nxp.com>, Marcin Wojtas <mw@semihalf.com>, Michal Simek
	<michal.simek@amd.com>, <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>, Steen Hegelund
	<Steen.Hegelund@microchip.com>, Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 9/9] net: sparx5: switch PCS driver to use
 phylink_pcs_neg_mode()
Message-ID: <ZHXw4/JCPIMShHgH@DEN-LT-70577>
References: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
 <E1q1UMY-007FTP-SG@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1q1UMY-007FTP-SG@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Use the newly introduced phylink_pcs_neg_mode() to configure whether
> inband-AN should be used.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> index bb97d27a1da4..87bdec185383 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> @@ -99,13 +99,17 @@ static int sparx5_pcs_config(struct phylink_pcs *pcs,
>  {
>         struct sparx5_port *port = sparx5_pcs_to_port(pcs);
>         struct sparx5_port_config conf;
> +       unsigned int neg_mode;
>         int ret = 0;
> 
> +       neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
> +
>         conf = port->conf;
>         conf.power_down = false;
>         conf.portmode = interface;
> -       conf.inband = phylink_autoneg_inband(mode);
> -       conf.autoneg = phylink_test(advertising, Autoneg);
> +       conf.inband = neg_mode == PHYLINK_PCS_NEG_INBAND_DISABLED ||
> +                     neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
> +       conf.autoneg = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
>         conf.pause_adv = 0;
>         if (phylink_test(advertising, Pause))
>                 conf.pause_adv |= ADVERTISE_1000XPAUSE;
> --
> 2.30.2
> 
>

Hi Russel,

This looks good to me. Tested on sparx5 pcb134 and pcb135.

/Daniel

