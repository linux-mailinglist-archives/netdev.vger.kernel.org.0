Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA262B93B1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgKSN3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:29:25 -0500
Received: from correo.us.es ([193.147.175.20]:56188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgKSN3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 08:29:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE50A1C41DE
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:29:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C09D3FC5E5
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:29:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B4337FC5ED; Thu, 19 Nov 2020 14:29:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 969A4DA73F;
        Thu, 19 Nov 2020 14:29:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Nov 2020 14:29:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 73EAA42EF4E0;
        Thu, 19 Nov 2020 14:29:21 +0100 (CET)
Date:   Thu, 19 Nov 2020 14:29:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: ipset: prevent uninit-value in
 hash_ip6_add
Message-ID: <20201119132921.GA21910@salvia>
References: <20201119095932.1962839-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201119095932.1962839-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 01:59:32AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found that we are not validating user input properly
> before copying 16 bytes [1].
> 
> Using NLA_BINARY in ipaddr_policy[] for IPv6 address is not correct,
> since it ensures at most 16 bytes were provided.
> 
> We should instead make sure user provided exactly 16 bytes.
> 
> In old kernels (before v4.20), fix would be to remove the NLA_BINARY,
> since NLA_POLICY_EXACT_LEN() was not yet available.

Applied, thanks.
