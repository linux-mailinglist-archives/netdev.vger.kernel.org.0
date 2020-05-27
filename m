Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF81E4D76
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgE0Swi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgE0Swg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:52:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E70DC08C5D1;
        Wed, 27 May 2020 11:35:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95D78128B3528;
        Wed, 27 May 2020 11:35:25 -0700 (PDT)
Date:   Wed, 27 May 2020 11:35:24 -0700 (PDT)
Message-Id: <20200527.113524.946608619523725892.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        kuba@kernel.org, tglx@linutronix.de,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] bridge: multicast: work around clang bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527135124.1082844-1-arnd@arndb.de>
References: <20200527135124.1082844-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:35:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 27 May 2020 15:51:13 +0200

> Clang-10 and clang-11 run into a corner case of the register
> allocator on 32-bit ARM, leading to excessive stack usage from
> register spilling:
> 
> net/bridge/br_multicast.c:2422:6: error: stack frame size of 1472 bytes in function 'br_multicast_get_stats' [-Werror,-Wframe-larger-than=]
> 
> Work around this by marking one of the internal functions as
> noinline_for_stack.
> 
> Link: https://bugs.llvm.org/show_bug.cgi?id=45802#c9
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
