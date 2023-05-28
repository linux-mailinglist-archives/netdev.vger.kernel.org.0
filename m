Return-Path: <netdev+bounces-5954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D553713AE0
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9615280CB1
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 16:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2E73D78;
	Sun, 28 May 2023 16:56:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B12597
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFF4C433EF;
	Sun, 28 May 2023 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685292981;
	bh=ueGDUdIeFC8AHXZQLlvav2knW6JGEKxFPJUhzpfVMiE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O2VgmX3NqDU6FDQv1qfNmkSIil1QyaOIm90W15IyaMF/S6AxlfLyuDD1K2FTZbN+Y
	 sbh/Vb1Oy93kUveqWRE2xFt2mmTvP0H59Kr1GZ1q9xfM2tDVP7EnsvllAq9xmUe85f
	 v2vGec/1yPvRCSdvAhIIM5+XvsY+5wTjFvVJH/2/86ISZcWua9Kx6etJxJ8LWZRA1K
	 ikdl5TEyC5lsRuk4NilIwnJYJgdDsk5rAtLa2wBXia2QCNAS1xhiWGnrMXPznrle6B
	 7MFUOI6+3HUOcAw9zmzyYwktXGCH3Ny3BTWUQe1vAza+pL7+4g2In3pVsIpBYxYfz+
	 wlEe8OI2U2Udw==
Date: Sun, 28 May 2023 18:12:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Sakari Ailus
 <sakari.ailus@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
 Michael Hennerich <Michael.Hennerich@analog.com>, Andreas Klinger
 <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>, Russell King
 <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?=
 <j.neuschaefer@gmx.net>, Linus Walleij <linus.walleij@linaro.org>, Paul
 Cercueil <paul@crapouillou.net>, Akhil R <akhilrajeev@nvidia.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v6 6/8] pinctrl: pistachio: relax return value check for
 IRQ get
Message-ID: <20230528181237.5fc6f5d9@jic23-huawei>
In-Reply-To: <9db9653eb33d345d305e918215216348a8f193da.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
	<9db9653eb33d345d305e918215216348a8f193da.1685082026.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 09:38:58 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
> 
> Drop check for return value 0.
> 
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> ---
> Revision history:
>  - No changes
> 
> Please note, I took Linus' reply to v4 cover-letter as ack && added the
> tag. Please let me know if this was not Ok.

Whilst I understand your point as Linus said he'd pick the patches up,
I would have left it to Linus to Ack explicitly but added a note here
to say he basically already did.

LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.
> ---
>  drivers/pinctrl/pinctrl-pistachio.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-pistachio.c b/drivers/pinctrl/pinctrl-pistachio.c
> index 53408344927a..8c50e0091b32 100644
> --- a/drivers/pinctrl/pinctrl-pistachio.c
> +++ b/drivers/pinctrl/pinctrl-pistachio.c
> @@ -1393,12 +1393,6 @@ static int pistachio_gpio_register(struct pistachio_pinctrl *pctl)
>  			dev_err(pctl->dev, "Failed to retrieve IRQ for bank %u\n", i);
>  			goto err;
>  		}
> -		if (!ret) {
> -			fwnode_handle_put(child);
> -			dev_err(pctl->dev, "No IRQ for bank %u\n", i);
> -			ret = -EINVAL;
> -			goto err;
> -		}
>  		irq = ret;
>  
>  		bank = &pctl->gpio_banks[i];


