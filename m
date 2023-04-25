Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706146EE9CC
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbjDYVoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjDYVoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:44:37 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D66B23A
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:44:36 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 19A775C00CE;
        Tue, 25 Apr 2023 17:44:36 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 25 Apr 2023 17:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682459076; x=1682545476; bh=/j
        9PK29hcLK6KW8qx7/m5utPSztLlp4D/oiiPS5B660=; b=LWYontF4pAPgLwPUC/
        2d4YSBEe4FKFVVPKDK6PrjwmNCSXyUhCPuW2VIpzn3QQQRU1OI4tHBOYpLPSL9AR
        AKWKSn0XhVVnWPHBnNGQbW8d6EH/k2FOQurUbs6bjxhBmeDEKYY4zAvEBKqeoYuH
        sij7zM6GN3iNKHNWe/zDTiKAM4UtjiNJi+TZZ9fIfL3SzCJFGYxb8OqIL6tTMzN7
        fGmKcsD3DdCDajfofOygaGX050svaVN8onuLQpodLAzDertGoIO+1oAFOEhZvgZB
        3n75LcWXcwRg9n9oy16q+ht2wtpwwGALhtjGe9A7ldEeAbU+hkr2j6VoiHGQIxIm
        emTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682459076; x=1682545476; bh=/j9PK29hcLK6K
        W8qx7/m5utPSztLlp4D/oiiPS5B660=; b=Hju89TkfZK2GKFFtDmOzjJh2SL7Zi
        3isCsiS4YPxGzCUD6vhtQ6qsgCoo2w/04JWAySQVs7FmkM1AZa+bRIhyk5W1Nf8t
        5RzKD8TmNGV29LjnlXFm/35g6VeTVfDcg5rDMWdACjTxQnQqRujexQDHqr2t2BpF
        0bxhIgDA7NpAqYIankUNcIzJKcNDGVazm5beslat+yarqslEM2ZjsMq+3lj5xXoq
        n0gMPYHxrrUUkp+o1KQ/q9XktFaQvKu60VW6tewYGxJ+dESZ8PEkIUuX1ZMG101f
        L5qZVml9xLJzNB+PWua21iOwxHjn/ZI8+1psMf3wr5Kx2+6vMEqfYykwg==
X-ME-Sender: <xms:w0lIZF3xHskdRs0JfaW1f035h_e5Tq-b9oG9Rm1zfBuE0jY5k0yieg>
    <xme:w0lIZMFuuN6qlNLKKdqQOgFQC_9HTs7eSi0CdoZTMAmPWYt8YyayPDgDAcisAnqC7
    uCKKPIuDPlVaUBqugA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedufedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:w0lIZF7mVPfqG6hYZnfXQv1izd1vrfsFtlZhE-jk2eQSFy3CCwKgvA>
    <xmx:w0lIZC32qb2BXLQfaGcApsWVzBWu4VWXof27xfF9LhiIKeXubSDSHQ>
    <xmx:w0lIZIEDSqh98oRAZjchrOXsldiIej0HPtv9d7bYN-talPmjj1k9sQ>
    <xmx:xElIZNMf_BDtYBvdmkhSmQC5vlybhO-nLyl_V9yiisD5gseW4mcelg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B3F54B60089; Tue, 25 Apr 2023 17:44:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-374-g72c94f7a42-fm-20230417.001-g72c94f7a
Mime-Version: 1.0
Message-Id: <e1e1022a-da6e-4267-bca9-18cd76e0d218@app.fastmail.com>
In-Reply-To: <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
 <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
Date:   Tue, 25 Apr 2023 22:44:34 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Andrew Lunn" <andrew@lunn.ch>, "Paolo Abeni" <pabeni@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023, at 22:38, Andrew Lunn wrote:
>>  
>> -config PHYLIB_LEDS
>> -	bool "Support probing LEDs from device tree"
>
> I don't know Kconfig to well, but i think you just need to remove the
> text, just keep the bool.
>
> -       bool "Support probing LEDs from device tree"
> +       bool

Right, that should work, or it can become

        def_bool y

or even

        def_bool OF

for brevity.

    Arnd
