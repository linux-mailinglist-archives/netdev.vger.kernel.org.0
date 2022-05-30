Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106D85374D4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiE3Gem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiE3Gei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 02:34:38 -0400
Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9C954BD1;
        Sun, 29 May 2022 23:34:37 -0700 (PDT)
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 331F120146;
        Mon, 30 May 2022 06:34:36 +0000 (UTC)
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.155])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 41692267CE;
        Mon, 30 May 2022 06:34:30 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id D605020050;
        Mon, 30 May 2022 06:34:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id BE2752A901;
        Mon, 30 May 2022 06:34:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7XLbhXPlGTEC; Mon, 30 May 2022 06:34:25 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon, 30 May 2022 06:34:25 +0000 (UTC)
Received: from edelgard.icenowy.me (unknown [59.41.162.116])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id E5FCF406ED;
        Mon, 30 May 2022 06:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1653892465; bh=OwOn+r1LVu6iOywcyjP0Xu3W9EM6q1G6QluuGNVxgwE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kQu4KkxAVavXGE8BkWGPWdw6JbF7NxPyWW/3fOp4yvwS7Uy0DJzxT5u+5NcfgO4Tr
         gIeCK9EPz9JJ0cjaO72C5hxGqcl4jaBAe33/U+OTLvKhA0DEYFwgW/elDxSIXKPOPH
         3IRBMs4IGMjrEzgWPuuO+1TNrP5heMObfdPpcMUo=
