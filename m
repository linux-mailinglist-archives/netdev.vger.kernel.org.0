Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C938516B208
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgBXVTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:19:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXVTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:19:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B142A121A82C6;
        Mon, 24 Feb 2020 13:19:41 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:19:41 -0800 (PST)
Message-Id: <20200224.131941.1864899496346758786.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ip6mr: Fix RCU list debugging warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200222165726.9330-1-frextrite@gmail.com>
References: <20200222165726.9330-1-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:19:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>
Date: Sat, 22 Feb 2020 22:27:27 +0530

> ip6mr_for_each_table() macro uses list_for_each_entry_rcu()
> for traversing outside an RCU read side critical section
> but under the protection of rtnl_mutex. Hence add the
> corresponding lockdep expression to silence the following
> false-positive warnings:
> 
> [    4.319479] =============================
> [    4.319480] WARNING: suspicious RCU usage
> [    4.319482] 5.5.4-stable #17 Tainted: G            E
> [    4.319483] -----------------------------
> [    4.319485] net/ipv6/ip6mr.c:1243 RCU-list traversed in non-reader section!!
> 
> [    4.456831] =============================
> [    4.456832] WARNING: suspicious RCU usage
> [    4.456834] 5.5.4-stable #17 Tainted: G            E
> [    4.456835] -----------------------------
> [    4.456837] net/ipv6/ip6mr.c:1582 RCU-list traversed in non-reader section!!
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>

Applied, thanks.
