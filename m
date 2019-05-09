Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E265518E01
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfEIQ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:27:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfEIQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:27:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D0F214CF93CC;
        Thu,  9 May 2019 09:27:30 -0700 (PDT)
Date:   Thu, 09 May 2019 09:27:29 -0700 (PDT)
Message-Id: <20190509.092729.490057205840616989.davem@davemloft.net>
To:     parthasarathy.bhuvaragan@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net,
        jon.maloy@ericsson.se
Subject: Re: [PATCH net v1] tipc: fix hanging clients using poll with
 EPOLLOUT flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509051342.6187-1-parthasarathy.bhuvaragan@gmail.com>
References: <20190509051342.6187-1-parthasarathy.bhuvaragan@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:27:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
Date: Thu,  9 May 2019 07:13:42 +0200

> commit 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
> introduced a regression for clients using non-blocking sockets.
> After the commit, we send EPOLLOUT event to the client even in
> TIPC_CONNECTING state. This causes the subsequent send() to fail
> with ENOTCONN, as the socket is still not in TIPC_ESTABLISHED state.
> 
> In this commit, we:
> - improve the fix for hanging poll() by replacing sk_data_ready()
>   with sk_state_change() to wake up all clients.
> - revert the faulty updates introduced by commit 517d7c79bdb398
>   ("tipc: fix hanging poll() for stream sockets").
> 
> Fixes: 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
> Signed-off-by: Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.se>

Applied and queued up for -stable.
