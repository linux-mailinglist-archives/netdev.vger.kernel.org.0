Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B21623D19
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiKJIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJIGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:06:00 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D5AC47;
        Thu, 10 Nov 2022 00:05:56 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2574F32009BB;
        Thu, 10 Nov 2022 03:05:45 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Thu, 10 Nov 2022 03:05:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668067544; x=1668153944; bh=9z6dpakWTQ
        c474Oc6sPg23vwltb7n4QHp0AAy2hupBw=; b=FGaVMC7/QkT5O6WwNld0N1blty
        bEWjb5gKBTYQolLIJ6DSY61Aw1KDixZA5ZeciU7UkpCV66ish6RkfniQ+zoDgShD
        RajyevWqvhMNDUou6LztAsCgOBQmCM8sdL/CipYCNOOmR8ki7/kvw755NFFPZpEh
        grl9VkaWs7nkY2JFyrCqzVWBiGox8a5m55bL7B7XI//zBE/2733k33T8+gGT5Nc9
        qYE8Fe4PrxwC7RuA3k7CfOveyKGE8aiD82Qplsqeg0NQMqYRnThfD7O66fSrh+7U
        FgVg4GZLJWOutK674EB87/lLfcXrd5Y93BGOEFVm44rlW6SQb8d3HELI0wCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668067544; x=1668153944; bh=9z6dpakWTQc474Oc6sPg23vwltb7
        n4QHp0AAy2hupBw=; b=HdRJqJAv6NHEXmu2lTEhKHeTJfhEdzLQ5wNdAoLzlAbW
        bhhuTvJqYR7O0PsfH9v1KcGaDF0Y1vk0xnQbZ+FDN5C6o91l16cQFz2MmVJJuD4z
        pXs/nqMc/+ygHiCvhfKuLQ/MavYzCMSqufUrfYSLVhA53NLAm7H7S0pamB/Q0C4v
        k8quuJPtSWuVWP74+NxtE3bEo1d3O3ImcIgl89A+61QLhG7pq6sypU5PqmvHgeNU
        fn4oKKZXQMR2TZtQCEA9R92mbI3itNTMnbI4FJDzYqD3eTOXJaIFUTm6sr6s6JU0
        wg15sVQsLVrTy1JzdNAjd+p8SX7D7mT8aDI4fbormQ==
X-ME-Sender: <xms:2LBsY8d2u2cIPDIdgl5I2nvO5fnqOEueqSvdt57FqU5Ca_IGj-34TQ>
    <xme:2LBsY-N48vDWqXpiF9UghwZ1MviYO8Nv3toMZygepzXLow8sXV0nKuKn2XrEQw6m5
    2vvklPDp0ZHsMa-FT4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeefgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepofgfggfkjghffffhvfev
    ufgtsehttdertderredtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorg
    hrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnhepleelheeffeehheefvddv
    kedtvdeitefgvddtkefgtddulefgfedttddvjeehheelnecuffhomhgrihhnpehsohhurh
    gtvghfohhrghgvrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:2LBsY9jCfbLSF-G6KzIWYDt-87LVwqaGeP2DoPrJT461pr84HnPZ1g>
    <xmx:2LBsYx9ynTAdrBky3vh20SEUjYWfoa1UQ57OXh3D-l6HqXVjgs4OZQ>
    <xmx:2LBsY4s1aXpSEdYiZs8ueEaNMz3ZNZZO8JzdYGVmF_dkh9fLnkuayA>
    <xmx:2LBsY2ARA8-q3CMzRu8ozNd0ScFx3vL7SWTfjvs2ZLo0Kn8Bnx9IEw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3470EB60086; Thu, 10 Nov 2022 03:05:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <213cb0f3-10ce-45b1-aa5d-41d753a0cadd@app.fastmail.com>
In-Reply-To: <Y2vghlEEmE+Bdm0v@lunn.ch>
References: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
 <Y2vghlEEmE+Bdm0v@lunn.ch>
Date:   Thu, 10 Nov 2022 09:05:25 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Andrew Lunn" <andrew@lunn.ch>,
        "Balamanikandan Gunasundar" <balamanikandan.gunasundar@microchip.com>
Cc:     "Ulf Hansson" <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        "linux-mmc @ vger . kernel . org" <linux-mmc@vger.kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        ludovic.desroches@microchip.com, 3chas3@gmail.com,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: atmel-mci: Convert to gpio descriptors
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022, at 18:16, Andrew Lunn wrote:
> On Wed, Nov 09, 2022 at 10:08:45AM +0530, Balamanikandan Gunasundar wrote:
>> Replace the legacy GPIO APIs with gpio descriptor consumer interface.
>
> I was wondering why you Cc: netdev and ATM. This clearly has nothing
> to do with those lists.
>
> You well foul of
>
> M:	Chas Williams <3chas3@gmail.com>
> L:	linux-atm-general@lists.sourceforge.net (moderated for non-subscribers)
> L:	netdev@vger.kernel.org
> S:	Maintained
> W:	http://linux-atm.sourceforge.net
> F:	drivers/atm/
> F:	include/linux/atm*
> F:	include/uapi/linux/atm*
>
> Maybe these atm* should be more specific so they don't match atmel :-)

The uapi headers look unambiguous to me, for the three headers in
include/linux/, only the atmdev.h is actually significant, while
linux/atm.h and linux/atm_tcp.h could each be folded into the one
C file that actually uses the contents.

    Arnd
