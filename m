Return-Path: <netdev+bounces-7303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC0A71F95D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D11A91C211C4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8875310E6;
	Fri,  2 Jun 2023 04:35:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC5ED5
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A920AC433D2;
	Fri,  2 Jun 2023 04:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685680511;
	bh=cyZzgJbtALLNYFlW0KYy4uVrzsAKxaTdtJnM6vQWfFU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qtt9OmebbXVk4ZHiDg2/l0aL4fTN4aMFQIkKS29RyH05aJ9z1JatyVDMgwAC8nI35
	 u96mV/cqrWclPmlIZv3Ts868oxAXRDbawi51hkaU7Fz+mHPa4x6oBl+QorAFqeH//A
	 faEr+wvyJ9A6D4zatIjKZpLsOfH2Fly+xsxGSS+CUfBJoRhqMb2vto2MiyF7ix8oXM
	 +JtbbiY9XmTlnl0Y27kekFzFreHODbuH6JIDjSUKPwTxEN3rhMQIG2y97yA2bfXMXS
	 C59GVUEKcQoGgPv2zI4JTz0GbWIsFtWzQDuG6iW6lYe7CCzkq9BmPCfEP4yJ3y160N
	 nGGDWC84/QUxQ==
Date: Thu, 1 Jun 2023 21:35:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleksij Rempel <linux@rempel-privat.de>,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <20230601213509.7ef8f199@kernel.org>
In-Reply-To: <20230601213345.3aaee66a@kernel.org>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
	<20230601213345.3aaee66a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 21:33:45 -0700 Jakub Kicinski wrote:
> On Thu, 01 Jun 2023 16:48:12 +0100 Russell King (Oracle) wrote:
> > +	__ret = read_poll_timeout(__val = phy_read, val, \  
>                                                     ^^^
> Is this not __val on purpose?

Yes it is :)  All this to save the single line of assignment
after the read_poll_timeout() "call" ?

