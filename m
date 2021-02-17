Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE05631D73B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhBQKD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:03:26 -0500
Received: from z11.mailgun.us ([104.130.96.11]:26327 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBQKDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:03:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613556178; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=4JdaXai7Zo7vtd+E83Cf5+ZaD1w9rnJU+MBT88EOUwA=; b=tOe1NFjhcKLNrhjQMRPuaoh9kVqwcJKHm9KYDt+siCMIxQugOoLKRMTSIn7V7HwxfdJJTjQv
 MLLTzke2nzCfGJKV1ebx41hh/Vo6mkmYlerYhif02liYslYR+TMxTTYUt18/hVYwjjI6gSMb
 kzjvs9dH06FLugqX3SaEdKxsz4A=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 602ce9a1a1a71e420fd76295 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 10:02:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AB214C433ED; Wed, 17 Feb 2021 10:02:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBD4DC433C6;
        Wed, 17 Feb 2021 10:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EBD4DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
Date:   Wed, 17 Feb 2021 12:02:03 +0200
In-Reply-To: <20210212115030.124490-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Fri, 12 Feb 2021 17:19:39 +0530")
Message-ID: <87v9arovvo.fsf@codeaurora.org>
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

I pushed this now to the pending branch of wireless-drivers-next for
build testing, let's see what kind of results we get. I didn't manage to
do a thorough review yet, but few quick comments:

> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -35,6 +35,7 @@ source "drivers/net/wireless/st/Kconfig"
>  source "drivers/net/wireless/ti/Kconfig"
>  source "drivers/net/wireless/zydas/Kconfig"
>  source "drivers/net/wireless/quantenna/Kconfig"
> +source "drivers/net/wireless/purelifi/Kconfig"

This is supposed to be in alphabetical order.

> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_WLAN_VENDOR_ST) += st/
>  obj-$(CONFIG_WLAN_VENDOR_TI) += ti/
>  obj-$(CONFIG_WLAN_VENDOR_ZYDAS) += zydas/
>  obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
> +obj-$(CONFIG_WLAN_VENDOR_PURELIFI) += purelifi/

And this one as well. Clearly I missed these with quantenna, but no need
to redo the same mistake with purelife. Also patches welcome to fix
quantenna sorting.

> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config PLFXLC
> +
> +	tristate "pureLiFi X, XL, XC device support"
> +	depends on CFG80211 && MAC80211 && USB
> +	help
> +	   This driver makes the adapter appear as a normal WLAN interface.
> +
> +	   The pureLiFi device requires external STA firmware to be loaded.
> +

The documentation here is not telling much. I think it goes without
saying that a firmware is needed, so no need to mention it. And also
"normal WLAN interface" is a standard upstream requirement so drop that
as well. Instead describe here in detail what hardware this driver
supports, for example exact product names, bus types, wifi/ieee
generation etc.

> +	   To compile this driver as a module, choose M here: the module will
> +	   be called purelifi.

Didn't you rename it to plfxlc?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
