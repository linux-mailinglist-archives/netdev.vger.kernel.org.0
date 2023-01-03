Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA0765C580
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbjACR5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbjACR4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:56:48 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B296D1147B;
        Tue,  3 Jan 2023 09:56:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j16so12413924edw.11;
        Tue, 03 Jan 2023 09:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p7a1U2/c7WJv3NEBfJYAOixnmGcKLo0CuycVU47++aQ=;
        b=aKwytJh4KX20LXxOryZJE0HuJG5HcaCeIxX3tFX5yZz0gEhN3vG/Ugzp3jfNHHAfFZ
         zpCCt+btieU/rdBGPWbe3sejqYvYS8FTg2R49yHZy6jaIbMe+hPE/DtWRavxYZwoIN0T
         QVzbnO8+eVVo9l/ID7dtlfG3fmFswrJrboaiZ3nNEzQHN+QM9WO5pCpA1f5g1joQhIXW
         l72WenGT/6K3hPFCxw3kIKLiLCVK3azdhhESTO51lnjK++sWuiMrmBZf4WNy7jNIp7fY
         YzJXiRkbxN0lvgynjSnG5SWR5+Uu2VYbKX6KvdPUI1pO/IiTONJIZdImNLn22/Eq/9AP
         aWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7a1U2/c7WJv3NEBfJYAOixnmGcKLo0CuycVU47++aQ=;
        b=Zq76Uzozq1s77vV07YW7Y6sN1jgMdeNPclu8K9ZPyDaI6RN7Hu/W869l+xUXUZ5S1+
         1e9wimXnwxgFkkhynGFpCQXTL9w2+AbYH1j0Yhon5+3mZXBxEJXWTpR9j2wLVGt2KWko
         gfvRSJLidEROVAIT5tzbsso/vl7s9iFCoCEfkYmqqPsuScYu89MTE25rQEMTBu33jUpN
         +uP3rfTPFDwzfPzVLAOW6Jn2PJikXfHXmqnt+Xjeu5NDohYaOt5LF0v/pdUGDdjrh656
         58GUpM4lQvHfDh9BBI4ZoPf914I2UPUbg0vBJQBbqPWelgMWy2KBAbGSs0oCBTCwaCFs
         m7FA==
X-Gm-Message-State: AFqh2kqvB2H2atkTy4ZwZqpaji8apBvIngX31LcOdnAYdmYGuCnCi3Q9
        24xneICgEnFaU8xOPHG+57Y=
X-Google-Smtp-Source: AMrXdXtEtXWdICTqd1aomJDuH7ZCpdFY3T3zFdVGv7z0OI1uDhXO0zYB+HaMBkbXi0VNrPwD5wFXmA==
X-Received: by 2002:a05:6402:390b:b0:465:f6a9:cb7b with SMTP id fe11-20020a056402390b00b00465f6a9cb7bmr39249116edb.12.1672768605161;
        Tue, 03 Jan 2023 09:56:45 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id h14-20020aa7c94e000000b0046f77031d40sm13864230edt.10.2023.01.03.09.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:56:44 -0800 (PST)
Date:   Tue, 3 Jan 2023 19:56:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v6 net-next 09/10] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <20230103175641.nqvo2gk43s3nanwg@skbuf>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
 <20230103051401.2265961-10-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103051401.2265961-10-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 09:14:00PM -0800, Colin Foster wrote:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> new file mode 100644
> index 000000000000..126bc0c12cb8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> @@ -0,0 +1,25 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Generic Ethernet Switch Port
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vladimir Oltean <olteanv@gmail.com>
> +
> +description:
> +  Ethernet switch port Description

Still doesn't look too great that the ethernet-switch-port description
is this thing devoid of meaning. What is said about the dsa-port is what
the description should be here, and the description of the dsa-port is
that it's a generic Ethernet switch port plus DSA specific properties.

> +
> +$ref: ethernet-controller.yaml#
> +
> +properties:
> +  reg:
> +    description: Port number
> +
> +additionalProperties: true

Also, I see your patches are deferred in patchwork, and while this isn't
really for me to say, presumably it's because there was no announcement
so far that net-next reopened.
