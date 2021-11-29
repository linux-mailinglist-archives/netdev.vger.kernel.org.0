Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA3462506
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhK2Wej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhK2WeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:34:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1239C0C085A
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:47:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id i5so39592313wrb.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VDFVuWQS88ygY4E8dDjW2hwtL5QxV5+SHoAT3pUVmPQ=;
        b=mXURssTm0TFZWiJ/6q7fzCcGb9ruGUw8/Psyc5OOrLeEAtHRZPfxL0hb+lc+fEN7P7
         RYvSHSRZO1O++o8V6rPetZNCkZgkt6ds8LgcTcT0hC44cXkBk5v+4pPOYieCrSFtibAj
         iP4w3V3hZRbxszTPSLSMiwhgKMb2wePbLiiG9yeRDx4dM3U5NiP3kdgzWHyv/wk2Ra+F
         H/xDcUT/wENfBGjHUjX96NupDXuJmLPqTWPURZlbESyUCC0IldOxoCs79n8EK7jbJG+x
         XBF6CmqsU+16NK5VOF7eTRuJS7nv9rCwy6J3fW/F4c+wRp8oHW7L3A3XNtDNOWtYQdWs
         94Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VDFVuWQS88ygY4E8dDjW2hwtL5QxV5+SHoAT3pUVmPQ=;
        b=pi3n7amtm+U9l9WCiof8NSdRTo4ueCLkxYnaVB0Iq1awY7NkDarQCHFZBVij8IF+90
         KzgVJ+hn8fZ6IozCr0EwhUZNsgQ8B2lt7Y4DBPEWEJKhbANy0E9vusxSFisCrX7b++gs
         qJAtUF7T59oDkQlBTKdOCI1ZN4gZqw5P/R5junousBHU4iwn3ecxmIHpqrOfuntNnHK1
         M4y25F5vhz4wa+vALmY2dTVU5RhB4ru6H+2Mk0LFc6UOFgvqZeH1HhHk26/TBLRendsf
         xwf9ck+0ZOcO3WtlgD7thkvvgYgSiVS0B6xqBpGvzG1hQ38Wndq0b+vq38AixxKExlGR
         1h0A==
X-Gm-Message-State: AOAM531DuFK9c5DnzzWAL7+qPE+DZS/k32pAC7t55hY9dGOhBeHcRyjG
        9QrxVpejhrJaEGf4xYcVsivPZK1yrUc=
X-Google-Smtp-Source: ABdhPJzRI2lMieTlCIWB2dvTdBodcjrG/rzRehpz7YEbo21Y0qi30R+ejPdW58T3vADpa0Q3K4CcBg==
X-Received: by 2002:a5d:6a8f:: with SMTP id s15mr36902199wru.544.1638218825558;
        Mon, 29 Nov 2021 12:47:05 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:8596:696b:f4cd:9c8e? (p200300ea8f1a0f008596696bf4cd9c8e.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:8596:696b:f4cd:9c8e])
        by smtp.googlemail.com with ESMTPSA id m34sm452527wms.25.2021.11.29.12.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 12:47:04 -0800 (PST)
