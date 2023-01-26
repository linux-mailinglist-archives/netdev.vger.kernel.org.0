Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1DD67CA8B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbjAZMF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbjAZMF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:05:57 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990936A31F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:05:52 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 8CA93320055E;
        Thu, 26 Jan 2023 07:05:51 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 07:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674734751; x=1674821151; bh=6hKpvnD9nO
        O9b1tYX2uXnhINltu3wQYdJRWE02Eo7bE=; b=D6AvH9piwcpGCoHN+5R5E/TdTa
        deixb8Y4vkLFiGdWD9uPgaM2bjWdx2KlX1hWMqMb4UI0JDOlmR3pj2KrP5IfB9Ux
        k6AwSKW2bEz6aZ/KCaYwxNzz15ayteM+RNhg4yXa+0yQZ9R/QpcqVfs6ad4sKCEg
        DPH50byvQ/2P5+t/fQRxsgCqBMxT/N1tZ8Cd/VyOwI2rJffpRtl+vi9GdiTNfWGY
        TEhp+h2I8QbgQ5YtBUdHONxM6iCAEUZi46GUO1JWJvCvzOE0eXLwfOIlZzu2M5Es
        F9BWbZ9SvXNwObpNZamWgFdPzchfOgntfKJ9/i8/UPfIZA0bAsUK83Z8d7TA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674734751; x=1674821151; bh=6hKpvnD9nOO9b1tYX2uXnhINltu3
        wQYdJRWE02Eo7bE=; b=KzX7dTicrncIMx4CwLTpwWjd5cYahE9b6quj+psrTGrM
        e+/viMpRnU9FgU1ap282jSuoDvEGnQtwRsZpJyunS1yACJRa/fxbfEAdHIaIITLx
        OpYfPQ7RZQAGuAc9WALDQK+f1bxshkSdaX/tGEAN9Z6Ovpdif8QZn61oa4IMBzjR
        g6zhsHEIDGufq7cDWvrBYeeCRk6X4DMxZgCtD/9Erh/cLyx7AkrhnSnPBPJ/eQ57
        H+OQ7+RaDohu7i9KDZ+UiMnE/tH/geHkcMBpW0NLgMKOple1jitXYXwDPefNYRhz
        aDdZYSyUCGP4GLr+XVoOlQUetuZ5Pii5OsuRqkSb4Q==
X-ME-Sender: <xms:nmzSYws0VDRaXLtej9yqpdNdcED4q_gqr1oXErrEBMg37NCVcXkodw>
    <xme:nmzSY9cmtrokW5r_SHTZoHDpp59ow-sPTZ_rRC9il2WAfPCXK1rhaip6Zj8pCzEop
    qHsYmtiEHrvWK_sKeI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:n2zSY7wLCF4U3lwn9G_stZyHl7Eg1juyV_nlANofFaxXhOGS34iOkQ>
    <xmx:n2zSYzNTK2KiV7yS0J5hGqWJ8-arvbKxYvpVOTwNnrvYKffdlRcoCg>
    <xmx:n2zSYw8DeuL3-5E3MaCOUrxEIJyvTz5plj0t9m8mPSvJylm7Ifw3nw>
    <xmx:n2zSY_nNo1IgU5puRYUSDuMaz0W6ajR7yD_YTQ1cLcvW0jGE-_FHnA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EDB93B60089; Thu, 26 Jan 2023 07:05:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <ec7724da-65ea-45d9-b0b1-990278202ecc@app.fastmail.com>
In-Reply-To: <20230126112130.2341075-3-edumazet@google.com>
References: <20230126112130.2341075-1-edumazet@google.com>
 <20230126112130.2341075-3-edumazet@google.com>
Date:   Thu, 26 Jan 2023 13:05:31 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Eric Dumazet" <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Cc:     Netdev <netdev@vger.kernel.org>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net 2/2] xfrm: annotate data-race around use_time
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
> KCSAN reported multiple cpus can update use_time
> at the same time.
>
> Adds READ_ONCE()/WRITE_ONCE() annotations.
>
> Note that 32bit arches are not fully protected,
> but they will probably no longer be supported/used in 2106.
>

Acked-by: Arnd Bergmann <arnd@arndb.de>
