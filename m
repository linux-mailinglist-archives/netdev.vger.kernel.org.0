Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEC018C5B4
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCTD0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:26:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgCTD0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:26:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99094158EC773;
        Thu, 19 Mar 2020 20:26:14 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:26:13 -0700 (PDT)
Message-Id: <20200319.202613.1356628708983056491.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, vladbu@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] net: sched: Do not assume RTNL is held in
 tunnel key action helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319113310.1031149-1-idosch@idosch.org>
References: <20200319113310.1031149-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 20:26:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 19 Mar 2020 13:33:10 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The cited commit removed RTNL from tc_setup_flow_action(), but the
> function calls two tunnel key action helpers that use rtnl_dereference()
> to fetch the action's parameters. This leads to "suspicious RCU usage"
> warnings [1][2].
> 
> Change the helpers to use rcu_dereference_protected() while requiring
> the action's lock to be held. This is safe because the two helpers are
> only called from tc_setup_flow_action() which acquires the lock.
 ...
> Fixes: b15e7a6e8d31 ("net: sched: don't take rtnl lock during flow_action setup")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>

Applied, thank you.
