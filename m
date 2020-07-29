Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E8232518
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgG2TLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2TLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 15:11:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24650C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 12:11:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A328E1298F3A5;
        Wed, 29 Jul 2020 11:54:23 -0700 (PDT)
Date:   Wed, 29 Jul 2020 12:11:04 -0700 (PDT)
Message-Id: <20200729.121104.4622726933132816.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jhs@mojatatu.com,
        jiri@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] vxlan: Ensure FDB dump is performed under RCU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729083436.2050768-1-idosch@idosch.org>
References: <20200729083436.2050768-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 11:54:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 29 Jul 2020 11:34:36 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The commit cited below removed the RCU read-side critical section from
> rtnl_fdb_dump() which means that the ndo_fdb_dump() callback is invoked
> without RCU protection.
> 
> This results in the following warning [1] in the VXLAN driver, which
> relied on the callback being invoked from an RCU read-side critical
> section.
> 
> Fix this by calling rcu_read_lock() in the VXLAN driver, as already done
> in the bridge driver.
> 
> [1]
> WARNING: suspicious RCU usage
> 5.8.0-rc4-custom-01521-g481007553ce6 #29 Not tainted
 ...
> Fixes: 5e6d24358799 ("bridge: netlink dump interface at par with brctl")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks.
