Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2069E994
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 22:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjBUVhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 16:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBUVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 16:37:34 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D189D29147;
        Tue, 21 Feb 2023 13:37:29 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id t14so3125144ljd.5;
        Tue, 21 Feb 2023 13:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ng3aDlLBypK1qhWgqGsl5Hs0htRTiwY5/G3GHLpJDi8=;
        b=Y0EDVOG8QH6nbDn9Ftt3WuOeY4L6hr759cdGIu15QfIrhqC9zi7HS+dKakVu/XDgRX
         SSiHz/eI8XfMSw7/wIEXhYGj2nArsLNeIMmhn81lbi5uK2Ndl4qW1ak53AYaLJyHDkEu
         15aSdZNPMKXIPr/m+y0TScHkzq59IlZAwUty8ZxYBm9VJc1XyYTCfokUWbGBmEMWuWhk
         a7A2DnnUSyfN/poMUJcbdWt06FYknJtnBfm01XxxDBUl27KlODc+1JdufEtF9kRA2TjW
         Xnm+VpEV20hUecyrzkXi9MgE0l0ogGhPTIA8jLLKrF72RADuKSUAKm/BibxnOQAt7Gbq
         Sk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ng3aDlLBypK1qhWgqGsl5Hs0htRTiwY5/G3GHLpJDi8=;
        b=0C+IzqGUK5gujnXlHARSPzG2bvxXmG7s3/0lKBV349/TU3btTvN1enhDVeEsw4bLaY
         SBQyRbO7NtCaDTfcLGsIEJ7GQKyRxJGbTwoM3VHzINhKVs8yMpMXb9AyvEepSUhHW0ZY
         j+qnTcFHy5hpXgAqMFGFqLkiaGFKBBg6IMRTiNeMVYnfxo9kEFabcgHbDHK4TZs4R7CW
         8MubzJMKPXW+ExqfswevKNGZMkoJNDrYlfZPYivu9pL4wrG22PVjknLbxg0vJatuZ9ve
         KN3RZr2Lz0sNrc2G1Az1utJwmErmI0f0Qbu+IUkNbbR1vksuZ4xXitvF9lVCq9ihseIW
         XPCA==
X-Gm-Message-State: AO0yUKXLtPx3m928yILLmKmSiisH5utkze+Wq+Coa92o3xru6h9D8c4y
        fyMN0eKoI7ZWAz0SwxfVIj1ropm0f6hOax/v3Ls=
X-Google-Smtp-Source: AK7set93Lf018OUfirtEuvNuilSSgcGN9XIDjgx2CkxBmqXqGWXz9IRlNZ08vhxAbkLLdIXcoaizRMtFCjB5/b1TYrM=
X-Received: by 2002:a05:651c:205e:b0:293:4fd1:6105 with SMTP id
 t30-20020a05651c205e00b002934fd16105mr2048286ljo.9.1677015447619; Tue, 21 Feb
 2023 13:37:27 -0800 (PST)
MIME-Version: 1.0
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com> <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
In-Reply-To: <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Feb 2023 13:37:15 -0800
Message-ID: <CABBYNZLod2-2biJzre+OSFepBQFWo0ApD3Jkn8WAWyrei-rKdg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neeraj,

