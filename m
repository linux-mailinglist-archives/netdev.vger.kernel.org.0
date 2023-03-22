Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DF06C44C7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVIVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjCVIVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:21:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58D659437
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 01:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679473270; x=1711009270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kx0uMnW1MWbAqHgBXc/liK3ZEugHy6O5T0ZauGmp8C0=;
  b=GRwQzyy6deyqkCU32CLjUqdM3R9L66bJbmaB/ya+KPtWn5jxpQoyu2zb
   V3r8+HwTxQT9zp3sH7PXEjNwzMku/u9vhSIo5nEwJPyyw6fzWDzD332Q3
   Hxwc2AaFU/ckjoV/D2ZW0oOmd4kjxrp3nl/zT8wxYjWuFfbRyxw8LDFCO
   HEWtlRm1LVhkfxPtX5LgSNKjVuk2JfVuLNsCNxJInDlTPzbX3hSgsQoZ9
   Fqj1K595WG72GUIA1OhxGLAx+fPxRPBEXJ803kfi6hfe4W0iOa29tq97e
   NAUX6d2lc5XqGPWUvO6iAkoVJvDeWWTKoDnUARIDrmS/UTLHtjAMQJSW8
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,281,1673938800"; 
   d="scan'208";a="202837268"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2023 01:21:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 01:21:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 22 Mar 2023 01:21:05 -0700
Date:   Wed, 22 Mar 2023 09:21:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     ChunHao Lin <hau@realtek.com>
CC:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h rx crc error
Message-ID: <20230322082104.y6pz7ewu3ojd3esh@soft-dev3-1>
References: <20230322064550.2378-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230322064550.2378-1-hau@realtek.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/22/2023 14:45, ChunHao Lin wrote:
> 
> When link speed is 10 Mbps and temperature is under -20°C, rtl8168h may
> have rx crc error. Disable phy 10 Mbps pll off to fix this issue.

Don't forget to add the fixes tag.
Another comment that I usually get is to replace hardcoded values with
defines, but on the other side I can see that this file already has
plently of hardcoded values.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: ChunHao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_phy_config.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
> index 930496cd34ed..b50f16786c24 100644
> --- a/drivers/net/ethernet/realtek/r8169_phy_config.c
> +++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
> @@ -826,6 +826,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
>         /* disable phy pfm mode */
>         phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
> 
> +       /* disable 10m pll off */
> +       phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
> +
>         rtl8168g_disable_aldps(phydev);
>         rtl8168g_config_eee_phy(phydev);
>  }
> --
> 2.37.2
> 

-- 
/Horatiu
