Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0673474B8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhCXJc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236243AbhCXJcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 05:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4031A61A07;
        Wed, 24 Mar 2021 09:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616578326;
        bh=H1ZA9F/FjCNa3FF4dTmgJwcqG8AEiMqEkQhzmBz7a8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QwL4d+3Wp7SsbuLFveFYAjv5S6bMwP+MMxtAZE+O8WrTjvo9tiYOj1q/1zl/7Hgb4
         nsdlMwcfqIGDCGHrC7UTfAAnn1nDzT7M1n/jQ2ETy/tV+s7pYNj4/QEhuDeMvJFRE5
         u/js21ec3KEmAW6QncrDxz4VtlyZ2CEFyIaW5k9Hu/GONfIJMBQHlsX4R7VzU4ZdB5
         zwSpYWIXAwL6LYoIc2x6KW4EceFDHueLO6edEmYdLrhmsCLNwbzLu8yVUCPDqA/idF
         SO87JOPUEhj5u+I4q/5/ZgUg45GhLCtj2t5F/zf62WC4iG4yRKkoGrQJuSV6ze7fxS
         QpH0tWFNgiolA==
Date:   Wed, 24 Mar 2021 11:32:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: make unregister netdev warning timeout
 configurable
Message-ID: <YFsHEwkqCq91ngwn@unreal>
References: <20210323064923.2098711-1-dvyukov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323064923.2098711-1-dvyukov@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 07:49:23AM +0100, Dmitry Vyukov wrote:
> netdev_wait_allrefs() issues a warning if refcount does not drop to 0
> after 10 seconds. While 10 second wait generally should not happen
> under normal workload in normal environment, it seems to fire falsely
> very often during fuzzing and/or in qemu emulation (~10x slower).
> At least it's not possible to understand if it's really a false
> positive or not. Automated testing generally bumps all timeouts
> to very high values to avoid flake failures.
> Add net.core.netdev_unregister_timeout_secs sysctl to make
> the timeout configurable for automated testing systems.
> Lowering the timeout may also be useful for e.g. manual bisection.
> The default value matches the current behavior.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=211877
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> Changes since v1:
>  - use sysctl instead of a config
> ---
>  Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
>  include/linux/netdevice.h                |  1 +
>  net/core/dev.c                           |  6 +++++-
>  net/core/sysctl_net_core.c               | 10 ++++++++++
>  4 files changed, 27 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
