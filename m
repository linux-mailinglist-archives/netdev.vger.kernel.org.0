Return-Path: <netdev+bounces-11265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14346732541
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3FC42815CB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C136C633;
	Fri, 16 Jun 2023 02:28:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFFB627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2388AC433C0;
	Fri, 16 Jun 2023 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686882533;
	bh=RG8zJOEs5zwd79CJ7/rRYIW8iSFBbt2yZjsLRR44/Ds=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jnigvh48ioCT4S/0MC1vFMpJHfdLm8PGTUEye27uKyB8cCLz3qbqMakJ+6V9jCXQM
	 mlii/TlrjLjIGKvx4qQLenpoPjTe6Fs4KrqfwdJIfOvM3R95CFnN/kCim8ce6hnQJn
	 61duih8f5lnaUJ8Fr0M+dqkUUsZpqdhYTXx6VjZyiyrdxhmHut4h7jkjlgAg68Ta0o
	 OZp/3q2p/iCs7HJl2er5TlvtsABkGmsXWGjZpaBrSOOHyVn4gLTcS4NZ5jBY1y7vQa
	 /iXvf8RF4uXr+BPGo5IiK9mYEK3NhvtcQv/RQRMT19JeRl+jaD96N87/hKXWmKcc0K
	 6IbkMxHhMlBkg==
Date: Thu, 15 Jun 2023 19:28:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>, Matti Vaittinen
 <matti.vaittinen@fi.rohmeurope.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Sakari Ailus
 <sakari.ailus@linux.intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
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
Message-ID: <20230615192851.6fc01998@kernel.org>
In-Reply-To: <2023061553-urging-collision-32f8@gregkh>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
	<20230530233438.572db3fb@kernel.org>
	<2023061553-urging-collision-32f8@gregkh>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jun 2023 13:37:17 +0200 Greg Kroah-Hartman wrote:
> > What's the merging plan? Could patch 1 go to a stable branch=20
> > and then driver trees can pull it in and apply their respective=20
> > patches locally? =20
>=20
> I'll take patch 1 now, and then after 6.5-rc1, Matti, can you send the
> cleanup patches to the respective subsystems?

=F0=9F=91=8D=EF=B8=8F=F0=9F=91=8D=EF=B8=8F

