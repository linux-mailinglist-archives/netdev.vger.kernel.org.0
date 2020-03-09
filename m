Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452F517D893
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIE01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:26:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIE01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:26:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5E97158B5848;
        Sun,  8 Mar 2020 21:26:26 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:26:26 -0700 (PDT)
Message-Id: <20200308.212626.1535278286897905339.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] gre: fix uninit-value in __iptunnel_pull_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308060514.149512-1-edumazet@google.com>
References: <20200308060514.149512-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:26:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  7 Mar 2020 22:05:14 -0800

> syzbot found an interesting case of the kernel reading
> an uninit-value [1]
> 
> Problem is in the handling of ETH_P_WCCP in gre_parse_header()
> 
> We look at the byte following GRE options to eventually decide
> if the options are four bytes longer.
> 
> Use skb_header_pointer() to not pull bytes if we found
> that no more bytes were needed.
> 
> All callers of gre_parse_header() are properly using pskb_may_pull()
> anyway before proceeding to next header.
> 
> [1]
 ...
> Fixes: 95f5c64c3c13 ("gre: Move utility functions to common headers")
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
