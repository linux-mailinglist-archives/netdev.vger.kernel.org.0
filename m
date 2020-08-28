Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BB6255F7D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgH1RLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:11:32 -0400
Received: from correo.us.es ([193.147.175.20]:52242 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgH1RL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 13:11:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F3FB19193E
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 19:11:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E87EE151B
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 19:11:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7D588E1511; Fri, 28 Aug 2020 19:11:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFC21DA84B;
        Fri, 28 Aug 2020 19:11:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 19:11:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8658342EF4E4;
        Fri, 28 Aug 2020 19:11:07 +0200 (CEST)
Date:   Fri, 28 Aug 2020 19:11:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Will McVicker <willmcvicker@google.com>, stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200828171107.GA32573@salvia>
References: <20200804113711.GA20988@salvia>
 <20200824193832.853621-1-willmcvicker@google.com>
 <20200824193832.853621-2-willmcvicker@google.com>
 <20200828164234.GA30990@salvia>
 <20200828164551.GG7319@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20200828164551.GG7319@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Aug 28, 2020 at 06:45:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Will,
> > 
> > Given this is for -stable maintainers only, I'd suggest:
> > 
> > 1) Specify what -stable kernel versions this patch applies to.
> >    Explain that this problem is gone since what kernel version.
> > 
> > 2) Maybe clarify that this is only for stable in the patch subject,
> >    e.g. [PATCH -stable v3] netfilter: nat: add a range check for l3/l4
> 
> Hmm, we silently accept a tuple that we can't really deal with, no?

Oh, I overlook, existing kernels are affected. You're right.

> > > +	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
> > > +		return -EOPNOTSUPP;
> 
> I vote to apply this to nf.git

I have rebased this patch on top of nf.git, attached what I'll apply
to nf.git.



--Dxnq1zWXvFF0Q93v
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-ctnetlink-add-a-range-check-for-l3-l4-prot.patch"

From 4d3426b91eba6eb28f38a2b06ee024aff861aa16 Mon Sep 17 00:00:00 2001
From: Will McVicker <willmcvicker@google.com>
Date: Mon, 24 Aug 2020 19:38:32 +0000
Subject: [PATCH] netfilter: ctnetlink: add a range check for l3/l4 protonum

The indexes to the nf_nat_l[34]protos arrays come from userspace. So
check the tuple's family, e.g. l3num, when creating the conntrack in
order to prevent an OOB memory access during setup.  Here is an example
kernel panic on 4.14.180 when userspace passes in an index greater than
NFPROTO_NUMPROTO.

Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:...
Process poc (pid: 5614, stack limit = 0x00000000a3933121)
CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
task: 000000002a3dfffe task.stack: 00000000a3933121
pc : __cfi_check_fail+0x1c/0x24
lr : __cfi_check_fail+0x1c/0x24
...
Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x468
nfnetlink_parse_nat_setup+0x234/0x258
ctnetlink_parse_nat_setup+0x4c/0x228
ctnetlink_new_conntrack+0x590/0xc40
nfnetlink_rcv_msg+0x31c/0x4d4
netlink_rcv_skb+0x100/0x184
nfnetlink_rcv+0xf4/0x180
netlink_unicast+0x360/0x770
netlink_sendmsg+0x5a0/0x6a4
___sys_sendmsg+0x314/0x46c
SyS_sendmsg+0xb4/0x108
el0_svc_naked+0x34/0x38

Fixes: c1d10adb4a521 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Will McVicker <willmcvicker@google.com>
[pablo@netfilter.org: rebased original patch on top of nf.git]
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 832eabecfbdd..d65846aa8059 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1404,7 +1404,8 @@ ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
 	if (err < 0)
 		return err;
 
-
+	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
+		return -EOPNOTSUPP;
 	tuple->src.l3num = l3num;
 
 	if (flags & CTA_FILTER_FLAG(CTA_IP_DST) ||
-- 
2.20.1


--Dxnq1zWXvFF0Q93v--
