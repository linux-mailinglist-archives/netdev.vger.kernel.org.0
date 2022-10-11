Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5495FAECD
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiJKJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJKJAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:00:36 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F4852452
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 02:00:35 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4B2BD3200918;
        Tue, 11 Oct 2022 05:00:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 11 Oct 2022 05:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665478830; x=1665565230; bh=0IvO0UcJSJiexYy2qNtH+WkfUbkn
        7xXLWJ78GlWZfs4=; b=LcDSz+9KASF5ii4s1LO2Db3xeGeJdcpOoV32MkmD0kH7
        zN3BCD7JqQoG2SyQoLfPZCIkHAiN8ozi1/fFS2S6ozKk4NVs4pdWCWwr1GDT+/sk
        UjZuusu2LJvcjo5un/KCUtIFoiu+0IwKsL7wx1MEABf33IC3bs+o7a6s6xrJAh3m
        LKhzl9S4Ju5F45CJx2h+Tj8II8i+V0QQHYb+qJ5FsjI0/w/bSodB3GHwQIVbzU+A
        brOhrOHgXuXzm+PAEB61fB8uINfcSG0asB9KN2/RbfI5joSY2cklnR8LwE9Yl9Jj
        3AgVcVQKD5HBlDYKUmtXnZb7PEThpTzR0nK+D+vi5A==
X-ME-Sender: <xms:rDBFYyjk_44L-SbFrnMyHSD5ZuLIIviGNHySbTsto1JhRvBJCta5kA>
    <xme:rDBFYzAxxhabH7r6FzG-AUX863RVnkSktBui8rNryp2vTm20JyWISLvc5zUTysubt
    wwM7aJOv8jHFVc>
X-ME-Received: <xmr:rDBFY6FpNLK-eHR_a49pR-Ue9DF2EGjmgZw5pG3z04IdknQGMasNSbx3ZDigjA42Bhbe_cydy29bkONxFswhJVCi8CY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rDBFY7QLhzryoRdvi64GJNbll9QDMlMCVjb3UaRQlWcQOaTbmLYtbQ>
    <xmx:rDBFY_x3N17oIOVp9RPHAVaWiCXUBYQi8nTxFiQA23ZbHhCXl1byzA>
    <xmx:rDBFY54aoZh-80Z_Iw89Y0e19Z6kwaeMHsxC-Irz0mor5a-A2_bxrg>
    <xmx:rjBFY94QS5H6uQ4pihNaeiEYN1g0VQZ6brGCQhHMAUrGT9aYSzYAAw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Oct 2022 05:00:28 -0400 (EDT)
Date:   Tue, 11 Oct 2022 12:00:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Subject: Re: [PATCH ipsec] xfrm: lwtunnel: squelch kernel warning in case
 XFRM encap type is not available
Message-ID: <Y0UwqMZQ6n+G//aD@shredder>
References: <20221011080137.440419-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011080137.440419-1-eyal.birger@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 11:01:37AM +0300, Eyal Birger wrote:
> Ido reported that a kernel warning [1] can be triggered from
> user space when the kernel is compiled with CONFIG_MODULES=y and
> CONFIG_XFRM=n when adding an xfrm encap type route, e.g:
> 
> $ ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
> Error: lwt encapsulation type not supported.
> 
> The reason for the warning is that the LWT infrastructure has an
> autoloading feature which is meant only for encap types that don't
> use a net device,  which is not the case in xfrm encap.
> 
> Mute this warning for xfrm encap as there's no encap module to autoload
> in this case.

[...]

> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
