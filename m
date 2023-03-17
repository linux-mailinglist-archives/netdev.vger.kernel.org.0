Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755346BEC02
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjCQO7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCQO7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:59:42 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDA3C97CF;
        Fri, 17 Mar 2023 07:59:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y4so21577452edo.2;
        Fri, 17 Mar 2023 07:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679065179;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YuW3M3knT9QpaEiynjTjamW8kmrzZ3OjR3+nQKcgn/I=;
        b=R7YKkgTyPKt+jfQSFkavns4SPgE9xK3gHFGBPvhYiBeL1axPsQXQQGWr0HpFGUG+HQ
         +09/Luef90V7tD0CSoyUDKHqYixRq6Lcc6uOl9T6lUXxbYDjBSVy8myCVpPuyLGyBbFH
         XvTMJaB/cy0US4Bt6yOXQjCw5FB6zcwVFPGlHqerWELmfIb0FVyP/AGXgJHyOpjinLdB
         F3ZxprTv4DKS62GH9JB7PlnpezcNyqihDxl5Wt+cI4H4g/syAr4yu0k0AdgnkvD+WKYl
         8qrQkePRzF+LyFzyaz8wGp3j+jkJdYLJVXNM3sfPNnZ18fDaOozUuIvqUNX12kgnK5XE
         P1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679065179;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YuW3M3knT9QpaEiynjTjamW8kmrzZ3OjR3+nQKcgn/I=;
        b=yF6e+sF/0QobV8TLOAq0cHFNeVgHlw8OtX+i2DmiA2kDyqm+IQOFt4CKssUS7y+P92
         ggSt6e9tgPjKQU6txH8vYrOS/WvQp4qrzVjI4MIIkgwy6tJ7Ji31Uc48pvsMs23En0cp
         5lTvmDMcLt2MH5VOMVpazdOzYu0Y6SBiHJbf0kflpwQTWxUmEG0AGaFTleMq1mldv7UR
         dovlbp5ml+xiPwPjUfaeRzEkAomI/3RAzL/kcf/g3MS8iXb+/OFditBh/7A6Hx3Uw2ET
         HxmoZmvPj9kPAymWUERQxZFVE3990juJTzFscMTgJQHUCBg6vA+5vnyCJanCzgbdmM2t
         8gxA==
X-Gm-Message-State: AO0yUKXMRwuRoNUqsctj7Ox7zJxMKOYW56HZKbJSD+j+YDiX2u/MWcmu
        EmSLNZgEHZtzWNSzf9bHA5s=
X-Google-Smtp-Source: AK7set8fvPFLPCsi014GJVC70mu+7rxZdaKD1pXdGCxbhrco3AtDD7MVl+C2bd1T2QI5zvHGsX2hoQ==
X-Received: by 2002:a17:906:612:b0:8b1:3483:e3d5 with SMTP id s18-20020a170906061200b008b13483e3d5mr13564946ejb.48.1679065178983;
        Fri, 17 Mar 2023 07:59:38 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c5b8:6200:f0f7:420b:6fc2:5ad8? (dynamic-2a01-0c23-c5b8-6200-f0f7-420b-6fc2-5ad8.c23.pool.telefonica.de. [2a01:c23:c5b8:6200:f0f7:420b:6fc2:5ad8])
        by smtp.googlemail.com with ESMTPSA id n3-20020a170906088300b009327ed171f2sm334954eje.129.2023.03.17.07.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 07:59:38 -0700 (PDT)
Message-ID: <d5ec2ec2-65a0-6ad3-a0a3-cad57d7f6616@gmail.com>
Date:   Fri, 17 Mar 2023 15:59:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     David Yang <mmyangfl@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230317143042.291260-1-mmyangfl@gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: hisi-festa: Add support for HiSilicon Festa
 PHYs
In-Reply-To: <20230317143042.291260-1-mmyangfl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.03.2023 15:30, David Yang wrote:
> HiSilicon Festa PHYs were used on some HiSilicon SoCs. This patch injects
> firmwares found on vendor kernels.
> 
What's the status of adding the firmware files to linux-firmware?
I don't see any related patch in the linux-firmware mailing list archive.

Any info on purpose of firmware? Does the PHY work normally also
w/o firmware? Or is the firmware required?

> Signed-off-by: David Yang <mmyangfl@gmail.com>
> ---
>  drivers/net/phy/Kconfig      |   5 ++
>  drivers/net/phy/Makefile     |   1 +
>  drivers/net/phy/hisi-festa.c | 169 +++++++++++++++++++++++++++++++++++
>  3 files changed, 175 insertions(+)
>  create mode 100644 drivers/net/phy/hisi-festa.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 54874555c..e7551e9b3 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -177,6 +177,11 @@ config DAVICOM_PHY
>  	help
>  	  Currently supports dm9161e and dm9131
>  
> +config HISI_FESTA_PHY
> +	tristate "HiSilicon Festa PHYs"
> +	help
> +	  Supports the HiSilicon Festa PHYs.
> +
>  config ICPLUS_PHY
>  	tristate "ICPlus PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b5138066b..2c5aded6b 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -60,6 +60,7 @@ obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
>  obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
>  obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
>  obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
> +obj-$(CONFIG_HISI_FESTA_PHY)	+= hisi-festa.o
>  obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
>  obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
>  obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
> diff --git a/drivers/net/phy/hisi-festa.c b/drivers/net/phy/hisi-festa.c
> new file mode 100644
> index 000000000..ab54ed3ca
> --- /dev/null
> +++ b/drivers/net/phy/hisi-festa.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
> +/*
> + * Driver for HiSilicon Festa PHYs
> + *
> + * This module does nothing than firmware injection. If you don't use firmware,
> + * simply blacklist this module.

That's not an appropriate hint. Relevant is the answer to the question
whether firmware is required.

> + *
> + * Copyright (c) 2023 David Yang
> + */
> +#include <linux/errno.h>
> +#include <linux/firmware.h>
> +#include <linux/init.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define PHY_ID_HISILICON_FESTAV200	0x20669813
> +#define PHY_ID_HISILICON_FESTAV220	0x20669823
> +#define PHY_ID_HISILICON_FESTAV300	0x20669833
> +#define PHY_ID_HISILICON_FESTAV320	0x20669843
> +#define PHY_ID_HISILICON_FESTAV330	0x20669853
> +#define PHY_ID_HISILICON_FESTAV331	0x20669863
> +
> +#define MII_EXPMD	0x1d	/* Expanded memory data */
> +#define MII_EXPMA	0x1e	/* Expanded memory address */
> +
> +/* bus->mdio_lock should be locked when using this function */
> +static inline int hisi_festa_read_expanded(struct phy_device *phydev, u16 addr)

