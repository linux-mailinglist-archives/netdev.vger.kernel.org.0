Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2EA1BE6A0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD2Suh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Sug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:50:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC65C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:50:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80AF21210D904;
        Wed, 29 Apr 2020 11:50:35 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:50:34 -0700 (PDT)
Message-Id: <20200429.115034.117126455083840977.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, cpaasch@apple.com, mptcp@lists.01.org
Subject: Re: [PATCH net 1/5] mptcp: consolidate synack processing.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5261bc9add632deda5890816c41188ee80c6765e.1588156257.git.pabeni@redhat.com>
References: <cover.1588156257.git.pabeni@redhat.com>
        <5261bc9add632deda5890816c41188ee80c6765e.1588156257.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 11:50:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 29 Apr 2020 12:41:45 +0200

> @@ -222,6 +222,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
>  	struct sock *parent = subflow->conn;
> +	struct tcp_sock *tp = tcp_sk(sk);

Since you introduce this 'tp' variable...

> +	} else if (subflow->request_mptcp) {
> +		tcp_sk(sk)->is_mptcp = 0;

Please use it here.

> +	}
> +
> +	if (!tcp_sk(sk)->is_mptcp)
>  		return;

And here.

Thank you.
