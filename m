Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EE0623E39
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKJJCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKJJCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:02:48 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA55D69DC8;
        Thu, 10 Nov 2022 01:02:47 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 772DC3200980;
        Thu, 10 Nov 2022 04:02:46 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Thu, 10 Nov 2022 04:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668070966; x=1668157366; bh=q00moUI8K+
        pOFD9ktwoRAAtmtSjS7qt/Tr5OG5EM1/8=; b=AwhCrceGKorlAVUjfyPbzW28FM
        eeSS9lcVePIHpJy1ZkC23YhXvXAzXJm/XL5iETpQjPrXwFFBFQZzglNyJU1CtPkO
        OJGOPVAIlJS37k9rJawHfyxrhIXaG53GCELC5pBUaidIUwAo9TGBaS+8dVB3fhkl
        13ppaCl6h4DxJYeCd1xJZIxGkHKSzczq3q+nDRD+gMLDxLcLRFsRufXxzc9NIy9Y
        3FWuiX55bh56q9X4Lge2aHy2A5GhiU909sLX5rwPjceEt78oSHEM1T9WuAHXm+Hy
        q567cC6ruRvR7/OwLKB5d3tdLdYC8k1aw3Y6XovD7L3gR76ORY9k1FgZRkJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668070966; x=1668157366; bh=q00moUI8K+pOFD9ktwoRAAtmtSjS
        7qt/Tr5OG5EM1/8=; b=sgH9PeCaA38pM4BH3FZX+t/rMdUT+fYgU+mHUXK6V7w/
        xDpykZZ74JzPDSODRsqZIDYuL9WbJvcGzT5DrLc/Y6I4UacKkrNSS/Q2pcVwGp1W
        iplpqWvNvLZY1JQl+595AQB2UtYm9SuZO40FwJRm6EKtHIw3qTfDC6pZNgUvSP8q
        StWcv2PXkIAosUXdc/cDsHEVffLQ3J/lOEZsz/tqX4MTBiDoY9sGvRZInIacjqmK
        L1A/qOdxMe7EvseH/x8KFQVis/cDQLkMxO9R23TVGDzuw+qxpbM07GoTZ0tIFjyl
        DTSqi5Gv2IHxdeZ1oiKODr4HHOR7tIxVhxxo5XD7Cw==
X-ME-Sender: <xms:Nb5sY2YcwuC4_kfJeNk8TsMohtQNJVNUxMUmIZhHsbrMIJlI8UCQng>
    <xme:Nb5sY5bXJwL3cLG92641KVJWuTqX_9UAfLgmcJuhkSTJoOczJz9kcqwbwBjaWCjZC
    Mqmp2DClNJiSHbka98>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeefgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepofgfggfkjghffffhvfev
    ufgtsehttdertderredtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorg
    hrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnhepleelheeffeehheefvddv
    kedtvdeitefgvddtkefgtddulefgfedttddvjeehheelnecuffhomhgrihhnpehsohhurh
    gtvghfohhrghgvrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Nb5sYw_nT4BGT3u4PbsoPlkWjT0v77Pjczi9Di-YwjbILsWkbyFzkw>
    <xmx:Nb5sY4pHVLQbI5ckX7z9GFrptNWjaxKCznBxXUs_liRDOAY2kBGaoQ>
    <xmx:Nb5sYxo2pFvlYAVJiKTRcGVHJJo2UUY3lW050faWm3XRw3gntD-N_g>
    <xmx:Nr5sY1exkr4JUEIuXX4GvDoGK8d3Jm0ciiPGcpSyxmELJCmph32RSA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 909F8B60086; Thu, 10 Nov 2022 04:02:45 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <d9b1e753-3bdd-4b8f-935e-718b0b590ace@app.fastmail.com>
In-Reply-To: <213cb0f3-10ce-45b1-aa5d-41d753a0cadd@app.fastmail.com>
References: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
 <Y2vghlEEmE+Bdm0v@lunn.ch>
 <213cb0f3-10ce-45b1-aa5d-41d753a0cadd@app.fastmail.com>
Date:   Thu, 10 Nov 2022 10:02:25 +0100
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

On Thu, Nov 10, 2022, at 09:05, Arnd Bergmann wrote:
> On Wed, Nov 9, 2022, at 18:16, Andrew Lunn wrote:
>> On Wed, Nov 09, 2022 at 10:08:45AM +0530, Balamanikandan Gunasundar wrote:
>>> Replace the legacy GPIO APIs with gpio descriptor consumer interface.
>>
>> I was wondering why you Cc: netdev and ATM. This clearly has nothing
>> to do with those lists.
>>
>> You well foul of
>>
>> M:	Chas Williams <3chas3@gmail.com>
>> L:	linux-atm-general@lists.sourceforge.net (moderated for non-subscribers)
>> L:	netdev@vger.kernel.org
>> S:	Maintained
>> W:	http://linux-atm.sourceforge.net
>> F:	drivers/atm/
>> F:	include/linux/atm*
>> F:	include/uapi/linux/atm*
>>
>> Maybe these atm* should be more specific so they don't match atmel :-)
>
> The uapi headers look unambiguous to me, for the three headers in
> include/linux/, only the atmdev.h is actually significant, while
> linux/atm.h and linux/atm_tcp.h could each be folded into the one
> C file that actually uses the contents.

Actually the situation for the linux/atmel*.h headers is similar:
most of them are only used in one file, and the linux/atmel-mci.h
contents should just be moved into drivers/mmc/host/atmel-mci.c
as part of Balamanikandan's patch, to allow further cleanups.

linux/atmel-isc-media.h similarly can go into its drivers as a
separate patch if desired.

The linux/atmel-ssc.h could ideally be cleaned up to get moved
into sound/soc/atmel/ along with drivers/misc/atmel-ssc.c.
The atmel-scc driver is technically also used by
sound/spi/at73c213.c, but that driver has been orphaned since
2014, with commit 2e591e7b3ac2 ("ARM: at91: remove
at91sam9261/at91sam9g10 legacy board support"), as nobody
ever added DT probing support to it.

      Arnd
