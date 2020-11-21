Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE92BC269
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 23:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgKUWW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 17:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgKUWW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 17:22:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C36C0613CF;
        Sat, 21 Nov 2020 14:22:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kgbHN-0007bJ-4S; Sat, 21 Nov 2020 23:22:49 +0100
Date:   Sat, 21 Nov 2020 23:22:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        liuzx@knownsec.com, Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree@solarflare.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Patch stable] netfilter: clear skb->next in NF_HOOK_LIST()
Message-ID: <20201121222249.GU15137@breakpoint.cc>
References: <20201121034317.577081-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121034317.577081-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> NF_HOOK_LIST() uses list_del() to remove skb from the linked list,
> however, it is not sufficient as skb->next still points to other
> skb. We should just call skb_list_del_init() to clear skb->next,
> like the rest places which using skb list.
> 
> This has been fixed in upstream by commit ca58fbe06c54
> ("netfilter: add and use nf_hook_slow_list()").

Thanks Cong, agree with this change, afaics its applicable to 4.19.y and 5.4.y.

