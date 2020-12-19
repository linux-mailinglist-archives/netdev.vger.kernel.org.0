Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8112DEEE4
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 13:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgLSMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 07:52:27 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:59551 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgLSMw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 07:52:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608382322; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=+Y2tNsCecFLAv1aRtNyApUxY3RBrrK572xFAYbx48aQ=; b=i75OM1nCBuDC8DIBVOuXBO3VSuyZNHJX5MXBLsrjjVpyoWyuOZWPh+9B36+GNAuvlHUnhGM4
 QtRZHyG7wyfJfKg+dKmM5BM8bAxb6HGXeXt5u/m5aLDFRxI0PkwzIDPCkSwdrgw7Dup8Z2N4
 qT+W/ie20N/2TTjAvVc5ptASwp0=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fddf754bfd08afb0ddb8286 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Dec 2020 12:51:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 52D73C43463; Sat, 19 Dec 2020 12:51:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6D25C433C6;
        Sat, 19 Dec 2020 12:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6D25C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v11] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
Date:   Sat, 19 Dec 2020 14:51:25 +0200
In-Reply-To: <20201208115719.349553-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Tue, 8 Dec 2020 17:27:04 +0530")
Message-ID: <87wnxeq7qq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

My first quick comments after 10 minutes of looking at this driver, so
not complete in any way:

Does not compile:

ERROR: modpost: "upload_mac_and_serial" [drivers/net/wireless/purelifi/purelifi.ko] undefined!

>  MAINTAINERS                              |    5 +
>  drivers/net/wireless/Kconfig             |    1 +
>  drivers/net/wireless/Makefile            |    1 +
>  drivers/net/wireless/purelifi/Kconfig    |   27 +
>  drivers/net/wireless/purelifi/Makefile   |    3 +
>  drivers/net/wireless/purelifi/chip.c     |   93 ++
>  drivers/net/wireless/purelifi/chip.h     |   81 ++
>  drivers/net/wireless/purelifi/dbgfs.c    |  150 +++
>  drivers/net/wireless/purelifi/firmware.c |  384 ++++++++
>  drivers/net/wireless/purelifi/intf.h     |   38 +
>  drivers/net/wireless/purelifi/mac.c      |  873 ++++++++++++++++++
>  drivers/net/wireless/purelifi/mac.h      |  189 ++++
>  drivers/net/wireless/purelifi/usb.c      | 1075 ++++++++++++++++++++++
>  drivers/net/wireless/purelifi/usb.h      |  199 ++++

The directory structure should be:

drivers/net/wireless/<vendor>/<drivername>/<file>

So please come up with a unique name for the driver which describes the
supported hardware somehow. Calling the driver "purelifi" is imho too
generic, what happens if/when there's a second generation hardware and
that needs a completely new driver? Just to give examples I like names
like rtw88 and mt76.

And I would prefer that the driver name is also used as the directory
name for firmware files, easier to find that way.

> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_PURELIFI)		:= purelifi.o
> +purelifi-objs 		+= chip.o usb.o mac.o firmware.o dbgfs.o
> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
> new file mode 100644
> index 000000000000..9a7ccd0f98f2
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/chip.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-only

Copyright missing in all files.

> +#undef  LOAD_MAC_AND_SERIAL_FROM_FILE
> +#undef  LOAD_MAC_AND_SERIAL_FROM_FLASH
> +#define LOAD_MAC_AND_SERIAL_FROM_EP0

This should be dynamic and not compile time configurable. For example
try file first, next flash and EP0 last, or something like that.

> +const struct device_attribute purelifi_attr_frequency = {
> +	  .attr = {.name = "frequency", .mode = (0666)},
> +	  .show = purelifi_show_sysfs,
> +	  .store = purelifi_store_frequency,
> +};
> +
> +struct device_attribute purelifi_attr_modulation = {
> +	.attr = {.name = "modulation", .mode = (0666)},
> +	.show = purelifi_show_modulation,
> +	.store = purelifi_store_modulation,
> +};
> +
> +const struct proc_ops  modulation_fops = {
> +	.proc_open  = modulation_open,
> +	.proc_read  = modulation_read,
> +	.proc_write = modulation_write
> +};

No procfs or sysfs files in wireless drivers, please. Needs a strong
reason to have an exception for that rule.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
