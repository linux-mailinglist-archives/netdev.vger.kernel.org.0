Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C251D6D5EAC
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbjDDLIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbjDDLI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:08:26 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F23A8C;
        Tue,  4 Apr 2023 04:06:53 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id 59BA2581F56;
        Tue,  4 Apr 2023 07:06:52 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 04 Apr 2023 07:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680606412; x=1680613612; bh=z7
        EzKZ0L03Vqajs+ogmzIxsIatsg8LuRD8oJ+p9J0SQ=; b=GnAWMe7LYftE+EzS5W
        WOMzwLNVzjI9xjmYSaYEiCwtAe6jPlylQa2Fd7r1D5jPNZOSUEQqhmxRnPFOgU8W
        WC8mNfm26+rhBxaI1sYbNO8IbAG39tY2USQliLK5MBMvnth1cB/aVdCJSTL++Q0M
        jp2GKbTRpfCbLaWyWul7GZrhK9+qLkfi87LntytmpP/XDUfOHmCetOcPa1bWz2qP
        ryiE694F8xPZ+vshZJEMJE/xHnO7MC2tEyvDSbl6guIotbD5G19VSWoCae7UJKSR
        lNHHMA+lGjR1WXud18FhlMTjCmNpBKQuEMPOWf1WMzqEA0YM7kb4w94yiB9H2/nl
        IleA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680606412; x=1680613612; bh=z7EzKZ0L03Vqa
        js+ogmzIxsIatsg8LuRD8oJ+p9J0SQ=; b=J2cm9zBGE9SXJJkI9w4MbSdW+Z90K
        ed6R7RdlRFhcHMea2g0jA+rjsbKmdhQUMALfnfjNFAf0o7OWMabxP4c/Vs0CSJpN
        /9g0Qw1CvJm/OfZ1ld9BoV3Pt1fpbhftfmLfj+XCgm0KjJEbZfOAoTbtOzGQ/Zug
        F/0LPJY0zxpyuN4ouYvGSLUz0HQBXfrPVq1vu4grqah9ADA0/oapLfWU0KC+eD0E
        rlcl90w4cJuc+syN32E4Z9g9J5ICptvO/1XeivZPirxkJjR+Pf1iSsiziToIqU0V
        BkuucE9ib7K163aCDV9ytieu4JyKOQFnXa6fUmwNHDYjdDbSr/HDw/SLQ==
X-ME-Sender: <xms:ygQsZEnCgUPZ8JbS-8VP0OAvdijeGFmJD7fQ3AFWHL4BCnLt3_rogA>
    <xme:ygQsZD1rDwS86pHr9alTivTRygqat2h53eXMMFp0xNNFeIjc1UQDvQctQszXcCob7
    ls-8q4ZRVfNIRZZc6o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ywQsZCrPhU64C5rSp1CXgBls8Hx_6__QDPdtx6NDedRHnxx7ChZFiw>
    <xmx:ywQsZAldtFKVm1jZCPEu-uIQsatmNC7dbMd5g8ausQ8rijBjWUiJpg>
    <xmx:ywQsZC138RABmk_OW4ckpB4mYsBiazH8XUmdAnuVd49yxjhj7tnbIg>
    <xmx:zAQsZF_8VYUsO5M4ZN0lxPtlAquo8dT-hp6azBitrfy9Uhgr6uJ3pw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E507AB60092; Tue,  4 Apr 2023 07:06:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-238-g746678b8b6-fm-20230329.001-g746678b8
Mime-Version: 1.0
Message-Id: <2a627c49-e0a3-4a7f-8c0a-37b1d3cb85dd@app.fastmail.com>
In-Reply-To: <20230404082401.1087835-1-arnd@kernel.org>
References: <20230404082401.1087835-1-arnd@kernel.org>
Date:   Tue, 04 Apr 2023 13:06:30 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Arnd Bergmann" <arnd@kernel.org>,
        "Tony Lindgren" <tony@atomide.com>
Cc:     soc@kernel.org, "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        "Christian Lamparter" <chunkeey@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Felipe Balbi" <balbi@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>, linux-wireless@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] p54spi devicetree conversion
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023, at 10:23, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> I now revisited the earlier submission, hopefully addressing
> all of the feedback correctly. This is still untested, but if
> everyone is happy, it could still make it into v6.4.
>
> Patch 3 touches both driver and platform parts, and can't
> easily be split up without breaking bisectability, so I think
> it's easiest to merge it through the soc tree, with Christian's
> Ack.
>
> Tony, I see you already sent a set of pull requests, let me know
> if you want to pick up these patches for a future round (6.4
> or 6.5), or if I should just apply them on top.

I just spotted two mistakes myself, so there will have to be a v3:
Patch 1 is missing a changelog text, and patch 3 contains a typo
that only now triggered in my randconfig builds.

      Arnd
