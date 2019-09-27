Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2575C0B65
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfI0SjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:39:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbfI0SjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:39:23 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8121C153F19C0;
        Fri, 27 Sep 2019 11:39:21 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:39:19 +0200 (CEST)
Message-Id: <20190927.203919.1324154741369410270.davem@davemloft.net>
To:     yyd@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com,
        soheil@google.com, priyarjha@google.com
Subject: Re: [PATCH net] tcp_bbr: fix quantization code to not raise cwnd
 if not probing bandwidth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926143005.106045-1-yyd@google.com>
References: <20190926143005.106045-1-yyd@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:39:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Kevin(Yudong) Yang" <yyd@google.com>
Date: Thu, 26 Sep 2019 10:30:05 -0400

> There was a bug in the previous logic that attempted to ensure gain cycling
> gets inflight above BDP even for small BDPs. This code correctly raised and
> lowered target inflight values during the gain cycle. And this code
> correctly ensured that cwnd was raised when probing bandwidth. However, it
> did not correspondingly ensure that cwnd was *not* raised in this way when
> *not* probing for bandwidth. The result was that small-BDP flows that were
> always cwnd-bound could go for many cycles with a fixed cwnd, and not probe
> or yield bandwidth at all. This meant that multiple small-BDP flows could
> fail to converge in their bandwidth allocations.
> 
> Fixes: 383d470 ("tcp_bbr: fix bw probing to raise in-flight data for very small BDPs")

Always use 12 digits of significance for SHA1 IDs, there are already 6 digit conflicts.

> Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Priyaranjan Jha <priyarjha@google.com>

Applied and queued up for -stable.
