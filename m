Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEB389E87
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfHLMiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:38:24 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16306 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHLMiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:38:23 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: qeHIJH6EHjEsNOvppt64ZYRVNZHLue+Csqxq7CLc08gsB7wEXuBIr0wLlIAI2HGArPxDVoIEtF
 wv87dc+PiXCuNuBmCMtLmiQrod3ooIDFecpcmfjaVgKq5tlnjaNwuJQCIs2OGjWd8t+K+tqfNf
 f405KkypkgqAXB42v76YacqYWJAcxkzG4iOdi0x2iyTZNZSJOXnpqXVUXOaynpCJqjY3Zgeque
 /cyp0i9UmcPeOeKwSkbrFIQdqvZCW3uza4MT9lHcqVMkhFPl8tb0r1gOOiMQie88pybuiSa05H
 sYI=
X-IronPort-AV: E=Sophos;i="5.64,377,1559545200"; 
   d="scan'208";a="44819725"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2019 05:38:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 05:38:22 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 12 Aug 2019 05:38:20 -0700
Date:   Mon, 12 Aug 2019 14:38:21 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 2/3] ocelot_ace: fix ingress ports setting for rule
Message-ID: <20190812123820.qjaclomo6bhpz5pg@lx-anielsen.microsemi.net>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190812104827.5935-3-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/12/2019 18:48, Yangbo Lu wrote:
> The ingress ports setting of rule should support covering all ports.
> This patch is to use u16 ingress_port for ingress port mask setting
> for ace rule. One bit corresponds one port.
That is how the HW is working, and it would be nice if we could operate on a
port masks/lists instead. But how can this be used?

Can you please explain how/when this will make a difference?

> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_ace.c    | 2 +-
>  drivers/net/ethernet/mscc/ocelot_ace.h    | 2 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
> index 5580a58..91250f3 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ace.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ace.c
> @@ -352,7 +352,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>  	data.type = IS2_ACTION_TYPE_NORMAL;
>  
>  	VCAP_KEY_ANY_SET(PAG);
> -	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~BIT(ace->chip_port));
> +	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~ace->ingress_port);
>  	VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
>  	VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
>  	VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
> diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
> index ce72f02..0fe23e0 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ace.h
> +++ b/drivers/net/ethernet/mscc/ocelot_ace.h
> @@ -193,7 +193,7 @@ struct ocelot_ace_rule {
>  
>  	enum ocelot_ace_action action;
>  	struct ocelot_ace_stats stats;
> -	int chip_port;
> +	u16 ingress_port;
>  
>  	enum ocelot_vcap_bit dmac_mc;
>  	enum ocelot_vcap_bit dmac_bc;
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index 7c60e8c..bfddc50 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -184,7 +184,7 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
>  		return NULL;
>  
>  	rule->ocelot = block->port->ocelot;
> -	rule->chip_port = block->port->chip_port;
> +	rule->ingress_port = BIT(block->port->chip_port);
>  	return rule;
>  }

-- Allan
