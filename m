Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801646BD9B2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCPUAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjCPT7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:59:52 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A77B53FF;
        Thu, 16 Mar 2023 12:59:22 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id n3-20020a4ad403000000b0053351dadc20so418209oos.13;
        Thu, 16 Mar 2023 12:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678996748;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iJcydj5yu12eDXGAVXNpWYkjn09kXGYM+OpHShhhGtQ=;
        b=M5Exo1aemhXIC+NICj+3t+mFNugig8zOaYV1viHiIlM8w1p5Wgm4MVqvTuRz3CDl/7
         Tn2toe6g4WjeP/F5BdcHxm+0egf+oXDHbaAbAz1aBqAtJ24oaEAF6BpUqJvfdo3FfX2N
         etDByyXvad0ZKSrlbh/6K91BaoQlWZ6M4IR1QSv2MZ50iUFP3aM2LgKUJe0ErSE+pTKP
         0m/Ebc/US0hhKnstBMta1soZKC2I8BJvowj+VjydpB+Vm2NeUn8X52j9q0MV3hWL3vi5
         LzPb+PteZ/g2kQR6TJ4VjjYZE1M40YFZcsOv7qAUoacDJwRvZVeh4bKNhNq30dyz0mds
         20Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678996748;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJcydj5yu12eDXGAVXNpWYkjn09kXGYM+OpHShhhGtQ=;
        b=PEJwUjtP7xvL9mWHWWsyR5qv5Tt4MH3V6akLeDBEhTv9LtuiVc+WSi05oRQOefuuzh
         ZgDmfdb8OcVweynzGiI0BnbUSTYfoUVbHnuShvONuzp6lO3KhLWH32FHxQSp/nSmdPqt
         IpF2FTogqLq0gxuzNSCS+41e4qYGGvDMx0TN4RRB3wfDBCPqs8ETkdxiHAmT7F/6kOSV
         upvUPE4aYNT5PLM+F6yd05P4ZSEksF7Bj32ujGMl6AZoiZn0JDPFW++PmPSY244W2r4g
         ACT9T7MWfk0S0bv2t8wE/LU14U2IraimDE1kSQ5eMVRhfiRpaHXtO3dQC9hmW9buQS+3
         xuSQ==
X-Gm-Message-State: AO0yUKU7bJn3Zz4z3PphWqiyyKzrWA5GJdLL0bWB8xN2LBZtloxj0c2P
        pRighBgiY0cUpc1YWFReims=
X-Google-Smtp-Source: AK7set873rjkScAW0PvvWNiDaSas6qVsx1V6E8+/VvR9+EWZwsiZipOMHLmvwH/oCotxf2TSkVj+8g==
X-Received: by 2002:a4a:6552:0:b0:534:c38a:dafd with SMTP id z18-20020a4a6552000000b00534c38adafdmr3319661oog.6.1678996747844;
        Thu, 16 Mar 2023 12:59:07 -0700 (PDT)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id c11-20020a4ae24b000000b005255e556399sm3620572oot.43.2023.03.16.12.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 12:59:07 -0700 (PDT)
Message-ID: <6413750b.4a0a0220.cfd67.2a0b@mx.google.com>
X-Google-Original-Message-ID: <ZBN1CGjW8ltuGavP@neuromancer.>
Date:   Thu, 16 Mar 2023 14:59:04 -0500
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
Subject: Re: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-10-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310202922.2459680-10-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:29:22PM +0100, Martin Blumenstingl wrote:
> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> well as the existing RTL8821C chipset code.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v1:
> - use /* ... */ style for copyright comments
> 
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  .../net/wireless/realtek/rtw88/rtw8821cs.c    | 35 +++++++++++++++++++
>  3 files changed, 49 insertions(+)
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
> index 000000000000..7ad7c13ac9e6
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> + */
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
> 2.39.2
> 

Overall it works well for me, but when I resume from suspend I get the
following filling up my dmesg:

rtw_8821cs mmc3:0001:1: sdio read8 failed (0x86): -110

So suspend/resume seems to be an issue, but otherwise it works well
for me.

Chris Morgan
