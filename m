Return-Path: <netdev+bounces-5953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E388713ACD
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34F7280C8E
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 16:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D443D61;
	Sun, 28 May 2023 16:53:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F333E0
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 16:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31091C4339C;
	Sun, 28 May 2023 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685292778;
	bh=6jBv9EQ5KlhNuW31yKlvrcZi5bUWsf/LRvMi5CHoiXU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VJ8g/zHWPYXw+S0eqeDnxPNxS0xOVgaBdxj2w9sSfeqkeitzhpd36Kv7pQHZAcq+h
	 pFksfue84kTUydLxY+VgPpCeIJ2teUM1ouUWWNMom3XaCxOKaEt8OsBFK5680j1n2o
	 kFDAE7FsC94GZRI0wQIZBNf6KQDUEl/spEGFiuqx8gZQ2MY0FKOQKoRwGUbCXjZl+V
	 oiOE9kBu87CJzV0v6QLxWqxVFz//0RepGcEtKBlUljMktEL/H7SavzCLrYiB/E2S3N
	 rhpXUI4sP21pS8drxwTO3qb0Jr//owAj3hogN2gGumnmLCV9/RmxEmW/sCU3vmB9IU
	 lGSTNYkTFXEcQ==
Date: Sun, 28 May 2023 18:09:13 +0100
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
Subject: Re: [PATCH v6 8/8] i2c: i2c-smbus: fwnode_irq_get_byname() return
 value fix
Message-ID: <20230528180913.21493d80@jic23-huawei>
In-Reply-To: <1c77cca2bb4a61133ebfc6833516981c98fb48b4.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
	<1c77cca2bb4a61133ebfc6833516981c98fb48b4.1685082026.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 09:39:37 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> The fwnode_irq_get_byname() was changed to not return 0 upon failure so
> return value check can be adjusted to reflect the change.
> 
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> 

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Comments follow though...
> ---
> Revision history:
> v5 =>:
>  - No changes
> v4 => v5:
>  - Added back after this was accidentally dropped at v4.
> 
> Depends on the mentioned return value change which is in patch 1/2. The

1/8?  Or just use 1/N and you never have to update it.

> return value change does also cause a functional change here. Eg. when
> IRQ mapping fails, the fwnode_irq_get_byname() no longer returns zero.
> This will cause also the probe here to return nonzero failure. I guess
> this is desired behaviour - but I would appreciate any confirmation.
> 
> Please, see also previous discussion here:
> https://lore.kernel.org/all/fbd52f5f5253b382b8d7b3e8046134de29f965b8.1666710197.git.mazziesaccount@gmail.com/
> 
> Another suggestion has been to drop the check altogether. I am slightly
> reluctant on doing that unless it gets confirmed that is the "right
> thing to do".

I'd be more inclined to also fail in the setup->irq < 0 path and drop the later check
on basis I can't see the driver doing anything useful wtihout an interrupt.

> ---
>  drivers/i2c/i2c-smbus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
> index 138c3f5e0093..893fe7cd3e41 100644
> --- a/drivers/i2c/i2c-smbus.c
> +++ b/drivers/i2c/i2c-smbus.c
> @@ -129,7 +129,7 @@ static int smbalert_probe(struct i2c_client *ara)
>  	} else {
>  		irq = fwnode_irq_get_byname(dev_fwnode(adapter->dev.parent),
>  					    "smbus_alert");
> -		if (irq <= 0)
> +		if (irq < 0)
>  			return irq;
>  	}
>  


