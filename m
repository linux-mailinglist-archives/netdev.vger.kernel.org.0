Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC606522CD7
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiEKHHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242598AbiEKHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:07:18 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF63CAD10E
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:07:11 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CF87A320085B;
        Wed, 11 May 2022 03:07:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 11 May 2022 03:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652252827; x=
        1652339227; bh=PWvf3FpP2Tmo1HXBWNxhMeP9Bf3FAnCIKJRU4sW6lkc=; b=Q
        QbUJ/BLKbyp/2tIoGkJKoPVz2l9mNjqNOQ56MOtQ4lI3WBIqCanJ1+EOf8Ph5nzt
        JgEYQm3PjILbV3zmwXY2tKyPmCSArU2oXj363yr8nR3FmMDhaHfVd0Yts/k5hCn5
        mwU/pCFtNDz5CCxtGUTD4FEY1PXCgn84j8IehXFijrVdtTes8QICCWcOzMxrofQS
        2fb/cKAucxAvpI1UphxGi/1WAYzQFvez+M0+rb5dmdTcAzBEgWgyXRBPODqOhAQW
        GPs7OXs+vYB9AQ5z+rvoaiexRn7KJ0oqpMcDaSnLD5PbXMSc+wA9VVWUz7jarbof
        YHtB0S7ZNjUVJKZYs43Bg==
X-ME-Sender: <xms:m2B7YrYfT3V9vQ-f8U8t31H25xuvfnAnVnK5M8TGxPhpfwm1NXzHtQ>
    <xme:m2B7YqYg7GBRsSwAD__olP32K2kRaM_pm6WCGH2hD1ZI4s8b3tgdxf4Rho7FwKH10
    CrP5LunGL6DsdM>
X-ME-Received: <xmr:m2B7Yt9iR27XnXGmuPifK8eZPjahZx49-dnrY0mpX_HNv6iY39KbO7puqqeb1JMdsp6EyljYLwGKsoY_bKhYlnpRKrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:m2B7YhrfsOPXwTnyqURdf0mMN6a4vxyazMZrGKNllqeyaFcjocHLoQ>
    <xmx:m2B7Ymoe_E7gJPHr_ZtC-9MmOkQdB2mZXZabuwHLX4BzkhZBtPEhQg>
    <xmx:m2B7YnTLSpvZ9Kpx1exeRnDErq0faErHfPiL75N45EjUvu-toXhXug>
    <xmx:m2B7YjBFZ8GaedUS8rUuFzDcTCeVkkpb_w353I8GQRzJEi4Pf0-P3A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 May 2022 03:07:06 -0400 (EDT)
Date:   Wed, 11 May 2022 10:07:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: tc_actions: allow mirred
 egress test to run on non-offloaded h2
Message-ID: <Yntgln3mRvtjlDMB@shredder>
References: <20220510220904.284552-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510220904.284552-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 01:09:04AM +0300, Vladimir Oltean wrote:
> The host interfaces $h1 and $h2 don't have to be switchdev interfaces,
> but due to the fact that we pass $tcflags which may have the value of
> "skip_sw", we force $h2 to offload a drop rule for dst_ip, something
> which it may not be able to do.
> 
> The selftest only wants to verify the hit count of this rule as a means
> of figuring out whether the packet was received, so remove the $tcflags
> for it and let it be done in software.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
