Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7335567CA7A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbjAZMEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbjAZMEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:04:36 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF796A322
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:04:34 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 566A23200911;
        Thu, 26 Jan 2023 07:04:32 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 07:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674734671; x=1674821071; bh=/1ujuJdl7/
        S/MHYohsIgN1ktn96W1LPT4uGdILaFt08=; b=Ki/YfJrJFZi/os3WmveriIyceD
        +hffqIQxAGwOKXU6MDbjzfYddUSpl1Hjf8nxOLApaNJs14dVPjA0L2aSd5qJbvr4
        wUHXhOE+4LkAbfuqQ0Mz0ILldyvgvu5d13LrAGpJp63Xn74JlfRMZEg+sR9JSUge
        UVlaIY6LqahFPvYXWACYJRRFPSsbhomPa/+JJ9x3YmUZoA/W2xtP93/W/5jvmaSZ
        OKTaV4sfTF1tfJILXMSVvM2eB1Cy5gRSS8inOa52ANc6wZJcQ3pAYeeFSzudrvdc
        BNKBn4sqLqUTFClgSbF4v7NkJlDkeXPQALIyoxtrjKhPuBoDDZ5/XvpQPzpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674734671; x=1674821071; bh=/1ujuJdl7/S/MHYohsIgN1ktn96W
        1LPT4uGdILaFt08=; b=L5HsmW2weRbYbMF+Qs+VujiUi+bkmnm8abzyZFdrPNWG
        +l200hyqbpvkKDu6NDMTGoBosbHt9TJWmURhrHFabmhszHr4leCCOZYYvUzYXJJ1
        XTyV7ibs9u65DpIbuLQ05eMAx2iDetqcRHW7woSBoEeaUeTxAi8sQMzR3JAJFZEh
        rjNVbEOuFBrSfinXFepQc2HQFJR+hERqK91Ak7HDY8Miec0PLw7m6fAs/9VS2pcc
        UyHSBx5rG0kHxElGjvfpWfBUmXJcYqU4y1Hdb+BzfPBqsTZvg7a9ZUCBYb3dNboz
        E/tBFXQXfINjn4rvlC00Gdd6LfWPVIO6JP08cO0ByA==
X-ME-Sender: <xms:T2zSY5vVyF-6KHfN64wadeYRw6ecnXxnGWaZyKw-q-wc0gTVmshc_A>
    <xme:T2zSYydRRtWlHwtB4iyKEiZNtg-z6XdPnzRzRf8XqYO-IgrhbXVfgYlJUg_DqNC0K
    twUz3lK2Q6vUtCRsEs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:T2zSY8zvLZVcUMIfulbEHcFFT90UJ7luiFB-5LHiovLgGVd7qW3OCg>
    <xmx:T2zSYwPO8wYLd0FK-dVHmuExhkngJqV1yHe_CluyHAZgHl2bp_2xeQ>
    <xmx:T2zSY58t7cE2OU94IU9KGfolaMZLmomrJmygI0nPfpV0WA9OGKoLrw>
    <xmx:T2zSY1YVQ83iq7v0icv5DLnUdITK8o52QbdsIPSGaYFc7X_CWeRZmw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7476AB60086; Thu, 26 Jan 2023 07:04:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <20891683-5df9-42f8-b7a8-2b9cff679062@app.fastmail.com>
In-Reply-To: <20230126112130.2341075-2-edumazet@google.com>
References: <20230126112130.2341075-1-edumazet@google.com>
 <20230126112130.2341075-2-edumazet@google.com>
Date:   Thu, 26 Jan 2023 13:04:12 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Eric Dumazet" <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Cc:     Netdev <netdev@vger.kernel.org>, eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/2] xfrm: consistently use time64_t in xfrm_timer_handler()
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 12:21, Eric Dumazet wrote:
> For some reason, blamed commit did the right thing in xfrm_policy_timer()
> but did not in xfrm_timer_handler()
>
> Fixes: 386c5680e2e8 ("xfrm: use time64_t for in-kernel timestamps")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

I don't remember anything about this one. I thought that perhaps it
was using 'long' for a relative value that is guaranteed to fit
but needs an otherwise expensive 64-bit division. I don't see
any of that though, it looks like an obvious bug.

Thanks for fixing it,

Acked-by: Arnd Bergmann <arnd@arndb.de>

