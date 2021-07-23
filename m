Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194273D432D
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhGWWPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:15:55 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45323 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233019AbhGWWPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:15:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id F1E32582A2B;
        Fri, 23 Jul 2021 18:56:24 -0400 (EDT)
Received: from imap43 ([10.202.2.93])
  by compute3.internal (MEProxy); Fri, 23 Jul 2021 18:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=mime-version:message-id:in-reply-to:references:date:from:to
        :cc:subject:content-type; s=fm1; bh=tTFd1PFlfcqw1vOZmALYMCCs5zoz
        hzoIchbtUK3cuNM=; b=i2GSngfh75gIui2mKvjPZkl8T9UqCsl31F/PQxgHMQgk
        enWrowA9Bb73cLrPztR8pAnKoZO9pjwBqMTj6VHPJq0ceBV7aG/ldVuK4bjDljXK
        0AIQb+35ZfH5VF25DC94yUyknAgyZiARgODGUxPF0lk6KjPuFgofzGw0SgvY2cTY
        BrdQYlaw074S4yoUYRUDc8ATKLZn4atuSGXe/r22ixXoyi0ZfrtmjYwb/hkFLJkZ
        hfVdk0LgIimeTOExWnD4weFJWdDuSMqk3BUlfywC3CVojzXQWUHke/f9NkZjpVle
        OM3P/XO5RYzaGLa8Jo/5RZNjgXM7e+4UJ6edCzC5dQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tTFd1P
        Flfcqw1vOZmALYMCCs5zozhzoIchbtUK3cuNM=; b=fYenRrrkR8x34dU03tKL0j
        4wbS284Hy28votnVcHS9AQBdc+239YYufMqud6o5vPDdZHJt38+Rkz2cOoeUEDCF
        dw2+dMKUJJfcrOBBjCaY2NWEFAVrv1tfYojqXa4GmQ9LsNFNtl+JECR5ojZXfQya
        Mnjb+9QoDuvnNoUZTkgwLpf5InzzBmR8uCEGUxwYjavRsf9fIVVROVK76ob9ox6n
        QVOx+HFIW4lwKLdEQi5yLmqp3EMZmXsKg9RwwcerZmqpicfTzROQ1pruJdZOclp9
        eMTIY/oJDD7kssFe1eU0CY8tuSJOzPAvUWL+PuhbQnXcX2HxwwlqjZTvKriCDITw
        ==
X-ME-Sender: <xms:F0n7YIU_5LGG2Pv7p7sjJS5WAP_XkROS8JCrwq-HdWrpT84UEDh9NA>
    <xme:F0n7YMml0vsRKjDaWNnSL9nHkQjjSNy0TPJtIhsjnwa9UbWTjWYYMbjWz12lDE0UR
    CmjU6WubMtEe1EWU3Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeelgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpeetlhhishht
    rghirhcuoegrlhhishhtrghirhesrghlihhsthgrihhrvdefrdhmvgeqnecuggftrfgrth
    htvghrnhepffehffffleduieeitdehudelteevueevgeduuddtjeekvddvvdeugfeludek
    hfehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlihhsthgrihhrsegrlhhishhtrghirhdvfedrmhgv
X-ME-Proxy: <xmx:F0n7YMaET5SUJLMmLdq5PpPT3qTVmNumWhAj0KUdRHTNXsbRe9YJtQ>
    <xmx:F0n7YHXYkPbX0MC-M7aKRx3A0HyhLlJqWqEwJv9sukDF7FTKHradZw>
    <xmx:F0n7YCkMRVyVGStVp-JbENQ8474khlhGlj0Xu0pRSC1DVUNIipev2g>
    <xmx:GEn7YM4qoeiwEFAWohLF3Byr4Do6cfHYJ_W301sNEdSxJajolSkPnQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 91AA0AC0DD3; Fri, 23 Jul 2021 18:56:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-540-g21c5be8f1e-fm-20210722.001-g21c5be8f
Mime-Version: 1.0
Message-Id: <a3605b89-6db0-41d6-9170-06711fe7384a@www.fastmail.com>
In-Reply-To: <20210721140424.725744-9-maxime@cerno.tech>
References: <20210721140424.725744-1-maxime@cerno.tech>
 <20210721140424.725744-9-maxime@cerno.tech>
Date:   Sat, 24 Jul 2021 08:56:02 +1000
From:   Alistair <alistair@alistair23.me>
To:     "Maxime Ripard" <maxime@cerno.tech>,
        "Chen-Yu Tsai" <wens@csie.org>,
        "Jernej Skrabec" <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, "Rob Herring" <robh+dt@kernel.org>,
        "Frank Rowand" <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, netdev@vger.kernel.org,
        "Vasily Khoruzhick" <anarsoul@gmail.com>
Subject: =?UTF-8?Q?Re:_[PATCH_08/54]_dt-bindings:_bluetooth:_realtek:_Add_missing?=
 =?UTF-8?Q?_max-speed?=
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021, at 12:03 AM, Maxime Ripard wrote:
> additionalProperties prevent any property not explicitly defined in the
> binding to be used. Yet, some serial properties like max-speed are valid
> and validated through the serial/serial.yaml binding.
> 
> Even though the ideal solution would be to use unevaluatedProperties
> instead, it's not pratical due to the way the bus bindings have been
> described. Let's add max-speed to remove the warning.
> 
> Cc: Alistair Francis <alistair@alistair23.me>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Reviewed-by: Alistair Francis <alistair@alistair23.me>

Alistair

> ---
> Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> index 4f485df69ac3..deae94ef54b8 100644
> --- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> @@ -34,6 +34,8 @@ properties:
>      maxItems: 1
>      description: GPIO specifier, used to wakeup the host processor
>  
> +  max-speed: true
> +
> required:
>    - compatible
>  
> -- 
> 2.31.1
> 
> 
