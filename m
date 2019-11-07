Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB8F3BC2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKGWv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:51:56 -0500
Received: from correo.us.es ([193.147.175.20]:59794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfKGWvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:51:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B439420A54F
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 23:51:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2575B8007
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 23:51:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8BC15FB362; Thu,  7 Nov 2019 23:51:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D193EFB362;
        Thu,  7 Nov 2019 23:51:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 Nov 2019 23:51:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A6B974251480;
        Thu,  7 Nov 2019 23:51:47 +0100 (CET)
Date:   Thu, 7 Nov 2019 23:51:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next,RFC 0/5] Netfilter egress hook
Message-ID: <20191107225149.5t4sg35b5gwuwawa@salvia>
References: <cover.1572528496.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Oct 31, 2019 at 02:41:00PM +0100, Lukas Wunner wrote:
> Introduce a netfilter egress hook to complement the existing ingress hook.
> 
> User space support for nft is submitted in a separate patch.
> 
> The need for this arose because I had to filter egress packets which do
> not match a specific ethertype.  The most common solution appears to be
> to enslave the interface to a bridge and use ebtables, but that's
> cumbersome to configure and comes with a (small) performance penalty.
> An alternative approach is tc, but that doesn't afford equivalent
> matching options as netfilter.  A bit of googling reveals that more
> people have expressed a desire for egress filtering in the past:
> 
> https://www.spinics.net/lists/netfilter/msg50038.html
> https://unix.stackexchange.com/questions/512371
> 
> I am first performing traffic control with sch_handle_egress() before
> performing filtering with nf_egress().  That order is identical to
> ingress processing.  I'm wondering whether an inverse order would be
> more logical or more beneficial.  Among other things it would allow
> marking packets with netfilter on egress before performing traffic
> control based on that mark.  Thoughts?

Would you provide some numbers on the performance impact for this new
hook?

Thanks.
