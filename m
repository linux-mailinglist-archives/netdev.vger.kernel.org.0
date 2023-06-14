Return-Path: <netdev+bounces-10621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95ED772F68C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D161A1C20BEC
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F4A17D7;
	Wed, 14 Jun 2023 07:40:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F57F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB759C433C0;
	Wed, 14 Jun 2023 07:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686728407;
	bh=9tKEuGeMMCSJYUtkoU+erfANYr53GikoWC56/oucmhw=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=cNeWSCyzGUnOEq9DRg7LIAwHY7RkxPD1/9283JqRK/sZw9GrXj4l9sexC5UmKqDjl
	 La7Ifdv6vRH7BrtN27+yDiiOGzkOM+jnr+8pbbtGN8T1XAAJlGCPWJuDTX+UFssAWp
	 nUr7yIZKEKeFYsWG5xGdy4wA/0eLB9r3DIsObl3+yc+aQbiHepcrcr8bOQdsvloSjJ
	 C0GlWILU7Xbxxnv8A/3hO5mCAPvRofQ9lN2wttU5BKmEv5m0TiUXpm2Fn+8cszVIc3
	 yxTl3Uep7MZX63seF2eThdKIT+dU1VuwQMxRh36SU+30BCW7PN1jp4f5ZvILtfuxjZ
	 CTfqBQwI1Gu+Q==
From: Kalle Valo <kvalo@kernel.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,  linux-hardening@vger.kernel.org,  linux-wireless@vger.kernel.org,  linux-kernel@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  netdev@vger.kernel.org
Subject: Re: [PATCH] cfg80211: cfg80211: strlcpy withreturn
References: <20230612232301.2572316-1-azeemshaikh38@gmail.com>
Date: Wed, 14 Jun 2023 10:40:00 +0300
In-Reply-To: <20230612232301.2572316-1-azeemshaikh38@gmail.com> (Azeem
	Shaikh's message of "Mon, 12 Jun 2023 23:23:01 +0000")
Message-ID: <87fs6ufq5r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Azeem Shaikh <azeemshaikh38@gmail.com> writes:

> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
>
> Direct replacement is safe here since WIPHY_ASSIGN is only used by
> TRACE macros and the return values are ignored.
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
>
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

The title should be:

wifi: cfg80211: replace strlcpy() with strlscpy()

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

