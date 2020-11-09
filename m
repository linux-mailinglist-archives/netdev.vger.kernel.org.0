Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEDD2AC930
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgKIXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgKIXQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 18:16:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0463D2065D;
        Mon,  9 Nov 2020 23:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604963791;
        bh=Aa9b05Qk604K2rjz8mDisDg0R7iWnGxjI1ju0SY5/MI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qdc/Os9kleBCD9uYhe365ZSuKtcY2iHlBIUrqAdhgpYOY8HTZ56NCMmDJ2tOs4ZHy
         2PTODUzqlzGioDz0DYNnwvMq0RhbNsrtbyWcDUMnM5+J7osxf5RDfXgP9J+gUqVkNb
         4z22s3AIlWM94CdcxQXQfttyu+vjjCnnvzQuXkyY=
Date:   Mon, 9 Nov 2020 15:16:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
Message-ID: <20201109151630.2a4579cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103104133.GA1573211@tws>
References: <20201103104133.GA1573211@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:41:33 +0100 Oliver Herms wrote:
> Due to the legacy usage of hard_header_len for SIT tunnels while
> already using infrastructure from net/ipv4/ip_tunnel.c the
> calculation of the path MTU in tnl_update_pmtu is incorrect.
> This leads to unnecessary creation of MTU exceptions for any
> flow going over a SIT tunnel.
> 
> As SIT tunnels do not have a header themsevles other than their
> transport (L3, L2) headers we're leaving hard_header_len set to zero
> as tnl_update_pmtu is already taking care of the transport headers
> sizes.
> 
> This will also help avoiding unnecessary IPv6 GC runs and spinlock
> contention seen when using SIT tunnels and for more than
> net.ipv6.route.gc_thresh flows.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>

Applied, thanks! Let's carry on the discussion about ipv6 tunnels,
though, it does look questionable.
