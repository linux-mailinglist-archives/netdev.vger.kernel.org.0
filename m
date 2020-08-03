Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49E723A2C3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 12:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHCKdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 06:33:47 -0400
Received: from correo.us.es ([193.147.175.20]:36018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCKdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 06:33:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF6A29A92D
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 12:33:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF13CDA859
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 12:33:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4BFEDA73F; Mon,  3 Aug 2020 12:33:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6FBCDA84F;
        Mon,  3 Aug 2020 12:33:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Aug 2020 12:33:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 285964265A32;
        Mon,  3 Aug 2020 12:33:41 +0200 (CEST)
Date:   Mon, 3 Aug 2020 12:33:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net v2 0/2] netfilter: conntrack: Fix CT offload timeout
 on heavily loaded systems
Message-ID: <20200803103339.GA2903@salvia>
References: <20200803073305.702079-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803073305.702079-1-roid@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 10:33:03AM +0300, Roi Dayan wrote:
> On heavily loaded systems the GC can take time to go over all existing
> conns and reset their timeout. At that time other calls like from
> nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
> expired. To fix this when we set the offload bit we should also reset
> the timeout instead of counting on GC to finish first iteration over
> all conns before the initial timeout.
> 
> First commit is to expose the function that updates the timeout.
> Second commit is to use it from flow_offload_add().

Series applied to nf.git, thanks.
