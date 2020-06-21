Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1702920279D
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgFUAbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUAbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:31:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B3C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:31:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11B50120ED49C;
        Sat, 20 Jun 2020 17:31:13 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:31:12 -0700 (PDT)
Message-Id: <20200620.173112.1919297460689030392.davem@davemloft.net>
To:     amritha.nambiar@intel.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        alexander.h.duyck@intel.com, eliezer.tamir@linux.intel.com,
        sridhar.samudrala@intel.com
Subject: Re: [net-next PATCH] net: Avoid overwriting valid skb->napi_id
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
References: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:31:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amritha Nambiar <amritha.nambiar@intel.com>
Date: Thu, 18 Jun 2020 14:22:15 -0700

> This will be useful to allow busy poll for tunneled traffic. In case of
> busy poll for sessions over tunnels, the underlying physical device's
> queues need to be polled.
> 
> Tunnels schedule NAPI either via netif_rx() for backlog queue or
> schedule the gro_cell_poll(). netif_rx() propagates the valid skb->napi_id
> to the socket. OTOH, gro_cell_poll() stamps the skb->napi_id again by
> calling skb_mark_napi_id() with the tunnel NAPI which is not a busy poll
> candidate. This was preventing tunneled traffic to use busy poll. A valid
> NAPI ID in the skb indicates it was already marked for busy poll by a
> NAPI driver and hence needs to be copied into the socket.
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>

Applied, thank you.
