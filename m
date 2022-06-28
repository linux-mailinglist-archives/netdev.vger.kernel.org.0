Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EF555E821
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347975AbiF1Pii convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 11:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348043AbiF1PiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:38:23 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5E130F70;
        Tue, 28 Jun 2022 08:38:12 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id z7so9963537qko.8;
        Tue, 28 Jun 2022 08:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PA6RIN6Q6sRWIrEsm5s1AcE8++ST1RljVs/MQH6vQEQ=;
        b=ujVxzrKl4GrQu/B10j7Aa3aV8mioizDpfqdGzYwO7CKqe52EWg10h6l9Ua9WjoL5v0
         03Rzn4Mx+2pr47YCUiULW9DgxAhDBwbDq+l9vLyyKYgqcXqtSi3FUN8VPVbqTIXMT4T8
         yZu7IHtWmiMbJhw61rEIqMj0elZd1axBttRdQSThIyMfCEHFocj90bA/BNU4sanYoYKI
         LM0dKpHMoWCAveTsv085fFXq8NtmDY9Ex/dCeSPVHdP8PknYNDjN+gJddPHwu0HhYgLQ
         CjAT1gjJ7FcUdAg89LbAEf+iqmJJDx/BpPnOg0tjGUPWkdNJZCI64lX5mgLGn/+yg2Yv
         wnag==
X-Gm-Message-State: AJIora9br8X3L7dl/YqSbY3QkndrJna4mNPS+MJZu7S4NlvZO4DKxYaI
        ySNRb70z1b209epYk4Q6y+pNryBBcZ5oWw==
X-Google-Smtp-Source: AGRyM1sDlf+YctAWsXQiPlnr2kbr5nVCGJs/M38PeqAmBsojGNx0Q42Tr8T2i6GeimJXg9tvWVKO+w==
X-Received: by 2002:a05:620a:4402:b0:6af:1b92:f064 with SMTP id v2-20020a05620a440200b006af1b92f064mr9556442qkp.410.1656430691586;
        Tue, 28 Jun 2022 08:38:11 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id z198-20020a3765cf000000b006a736c8ea80sm11285850qkb.48.2022.06.28.08.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:38:10 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-31bf3656517so30463577b3.12;
        Tue, 28 Jun 2022 08:38:10 -0700 (PDT)
X-Received: by 2002:a0d:c787:0:b0:31b:a963:e1de with SMTP id
 j129-20020a0dc787000000b0031ba963e1demr14919177ywd.283.1656430689886; Tue, 28
 Jun 2022 08:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-7-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-7-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 17:37:57 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU9fpY5b9GGFYQ50KmFNu35J5d129F=9=LYZEN82R=cfw@mail.gmail.com>
Message-ID: <CAMuHMdU9fpY5b9GGFYQ50KmFNu35J5d129F=9=LYZEN82R=cfw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 06/16] dt-bindings: net: dsa: add bindings for
 Renesas RZ/N1 Advanced 5 port switch
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Fri, Jun 24, 2022 at 4:41 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas RZ/N1 Advanced 5 ports ethernet switch
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +description: |
> +  The advanced 5 ports switch is present on the Renesas RZ/N1 SoC family and
> +  handles 4 ports + 1 CPU management port.

While diving deeper into the RZ/N1 documentation, I noticed the switch
has 4 interrupts, which are currently not described in the bindings.
Presumably the driver has no need to use them, but as DT describes
hardware, I think it would be good to submit follow-up patches for
bindings and DTS to add the interrupts.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
