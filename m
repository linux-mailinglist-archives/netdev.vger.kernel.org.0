Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18935BC83C
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395325AbfIXMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 08:53:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbfIXMxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 08:53:02 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADA9315163DFE;
        Tue, 24 Sep 2019 05:53:00 -0700 (PDT)
Date:   Tue, 24 Sep 2019 14:52:57 +0200 (CEST)
Message-Id: <20190924.145257.2013712373872209531.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924073615.31704-1-Jason@zx2c4.com>
References: <20190924073615.31704-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 05:53:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 24 Sep 2019 09:36:15 +0200

> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case in the link of
> this commit reliably triggers various crashes due to the use-after-free
> caused by the reference underflow.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Test-case: https://git.zx2c4.com/WireGuard/commit/?id=ad66532000f7a20b149e47c5eb3a957362c8e161
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Please make such test cases integratabe into the selftests area for networking
and submit it along with this fix.

Otherwise this code will regress.

Thank you.

