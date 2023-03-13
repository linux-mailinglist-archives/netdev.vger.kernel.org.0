Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD76B71F5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCMJD7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 05:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCMJDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:03:32 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CE35CEDE;
        Mon, 13 Mar 2023 01:59:32 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32D8x7OC1002005, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32D8x7OC1002005
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Mar 2023 16:59:07 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 13 Mar 2023 16:58:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 13 Mar 2023 16:58:31 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Mar 2023 16:58:31 +0800
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
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 RFC 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [PATCH v2 RFC 2/9] wifi: rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZU48RuwSN13p1cEWN5arWdO1W5K74ACNg
Date:   Mon, 13 Mar 2023 08:58:31 +0000
Message-ID: <028947beef90440599fed50a513ba9cf@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230310202922.2459680-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/13_=3F=3F_07:09:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, March 11, 2023 4:29 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 RFC 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
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
>  drivers/net/wireless/realtek/rtw88/mac.h    |    1 -
>  drivers/net/wireless/realtek/rtw88/reg.h    |   12 +
>  drivers/net/wireless/realtek/rtw88/sdio.c   | 1251 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/sdio.h   |  175 +++
>  7 files changed, 1445 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h
> 

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
> new file mode 100644
> index 000000000000..915d641d9226
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -0,0 +1,1251 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (C) 2021 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> + * Copyright (C) 2021 Jernej Skrabec <jernej.skrabec@gmail.com>
> + *
> + * Based on rtw88/pci.c:
> + *   Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/sdio_func.h>
> +#include "sdio.h"
> +#include "reg.h"
> +#include "tx.h"
> +#include "rx.h"
> +#include "fw.h"
> +#include "ps.h"
> +#include "debug.h"

How about making them in alphabetical order?

[...]

> +static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
> +                           u32 pkt_offset, struct rtw_rx_pkt_stat *pkt_stat,
> +                           struct ieee80211_rx_status *rx_status)
> +{
> +       memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));

nit: IEEE80211_SKB_RXCB(skb) = *rx_status;

Then, compiler can help to check the type.

> +
> +       if (pkt_stat->is_c2h) {
> +               skb_put(skb, pkt_stat->pkt_len + pkt_offset);
> +               rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, skb);
> +               return;
> +       }
> +
> +       skb_put(skb, pkt_stat->pkt_len);
> +       skb_reserve(skb, pkt_offset);
> +
> +       rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
> +
> +       ieee80211_rx_irqsafe(rtwdev->hw, skb);
> +}
> +
> +static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
> +{
> +       struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +       const struct rtw_chip_info *chip = rtwdev->chip;
> +       u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
> +       struct ieee80211_rx_status rx_status;
> +       struct rtw_rx_pkt_stat pkt_stat;
> +       struct sk_buff *skb, *split_skb;
> +       u32 pkt_offset, curr_pkt_len;
> +       size_t bufsz;
> +       u8 *rx_desc;
> +       int ret;
> +
> +       bufsz = sdio_align_size(rtwsdio->sdio_func, rx_len);
> +
> +       skb = dev_alloc_skb(bufsz);
> +       if (!skb)
> +               return;
> +
> +       ret = rtw_sdio_read_port(rtwdev, skb->data, bufsz);
> +       if (ret) {
> +               dev_kfree_skb_any(skb);
> +               return;
> +       }
> +
> +       while (true) {
> +               rx_desc = skb->data;
> +               chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat,
> +                                        &rx_status);
> +               pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
> +                            pkt_stat.shift;
> +
> +               curr_pkt_len = ALIGN(pkt_offset + pkt_stat.pkt_len,
> +                                    RTW_SDIO_DATA_PTR_ALIGN);
> +
> +               if ((curr_pkt_len + pkt_desc_sz) >= rx_len) {
> +                       /* Use the original skb (with it's adjusted offset)
> +                        * when processing the last (or even the only) entry to
> +                        * have it's memory freed automatically.
> +                        */
> +                       rtw_sdio_rx_skb(rtwdev, skb, pkt_offset, &pkt_stat,
> +                                       &rx_status);
> +                       break;
> +               }
> +
> +               split_skb = dev_alloc_skb(curr_pkt_len);
> +               if (!split_skb) {
> +                       rtw_sdio_rx_skb(rtwdev, skb, pkt_offset, &pkt_stat,
> +                                       &rx_status);
> +                       break;
> +               }
> +
> +               skb_copy_header(split_skb, skb);
> +               memcpy(split_skb->data, skb->data, curr_pkt_len);
> +
> +               rtw_sdio_rx_skb(rtwdev, split_skb, pkt_offset, &pkt_stat,
> +                               &rx_status);
> +
> +               /* Move to the start of the next RX descriptor */
> +               skb_reserve(skb, curr_pkt_len);
> +               rx_len -= curr_pkt_len;
> +       }
> +}
> +
> +static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
> +{
> +       u32 rx_len;
> +
> +       while (true) {

I forget if we have discussed this in v1, but it would be better to have a hard
retry limit in driver, like 500. Will we miss to receive packets if break this
loop early?


> +               if (rtw_chip_wcpu_11n(rtwdev))
> +                       rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
> +               else
> +                       rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
> +
> +               if (!rx_len)
> +                       break;
> +
> +               rtw_sdio_rxfifo_recv(rtwdev, rx_len);
> +       }
> +}
> +

[...]


