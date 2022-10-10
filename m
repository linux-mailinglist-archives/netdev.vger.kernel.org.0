Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7975FA2F4
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJJRwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJJRwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:52:35 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339CE13E14;
        Mon, 10 Oct 2022 10:52:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 85BC52B06F1B;
        Mon, 10 Oct 2022 13:52:31 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Mon, 10 Oct 2022 13:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665424351; x=1665427951; bh=eIM+MeuDgl
        5z58nSOwcRux9xgNdpNXrzM2SeDZwQsd8=; b=oYZS5cu/Rsvl0KB8JTLsGB3saF
        kHTxa5Fkfk+2YZuUmW9S023XW9o0XZ0SDkanDwFAcRrfnfQSmXsoo5P3Ges1zjBL
        xfvxLGE/PIRL1hIfssvk3zHIJO5gYIpw1Hq6FsGy6STG1EjMUm9xPrf7SoN0TbcM
        lW+Pmrs07xyj6QAHa9a4A47TC+EdrpYC4ECJp1POmEvis5e7t0l4oRjLdzWpE/+5
        huVbsRcM8F2DYQ/eWtpk1cO+0hEV+8sBDdZnEPKEY+8mR+FQsBIlQLr7ia0I79Yd
        dx5VnCYxMOOy7K6aAa4zQAHfR+qG4OTopY2xqj0nZ6JexpQYsNFTfI+kIXDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665424351; x=1665427951; bh=eIM+MeuDgl5z58nSOwcRux9xgNdp
        NXrzM2SeDZwQsd8=; b=U9A8Pr/nhJN0fRLBk0x5nsQOv7x3e+NiaeXMGoKz2X8C
        yQizTYenqakkepNspG883KFpigUTTBod0GP0z/+BJxxLiGU15sBrf4DmuFOrB5pk
        tZxoT7wGtBG/fZ0YVC+OysEa7hll+3SyB+TxTPCvtAPrpskNkj5QTzlCSC3k9q6A
        ZoUONN2LuxiqmrA/hwV/Rn094kcd8rKbbbdNRghnqU3fEEXT86vBPrqf2i0KTOcC
        zKbvN05lgLt0E8O6aiqU1FAunw7EKsjNbMzAxpi9HwBXV6KwODbKyvwEjeub96px
        qKdbKSnAzV+joiEs4L4uLyufFYzCkEvf55D0zq+FcQ==
X-ME-Sender: <xms:3ltEY_8b39mNjScYLdR4EksI10Dmr9dCKLpvYm0EqLHlUzUwYrVQEg>
    <xme:3ltEY7shMHCvjx9dhS_CDkTBNypGWkHRDgUEBy8O590its7J_gEj6K6S0giUkpAxZ
    wSvMi7sMKZIRecmb4Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejgedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeelhfejffehveevjeduffegieffhfeihfekteetffdujedufeeghfekuedt
    heetgeenucffohhmrghinhepthhugigsuhhilhgurdgtohhmpdhkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhn
    ugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:3ltEY9C2kDz3h37uVXomDacWmOvYYCjaELqRJgTzUtWZvHe_jBpX7Q>
    <xmx:3ltEY7cigPoef-_K5NZhRVno0hk_IX7XGhKORG3mGpkbz6fDrvav1Q>
    <xmx:3ltEY0P2trZKuLHGNKQ8enQ6dPvU7dVmK_jFfzTAbeHtGlKUXyeoqQ>
    <xmx:3ltEYzpfzxKrcwSazZHRW6cp90WKwAXb278VbPYcPIlYN2rn4Q9OjnNW0SA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 933A0B60086; Mon, 10 Oct 2022 13:52:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1015-gaf7d526680-fm-20220929.001-gaf7d5266
Mime-Version: 1.0
Message-Id: <158e9f4f-9929-4244-b040-78f2e54bc028@app.fastmail.com>
In-Reply-To: <87ilkrpqka.fsf@kernel.org>
References: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
 <87ilkrpqka.fsf@kernel.org>
Date:   Mon, 10 Oct 2022 19:52:09 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Kalle Valo" <kvalo@kernel.org>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, ath11k@lists.infradead.org,
        regressions@lists.linux.dev, lkft-triage@lists.linaro.org
Subject: Re: drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning:
 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size 0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022, at 6:54 PM, Kalle Valo wrote:
> Naresh Kamboju <naresh.kamboju@linaro.org> writes:

>>
>> Build log: https://builds.tuxbuild.com/2F4W7nZHNx3T88RB0gaCZ9hBX6c/
>
> Thanks, I was able to reproduce it now and submitted a patch:
>
> https://patchwork.kernel.org/project/linux-wireless/patch/20221010160638.20152-1-kvalo@kernel.org/
>
> But it's strange that nobody else (myself included) didn't see this
> earlier. Nor later for that matter, this is the only report I got about
> this. Arnd, any ideas what could cause this only to happen on GCC 11?
>
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

No idea here, though I have not tried to reproduce it. This looks
like a false positive to me, which might be the result of some
missed optimization in the compiler when building with certain
options. I see in the .config that KASAN is enabled, and this sometimes
causes odd behavior like this. If it does not happen without KASAN,
maybe report it as a bug against the compiler.

     Arnd
