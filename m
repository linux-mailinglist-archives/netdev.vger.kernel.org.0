Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C101C42D4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgEDRcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729942AbgEDRcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:32:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE958C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:32:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDA59119534F6;
        Mon,  4 May 2020 10:32:04 -0700 (PDT)
Date:   Mon, 04 May 2020 10:32:04 -0700 (PDT)
Message-Id: <20200504.103204.2161530815623718852.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix partial topology connection closure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504041554.3703-1-tuong.t.lien@dektech.com.au>
References: <20200504041554.3703-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:32:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Mon,  4 May 2020 11:15:54 +0700

> When an application connects to the TIPC topology server and subscribes
> to some services, a new connection is created along with some objects -
> 'tipc_subscription' to store related data correspondingly...
> However, there is one omission in the connection handling that when the
> connection or application is orderly shutdown (e.g. via SIGQUIT, etc.),
> the connection is not closed in kernel, the 'tipc_subscription' objects
> are not freed too.
> This results in:
> - The maximum number of subscriptions (65535) will be reached soon, new
> subscriptions will be rejected;
> - TIPC module cannot be removed (unless the objects  are somehow forced
> to release first);
> 
> The commit fixes the issue by closing the connection if the 'recvmsg()'
> returns '0' i.e. when the peer is shutdown gracefully. It also includes
> the other unexpected cases.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thanks.
