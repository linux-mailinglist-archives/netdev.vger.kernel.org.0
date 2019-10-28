Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3826FE7A97
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbfJ1Uy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:54:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1Uy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:54:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABC9514B7A8AC;
        Mon, 28 Oct 2019 13:54:56 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:54:56 -0700 (PDT)
Message-Id: <20191028.135456.145825661160523017.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, pabeni@redhat.com
Subject: Re: [PATCH net] udp: fix data-race in udp_set_dev_scratch()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024184331.28920-1-edumazet@google.com>
References: <20191024184331.28920-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:54:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 24 Oct 2019 11:43:31 -0700

> KCSAN reported a data-race in udp_set_dev_scratch() [1]
> 
> The issue here is that we must not write over skb fields
> if skb is shared. A similar issue has been fixed in commit
> 89c22d8c3b27 ("net: Fix skb csum races when peeking")
> 
> While we are at it, use a helper only dealing with
> udp_skb_scratch(skb)->csum_unnecessary, as this allows
> udp_set_dev_scratch() to be called once and thus inlined.
> 
> [1]
 ...
> Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
