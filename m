Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4171539E4A1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhFGRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFGRBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:01:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A708AC061766;
        Mon,  7 Jun 2021 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/0ZaIOrjyCTF72vAgL3TDsvmLAoA/lD5LRh6UMqpICs=; b=XW4JCqV4XZvf/afuJZZ+sk5LGp
        zsghvaie1WTGsc2wubVPPN/CZ2c12b2tkuYofmYyyby0NHF33iNOoSqnMCG3m9YOVgHl6j7TEUm5D
        lvEFH/iS58Gw9gG6gyb0xFND3O6ZcaKQqCzpFAeyCc4Q2xjzcJdJxBmSCkc5bjwtUGsre8eI1Wpu+
        rG0vgqz3yIEYKiqZxOWgNX+fcOWEGB56+P9IHWr36NuYR9bBALeRkZuQTCrSJUvGCEI04JB/G1Vn8
        sJksvP9w2hwcXo7WT+uAP9OqAB4ponJyGSZUF+Qagn0qAfohAS8o9Q5hVbDVQDS+JZ6pzCq+5MGOt
        e/ny9mbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqIaG-00G2f8-Jj; Mon, 07 Jun 2021 16:58:42 +0000
Date:   Mon, 7 Jun 2021 17:58:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>
Cc:     bjorn.andersson@linaro.org, brookebasile@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ducheng2@gmail.com, ebiggers@kernel.org, fw@strlen.de,
        gregkh@linuxfoundation.org, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, skhan@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] BUG: using smp_processor_id() in preemptible code in
 radix_tree_node_alloc
Message-ID: <YL5QQE2GnJFWI4rB@casper.infradead.org>
References: <000000000000a363b205a74ca6a2@google.com>
 <000000000000b9c68205c42fcacb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b9c68205c42fcacb@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 09:47:07AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 43016d02cf6e46edfc4696452251d34bba0c0435
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon May 3 11:51:15 2021 +0000
> 
>     netfilter: arptables: use pernet ops struct during unregister

Same wrong bisection.

#syz fix: qrtr: Convert qrtr_ports from IDR to XArray
