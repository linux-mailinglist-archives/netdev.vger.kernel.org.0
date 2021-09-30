Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0A741D15D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 04:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347712AbhI3CVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 22:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232383AbhI3CVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 22:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CFAD613D3;
        Thu, 30 Sep 2021 02:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632968394;
        bh=ua9+bSTUTs0nqUTaRAPXnrex+Ls5qh2nXr/Sjt4l7qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lOcn7/tizcJzYz/Xmzd2yqn8psqxmzjc5UWAHbcOmPo79Ydw4n486AIKx84uZf7cF
         uGws/YspcadKmONB1SsLtSE3pWZCjgmJjW4xLmDMh3pBicPxWT3JjtIoSfY0wr0+tO
         OP0HgkrvilhWtucxh9u58npS4SbQTJiBqQZzyCnf8H7XCQ+k/mnFwed4gMCyF0TMlm
         gr+ttjPbw2YMNU5VjSWPRnLcidLAfcRXeJ/DBoWklTt4hJX84XUoTXIxO+1/J7AX56
         fZXsrHjqNT+YSiSo2qvavp7JI1uYtV6ilENyHuqoinZDpUybtJOMOCQBfNXcZ6EXtw
         t2/8zFpOrZ6mg==
Date:   Wed, 29 Sep 2021 19:19:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/5] netfilter: nf_tables: add position handle in
 event notification
Message-ID: <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929230500.811946-3-pablo@netfilter.org>
References: <20210929230500.811946-1-pablo@netfilter.org>
        <20210929230500.811946-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 01:04:57 +0200 Pablo Neira Ayuso wrote:
> Add position handle to allow to identify the rule location from netlink
> events. Otherwise, userspace cannot incrementally update a userspace
> cache through monitoring events.
> 
> Skip handle dump if the rule has been either inserted (at the beginning
> of the ruleset) or appended (at the end of the ruleset), the
> NLM_F_APPEND netlink flag is sufficient in these two cases.
> 
> Handle NLM_F_REPLACE as NLM_F_APPEND since the rule replacement
> expansion appends it after the specified rule handle.
> 
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Let me defer to Dave on this one. Krzysztof K recently provided us with
this quote:

"One thing that does bother [Linus] is developers who send him fixes in the
-rc2 or -rc3 time frame for things that never worked in the first place.
If something never worked, then the fact that it doesn't work now is not
a regression, so the fixes should just wait for the next merge window.
Those fixes are, after all, essentially development work."

	https://lwn.net/Articles/705245/

Maybe the thinking has evolved since, but this patch strikes me as odd.
We forgot to put an attribute in netlink 8 years ago, and suddenly it's
urgent to fill it in?  Something does not connect for me, certainly the
commit message should have explained things better...
