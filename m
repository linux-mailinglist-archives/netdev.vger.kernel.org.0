Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BA5200097
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgFSDPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgFSDPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:15:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C7CC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:15:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6588A120ED49A;
        Thu, 18 Jun 2020 20:15:02 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:15:01 -0700 (PDT)
Message-Id: <20200618.201501.2227346198125853544.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, pshelar@nicira.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net v3] ip_tunnel: fix use-after-free in
 ip_tunnel_lookup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616165151.19540-1-ap420073@gmail.com>
References: <20200616165151.19540-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:15:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue, 16 Jun 2020 16:51:51 +0000

> In the datapath, the ip_tunnel_lookup() is used and it internally uses
> fallback tunnel device pointer, which is fb_tunnel_dev.
> This pointer variable should be set to NULL when a fb interface is deleted.
> But there is no routine to set fb_tunnel_dev pointer to NULL.
> So, this pointer will be still used after interface is deleted and
> it eventually results in the use-after-free problem.
> 
> Test commands:
 ...
> Splat looks like:
 ...
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable.
