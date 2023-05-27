Return-Path: <netdev+bounces-5842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3247131FD
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6DD12819C4
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936BD37A;
	Sat, 27 May 2023 02:41:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EEA194
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6EEC433D2;
	Sat, 27 May 2023 02:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685155298;
	bh=6Mg/DrVJEpbXZKCht3Mpy3RAP8gCualRuoTjdOiNzcE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p7uyZ0tSpdSlV44UdEoTIMuDidg0zTIOHXSDD8OHmp+bXdJZcPrOwh/8ftzdk7SaU
	 SlWVyOQO3j8LneSp7JaZ+ru1g80L8ISJRaQ6HC1W0KAByl4jnWtodwRsWo3bMf1yBM
	 PWtXnuRxb33CoJIu6/MpaVtHcC9t+4+YpAcgWiCeASQBJOmN+v/At6caVp3IF9B8WG
	 AFgKWcdFPnslsXIOhY3x2JC74VzIRHK+NSR1W9VuWZOBFyysVRcy83myreOIK1IXsU
	 R4FRTLw5Yjnu0mnKbumybXRAgiIMlA0NBaq4uBUhOGXklkXNPxTRURA9CNAQYnfoA0
	 JwigRw0ZiNe7Q==
Date: Fri, 26 May 2023 19:41:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Jason Xing <kerneljasonxing@gmail.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Subject: Re: [PATCH net v2] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
Message-ID: <20230526194136.1c9f8d6c@kernel.org>
In-Reply-To: <20230524131331.56664-1-cambda@linux.alibaba.com>
References: <20230524131331.56664-1-cambda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 21:13:31 +0800 Cambda Zhu wrote:
> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> it's zero is probably a bug.
> 
> With this change, getting TCP_MAXSEG before connecting will return
> default MSS normally, and return user_mss if user_mss is set.

Hi, your patch was marked as "Changes requested" by DaveM (I think).
Presumably because of the missing CCs. Would you mind resending one
more time with the fuller CC list?

