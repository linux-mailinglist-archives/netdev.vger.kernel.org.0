Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C8206AC4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbgFXDtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388609AbgFXDtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:49:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64AEC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:49:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5367B1298785B;
        Tue, 23 Jun 2020 20:49:49 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:49:48 -0700 (PDT)
Message-Id: <20200623.204948.194068071672775099.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        saeedm@mellanox.com, borisp@mellanox.com
Subject: Re: [PATCH net V2] net: Do not clear the sock TX queue in
 sk_set_socket()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592857564-13755-1-git-send-email-tariqt@mellanox.com>
References: <1592857564-13755-1-git-send-email-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:49:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Mon, 22 Jun 2020 23:26:04 +0300

> Clearing the sock TX queue in sk_set_socket() might cause unexpected
> out-of-order transmit when called from sock_orphan(), as outstanding
> packets can pick a different TX queue and bypass the ones already queued.
> 
> This is undesired in general. More specifically, it breaks the in-order
> scheduling property guarantee for device-offloaded TLS sockets.
> 
> Remove the call to sk_tx_queue_clear() in sk_set_socket(), and add it
> explicitly only where needed.
> 
> Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>

Applied and queued up for -stable, thank you.
