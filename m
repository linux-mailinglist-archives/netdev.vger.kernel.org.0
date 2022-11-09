Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD71262252E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 09:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKIIR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 03:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiKIIR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:17:58 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8141BE81
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:17:57 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A49765C00D5;
        Wed,  9 Nov 2022 03:17:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 09 Nov 2022 03:17:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667981874; x=1668068274; bh=+LMneKv5k+OvBcSGWMWI6zNezFuN
        JguV2eEB7JZE7d0=; b=AVHwPJaJy+8als89XN/yVvV1/u1LMFKAajYrEytXN2TZ
        ABLrgCwT/ovG8U3hLbUPY3O0+oPGycmD4n6s2MykKtH6YFeBRJaZpobj61g5Ynii
        rVmMp7IJHsI0I2dVHrph+tFIJ8xTfJL36Bqr2Kch+DP1HDfT/SK6FH6XLuld7hO+
        Xrkb8rxQo7AK9yh+/+hk9vob74cARuxYlld20kRL/R+LI4FF+oZwu6RhVE7AAsjV
        BB/8bhacdC7IoMKYYd1p76YuLSqqbC7hg3IBarj+BuYQtAwjaTA+zPLWFyCxIMfs
        rYjPiV67X012RdewMUQN3g/cP3z7Nn9orJawRH1uxQ==
X-ME-Sender: <xms:MmJrY2h8IgVjngd4YQK7AIP3KOUSM-djuDnRxBFxwIov4wt9J6Wf1Q>
    <xme:MmJrY3CESlOlmfOcNVGLpVJVxzz7qC0w-WJqTOoLdsyHi1rXbukhlmByUKHC_5ULu
    11yO7JrRdv0kSg>
X-ME-Received: <xmr:MmJrY-FbV5jQjgOK0-jd1eASOW_nqcs1cNFD9U97A0TW9z5g3uAtfuFLsPca>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedugdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MmJrY_SwDXB-kvv5srNvSlPKKNBekSsqcucicwfm35L2MYhrNMk76w>
    <xmx:MmJrYzxUA_hfP0ajwNBVeKWE-Z5hbPQ9m2s3Qu_waKrvHoMN2eQ05A>
    <xmx:MmJrY95hT8fxHSOPH7Hf7l-ad9mpelcwlbnmOGinzRh4WOks7j4u_Q>
    <xmx:MmJrY-8sNjfEZD-0WfHqYjHxPV0uLnBWWm8FjPZUZzfbTNzT4Wav4w>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 03:17:53 -0500 (EST)
Date:   Wed, 9 Nov 2022 10:17:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] ip: fix return value for rtnl_talk failures
Message-ID: <Y2tiLyt51VN4ilmi@shredder>
References: <20221108124344.192326-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108124344.192326-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 08:43:44PM +0800, Hangbin Liu wrote:
> Since my last commit "rtnetlink: add new function rtnl_echo_talk()" we
> return the kernel rtnl exit code directly, which breaks some kernel
> selftest checking. As there are still a lot of tests checking -2 as the
> error return value, to keep backward compatibility, let's keep using
> -2 for all the rtnl return values.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 6c09257f1bf6 ("rtnetlink: add new function rtnl_echo_talk()")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>
