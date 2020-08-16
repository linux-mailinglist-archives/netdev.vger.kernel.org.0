Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC92459E6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgHPW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgHPW3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:29:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16415C061786;
        Sun, 16 Aug 2020 15:29:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54FB2135F31A5;
        Sun, 16 Aug 2020 15:12:52 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:29:37 -0700 (PDT)
Message-Id: <20200816.152937.1107786737475087036.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH net] net: xdp: pull ethernet header off packet after
 computing skb->protocol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815072930.4564-1-Jason@zx2c4.com>
References: <20200815072930.4564-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 15:12:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 15 Aug 2020 09:29:30 +0200

> When an XDP program changes the ethernet header protocol field,
> eth_type_trans is used to recalculate skb->protocol. In order for
> eth_type_trans to work correctly, the ethernet header must actually be
> part of the skb data segment, so the code first pushes that onto the
> head of the skb. However, it subsequently forgets to pull it back off,
> making the behavior of the passed-on packet inconsistent between the
> protocol modifying case and the static protocol case. This patch fixes
> the issue by simply pulling the ethernet header back off of the skb
> head.
> 
> Fixes: 297249569932 ("net: fix generic XDP to handle if eth header was mangled")
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Applied and queued up for -stable, thanks.

Jesper, I wonder how your original patch was tested because it pushes a packet
with skb->data pointing at the ethernet header into the stack.  That should be
popped at this point as per this fix here.

Thanks.

