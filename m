Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25AC4F908
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVXvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:51:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVXvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:51:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26AD4136DDD20;
        Sat, 22 Jun 2019 16:51:12 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:51:11 -0700 (PDT)
Message-Id: <20190622.165111.1722448155363637012.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2] ipv6: Error when route does not have any
 valid nexthops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620091021.18210-1-idosch@idosch.org>
References: <20190620091021.18210-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:51:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 20 Jun 2019 12:10:21 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> When user space sends invalid information in RTA_MULTIPATH, the nexthop
> list in ip6_route_multipath_add() is empty and 'rt_notif' is set to
> NULL.
> 
> The code that emits the in-kernel notifications does not check for this
> condition, which results in a NULL pointer dereference [1].
> 
> Fix this by bailing earlier in the function if the parsed nexthop list
> is empty. This is consistent with the corresponding IPv4 code.
> 
> v2:
> * Check if parsed nexthop list is empty and bail with extack set
> 
> [1]
 ...
> 
> Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
> Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied.
