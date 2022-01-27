Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A66149E78F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbiA0QcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:32:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiA0QcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:32:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE6A6195E
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 16:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7271C340E8;
        Thu, 27 Jan 2022 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643301136;
        bh=KEZRzdTIvekf9qA/ZJZf6GHftcZxYcRgskLoP/bo8rI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B87IvL+fjIGz7jIQVSBLA4pfYbEuepPHVFZzzJB0QMx5z7YWtYm+IOKly07xf89Zc
         /hgsibbz6EIp/HOHFDpjM8TBbBE89kIOZ+VYlfKcqA/jzLP9BYuXo63pB/lSHS6IGc
         aEuOLpiEo7Td5YyU65sndrhgBmyUiaFEKNCIFfNjI2Df/Xr0lIrlX0KZyW1xJald39
         uRAsIsA01GzqEoNGcvEIHaTgkKDpPdQesKH5VEmx1XCitkJ27gQ3afa1Su2pKqsS2O
         TNWbHHbIK4+POT9VKaMS8ailPSZl8dO6eDXy1jvdJMOKgAMIrOtyz7ZoTMCXe9Y1+F
         sdUvyOvHr583w==
Date:   Thu, 27 Jan 2022 08:32:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Subject: Re: [PATCH 1/6] net: page_pool: Add alloc stats and fast path stat
Message-ID: <20220127083214.39b80c20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1643237300-44904-2-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
        <1643237300-44904-2-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 14:48:15 -0800 Joe Damato wrote:
> Add a stats structure with a an internal alloc structure for holding
> allocation path related stats.
> 
> The alloc structure contains the stat 'fast'. This stat tracks fast
> path allocations.
> 
> A static inline accessor function is exposed for accessing this stat.

> +/**
> + * stats for tracking page_pool events.
> + *
> + * accessor functions for these stats provided below.
> + *
> + * Note that it is the responsibility of the API consumer to ensure that
> + * the page_pool has not been destroyed while accessing stats fields.
> + */
> +struct page_pool_stats {
> +	struct {
> +		u64 fast; /* fast path allocations */
> +	} alloc;
> +};

scripts/kernel-doc says:

include/net/page_pool.h:75: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * stats for tracking page_pool events.