On Tue, Feb 21, 2023 at 8:26 AM Neeraj Sanjay Kale
<neeraj.sanjaykale@nxp.com> wrote:
>
> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
>
> This driver has Power Save feature that will put the chip into sleep
> state whenever there is no activity for 2000ms, and will be woken up when
> any activity is to be initiated over UART.
>
> This driver enables the power save feature by default by sending the
> vendor specific commands to the chip during setup.
>
> During setup, the driver checks if a FW is already running on the chip
> based on the CTS line, and downloads device specific FW file into the
> chip over UART.
>
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based
> on compatibility devices mentioned in DT bindings. Handled potential
> memory leaks and null pointer dereference issues, simplified FW download
> feature, handled byte-order and few cosmetic changes. (Ilpo J=C3=A4rvinen=
,
> Alok Tiwari, Hillf Danton)
> v3: Added conf file support necessary to support different vendor modules=
,
> moved .h file contents to .c, cosmetic changes. (Luiz Augusto von Dentz,
> Rob Herring, Leon Romanovsky)
> v4: Removed conf file support, optimized driver data, add logic to
> select FW name based on chip signature (Greg KH, Ilpo Jarvinen, Sherry
> Sun)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1292 +++++++++++++++++++++++++++++++++
>  4 files changed, 1305 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d36f52dc124..7343f4943458 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22840,6 +22840,7 @@ M:      Amitkumar Karwar <amitkumar.karwar@nxp.co=
m>
>  M:     Neeraj Kale <neeraj.sanjaykale@nxp.com>
>  S:     Maintained
>  F:     Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml
> +F:     drivers/bluetooth/btnxpuart.c
>
>  THE REST
>  M:     Linus Torvalds <torvalds@linux-foundation.org>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..359a4833e31f 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -465,4 +465,15 @@ config BT_VIRTIO
>           Say Y here to compile support for HCI over Virtio into the
>           kernel or say M to compile as a module.
>
> +config BT_NXPUART
> +       tristate "NXP protocol support"
> +       depends on SERIAL_DEV_BUS
> +       help
> +         NXP is serial driver required for NXP Bluetooth
> +         devices with UART interface.
> +
> +         Say Y here to compile support for NXP Bluetooth UART device int=
o
> +         the kernel, or say M here to compile as a module (btnxpuart).
> +
> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index e0b261f24fc9..7a5967e9ac48 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)          +=3D btqca.o
>  obj-$(CONFIG_BT_MTK)           +=3D btmtk.o
>
>  obj-$(CONFIG_BT_VIRTIO)                +=3D virtio_bt.o
> +obj-$(CONFIG_BT_NXPUART)       +=3D btnxpuart.o
>
>  obj-$(CONFIG_BT_HCIUART_NOKIA) +=3D hci_nokia.o
>
> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.=
c
> new file mode 100644
> index 000000000000..608185be2b30
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1292 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/serdev.h>
> +#include <linux/of.h>
> +#include <linux/skbuff.h>
> +#include <asm/unaligned.h>
> +#include <linux/firmware.h>
> +#include <linux/string.h>
> +#include <linux/crc8.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include "h4_recv.h"
> +
> +#define MANUFACTURER_NXP               37
> +
> +#define BTNXPUART_TX_STATE_ACTIVE      1
> +#define BTNXPUART_FW_DOWNLOADING       2
> +
> +#define FIRMWARE_W8987 "nxp/uartuart8987_bt.bin"
> +#define FIRMWARE_W8997 "nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098 "nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416 "nxp/uartiw416_bt_v0.bin"
> +#define FIRMWARE_IW612 "nxp/uartspi_n61x_v1.bin.se"
> +
> +#define CHIP_ID_W9098          0x5c03
> +#define CHIP_ID_IW416          0x7201
> +#define CHIP_ID_IW612          0x7601
> +
> +#define HCI_NXP_PRI_BAUDRATE   115200
> +#define HCI_NXP_SEC_BAUDRATE   3000000
> +
> +#define MAX_FW_FILE_NAME_LEN    50
> +
> +/* Default ps timeout period in milli-second */
> +#define PS_DEFAULT_TIMEOUT_PERIOD     2000
> +
> +/* wakeup methods */
> +#define WAKEUP_METHOD_DTR       0
> +#define WAKEUP_METHOD_BREAK     1
> +#define WAKEUP_METHOD_EXT_BREAK 2
> +#define WAKEUP_METHOD_RTS       3
> +#define WAKEUP_METHOD_INVALID   0xff
> +
> +/* power save mode status */
> +#define PS_MODE_DISABLE         0
> +#define PS_MODE_ENABLE          1
> +
> +/* Power Save Commands to ps_work_func  */
> +#define PS_CMD_EXIT_PS          1
> +#define PS_CMD_ENTER_PS         2
> +
> +/* power save state */
> +#define PS_STATE_AWAKE          0
> +#define PS_STATE_SLEEP          1
> +
> +/* Bluetooth vendor command : Sleep mode */
> +#define HCI_NXP_AUTO_SLEEP_MODE        0xfc23
> +/* Bluetooth vendor command : Wakeup method */
> +#define HCI_NXP_WAKEUP_METHOD  0xfc53
> +/* Bluetooth vendor command : Set operational baudrate */
> +#define HCI_NXP_SET_OPER_SPEED 0xfc09
> +/* Bluetooth vendor command: Independent Reset */
> +#define HCI_NXP_IND_RESET      0xfcfc
> +
> +/* Bluetooth Power State : Vendor cmd params */
> +#define BT_PS_ENABLE                   0x02
> +#define BT_PS_DISABLE                  0x03
> +
> +/* Bluetooth Host Wakeup Methods */
> +#define BT_HOST_WAKEUP_METHOD_NONE      0x00
> +#define BT_HOST_WAKEUP_METHOD_DTR       0x01
> +#define BT_HOST_WAKEUP_METHOD_BREAK     0x02
> +#define BT_HOST_WAKEUP_METHOD_GPIO      0x03
> +
> +/* Bluetooth Chip Wakeup Methods */
> +#define BT_CTRL_WAKEUP_METHOD_DSR       0x00
> +#define BT_CTRL_WAKEUP_METHOD_BREAK     0x01
> +#define BT_CTRL_WAKEUP_METHOD_GPIO      0x02
> +#define BT_CTRL_WAKEUP_METHOD_EXT_BREAK 0x04
> +#define BT_CTRL_WAKEUP_METHOD_RTS       0x05
> +
> +struct ps_data {
> +       u8    ps_mode;
> +       u8    cur_psmode;
> +       u8    ps_state;
> +       u8    ps_cmd;
> +       u8    wakeupmode;
> +       u8    cur_wakeupmode;
> +       bool  driver_sent_cmd;
> +       bool  timer_on;
> +       u32   interval;
> +       struct hci_dev *hdev;
> +       struct work_struct work;
> +       struct timer_list ps_timer;
> +};
> +
> +struct btnxpuart_data {
> +       bool fw_dnld_use_high_baudrate;
> +       const u8 *fw_name;
> +};
> +
> +struct btnxpuart_dev {
> +       struct hci_dev *hdev;
> +       struct serdev_device *serdev;
> +
> +       struct work_struct tx_work;
> +       unsigned long tx_state;
> +       struct sk_buff_head txq;
> +       struct sk_buff *rx_skb;
> +
> +       const struct firmware *fw;
> +       u8 fw_name[MAX_FW_FILE_NAME_LEN];
> +       u32 fw_dnld_v1_offset;
> +       u32 fw_v1_sent_bytes;
> +       u32 fw_v3_offset_correction;
> +       u32 fw_v1_expected_len;
> +       wait_queue_head_t suspend_wait_q;
> +
> +       u32 new_baudrate;
> +       u32 current_baudrate;
> +       bool timeout_changed;
> +       bool baudrate_changed;
> +
> +       struct ps_data *psdata;
> +       struct btnxpuart_data *nxp_data;
> +};
> +
> +#define NXP_V1_FW_REQ_PKT      0xa5
> +#define NXP_V1_CHIP_VER_PKT    0xaa
> +#define NXP_V3_FW_REQ_PKT      0xa7
> +#define NXP_V3_CHIP_VER_PKT    0xab
> +
> +#define NXP_ACK_V1             0x5a
> +#define NXP_NAK_V1             0xbf
> +#define NXP_ACK_V3             0x7a
> +#define NXP_NAK_V3             0x7b
> +#define NXP_CRC_ERROR_V3       0x7c
> +
> +#define HDR_LEN                        16
> +
> +#define NXP_RECV_FW_REQ_V1 \
> +       .type =3D NXP_V1_FW_REQ_PKT, \
> +       .hlen =3D 4, \
> +       .loff =3D 0, \
> +       .lsize =3D 0, \
> +       .maxlen =3D 4
> +
> +#define NXP_RECV_CHIP_VER_V3 \
> +       .type =3D NXP_V3_CHIP_VER_PKT, \
> +       .hlen =3D 4, \
> +       .loff =3D 0, \
> +       .lsize =3D 0, \
> +       .maxlen =3D 4
> +
> +#define NXP_RECV_FW_REQ_V3 \
> +       .type =3D NXP_V3_FW_REQ_PKT, \
> +       .hlen =3D 9, \
> +       .loff =3D 0, \
> +       .lsize =3D 0, \
> +       .maxlen =3D 9
> +
> +struct v1_data_req {
> +       __le16 len;
> +       __le16 len_comp;
> +} __packed;
> +
> +struct v3_data_req {
> +       __le16 len;
> +       __le32 offset;
> +       __le16 error;
> +       u8 crc;
> +} __packed;
> +
> +struct v3_start_ind {
> +       __le16 chip_id;
> +       u8 loader_ver;
> +       u8 crc;
> +} __packed;
> +
> +/* UART register addresses of BT chip */
> +#define CLKDIVADDR     0x7f00008f
> +#define UARTDIVADDR    0x7f000090
> +#define UARTMCRADDR    0x7f000091
> +#define UARTREINITADDR 0x7f000092
> +#define UARTICRADDR    0x7f000093
> +#define UARTFCRADDR    0x7f000094
> +
> +#define MCR            0x00000022
> +#define INIT           0x00000001
> +#define ICR            0x000000c7
> +#define FCR            0x000000c7
> +
> +#define POLYNOMIAL8    0x07
> +#define POLYNOMIAL32   0x04c11db7L
> +
> +struct uart_reg {
> +       __le32 address;
> +       __le32 value;
> +} __packed;
> +
> +struct uart_config {
> +       struct uart_reg clkdiv;
> +       struct uart_reg uartdiv;
> +       struct uart_reg mcr;
> +       struct uart_reg re_init;
> +       struct uart_reg icr;
> +       struct uart_reg fcr;
> +       __le32 crc;
> +} __packed;
> +
> +struct nxp_bootloader_cmd {
> +       __le32 header;
> +       __le32 arg;
> +       __le32 payload_len;
> +       __le32 crc;
> +} __packed;
> +
> +static u8 crc8_table[CRC8_TABLE_SIZE];
> +static unsigned long crc32_table[256];
> +
> +/* Default Power Save configuration */
> +static int wakeupmode =3D WAKEUP_METHOD_BREAK;
> +static int ps_mode =3D PS_MODE_ENABLE;
> +
> +static int init_baudrate =3D 115200;
> +
> +static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode=
,
> +                                       u32 plen,
> +                                       void *param)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       struct sk_buff *skb;
> +
> +       psdata->driver_sent_cmd =3D true; /* set flag to prevent re-sendi=
ng command in nxp_enqueue */
> +       skb =3D __hci_cmd_sync(hdev, opcode, plen, param, HCI_CMD_TIMEOUT=
);
> +       psdata->driver_sent_cmd =3D false;
> +
> +       return skb;
> +}
> +
> +static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +       if (schedule_work(&nxpdev->tx_work))
> +               set_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +/* NXP Power Save Feature */
> +static void ps_start_timer(struct btnxpuart_dev *nxpdev)
> +{
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +
> +       if (!psdata)
> +               return;
> +
> +       if (psdata->cur_psmode =3D=3D PS_MODE_ENABLE) {
> +               psdata->timer_on =3D true;
> +               mod_timer(&psdata->ps_timer, jiffies + msecs_to_jiffies(p=
sdata->interval));
> +       }
> +}
> +
> +static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
> +{
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +
> +       if (!psdata)
> +               return;
> +
> +       flush_work(&psdata->work);
> +       if (psdata->timer_on)
> +               del_timer_sync(&psdata->ps_timer);
> +       kfree(psdata);

It seems that ps_cancel_timer is only called when unregister so
psdata, wouldn't be used anymore, but in case ps_cancel_timer would be
reused in the future this would become a problem so I recommend moving
it out if it.

> +}
> +
> +static void ps_control(struct hci_dev *hdev, u8 ps_state)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       int status;
> +
> +       if (psdata->ps_state =3D=3D ps_state)
> +               return;
> +
> +       switch (psdata->cur_wakeupmode) {
> +       case WAKEUP_METHOD_DTR:
> +               if (ps_state =3D=3D PS_STATE_AWAKE)
> +                       serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR=
, 0);
> +               else
> +                       serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_=
DTR);
> +               break;
> +       case WAKEUP_METHOD_BREAK:
> +       default:
> +               if (ps_state =3D=3D PS_STATE_AWAKE)
> +                       status =3D serdev_device_break_ctl(nxpdev->serdev=
, 0);
> +               else
> +                       status =3D serdev_device_break_ctl(nxpdev->serdev=
, -1);
> +               bt_dev_info(hdev, "Set UART break: %s, status=3D%d",
> +                           ps_state =3D=3D PS_STATE_AWAKE ? "off" : "on"=
, status);
> +               break;
> +       }
> +       psdata->ps_state =3D ps_state;
> +       if (ps_state =3D=3D PS_STATE_AWAKE)
> +               btnxpuart_tx_wakeup(nxpdev);
> +}
> +
> +static void ps_work_func(struct work_struct *work)
> +{
> +       struct ps_data *data =3D container_of(work, struct ps_data, work)=
;
> +
> +       if (!data)
> +               return;
> +
> +       if (data->ps_cmd =3D=3D PS_CMD_ENTER_PS && data->cur_psmode =3D=
=3D PS_MODE_ENABLE)
> +               ps_control(data->hdev, PS_STATE_SLEEP);
> +       else if (data->ps_cmd =3D=3D PS_CMD_EXIT_PS)
> +               ps_control(data->hdev, PS_STATE_AWAKE);
> +}
> +
> +static void ps_timeout_func(struct timer_list *t)
> +{
> +       struct ps_data *data =3D from_timer(data, t, ps_timer);
> +       struct hci_dev *hdev =3D data->hdev;
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +
> +       data->timer_on =3D false;
> +       if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +               ps_start_timer(nxpdev);
> +       } else {
> +               data->ps_cmd =3D PS_CMD_ENTER_PS;
> +               schedule_work(&data->work);
> +       }
> +}
> +
> +static int ps_init_work(struct hci_dev *hdev)
> +{
> +       struct ps_data *psdata =3D kzalloc(sizeof(*psdata), GFP_KERNEL);
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +
> +       if (!psdata) {
> +               bt_dev_err(hdev, "Can't allocate control structure for Po=
wer Save feature");
> +               return -ENOMEM;
> +       }
> +       nxpdev->psdata =3D psdata;
> +
> +       psdata->interval =3D PS_DEFAULT_TIMEOUT_PERIOD;
> +       psdata->ps_state =3D PS_STATE_AWAKE;
> +       psdata->ps_mode =3D ps_mode;
> +       psdata->hdev =3D hdev;
> +
> +       switch (wakeupmode) {
> +       case WAKEUP_METHOD_DTR:
> +               psdata->wakeupmode =3D WAKEUP_METHOD_DTR;
> +               break;
> +       case WAKEUP_METHOD_BREAK:
> +       default:
> +               psdata->wakeupmode =3D WAKEUP_METHOD_BREAK;
> +               break;
> +       }
> +       psdata->cur_psmode =3D PS_MODE_DISABLE;
> +       psdata->cur_wakeupmode =3D WAKEUP_METHOD_INVALID;
> +       INIT_WORK(&psdata->work, ps_work_func);
> +
> +       return 0;
> +}
> +
> +static void ps_init_timer(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +
> +       psdata->timer_on =3D false;
> +       timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
> +}
> +
> +static int ps_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +
> +       if (psdata->ps_state =3D=3D PS_STATE_AWAKE)
> +               return 0;
> +       psdata->ps_cmd =3D PS_CMD_EXIT_PS;
> +       schedule_work(&psdata->work);
> +
> +       return 1;
> +}
> +
> +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       u8 pcmd;
> +       struct sk_buff *skb;
> +       u8 *status;
> +
> +       if (psdata->ps_mode =3D=3D PS_MODE_ENABLE)
> +               pcmd =3D BT_PS_ENABLE;
> +       else
> +               pcmd =3D BT_PS_DISABLE;
> +
> +       skb =3D nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd)=
;
> +       if (IS_ERR(skb)) {
> +               bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", =
PTR_ERR(skb));
> +               return PTR_ERR(skb);
> +       }
> +
> +       status =3D skb_pull_data(skb, 1);
> +       if (status) {
> +               if (!*status)
> +                       psdata->cur_psmode =3D psdata->ps_mode;
> +               else
> +                       psdata->ps_mode =3D psdata->cur_psmode;
> +               if (psdata->cur_psmode =3D=3D PS_MODE_ENABLE)
> +                       ps_start_timer(nxpdev);
> +               else
> +                       ps_wakeup(nxpdev);
> +               bt_dev_info(hdev, "Power Save mode response: status=3D%d,=
 ps_mode=3D%d",
> +                           *status, psdata->cur_psmode);

Like Greg already mentioned the above should probably be converted to
bt_dev_dbg otherwise we just flood the logs with message that are not
really useful if you are not debugging this driver.

> +       }
> +       kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       u8 pcmd[4];
> +       struct sk_buff *skb;
> +       u8 *status;
> +
> +       pcmd[0] =3D BT_HOST_WAKEUP_METHOD_NONE;
> +       pcmd[1] =3D 0xff;
> +       switch (psdata->wakeupmode) {
> +       case WAKEUP_METHOD_DTR:
> +               pcmd[2] =3D BT_CTRL_WAKEUP_METHOD_DSR;
> +               break;
> +       case WAKEUP_METHOD_BREAK:
> +       default:
> +               pcmd[2] =3D BT_CTRL_WAKEUP_METHOD_BREAK;
> +               break;
> +       }
> +       pcmd[3] =3D 0xff;
> +
> +       skb =3D nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, 4, pcmd);
> +       if (IS_ERR(skb)) {
> +               bt_dev_err(hdev, "Setting wake-up method failed (%ld)", P=
TR_ERR(skb));
> +               return PTR_ERR(skb);
> +       }
> +
> +       status =3D skb_pull_data(skb, 1);
> +       if (status) {
> +               if (*status =3D=3D 0)
> +                       psdata->cur_wakeupmode =3D psdata->wakeupmode;
> +               else
> +                       psdata->wakeupmode =3D psdata->cur_wakeupmode;
> +               bt_dev_info(hdev, "Set Wakeup Method response: status=3D%=
d, wakeupmode=3D%d",
> +                           *status, psdata->cur_wakeupmode);

Ditto.

> +       }
> +       kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +static int ps_init(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +
> +       serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_RTS);
> +       usleep_range(5000, 10000);
> +       serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
> +       usleep_range(5000, 10000);
> +
> +       switch (psdata->wakeupmode) {
> +       case WAKEUP_METHOD_DTR:
> +               serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +               serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +               break;
> +       case WAKEUP_METHOD_BREAK:
> +       default:
> +               serdev_device_break_ctl(nxpdev->serdev, -1);
> +               usleep_range(5000, 10000);
> +               serdev_device_break_ctl(nxpdev->serdev, 0);
> +               usleep_range(5000, 10000);
> +               break;
> +       }
> +       if (!test_bit(HCI_RUNNING, &hdev->flags)) {
> +               bt_dev_err(hdev, "HCI_RUNNING is not set");
> +               return -EBUSY;
> +       }
> +       if (psdata->cur_wakeupmode !=3D psdata->wakeupmode)
> +               hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NU=
LL);
> +       if (psdata->cur_psmode !=3D psdata->ps_mode)
> +               hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +
> +       return 0;
> +}
> +
> +/* NXP Firmware Download Feature */
> +static void nxp_fw_dnld_gen_crc32_table(void)
> +{
> +       int i, j;
> +       unsigned long crc_accum;
> +
> +       for (i =3D 0; i < 256; i++) {
> +               crc_accum =3D ((unsigned long)i << 24);
> +               for (j =3D 0; j < 8; j++) {
> +                       if (crc_accum & 0x80000000L)
> +                               crc_accum =3D (crc_accum << 1) ^ POLYNOMI=
AL32;
> +                       else
> +                               crc_accum =3D (crc_accum << 1);
> +               }
> +               crc32_table[i] =3D crc_accum;
> +       }
> +}
> +
> +static unsigned long nxp_fw_dnld_update_crc(unsigned long crc_accum,
> +                                           char *data_blk_ptr,
> +                                           int data_blk_size)
> +{
> +       unsigned long i, j;
> +
> +       for (j =3D 0; j < data_blk_size; j++) {
> +               i =3D ((unsigned long)(crc_accum >> 24) ^ *data_blk_ptr++=
) & 0xff;
> +               crc_accum =3D (crc_accum << 8) ^ crc32_table[i];
> +       }
> +       return crc_accum;
> +}
> +
> +static int nxp_download_firmware(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       int err =3D 0;
> +
> +       nxpdev->fw_dnld_v1_offset =3D 0;
> +       nxpdev->fw_v1_sent_bytes =3D 0;
> +       nxpdev->fw_v1_expected_len =3D HDR_LEN;
> +       nxpdev->fw_v3_offset_correction =3D 0;
> +       nxpdev->baudrate_changed =3D false;
> +       nxpdev->timeout_changed =3D false;
> +
> +       crc8_populate_msb(crc8_table, POLYNOMIAL8);
> +       nxp_fw_dnld_gen_crc32_table();
> +
> +       serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
> +       serdev_device_set_flow_control(nxpdev->serdev, 0);
> +       nxpdev->current_baudrate =3D HCI_NXP_PRI_BAUDRATE;
> +
> +       /* Wait till FW is downloaded and CTS becomes low */
> +       err =3D wait_event_interruptible_timeout(nxpdev->suspend_wait_q,
> +                                              !test_bit(BTNXPUART_FW_DOW=
NLOADING,
> +                                                        &nxpdev->tx_stat=
e),
> +                                              msecs_to_jiffies(60000));
> +       if (err =3D=3D 0) {
> +               bt_dev_err(hdev, "FW Download Timeout.");
> +               return -ETIMEDOUT;
> +       }
> +
> +       serdev_device_set_flow_control(nxpdev->serdev, 1);
> +       err =3D serdev_device_wait_for_cts(nxpdev->serdev, 1, 60000);
> +       if (err < 0) {
> +               bt_dev_err(hdev, "CTS is still high. FW Download failed."=
);
> +               return err;
> +       }
> +       bt_dev_info(hdev, "CTS is low");

Ditto, I actually would just get rid of this one since you can infer
it when the firmware loading succeeded.

> +       release_firmware(nxpdev->fw);
> +       memset(nxpdev->fw_name, 0, MAX_FW_FILE_NAME_LEN);
> +
> +       /* Allow the downloaded FW to initialize */
> +       usleep_range(800000, 1000000);
> +
> +       return 0;
> +}
> +
> +static int nxp_send_ack(u8 ack, struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       u8 ack_nak[2];
> +
> +       if (ack =3D=3D NXP_ACK_V1 || ack =3D=3D NXP_NAK_V1) {
> +               ack_nak[0] =3D ack;
> +               serdev_device_write_buf(nxpdev->serdev, ack_nak, 1);
> +       } else if (ack =3D=3D NXP_ACK_V3) {
> +               ack_nak[0] =3D ack;
> +               ack_nak[1] =3D crc8(crc8_table, ack_nak, 1, 0xff);
> +               serdev_device_write_buf(nxpdev->serdev, ack_nak, 2);
> +       }
> +       return 0;
> +}
> +
> +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct nxp_bootloader_cmd nxp_cmd5;
> +       struct uart_config uart_config;
> +
> +       if (req_len =3D=3D sizeof(nxp_cmd5)) {
> +               nxp_cmd5.header =3D __cpu_to_le32(5);
> +               nxp_cmd5.arg =3D 0;
> +               nxp_cmd5.payload_len =3D __cpu_to_le32(sizeof(uart_config=
));
> +               nxp_cmd5.crc =3D swab32(nxp_fw_dnld_update_crc(0UL,
> +                                                            (char *)&nxp=
_cmd5,
> +                                                            sizeof(nxp_c=
md5) - 4));
> +
> +               serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd5, =
req_len);
> +               nxpdev->fw_v3_offset_correction +=3D req_len;
> +       } else if (req_len =3D=3D sizeof(uart_config)) {
> +               uart_config.clkdiv.address =3D __cpu_to_le32(CLKDIVADDR);
> +               uart_config.clkdiv.value =3D __cpu_to_le32(0x00c00000);
> +               uart_config.uartdiv.address =3D __cpu_to_le32(UARTDIVADDR=
);
> +               uart_config.uartdiv.value =3D __cpu_to_le32(1);
> +               uart_config.mcr.address =3D __cpu_to_le32(UARTMCRADDR);
> +               uart_config.mcr.value =3D __cpu_to_le32(MCR);
> +               uart_config.re_init.address =3D __cpu_to_le32(UARTREINITA=
DDR);
> +               uart_config.re_init.value =3D __cpu_to_le32(INIT);
> +               uart_config.icr.address =3D __cpu_to_le32(UARTICRADDR);
> +               uart_config.icr.value =3D __cpu_to_le32(ICR);
> +               uart_config.fcr.address =3D __cpu_to_le32(UARTFCRADDR);
> +               uart_config.fcr.value =3D __cpu_to_le32(FCR);
> +               uart_config.crc =3D swab32(nxp_fw_dnld_update_crc(0UL,
> +                                                               (char *)&=
uart_config,
> +                                                               sizeof(ua=
rt_config) - 4));
> +               serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_confi=
g, req_len);
> +               serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +               nxpdev->fw_v3_offset_correction +=3D req_len;
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static bool nxp_fw_change_timeout(struct hci_dev *hdev, u16 req_len)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct nxp_bootloader_cmd nxp_cmd7;
> +
> +       if (req_len !=3D sizeof(nxp_cmd7))
> +               return false;
> +
> +       nxp_cmd7.header =3D __cpu_to_le32(7);
> +       nxp_cmd7.arg =3D __cpu_to_le32(0x70);
> +       nxp_cmd7.payload_len =3D 0;
> +       nxp_cmd7.crc =3D swab32(nxp_fw_dnld_update_crc(0UL,
> +                                                    (char *)&nxp_cmd7,
> +                                                    sizeof(nxp_cmd7) - 4=
));
> +
> +       serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, req_len)=
;
> +       serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +       nxpdev->fw_v3_offset_correction +=3D req_len;
> +       return true;
> +}
> +
> +static u32 nxp_get_data_len(const u8 *buf)
> +{
> +       struct nxp_bootloader_cmd *hdr =3D (struct nxp_bootloader_cmd *)b=
uf;
> +
> +       return __le32_to_cpu(hdr->payload_len);
> +}
> +
> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       struct v1_data_req *req =3D skb_pull_data(skb, sizeof(struct v1_d=
ata_req));
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct btnxpuart_data *nxp_data =3D nxpdev->nxp_data;
> +       u32 requested_len;
> +       int err;
> +
> +       if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +               goto ret;
> +
> +       if (req && (req->len ^ req->len_comp) !=3D 0xffff) {
> +               bt_dev_info(hdev, "ERR: Send NAK");

Ditto, please use bt_dev_dbg, btw you wouldn't have to do this sort
for logging if there you add decoding support for these message to the
likes of btmon.

> +               nxp_send_ack(NXP_NAK_V1, hdev);
> +               goto ret;
> +       }
> +       nxp_send_ack(NXP_ACK_V1, hdev);
> +
> +       if (nxp_data->fw_dnld_use_high_baudrate) {
> +               if (!nxpdev->timeout_changed) {
> +                       nxpdev->timeout_changed =3D nxp_fw_change_timeout=
(hdev, req->len);
> +                       goto ret;
> +               }
> +               if (!nxpdev->baudrate_changed) {
> +                       nxpdev->baudrate_changed =3D nxp_fw_change_baudra=
te(hdev, req->len);
> +                       if (nxpdev->baudrate_changed) {
> +                               serdev_device_set_baudrate(nxpdev->serdev=
,
> +                                                          HCI_NXP_SEC_BA=
UDRATE);
> +                               serdev_device_set_flow_control(nxpdev->se=
rdev, 1);
> +                               nxpdev->current_baudrate =3D HCI_NXP_SEC_=
BAUDRATE;
> +                       }
> +                       goto ret;
> +               }
> +       }
> +
> +       if (!strlen(nxpdev->fw_name)) {
> +               snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +                        nxp_data->fw_name);
> +               bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name=
);
> +               err =3D request_firmware(&nxpdev->fw, nxpdev->fw_name, &h=
dev->dev);
> +               if (err < 0) {
> +                       bt_dev_err(hdev, "Firmware file %s not found", nx=
pdev->fw_name);
> +                       clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_s=
tate);
> +                       return err;
> +               }
> +       }
> +
> +       requested_len =3D req->len;
> +       if (requested_len =3D=3D 0) {
> +               bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes"=
, nxpdev->fw->size);
> +               clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +               wake_up_interruptible(&nxpdev->suspend_wait_q);
> +               goto ret;
> +       }
> +       if (requested_len & 0x01) {
> +               /* The CRC did not match at the other end.
> +                * Simply send the same bytes again.
> +                */
> +               requested_len =3D nxpdev->fw_v1_sent_bytes;
> +               bt_dev_err(hdev, "CRC error. Resend %d bytes of FW.", req=
uested_len);
> +       } else {
> +               nxpdev->fw_dnld_v1_offset +=3D nxpdev->fw_v1_sent_bytes;
> +
> +               /* The FW bin file is made up of many blocks of
> +                * 16 byte header and payload data chunks. If the
> +                * FW has requested a header, read the payload length
> +                * info from the header, before sending the header.
> +                * In the next iteration, the FW should request the
> +                * payload data chunk, which should be equal to the
> +                * payload length read from header. If there is a
> +                * mismatch, clearly the driver and FW are out of sync,
> +                * and we need to re-send the previous header again.
> +                */
> +               if (requested_len =3D=3D nxpdev->fw_v1_expected_len) {
> +                       if (requested_len =3D=3D HDR_LEN)
> +                               nxpdev->fw_v1_expected_len =3D nxp_get_da=
ta_len(nxpdev->fw->data +
> +                                                                       n=
xpdev->fw_dnld_v1_offset);
> +                       else
> +                               nxpdev->fw_v1_expected_len =3D HDR_LEN;
> +               } else {
> +                       if (requested_len =3D=3D HDR_LEN) {
> +                               /* FW download out of sync. Send previous=
 chunk again */
> +                               nxpdev->fw_dnld_v1_offset -=3D nxpdev->fw=
_v1_sent_bytes;
> +                               nxpdev->fw_v1_expected_len =3D HDR_LEN;
> +                       }
> +               }
> +       }
> +
> +       if (nxpdev->fw_dnld_v1_offset + requested_len <=3D nxpdev->fw->si=
ze)
> +               serdev_device_write_buf(nxpdev->serdev,
> +                                       nxpdev->fw->data + nxpdev->fw_dnl=
d_v1_offset,
> +                                       requested_len);
> +       nxpdev->fw_v1_sent_bytes =3D requested_len;
> +
> +ret:
> +       kfree_skb(skb);
> +       return 0;
> +}
> +
> +static u8 *nxp_get_fw_name_from_chipid(struct hci_dev *hdev, u16 chipid)
> +{
> +       u8 *fw_name =3D NULL;
> +
> +       switch (chipid) {
> +       case CHIP_ID_W9098:
> +               fw_name =3D FIRMWARE_W9098;
> +               break;
> +       case CHIP_ID_IW416:
> +               fw_name =3D FIRMWARE_IW416;
> +               break;
> +       case CHIP_ID_IW612:
> +               fw_name =3D FIRMWARE_IW612;
> +               break;
> +       default:
> +               bt_dev_err(hdev, "Unknown chip signature %04X", chipid);
> +               break;
> +       }
> +       return fw_name;
> +}
> +
> +static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *sk=
b)
> +{
> +       struct v3_start_ind *req =3D skb_pull_data(skb, sizeof(struct v3_=
start_ind));
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       int err;
> +
> +       if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +               goto ret;
> +
> +       if (!strlen(nxpdev->fw_name)) {
> +               snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +                        nxp_get_fw_name_from_chipid(hdev, req->chip_id))=
;
> +
> +               bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name=
);
> +               err =3D request_firmware(&nxpdev->fw, nxpdev->fw_name, &h=
dev->dev);
> +               if (err < 0) {
> +                       bt_dev_err(hdev, "Firmware file %s not found", nx=
pdev->fw_name);
> +                       clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_s=
tate);
> +                       goto ret;
> +               }
> +       }
> +       nxp_send_ack(NXP_ACK_V3, hdev);
> +ret:
> +       kfree_skb(skb);
> +       return 0;
> +}
> +
> +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       struct v3_data_req *req =3D skb_pull_data(skb, sizeof(struct v3_d=
ata_req));
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +
> +       if (!req || !nxpdev || !nxpdev->fw)
> +               goto ret;
> +
> +       if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +               goto ret;
> +
> +       nxp_send_ack(NXP_ACK_V3, hdev);
> +
> +       if (!nxpdev->timeout_changed) {
> +               nxpdev->timeout_changed =3D nxp_fw_change_timeout(hdev, r=
eq->len);
> +               goto ret;
> +       }
> +
> +       if (!nxpdev->baudrate_changed) {
> +               nxpdev->baudrate_changed =3D nxp_fw_change_baudrate(hdev,=
 req->len);
> +               if (nxpdev->baudrate_changed) {
> +                       serdev_device_set_baudrate(nxpdev->serdev,
> +                                                  HCI_NXP_SEC_BAUDRATE);
> +                       serdev_device_set_flow_control(nxpdev->serdev, 1)=
;
> +                       nxpdev->current_baudrate =3D HCI_NXP_SEC_BAUDRATE=
;
> +               }
> +               goto ret;
> +       }
> +
> +       if (req->len =3D=3D 0) {
> +               bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes"=
, nxpdev->fw->size);
> +               clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +               wake_up_interruptible(&nxpdev->suspend_wait_q);
> +               goto ret;
> +       }
> +       if (req->error)
> +               bt_dev_err(hdev, "FW Download received err 0x%02x from ch=
ip. Resending FW chunk.",
> +                          req->error);
> +
> +       if (req->offset < nxpdev->fw_v3_offset_correction) {
> +               /* This scenario should ideally never occur.
> +                * But if it ever does, FW is out of sync and
> +                * needs a power cycle.
> +                */
> +               bt_dev_err(hdev, "Something went wrong during FW download=
. Please power cycle and try again");

Can't we actually power cycle instead of printing an error?

> +               goto ret;
> +       }
> +
> +       serdev_device_write_buf(nxpdev->serdev,
> +                               nxpdev->fw->data + req->offset - nxpdev->=
fw_v3_offset_correction,
> +                               req->len);
> +
> +ret:
> +       kfree_skb(skb);
> +       return 0;
> +}
> +
> +static int nxp_set_baudrate_cmd(struct hci_dev *hdev, void *data)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       u32 new_baudrate =3D __cpu_to_le32(nxpdev->new_baudrate);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       u8 *pcmd =3D (u8 *)&new_baudrate;
> +       struct sk_buff *skb;
> +       u8 *status;
> +
> +       if (!psdata)
> +               return 0;
> +
> +       skb =3D nxp_drv_send_cmd(hdev, HCI_NXP_SET_OPER_SPEED, 4, pcmd);
> +       if (IS_ERR(skb)) {
> +               bt_dev_err(hdev, "Setting baudrate failed (%ld)", PTR_ERR=
(skb));
> +               return PTR_ERR(skb);
> +       }
> +
> +       status =3D skb_pull_data(skb, 1);
> +       if (status) {
> +               if (*status =3D=3D 0) {
> +                       serdev_device_set_baudrate(nxpdev->serdev, nxpdev=
->new_baudrate);
> +                       nxpdev->current_baudrate =3D nxpdev->new_baudrate=
;
> +               }
> +               bt_dev_info(hdev, "Set baudrate response: status=3D%d, ba=
udrate=3D%d",
> +                           *status, nxpdev->new_baudrate);

Ditto, use bt_dev_dbg above.

> +       }
> +       kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +static int nxp_set_ind_reset(struct hci_dev *hdev, void *data)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct sk_buff *skb;
> +       u8 *status;
> +       u8 pcmd =3D 0;
> +       int err;
> +
> +       skb =3D nxp_drv_send_cmd(hdev, HCI_NXP_IND_RESET, 1, &pcmd);
> +       if (IS_ERR(skb))
> +               return PTR_ERR(skb);
> +
> +       status =3D skb_pull_data(skb, 1);
> +       if (status) {
> +               if (*status =3D=3D 0) {
> +                       set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_sta=
te);
> +                       err =3D nxp_download_firmware(hdev);
> +                       if (err < 0)
> +                               return err;
> +                       serdev_device_set_baudrate(nxpdev->serdev, init_b=
audrate);
> +                       nxpdev->current_baudrate =3D init_baudrate;
> +                       if (nxpdev->current_baudrate !=3D HCI_NXP_SEC_BAU=
DRATE) {
> +                               nxpdev->new_baudrate =3D HCI_NXP_SEC_BAUD=
RATE;
> +                               nxp_set_baudrate_cmd(hdev, NULL);
> +                       }
> +               }
> +       }
> +       kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +/* NXP protocol */
> +static int nxp_setup(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       int err =3D 0;
> +
> +       if (!nxpdev)
> +               return 0;
> +
> +       set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +       init_waitqueue_head(&nxpdev->suspend_wait_q);
> +
> +       if (!serdev_device_get_cts(nxpdev->serdev)) {
> +               bt_dev_info(hdev, "CTS high. Need FW Download");

Ditto.

> +               err =3D nxp_download_firmware(hdev);
> +               if (err < 0)
> +                       return err;
> +       } else {
> +               bt_dev_info(hdev, "CTS low. FW already running.");

Ditto.

> +               clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +       }
> +
> +       serdev_device_set_flow_control(nxpdev->serdev, 1);
> +       serdev_device_set_baudrate(nxpdev->serdev, init_baudrate);
> +       nxpdev->current_baudrate =3D init_baudrate;
> +
> +       if (nxpdev->current_baudrate !=3D HCI_NXP_SEC_BAUDRATE) {
> +               nxpdev->new_baudrate =3D HCI_NXP_SEC_BAUDRATE;
> +               hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL=
);
> +       }
> +
> +       ps_init(hdev);
> +
> +       return 0;
> +}
> +
> +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       struct ps_data *psdata =3D nxpdev->psdata;
> +       struct hci_command_hdr *hdr;
> +       u8 *param;
> +
> +       if (!nxpdev || !psdata)
> +               goto free_skb;
> +
> +       /* if vendor commands are received from user space (e.g. hcitool)=
, update
> +        * driver flags accordingly and ask driver to re-send the command=
 to FW.
> +        */
> +       if (bt_cb(skb)->pkt_type =3D=3D HCI_COMMAND_PKT && !psdata->drive=
r_sent_cmd) {
> +               hdr =3D (struct hci_command_hdr *)skb->data;

It is not safe to access the contents of skb->data without first
checking skb->len, I understand you can't use skb_pull_data since that
changes the packet but Im not so happy with this code either way since
you appear to be doing this only to support userspace initiating these
commands but is that really expected or you are just doing this for
testing purpose? Also why not doing this handling on the command
complete/command status event as that would be common to both driver
or userspace initiated?


> +               param =3D skb->data + HCI_COMMAND_HDR_SIZE;
> +               switch (__le16_to_cpu(hdr->opcode)) {
> +               case HCI_NXP_AUTO_SLEEP_MODE:
> +                       if (hdr->plen >=3D 1) {
> +                               if (param[0] =3D=3D BT_PS_ENABLE)
> +                                       psdata->ps_mode =3D PS_MODE_ENABL=
E;
> +                               else if (param[0] =3D=3D BT_PS_DISABLE)
> +                                       psdata->ps_mode =3D PS_MODE_DISAB=
LE;
> +                               hci_cmd_sync_queue(hdev, send_ps_cmd, NUL=
L, NULL);
> +                               goto free_skb;
> +                       }
> +                       break;
> +               case HCI_NXP_WAKEUP_METHOD:
> +                       if (hdr->plen >=3D 4) {
> +                               switch (param[2]) {
> +                               case BT_CTRL_WAKEUP_METHOD_DSR:
> +                                       psdata->wakeupmode =3D WAKEUP_MET=
HOD_DTR;
> +                                       break;
> +                               case BT_CTRL_WAKEUP_METHOD_BREAK:
> +                               default:
> +                                       psdata->wakeupmode =3D WAKEUP_MET=
HOD_BREAK;
> +                                       break;
> +                               }
> +                               hci_cmd_sync_queue(hdev, send_wakeup_meth=
od_cmd, NULL, NULL);
> +                               goto free_skb;
> +                       }
> +                       break;
> +               case HCI_NXP_SET_OPER_SPEED:
> +                       if (hdr->plen =3D=3D 4) {
> +                               nxpdev->new_baudrate =3D *((u32 *)param);
> +                               hci_cmd_sync_queue(hdev, nxp_set_baudrate=
_cmd, NULL, NULL);
> +                               goto free_skb;
> +                       }
> +                       break;
> +               case HCI_NXP_IND_RESET:
> +                       if (hdr->plen =3D=3D 1) {
> +                               hci_cmd_sync_queue(hdev, nxp_set_ind_rese=
t, NULL, NULL);
> +                               goto free_skb;
> +                       }
> +                       break;
> +               default:
> +                       break;
> +               }
> +       }
> +
> +       /* Prepend skb with frame type */
> +       memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> +       skb_queue_tail(&nxpdev->txq, skb);
> +
> +       btnxpuart_tx_wakeup(nxpdev);
> +ret:
> +       return 0;
> +
> +free_skb:
> +       kfree_skb(skb);
> +       goto ret;
> +}
> +
> +static struct sk_buff *nxp_dequeue(void *data)
> +{
> +       struct btnxpuart_dev *nxpdev =3D (struct btnxpuart_dev *)data;
> +
> +       ps_wakeup(nxpdev);
> +       ps_start_timer(nxpdev);
> +       return skb_dequeue(&nxpdev->txq);
> +}
> +
> +/* btnxpuart based on serdev */
> +static void btnxpuart_tx_work(struct work_struct *work)
> +{
> +       struct btnxpuart_dev *nxpdev =3D container_of(work, struct btnxpu=
art_dev,
> +                                                  tx_work);
> +       struct serdev_device *serdev =3D nxpdev->serdev;
> +       struct hci_dev *hdev =3D nxpdev->hdev;
> +       struct sk_buff *skb;
> +       int len;
> +
> +       while ((skb =3D nxp_dequeue(nxpdev))) {
> +               len =3D serdev_device_write_buf(serdev, skb->data, skb->l=
en);
> +               hdev->stat.byte_tx +=3D len;
> +
> +               skb_pull(skb, len);
> +               if (skb->len > 0) {
> +                       skb_queue_head(&nxpdev->txq, skb);
> +                       break;
> +               }
> +
> +               switch (hci_skb_pkt_type(skb)) {
> +               case HCI_COMMAND_PKT:
> +                       hdev->stat.cmd_tx++;
> +                       break;
> +               case HCI_ACLDATA_PKT:
> +                       hdev->stat.acl_tx++;
> +                       break;
> +               case HCI_SCODATA_PKT:
> +                       hdev->stat.sco_tx++;
> +                       break;
> +               }
> +
> +               kfree_skb(skb);
> +       }
> +       clear_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +static int btnxpuart_open(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +       int err =3D 0;
> +
> +       err =3D serdev_device_open(nxpdev->serdev);
> +       if (err) {
> +               bt_dev_err(hdev, "Unable to open UART device %s",
> +                          dev_name(&nxpdev->serdev->dev));
> +       }
> +
> +       return err;
> +}
> +
> +static int btnxpuart_close(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +
> +       if (!nxpdev)
> +               return 0;
> +
> +       serdev_device_close(nxpdev->serdev);
> +
> +       return 0;
> +}
> +
> +static int btnxpuart_flush(struct hci_dev *hdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> +
> +       if (!nxpdev)
> +               return 0;
> +
> +       /* Flush any pending characters */
> +       serdev_device_write_flush(nxpdev->serdev);
> +       skb_queue_purge(&nxpdev->txq);
> +
> +       cancel_work_sync(&nxpdev->tx_work);
> +
> +       kfree_skb(nxpdev->rx_skb);
> +       nxpdev->rx_skb =3D NULL;
> +
> +       return 0;
> +}
> +
> +static const struct h4_recv_pkt nxp_recv_pkts[] =3D {
> +       { H4_RECV_ACL,          .recv =3D hci_recv_frame },
> +       { H4_RECV_SCO,          .recv =3D hci_recv_frame },
> +       { H4_RECV_EVENT,        .recv =3D hci_recv_frame },
> +       { NXP_RECV_FW_REQ_V1,   .recv =3D nxp_recv_fw_req_v1 },
> +       { NXP_RECV_CHIP_VER_V3, .recv =3D nxp_recv_chip_ver_v3 },
> +       { NXP_RECV_FW_REQ_V3,   .recv =3D nxp_recv_fw_req_v3 },
> +};
> +
> +static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 =
*data,
> +                                size_t count)
> +{
> +       struct btnxpuart_dev *nxpdev =3D serdev_device_get_drvdata(serdev=
);
> +
> +       if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state)) {
> +               if (*data !=3D NXP_V1_FW_REQ_PKT && *data !=3D NXP_V1_CHI=
P_VER_PKT &&
> +                   *data !=3D NXP_V3_FW_REQ_PKT && *data !=3D NXP_V3_CHI=
P_VER_PKT) {
> +                       /* Unknown bootloader signature, skip without ret=
urning error */
> +                       return count;
> +               }
> +       }
> +
> +       ps_start_timer(nxpdev);
> +
> +       nxpdev->rx_skb =3D h4_recv_buf(nxpdev->hdev, nxpdev->rx_skb, data=
, count,
> +                                    nxp_recv_pkts, ARRAY_SIZE(nxp_recv_p=
kts));
> +       if (IS_ERR(nxpdev->rx_skb)) {
> +               int err =3D PTR_ERR(nxpdev->rx_skb);
> +
> +               bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", =
err);
> +               nxpdev->rx_skb =3D NULL;
> +               return err;
> +       }
> +       nxpdev->hdev->stat.byte_rx +=3D count;
> +       return count;
> +}
> +
> +static void btnxpuart_write_wakeup(struct serdev_device *serdev)
> +{
> +       serdev_device_write_wakeup(serdev);
> +}
> +
> +static const struct serdev_device_ops btnxpuart_client_ops =3D {
> +       .receive_buf =3D btnxpuart_receive_buf,
> +       .write_wakeup =3D btnxpuart_write_wakeup,
> +};
> +
> +static int nxp_serdev_probe(struct serdev_device *serdev)
> +{
> +       struct hci_dev *hdev;
> +       struct btnxpuart_dev *nxpdev;
> +
> +       nxpdev =3D devm_kzalloc(&serdev->dev, sizeof(*nxpdev), GFP_KERNEL=
);
> +       if (!nxpdev)
> +               return -ENOMEM;
> +
> +       nxpdev->nxp_data =3D (struct btnxpuart_data *)device_get_match_da=
ta(&serdev->dev);
> +
> +       nxpdev->serdev =3D serdev;
> +       serdev_device_set_drvdata(serdev, nxpdev);
> +
> +       serdev_device_set_client_ops(serdev, &btnxpuart_client_ops);
> +
> +       INIT_WORK(&nxpdev->tx_work, btnxpuart_tx_work);
> +       skb_queue_head_init(&nxpdev->txq);
> +
> +       /* Initialize and register HCI device */
> +       hdev =3D hci_alloc_dev();
> +       if (!hdev) {
> +               dev_err(&serdev->dev, "Can't allocate HCI device\n");
> +               return -ENOMEM;
> +       }
> +
> +       nxpdev->hdev =3D hdev;
> +
> +       hdev->bus =3D HCI_UART;
> +       hci_set_drvdata(hdev, nxpdev);
> +
> +       hdev->manufacturer =3D MANUFACTURER_NXP;
> +       hdev->open  =3D btnxpuart_open;
> +       hdev->close =3D btnxpuart_close;
> +       hdev->flush =3D btnxpuart_flush;
> +       hdev->setup =3D nxp_setup;
> +       hdev->send  =3D nxp_enqueue;
> +       SET_HCIDEV_DEV(hdev, &serdev->dev);
> +
> +       if (hci_register_dev(hdev) < 0) {
> +               dev_err(&serdev->dev, "Can't register HCI device\n");
> +               hci_free_dev(hdev);
> +               return -ENODEV;
> +       }
> +
> +       if (!ps_init_work(hdev))
> +               ps_init_timer(hdev);
> +
> +       return 0;
> +}
> +
> +static void nxp_serdev_remove(struct serdev_device *serdev)
> +{
> +       struct btnxpuart_dev *nxpdev =3D serdev_device_get_drvdata(serdev=
);
> +       struct hci_dev *hdev =3D nxpdev->hdev;
> +
> +       /* Restore FW baudrate to init_baudrate if changed.
> +        * This will ensure FW baudrate is in sync with
> +        * driver baudrate in case this driver is re-inserted.
> +        */
> +       if (init_baudrate !=3D nxpdev->current_baudrate) {
> +               nxpdev->new_baudrate =3D init_baudrate;
> +               nxp_set_baudrate_cmd(hdev, NULL);
> +       }
> +
> +       ps_cancel_timer(nxpdev);
> +       hci_unregister_dev(hdev);
> +       hci_free_dev(hdev);
> +}
> +
> +static struct btnxpuart_data w8987_data =3D {
> +       .fw_dnld_use_high_baudrate =3D true,
> +       .fw_name =3D FIRMWARE_W8987,
> +};
> +
> +static struct btnxpuart_data w8997_data =3D {
> +       .fw_dnld_use_high_baudrate =3D false,
> +       .fw_name =3D FIRMWARE_W8997,
> +};
> +
> +static const struct of_device_id nxpuart_of_match_table[] =3D {
> +       { .compatible =3D "nxp,88w8987-bt", .data =3D &w8987_data },
> +       { .compatible =3D "nxp,88w8997-bt", .data =3D &w8997_data },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, nxpuart_of_match_table);
> +
> +static struct serdev_device_driver nxp_serdev_driver =3D {
> +       .probe =3D nxp_serdev_probe,
> +       .remove =3D nxp_serdev_remove,
> +       .driver =3D {
> +               .name =3D "btnxpuart",
> +               .of_match_table =3D of_match_ptr(nxpuart_of_match_table),
> +       },
> +};
> +
> +module_serdev_device_driver(nxp_serdev_driver);
> +
> +/* This module parameter is "chip-module vendor" dependent.
> + * Same chip can have different FW init speed depending
> + * on caliberation done by different module vendors.
> + */
> +module_param(init_baudrate, int, 0444);
> +MODULE_PARM_DESC(init_baudrate, "host baudrate after FW download: defaul=
t=3D115200");
> +
> +MODULE_AUTHOR("Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>");
> +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
> +MODULE_LICENSE("GPL");
> --
> 2.34.1
>


--=20
Luiz Augusto von Dentz
