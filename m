Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56F25B68D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIBWpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBWpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:45:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBEC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 15:45:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD74B157347B5;
        Wed,  2 Sep 2020 15:29:03 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:45:49 -0700 (PDT)
Message-Id: <20200902.154549.1724506065958112316.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net] ipv6: Fix sysctl max for fib_multipath_hash_policy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902131659.2051734-1-idosch@idosch.org>
References: <20200902131659.2051734-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:29:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed,  2 Sep 2020 16:16:59 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit added the possible value of '2', but it cannot be set. Fix
> it by adjusting the maximum value to '2'. This is consistent with the
> corresponding IPv4 sysctl.
> 
> Before:
> 
> # sysctl -w net.ipv6.fib_multipath_hash_policy=2
> sysctl: setting key "net.ipv6.fib_multipath_hash_policy": Invalid argument
> net.ipv6.fib_multipath_hash_policy = 2
> # sysctl net.ipv6.fib_multipath_hash_policy
> net.ipv6.fib_multipath_hash_policy = 0
> 
> After:
> 
> # sysctl -w net.ipv6.fib_multipath_hash_policy=2
> net.ipv6.fib_multipath_hash_policy = 2
> # sysctl net.ipv6.fib_multipath_hash_policy
> net.ipv6.fib_multipath_hash_policy = 2
> 
> Fixes: d8f74f0975d8 ("ipv6: Support multipath hashing on inner IP pkts")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Wow, how was this mode even tested...

Applied and queued up for -stable, thanks.

