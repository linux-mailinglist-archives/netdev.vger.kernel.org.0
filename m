Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E1922F7AC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgG0SXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:23:09 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:46683 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729205AbgG0SXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:23:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id D24DDE02;
        Mon, 27 Jul 2020 14:23:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Jul 2020 14:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Afhna7
        9fjG2N/ESpGlT1yod24pbovs9kG7jTtRp8uec=; b=pxd6lnhAQY6lq36Rw0t2Wr
        FNTj7Aqv7utLvfCSPVSKK7zYkP/Oi6k9NUUf7rFRtAgNJ4ISpkANzMes5KPdO5xP
        uQhBAs0exKeEZWKHlguK1wyxAhd7/2StnncNBaDA+r1X7J3jOA/5IUqtqukcS8Zy
        6b1F7WsC7K7Gxls+h+LpTkFCZf/cBDkEzEii5uRHhbH0he4RqOm0VhtaaNhJ0ONh
        sA1OegTDCQaheFhFJspfeBf1dkuokHpdFLa9JDtSfErlJ23gF/vUAREvveiVNSbI
        s2U0p/YcHBpouuo2EToObgfipcm60uYWCoTDshKh/Ld62ZeuhBlR0923rp/WSgug
        ==
X-ME-Sender: <xms:hhsfXw256bt5Qvmk7qwJktXsYXMYpGtJEPiP9Uh0o4S3z4J60JG_Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddukedurddvrddujeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hhsfX7GUtyQL-qzWlnNrDA6BRLNqA_sVqs6SkDPZ3OFYz2rLpuLPKA>
    <xmx:hhsfX46tTRqe9_4re0uj3hKI21pc6E5kOG5GBQ_4I2GbhCEFmzhFVQ>
    <xmx:hhsfX53ly2RhKyVXpSc-AP7Py8h3bUEfu3XyInk15A9EOdXPwhk-DQ>
    <xmx:iBsfX7VuEFOpnGbNFKVSKt3rokiDITnfnJBSqLDGQ8efu7Vwr-9kkM4RTJM>
Received: from localhost (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA5ED328005D;
        Mon, 27 Jul 2020 14:23:01 -0400 (EDT)
Date:   Mon, 27 Jul 2020 21:22:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 19/26] net/ipv6: switch ipv6_flowlabel_opt to sockptr_t
Message-ID: <20200727182259.GA1931870@shredder>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-20-hch@lst.de>
 <20200727121505.GA1804864@shredder>
 <20200727130029.GA26393@lst.de>
 <20200727133331.GA1851348@shredder>
 <20200727161555.GA7817@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727161555.GA7817@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 06:15:55PM +0200, Christoph Hellwig wrote:
> I have to admit I didn't spot the difference between the good and the
> bad output even after trying hard..
> 
> But can you try the patch below?
> 
> ---
> From cce2d2e1b43ecee5f4af7cf116808b74b330080f Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 27 Jul 2020 17:42:27 +0200
> Subject: net: remove sockptr_advance
> 
> sockptr_advance never properly worked.  Replace it with _offset variants
> of copy_from_sockptr and copy_to_sockptr.
> 
> Fixes: ba423fdaa589 ("net: add a new sockptr_t type")
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
