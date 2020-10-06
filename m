Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D851284C2F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgJFNEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:04:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379AEC061755;
        Tue,  6 Oct 2020 06:04:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF84C127C5E92;
        Tue,  6 Oct 2020 05:47:50 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:02:47 -0700 (PDT)
Message-Id: <20201006.060247.672466449778345455.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, elder@linaro.org
Subject: Re: [PATCH v3] net: qrtr: ns: Fix the incorrect usage of
 rcu_read_lock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005071642.9621-1-manivannan.sadhasivam@linaro.org>
References: <20201005071642.9621-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:47:51 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Mon,  5 Oct 2020 12:46:42 +0530

> The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
> since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
> fix it by excluding the locking for kernel_sendmsg().
> 
> While at it, let's also use radix_tree_deref_retry() to confirm the
> validity of the pointer returned by radix_tree_deref_slot() and use
> radix_tree_iter_resume() to resume iterating the tree properly before
> releasing the lock as suggested by Doug.
> 
> Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
> Reported-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied, thank you.
