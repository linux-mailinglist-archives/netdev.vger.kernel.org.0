Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810122625E2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgIID1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIID1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:27:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16138C061573;
        Tue,  8 Sep 2020 20:27:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99AAE11E3E4C3;
        Tue,  8 Sep 2020 20:10:45 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:27:31 -0700 (PDT)
Message-Id: <20200908.202731.923992684489468023.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: use atomic exchange for suspend
 reference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909002127.21089-2-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
        <20200909002127.21089-2-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:10:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Tue,  8 Sep 2020 19:21:23 -0500

> We take a single IPA clock reference to keep the clock running
> until we get a system suspend operation.  When a system suspend
> request arrives, we drop that reference, and if that's the last
> reference (likely) we'll proceed with suspending endpoints and
> disabling the IPA core clock and interconnects.
> 
> In most places we simply set the reference count to 0 or 1
> atomically.  Instead--primarily to catch coding errors--use an
> atomic exchange to update the reference count value, and report
> an error in the event the previous value was unexpected.
> 
> In a few cases it's not hard to see that the error message should
> never be reported.  Report them anyway, but add some excitement
> to the message by ending it with an exclamation point.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Please use refcount_t if you're wanting to validate things like
this.

Thank you.
