Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7E1695EF
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 06:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgBWFZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 00:25:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBWFZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 00:25:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6181141C7B60;
        Sat, 22 Feb 2020 21:25:23 -0800 (PST)
Date:   Sat, 22 Feb 2020 21:25:16 -0800 (PST)
Message-Id: <20200222.212516.1016463361000574214.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/12] mlxsw: Remove RTNL from route insertion
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Feb 2020 21:25:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 21 Feb 2020 19:54:03 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set removes RTNL from the route insertion path in mlxsw in
> order to reduce the control plane latency: the time it takes to push
> routes from user space to the kernel and mlxsw.
> 
> Up until now mlxsw did not have a lock to protect its shared router data
> structures and instead relied on RTNL. While this was simple and worked,
> it resulted in large control plane latencies as RTNL was heavily
> contended - by both the task receiving the netlink messages from user
> space and the mlxsw workqueue that programs the routes to the device.
> 
> By removing RTNL and introducing a new router mutex, this patch set
> reduces the control plane latency by ~80%. A single mutex is added as
> inside mlxsw there is not a lot of concurrency. In addition, a more
> fine-grained locking scheme is much more error-prone.
> 
> Patches #1-#6 are preparations. They add needed locking in NVE and
> multicast routing code instead of relying on RTNL
> Patch #7 introduces the new mutex
> Patches #8-#12 gradually take the lock in various entry points into the
> routing code
> Patch #13 removes RTNL in places where it is no longer required

Series applied, thanks.
