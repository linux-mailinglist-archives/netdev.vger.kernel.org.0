Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4146E27650D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIXAb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:31:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06877C0613CE;
        Wed, 23 Sep 2020 17:31:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB6A011E58452;
        Wed, 23 Sep 2020 17:14:39 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:31:26 -0700 (PDT)
Message-Id: <20200923.173126.2037073365366368611.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     mathew.j.martineau@linux.intel.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] mptcp: Wake up MPTCP worker when DATA_FIN
 found on a TCP FIN packet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921145759.1302197-1-matthieu.baerts@tessares.net>
References: <20200921145759.1302197-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:14:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Mon, 21 Sep 2020 16:57:58 +0200

> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> When receiving a DATA_FIN MPTCP option on a TCP FIN packet, the DATA_FIN
> information would be stored but the MPTCP worker did not get
> scheduled. In turn, the MPTCP socket state would remain in
> TCP_ESTABLISHED and no blocked operations would be awakened.
> 
> TCP FIN packets are seen by the MPTCP socket when moving skbs out of the
> subflow receive queues, so schedule the MPTCP worker when a skb with
> DATA_FIN but no data payload is moved from a subflow queue. Other cases
> (DATA_FIN on a bare TCP ACK or on a packet with data payload) are
> already handled.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/84
> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied to 'net', thanks.
