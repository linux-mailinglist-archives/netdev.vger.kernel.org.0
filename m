Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1812699F6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgINX6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINX6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:58:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5224BC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:58:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD83E128E5E64;
        Mon, 14 Sep 2020 16:41:48 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:58:35 -0700 (PDT)
Message-Id: <20200914.165835.2089542967228126257.davem@davemloft.net>
To:     soheil.kdev@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, soheil@google.com
Subject: Re: [PATCH net-next 1/2] tcp: return EPOLLOUT from tcp_poll only
 when notsent_bytes is half the limit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914215210.2288109-1-soheil.kdev@gmail.com>
References: <20200914215210.2288109-1-soheil.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:41:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
Date: Mon, 14 Sep 2020 17:52:09 -0400

> From: Soheil Hassas Yeganeh <soheil@google.com>
> 
> If there was any event available on the TCP socket, tcp_poll()
> will be called to retrieve all the events.  In tcp_poll(), we call
> sk_stream_is_writeable() which returns true as long as we are at least
> one byte below notsent_lowat.  This will result in quite a few
> spurious EPLLOUT and frequent tiny sendmsg() calls as a result.
> 
> Similar to sk_stream_write_space(), use __sk_stream_is_writeable
> with a wake value of 1, so that we set EPOLLOUT only if half the
> space is available for write.
> 
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
