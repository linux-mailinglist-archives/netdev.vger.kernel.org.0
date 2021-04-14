Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA0935EEBC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349784AbhDNHr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:47:58 -0400
Received: from void.so ([95.85.17.176]:58582 "EHLO void.so"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349778AbhDNHr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 03:47:57 -0400
Received: from void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTP id 58CA01C2AB6;
        Wed, 14 Apr 2021 10:47:34 +0300 (MSK)
Received: from void.so ([127.0.0.1])
        by void.so (void.so [127.0.0.1]) (amavisd-new, port 10024) with LMTP
        id V6iT49-b6IoV; Wed, 14 Apr 2021 10:47:34 +0300 (MSK)
Received: from rnd (unknown [91.244.183.205])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by void.so (Postfix) with ESMTPSA id 8B3151C2A8F;
        Wed, 14 Apr 2021 10:47:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=void.so; s=mail;
        t=1618386453; bh=cb4VP6AyHKNHm5F0FH5eV4QTaogSJPtMI+591cS63HI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=HTodRisbvIoYIDTFhx9oFB+ocnQQs6z1vTBWvidc25AoqKuBsSu3ZTMIyR79+6zyY
         /ddCgVvLJjTL2jWf12jZSnqqXIVTCslngPma6AeazS73yY44ffcLpycJnwjgvvKpL1
         6PYybcRm+kV17/PtutmbEhSATrlgKj96CEtFDrZk=
Date:   Wed, 14 Apr 2021 10:45:47 +0300
From:   Pavel Balaev <mail@void.so>
To:     netdev@vger.kernel.org
Cc:     christophe.jaillet@wanadoo.fr, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
Message-ID: <YHadq3m1bBWrPQn7@rnd>
References: <YHWGmPmvpQAT3BcV@rnd>
 <20210413.161521.2301224176572441397.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413.161521.2301224176572441397.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 04:15:21PM -0700, David Miller wrote:
> From: Balaev Pavel <balaevpa@infotecs.ru>
> Date: Tue, 13 Apr 2021 14:55:04 +0300
> 
> > @@ -222,6 +230,9 @@ struct netns_ipv4 {
> >  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> >  	u8 sysctl_fib_multipath_use_neigh;
> >  	u8 sysctl_fib_multipath_hash_policy;
> > +	int sysctl_fib_multipath_hash_seed;
> > +	struct multipath_seed_ctx __rcu *fib_multipath_hash_seed_ctx;
> > +	spinlock_t fib_multipath_hash_seed_ctx_lock;
> 
> Maybe use the rtnl mutex instead of this custom spinlock?
> 
> Thanks.
Thanks for advise, I will use it in next patch version.
