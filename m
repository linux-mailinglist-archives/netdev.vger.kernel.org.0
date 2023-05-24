Return-Path: <netdev+bounces-4881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFA970EF53
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 611702811C6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECC78462;
	Wed, 24 May 2023 07:26:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DA229A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:26:43 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6695C196
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684913187; x=1716449187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rQ0DuZshKAbz/udXXhLXGtUBznxtKAoyeYG8wTrC7VQ=;
  b=c4utAwxnCYbP7OkalWouE9RngutYp2PoQljvUEpPuxT0HPSN5PlDHqjT
   em2AfIa6hnXvTBrxbbG2oJiFplEww3h9vYhsc3FW0wTVZMRCwoa1dNjN4
   oAviQmVpiO0GKxtv472p9SfYfOBTUmYHI5pKAYCZel8D6g0nA9LBFqxJ3
   AV3nntJGcDzpvJwzpOckItajiKT7U08f38QN1Eo3wrv+Oz2FeXiJVkXeY
   OpQWyAEQVWkN1c3Nm530AOLO0o6DBBOJD3Rgxuqo+QYyt+Q5IKo2ju51O
   GHduMxyCkptlBnK+t8H4KmEYkj37K68g/DBHKVm6gBLZvT9xLu9ktQE2p
   g==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="217006483"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 00:26:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 00:26:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 24 May 2023 00:26:20 -0700
Date: Wed, 24 May 2023 09:26:19 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Florian Fainelli
	<f.fainelli@gmail.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Jakub Kicinski
	<kuba@kernel.org>, Lars Povlsen <lars.povlsen@microchip.com>,
	<linux-arm-kernel@lists.infradead.org>, Madalin Bucur
	<madalin.bucur@nxp.com>, Marcin Wojtas <mw@semihalf.com>, Michal Simek
	<michal.simek@amd.com>, <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>, Steen Hegelund
	<Steen.Hegelund@microchip.com>, Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC 0/9] Add and use helper for PCS negotiation modes
Message-ID: <20230524072619.dnzfy3lmgobqmu2k@soft-dev3-1>
References: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/23/2023 16:54, Russell King (Oracle) wrote:

Hi Russell,

I have tried this series on lan966x and it seems to be working fine.
There was a small issue applying the patch 3, as the function
'phylink_resolve_c73' doesn't exist yet.

> 
> Hi,
> 
> Earlier this month, I proposed a helper for deciding whether a PCS
> should use inband negotiation modes or not. There was some discussion
> around this topic, and I believe there was no disagreement about
> providing the helper.
> 
> The discussion can be found at:
> 
> https://lore.kernel.org/r/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk
> 
> This series adds that helper, and modifies most code to use it. I have
> a couple of further patches that hoist this function out of every PCS
> driver and into phylink's new phylink_pcs_config() function that I've
> posted separately, and drop the "mode" argument to the pcs_config()
> method, instead passing the result of phylink_pcs_neg_mode().
> 
> I haven't included those because this series doesn't update everything
> in net-next, but for RFC purposes, I think this is good enough to get
> a few whether people are generally happy or not.
> 
> Note that this helper is only about modes that affect the PCS such as
> the SGMII family and 802.3z types, not amount negotiation that happens
> in order to select a PCS (e.g. for backplanes.)
> 
>  drivers/net/dsa/qca/qca8k-8xxx.c                   | 13 ++--
>  drivers/net/ethernet/freescale/fman/fman_dtsec.c   |  7 +-
>  drivers/net/ethernet/marvell/mvneta.c              |  5 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  4 +-
>  .../net/ethernet/marvell/prestera/prestera_main.c  | 10 ++-
>  .../ethernet/microchip/lan966x/lan966x_phylink.c   |  8 ++-
>  .../net/ethernet/microchip/sparx5/sparx5_phylink.c |  8 ++-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  5 +-
>  drivers/net/pcs/pcs-lynx.c                         | 18 +++--
>  drivers/net/phy/phylink.c                          | 14 ++--
>  include/linux/phylink.h                            | 81 +++++++++++++++++++++-
>  11 files changed, 136 insertions(+), 37 deletions(-)
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu

