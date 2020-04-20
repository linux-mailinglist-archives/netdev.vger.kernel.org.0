Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504A31B0986
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDTMjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:39:22 -0400
Received: from correo.us.es ([193.147.175.20]:54906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgDTMjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:39:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CBEEFB454
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:39:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D8EDDA736
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:39:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E97D9FA52A; Mon, 20 Apr 2020 14:39:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1315A100A44;
        Mon, 20 Apr 2020 14:39:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Apr 2020 14:39:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E99E842EF42B;
        Mon, 20 Apr 2020 14:39:15 +0200 (CEST)
Date:   Mon, 20 Apr 2020 14:39:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420123915.nrqancwjb7226l7e@salvia>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 01:28:22PM +0100, Edward Cree wrote:
> On 20/04/2020 12:52, Jiri Pirko wrote:
> > However for TC, when user specifies "HW_STATS_DISABLED", the driver
> > should not do stats.
>
> What should a driver do if the user specifies DISABLED, but the stats
>  are still needed for internal bookkeeping (e.g. to prod an ARP entry
>  that's in use for encapsulation offload, so that it doesn't get
>  expired out of the cache)?  Enable the stats on the HW anyway but
>  not report them to FLOW_CLS_STATS?  Or return an error?

My interpretation is that HW_STATS_DISABLED means that the front-end
does not care / does not need counters. The driver can still allocate
them if needed. So the enum flow_action_hw_stats flags represent what
the front-end requires.
