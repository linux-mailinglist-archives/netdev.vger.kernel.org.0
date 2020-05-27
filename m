Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863B51E3E14
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgE0Jwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:52:43 -0400
Received: from correo.us.es ([193.147.175.20]:45212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgE0Jwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 05:52:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E5D6F23BB
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:52:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3096CDA707
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:52:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 26AE7DA703; Wed, 27 May 2020 11:52:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AD4BDA70F;
        Wed, 27 May 2020 11:52:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 May 2020 11:52:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ECBA542EE38F;
        Wed, 27 May 2020 11:52:35 +0200 (CEST)
Date:   Wed, 27 May 2020 11:52:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net] netfilter: conntrack: Pass value of ctinfo to
 __nf_conntrack_update
Message-ID: <20200527095235.GA399@salvia>
References: <20200527081038.3506095-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527081038.3506095-1-natechancellor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 01:10:39AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> net/netfilter/nf_conntrack_core.c:2068:21: warning: variable 'ctinfo' is
> uninitialized when used here [-Wuninitialized]
>         nf_ct_set(skb, ct, ctinfo);
>                            ^~~~~~
> net/netfilter/nf_conntrack_core.c:2024:2: note: variable 'ctinfo' is
> declared here
>         enum ip_conntrack_info ctinfo;
>         ^
> 1 warning generated.
> 
> nf_conntrack_update was split up into nf_conntrack_update and
> __nf_conntrack_update, where the assignment of ctifno is in
> nf_conntrack_update but it is used in __nf_conntrack_update.
> 
> Pass the value of ctinfo from nf_conntrack_update to
> __nf_conntrack_update so that uninitialized memory is not used
> and everything works properly.

Applied, thanks.
