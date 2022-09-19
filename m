Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE155BD2B5
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiISQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiISQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:56:19 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0A62D1D8;
        Mon, 19 Sep 2022 09:56:16 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F2EBF5C03F5;
        Mon, 19 Sep 2022 12:56:15 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 12:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1663606575; x=1663692975; bh=Lt
        Q0DLuSXvYNpp6h6u8UcE3CM907DFTu5M1mUT8X5J8=; b=hQD3O5xw7mveu5YLDL
        vmdvFfjUn7VEveiuegGdwWh+IVhRKde7r4yf7YkDU1P1WHMXDC1Lc2bHnQu24jL7
        Se+/jGA6JvdexhWgsr84V/iYjwWNEV2TQ4qGfXX5bbwDAs+rJQx7fAKIkDinAZz9
        rUhKhCSngkW8hPez5UknVLx2tXU1RJ/DOapmGUxN94yVoUcOVXOpldyra+P9RmZD
        eVpiKeLkZQ8Tc4kc1WwasnTFCKU4JjIHJtOC60NOBmclnCplNUqAUKYhfmADzpFh
        eQZo0ksA2QX4EZ7Dgiwy1K2/lpxYITwy7aaW+FizGyb3LplKe34dE23yUod3KQVg
        +rwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663606575; x=1663692975; bh=LtQ0DLuSXvYNpp6h6u8UcE3CM907
        DFTu5M1mUT8X5J8=; b=PW5Q+G5BpLu8W+HJM+9RogC1e1vTA+z0Skq59YfcwDC4
        PMQMk56C9srehJ8ibVpy72D96OTkGB4Wok1T8Y+qXqafsnjD9WgfOaMKoXDEEHyV
        Ao6k1I9jVXfsZtNndIAkxcoWEUCK+wyWpJPwptqJ6bAjteiq+Fc+0IexaHmey8X3
        asoavoAQTUMHLqosDiAvhWZm34eTW0q3G80k+s384W6pGNVHnIE6NOKCw0Vo7sBm
        vxg5q/Ei//fcnnWHHWJYABK1d8d6uGvmnHZd5Na/Pok+9vZZjmdZvo2A5j4uEfqj
        px9Rnqp4IHcLjdOgmcMQ/AT3K8S7ZONassas9nAiWg==
X-ME-Sender: <xms:L58oY7x92uJP0wA96kefexThi9fP_avH7-Ezt9-cATFmXQ6IAreoKA>
    <xme:L58oYzSNRB0ye8viq0m1rVY6IRGXmT8CQZYO3c2I03sOIi5RGFkZpBn9XEyde4uWR
    y-tCvNgKmnt4l_IP0Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfu
    vhgvnhcurfgvthgvrhdfuceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtf
    frrghtthgvrhhnpeekleekudelvddvhfefhfelgffffefgvdehjeegjefhheejjefgffef
    ieejtdetjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghr
    rdguvghv
X-ME-Proxy: <xmx:L58oY1UvXUj5_qinYbzuqFXjoZ-DlplIiIqHdM7VT107cwqSkqfptw>
    <xmx:L58oY1jxciWTPHI6Cl3UAAdsj187O-gD0e9YnRXI8GggNgQR2-1-sg>
    <xmx:L58oY9CWKUDPLDfKLg2Ynzlrsupyg3jqts01hStBxaMoSNt00iCMBA>
    <xmx:L58oY1YUZAM0sebk1OEOBf3sZoDr55IneDB877oKpz2YP_qByVadBQ>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A7601A6007C; Mon, 19 Sep 2022 12:56:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <4910f728-843a-4546-8aa8-69d5faadc92f@app.fastmail.com>
In-Reply-To: <20220919164834.62739-1-sven@svenpeter.dev>
References: <20220919164834.62739-1-sven@svenpeter.dev>
Date:   Mon, 19 Sep 2022 18:55:55 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Hector Martin" <marcan@marcan.st>,
        "Alyssa Rosenzweig" <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Broadcom/Apple Bluetooth driver for Apple Silicon
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022, at 18:48, Sven Peter wrote:
> Hi,
>
> v1: https://lore.kernel.org/asahi/20220801103633.27772-1-sven@svenpeter.dev/
> v2: https://lore.kernel.org/asahi/20220907170935.11757-1-sven@svenpeter.dev/
>
> Here's v3 of the Apple/Broadcom Bluetooth series. Again most changes are
> to the device tree bindings. I've also included the changes to the dts files
> that I forgot for the last two versions.
>
> Additionally I had to introduce another quirk since these controllers also claim
> to support MWS Pattern Configuration but then simply disallow that command. This

Apologies! This was supposed to be "MWS Transport Layer Configuration" instead
of "MWS Pattern Configuration". I just miscounted bits originally and
forgot to update the cover letter. The actual commit has the correct name
though.


Sven
