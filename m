Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA361DC68
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiKERZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 13:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKERZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 13:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64F712608
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 10:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80F9160B77
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 17:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD99C433D6;
        Sat,  5 Nov 2022 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667669146;
        bh=6MUkXPWXkX5uSssmigqg/8HK2NzMBL77Wj/776PSTWY=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=o6cyfT6qGQ57dunstEybawRPZdO8/vj9fKonfTiyqE9PSfJvAiZIZTjyAxVpzuvIs
         Xw8RUHmLLdG5zcAfJxzLVRUMLQjpI1/TKQ6ALR0FNTCm21CUFz7cgkiLHmcGhAKXED
         7pia+2xJFXL7jZD/6WMwXPA9F53sqmgMDalHqSdnafAnBxhYCxsRdd7eN1z7DE7Bg9
         DDF55tmq3ffYXleesYyJtc3T3OWgBckIUP7kwlslUi4GZYAq95mXKzC6thR6i6Dc0L
         qH/xz42sA2+MEraMx8qmlSnqQ4ac61tm1TgfccFnfudNZN5zxfV4aOPCslnTlVxHri
         MaefpH+qFPKfQ==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 31A3A27C0054;
        Sat,  5 Nov 2022 13:25:45 -0400 (EDT)
Received: from imap50 ([10.202.2.100])
  by compute2.internal (MEProxy); Sat, 05 Nov 2022 13:25:45 -0400
X-ME-Sender: <xms:l5xmY8fW03wV1tv40YETCdG6_Pvo43pbD3uGUE5y-O61hhDk-QOJ8w>
    <xme:l5xmY-NYk1IHed-80V5M7ZErEyT0suoNvpLZZEZcsKbLxf9lKMVavjwDJiAbOzypM
    Wh3HvGrlMvKa93tUt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdefgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfnfgv
    ohhnucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgeejveelieejhfffjeegvdfhueefvddtvddvvdfhleetjeetleeg
    ieefvdfgveegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheplhgvohhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdeftdeh
    feelkeegqddvjeejleejjedvkedqlhgvohhnpeepkhgvrhhnvghlrdhorhhgsehlvghonh
    drnhhu
X-ME-Proxy: <xmx:mJxmY9giPU26wMCMCjsG_sOW45YOQKq_geTZmTeokYjIKT-ZM-nH0Q>
    <xmx:mJxmYx9SWYQfyMxVE62qBGS_fAKQT8wwni2LBgmUX9L56xobeWYZ9Q>
    <xmx:mJxmY4uVp2yH6NpL_9gAbJVWfQjr6j9HESruq8eqCgdcdsdg3bRqCA>
    <xmx:mZxmY6I4c0CZgHTOMy2Vy7ZSDFbapZysC0-sCZWRNQ00JYD2_VK88w>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E57DB1700089; Sat,  5 Nov 2022 13:25:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1087-g968661d8e1-fm-20221021.001-g968661d8
Mime-Version: 1.0
Message-Id: <4299887e-d9a4-4f8d-99fc-2964674f978a@app.fastmail.com>
In-Reply-To: <20221103204800.23e3adcf@kernel.org>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221103204800.23e3adcf@kernel.org>
Date:   Sat, 05 Nov 2022 19:25:23 +0200
From:   "Leon Romanovsky" <leon@kernel.org>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "Simon Horman" <simon.horman@corigine.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Chentian Liu" <chengtian.liu@corigine.com>,
        "Huanhuan Wang" <huanhuan.wang@corigine.com>,
        "Yinjun Zhang" <yinjun.zhang@corigine.com>,
        "Louis Peens" <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v3 0/3] nfp: IPsec offload support
Content-Type: text/plain
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, Nov 4, 2022, at 05:48, Jakub Kicinski wrote:
> On Tue,  1 Nov 2022 12:02:45 +0100 Simon Horman wrote:
>> It covers three enhancements:
>> 
>> 1. Patches 1/3:
>>    - Extend the capability word and control word to to support
>>      new features.
>> 
>> 2. Patch 2/3:
>>    - Add framework to support IPsec offloading for NFP driver,
>>      but IPsec offload control plane interface xfrm callbacks which
>>      interact with upper layer are not implemented in this patch.
>> 
>> 3. Patch 3/3:
>>    - IPsec control plane interface xfrm callbacks are implemented
>>      in this patch.
>
> Steffen, Leon, does this look good to you

I'm sorry but didn't look yet. We had onsite IPsec workshop at that time.  I'll take look on Sunday.

Thanks 
