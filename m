Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE59324320B
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 03:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgHMB2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 21:28:44 -0400
Received: from correo.us.es ([193.147.175.20]:57344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbgHMB2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 21:28:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59A46DA7EC
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 03:28:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AC69DA84A
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 03:28:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3C260DA792; Thu, 13 Aug 2020 03:28:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C6DEDA704;
        Thu, 13 Aug 2020 03:28:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 13 Aug 2020 03:28:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (246.pool85-48-185.static.orange.es [85.48.185.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 111A542EE38E;
        Thu, 13 Aug 2020 03:28:37 +0200 (CEST)
Date:   Thu, 13 Aug 2020 03:28:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, Peilin Ye <yepeilin.cs@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net-next v2] ipvs: Fix
 uninit-value in do_ip_vs_set_ctl()
Message-ID: <20200813012835.GA1851@salvia>
References: <20200810220703.796718-1-yepeilin.cs@gmail.com>
 <20200811074640.841693-1-yepeilin.cs@gmail.com>
 <alpine.LFD.2.23.451.2008111324570.7428@ja.home.ssi.bg>
 <20200811125956.GA31293@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811125956.GA31293@vergenet.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 02:59:59PM +0200, Simon Horman wrote:
> On Tue, Aug 11, 2020 at 01:29:04PM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Tue, 11 Aug 2020, Peilin Ye wrote:
> > 
> > > do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
> > > zero. Fix it.
> > > 
> > > Reported-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
> > > Suggested-by: Julian Anastasov <ja@ssi.bg>
> > > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > 
> > 	Looks good to me, thanks!
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Pablo, could you consider this for nf-next or should we repost when
> net-next re-opens?

No worries, it will sit in netfilter's patchwork until net-next
reopens.
