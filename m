Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400935A1AD5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiHYVM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiHYVM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:12:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E946329F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vog/mXPXkotOFtFrlDYoaUmbTRYn5sRLHhjoYdTaFyE=; b=S2YWNdx0KhK4XgbiMq8ljQhH9v
        iFqq/9jakADGMuc9183Z04rbqVM1wmKW4iRGB0E37csiTY4U7Lsm7HbLXa8/n3vzhp6QfMJguZjkb
        HhQlhomBCDd44IXcS/eGV52NeC8FlAeOPFM633n/2imOxYD+dexl4TOeYaWgDguG6qdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRK9G-00Ebln-Ma; Thu, 25 Aug 2022 23:12:22 +0200
Date:   Thu, 25 Aug 2022 23:12:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 1] net: ngbe: Add build support for ngbe
Message-ID: <YwfltvdQaHUNKdAh@lunn.ch>
References: <20220825111512.43747-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825111512.43747-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -16,6 +16,19 @@ config NET_VENDOR_WANGXUN
>  
>  if NET_VENDOR_WANGXUN
>  
> +config NGBE
> +	tristate "Wangxun(R) GbE PCI Express adapters support"
> +	depends on PCI

> +++ b/drivers/net/ethernet/wangxun/Makefile
> @@ -4,3 +4,4 @@
>  #
>  
>  obj-$(CONFIG_TXGBE) += txgbe/
> +obj-$(CONFIG_TXGBE) += ngbe/

I think this should be NGBE, not TXGBE.

> +/* ngbe_pci_tbl - PCI Device ID Table
> + *
> + * Wildcard entries (PCI_ANY_ID) should come last

You make this comment, but then don't have a wildcard?

> + * Last entry must be all 0s
> + *
> + * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
> + *   Class, Class Mask, private data (not used) }
> + */
> +static const struct pci_device_id ngbe_pci_tbl[] = {
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL_W), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A2), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A2S), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A4), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A4S), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL2), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL2S), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL4), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL4S), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860LC), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A1), 0},
> +	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A1L), 0},
> +	/* required last entry */
> +	{ .device = 0 }
> +};
> +

You can add my Reviewed-by: Andrew Lunn <andrew@lunn.ch>
when you fix up these two minor issues.

	Andrew
