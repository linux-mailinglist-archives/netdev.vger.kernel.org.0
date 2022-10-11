Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BE45FB0CD
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 12:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJKKxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 06:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJKKx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 06:53:29 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5751E37184;
        Tue, 11 Oct 2022 03:53:27 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id B498C2B066B9;
        Tue, 11 Oct 2022 06:53:25 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 11 Oct 2022 06:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665485605; x=1665489205; bh=5bI3YI3TxD
        wB3OBrM9zXo72ykVPw/KrTh1LKAdTEzQI=; b=wvKNwKMxqrtAUNztuQlpfH9rp1
        brYdNWsHKjW5fJGmq9KxBMWNgghy92WBf4MC7Df/2iyjxjmhvBS9lfU/852FLQBp
        cwYxE7DKRf1odZT1cYvYmIOjaFXYHx1v9iQfOZ1r45PpQULyQ73bENRT2VQaF14n
        YlSUTQWrnjdvMW5/vOFs1RpnahKqADuw8MKEfsOS7DOCiPl8jJUcMj54k+6YL/cP
        Tldi28IarLCcK31EyloZYKNFdkDjGMo5sgbySgmeTpy7U14eqb6cErLRRWgnPBRL
        5JF2BDvJFdUGJNEaZehLDR7ifkamlAlDo52ovoiZk8a6s4AnrGC4lGLa7D/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665485605; x=1665489205; bh=5bI3YI3TxDwB3OBrM9zXo72ykVPw
        /KrTh1LKAdTEzQI=; b=QiyfXg4wplRnzHFR+cKAh/LuF+QhtxgGfaKaoB9f8dyO
        41zuh4OCh3LAMg4AEswO0xUhCGhmzHV8pNpkmkRBcuTeFDIeiBfw464gNOdcqn4I
        fFFPIYbZCGph4Y1DbFmnVdv7soycxHa2mLCXm1LiV2NLX5Ofs0QiFuHBNtEOyXcM
        uSFkq7zJo2eoNmSWveue5aUznNqZ04sn7yu2lATDofJ0jSGdfILE6BQEBY2e32qg
        H0XRSS/QYLFzQYuA4wig9W2u4LP2bAW4VtELDlZbNut75XPUyRQ5DeCUiiHM2elL
        vp6jgsEcas+IeiCGy2bMpewivf1Zqz3ZMcf30umdXg==
X-ME-Sender: <xms:JEtFY32lcooBYztdni67Wwmf0LubIg_dQcMQkf3jQrxQ-oDXKtPCUw>
    <xme:JEtFY2HgsDD9Sbsgfw-Jy2gu8rI3E0Sl9eGDOrmslweQR1ZqSxMeUEs_-Yh-k0Swd
    mPXzYddL1kPBGVBsoI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejiedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:JEtFY34Hs5N1C3qu7St5NaZMRwdLH8GqRYGVSNCkcjMa44U90zOy6Q>
    <xmx:JEtFY83QAC37vCJ0ovUwIfvJSa_Vo9YEENl-M-JBNfvib88fBVKhGQ>
    <xmx:JEtFY6HZMGQ9A2HNXL7dS-yvA5FZgAEJlvb5J-il0U7Y-PCW9C3p5A>
    <xmx:JUtFY9C-zwgQtavNsqAMd3xx1ciDw6jSZur_Rm2SJnHJdxi7sCsWrmxdE6s>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B75D1B60086; Tue, 11 Oct 2022 06:53:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1015-gaf7d526680-fm-20220929.001-gaf7d5266
Mime-Version: 1.0
Message-Id: <e21a4eab-fe4f-4028-a22e-d60a6feb4dac@app.fastmail.com>
In-Reply-To: <87tu4aok1j.fsf@kernel.org>
References: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
 <87ilkrpqka.fsf@kernel.org>
 <158e9f4f-9929-4244-b040-78f2e54bc028@app.fastmail.com>
 <87tu4aok1j.fsf@kernel.org>
Date:   Tue, 11 Oct 2022 12:53:04 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>,
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

On Tue, Oct 11, 2022, at 10:12 AM, Kalle Valo wrote:
> "Arnd Bergmann" <arnd@arndb.de> writes:

>
> You guessed correctly, disabling KASAN makes the warning go away. So no
> point of reporting this to GCC, thanks for the help!

What I meant was that if the problem is specific to KASAN, it might
be nice to report it in the gcc bug tracker with the KASAN component,
ideally with some kind of minimized test case or at least preprocessed
source.

   Arnd
