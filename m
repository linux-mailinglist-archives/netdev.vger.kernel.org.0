Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E937200095
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgFSDOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgFSDOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:14:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07917C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:14:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B220B120ED49A;
        Thu, 18 Jun 2020 20:14:16 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:14:16 -0700 (PDT)
Message-Id: <20200618.201416.134857504304955791.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, xeb@mail.ru,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net v2] ip6_gre: fix use-after-free in
 ip6gre_tunnel_lookup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616160400.8579-1-ap420073@gmail.com>
References: <20200616160400.8579-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:14:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue, 16 Jun 2020 16:04:00 +0000

> In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
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
> Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable.
