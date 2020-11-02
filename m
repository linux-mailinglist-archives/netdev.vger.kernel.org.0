Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83542A284A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgKBKbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 05:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgKBKbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 05:31:21 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F8AC0617A6;
        Mon,  2 Nov 2020 02:31:21 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id z3so4345951pfz.6;
        Mon, 02 Nov 2020 02:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OxvGBdGtoO3YM6l42BIewWHkTCA+QLXwXCh0UABXwMA=;
        b=PsJ+UkcWKow2Of3a8l4evOMbXampfD7DU6EG/GvbQ6W0F175IJlcDaMs4gTt8jVGNZ
         knRKcYRVnkgT4aL15O5GCG65a5TVxs49s+J1OGga2/tXTVpM3nOWOS1JnfBeaCDXQv5g
         la+Af7AyPNVwr7DGE1HvTMX0umXnTIZewRA1idSqUn7niaPmMIR930k76WBYiZ39y2qH
         oiAC518oNeoN7u42Bbc3fxKXtEtu1qylcbkkMeM8wu3/FlsP/3ZsakWiZ7KR9qERvoM5
         t9WsRHmSZJ8AxS4zwyYVKketumxB8q4ayNxWNsK3865rVij1Dbs+sekbn11vQ2YXHYIx
         pDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OxvGBdGtoO3YM6l42BIewWHkTCA+QLXwXCh0UABXwMA=;
        b=LXlr/Okw4iZj0kKEGxp+uFVMANxMMuHnqjCJAY9A1x85IsSb8Kkovq4Uczv3TzC1Rs
         FqIGQZkT1qcqEBqn7B+UQlllrSSXqQBpwyP1IcbwElphd6MbZk3/YkD4DtApMfhecEkZ
         rpmraUo4DT+mQjT6JFhepQEKD9tc3N3KA6CISN7SPKlrmI9C+FFXC4sLzs0WPFvl9W6F
         Fg7SZq+UUQ9Y6fZ5QQnlyMLDEQ/rLnrR4FLaU4/I4QiZxiNTk+EsgB+woc6y95YHwlDI
         /5vVba0Csdx0K+yf+vQ2oIwikDzJcvG+tNKlHIX/c9eCj4gm/XWX3UgjnRC/ronaUEzv
         5yGw==
X-Gm-Message-State: AOAM533JQOMIIDWJMclH5iny0PmYGsad2MaUJ25ax1eQ49MlclxjPuYF
        Vbm5TBKVpgk0QExNFDDJsSs=
X-Google-Smtp-Source: ABdhPJy9zK2Hm2BAlwskSJtAClb455DP1biMXtJTBsUAf/f6sBJamAKkDMfxCHl7h3czVWrmZ4JPiw==
X-Received: by 2002:a17:90a:ac06:: with SMTP id o6mr17287438pjq.49.1604313080776;
        Mon, 02 Nov 2020 02:31:20 -0800 (PST)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id a21sm13668069pfg.68.2020.11.02.02.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:31:20 -0800 (PST)
Message-ID: <4bb9ba8208e23d6b30ec9282556f2c8d764763e2.camel@gmail.com>
Subject: Re: [RFC PATCH 1/3] mwifiex: pcie: add DMI-based quirk impl for
 Surface devices
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>, verdre@v0yd.nl
Date:   Mon, 02 Nov 2020 19:31:15 +0900
In-Reply-To: <20201028152710.GU4077@smile.fi.intel.com>
References: <20201028142753.18855-1-kitakar@gmail.com>
         <20201028142753.18855-2-kitakar@gmail.com>
         <20201028152710.GU4077@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 17:27 +0200, Andy Shevchenko wrote:
> On Wed, Oct 28, 2020 at 11:27:51PM +0900, Tsuchiya Yuto wrote:
>> This commit adds quirk implementation based on DMI matching with DMI
>> table for Microsoft Surface devices that uses mwifiex chip (currently,
>> all the devices that use mwifiex equip PCIe-88W8897 chip).
>>
>> This implementation can be used for quirks later.
>
> I guess you might need to resend this (and possible other PCI pm related)
> patches to linux-pci@ and Bjorn in Cc.
>
> They may advise possible other (better) solutions.

Thanks for the advice! I also feel it's better. And if I resend this to
the linux-pci mailing list, I feel that I should try to use
drivers/pci/quirks.c instead if possible. But if I do so with this quirk
implementation, it might be possible that it'll be too big change.

