Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0767B26383F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgIIVOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIIVOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:14:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A31C061573;
        Wed,  9 Sep 2020 14:14:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B57B912987FAD;
        Wed,  9 Sep 2020 13:57:16 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:14:02 -0700 (PDT)
Message-Id: <20200909.141402.826324173736678429.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: use atomic exchange for suspend
 reference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bd61d3fb-44b7-9bc3-ccad-1101c5c34ebc@linaro.org>
References: <20200909002127.21089-2-elder@linaro.org>
        <20200908.202731.923992684489468023.davem@davemloft.net>
        <bd61d3fb-44b7-9bc3-ccad-1101c5c34ebc@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 13:57:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Wed, 9 Sep 2020 08:43:44 -0500

> There is exactly one reference here; the "reference" is
> essentially a Boolean flag.  So the value is always either
> 0 or 1.

Aha, then why not use a bitmask and test_and_set_bit() et al.?
