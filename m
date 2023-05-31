Return-Path: <netdev+bounces-6686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 037CA7176E4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 959431C20D87
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24136FA3;
	Wed, 31 May 2023 06:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A158263CB
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F03C4339B;
	Wed, 31 May 2023 06:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685514880;
	bh=VbJXJ5zz+WVpnyRQMyry3uFyArPowS0EQwKqrDggAFo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QijCDzcRmZbR2iHcYZtpEYpw6bAFdDHejD9UBEfPcsfUQaOT2Tt/9k/VxjOQbGdxA
	 QDJOoV3DxLF8Vt54AzGdX21lutd/xZParafTh73vV+oSfsHSBfYegP2u43MtzMdh7T
	 oecQFkldm7MpwUtQXBxIVMqWCTm8H6aKcfEFofaRrDbR/1Uw4TtdcONaphzmDXRyWo
	 RppPS1Z2PYrZsAbT/p225lgG8fwFiDplK5sUt3//lMWdXQ8SE4/4sM7D9Jp+t8x4OO
	 15wDxV6BJaKVjOV9VqVi/DHRoXdI0/deofPd9pw5Icn/svT+DQpujic4PwX6f/MJ3z
	 olvSJGHdp3NRw==
Date: Tue, 30 May 2023 23:34:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Sakari Ailus
 <sakari.ailus@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
 Michael Hennerich <Michael.Hennerich@analog.com>, Jonathan Cameron
 <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas
 <mw@semihalf.com>, Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?=
 <j.neuschaefer@gmx.net>, Linus Walleij <linus.walleij@linaro.org>, Paul
 Cercueil <paul@crapouillou.net>, Akhil R <akhilrajeev@nvidia.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 0/9] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <20230530233438.572db3fb@kernel.org>
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 09:22:15 +0300 Matti Vaittinen wrote:
> The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
> zero if mapping the IRQ fails. This contradicts the
> fwnode_irq_get_byname() documentation. Furthermore, returning zero or
> errno on error is unepected and can easily lead to problems
> like.

What's the merging plan? Could patch 1 go to a stable branch 
and then driver trees can pull it in and apply their respective 
patches locally?

