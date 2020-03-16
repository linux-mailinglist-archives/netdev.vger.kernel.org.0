Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE3C1866DA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgCPIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:46:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730118AbgCPIqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:46:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B41F81444BB54;
        Mon, 16 Mar 2020 01:46:24 -0700 (PDT)
Date:   Mon, 16 Mar 2020 01:46:24 -0700 (PDT)
Message-Id: <20200316.014624.288746110703466576.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] hsr: fix several bugs in generic netlink
 callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313064952.32075-1-ap420073@gmail.com>
References: <20200313064952.32075-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 01:46:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 13 Mar 2020 06:49:52 +0000

> This patchset is to fix several bugs they are related in
> generic netlink callback in hsr module.
> 
> 1. The first patch is to add missing rcu_read_lock() in
> hsr_get_node_{list/status}().
> The hsr_get_node_{list/status}() are not protected by RTNL because
> they are callback functions of generic netlink.
> But it calls __dev_get_by_index() without acquiring RTNL.
> So, it would use unsafe data.
> 
> 2. The second patch is to avoid failure of hsr_get_node_list().
> hsr_get_node_list() is a callback of generic netlink and
> it is used to get node information in userspace.
> But, if there are so many nodes, it fails because of buffer size.
> So, in this patch, restart routine is added.
> 
> 3. The third patch is to set .netnsok flag to true.
> If .netnsok flag is false, non-init_net namespace is not allowed to
> operate generic netlink operations.
> So, currently, non-init_net namespace has no way to get node information
> because .netnsok is false in the current hsr code.
> 
> Change log:
> v1->v2:
>  - Preserve reverse christmas tree variable ordering in the second patch.

Series applied, thank you.
