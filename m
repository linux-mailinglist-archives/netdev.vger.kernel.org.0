Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156BB6B7229
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjCMJKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjCMJKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:10:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5268AD21;
        Mon, 13 Mar 2023 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678698602; x=1710234602;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YivqxS+zeFWZMfPdu5ClCSUPNAcBM+7zK7hLm2cpsW4=;
  b=YvKAV2+yIUJ4Xr1ZHuwqJv40zlJF+SYCOcCMJbdckABCCzZJumm3oF4m
   yIHWnwdCHJ+mZCV35h9+APqwpJ+LOQEWw15LbypXY9dGRp29ALC8xBErP
   zYh4VPE1ZhjhizyY6soCSjppW5u/bq3pOQ1jP32UhxGXK9lC7rAl23wNC
   PtkrYIHvA8C08QKfiwOL7PVwQJkoViZxhiwqihq+AxJMNArjFQgSK2QlA
   eG2aMXqFxHbS69hkqXjcSKC0GlCi5kSoRrI/xdN58Wuu4UCTSceOQ5ASz
   Dmo1BtHXxBYoZyWtVT83BBiFFscouuR8oGetW5jg+S2v3zW+OiSbPlvpS
   g==;
X-IronPort-AV: E=Sophos;i="5.98,256,1673938800"; 
   d="scan'208";a="205062965"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Mar 2023 02:10:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 02:09:47 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 13 Mar 2023 02:09:40 -0700
Message-ID: <21d44d0b-05c0-1912-15de-a5c74d3ff4c6@microchip.com>
Date:   Mon, 13 Mar 2023 10:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Michal Simek" <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     <devicetree@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-wireless@vger.kernel.org>
References: <20230310144718.1544169-1-robh@kernel.org>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230310144718.1544169-1-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2023 at 15:47, Rob Herring wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   drivers/net/can/cc770/cc770_platform.c          | 12 ++++++------
>   drivers/net/ethernet/cadence/macb_main.c        |  2 +-

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

>   drivers/net/ethernet/davicom/dm9000.c           |  4 ++--

[..]

> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4990,7 +4990,7 @@ static int macb_probe(struct platform_device *pdev)
>                  bp->jumbo_max_len = macb_config->jumbo_max_len;
> 
>          bp->wol = 0;
> -       if (of_get_property(np, "magic-packet", NULL))
> +       if (of_property_read_bool(np, "magic-packet"))
>                  bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
>          device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);

[..]

-- 
Nicolas Ferre

