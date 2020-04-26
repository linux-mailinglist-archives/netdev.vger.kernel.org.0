Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066BE1B8BAF
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgDZDiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726126AbgDZDiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:38:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA11C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 20:38:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01048159FC800;
        Sat, 25 Apr 2020 20:38:15 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:38:15 -0700 (PDT)
Message-Id: <20200425.203815.652543937267054453.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] tcp: mptcp: use mptcp receive buffer space to
 select rcv window
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424103150.334-1-fw@strlen.de>
References: <20200424103150.334-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:38:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 24 Apr 2020 12:31:50 +0200

> In MPTCP, the receive window is shared across all subflows, because it
> refers to the mptcp-level sequence space.
> 
> MPTCP receivers already place incoming packets on the mptcp socket
> receive queue and will charge it to the mptcp socket rcvbuf until
> userspace consumes the data.
> 
> Update __tcp_select_window to use the occupancy of the parent/mptcp
> socket instead of the subflow socket in case the tcp socket is part
> of a logical mptcp connection.
> 
> This commit doesn't change choice of initial window for passive or active
> connections.
> While it would be possible to change those as well, this adds complexity
> (especially when handling MP_JOIN requests).  Furthermore, the MPTCP RFC
> specifically says that a MPTCP sender 'MUST NOT use the RCV.WND field
> of a TCP segment at the connection level if it does not also carry a DSS
> option with a Data ACK field.'
> 
> SYN/SYNACK packets do not carry a DSS option with a Data ACK field.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied.
