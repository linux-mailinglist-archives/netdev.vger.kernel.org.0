Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A3147E427
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243778AbhLWNil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbhLWNil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:38:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB863C061401;
        Thu, 23 Dec 2021 05:38:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n0OIf-0007lR-Bk; Thu, 23 Dec 2021 14:38:29 +0100
Date:   Thu, 23 Dec 2021 14:38:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: fix refcount leak in
 clusterip_tg_check()
Message-ID: <20211223133829.GA5287@breakpoint.cc>
References: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Xiong <xiongx18@fudan.edu.cn> wrote:
> The issue takes place in one error path of clusterip_tg_check(). When
> memcmp() returns nonzero, the function simply returns the error code,
> forgetting to decrease the reference count of a clusterip_config
> object, which is bumped earlier by clusterip_config_find_get(). This
> may incur reference count leak.
> 
> Fix this issue by decrementing the refcount of the object in specific
> error path.

Fixes: 06aa151ad1fc74 ("netfilter: ipt_CLUSTERIP: check MAC address when duplicate config is set")

