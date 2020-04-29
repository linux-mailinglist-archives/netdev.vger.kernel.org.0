Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6F1BE788
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD2Tkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Tkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:40:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B23AC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:40:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96BF31210A3E3;
        Wed, 29 Apr 2020 12:40:51 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:40:50 -0700 (PDT)
Message-Id: <20200429.124050.2123497422809828869.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net] mptcp: replace mptcp_disconnect with a stub
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429184320.30733-1-fw@strlen.de>
References: <20200429184320.30733-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:40:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 29 Apr 2020 20:43:20 +0200

> Paolo points out that mptcp_disconnect is bogus:
> "lock_sock(sk);
> looks suspicious (lock should be already held by the caller)
> And call to: tcp_disconnect(sk, flags); too, sk is not a tcp
> socket".
> 
> ->disconnect() gets called from e.g. inet_stream_connect when
> one tries to disassociate a connected socket again (to re-connect
> without closing the socket first).
> MPTCP however uses mptcp_stream_connect, not inet_stream_connect,
> for the mptcp-socket connect call.
> 
> inet_stream_connect only gets called indirectly, for the tcp socket,
> so any ->disconnect() calls end up calling tcp_disconnect for that
> tcp subflow sk.
> 
> This also explains why syzkaller has not yet reported a problem
> here.  So for now replace this with a stub that doesn't do anything.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/14
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied.
