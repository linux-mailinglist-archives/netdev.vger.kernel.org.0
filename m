Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3C8957DA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfHTHFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:05:35 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:26946 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfHTHFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 03:05:35 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: sREywqhF9Ftgtqoa7FKTDX5naRepeSQnWEme6Fe+4O91nsRFcV41Y8uLGpmATE2svkCt1DxaLp
 WB+4T8zW2GxPw72EDLFP4/3DfJrwNMjTdGTSAZppOGukJlaBnhvY/2MVq+7+6c2oej3qOZToXM
 05p/AWrxLN7x8P86h8jAZWX1U8e96oJI3Tt/Qx0OH6ZO94mukuC1LE5gAJsjNsmfZWKchPvvce
 nwluS05XE3SqAuvSOfAeL+ru5pE+db+ejowEFtsdR5ArZ+ZvuCqcXotDkE/Q0eruwWpjpSfCgp
 NlY=
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="42881334"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2019 00:05:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 00:05:21 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 20 Aug 2019 00:05:20 -0700
Date:   Tue, 20 Aug 2019 09:05:20 +0200
From:   "Allan W . Nielsen" <allan.nielsen@microchip.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3] ocelot_ace: fix action of trap
Message-ID: <20190820070518.mypyahquun6t4yjf@lx-anielsen.microsemi.net>
References: <20190820042005.12776-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190820042005.12776-1-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is fixing a bug introduced in b596229448dd2

Acked-by: Allan W. Nielsen <allan.nielsen@microchip.com>

/Allan


The 08/20/2019 12:20, Yangbo Lu wrote:
> External E-Mail
> 
> 
> The trap action should be copying the frame to CPU and
> dropping it for forwarding, but current setting was just
> copying frame to CPU.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_ace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
> index 39aca1a..86fc6e6 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ace.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ace.c
> @@ -317,7 +317,7 @@ static void is2_action_set(struct vcap_data *data,
>  		break;
>  	case OCELOT_ACL_ACTION_TRAP:
>  		VCAP_ACT_SET(PORT_MASK, 0x0);
> -		VCAP_ACT_SET(MASK_MODE, 0x0);
> +		VCAP_ACT_SET(MASK_MODE, 0x1);
>  		VCAP_ACT_SET(POLICE_ENA, 0x0);
>  		VCAP_ACT_SET(POLICE_IDX, 0x0);
>  		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
> -- 
> 2.7.4
> 
> 

-- 
/Allan
