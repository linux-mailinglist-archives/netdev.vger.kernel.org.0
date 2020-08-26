Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C49253A82
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHZW76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZW75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:59:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56877C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:59:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AA5A12961928;
        Wed, 26 Aug 2020 15:43:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:59:55 -0700 (PDT)
Message-Id: <20200826.155955.378926781937673433.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net] ipv4: Silence suspicious RCU usage warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826164810.1029595-1-idosch@idosch.org>
References: <20200826164810.1029595-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:43:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 26 Aug 2020 19:48:10 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> fib_info_notify_update() is always called with RTNL held, but not from
> an RCU read-side critical section. This leads to the following warning
> [1] when the FIB table list is traversed with
> hlist_for_each_entry_rcu(), but without a proper lockdep expression.
> 
> Since modification of the list is protected by RTNL, silence the warning
> by adding a lockdep expression which verifies RTNL is held.
 ...
> Fixes: 1bff1a0c9bbd ("ipv4: Add function to send route updates")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Applied and queued up for -stable, thanks.
