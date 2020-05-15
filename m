Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55B51D5A06
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgEOTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgEOTbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:31:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BE8C05BD0B
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 12:31:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35E1E15305FA3;
        Fri, 15 May 2020 12:31:03 -0700 (PDT)
Date:   Fri, 15 May 2020 12:30:59 -0700 (PDT)
Message-Id: <20200515.123059.151278519835306555.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, cpaasch@apple.com,
        mptcp@lists.01.org, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next v2 0/3] mptcp: fix MP_JOIN failure handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1589558049.git.pabeni@redhat.com>
References: <cover.1589558049.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 12:31:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 15 May 2020 19:22:14 +0200

> Currently if we hit an MP_JOIN failure on the third ack, the child socket is
> closed with reset, but the request socket is not deleted, causing weird
> behaviors.
> 
> The main problem is that MPTCP's MP_JOIN code needs to plug it's own
> 'valid 3rd ack' checks and the current TCP callbacks do not allow that.
> 
> This series tries to address the above shortcoming introducing a new MPTCP
> specific bit in a 'struct tcp_request_sock' hole, and leveraging that to allow
> tcp_check_req releasing the request socket when needed.
> 
> The above allows cleaning-up a bit current MPTCP hooking in tcp_check_req().
> 
> An alternative solution, possibly cleaner but more invasive, would be
> changing the 'bool *own_req' syn_recv_sock() argument into 'int *req_status'
> and let MPTCP set it to 'REQ_DROP'.
> 
> v1 -> v2:
>  - be more conservative about drop_req initialization
> 
> RFC -> v1:
>  - move the drop_req bit inside tcp_request_sock (Eric)

Series applied, thanks Paolo.
