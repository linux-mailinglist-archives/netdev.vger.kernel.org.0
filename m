Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5163F4C06C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfFSSA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:00:29 -0400
Received: from mail.us.es ([193.147.175.20]:45104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfFSSA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 14:00:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62C01C1B28
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:00:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 516DDDA709
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:00:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 46F85DA710; Wed, 19 Jun 2019 20:00:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4207DDA701;
        Wed, 19 Jun 2019 20:00:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 20:00:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1845A4265A5B;
        Wed, 19 Jun 2019 20:00:25 +0200 (CEST)
Date:   Wed, 19 Jun 2019 20:00:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190619180024.gzqhe3nrzpxngojy@salvia>
References: <20190611120912.3825-1-ssuryaextr@gmail.com>
 <20190619171832.om7losybbkysuk4r@salvia>
 <20190619175801.GA3859@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619175801.GA3859@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 01:58:02PM -0400, Stephen Suryaputra wrote:
> On Wed, Jun 19, 2019 at 07:18:32PM +0200, Pablo Neira Ayuso wrote:
> > 
> > Rules with this options will load fine:
> > 
> > ip option eol type 1
> > ip option noop type 1
> > ip option sec type 1
> > ip option timestamp type 1
> > ip option rr type 1
> > ip option sid type 1
> > 
> > However, they will not ever match I think.
> > 
> > found is set to true, but target is set to EOPNOTSUPP, then...
> > 
> > [...]
> > > +	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
> > 
> > ... ipv4_find_option() returns -EOPNOTSUPP which says header does
> > not exist.
> > 
> Yes. My goal in writing this is mainly to block loose and/or strict
> source routing. The system also will need to block RA and RR. Others are
> not fully supported since we (my employer) don't need it. They can be
> added later on if desired...

OK, that's fine. Then I'd suggest you remove support from eol, noop,
sec, timestamp and sid from the userspace patches.

Thanks!
