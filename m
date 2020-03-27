Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B2194EEE
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgC0C3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:29:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgC0C3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:29:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D76C915CC7479;
        Thu, 26 Mar 2020 19:29:08 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:29:07 -0700 (PDT)
Message-Id: <20200326.192907.1502687986030002778.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next v2 07/17] mptcp: queue data for mptcp level
 retransmission
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326204640.67336-8-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
        <20200326204640.67336-8-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:29:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Thu, 26 Mar 2020 13:46:30 -0700

> @@ -285,15 +285,75 @@ static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
>  	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
>  }
>  
> +static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
> +					      const struct page_frag *pfrag,
> +					      const struct mptcp_data_frag *df)

Please don't use inline in foo.c files, let the compiler decide.
