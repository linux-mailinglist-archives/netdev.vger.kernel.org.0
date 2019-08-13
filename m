Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B6E8AFDF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfHMGZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:25:28 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:31768 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMGZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:25:28 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: aSkY3tesq8gTapETkaEJyjAjq9gI1YJozJHhAEyuRJR5I2C/etWrUxUIQ0edjdlJ00xj3pxtB4
 AmmvddvdGA4AFHot3BUGKzpC0eSzfIUd31ZHzh6oezrJv2kCEtSiSkkdAzeUEGM+MBxIgM4Sf/
 Gpa9MFCxfmLq7g3ip8gzg6Heq5d6pEmBpsvvD1EdXb53M2cUY/+gl7T4FkmLLSXh4ocHSEcQIe
 mfwMtOC2bt/+d+O5Be2qkvCjdckm0MTuSJwTttm9KKNbxHgJZI63/1Nkblj7uU5lLc5I/eQm+k
 qFo=
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="46311026"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2019 23:25:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 23:25:27 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 12 Aug 2019 23:25:27 -0700
Date:   Tue, 13 Aug 2019 08:25:26 +0200
From:   "Allan W . Nielsen" <allan.nielsen@microchip.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
Subject: Re: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Message-ID: <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-5-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190813025214.18601-5-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/13/2019 10:52, Yangbo Lu wrote:
> All the PTP messages over Ethernet have etype 0x88f7 on them.
> Use etype as the key to trap PTP messages.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Added this patch.
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 6932e61..40f4e0d 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1681,6 +1681,33 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
>  }
>  EXPORT_SYMBOL(ocelot_probe_port);
>  
> +static int ocelot_ace_add_ptp_rule(struct ocelot *ocelot)
> +{
> +	struct ocelot_ace_rule *rule;
> +
> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> +	if (!rule)
> +		return -ENOMEM;
> +
> +	/* Entry for PTP over Ethernet (etype 0x88f7)
> +	 * Action: trap to CPU port
> +	 */
> +	rule->ocelot = ocelot;
> +	rule->prio = 1;
> +	rule->type = OCELOT_ACE_TYPE_ETYPE;
> +	/* Available on all ingress port except CPU port */
> +	rule->ingress_port = ~BIT(ocelot->num_phys_ports);
> +	rule->dmac_mc = OCELOT_VCAP_BIT_1;
> +	rule->frame.etype.etype.value[0] = 0x88;
> +	rule->frame.etype.etype.value[1] = 0xf7;
> +	rule->frame.etype.etype.mask[0] = 0xff;
> +	rule->frame.etype.etype.mask[1] = 0xff;
> +	rule->action = OCELOT_ACL_ACTION_TRAP;
> +
> +	ocelot_ace_rule_offload_add(rule);
> +	return 0;
> +}
> +
>  int ocelot_init(struct ocelot *ocelot)
>  {
>  	u32 port;
> @@ -1708,6 +1735,7 @@ int ocelot_init(struct ocelot *ocelot)
>  	ocelot_mact_init(ocelot);
>  	ocelot_vlan_init(ocelot);
>  	ocelot_ace_init(ocelot);
> +	ocelot_ace_add_ptp_rule(ocelot);
>  
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
>  		/* Clear all counters (5 groups) */
This seems really wrong to me, and much too hard-coded...

What if I want to forward the PTP frames to be forwarded like a normal non-aware
PTP switch?

What if do not want this on all ports?

If you do not have an application behind this implementing a boundary or
transparent clock, then you are breaking PTP on the network.

/Allan
