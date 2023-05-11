Return-Path: <netdev+bounces-1794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC126FF289
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7655F281744
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4506AAB;
	Thu, 11 May 2023 13:19:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86591F931
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B78C433EF;
	Thu, 11 May 2023 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683811139;
	bh=JYPuz8rXjJmnO/HJsLqAmGKHkECg/RfopqqCAFHwjzk=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=G99MefCSp6svtRYqUM43CyoVhOZC7cfhPEPjXzVcAbereHPMdkSE3+kGXWKZiHPQD
	 2yHMwKRKx+EFLHsraEQXiuAmV9j6lJVd8EI6a6iugmsXTe9CsGv1X/sBZiMXhdLUvg
	 HjA9mmyymrzHR/6Hz8bSqw6ZBhK7YNlfd8ZB2LZS2Ok9WFgxmCygkiWVOrz2zac0Hy
	 wkEMdfRNH8TcsMj4zIC8sjIpCcPz6U4C9zoY0PT3L94tSYICwwCHPOVsSo8KHZxSfp
	 +f0iw1IN3XxSOpwO5929RqiVUWL7nqLJ3jRZf9P8Otm+S/xB6mAP0vKLgqGZS4ole2
	 a/a2a9F+ehUbA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless] wifi: mwifiex: Fix the size of a memory allocation in
 mwifiex_ret_802_11_scan()
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: 
 <7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr>
References: 
 <7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
 Ganapathi Bhat <ganapathi017@gmail.com>,
 Sharvari Harisangam <sharvari.harisangam@nxp.com>,
 Xinming Hu <huxinming820@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, chunfan chen <jeffc@marvell.com>,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Xinming Hu <huxm@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168381113342.27145.15828757976515232623.kvalo@kernel.org>
Date: Thu, 11 May 2023 13:18:55 +0000 (UTC)

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> The type of "mwifiex_adapter->nd_info" is "struct cfg80211_wowlan_nd_info",
> not "struct cfg80211_wowlan_nd_match".
> 
> Use struct_size() to ease the computation of the needed size.
> 
> The current code over-allocates some memory, so is safe.
> But it wastes 32 bytes.
> 
> Fixes: 7d7f07d8c5d3 ("mwifiex: add wowlan net-detect support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

d9aef04fcfa8 wifi: mwifiex: Fix the size of a memory allocation in mwifiex_ret_802_11_scan()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


