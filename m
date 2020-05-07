Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2D1C7E85
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgEGAXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgEGAXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:23:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAD9C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 17:23:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20F851277C5C0;
        Wed,  6 May 2020 17:23:39 -0700 (PDT)
Date:   Wed, 06 May 2020 17:23:38 -0700 (PDT)
Message-Id: <20200506.172338.1702704236989217382.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: stricter validation of untrusted gso packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504164855.154740-1-willemdebruijn.kernel@gmail.com>
References: <20200504164855.154740-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:23:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon,  4 May 2020 12:48:54 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Syzkaller again found a path to a kernel crash through bad gso input:
> a packet with transport header extending beyond skb_headlen(skb).
> 
> Tighten validation at kernel entry:
> 
> - Verify that the transport header lies within the linear section.
> 
>     To avoid pulling linux/tcp.h, verify just sizeof tcphdr.
>     tcp_gso_segment will call pskb_may_pull (th->doff * 4) before use.
> 
> - Match the gso_type against the ip_proto found by the flow dissector.
> 
> Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks.
