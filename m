Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1383835E993
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 01:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbhDMXPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhDMXPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 19:15:51 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE86BC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:15:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6865E4D254D21;
        Tue, 13 Apr 2021 16:15:28 -0700 (PDT)
Date:   Tue, 13 Apr 2021 16:15:21 -0700 (PDT)
Message-Id: <20210413.161521.2301224176572441397.davem@davemloft.net>
To:     balaevpa@infotecs.ru
Cc:     netdev@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YHWGmPmvpQAT3BcV@rnd>
References: <YHWGmPmvpQAT3BcV@rnd>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 13 Apr 2021 16:15:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Balaev Pavel <balaevpa@infotecs.ru>
Date: Tue, 13 Apr 2021 14:55:04 +0300

> @@ -222,6 +230,9 @@ struct netns_ipv4 {
>  #ifdef CONFIG_IP_ROUTE_MULTIPATH
>  	u8 sysctl_fib_multipath_use_neigh;
>  	u8 sysctl_fib_multipath_hash_policy;
> +	int sysctl_fib_multipath_hash_seed;
> +	struct multipath_seed_ctx __rcu *fib_multipath_hash_seed_ctx;
> +	spinlock_t fib_multipath_hash_seed_ctx_lock;

Maybe use the rtnl mutex instead of this custom spinlock?

Thanks.
