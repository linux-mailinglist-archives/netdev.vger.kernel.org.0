Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C70632AA8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiKURR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiKURRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:17:12 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7EFD5399;
        Mon, 21 Nov 2022 09:15:17 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6552420199;
        Mon, 21 Nov 2022 18:15:15 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b8o36EmnEO1I; Mon, 21 Nov 2022 18:15:14 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 73080200BB;
        Mon, 21 Nov 2022 18:15:14 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 641EB80004A;
        Mon, 21 Nov 2022 18:15:14 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 18:15:14 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 18:15:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 71E4531829DB; Mon, 21 Nov 2022 18:15:13 +0100 (CET)
Date:   Mon, 21 Nov 2022 18:15:13 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     syzbot <syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <sfr@canb.auug.org.au>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] linux-next test error: general protection fault in
 xfrm_policy_lookup_bytype
Message-ID: <20221121171513.GB704954@gauss3.secunet.de>
References: <000000000000706e6f05edfb4ce0@google.com>
 <Y3uULqIZ31at0aIX@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3uULqIZ31at0aIX@hog>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:07:26PM +0100, Sabrina Dubroca wrote:
> 2022-11-21, 05:47:38 -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    e4cd8d3ff7f9 Add linux-next specific files for 20221121
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1472370d880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a0ebedc6917bacc1
> > dashboard link: https://syzkaller.appspot.com/bug?extid=bfb2bee01b9c01fff864
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/b59eb967701d/disk-e4cd8d3f.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/37a7b43e6e84/vmlinux-e4cd8d3f.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/ebfb0438e6a2/bzImage-e4cd8d3f.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com
> > 
> > general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
> > CPU: 0 PID: 5295 Comm: kworker/0:3 Not tainted 6.1.0-rc5-next-20221121-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > Workqueue: ipv6_addrconf addrconf_dad_work
> > RIP: 0010:xfrm_policy_lookup_bytype.cold+0x1c/0x54 net/xfrm/xfrm_policy.c:2139
> 
> That's the printk at the end of the function, when
> xfrm_policy_lookup_bytype returns NULL. It seems to have snuck into
> commit c39f95aaf6d1 ("xfrm: Fix oops in __xfrm_state_delete()"), we
> can just remove it:
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 3a203c59a11b..e392d8d05e0c 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -2135,9 +2135,6 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
>  fail:
>  	rcu_read_unlock();
>  
> -	if (!IS_ERR(ret))
> -		printk("xfrm_policy_lookup_bytype: policy if_id %d, wanted if_id  %d\n", ret->if_id, if_id);
> -
>  	return ret;

Hm, this was not in the original patch. Maybe my tree was not
clean when I applied it. Do you want to send a patch, or should
I just remove it?
