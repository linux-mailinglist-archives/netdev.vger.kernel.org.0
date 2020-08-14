Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC680244F5F
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 22:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgHNUzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 16:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgHNUzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 16:55:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D44C061385;
        Fri, 14 Aug 2020 13:55:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19883127471E4;
        Fri, 14 Aug 2020 13:39:01 -0700 (PDT)
Date:   Fri, 14 Aug 2020 13:55:46 -0700 (PDT)
Message-Id: <20200814.135546.2266851283177227377.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        kuba@kernel.org, alexei.starovoitov@gmail.com
Subject: Re: [PATCH net v5] net: xdp: account for layer 3 packets in
 generic skb handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814073048.30291-1-Jason@zx2c4.com>
References: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
        <20200814073048.30291-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:39:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 14 Aug 2020 09:30:48 +0200

> @@ -4676,6 +4688,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
>  		__skb_push(skb, ETH_HLEN);
>  		skb->protocol = eth_type_trans(skb, skb->dev);
> +		__skb_pull(skb, ETH_HLEN);
>  	}
>  
>  	switch (act) {

This bug fix is separate from your other changes.  Please do not combine
them.
