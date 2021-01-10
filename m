Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EF72F0607
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAJIk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:40:27 -0500
Received: from correo.us.es ([193.147.175.20]:38884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbhAJIk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:40:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51E1ED2AE3
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:39:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45167DA78D
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:39:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3AAACDA78A; Sun, 10 Jan 2021 09:39:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0ABEBDA72F;
        Sun, 10 Jan 2021 09:39:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 10 Jan 2021 09:39:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DF272426CC84;
        Sun, 10 Jan 2021 09:39:00 +0100 (CET)
Date:   Sun, 10 Jan 2021 09:39:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: fix reading
 nf_conntrack_buckets
Message-ID: <20210110083942.GA28800@salvia>
References: <161010627346.3858336.14321264288771872662.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161010627346.3858336.14321264288771872662.stgit@firesoul>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 12:44:33PM +0100, Jesper Dangaard Brouer wrote:
> The old way of changing the conntrack hashsize runtime was through changing
> the module param via file /sys/module/nf_conntrack/parameters/hashsize. This
> was extended to sysctl change in commit 3183ab8997a4 ("netfilter: conntrack:
> allow increasing bucket size via sysctl too").
> 
> The commit introduced second "user" variable nf_conntrack_htable_size_user
> which shadow actual variable nf_conntrack_htable_size. When hashsize is
> changed via module param this "user" variable isn't updated. This results in
> sysctl net/netfilter/nf_conntrack_buckets shows the wrong value when users
> update via the old way.
> 
> This patch fix the issue by always updating "user" variable when reading the
> proc file. This will take care of changes to the actual variable without
> sysctl need to be aware.

Applied, thanks.
