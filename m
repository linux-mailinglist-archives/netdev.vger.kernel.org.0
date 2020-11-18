Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9401C2B83AE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgKRSRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:17:01 -0500
Received: from correo.us.es ([193.147.175.20]:38030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgKRSRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:17:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 514E1FC5F6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:16:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42281DA730
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:16:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B5F0DA78F; Wed, 18 Nov 2020 19:16:59 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 710CDDA850;
        Wed, 18 Nov 2020 19:16:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Nov 2020 19:16:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 478B742EF42A;
        Wed, 18 Nov 2020 19:16:56 +0100 (CET)
Date:   Wed, 18 Nov 2020 19:16:55 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201118181655.GA11119@salvia>
References: <20201111115025.28879-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111115025.28879-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 11, 2020 at 12:50:25PM +0100, Georg Kohmann wrote:
[...]
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index c8cf1bb..e3869ba 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -318,15 +318,43 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  	return -1;
>  }
>  
> +/* Check if the upper layer header is truncated in the first fragment. */
> +bool ipv6_frag_thdr_truncated(struct sk_buff *skb, int start, u8 *nexthdrp)

Please, follow up and send a patch to place this function in
include/net/ipv6_frag.h as static inline.

See: https://marc.info/?l=netfilter-devel&m=160571942728516&w=2
