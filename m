Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3462C4870
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgKYTb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgKYTb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:31:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8066E207BC;
        Wed, 25 Nov 2020 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606332715;
        bh=x7K/ajjC3mN5J5QrxuS3GALRElDAAPkqLx0RhZTP85c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l5YEVfvlrYITXkFpLPn8m7dKGFy3AU9Rq0lcMSxkpxAElQ5OK3+zAMStbEeu8A/yb
         7yCviwHGriUy1+3fw1neFiVf/kP7UKQcxCmqIyQe7naBH3Z/kmg847g6woqZsRuEgf
         ERwspMqdbLdV7tXDcrVIPTFn0C3gEL8HXRCKahVU=
Date:   Wed, 25 Nov 2020 11:31:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] gro_cells: reduce number of synchronize_net() calls
Message-ID: <20201125113154.739bc908@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124203822.1360107-1-eric.dumazet@gmail.com>
References: <20201124203822.1360107-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 12:38:22 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After cited commit, gro_cells_destroy() became damn slow
> on hosts with a lot of cores.
> 
> This is because we have one additional synchronize_net() per cpu as
> stated in the changelog.
> 
> gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
> to not have one synchronize_net() call per netif_napi_del()
> 
> We can factorize all the synchronize_net() to a single one,
> right before freeing per-cpu memory.
> 
> Fixes: 5198d545dba8 ("net: remove napi_hash_del() from driver-facing API")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
