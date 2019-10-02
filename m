Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00305C45A4
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfJBBlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:41:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfJBBlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:41:37 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2616A14DAB32B;
        Tue,  1 Oct 2019 18:41:36 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:41:35 -0400 (EDT)
Message-Id: <20191001.214135.98815209147906561.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com,
        eric.dumazet@gmail.com, ycheng@google.com, marek@cloudflare.com
Subject: Re: [PATCH net] tcp: adjust rto_base in retransmits_timed_out()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930224444.77901-1-edumazet@google.com>
References: <20190930224444.77901-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:41:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 30 Sep 2019 15:44:44 -0700

> The cited commit exposed an old retransmits_timed_out() bug
> which assumed it could call tcp_model_timeout() with
> TCP_RTO_MIN as rto_base for all states.
> 
> But flows in SYN_SENT or SYN_RECV state uses a different
> RTO base (1 sec instead of 200 ms, unless BPF choses
> another value)
> 
> This caused a reduction of SYN retransmits from 6 to 4 with
> the default /proc/sys/net/ipv4/tcp_syn_retries value.
> 
> Fixes: a41e8a88b06e ("tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable.
