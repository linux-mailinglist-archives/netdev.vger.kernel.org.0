Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17223CC00E
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhGQAZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:25:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45700 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGQAZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:25:41 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0725D6164C;
        Sat, 17 Jul 2021 02:22:25 +0200 (CEST)
Date:   Sat, 17 Jul 2021 02:22:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] audit: fix memory leak in nf_tables_commit
Message-ID: <20210717002243.GA27401@salvia>
References: <20210714032703.505023-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210714032703.505023-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 11:27:03AM +0800, Dongliang Mu wrote:
> In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> free the adp variable.
> 
> Fix this by adding nf_tables_commit_audit_free which frees 
> the linked list with the head node adl.
> 
> backtrace:
>   kmalloc include/linux/slab.h:591 [inline]
>   kzalloc include/linux/slab.h:721 [inline]
>   nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
>   nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
>   nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
>   sock_sendmsg_nosec net/socket.c:702 [inline]
>   sock_sendmsg+0x56/0x80 net/socket.c:722

Applied, thanks.
