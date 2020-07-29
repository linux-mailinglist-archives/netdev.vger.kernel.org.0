Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74014232526
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG2TNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgG2TNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 15:13:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560C0C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 12:13:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 789171298F3AE;
        Wed, 29 Jul 2020 11:56:48 -0700 (PDT)
Date:   Wed, 29 Jul 2020 12:13:32 -0700 (PDT)
Message-Id: <20200729.121332.1722544892017052313.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        alexander.h.duyck@intel.com, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] ipv4: Silence suspicious RCU usage warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729083713.2051435-1-idosch@idosch.org>
References: <20200729083713.2051435-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 11:56:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 29 Jul 2020 11:37:13 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> fib_trie_unmerge() is called with RTNL held, but not from an RCU
> read-side critical section. This leads to the following warning [1] when
> the FIB alias list in a leaf is traversed with
> hlist_for_each_entry_rcu().
> 
> Since the function is always called with RTNL held and since
> modification of the list is protected by RTNL, simply use
> hlist_for_each_entry() and silence the warning.
> 
> [1]
> WARNING: suspicious RCU usage
> 5.8.0-rc4-custom-01520-gc1f937f3f83b #30 Not tainted
> -----------------------------
> net/ipv4/fib_trie.c:1867 RCU-list traversed in non-reader section!!
 ...
> Fixes: 0ddcf43d5d4a ("ipv4: FIB Local/MAIN table collapse")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Also applied, thanks.
