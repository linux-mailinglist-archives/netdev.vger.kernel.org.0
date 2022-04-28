Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09F9512B46
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242811AbiD1GMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 02:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiD1GML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 02:12:11 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8349A972EE
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:08:58 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 204683200786;
        Thu, 28 Apr 2022 02:08:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 28 Apr 2022 02:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651126134; x=
        1651212534; bh=FmGRwSTmiNe+uoRsRcb6/868ljxQoMtp3S38L8mF6dE=; b=m
        qs9hq0aRCpPJjBgirI+2xsUnvfEGk/gVnKw+IYR+8ZhD0ug5SzWgbqytNYVJiKv5
        Vafd6SftEipZpezHXFVfPNhCoFY6EFkH8RhOdW7c1/yKR8OAAhiibPuKPnK2rb2O
        5gxAExpJq0z2EjDFS057Xp5yvYOcF2/55KiGAjvtF8bi9OdsJ7eMymxTBWz2zf0a
        7ehxIKN+IjlUJUUnibl3EB/fGwFDfEP8+d9FyGwZfbFUnz71zu3ZFe7eD1WYHM8h
        RRBqDoHZ1pHREAV33JaBbSHBvmttKNbXFcxUplBxlDJ0DaxEGBDSOpQiu6sPg8Pl
        9ifMOlTCl6unqbWvboOgA==
X-ME-Sender: <xms:di9qYjcJPMf9pwUP0FPl_0DecQzaS7owQOfJ230siO35Ci-WgoohrA>
    <xme:di9qYpNygT129efF5-QnaBUhGEbGVnCSC3xpkk7VZ9mmXnbJHGN7DYcnKjz8HaxqO
    KVsCblL5Z4w3iU>
X-ME-Received: <xmr:di9qYsgy8o2XiZEWrCtvVnO7RH5X8opI11H7c_4xt7l7t8OxDeJFu31rqsLExNNO4o0rnFc2nslhNrk-kGxsOaiXihg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:di9qYk-7Ao8Ju4Yj2R0a0qO9cjfjtQKXKtocLCA4CDvPSKGJMd1ibw>
    <xmx:di9qYvt-isOCSNAKgYgxRTdz10NkgZ7WnuI4tZuGWb-LFJhDuTbqFg>
    <xmx:di9qYjEvWOo-N7dKK4ztVCjjH4cJAYW5Ybx_sq6MszTfMq_9sGh5xg>
    <xmx:di9qYpKnYKiYjp1VR9rQHhtjalluordMPEqiaVSigN_3o6BbkDscxA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Apr 2022 02:08:53 -0400 (EDT)
Date:   Thu, 28 Apr 2022 09:08:49 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] net: make sure net_rx_action() calls
 skb_defer_free_flush()
Message-ID: <YmovcRTm1l6pv93/@shredder>
References: <20220427204147.1310161-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427204147.1310161-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 01:41:47PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I missed a stray return; in net_rx_action(), which very well
> is taken whenever trigger_rx_softirq() has been called on
> a cpu that is no longer receiving network packets,
> or receiving too few of them.
> 
> Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Ido Schimmel <idosch@nvidia.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
