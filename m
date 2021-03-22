Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9562D344FDF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhCVT0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:26:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40644 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhCVT0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:26:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3858E4D249275;
        Mon, 22 Mar 2021 12:26:18 -0700 (PDT)
Date:   Mon, 22 Mar 2021 12:26:13 -0700 (PDT)
Message-Id: <20210322.122613.1113183432857887657.davem@davemloft.net>
To:     dvyukov@google.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: make unregister netdev warning timeout
 configurable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210320142851.1328291-1-dvyukov@google.com>
References: <20210320142851.1328291-1-dvyukov@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 22 Mar 2021 12:26:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 20 Mar 2021 15:28:51 +0100

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

I'd say a sysctl knob is much better than a compile time setting for this.
That way stock kernels can be used in these testing scenerios.

Thanks.
