Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4510141D9E9
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbhI3MhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350909AbhI3MhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:37:16 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDCC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:35:33 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 922934FD3DF3B;
        Thu, 30 Sep 2021 05:35:27 -0700 (PDT)
Date:   Thu, 30 Sep 2021 13:35:22 +0100 (BST)
Message-Id: <20210930.133522.917842602540469933.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/5] netfilter: nf_tables: add position handle in
 event notification
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210929230500.811946-1-pablo@netfilter.org>
        <20210929230500.811946-3-pablo@netfilter.org>
        <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 30 Sep 2021 05:35:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 29 Sep 2021 19:19:53 -0700

> On Thu, 30 Sep 2021 01:04:57 +0200 Pablo Neira Ayuso wrote:
>> Add position handle to allow to identify the rule location from netlink
>> events. Otherwise, userspace cannot incrementally update a userspace
>> cache through monitoring events.
>> 
>> Skip handle dump if the rule has been either inserted (at the beginning
>> of the ruleset) or appended (at the end of the ruleset), the
>> NLM_F_APPEND netlink flag is sufficient in these two cases.
>> 
>> Handle NLM_F_REPLACE as NLM_F_APPEND since the rule replacement
>> expansion appends it after the specified rule handle.
>> 
>> Fixes: 96518518cc41 ("netfilter: add nftables")
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Let me defer to Dave on this one. Krzysztof K recently provided us with
> this quote:
> 
> "One thing that does bother [Linus] is developers who send him fixes in the
> -rc2 or -rc3 time frame for things that never worked in the first place.
> If something never worked, then the fact that it doesn't work now is not
> a regression, so the fixes should just wait for the next merge window.
> Those fixes are, after all, essentially development work."
> 
> 	https://lwn.net/Articles/705245/
> 
> Maybe the thinking has evolved since, but this patch strikes me as odd.
> We forgot to put an attribute in netlink 8 years ago, and suddenly it's
> urgent to fill it in?  Something does not connect for me, certainly the
> commit message should have explained things better...

Agreed.
