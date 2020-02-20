Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DA81665C5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBTSEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:04:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgBTSEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:04:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78FDB15AC0C10;
        Thu, 20 Feb 2020 10:04:49 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:04:48 -0800 (PST)
Message-Id: <20200220.100448.49805640721461744.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/15] mlxsw: Preparation for RTNL removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:04:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 20 Feb 2020 09:07:45 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The driver currently acquires RTNL in its route insertion path, which
> contributes to very large control plane latencies. This patch set
> prepares mlxsw for RTNL removal from its route insertion path in a
> follow-up patch set.
> 
> Patches #1-#2 protect shared resources - KVDL and counter pool - with
> their own locks. All allocations of these resources are currently
> performed under RTNL, so no locks were required.
> 
> Patches #3-#7 ensure that updates to mirroring sessions only take place
> in case there are active mirroring sessions. This allows us to avoid
> taking RTNL when it is unnecessary, as updating of the mirroring
> sessions must be performed under RTNL for the time being.
> 
> Patches #8-#10 replace the use of APIs that assume that RTNL is taken
> with their RCU counterparts. Specifically, patches #8 and #9 replace
> __in_dev_get_rtnl() with __in_dev_get_rcu() under RCU read-side critical
> section. Patch #10 replaces __dev_get_by_index() with
> dev_get_by_index_rcu().
> 
> Patches #11-#15 perform small adjustments in the code to make it easier
> to later introduce a router lock instead of relying on RTNL.

Series applied, thanks!