Message-ID: <8e357eaea90e49d7d23bdb83ead4f0da870c3689.camel@aosc.io>
Subject: Re: [PATCH 07/10] rtw88: Add rtw8723du chipset support
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Date:   Mon, 30 May 2022 14:34:12 +0800
In-Reply-To: <20220518082318.3898514-8-s.hauer@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-8-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022-05-18星期三的 10:23 +0200，Sascha Hauer写道：
> Add support for the rtw8723du chipset based on
> https://github.com/ulli-kroll/rtw88-usb.git
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 +++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  drivers/net/wireless/realtek/rtw88/rtw8723d.c | 19 +++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8723d.h |  1 +
>  .../net/wireless/realtek/rtw88/rtw8723du.c    | 40
> +++++++++++++++++++
>  .../net/wireless/realtek/rtw88/rtw8723du.h    | 13 ++++++
>  6 files changed, 87 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig
> b/drivers/net/wireless/realtek/rtw88/Kconfig
> index 1624c5db69bac..ad1ac453015a9 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -64,6 +64,17 @@ config RTW88_8723DE
>  
>           802.11n PCIe wireless network adapter
>  
> +config RTW88_8723DU
> +       tristate "Realtek 8723DU USB wireless network adapter"
> +       depends on USB
> +       select RTW88_CORE
> +       select RTW88_USB
> +       select RTW88_8723D
> +       help
> +         Select this option will enable support for 8723DU chipset
> +
> +         802.11n USB wireless network adapter
> +
>  config RTW88_8821CE
>         tristate "Realtek 8821CE PCI wireless network adapter"
>         depends on PCI
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile
> b/drivers/net/wireless/realtek/rtw88/Makefile
> index 9e095f8181483..eb26c215fcde3 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -38,6 +38,9 @@ rtw88_8723d-objs              := rtw8723d.o
> rtw8723d_table.o
>  obj-$(CONFIG_RTW88_8723DE)     += rtw88_8723de.o
>  rtw88_8723de-objs              := rtw8723de.o
>  
> +obj-$(CONFIG_RTW88_8723DU)     += rtw88_8723du.o
> +rtw88_8723du-objs              := rtw8723du.o
> +
>  obj-$(CONFIG_RTW88_8821C)      += rtw88_8821c.o
>  rtw88_8821c-objs               := rtw8821c.o rtw8821c_table.o
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
> index ad2b323a0423c..ccd23902756e1 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8723d.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
> @@ -210,6 +210,12 @@ static void rtw8723de_efuse_parsing(struct
> rtw_efuse *efuse,
>         ether_addr_copy(efuse->addr, map->e.mac_addr);
>  }
>  
> +static void rtw8723du_efuse_parsing(struct rtw_efuse *efuse,
> +                                   struct rtw8723d_efuse *map)
> +{
> +       ether_addr_copy(efuse->addr, map->u.mac_addr);
> +}
> +
>  static int rtw8723d_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>  {
>         struct rtw_efuse *efuse = &rtwdev->efuse;
> @@ -239,6 +245,9 @@ static int rtw8723d_read_efuse(struct rtw_dev
> *rtwdev, u8 *log_map)
>         case RTW_HCI_TYPE_PCIE:
>                 rtw8723de_efuse_parsing(efuse, map);
>                 break;
> +       case RTW_HCI_TYPE_USB:
> +               rtw8723du_efuse_parsing(efuse, map);
> +               break;
>         default:
>                 /* unsupported now */
>                 return -ENOTSUPP;
> @@ -1945,6 +1954,15 @@ static void rtw8723d_pwr_track(struct rtw_dev
> *rtwdev)
>         dm_info->pwr_trk_triggered = false;
>  }
>  
> +static void rtw8723d_fill_txdesc_checksum(struct rtw_dev *rtwdev,
> +                                         struct rtw_tx_pkt_info
> *pkt_info,
> +                                         u8 *txdesc)
> +{
> +       size_t words = 32 / 2; /* calculate the first 32 bytes (16
> words) */
> +
> +       fill_txdesc_checksum_common(txdesc, words);
> +}
> +
>  static struct rtw_chip_ops rtw8723d_ops = {
>         .phy_set_param          = rtw8723d_phy_set_param,
>         .read_efuse             = rtw8723d_read_efuse,
> @@ -1965,6 +1983,7 @@ static struct rtw_chip_ops rtw8723d_ops = {
>         .config_bfee            = NULL,
>         .set_gid_table          = NULL,
>         .cfg_csi_rate           = NULL,
> +       .fill_txdesc_checksum   = rtw8723d_fill_txdesc_checksum,
>  
>         .coex_set_init          = rtw8723d_coex_cfg_init,
>         .coex_set_ant_switch    = NULL,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
> b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
> index 41d35174a5425..8113bd97edf57 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
> @@ -70,6 +70,7 @@ struct rtw8723d_efuse {
>         u8 country_code[2];
>         u8 res[3];
>         struct rtw8723de_efuse e;
> +       struct rtw8723de_efuse u;

The code here looks ridiculously wrong.

Should there be a rtw8723du_efuse struct and an union here?

BTW I found that Ulli's rtw88-usb repo has the same error, but I doubt
whether 8723du support is tested there.

>  };
>  
>  /* phy status page0 */
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> new file mode 100644
> index 0000000000000..910f64c168131
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +#include "main.h"
> +#include "rtw8723du.h"
> +#include "usb.h"
> +
> +static const struct usb_device_id rtw_8723du_id_table[] = {
> +       /*
> +        * ULLI :
> +        * ID found in rtw8822bu sources
> +        */
> +       { USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK,
> +                                       0xD723,
> +                                       0xff, 0xff, 0xff),
> +         .driver_info = (kernel_ulong_t)&(rtw8723d_hw_spec) }, /*
> 8723DU 1*1 */
> +       { },
> +};
> +MODULE_DEVICE_TABLE(usb, rtw_8723du_id_table);
> +
> +static int rtw8723du_probe(struct usb_interface *intf,
> +                           const struct usb_device_id *id)
> +{
> +       return rtw_usb_probe(intf, id);
> +}
> +
> +static struct usb_driver rtw_8723du_driver = {
> +       .name = "rtw_8723du",
> +       .id_table = rtw_8723du_id_table,
> +       .probe = rtw8723du_probe,
> +       .disconnect = rtw_usb_disconnect,
> +};
> +module_usb_driver(rtw_8723du_driver);
> +
> +MODULE_AUTHOR("Hans Ulli Kroll <linux@ulli-kroll.de>");
> +MODULE_DESCRIPTION("Realtek 802.11n wireless 8723du driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723du.h
> b/drivers/net/wireless/realtek/rtw88/rtw8723du.h
> new file mode 100644
> index 0000000000000..2e069f65c0551
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723du.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> +/* Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#ifndef __RTW_8723DU_H_
> +#define __RTW_8723DU_H_
> +
> +/* USB Vendor/Product IDs */
> +#define RTW_USB_VENDOR_ID_REALTEK              0x0BDA
> +
> +extern struct rtw_chip_info rtw8723d_hw_spec;
> +
> +#endif


