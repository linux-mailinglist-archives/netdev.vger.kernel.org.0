Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D083431BC
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 09:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCUI3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 04:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhCUI2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 04:28:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A04B6192F;
        Sun, 21 Mar 2021 08:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616315332;
        bh=Iv6go7i27JUrhyzVdDbwoLLwuIfA0usEsppHcbzNwjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBjjyp9+aGelAw2A/2iwUBbB/Ejw3pPWVlQ9bZZGzqnYr/bZWE+gte+VuM8+KmZtn
         JQ0ikq97mHEMy39gd7DmzpELb2c/3imOC2XhDdFtqe2HSMXvBuzv4MjmgTQ06KJHVA
         E/4wgaKKoJfhwd4MGBLlLRKoqy5agL5XRMYvEai2qTXk3iu4yIB4p/tBoSZRf23KdT
         vu85cZbdm+C2NsMqNoDvrRW9rznzsRgeUEkCOXvE6suIHJNu9nYkWVViyW+xAbigK/
         13fQICYthOJuACy4fbDp/FScfz35A4q4dohwthn6nQbBfkOoZ0q0emaSRSnuDk2WPU
         LSuiUs/QGZykg==
Date:   Sun, 21 Mar 2021 10:28:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: make unregister netdev warning timeout configurable
Message-ID: <YFcDwbmecMo0o4na@unreal>
References: <20210320142851.1328291-1-dvyukov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320142851.1328291-1-dvyukov@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 03:28:51PM +0100, Dmitry Vyukov wrote:
> netdev_wait_allrefs() issues a warning if refcount does not drop to 0
> after 10 seconds. While 10 second wait generally should not happen
> under normal workload in normal environment, it seems to fire falsely
> very often during fuzzing and/or in qemu emulation (~10x slower).
> At least it's not possible to understand if it's really a false
> positive or not. Automated testing generally bumps all timeouts
> to very high values to avoid flake failures.
> Make the timeout configurable for automated testing systems.
> Lowering the timeout may also be useful for e.g. manual bisection.
> The default value matches the current behavior.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=211877
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  net/Kconfig    | 12 ++++++++++++
>  net/core/dev.c |  4 +++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 

Our verification team would like to see this change too.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
