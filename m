Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F9E635
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfD2PYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:24:02 -0400
Received: from mail.us.es ([193.147.175.20]:35544 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbfD2PYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 11:24:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77EA11878B4
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67C89DA707
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5D419DA701; Mon, 29 Apr 2019 17:24:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0734EDA701;
        Mon, 29 Apr 2019 17:23:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 17:23:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D77934265A32;
        Mon, 29 Apr 2019 17:23:57 +0200 (CEST)
Date:   Mon, 29 Apr 2019 17:23:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter
 on flush
Message-ID: <20190429152357.kwah6tvdwax6ae7p@salvia>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
 <20190426192529.yxzpunyenmk4yfk3@salvia>
 <2dc9a105-930b-83b1-130f-891d941dc09b@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dc9a105-930b-83b1-130f-891d941dc09b@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 04:53:38PM +0200, Nicolas Dichtel wrote:
> Le 26/04/2019 à 21:25, Pablo Neira Ayuso a écrit :
> > On Thu, Apr 25, 2019 at 05:41:45PM +0200, Nicolas Dichtel wrote:
> >> Le 25/04/2019 à 12:07, Nicolas Dichtel a écrit :
> >> [snip]
> >>> In fact, the conntrack tool set by default the family to AF_INET and forbid to
> >>> set the family to something else (the '-f' option is not allowed for the command
> >>> 'flush').
> >>
> >> 'conntrack -D -f ipv6' will do the job, but this is still a regression.
> > 
> > You mean, before this patch, flush was ignoring the family, and after
> > Kristian's patch, it forces you to use NFPROTO_UNSPEC to achieve the
> > same thing, right?
> > 
> Before the patch, flush was ignoring the family, and after the patch, the flush
> takes care of the family.
> The conntrack tool has always set the family to AF_INET by default, thus, since
> this patch, only ipv4 conntracks are flushed with 'conntrack -F':
> https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2565
> https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2796

Thanks for explaining, what fix would you propose for this?
