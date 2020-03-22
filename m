Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3718E611
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgCVCrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:47:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCVCrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:47:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA58915ABB519;
        Sat, 21 Mar 2020 19:47:13 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:47:13 -0700 (PDT)
Message-Id: <20200321.194713.2123710379405962592.davem@davemloft.net>
To:     elder@linaro.org
Cc:     bjorn.andersson@linaro.org, naresh.kamboju@linaro.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320160220.21425-1-elder@linaro.org>
References: <20200320160220.21425-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:47:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 20 Mar 2020 11:02:20 -0500

> Don't assume the receive buffer size is a power-of-2 number of pages.
> Instead, define the receive buffer size independently, and then
> compute the page order from that size when needed.
> 
> This fixes a build problem that arises when the ARM64_PAGE_SHIFT
> config option is set to have a page size greater than 4KB.  The
> problem was identified by Linux Kernel Functional Testing.
> 
> The IPA code basically assumed the page size to be 4KB.  A larger page
> size caused the receive buffer size to become correspondingly larger
> (32KB or 128KB for ARM64_16K_PAGES and ARM64_64K_PAGES, respectively).
> The receive buffer size is used to compute an "aggregation byte limit"
> value that gets programmed into the hardware, and the large page sizes
> caused that limit value to be too big to fit in a 5 bit field.  This
> triggered a BUILD_BUG_ON() call in ipa_endpoint_validate_build().
> 
> This fix causes a lot of receive buffer memory to be wasted if
> system is configured for page size greater than 4KB.  But such a
> misguided configuration will now build successfully.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 
> Dave, I *hope* this is it for IPA for this release.	-Alex

Applied to net-next, thanks.
