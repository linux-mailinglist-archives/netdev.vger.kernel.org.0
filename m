Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9543265CA1C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjACXCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbjACXB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:01:56 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9514030;
        Tue,  3 Jan 2023 15:01:55 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-150debe2b7cso2708150fac.0;
        Tue, 03 Jan 2023 15:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dL0ArEdazE1dptVNtHB/gi8aO8UwG9PiFQ1UhQeWBKQ=;
        b=TvJgztBlbd8eLRJdFi0BvIy/vu+aN5nhB7OLaOaYXa5swfw15Mhg9kUMuYM4JqskFp
         u1CGUjsSclrut29uL1pBCn70sGlnBwjOpd6RMvCU7Ld0fpA0+LZlYq+W/6+UhQGY8Akl
         a88jibj5A32dh5MamGyBOI4vvtEuPEWZjY4/VAVILbF2aHmGgP0WafsrQWBgXlCVZj/6
         QASCijkTUgx47HgimqIfmyTeC1Kxb/vk9QNg5XGA2C+yCxcGrNeYth2LTdvyqsEsBTAc
         83eGXPFPuGmuFZyDkeLT4BldO1sLZ5jdAOAGifkwFTPcbbjta6EquFDz9WbenOoIeIv5
         wuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dL0ArEdazE1dptVNtHB/gi8aO8UwG9PiFQ1UhQeWBKQ=;
        b=Q6vbVrUrA6/vEh/XlFtFUQsPeCRVlYDwu+SHC7Xbo191dAgUb7RRWPFIq0x6S7QpNG
         LeoKlYQ+sWADe2NWN5r3rwY/TMHiciPz9uKPCcA2A6rDKg/EOs5QacV3x8qxpoOKGki3
         OyjoOtlvWvhuglMEYh/eThhBJ2JnbYZSFvlDd762bQ2OsKFj2pK1lA/93rXmjZ68Sz9/
         kx3otafcy7YrP6WVtJrDjnO563SaYqe9F4q+VoFI4HggdDLwblDove+Y5m5JZ+MxdUzF
         Nngn3wKfKaAwygQxS/6NDSKL2fTWHgiGuRJXZLe2lb5jbYpk7OeOXHtdpF7yJ9Y5ppIu
         VRIA==
X-Gm-Message-State: AFqh2kr/HTi0XR2v+m0vJJ+yvKV5zIg68LCBzOAix4lnzUa/3mRfxGtY
        YEiSLJd9B91mP+NmMjvoXxk=
X-Google-Smtp-Source: AMrXdXvIn7WzhpO9PdePHDmgbHU9PCDka+j7sIVfSzdzOPs5Oo9++pL36PKgn5tatnGacBGpsjCSYA==
X-Received: by 2002:a05:6870:648d:b0:144:bf16:f432 with SMTP id cz13-20020a056870648d00b00144bf16f432mr28996037oab.50.1672786914222;
        Tue, 03 Jan 2023 15:01:54 -0800 (PST)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id z36-20020a056870462400b00144e6ffe9e5sm14797811oao.47.2023.01.03.15.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 15:01:53 -0800 (PST)
Message-ID: <63b4b3e1.050a0220.791fb.767c@mx.google.com>
X-Google-Original-Message-ID: <Y7Sz3ycScm7ln170@neuromancer.>
Date:   Tue, 3 Jan 2023 17:01:51 -0600
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> well as the existing RTL8821C chipset code.
> 

Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
master and I get errors during probe (it appears the firmware never
loads).

Relevant dmesg logs are as follows:

[    0.989545] mmc2: new high speed SDIO card at address 0001
[    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
[    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
[    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
[    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
[    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
[    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
[    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
[    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110

The error of "sdio read32 failed (0x1700): -110" then repeats several
hundred times, then I get this:

[    1.066294] rtw_8821cs mmc2:0001:1: failed to download firmware
[    1.066367] rtw_8821cs mmc2:0001:1: sdio read16 failed (0x80): -110
[    1.066417] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x100): -110
[    1.066697] rtw_8821cs mmc2:0001:1: failed to setup chip efuse info
[    1.066703] rtw_8821cs mmc2:0001:1: failed to setup chip information
[    1.066839] rtw_8821cs: probe of mmc2:0001:1 failed with error -16

The hardware I am using is an rtl8821cs that I can confirm was working
with a previous driver.

Thank you.

> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  .../net/wireless/realtek/rtw88/rtw8821cs.c    | 34 +++++++++++++++++++
>  3 files changed, 48 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> index 6b65da81127f..29eb2f8e0eb7 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -133,6 +133,17 @@ config RTW88_8821CE
>  
>  	  802.11ac PCIe wireless network adapter
>  
> +config RTW88_8821CS
> +	tristate "Realtek 8821CS SDIO wireless network adapter"
> +	depends on MMC
> +	select RTW88_CORE
> +	select RTW88_SDIO
> +	select RTW88_8821C
> +	help
> +	  Select this option will enable support for 8821CS chipset
> +
> +	  802.11ac SDIO wireless network adapter
> +
>  config RTW88_8821CU
>  	tristate "Realtek 8821CU USB wireless network adapter"
>  	depends on USB
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> index 6105c2745bda..82979b30ae8d 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -59,6 +59,9 @@ rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o
>  obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
>  rtw88_8821ce-objs		:= rtw8821ce.o
>  
> +obj-$(CONFIG_RTW88_8821CS)	+= rtw88_8821cs.o
> +rtw88_8821cs-objs		:= rtw8821cs.o
> +
>  obj-$(CONFIG_RTW88_8821CU)	+= rtw88_8821cu.o
>  rtw88_8821cu-objs		:= rtw8821cu.o
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cs.c b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> new file mode 100644
> index 000000000000..61f82b38cda4
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +// Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> +
> +#include <linux/mmc/sdio_func.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/module.h>
> +#include "sdio.h"
> +#include "rtw8821c.h"
> +
> +static const struct sdio_device_id rtw_8821cs_id_table[] =  {
> +	{
> +		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
> +			    SDIO_DEVICE_ID_REALTEK_RTW8821CS),
> +		.driver_data = (kernel_ulong_t)&rtw8821c_hw_spec,
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(sdio, rtw_8821cs_id_table);
> +
> +static struct sdio_driver rtw_8821cs_driver = {
> +	.name = "rtw_8821cs",
> +	.probe = rtw_sdio_probe,
> +	.remove = rtw_sdio_remove,
> +	.id_table = rtw_8821cs_id_table,
> +	.drv = {
> +		.pm = &rtw_sdio_pm_ops,
> +		.shutdown = rtw_sdio_shutdown,
> +	}
> +};
> +module_sdio_driver(rtw_8821cs_driver);
> +
> +MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
> +MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cs driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> -- 
> 2.39.0
> 
