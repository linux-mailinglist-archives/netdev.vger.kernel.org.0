Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1595E89658
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfHLEmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:42:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfHLEmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:42:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE650145F4F5D;
        Sun, 11 Aug 2019 21:42:15 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:42:15 -0700 (PDT)
Message-Id: <20190811.214215.1211940529349794121.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: tc35815: Explicitly check NET_IP_ALIGN is not
 zero in tc35815_rx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812031345.41157-1-natechancellor@gmail.com>
References: <20190812031345.41157-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:42:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Sun, 11 Aug 2019 20:13:45 -0700

> clang warns:
> 
> drivers/net/ethernet/toshiba/tc35815.c:1507:30: warning: use of logical
> '&&' with constant operand [-Wconstant-logical-operand]
>                         if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
>                                                   ^  ~~~~~~~~~~~~
> drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: use '&' for a
> bitwise operation
>                         if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
>                                                   ^~
>                                                   &
> drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: remove constant to
> silence this warning
>                         if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
>                                                  ~^~~~~~~~~~~~~~~
> 1 warning generated.
> 
> Explicitly check that NET_IP_ALIGN is not zero, which matches how this
> is checked in other parts of the tree. Because NET_IP_ALIGN is a build
> time constant, this check will be constant folded away during
> optimization.
> 
> Fixes: 82a9928db560 ("tc35815: Enable StripCRC feature")
> Link: https://github.com/ClangBuiltLinux/linux/issues/608
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied but I think clang is being rediculous.
