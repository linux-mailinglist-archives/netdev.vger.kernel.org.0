Return-Path: <netdev+bounces-5957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A92713AF4
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94EDD280DEA
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E615675;
	Sun, 28 May 2023 17:03:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2CA3D61
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CF4C4339B;
	Sun, 28 May 2023 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685293427;
	bh=z8cnynG0YqzbyS3wmg4WMqU8xEMm6lCe+QQT7lZn2hY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=drLgGpaWe2W3vJNqC777jZtERLTCi572SUkDnKdfwz9P//uCyZOZqzim2AzkBZlHJ
	 LB2aKK5Bxi/8rql+oNynvOUYqikMHpPojtNSpbcVLX1vpD6OMBz81BAskhnTy78TSU
	 h/R32K6weV9j/B///T1yICRLHWhHdwZ0N11/wE/W4JYByIGpCz26iFg+4eGwp1Trjt
	 h9g1/48y6bJnGYUiZBwJ4Dlvmxbt8RE0I7zCZtWQTRVIhcrq5ACbiIkGFZ59V1q9JJ
	 b06pkY7tlCEObYGlw535AJ4Gkxv5fp7DajRtNbl3SYSCoDMULEEgWryz7STAmPqS+9
	 F9rH/sc1kphWw==
Date: Sun, 28 May 2023 18:20:02 +0100
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
Subject: Re: [PATCH v6 3/8] net-next: mvpp2: relax return value check for
 IRQ get
Message-ID: <20230528182002.6252f3cb@jic23-huawei>
In-Reply-To: <a9dfab391fbaa7492e69729ab1396c41c8ad4991.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
	<a9dfab391fbaa7492e69729ab1396c41c8ad4991.1685082026.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 09:36:57 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
> 
> Drop check for return value 0.
> 
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> 
Seems straight forward though 'maybe' nice to return the actual
error rather than eating it.  That relies on nothing up the stack
handling resulting error codes different though.


> ---
> Revision history:
> v5 =>:
>  - No changes
> v4 = v5:
> Fix the subject, mb1232 => mvpp2
> 
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index adc953611913..5b987af306a5 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5833,7 +5833,7 @@ static int mvpp2_multi_queue_vectors_init(struct mvpp2_port *port,
>  			v->irq = of_irq_get_byname(port_node, irqname);
>  		else
>  			v->irq = fwnode_irq_get(port->fwnode, i);
> -		if (v->irq <= 0) {
> +		if (v->irq < 0) {
>  			ret = -EINVAL;

			ret = v->irq; seems nicer.

>  			goto err;
>  		}
> @@ -6764,7 +6764,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  		err = -EPROBE_DEFER;
>  		goto err_deinit_qvecs;
>  	}
> -	if (port->port_irq <= 0)
> +	if (port->port_irq < 0)
>  		/* the link irq is optional */
>  		port->port_irq = 0;
>  


