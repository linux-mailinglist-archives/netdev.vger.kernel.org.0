Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04EEC3CA2
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfJAQxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:53:18 -0400
Received: from correo.us.es ([193.147.175.20]:36422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfJAQnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E69411EBA1
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 18:43:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 011785257A
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 18:43:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DFCFECE39C; Tue,  1 Oct 2019 18:43:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0CDADA4CA;
        Tue,  1 Oct 2019 18:43:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Oct 2019 18:43:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AED974251480;
        Tue,  1 Oct 2019 18:43:24 +0200 (CEST)
Date:   Tue, 1 Oct 2019 18:43:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        edumazet@google.com
Subject: Re: [PATCH net] netfilter: drop bridge nf reset from nf_reset
Message-ID: <20191001164326.ifgirwawm52zcr7b@salvia>
References: <20190929185403.12116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929185403.12116-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 08:54:03PM +0200, Florian Westphal wrote:
> commit 174e23810cd31
> ("sk_buff: drop all skb extensions on free and skb scrubbing") made napi
> recycle always drop skb extensions.  The additional skb_ext_del() that is
> performed via nf_reset on napi skb recycle is not needed anymore.
> 
> Most nf_reset() calls in the stack are there so queued skb won't block
> 'rmmod nf_conntrack' indefinitely.
> 
> This removes the skb_ext_del from nf_reset, and renames it to a more
> fitting nf_reset_ct().
> 
> In a few selected places, add a call to skb_ext_reset to make sure that
> no active extensions remain.
> 
> I am submitting this for "net", because we're still early in the release
> cycle.  The patch applies to net-next too, but I think the rename causes
> needless divergence between those trees.

Applied, thanks.
