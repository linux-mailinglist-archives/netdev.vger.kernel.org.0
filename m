Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7E34B9333
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiBPVbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:31:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiBPVbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:31:21 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B669D28198F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 13:31:07 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5DF365C01CA;
        Wed, 16 Feb 2022 16:31:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Feb 2022 16:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qojOt21fDm+knJ5N1
        xYySQePh/c5fbyV1uxzbGuUpU0=; b=WYt+kvcWECC2jz4BclXYELVwCvDB6Nb6m
        at9Wl+u50rPcwiqUROcYRDOwc+hGVb7NmgSCr3IAtBVGbNWw91BS7uDHgmT2wU/T
        ak0jb5h+TytLV5E/kZEp2HIV7hLd4hnWVyeJpmViZUQkAwD31yYGXJx7hE9U/IFI
        rseLvDm1fyWiCgQdjoRJk0ci8/ukrn8CXcfwSroTNfNk8bHa24+skLhNV7IZFHhI
        2kj2x/AxGPum3tbv+jB6eN8KbxZLaY4qxLkYAq1tCIosUkl1221qrl4vdijbE8Lf
        BZKVJ8hIEY5aiYi3LLpvlw3JqG7iAARJzNSAd0CjnKn4lvd1UP30w==
X-ME-Sender: <xms:GG0NYvV63zafBjs0OV-jXwpQ_HF9acpiHzzFHvHh1k4c3SKaZv1_lg>
    <xme:GG0NYnmUcT1GUHdQ3vEHl7m2uVtLe6AVAn_S-hGGa41vHIzcVjUdDuqUCaVmRwkC8
    a84r-Uu_35FkhM>
X-ME-Received: <xmr:GG0NYrZFrfls8_L-R1KrUEosXLlRsCBzJZYbFmznWinKUaOBnDOio7rwpMWwBs2Xtl7FoKQ3MZ5TIAt0SNCEKBiCMAE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeeigddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GG0NYqWeE1jqeE_n8zXXrpnEvZo-DYRYbz9w6T0lBkr9R4UMk6UmhA>
    <xmx:GG0NYpmOQrM0eblUV0ojHRgRN7ume0iMwJ7XWJuG5F0mLbww9_HC6w>
    <xmx:GG0NYnfJZsNCP8XOHCTRJOnrR7GZe_Rbv-pcoNIxRB_hN0MCx3AvTA>
    <xmx:GW0NYiCnoHqKdfk1YYhRQSbj6pSaL2qpchymicASbQ4a3J1Snc7mrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Feb 2022 16:31:03 -0500 (EST)
Date:   Wed, 16 Feb 2022 23:30:59 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net 1/2] ipv4: fix data races in fib_alias_hw_flags_set
Message-ID: <Yg1tExg4IGAKm7Bq@shredder>
References: <20220216173217.3792411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216173217.3792411-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 09:32:16AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> fib_alias_hw_flags_set() can be used by concurrent threads,
> and is only RCU protected.
> 
> We need to annotate accesses to following fields of struct fib_alias:
> 
>     offload, trap, offload_failed
> 
> Because of READ_ONCE()WRITE_ONCE() limitations, make these
> field u8.

[...]

> Fixes: 90b93f1b31f8 ("ipv4: Add "offload" and "trap" indications to routes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks, this is better than taking RTNL

> ---
>  net/ipv4/fib_lookup.h    |  7 +++----
>  net/ipv4/fib_semantics.c |  6 +++---
>  net/ipv4/fib_trie.c      | 22 +++++++++++++---------
>  net/ipv4/route.c         |  4 ++--
>  4 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
> index e184bcb1994343c00914e09ab728ae16c4d23dc8..78e40ea42e58d930b3439d497de2b9e15fe45706 100644
> --- a/net/ipv4/fib_lookup.h
> +++ b/net/ipv4/fib_lookup.h
> @@ -16,10 +16,9 @@ struct fib_alias {
>  	u8			fa_slen;
>  	u32			tb_id;
>  	s16			fa_default;
> -	u8			offload:1,
> -				trap:1,
> -				offload_failed:1,
> -				unused:5;
> +	u8			offload;
> +	u8			trap;
> +	u8			offload_failed;

There is a 5 bytes hole here, so this shouldn't increase the struct and
it should still fit in one cache line

>  	struct rcu_head		rcu;
>  };
