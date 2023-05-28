Return-Path: <netdev+bounces-5972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D60713BF6
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 20:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88125280E6E
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A513E5696;
	Sun, 28 May 2023 18:57:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3B22F3D
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DE1C433EF;
	Sun, 28 May 2023 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685300271;
	bh=KlKvkfbT2430hhOEgYoBgaDnMkWkALFfhUEwavNOtLg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M2UobjnClAfdfRy0Po1wB9j4LPI1N+oqswdAWDqt6VvPCaO7OlScQ30yw/RhSHaEu
	 lsgW+G+F0PJKP8QE11DiFsqDihh3DhP41ymAXDJNHdGDmFDXplhKp4bKw3wtgfGWcO
	 FgP1RbgQnCoHx6Oq/RW5Uy7bMTLnxl7XUpgbaUv/Ge7t8prNuHv0hBE0Lp9YTCudoB
	 s3gsXWGzVcW+JtuAoFKNTYZiOOOYFzLt0banqQ+4C+bNMPf8s11KiKv3JiiF59CTJE
	 IAsLu/M9AfvMc3TIGJFwQ2UoNnox4CUMbr8W2ili6BGzFeqACokV97xYERRJLSBtE5
	 Hjq6j7Ri6XWJQ==
Date: Sun, 28 May 2023 20:14:07 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: andy.shevchenko@gmail.com, Matti Vaittinen
 <matti.vaittinen@fi.rohmeurope.com>, Andy Shevchenko
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
Subject: Re: [PATCH v5 3/8] net-next: mvpp2: relax return value check for
 IRQ get
Message-ID: <20230528201407.394235f5@jic23-huawei>
In-Reply-To: <6e94c838-886d-3c58-3fa0-175501f57f56@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
	<7c7b1a123d6d5c15c8b37754f1f0c4bd1cad5a01.1684493615.git.mazziesaccount@gmail.com>
	<ZGpSpZFEo5cw94U_@surfacebook>
	<6e94c838-886d-3c58-3fa0-175501f57f56@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 08:15:01 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> Hi Andy,
> 
> On 5/21/23 20:19, andy.shevchenko@gmail.com wrote:
> > Fri, May 19, 2023 at 02:01:47PM +0300, Matti Vaittinen kirjoitti:  
> >> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
> >>
> >> Drop check for return value 0.  
> > 
> > ...
> >   
> >> -		if (v->irq <= 0) {
> >> +		if (v->irq < 0) {
> >>   			ret = -EINVAL;  
> > 
> > 			ret = v->irq;
> > 
> > ?  
> 
> For me that seems to be correct, yes. This, however, would be a 
> functional change and in my opinion it should be done separately from 
> this API change.
Ah. I commented on this as well in v6.  Roll us that separate patch
and I expect we'll both be happy ;)

Jonathan

> 
> >   
> >>   			goto err;
> >>   		}  
> >   
> 


