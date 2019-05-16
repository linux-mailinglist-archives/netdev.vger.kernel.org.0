Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3254A20F23
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEPTSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:18:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfEPTSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:18:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC3CC133E977F;
        Thu, 16 May 2019 12:18:41 -0700 (PDT)
Date:   Thu, 16 May 2019 12:18:41 -0700 (PDT)
Message-Id: <20190516.121841.1544241385308476523.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com
Subject: Re: [PATCH net] net: test nouarg before dereferencing zerocopy
 pointers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190515172916.143166-1-willemdebruijn.kernel@gmail.com>
References: <20190515172916.143166-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:18:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 15 May 2019 13:29:16 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Zerocopy skbs without completion notification were added for packet
> sockets with PACKET_TX_RING user buffers. Those signal completion
> through the TP_STATUS_USER bit in the ring. Zerocopy annotation was
> added only to avoid premature notification after clone or orphan, by
> triggering a copy on these paths for these packets.
> 
> The mechanism had to define a special "no-uarg" mode because packet
> sockets already use skb_uarg(skb) == skb_shinfo(skb)->destructor_arg
> for a different pointer.
> 
> Before deferencing skb_uarg(skb), verify that it is a real pointer.
> 
> Fixes: 5cd8d46ea1562 ("packet: copy user buffers before orphan or clone")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks.
