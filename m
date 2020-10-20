Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8FF293F74
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408665AbgJTPVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:21:40 -0400
Received: from correo.us.es ([193.147.175.20]:51614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408659AbgJTPVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:21:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 653FC1761AC
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:21:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56ABBE151C
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:21:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4BF3CE1506; Tue, 20 Oct 2020 17:21:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37CC2F7327;
        Tue, 20 Oct 2020 17:21:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:21:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 123654301DE0;
        Tue, 20 Oct 2020 17:21:36 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:21:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, fw@strlen.org,
        kadlec@netfilter.org
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201020152135.GA19913@salvia>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:32:52PM -0700, Francesco Ruggeri wrote:
> If the first packet conntrack sees after a re-register is an outgoing
> keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to
> SND.NXT-1.
> When the peer correctly acknowledges SND.NXT, tcp_in_window fails
> check III (Upper bound for valid (s)ack: sack <= receiver.td_end) and
> returns false, which cascades into nf_conntrack_in setting
> skb->_nfct = 0 and in later conntrack iptables rules not matching.
> In cases where iptables are dropping packets that do not match
> conntrack rules this can result in idle tcp connections to time out.

Applied, thanks.