Message-ID: <3b610e64-9013-5c8c-93e9-95994d79f128@gmail.com>
Date:   Mon, 29 Nov 2021 21:46:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC PATCH 3/4] r8169: support CMAC
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-384-nic_swsd@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211129101315.16372-384-nic_swsd@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2021 11:13, Hayes Wang wrote:
> Support CMAC for RTL8111EP and RTL8111FP.
> 
> CMAC is the major interface to configure the firmware when dash is
> enabled.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/ethernet/realtek/Makefile     |   2 +-
>  drivers/net/ethernet/realtek/r8169.h      |   2 +
>  drivers/net/ethernet/realtek/r8169_dash.c | 756 ++++++++++++++++++++++
>  drivers/net/ethernet/realtek/r8169_dash.h |  22 +
>  drivers/net/ethernet/realtek/r8169_main.c |  54 +-
>  5 files changed, 824 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/net/ethernet/realtek/r8169_dash.c
>  create mode 100644 drivers/net/ethernet/realtek/r8169_dash.h
> 
> diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
> index 2e1d78b106b0..8f3372ee92ff 100644
> --- a/drivers/net/ethernet/realtek/Makefile
> +++ b/drivers/net/ethernet/realtek/Makefile
> @@ -6,5 +6,5 @@
>  obj-$(CONFIG_8139CP) += 8139cp.o
>  obj-$(CONFIG_8139TOO) += 8139too.o
>  obj-$(CONFIG_ATP) += atp.o
> -r8169-objs += r8169_main.o r8169_firmware.o r8169_phy_config.o
> +r8169-objs += r8169_main.o r8169_firmware.o r8169_phy_config.o r8169_dash.o
>  obj-$(CONFIG_R8169) += r8169.o
> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> index 7db647b4796f..b75484a2a580 100644
> --- a/drivers/net/ethernet/realtek/r8169.h
> +++ b/drivers/net/ethernet/realtek/r8169.h
> @@ -78,5 +78,7 @@ u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr);
>  void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
>  			 enum mac_version ver);
>  
> +u32 r8168ep_ocp_read(struct rtl8169_private *tp, u16 reg);
>  u32 r8168_type2_read(struct rtl8169_private *tp, u32 addr);
> +void r8168ep_ocp_write(struct rtl8169_private *tp, u8 mask, u16 reg, u32 data);
>  void r8168_type2_write(struct rtl8169_private *tp, u8 mask, u32 addr, u32 val);
> diff --git a/drivers/net/ethernet/realtek/r8169_dash.c b/drivers/net/ethernet/realtek/r8169_dash.c
> new file mode 100644
> index 000000000000..acee7519e9f1
> --- /dev/null
> +++ b/drivers/net/ethernet/realtek/r8169_dash.c
> @@ -0,0 +1,756 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/pci.h>
> +#include <linux/workqueue.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/string.h>
> +#include "r8169.h"
> +#include "r8169_dash.h"
> +
> +#define IBCR0				0xf8
> +#define IBCR2				0xf9
> +#define IBIMR0				0xfa
> +#define IBISR0				0xfb
> +
> +#define RTXS_LS				BIT(12)
> +#define RTXS_FS				BIT(13)
> +#define RTXS_EOR			BIT(14)
> +#define RTXS_OWN			BIT(15)
> +
> +#define DASH_ISR_ROK			BIT(0)
> +#define DASH_ISR_RDU			BIT(1)
> +#define DASH_ISR_TOK			BIT(2)
> +#define DASH_ISR_TDU			BIT(3)
> +#define DASH_ISR_TX_DISABLE_IDLE	BIT(5)
> +#define DASH_ISR_RX_DISABLE_IDLE	BIT(6)
> +
> +#define CMAC_DESC_NUM		4
> +#define CMAC_DESC_SIZE		(CMAC_DESC_NUM * sizeof(struct cmac_desc))
> +#define CMAC_TIMEOUT		(HZ * 5)
> +
> +#define OOB_CMD_DRIVER_START		0x05
> +#define OOB_CMD_DRIVER_STOP		0x06
> +#define OOB_CMD_CMAC_STOP		0x25
> +#define OOB_CMD_CMAC_INIT		0x26
> +#define OOB_CMD_CMAC_RESET		0x2a
> +
> +enum dash_cmac_state {
> +	CMAC_STATE_STOP = 0,
> +	CMAC_STATE_READY,
> +	CMAC_STATE_RUNNING,
> +};
> +
> +enum dash_flag {
> +	DASH_FLAG_CHECK_CMAC = 0,
> +	DASH_FLAG_MAX
> +};
> +
> +#pragma pack(push)
> +#pragma pack(1)
> +
> +struct cmac_desc {
> +	__le16 length;
> +	__le16 status;
> +	__le32 resv;
> +	__le64 dma_addr;
> +};
> +
> +struct oob_hdr {
> +	__le32 len;
> +	u8 type;
> +	u8 flag;
> +	u8 host_req;
> +	u8 res;
> +};
> +
> +#pragma pack(pop)
> +
> +struct dash_tx_info {
> +	u8 *buf;
> +	u32 len;
> +	bool ack;
> +};
> +
> +struct rtl_dash {
> +	struct rtl8169_private *tp;
> +	struct pci_dev *pdev_cmac;
> +	void __iomem *cmac_ioaddr;
> +	struct cmac_desc *tx_desc, *rx_desc;
> +	struct page *tx_buf, *rx_buf;
> +	struct dash_tx_info tx_info[CMAC_DESC_NUM];
> +	struct tasklet_struct tl;

Please see the following in include/linux/interrupt.h:

/* Tasklets --- multithreaded analogue of BHs.

   This API is deprecated. Please consider using threaded IRQs instead:
   https://lore.kernel.org/lkml/20200716081538.2sivhkj4hcyrusem@linutronix.de
