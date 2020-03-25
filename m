Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5157F193459
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCYXN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:13:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34496 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727395AbgCYXN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:13:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jHFDa-00053N-5c; Thu, 26 Mar 2020 00:13:51 +0100
Date:   Thu, 26 Mar 2020 00:13:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Qian Cai <cai@lca.pw>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter/nf_tables: silence a RCU-list warning
Message-ID: <20200325231350.GC878@breakpoint.cc>
References: <20200325143142.6955-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325143142.6955-1-cai@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qian Cai <cai@lca.pw> wrote:
> It is safe to traverse &net->nft.tables with &net->nft.commit_mutex
> held using list_for_each_entry_rcu(). Silence the PROVE_RCU_LIST false
> positive,

[..]

> -	list_for_each_entry_rcu(table, &net->nft.tables, list) {
> +	list_for_each_entry_rcu(table, &net->nft.tables, list,
> +				lockdep_is_held(&net->nft.commit_mutex)) {

Thanks for the patch.

Acked-by: Florian Westphal <fw@strlen.de>
