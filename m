Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABF615CE05
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBMWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:19:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:19:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5710015B75334;
        Thu, 13 Feb 2020 14:19:22 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:19:21 -0800 (PST)
Message-Id: <20200213.141921.2246207693168419669.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 net 0/5] icmp: account for NAT when sending icmps
 from ndo layer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 14:19:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 11 Feb 2020 20:47:04 +0100

> The ICMP routines use the source address for two reasons:
> 
> 1. Rate-limiting ICMP transmissions based on source address, so
>    that one source address cannot provoke a flood of replies. If
>    the source address is wrong, the rate limiting will be
>    incorrectly applied.
> 
> 2. Choosing the interface and hence new source address of the
>    generated ICMP packet. If the original packet source address
>    is wrong, ICMP replies will be sent from the wrong source
>    address, resulting in either a misdelivery, infoleak, or just
>    general network admin confusion.
> 
> Most of the time, the icmp_send and icmpv6_send routines can just reach
> down into the skb's IP header to determine the saddr. However, if
> icmp_send or icmpv6_send is being called from a network device driver --
> there are a few in the tree -- then it's possible that by the time
> icmp_send or icmpv6_send looks at the packet, the packet's source
> address has already been transformed by SNAT or MASQUERADE or some other
> transformation that CONNTRACK knows about. In this case, the packet's
> source address is most certainly the *wrong* source address to be used
> for the purpose of ICMP replies.
> 
> Rather, the source address we want to use for ICMP replies is the
> original one, from before the transformation occurred.
 ...

Series applied, thank you.

