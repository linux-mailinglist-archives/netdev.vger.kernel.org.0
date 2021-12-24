Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B779547EAC6
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351107AbhLXDOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:14:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59156 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351103AbhLXDOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:14:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF8CB82253;
        Fri, 24 Dec 2021 03:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FE1C36AE9;
        Fri, 24 Dec 2021 03:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640315656;
        bh=ZXAyYys/9i+dLIp80SuILsfSAiF5yaCmgcI3+0FvJSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nTwOJKHMTATySU/Q77sNpnZKbdcN42Aes9Q6mo50uwMPPw9aqwa0eShgqseQT3TsZ
         yQAhh8AW5JwJp4/1q9UNTmMuIgHzr6sZOPSUAnVdISFTnH9hJNetK0eEH77MD/cwCi
         ZLX8BW1rZ4LrcuYUf1T5uNnivXQKn7IkNfFXW1glomv1njyoPjOT3RphSnNbm6O7uK
         Lhoz5jO86R2LLuqcy0pq0Hy00r2X5hW4ymAo43P7fEYqaQl/mimpSX75sPLzD2vcGt
         sk3CDu7sGsYQz+DsxF11tsC1JyHzcGmIvXQh/cDIGyakdd4oph9JS/JWhLAe8bJBVA
         x3hr0a6PbvdCg==
Date:   Thu, 23 Dec 2021 19:14:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     robin.murphy@arm.com, andy.shevchenko@gmail.com,
        davem@davemloft.net, yangyingliang@huawei.com, sashal@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] fjes: Check for error irq
Message-ID: <20211223191414.1328c7be@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224013445.1400507-1-jiasheng@iscas.ac.cn>
References: <20211224013445.1400507-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 09:34:45 +0800 Jiasheng Jiang wrote:
> The platform_get_irq() is possible to fail.
> And the returned irq could be error number and will finally cause the
> failure of the request_irq().
> Consider that platform_get_irq() can now in certain cases return
> -EPROBE_DEFER, and the consequences of letting request_irq() effectively
> convert that into -EINVAL, even at probe time rather than later on.
> So it might be better to check just now.
> 
> Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Please take note of the notifications you're getting. The previous
versions of this and the other two patches you posted shortly after
were already merged into the net tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=db6d6afe382de5a65d6ccf51253ab48b8e8336c3

If you want to refactor the check you need to send an incremental
change (IOW diff against the previously applied patch).
