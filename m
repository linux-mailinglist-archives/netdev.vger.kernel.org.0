Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094B833BF80
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhCOPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhCOPL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 11:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD03B64DF0;
        Mon, 15 Mar 2021 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615821116;
        bh=L7mnfgF+lb3L7iB9rSiuo2URmRNaFyzItGPOorf386w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVtsZts/cibSxdjb/Jr3vi8PXgNlYqDm55wHi7LqMy+T8agsvjuRMA+tQDeN+jlyq
         O6r7vWYrtQ/zQRIH2ECqR7bKeAmZD7zO+ftKuY9dEoNpOVX9t1ECuUc+uNzibBSQ6q
         NwD45oywH1vZddYlES25P956rTE6lENmxejcS1csz0UuW1iMg3XLGQb2CGCexAk0HA
         tvdzBh/9KlhbnGlIFm2pm8aSL5BO9/GVWw8VBlrGKWRUsGnfhOJOcAWOke17+PKwRk
         /2YwNxDmaJdhIo0qwkIwI9aygAK/B9byS2SneQHGeV1yVTyuFSK58tARWt0esHEiE/
         eOT1ucJaKb9NQ==
Date:   Mon, 15 Mar 2021 17:11:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v5 03/24] wfx: add Makefile/Kconfig
Message-ID: <YE95OCx5hWRedi+W@unreal>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
 <20210315132501.441681-4-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315132501.441681-4-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 02:24:40PM +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/net/wireless/silabs/wfx/Kconfig  | 12 +++++++++++
>  drivers/net/wireless/silabs/wfx/Makefile | 26 ++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>  create mode 100644 drivers/net/wireless/silabs/wfx/Kconfig
>  create mode 100644 drivers/net/wireless/silabs/wfx/Makefile
>
> diff --git a/drivers/net/wireless/silabs/wfx/Kconfig b/drivers/net/wireless/silabs/wfx/Kconfig
> new file mode 100644
> index 000000000000..3be4b1e735e1
> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/Kconfig
> @@ -0,0 +1,12 @@
> +config WFX
> +	tristate "Silicon Labs wireless chips WF200 and further"
> +	depends on MAC80211
> +	depends on MMC || !MMC # do not allow WFX=y if MMC=m
> +	depends on (SPI || MMC)
> +	help
> +	  This is a driver for Silicons Labs WFxxx series (WF200 and further)
> +	  chipsets. This chip can be found on SPI or SDIO buses.
> +
> +	  Silabs does not use a reliable SDIO vendor ID. So, to avoid conflicts,
> +	  the driver won't probe the device if it is not also declared in the
> +	  Device Tree.
> diff --git a/drivers/net/wireless/silabs/wfx/Makefile b/drivers/net/wireless/silabs/wfx/Makefile
> new file mode 100644
> index 000000000000..f399962c8619
> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/Makefile
> @@ -0,0 +1,26 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Necessary for CREATE_TRACE_POINTS
> +CFLAGS_debug.o = -I$(src)

I wonder if it is still relevant outside of the staging tree.

Thanks
