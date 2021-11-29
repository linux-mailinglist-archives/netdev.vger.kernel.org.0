Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71136461D76
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349185AbhK2SWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:22:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56988 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236283AbhK2SUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:20:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63223B8159D
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 18:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A0C53FAD;
        Mon, 29 Nov 2021 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638209834;
        bh=L3FWl6shzT4GTo0Mfe5pQBNxjDJlIrA1Ka9GC3iLmHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nd6KtmHOj/W7lYcoufy/s8U2jmBwtjENodG3J9LlhawTzSfP6jlATKtKslfRICzpE
         5XE0jnCcMqlbVCUUsOgluwf0+D3p71J2Xl0rcd53Tu5gRaNZbZ/GPOsp+2S9m5TRnH
         RpwxGlpwUtHI7sHfh/f7UvDfE7OIb0ZMplRBFd4hr+jk0XIPOTs+BXtumT0W5gCtVM
         O/z8QGF6YeIUSiGKmBVT8U39zH7ovzwuH99ViqLCCcsmzevPjhxBEV6kGs1yfHxBd2
         0i4yY2KgrORD8yw5wRPwXBYGvoCUxZ2dWUbDSWYGT+2Nr7KXkcL2xRUOjG/pSjxIJT
         JitiSw0UjSWUg==
Date:   Mon, 29 Nov 2021 10:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 00/10] wireguard/siphash patches for 5.16-rc6
Message-ID: <20211129101712.0b74c2a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 10:39:19 -0500 Jason A. Donenfeld wrote:
> Here's quite a largeish set of stable patches I've had queued up and
> testing for a number of months now:
> 
>   - Patch (1) squelches a sparse warning by fixing an annotation.
>   - Patches (2), (3), and (5) are minor improvements and fixes to the
>     test suite.
>   - Patch (4) is part of a tree-wide cleanup to have module-specific
>     init and exit functions.
>   - Patch (6) fixes a an issue with dangling dst references, by having a
>     function to release references immediately rather than deferring,
>     and adds an associated test case to prevent this from regressing.
>   - Patches (7) and (8) help mitigate somewhat a potential DoS on the
>     ingress path due to the use of skb_list's locking hitting contention
>     on multiple cores by switching to using a ring buffer and dropping
>     packets on contention rather than locking up another core spinning.
>   - Patch (9) switches kvzalloc to kvcalloc for better form.
>   - Patch (10) fixes alignment traps in siphash with clang-13 (and maybe
>     other compilers) on armv6, by switching to using the unaligned
>     functions by default instead of the aligned functions by default.

Typo in the subject, right? No particular connection to -rc6 here?
Just checking.
