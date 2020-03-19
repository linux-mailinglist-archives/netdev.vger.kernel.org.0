Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DE418C083
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgCSThl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:37:41 -0400
Received: from correo.us.es ([193.147.175.20]:35440 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbgCSThl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 15:37:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1830EBAD2
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 20:37:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3293FEFB3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 20:37:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8C18FEFA9; Thu, 19 Mar 2020 20:37:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E7B0FEFAE;
        Thu, 19 Mar 2020 20:37:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 20:37:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5C5BE42EFB80;
        Thu, 19 Mar 2020 20:37:06 +0100 (CET)
Date:   Thu, 19 Mar 2020 20:37:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ozsh@mellanox.com, majd@mellanox.com,
        saeedm@mellanox.com
Subject: Re: [PATCH net-next 6/6] netfilter: nf_flow_table: hardware offload
 support
Message-ID: <20200319193736.zzbrb6ktfmqatkon@salvia>
References: <20191111232956.24898-1-pablo@netfilter.org>
 <20191111232956.24898-7-pablo@netfilter.org>
 <64004716-fdbe-9542-2484-8a1691d54e53@solarflare.com>
 <87cc5180-4e84-753f-0acf-1c7a0fa8549d@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cc5180-4e84-753f-0acf-1c7a0fa8549d@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 06:47:07PM +0200, Paul Blakey wrote:
> 
> On 19/03/2020 17:57, Edward Cree wrote:
[...]
> > <snip>
> >> +static int nf_flow_rule_match(struct nf_flow_match *match,
> >> +			      const struct flow_offload_tuple *tuple)
> >> +{
> >> +	struct nf_flow_key *mask = &match->mask;
> >> +	struct nf_flow_key *key = &match->key;
> >> +
> >> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
> >> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
> >> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
> >> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
> >> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
> >> +
> >> +	switch (tuple->l3proto) {
> >> +	case AF_INET:
> >> +		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> >>
> > Is it intentional that mask->control.addr_type never gets set?
>
> It should be set.

I'd be glad to take a patch for this into nf.git

Thanks.
