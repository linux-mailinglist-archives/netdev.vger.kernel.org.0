Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55083276A15
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgIXHIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:08:20 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:49373 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIXHIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:08:20 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2B210FF805;
        Thu, 24 Sep 2020 07:08:17 +0000 (UTC)
Date:   Thu, 24 Sep 2020 09:08:16 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        fido_max@inbox.ru, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: Re: [net] net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3
Message-ID: <20200924070816.GS9675@piout.net>
References: <20200924021113.9964-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924021113.9964-1-xiaoliang.yang_1@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24/09/2020 10:11:13+0800, Xiaoliang Yang wrote:
> INIT_IPS and GATE_ENABLE fields have a wrong offset in SG_CONFIG_REG_3.

You are changing GATE_STATE, not GATE_ENABLE

> This register is used by stream gate control of PSFP, and it has not
> been used before, because PSFP is not implemented in ocelot driver.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  include/soc/mscc/ocelot_ana.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/soc/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.h
> index 841c6ec22b64..1669481d9779 100644
> --- a/include/soc/mscc/ocelot_ana.h
> +++ b/include/soc/mscc/ocelot_ana.h
> @@ -252,10 +252,10 @@
>  #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_M                 GENMASK(18, 16)
>  #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_X(x)              (((x) & GENMASK(18, 16)) >> 16)
>  #define ANA_SG_CONFIG_REG_3_GATE_ENABLE                   BIT(20)
> -#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 24) & GENMASK(27, 24))
> -#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(27, 24)
> -#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(27, 24)) >> 24)
> -#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(28)
> +#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) & GENMASK(24, 21))
> +#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21)
> +#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(24, 21)) >> 21)
> +#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
>  

VSC7514 doesn't have the stream gate registers ans this was generated
automatically from the cml file for felix. Did that change?

Seeing that bits in this register are not packed, I would believe your
change is correct.

>  #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
>  
> -- 
> 2.17.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
