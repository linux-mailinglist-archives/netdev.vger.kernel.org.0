Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A30C26E970
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIQXZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:25:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0B8C06174A;
        Thu, 17 Sep 2020 16:25:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBDC81365D756;
        Thu, 17 Sep 2020 16:08:31 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:25:17 -0700 (PDT)
Message-Id: <20200917.162517.1954900068049030234.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        john.ogness@linutronix.de, wanghai38@huawei.com, arnd@arndb.de
Subject: Re: [PATCH net-next] net/packet: Fix a comment about mac_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916122308.11678-1-xie.he.0141@gmail.com>
References: <20200916122308.11678-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:08:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed, 16 Sep 2020 05:23:08 -0700

> 1. Change all "dev->hard_header" to "dev->header_ops"
> 
> 2. On receiving incoming frames when header_ops == NULL:
> 
> The comment only says what is wrong, but doesn't say what is right.
> This patch changes the comment to make it clear what is right.
> 
> 3. On transmitting and receiving outgoing frames when header_ops == NULL:
> 
> The comment explains that the LL header will be later added by the driver.
> 
> However, I think it's better to simply say that the LL header is invisible
> to us. This phrasing is better from a software engineering perspective,
> because this makes it clear that what happens in the driver should be
> hidden from us and we should not care about what happens internally in the
> driver.
> 
> 4. On resuming the LL header (for RAW frames) when header_ops == NULL:
> 
> The comment says we are "unlikely" to restore the LL header.
> 
> However, we should say that we are "unable" to restore it.
> It's not possible (rather than not likely) to restore it, because:
> 
> 1) There is no way for us to restore because the LL header internally
> processed by the driver should be invisible to us.
> 
> 2) In function packet_rcv and tpacket_rcv, the code only tries to restore
> the LL header when header_ops != NULL.
> 
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
