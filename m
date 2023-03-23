Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77876C5C89
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 03:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCWCXs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Mar 2023 22:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCWCXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 22:23:47 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4FF76A5;
        Wed, 22 Mar 2023 19:23:45 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N2NAWV0032672, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N2NAWV0032672
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 10:23:10 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 23 Mar 2023 10:23:25 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 23 Mar 2023 10:23:24 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 10:23:24 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZW3PmZA7gPA0kmU6G6BuQjRUl4q8HoQbg
Date:   Thu, 23 Mar 2023 02:23:24 +0000
Message-ID: <f7b9dda9d852456caffc3c0572f88947@realtek.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230320213508.2358213-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/22_=3F=3F_11:29:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Tuesday, March 21, 2023 5:35 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Larry Finger <Larry.Finger@lwfinger.net>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
> 
> Add a sub-driver for SDIO based chipsets which implements the following
> functionality:
> - register accessors for 8, 16 and 32 bits for all states of the card
>   (including usage of 4x 8 bit access for one 32 bit buffer if the card
>   is not fully powered on yet - or if it's fully powered on then 1x 32
>   bit access is used)
> - checking whether there's space in the TX FIFO queue to transmit data
> - transfers from the host to the device for actual network traffic,
>   reserved pages (for firmware download) and H2C (host-to-card)
>   transfers
> - receiving data from the device
> - deep power saving state
> 
> The transmit path is optimized so DMA-capable SDIO host controllers can
> directly use the buffers provided because the buffer's physical
> addresses are 8 byte aligned.
> 
> The receive path is prepared to support RX aggregation where the
> chipset combines multiple MAC frames into one bigger buffer to reduce
> SDIO transfer overhead.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v2:
> - add sdio.h include in patch 2 already (instead of patch 3) as
>   suggested by Larry Finger (thank you!) so the build doesn't break
>   during bisect
> - move #include "main.h" from sdio.h to sdio.c
> - sort includes in sdio.c alphabetically as suggested by Ping-Ke
>   (except main.h, which must be included before other rtw88 headers)
> - don't use memcpy to copy struct ieee80211_rx_status in
>   rtw_sdio_rx_skb() as suggested by Ping-Ke
> - prevent infinite looping in rtw_sdio_rx_isr() by limiting the number
>   of bytes to process for one interrupt (if more bytes need to be
>   received the interrupt will immediately fire again - tested by
>   limiting to one transfer, which then hurt RX performance a lot as it
>   went down from 19Mbit/s to 0.5Mbit/s). 64k was chosen as it doesn't
>   hurt RX performance and still prevents infinite loops
> - don't disable RX aggregation for RTL8822CS anymore (either the most
>   recent firmware v9.9.14 had some impact on this or an update of my
>   main AP's firmware improved this) the RX throughput is within 5%
>   regardless of whether RX aggregation is enabled or disabled
> - fix suspend/resume cycle by enabling MMC_PM_KEEP_POWER in
>   rtw_sdio_suspend() as for example reported by Chris Morgan
> - fix smatch false positive "uninitialized symbol 'ret'" in
>   rtw_sdio_read_indirect_bytes() by initializing ret to 0 (Ping-Ke
>   suggested that it may be because "it considers 'count = 0' is
>   possible"). Thanks for the suggestion!
> 
> Changes since v1:
> - fixed size_t printk format in rtw_sdio_{read,write}_port as reported
>   by the Intel kernel test robot
> - return -EINVAL from the 11n wcpu case in rtw_sdio_check_free_txpg to
>   fix an uninitialized variable (pages_free) warning as reported by
>   the Intel kernel test robot
> - rename all int *ret to int *err_ret for better consistency with the
>   sdio_readX functions as suggested by Ping-Ke
> - fix typos to use "if (!*err_ret ..." (to read the error code)
>   instead of "if (!err_ret ..." (which just checks if a non-null
>   pointer was passed) in rtw_sdio_read_indirect{8,32})
> - use a u8 tmp variable for reading the indirect status (BIT(4)) in
>   rtw_sdio_read_indirect32
> - change buf[0] to buf[i] in rtw_sdio_read_indirect_bytes
> - remove stray semicolon after rtw_sdio_get_tx_qsel
> - add proper BIT_RXDMA_AGG_PG_TH, BIT_DMA_AGG_TO_V1, BIT_HCI_SUS_REQ,
>   BIT_HCI_RESUME_RDY and BIT_SDIO_PAD_E5 macros as suggested by
>   Ping-Ke (thanks for sharing these names!)
> - use /* ... */ style for copyright comments
> - don't infinitely loop in rtw_sdio_process_tx_queue and limit the
>   number of skbs to process per queue to 1000 in rtw_sdio_tx_handler
> - add bus_claim check to rtw_sdio_read_port() so it works similar to
>   rtw_sdio_write_port() (meaning it can be used from interrupt and
>   non interrupt context)
> - enable RX aggregation on all chips except RTL8822CS (where it hurts
>   RX performance)
> - use rtw_tx_fill_txdesc_checksum() helper instead of open-coding it
> - re-use RTW_FLAG_POWERON instead of a new .power_switch callback
> - added Ulf's Reviewed-by (who had a look at the SDIO specific bits,
>   thank you!)
> 
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
>  drivers/net/wireless/realtek/rtw88/Makefile |    3 +
>  drivers/net/wireless/realtek/rtw88/debug.h  |    1 +
>  drivers/net/wireless/realtek/rtw88/mac.c    |    1 +
>  drivers/net/wireless/realtek/rtw88/mac.h    |    1 -
>  drivers/net/wireless/realtek/rtw88/reg.h    |   12 +
>  drivers/net/wireless/realtek/rtw88/sdio.c   | 1252 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/sdio.h   |  173 +++
>  8 files changed, 1445 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h
> 

