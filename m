Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E08134F69
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 23:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgAHWcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 17:32:20 -0500
Received: from correo.us.es ([193.147.175.20]:55662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgAHWcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 17:32:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D22D7C514A
        for <netdev@vger.kernel.org>; Wed,  8 Jan 2020 23:32:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5DAADA712
        for <netdev@vger.kernel.org>; Wed,  8 Jan 2020 23:32:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7978DA707; Wed,  8 Jan 2020 23:32:16 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A888ADA705;
        Wed,  8 Jan 2020 23:32:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jan 2020 23:32:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 89BBF426CCB9;
        Wed,  8 Jan 2020 23:32:14 +0100 (CET)
Date:   Wed, 8 Jan 2020 23:32:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: conntrack: dccp, sctp: handle null timeout
 argument
Message-ID: <20200108223214.3niyo2o2sr2zf3fg@salvia>
References: <0000000000009cd5e0059b7eb836@google.com>
 <20200106223417.18279-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106223417.18279-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 11:34:17PM +0100, Florian Westphal wrote:
> The timeout pointer can be NULL which means we should modify the
> per-nets timeout instead.
> 
> All do this, except sctp and dccp which instead give:
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> net/netfilter/nf_conntrack_proto_dccp.c:682
>  ctnl_timeout_parse_policy+0x150/0x1d0 net/netfilter/nfnetlink_cttimeout.c:67
>  cttimeout_default_set+0x150/0x1c0 net/netfilter/nfnetlink_cttimeout.c:368
>  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477

Applied, thanks Florian.
