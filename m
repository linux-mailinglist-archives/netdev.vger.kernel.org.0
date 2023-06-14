Return-Path: <netdev+bounces-10752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0927301B6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E89061C20CC3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4057DDD3;
	Wed, 14 Jun 2023 14:24:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E15DDBF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101D4C433C0;
	Wed, 14 Jun 2023 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686752664;
	bh=FqUvtv9fuBbOa2cF0stc7Ubtd7EhOO9sRUnWlgEUXAQ=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=LiBeaZK8BUyAEjBrPaLbVcm91bl8Yb5AL+52JlAkAMN9cHgJZQ/RoxtPXQWvLZJxU
	 pL0men2FEq1b51j9taoqaMWFzz/KYrPxexiVI8VlVVqFlQAwcOA7+HAeIvcQh4hQ6a
	 K61OZ8DNdl+cLehJPmoXz9F6pB75znxKlvyppP8knd2zE4b9B5t6BASD0hLGvJPGbY
	 Zv93cyUotdQ8zCG7i2DA14XmNfwhaVNtPaGHO6JzJ/o28HoEkhAFtNCIbakz/ZwM20
	 IZM3sew8V4B8QPEuveh7AoqxEXpdaDkPWiCvk6+HbIjpf9LGWi8lhhocfHykjS9NvC
	 yEj1kv5BqbmUA==
From: Kalle Valo <kvalo@kernel.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: linux-hardening@vger.kernel.org,  linux-wireless@vger.kernel.org,  linux-kernel@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  netdev@vger.kernel.org,  Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: cfg80211: replace strlcpy() with strscpy()
References: <20230614134956.2109252-1-azeemshaikh38@gmail.com>
Date: Wed, 14 Jun 2023 17:24:20 +0300
In-Reply-To: <20230614134956.2109252-1-azeemshaikh38@gmail.com> (Azeem
	Shaikh's message of "Wed, 14 Jun 2023 13:49:56 +0000")
Message-ID: <874jnaf7fv.fsf@kernel.org>
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
> ---
> v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38@gmail.com/
> v2: https://lore.kernel.org/all/20230614134552.2108471-1-azeemshaikh38@gmail.com/

In the change log (after the "---" line) you should also describe what
changes you made, more info in the wiki below. In this case it's clear
as the patch is simple but please keep this in mind for future patches.

No need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

