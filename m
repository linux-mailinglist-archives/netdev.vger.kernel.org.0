Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B53A14A091
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgA0JS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:18:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgA0JS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:18:57 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A527B14EB19FA;
        Mon, 27 Jan 2020 01:18:55 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:18:53 +0100 (CET)
Message-Id: <20200127.101853.1471544937358444588.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127082054.318263-1-pablo@netfilter.org>
References: <20200127082054.318263-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:18:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 27 Jan 2020 09:20:48 +0100

> This batch contains Netfilter updates for net-next:
> 
> 1) Add nft_setelem_parse_key() helper function.
> 
> 2) Add NFTA_SET_ELEM_KEY_END to specify a range with one single element.
> 
> 3) Add NFTA_SET_DESC_CONCAT to describe the set element concatenation,
>    from Stefano Brivio.
> 
> 4) Add bitmap_cut() to copy n-bits from source to destination,
>    from Stefano Brivio.
> 
> 5) Add set to match on arbitrary concatenations, from Stefano Brivio.
> 
> 6) Add selftest for this new set type. An extract of Stefano's
>    description follows:
> 
> "Existing nftables set implementations allow matching entries with
> interval expressions (rbtree), e.g. 192.0.2.1-192.0.2.4, entries
> specifying field concatenation (hash, rhash), e.g. 192.0.2.1:22,
> but not both.
> 
> In other words, none of the set types allows matching on range
> expressions for more than one packet field at a time, such as ipset
> does with types bitmap:ip,mac, and, to a more limited extent
> (netmasks, not arbitrary ranges), with types hash:net,net,
> hash:net,port, hash:ip,port,net, and hash:net,port,net.
> 
> As a pure hash-based approach is unsuitable for matching on ranges,
> and "proxying" the existing red-black tree type looks impractical as
> elements would need to be shared and managed across all employed
> trees, this new set implementation intends to fill the functionality
> gap by employing a relatively novel approach.
> 
> The fundamental idea, illustrated in deeper detail in patch 5/9, is to
> use lookup tables classifying a small number of grouped bits from each
> field, and map the lookup results in a way that yields a verdict for
> the full set of specified fields.
> 
> The grouping bit aspect is loosely inspired by the Grouper algorithm,
> by Jay Ligatti, Josh Kuhn, and Chris Gage (see patch 5/9 for the full
> reference).
> 
> A reference, stand-alone implementation of the algorithm itself is
> available at:
>         https://pipapo.lameexcu.se
> 
> Some notes about possible future optimisations are also mentioned
> there. This algorithm reduces the matching problem to, essentially,
> a repetitive sequence of simple bitwise operations, and is
> particularly suitable to be optimised by leveraging SIMD instruction
> sets."
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
