Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4AF5807C8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbiGYWtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiGYWti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:49:38 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4610B0;
        Mon, 25 Jul 2022 15:49:37 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E573C320090E;
        Mon, 25 Jul 2022 18:49:32 -0400 (EDT)
Received: from imap43 ([10.202.2.93])
  by compute2.internal (MEProxy); Mon, 25 Jul 2022 18:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658789372; x=1658875772; bh=ND
        s6eODdn2bexcjuNKFWjUTcea0bQW5OWSmo8ftc1/g=; b=zu146mCcQc1T9H7Y/Z
        7j1DVU1UX8Q2ZohlvLcSWonP7z5rmGLaV5AzYQ/SJxuKxtd9d0ukJUn6twVXAZPI
        STTxLSLUdRjtHug88sM5T6J2cXWp9swCGPpwU6Vac0i1qyTWa2OYgmUtunC+ZPrM
        VAuxbP89C80fOYMm/oUd9Ng+ZVx0ReC7WsG2QQatpRjvQdLN3iGdNuqJIKWUsM66
        bJlrMdzbmP7vov8CbT0lCGk5Y+AKNQa6wqk8Y4GnSLgYKzeOn4WwSZgI1h2Wu9vc
        /E9PQjTyzPew78Z9p2OEBYgNGEZTxf3zI+TnGpGNAQPhUR/Rq+X4yKzw2lY022WO
        ZDvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658789372; x=1658875772; bh=NDs6eODdn2bexcjuNKFWjUTcea0b
        QW5OWSmo8ftc1/g=; b=Lp0QAv5sz2CbyyZiVx0PLOnJU39P11Pq190bzsC5pIZL
        /XsNGrk0F1VH3O18JmhHdRBv4JupuE/SEOXMcgKrwIegANR8mEEV+gq6l0zBP4gL
        uq6mhJHpMybVH9143OEtMBCNL1SOE0Px3tpXj8NlP64KO3YNt9tazxAq/rXZGs5L
        jRz3BR/N7j7EBngpfNtGIRXhVXknisZ6DM0xI8qa8wxuTMbFFikvJa1gNEHgHDYi
        tdDhHjLuhZwT+y8NcJo45PyECJC1uSeE1G5kcYArQwqTjdtVQM2M/AKb5ZWCb4C8
        H1CWVxmoUV8Bmssz0Lc2va2MeI4lr4GpyqUV5nAplQ==
X-ME-Sender: <xms:_B3fYn2eb6G-FmB2gZvefgAfbw-ytSrx-WhQu1AUl7YemxtfbUT70g>
    <xme:_B3fYmHlHM5QEenUZU7B3MCagd5uIIg5DsYEJ_de0J_YtKD1X3m4QZtUb8XxORbkB
    1ZrsirDIBvwSGwq-To>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtledgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpeetlhhi
    shhtrghirhcuoegrlhhishhtrghirhesrghlihhsthgrihhrvdefrdhmvgeqnecuggftrf
    grthhtvghrnhepueekffekhfejteehtdeigedujeevvdfhjeelkeehfefhudffhfejgfej
    ieehhefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghlihhsthgrihhrsegrlhhishhtrghirhdvfedrmhgv
X-ME-Proxy: <xmx:_B3fYn4oL0MGX6gx_0Td1RJui8sxWd1bLwjeGoV9qMzfhvL3HuDMkg>
    <xmx:_B3fYs3dgNZtn0RUrr1FvaKFb0tsoInl9T2JRpnio77FdAawv3S6_A>
    <xmx:_B3fYqFiZJcltk0TnWy_9WftQWH9g4cpBfgKxFQjH_4hiJCB5TwHIQ>
    <xmx:_B3fYhcbdoPXUCQkCnwuH-be5R5FfON6l48MSSb9ebdUau6_FCOj7Q>
Feedback-ID: ifd214418:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 03E322D40074; Mon, 25 Jul 2022 18:49:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-757-gc3ad9c75d3-fm-20220722.001-gc3ad9c75
Mime-Version: 1.0
Message-Id: <9820e03f-8e81-4dc8-ae21-82a21c830278@www.fastmail.com>
In-Reply-To: <20220725055059.57498-1-samuel@sholland.org>
References: <20220725055059.57498-1-samuel@sholland.org>
Date:   Tue, 26 Jul 2022 08:49:11 +1000
From:   Alistair <alistair@alistair23.me>
To:     "Samuel Holland" <samuel@sholland.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     linux-bluetooth@vger.kernel.org,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Vasily Khoruzhick" <anarsoul@gmail.com>,
        devicetree@vger.kernel.org,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: bluetooth: realtek: Add RTL8723DS
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022, at 3:50 PM, Samuel Holland wrote:
> RTL8723DS is another version of the RTL8723 WiFi + Bluetooth chip. It is
> already supported by the hci_uart/btrtl driver. Document the compatible.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Alistair Francis <alistair@alistair23.me>

Alistair

> ---
> 
> Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> index 157d606bf9cb..8ac633b7e917 100644
> --- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> @@ -20,6 +20,7 @@ properties:
>      enum:
>        - realtek,rtl8723bs-bt
>        - realtek,rtl8723cs-bt
> +      - realtek,rtl8723ds-bt
>        - realtek,rtl8822cs-bt
>  
>    device-wake-gpios:
> -- 
> 2.35.1
> 
> 
