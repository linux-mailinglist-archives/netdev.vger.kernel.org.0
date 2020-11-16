Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736372B54A9
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgKPW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:57:04 -0500
Received: from correo.us.es ([193.147.175.20]:55934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgKPW5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:57:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8393BE2C59
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:57:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75E7EFC5E3
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:57:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B64DDA73D; Mon, 16 Nov 2020 23:57:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 503F8DA722;
        Mon, 16 Nov 2020 23:56:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 23:56:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 32D9B4265A5A;
        Mon, 16 Nov 2020 23:56:59 +0100 (CET)
Date:   Mon, 16 Nov 2020 23:56:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116225658.GA7247@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114115906.GA21025@salvia>
 <87sg9cjaxo.fsf@waldekranz.com>
 <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116221815.GA6682@salvia>
 <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116223615.GA6967@salvia>
 <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 02:45:21PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 23:36:15 +0100 Pablo Neira Ayuso wrote:
> > > Are you saying A -> B traffic won't match so it will update the cache,
> > > since conntrack flows are bi-directional?  
> > 
> > Yes, Traffic for A -> B won't match the flowtable entry, this will
> > update the cache.
> 
> That's assuming there will be A -> B traffic without B sending a
> request which reaches A, first.

B might send packets to A but this will not get anywhere. Assuming
TCP, this will trigger retransmissions so B -> A will kick in to
refresh the entry.

Is this scenario that you describe a showstopper?

Thank you.
