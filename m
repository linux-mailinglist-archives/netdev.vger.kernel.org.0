Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC14260E17
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 01:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfGEXTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 19:19:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEXTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 19:19:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACE9615043C44;
        Fri,  5 Jul 2019 16:19:33 -0700 (PDT)
Date:   Fri, 05 Jul 2019 16:19:33 -0700 (PDT)
Message-Id: <20190705.161933.2002038370655051093.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] ipv4: Fix NULL pointer dereference in
 ipv4_neigh_lookup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704162638.17913-1-idosch@idosch.org>
References: <20190704162638.17913-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 16:19:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  4 Jul 2019 19:26:38 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Both ip_neigh_gw4() and ip_neigh_gw6() can return either a valid pointer
> or an error pointer, but the code currently checks that the pointer is
> not NULL.
> 
> Fix this by checking that the pointer is not an error pointer, as this
> can result in a NULL pointer dereference [1]. Specifically, I believe
> that what happened is that ip_neigh_gw4() returned '-EINVAL'
> (0xffffffffffffffea) to which the offset of 'refcnt' (0x70) was added,
> which resulted in the address 0x000000000000005a.
> 
> [1]
 ...
> Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Shalom Toledo <shalomt@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks.
