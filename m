Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94C531A94
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 10:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfFAIkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 04:40:31 -0400
Received: from mail.us.es ([193.147.175.20]:54924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfFAIka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 04:40:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6B87C32CB
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 10:40:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A694CDA706
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 10:40:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C598DA701; Sat,  1 Jun 2019 10:40:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E15ADA705;
        Sat,  1 Jun 2019 10:40:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 10:40:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D6134265A31;
        Sat,  1 Jun 2019 10:40:26 +0200 (CEST)
Date:   Sat, 1 Jun 2019 10:40:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601084025.rheeejbn3clpgsmu@salvia>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 10:27:32AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > »       iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
> > > »       if (!iph || skb->protocol != htons(ETH_P_IP))
> > > »       »       return -EBADMSG;
> > 
> > I mean, you make this check upfront from the _eval() path, ie.
> > 
> > static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
> >                                  ...
> > {
> >         ...
> > 
> >         if (skb->protocol != htons(ETH_P_IP))
> >                 goto err;
> 
> Wouldn't it be preferable to just use nft_pf() != NFPROTO_IPV4?

Then IPv4 options extension won't work from bridge and netdev families
too, right?
