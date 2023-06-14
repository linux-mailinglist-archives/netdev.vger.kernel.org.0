Return-Path: <netdev+bounces-10737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C2B730079
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 587D61C20CF1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6062DC2C7;
	Wed, 14 Jun 2023 13:49:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0139F613F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FBDC433C8;
	Wed, 14 Jun 2023 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686750555;
	bh=K8wYi/yoT8s5R17p76hSh/ZFx53ah7YMr+dtJL5G/tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M6Wqw5L7F/ncfbdX1K+o3SbPkqW1ek6AgMM1Ytm8D3IPkaskthW9jMz3WmIERLjzx
	 Wm7Waze4XDGkMBUU/Y5nQZhhTM4BZmy6F20S6x+60wVxUpWXJOMd/D5ESCatMsUbeg
	 mcmrUb1Mlu8PY5Xi0T5HL7Ve3s+E+WWTOuQdNYcDG4bJYUH5zWV0yyQ0vDaAm+G79M
	 6rmhzR3FHZXp3eM6ph22wmR2UyyAKaymh1fmWcWqUlmAeQEJLbZKiT3kMap5Jct2fY
	 ZOqY5+OXaWS7JPdYD4OgX3Rkz7mHlhPMMir1CF3fM9vghCiduD5ISHQyg239U++BF/
	 XY8IZbYJ94t6A==
Date: Wed, 14 Jun 2023 14:49:09 +0100
From: Lee Jones <lee@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, linux-leds@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next resend] leds: trigger: netdev: uninitialized
 variable in netdev_trig_activate()
Message-ID: <20230614134909.GT3635807@google.com>
References: <ZIlmX/ClDXwxQncL@kadam>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZIlmX/ClDXwxQncL@kadam>

On Wed, 14 Jun 2023, Dan Carpenter wrote:

> The qca8k_cled_hw_control_get() function which implements ->hw_control_get
> sets the appropriate bits but does not clear them.  This leads to an
> uninitialized variable bug.  Fix this by setting mode to zero at the
> start.
> 
> Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> Resending because this actually goes through net-next and not the led
> subsystem.
> 
> v2: In the original patch I fixed qca8k_cled_hw_control_get() instead
> so that patch went to netdev instead of to the led subsystem.
> https://lore.kernel.org/all/5dff3719-f827-45b6-a0d3-a00efed1099b@moroto.mountain/
> Fixing it here is a more reliable way to do it.
> 
>  drivers/leds/trigger/ledtrig-netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Lee Jones <lee@kernel.org>

-- 
Lee Jones [李琼斯]

