Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02647CCB7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 06:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbhLVF4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 00:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhLVF4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 00:56:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A5C061574;
        Tue, 21 Dec 2021 21:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49734617F2;
        Wed, 22 Dec 2021 05:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE69C36AE5;
        Wed, 22 Dec 2021 05:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640152568;
        bh=cyCADuhN6VA0Ec892gswnFOQNtzdUG7PQdTXJYthN9s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fKWxZJR7Iwpj6QLIt4pVH22h8WM5P4xcTXLVr16r1n4VjBjBsa6eN51MP1Jf+uT8r
         NldzEtK/aJfnb6P6bPBB68p5bvzUqY3CXYMV+6BwRw88kc9dzEyYLo7ufceT2p+t/l
         auIgIEh0+CKlTC2VwDNGFrJQ2oYVtZNepgNrQWyaBT/GF1mX5WQbjjD57r4ygZjysv
         qOWd9XAA0l4IMRXXQ0k+gtP7Y/HSYMsqZ3rUEGA6tO9MTLRtvz/t/mk9g0hLx0QFKp
         19hTq/DeUkgB7+uRc/nX7nFBWEc0YJBVBqfqyU+4Y4yBo34p6xMsRMPvXVanJwsSk2
         LTQcHKXtC865w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pkshih@realtek.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] codel: remove unnecessary sock.h include
References: <20211221193941.3805147-1-kuba@kernel.org>
Date:   Wed, 22 Dec 2021 07:56:05 +0200
In-Reply-To: <20211221193941.3805147-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Tue, 21 Dec 2021 11:39:40 -0800")
Message-ID: <87sful2ney.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Since sock.h is modified relatively often (60 times in the last
> 12 months) it seems worthwhile to decrease the incremental build
> work.
>
> CoDel's header includes net/inet_ecn.h which in turn includes net/sock.h.
> codel.h is itself included by mac80211 which is included by much of
> the WiFi stack and drivers. Removing the net/inet_ecn.h include from
> CoDel breaks the dependecy between WiFi and sock.h.
>
> Commit d068ca2ae2e6 ("codel: split into multiple files") moved all
> the code which actually needs ECN helpers out to net/codel_impl.h,
> the include can be moved there as well.
>
> This decreases the incremental build size after touching sock.h
> from 4999 objects to 4051 objects.
>
> Fix unmasked missing includes in WiFi drivers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: kvalo@kernel.org
> CC: pkshih@realtek.com
> CC: ath11k@lists.infradead.org
> CC: linux-wireless@vger.kernel.org
> ---
>  drivers/net/wireless/ath/ath11k/debugfs.c  | 2 ++
>  drivers/net/wireless/realtek/rtw89/core.c  | 2 ++
>  drivers/net/wireless/realtek/rtw89/debug.c | 2 ++

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