No inline keyword please, let the compiler decide.

> +{
> +	__phy_write(phydev, MII_EXPMA, addr);
> +	return __phy_read(phydev, MII_EXPMD);
> +}
> +
> +/* bus->mdio_lock should be locked when using this function */
> +static inline int hisi_festa_write_expanded(struct phy_device *phydev, u16 addr, u8 val)

Why return type int and not void?

> +{
> +	__phy_write(phydev, MII_EXPMA, addr);
> +	__phy_write(phydev, MII_EXPMD, val);
> +	return 0;
> +}
> +
> +/* bus->mdio_lock should be locked when using this function */
> +static inline int hisi_festa_write_expanded_mem(struct phy_device *phydev, u16 addr,
> +						const u8 *data, int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		hisi_festa_write_expanded(phydev, addr + i, data[i]);
> +	return 0;
> +}
> +
> +static int hisi_festa_write_fw(struct phy_device *phydev, const struct firmware *fw)
> +{
> +	static const u8 prologue[] = {0xbd, 0x34, 0x00, 0x39};
> +	int ret;
> +
> +	phy_lock_mdio_bus(phydev);
> +
> +	ret = __phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);

Why power down the PHY?

> +	if (ret) {
> +		phydev_err(phydev, "cannot suspend device\n");
> +		goto out;
> +	}
> +
> +	hisi_festa_write_expanded_mem(phydev, 0x33f9, prologue, sizeof(prologue));
> +	/* mask jump instruction */
> +	hisi_festa_write_expanded(phydev, 0x3400, 0x39);
> +	hisi_festa_write_expanded_mem(phydev, 0x3401, fw->data + 1, fw->size - 1);
> +	/* now release firmware */
> +	hisi_festa_write_expanded(phydev, 0x3400, fw->data[0]);
> +	hisi_festa_write_expanded(phydev, 0x33f8, 0x01);
> +
> +	ret = __phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);

Or do a soft reset here?

> +
> +out:
> +	phy_unlock_mdio_bus(phydev);
> +	return ret;
> +}
> +
> +static int hisi_festa_patch_fw(struct phy_device *phydev)
> +{
> +	int ret;
> +	char fw_name[64];
> +	const struct firmware *fw;
> +

reverse x-mas tree

> +	snprintf(fw_name, sizeof(fw_name), "hisilicon/festa.%08x.ucode", phydev->phy_id);
> +
> +	ret = request_firmware(&fw, fw_name, &phydev->mdio.dev);

Any option to detect whether firmware is loaded already?

> +	if (ret) {
> +		/* err message already printed by request_firmware */
> +		return -EAGAIN;
> +	}
> +
> +	if (fw->data[0] != 0x01 || fw->data[1] != 0xcc) {
> +		phydev_err(phydev, "%s does not look like valid firmware; refused to load\n",
> +			   fw_name);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = hisi_festa_write_fw(phydev, fw);
> +	if (ret) {
> +		phydev_err(phydev, "download firmware %s failed\n", fw_name);
> +		goto out;
> +	}
> +
> +	phydev_info(phydev, "using firmware %s\n", fw_name);
> +
> +out:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +static int hisi_festa_config_init(struct phy_device *phydev)
> +{
> +	hisi_festa_patch_fw(phydev);
> +	/* ok, use programmed firmware */
> +	return 0;
> +}
> +
> +static struct phy_driver hisi_festa_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV200),
> +		.name        = "HiSilicon Festa v200/v210",
> +		.config_init = hisi_festa_config_init,

How about callbacks like suspend/resume?

> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV220),
> +		.name        = "HiSilicon Festa v220",
> +		.config_init = hisi_festa_config_init,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV300),
> +		.name        = "HiSilicon Festa v300",
> +		.config_init = hisi_festa_config_init,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV320),
> +		.name        = "HiSilicon Festa v320",
> +		.config_init = hisi_festa_config_init,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV330),
> +		.name        = "HiSilicon Festa v330",
> +		.config_init = hisi_festa_config_init,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV331),
> +		.name        = "HiSilicon Festa v331",
> +		.config_init = hisi_festa_config_init,
> +	},
> +};
> +
> +module_phy_driver(hisi_festa_driver);
> +
> +static struct mdio_device_id __maybe_unused hisi_festa_tbl[] = {
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV200) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV220) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV300) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV320) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV330) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV331) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, hisi_festa_tbl);
> +MODULE_DESCRIPTION("HiSilicon Festa PHY driver");
> +MODULE_LICENSE("Dual MIT/GPL");

