Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E4C69AB3B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBQMSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBQMSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:18:23 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248566044;
        Fri, 17 Feb 2023 04:18:22 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id AF3965C0145;
        Fri, 17 Feb 2023 07:18:19 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 07:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676636299; x=1676722699; bh=vPqiFFQO7x
        8SCHhgC4aLKlPDdfJ2gCkxCnt3cyUKqqQ=; b=r/MAzjUs2/7KqiKLwhsbhH5TDc
        pWEsepg5H1w//MrmUdOVzOiAiN4C4wxwE1h2xYkmCgH2qMpw6VC0UECP4H4E4e67
        Bdaau1rMHvVpfKEF1Jo4/6M9CG2NvnYHIGM4ogBCUzlRx/fa0aHhepwEeZ2THiYT
        gfxzUHhvAJ5qVLtb8FaulXHD7i51N8zgITpHwIADG8scSAgSHVbRyZ4H5ufCwxxb
        LhnfMe1ofBcCchQY9k+pgbP3gR49FiLJIYDpCrC4KaVI6LmeKkxGnKW4IeqeVfb6
        LOANtUfnIkqMayEbkkFwAAgw9R6DGRRdYs5IB0qqIihbRovASB5kooqRHfYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676636299; x=1676722699; bh=vPqiFFQO7x8SCHhgC4aLKlPDdfJ2
        gCkxCnt3cyUKqqQ=; b=sKZFe/UiRExLtypB8/KpdIxqzEj4+dg6TYKtCO4p46MI
        TRwyrvBdyM83zGX2Sz9rnZJDMjmxAt9j8yyITJ1bVhBh5jgZw8ehUS+rQpUsTtFX
        9y+iMXVmQ+OQzKoDR23m251ov5NRfAhMebDWVs+nCEmVBpte1Z+lTwR5lRVm33vS
        8Fd3oBJxNQ0wxo6Lp4G4gOn/L4mEMXKcbELqYaIMqaa8/rexFGagixtqfUTgrCvm
        78QrOcumDbiVHjNwcELJdhW3SG3bHj90eF5I+/5OBvqIcf8hU7371hPANCz1TthV
        nAZN1oprkKyYFkRugIQ6BXMOhVpLOuU+wWoLARHqMw==
X-ME-Sender: <xms:i3DvY7Lw5ZW76FGqoIwRvEZFt701vL-WVe446mQ7jd3i-ZXJ7G1_RA>
    <xme:i3DvY_KDNfGBvodwNWeDWWz5Op3yvLypbz0708pLsvUd9r_cXVFD-2KRH7alvQgWQ
    nPhZZkpcFeILfpLEyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:i3DvYzvyzD7iW4Rjd-LKFbGb1O6CWfO__VYSilDkQdtFI2DnYmh9GA>
    <xmx:i3DvY0aRK5xi2rSl-_taCEJgttzyTCDwLCs-Y6MbonNkuCXZRNRJ_g>
    <xmx:i3DvYyaD3X8L9hNZobVHFgW9P8mCti9pJe5rJdtwp_k2vpF_tXhN5g>
    <xmx:i3DvY4mP_y6r8GLQGTmQFP0tLv4Nv0SMFm7lcMHhP5zW8UWwdqygkA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 513F1B60086; Fri, 17 Feb 2023 07:18:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <a6f0f854-6ee2-4535-825a-b967e37ea221@app.fastmail.com>
In-Reply-To: <4e88fae65e85366bfc5d728c0e4c47133c7b9523.camel@realtek.com>
References: <20230217095910.2480356-1-arnd@kernel.org>
 <4e88fae65e85366bfc5d728c0e4c47133c7b9523.camel@realtek.com>
Date:   Fri, 17 Feb 2023 13:17:59 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Ping-Ke Shih" <pkshih@realtek.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Kalle Valo" <kvalo@kernel.org>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtl8xxxu: add LEDS_CLASS dependency
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023, at 12:50, Ping-Ke Shih wrote:
> On Fri, 2023-02-17 at 10:59 +0100, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
>> b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
>> index 091d3ad98093..2eed20b0988c 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
>> @@ -5,6 +5,7 @@
>>  config RTL8XXXU
>>         tristate "Realtek 802.11n USB wireless chips support"
>>         depends on MAC80211 && USB
>> +       depends on LEDS_CLASS
>
> With 'depends on', this item will disappear if LEDS_CLASS isn't selected.
> Would it use 'select' instead?

In general, 'select' is for hidden symbols, not user visible ones.
The main problem is mixing 'select' and 'depends on', as this
leads to circular dependencies. With LEDS_CLASS there is unfortunately
already a mix of the two that can be hard to clean up, but
'depends on' is usually the safer bet to avoid causing more
problems.

For wireless drivers, you can also use MAC80211_LEDS to abstract
some of this, but that is probably a larger rework.


    Arnd
