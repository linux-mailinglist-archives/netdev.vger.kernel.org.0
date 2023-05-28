Return-Path: <netdev+bounces-5955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A078713AE7
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC87D1C20958
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 16:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C573D78;
	Sun, 28 May 2023 16:57:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F60566C
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F60C433EF;
	Sun, 28 May 2023 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685293029;
	bh=+hWlogpsHCsoKplEv/92cr5w/RkOgzEL9FTtd9IUdlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vE/zGI6PJoizrumVsABEYxWZWkx8NssyJ8jedEzsoTKTu2P91Z7zKOqGTY/t5LRwO
	 vxwIoxcigc2J8mjbzCzA3c2AUZpCbFRTYAiG2OZW3NyMWyZ/fHWqZ2mC3yfWh2BU1S
	 fdtt28fjgYscnYHQAh6tQS31vjDFyqAJdrP8HvOwuxNsD1aMNamwkHJqZAlWOWpNNF
	 XqcSzFaWqmkBmD/uJuZXNoXlZa43UVIdFrUXZpM93NKu9DSvBNUGurdssDsxETI2Mo
	 r55oVQgTw/qb9/fagyXMH1Yv57zvtCG3jR6D6zAawFMt108KTZdETGe6mU9mOb0A0p
	 Hm3cV3AKBKJ6g==
Date: Sun, 28 May 2023 18:13:25 +0100
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
Subject: Re: [PATCH v6 5/8] pinctrl: ingenic: relax return value check for
 IRQ get
Message-ID: <20230528181325.405d9dad@jic23-huawei>
In-Reply-To: <c4d877dd94cb528a39dd9c7403159a036934d3b1.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
	<c4d877dd94cb528a39dd9c7403159a036934d3b1.1685082026.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 09:38:39 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
> 
> Drop check for return value 0.
> 
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
> Revision history:
>  - No changes
> 
> Please note, I took Linus' reply to v4 cover-letter as ack && added the
> tag. Please let me know if this was not Ok.
> 
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.
> ---
>  drivers/pinctrl/pinctrl-ingenic.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
> index 2f220a47b749..86e71ad703a5 100644
> --- a/drivers/pinctrl/pinctrl-ingenic.c
> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -4201,8 +4201,6 @@ static int __init ingenic_gpio_probe(struct ingenic_pinctrl *jzpc,
>  	err = fwnode_irq_get(fwnode, 0);
>  	if (err < 0)
>  		return err;
> -	if (!err)
> -		return -EINVAL;
>  	jzgc->irq = err;
>  
>  	girq = &jzgc->gc.irq;


