Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C6153A85
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgBEVzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:55:04 -0500
Received: from nautica.notk.org ([91.121.71.147]:56696 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgBEVzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 16:55:03 -0500
Received: by nautica.notk.org (Postfix, from userid 1001)
        id E3728C009; Wed,  5 Feb 2020 22:55:01 +0100 (CET)
Date:   Wed, 5 Feb 2020 22:54:46 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Sergey Alirzaev <l29ah@cock.li>
Cc:     v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9pnet: allow making incomplete read requests
Message-ID: <20200205215446.GB3942@nautica>
References: <20200205204053.12751-1-l29ah@cock.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205204053.12751-1-l29ah@cock.li>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergey Alirzaev wrote on Wed, Feb 05, 2020:
> A user doesn't necessarily want to wait for all the requested data to
> be available, since the waiting time for each request is unbounded.
> 
> The new method permits sending one read request at a time and getting
> the response ASAP, allowing to use 9pnet with synthetic file systems
> representing arbitrary data streams.

Much better, thanks!

> Signed-off-by: Sergey Alirzaev <l29ah@cock.li>
> [...]
> +		if (n != count) {
> +			*err = -EFAULT;
> +			p9_tag_remove(clnt, req);
> +			return n;
>  		}
> -		p9_tag_remove(clnt, req);
> +	} else {
> +		iov_iter_advance(to, count);
> +		count;

Any reason for this stray 'count;' statement?

If you're ok with this I'll just take patch without that line, don't
bother resubmitting.
Will take a fair amount of time to make it to linux-next though, test
setup needs some love and I want to run tests even if this should be
straightforward...

Thanks,
-- 
Dominique
