Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7A1BE729
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgD2TRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:17:13 -0400
Received: from correo.us.es ([193.147.175.20]:36322 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgD2TRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 15:17:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61791D2DA28
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:17:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54D48B7FF3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:17:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 456B0524FF; Wed, 29 Apr 2020 21:17:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FAE8DA736;
        Wed, 29 Apr 2020 21:17:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:17:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 290E042EF9E2;
        Wed, 29 Apr 2020 21:17:08 +0200 (CEST)
Date:   Wed, 29 Apr 2020 21:17:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_osf: avoid passing pointer to local var
Message-ID: <20200429191707.GA16859@salvia>
References: <20200429190051.27993-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429190051.27993-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 09:00:41PM +0200, Arnd Bergmann wrote:
> gcc-10 points out that a code path exists where a pointer to a stack
> variable may be passed back to the caller:
> 
> net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> net/netfilter/nfnetlink_osf.c:171:16: note: declared here
>   171 |  struct tcphdr _tcph;
>       |                ^~~~~
> 
> I am not sure whether this can happen in practice, but moving the
> variable declaration into the callers avoids the problem.

Applied, thanks.
