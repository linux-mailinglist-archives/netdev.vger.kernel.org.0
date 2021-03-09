Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DF2332388
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhCILB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCILBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:01:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8176C06174A;
        Tue,  9 Mar 2021 03:01:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lJa77-0005Oy-1Q; Tue, 09 Mar 2021 12:01:21 +0100
Date:   Tue, 9 Mar 2021 12:01:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: fix error return code of
 do_update_counters()
Message-ID: <20210309110121.GD10808@breakpoint.cc>
References: <20210309022854.17904-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309022854.17904-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
> When find_table_lock() returns NULL to t, no error return code of
> do_update_counters() is assigned.

Its -ENOENT.

>  	t = find_table_lock(net, name, &ret, &ebt_mutex);
                                       ^^^^^

ret is passed to find_table_lock, which passes it to
find_inlist_lock_noload() which will set *ret = -ENOENT
for NULL case.
