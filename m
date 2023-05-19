Return-Path: <netdev+bounces-4031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D29170A2C9
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 675B6281B87
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11741800F;
	Fri, 19 May 2023 22:28:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFCF18000
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 22:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23F6C433EF;
	Fri, 19 May 2023 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684535289;
	bh=kHtJttk0IvKNpeBTTCun9Kaxe9mpk0uKJbFMu4xbEBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fjPLOWfLnh+YUZso0agkMdGAZir6v6nV/SrtAoiIwmSXhkhEz/FeEuTojZV5BbnPM
	 xCIvyJdayyv8y4OHd1E2WJ46Z4RC9+FGstF2G124fSkQTJhZWetm0hjFjzRXF3V2gt
	 2BRLX6+LhW1kwD1KTWzkeOxw2fRU1DTSyNRWM7wfV99ZalR8t0B4Cqz+5XOfzOmgfz
	 NEXnwc7TwkiLmnpM5TIxiH0cgPylLpFcsTbogVuDBsPO73ySzLbgao2cnYIA8mzcvj
	 a4+G4l6DjOJ6OwrSJ7RbWzd7XyYfgmqTdZQK2p8lRFod49RbJYyKwKIF2sLYn1Y17c
	 JbJTzMI5Io2bg==
Date: Fri, 19 May 2023 15:28:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>, Claudiu Beznea
 <claudiu.beznea@microchip.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: use correct __be32 and __be16 types
Message-ID: <20230519152807.57d3f4c8@kernel.org>
In-Reply-To: <20230519221942.53942-1-minhuadotchen@gmail.com>
References: <20230519221942.53942-1-minhuadotchen@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 20 May 2023 06:19:39 +0800 Min-Hua Chen wrote:
> This patch fixes the following sparse warnings. No functional changes.
> 
> Use cpu_to_be16() and cpu_to_be32() to convert constants before comparing
> them with __be16 type of psrc/pdst and __be32 type of ip4src/ip4dst.
> Apply be16_to_cpu() in GEM_BFINS().

same story as with your stmmac patch, the warning is a false positive