So, I'll just resend this series (with changes so that it can be used
for powr_save quirk as well like I said in the reply to another series)
to the linux-pci mailing list and Bjorn (and linux-wireless mailing list
as well) and see what they think.

>> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
>> ---
>>  drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
>>  drivers/net/wireless/marvell/mwifiex/pcie.c   |   4 +
>>  drivers/net/wireless/marvell/mwifiex/pcie.h   |   2 +
>>  .../wireless/marvell/mwifiex/pcie_quirks.c    | 114 ++++++++++++++++++
>>  .../wireless/marvell/mwifiex/pcie_quirks.h    |  11 ++
>>  5 files changed, 132 insertions(+)
>>  create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>>  create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/Makefile b/drivers/net/wireless/marvell/mwifiex/Makefile
>> index fdfd9bf15ed46..8a1e7c5b9c6e2 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/Makefile
>> +++ b/drivers/net/wireless/marvell/mwifiex/Makefile
>> @@ -49,6 +49,7 @@ mwifiex_sdio-y += sdio.o
>>  obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
>>  
>>  mwifiex_pcie-y += pcie.o
>> +mwifiex_pcie-y += pcie_quirks.o
>>  obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
>>  
>>  mwifiex_usb-y += usb.o
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> index 6a10ff0377a24..362cf10debfa0 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -27,6 +27,7 @@
>>  #include "wmm.h"
>>  #include "11n.h"
>>  #include "pcie.h"
>> +#include "pcie_quirks.h"
>>  
>>  #define PCIE_VERSION	"1.0"
>>  #define DRV_NAME        "Marvell mwifiex PCIe"
>> @@ -410,6 +411,9 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
>>  			return ret;
>>  	}
>>  
>> +	/* check quirks */
>> +	mwifiex_initialize_quirks(card);
>> +
>>  	if (mwifiex_add_card(card, &card->fw_done, &pcie_ops,
>>  			     MWIFIEX_PCIE, &pdev->dev)) {
>>  		pr_err("%s failed\n", __func__);
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
>> index 843d57eda8201..09839a3bd1753 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
>> @@ -242,6 +242,8 @@ struct pcie_service_card {
>>  	struct mwifiex_msix_context share_irq_ctx;
>>  	struct work_struct work;
>>  	unsigned long work_flags;
>> +
>> +	unsigned long quirks;
>>  };
>>  
>>  static inline int
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> new file mode 100644
>> index 0000000000000..929aee2b0a60a
>> --- /dev/null
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> @@ -0,0 +1,114 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * File for PCIe quirks.
>> + */
>> +
>> +/* The low-level PCI operations will be performed in this file. Therefore,
>> + * let's use dev_*() instead of mwifiex_dbg() here to avoid troubles (e.g.
>> + * to avoid using mwifiex_adapter struct before init or wifi is powered
>> + * down, or causes NULL ptr deref).
>> + */
>> +
>> +#include <linux/dmi.h>
>> +
>> +#include "pcie_quirks.h"
>> +
>> +/* quirk table based on DMI matching */
>> +static const struct dmi_system_id mwifiex_quirk_table[] = {
>> +	{
>> +		.ident = "Surface Pro 4",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 5",
>> +		.matches = {
>> +			/* match for SKU here due to generic product name "Surface Pro" */
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 5 (LTE)",
>> +		.matches = {
>> +			/* match for SKU here due to generic product name "Surface Pro" */
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 6",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Book 1",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Book 2",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Laptop 1",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Laptop 2",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface 3",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface 3"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 3",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 3"),
>> +		},
>> +		.driver_data = 0,
>> +	},
>> +	{}
>> +};
>> +
>> +void mwifiex_initialize_quirks(struct pcie_service_card *card)
>> +{
>> +	struct pci_dev *pdev = card->dev;
>> +	const struct dmi_system_id *dmi_id;
>> +
>> +	dmi_id = dmi_first_match(mwifiex_quirk_table);
>> +	if (dmi_id)
>> +		card->quirks = (uintptr_t)dmi_id->driver_data;
>> +
>> +	if (!card->quirks)
>> +		dev_info(&pdev->dev, "no quirks enabled\n");
>> +}
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> new file mode 100644
>> index 0000000000000..5326ae7e56713
>> --- /dev/null
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Header file for PCIe quirks.
>> + */
>> +
>> +#include "pcie.h"
>> +
>> +/* quirks */
>> +// quirk flags can be added here
>> +
>> +void mwifiex_initialize_quirks(struct pcie_service_card *card);
>> -- 
>> 2.29.1
>>
>


