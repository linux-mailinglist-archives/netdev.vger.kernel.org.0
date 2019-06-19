Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCA94BD7A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfFSQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:04:29 -0400
Received: from mail.us.es ([193.147.175.20]:34050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfFSQE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:04:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DBFAF2694
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 18:04:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F285DA707
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 18:04:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 622F9DA70F; Wed, 19 Jun 2019 18:04:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07631DA70E;
        Wed, 19 Jun 2019 18:04:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 18:04:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D1B614265A2F;
        Wed, 19 Jun 2019 18:04:22 +0200 (CEST)
Date:   Wed, 19 Jun 2019 18:04:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: synproxy: fix nf_synproxy_ipv{4,6}_init()
 return code
Message-ID: <20190619160422.t33ckepbusdtfjzq@salvia>
References: <20190619125314.1005993-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619125314.1005993-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 02:53:07PM +0200, Arnd Bergmann wrote:
> We return an uninitialized variable on success:
> 
> net/netfilter/nf_synproxy_core.c:793:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (snet->hook_ref4 == 0) {
>             ^~~~~~~~~~~~~~~~~~~~
> 
> Initialize the return code to zero first.

Thanks Arnd. We got a fix for this:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=72c5e11854afb842e157353be0291d65b91725f5
