Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34432B7B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfFCJHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:07:33 -0400
Received: from mail.us.es ([193.147.175.20]:38876 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfFCJHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98D52EDB0B
        for <netdev@vger.kernel.org>; Mon,  3 Jun 2019 11:07:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CB1EDA718
        for <netdev@vger.kernel.org>; Mon,  3 Jun 2019 11:07:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 825A2DA712; Mon,  3 Jun 2019 11:07:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B6ECDA70E;
        Mon,  3 Jun 2019 11:07:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Jun 2019 11:07:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 22D1F40705C3;
        Mon,  3 Jun 2019 11:07:28 +0200 (CEST)
Date:   Mon, 3 Jun 2019 11:07:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: fix use-after-free in kfree_skb_list
Message-ID: <20190603090727.g2cxedtuwe2hhvjl@salvia>
References: <20190602182418.117629-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602182418.117629-1-edumazet@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 11:24:18AM -0700, Eric Dumazet wrote:
> syzbot reported nasty use-after-free [1]
> 
> Lets remove frag_list field from structs ip_fraglist_iter
> and ip6_fraglist_iter. This seens not needed anyway.
> 
> [1] :
> BUG: KASAN: use-after-free in kfree_skb_list+0x5d/0x60 net/core/skbuff.c:706
> Read of size 8 at addr ffff888085a3cbc0 by task syz-executor303/8947
[...]
> 
> Memory state around the buggy address:
>  ffff888085a3ca80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888085a3cb00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> >ffff888085a3cb80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>                                            ^
>  ffff888085a3cc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888085a3cc80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
> 
> Fixes: 0feca6190f88 ("net: ipv6: add skbuff fraglist splitter")
> Fixes: c8b17be0b7a4 ("net: ipv4: add skbuff fraglist splitter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