[...]

> +static u16 rtw_sdio_read16(struct rtw_dev *rtwdev, u32 addr)
> +{
> +       struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +       bool direct, bus_claim;
> +       u8 buf[2];
> +       int ret;
> +       u16 val;
> +
> +       bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
> +       direct = rtw_sdio_is_bus_addr(addr);
> +
> +       if (bus_claim)
> +               sdio_claim_host(rtwsdio->sdio_func);
> +
> +       if (direct) {
> +               addr = rtw_sdio_to_bus_offset(rtwdev, addr);
> +               buf[0] = sdio_readb(rtwsdio->sdio_func, addr, &ret);
> +               if (!ret)
> +                       buf[1] = sdio_readb(rtwsdio->sdio_func, addr + 1, &ret);
> +               val = le16_to_cpu(*(__le16 *)buf);
> +       } else if (addr & 1) {

else if (IS_ALIGNED(addr, 2) {

> +               ret = rtw_sdio_read_indirect_bytes(rtwdev, addr, buf, 2);
> +               val = le16_to_cpu(*(__le16 *)buf);
> +       } else {
> +               val = rtw_sdio_read_indirect32(rtwdev, addr, &ret);
> +       }
> +
> +       if (bus_claim)
> +               sdio_release_host(rtwsdio->sdio_func);
> +
> +       if (ret)
> +               rtw_warn(rtwdev, "sdio read16 failed (0x%x): %d", addr, ret);
> +
> +       return val;
> +}
> +
> +static u32 rtw_sdio_read32(struct rtw_dev *rtwdev, u32 addr)
> +{
> +       struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +       bool direct, bus_claim;
> +       u8 buf[4];
> +       u32 val;
> +       int ret;
> +
> +       bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
> +       direct = rtw_sdio_is_bus_addr(addr);
> +
> +       if (bus_claim)
> +               sdio_claim_host(rtwsdio->sdio_func);
> +
> +       if (direct) {
> +               addr = rtw_sdio_to_bus_offset(rtwdev, addr);
> +               val = rtw_sdio_readl(rtwdev, addr, &ret);
> +       } else if (addr & 3) {

else if (IS_ALIGNED(addr, 4) {

> +               ret = rtw_sdio_read_indirect_bytes(rtwdev, addr, buf, 4);
> +               val = le32_to_cpu(*(__le32 *)buf);
> +       } else {
> +               val = rtw_sdio_read_indirect32(rtwdev, addr, &ret);
> +       }
> +
> +       if (bus_claim)
> +               sdio_release_host(rtwsdio->sdio_func);
> +
> +       if (ret)
> +               rtw_warn(rtwdev, "sdio read32 failed (0x%x): %d", addr, ret);
> +
> +       return val;
> +}
> +

[...]

> +int rtw_sdio_probe(struct sdio_func *sdio_func,
> +                  const struct sdio_device_id *id)
> +{
> +       struct ieee80211_hw *hw;
> +       struct rtw_dev *rtwdev;
> +       int drv_data_size;
> +       int ret;
> +
> +       drv_data_size = sizeof(struct rtw_dev) + sizeof(struct rtw_sdio);
> +       hw = ieee80211_alloc_hw(drv_data_size, &rtw_ops);
> +       if (!hw) {
> +               dev_err(&sdio_func->dev, "failed to allocate hw");
> +               return -ENOMEM;
> +       }
> +
> +       rtwdev = hw->priv;
> +       rtwdev->hw = hw;
> +       rtwdev->dev = &sdio_func->dev;
> +       rtwdev->chip = (struct rtw_chip_info *)id->driver_data;
> +       rtwdev->hci.ops = &rtw_sdio_ops;
> +       rtwdev->hci.type = RTW_HCI_TYPE_SDIO;
> +
> +       ret = rtw_core_init(rtwdev);
> +       if (ret)
> +               goto err_release_hw;
> +
> +       rtw_dbg(rtwdev, RTW_DBG_SDIO,
> +               "rtw88 SDIO probe: vendor=0x%04x device=%04x class=%02x",
> +               id->vendor, id->device, id->class);
> +
> +       ret = rtw_sdio_claim(rtwdev, sdio_func);
> +       if (ret) {
> +               rtw_err(rtwdev, "failed to claim SDIO device");
> +               goto err_deinit_core;
> +       }
> +
> +       rtw_sdio_init(rtwdev);
> +
> +       ret = rtw_sdio_init_tx(rtwdev);
> +       if (ret) {
> +               rtw_err(rtwdev, "failed to init SDIO TX queue\n");
> +               goto err_sdio_declaim;
> +       }
> +
> +       ret = rtw_chip_info_setup(rtwdev);
> +       if (ret) {
> +               rtw_err(rtwdev, "failed to setup chip information");
> +               goto err_destroy_txwq;
> +       }
> +
> +       ret = rtw_register_hw(rtwdev, hw);
> +       if (ret) {
> +               rtw_err(rtwdev, "failed to register hw");
> +               goto err_destroy_txwq;
> +       }
> +

Today, people reported there is race condition between register netdev and NAPI
in rtw89 driver. I wonder if there will be in register netdev and request IRQ.

You can add a msleep(10 * 100) here, and then do 'ifconfig up' and 'iw scan'
quickly right after SDIO probe to see if it can work well. Otherwise, switching
the order of rtw_register_hw() and rtw_sdio_request_irq() could be a possible
solution.

> +       ret = rtw_sdio_request_irq(rtwdev, sdio_func);
> +       if (ret)
> +               goto err_unregister_hw;
> +
> +       return 0;
> +
> +err_unregister_hw:
> +       rtw_unregister_hw(rtwdev, hw);
> +err_destroy_txwq:
> +       rtw_sdio_deinit_tx(rtwdev);
> +err_sdio_declaim:
> +       rtw_sdio_declaim(rtwdev, sdio_func);
> +err_deinit_core:
> +       rtw_core_deinit(rtwdev);
> +err_release_hw:
> +       ieee80211_free_hw(hw);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(rtw_sdio_probe);

[...]

Only minor comments.

Ping-Ke

