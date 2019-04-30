Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C92F8E3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfD3MbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:31:08 -0400
Received: from mail.us.es ([193.147.175.20]:49738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbfD3MbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 08:31:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BCB9111FF92
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 14:31:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC343DA720
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 14:31:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A129FDA717; Tue, 30 Apr 2019 14:31:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D924DA707;
        Tue, 30 Apr 2019 14:31:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 14:31:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 546204265A31;
        Tue, 30 Apr 2019 14:31:03 +0200 (CEST)
Date:   Tue, 30 Apr 2019 14:31:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nat: avoid unused-variable warning
Message-ID: <20190430123102.xia5kwlkqsvinqvi@salvia>
References: <20190325135336.2107801-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325135336.2107801-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 25, 2019 at 02:53:05PM +0100, Arnd Bergmann wrote:
> masq_refcnt6 was added at the start of the file, but it is
> only used in the option IPv6 section of the file, causing
> a harmless compiler warning if IPv6 is disabled:
> 
> net/netfilter/nf_nat_masquerade.c:15:21: error: 'masq_refcnt6' defined but not used [-Werror=unused-variable]
>  static unsigned int masq_refcnt6 __read_mostly;
> 
> Move the variable next to the user to avoid that warning.
> 
> Fixes: 46f7487e161b ("netfilter: nat: don't register device notifier twice")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ----
> This is an older patch stack, for some reason I seem to have never
> sent it, and I can't find any indication of anyone else sending
> a similar fix, so sending this out now.
> 
> If it's already fixed upstream, please ignore.

Yes, Florian fixed this in nf-next.
