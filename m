Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B682C586C84
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiHAODO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiHAODN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088CA30F66
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95565B80EBC
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 14:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D432C433D7
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659362589;
        bh=dJpwlpoo8AtUO2dWZqhh/XD4WNKZ8Ynruzb4F/ZFrpE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HtQbRRJOVwkzg6BSZ2q30UwV+kHcr20i7uFOjDH0Oip5FQBlEwyF6bY5cgpczvNTZ
         5dfrepWM0RVoUJlTYd8kBpXwAHw+2YwKZkriDqtW/IJl51XvSCEblp7nowOqSXD03u
         VUIVrmOklMBNMPM79LXHfknqh1xGfiQTusRaaiRi0tnF03RfC2XiwTlvf9n3mZMrkc
         BwiFRkH2gokCSNLv1NReOkZNK+Hy3to9vIIiYrDiFIYPP4Hg5ztoZ74MaFINI96879
         8ZQ0yVj/Rw+wwdTsC2pR13vsEc2YDJHI67dXxhYRgdzv4Pyu/PBcZqIpObv0n2M5wc
         NHHlqrs8mFDVA==
Received: by mail-vs1-f46.google.com with SMTP id k3so11322483vsr.9
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 07:03:09 -0700 (PDT)
X-Gm-Message-State: ACgBeo3cWoRxtjZyP910L9/Q8/u/+5nTggtshhGYikx5s5B2nnfhwnTl
        seSUB6vsfBbCEF+76be2Rj64Ylc+Wo2LL9We6g==
X-Google-Smtp-Source: AA6agR6MvaHAEOfaMrNvpuLg8PnC6Xc1cyww40d0m93Gs/61Jw3HjYyN6FrVRD/Zg2iYdPbCZqk8HKPTggL2qJRGKrw=
X-Received: by 2002:a05:6102:1494:b0:37e:2dc5:870d with SMTP id
 d20-20020a056102149400b0037e2dc5870dmr2442430vsv.6.1659362588106; Mon, 01 Aug
 2022 07:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com> <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
 <20220729170107.h4ariyl5rvhcrhq3@skbuf> <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
 <20220730162351.rwfzpma5uvsg3kax@skbuf>
In-Reply-To: <20220730162351.rwfzpma5uvsg3kax@skbuf>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 1 Aug 2022 08:02:56 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLyCJE2c4ORx-kK1iUMR08iMUMDi0FMb9WeTyfyzO3GKw@mail.gmail.com>
Message-ID: <CAL_JsqLyCJE2c4ORx-kK1iUMR08iMUMDi0FMb9WeTyfyzO3GKw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 30, 2022 at 10:24 AM Vladimir Oltean
<vladimir.oltean@nxp.com> wrote:
>
> Hi Rob,
>
> On Fri, Jul 29, 2022 at 12:39:06PM -0600, Rob Herring wrote:
> > All valid points. At least for the sea of warnings, you can limit
> > checking to only a subset of schemas you care about. Setting
> > 'DT_SCHEMA_FILES=net/' will only check networking schemas for example.
> > Just need folks to care about those subsets.
> >
> > I'm not saying don't put warnings in the kernel for this. Just don't
> > make it the only source of warnings. Given you are tightening the
> > requirements, it makes sense to have a warning. If it was something
> > entirely new, then I'd be more inclined to say only the schema should
> > check.
>
> How does this look like? It says that if the 'ethernet' property exists
> and is a phandle (i.e. this is a CPU port), or if the 'link' property
> exists and is a phandle-array (i.e. this is a DSA port), then the
> phylink-related properties are mandatory, in the combinations that they
> may appear in.
>
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 09317e16cb5d..ed828cec90fd 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -76,6 +76,31 @@ properties:
>  required:
>    - reg
>
> +if:
> +  oneOf:
> +    - properties:
> +        ethernet:
> +          items:
> +            $ref: /schemas/types.yaml#/definitions/phandle
> +    - properties:
> +        link:
> +          items:
> +            $ref: /schemas/types.yaml#/definitions/phandle-array

'items' here is wrong. 'required' is needed because the property not
present will be true otherwise.

Checking the type is redundant given the top-level schema already does that.

> +then:
> +  allOf:
> +  - required:
> +    - phy-mode
> +  - oneOf:
> +    - required:
> +      - fixed-link
> +    - required:
> +      - phy-handle
> +    - required:
> +      - managed
> +    - required:
> +      - phy-handle
> +      - managed
> +
>  additionalProperties: true
>
>
> I have deliberately made this part of dsa-port.yaml and not depend on
> any compatible string. The reason is the code - we'll warn about missing
> properties regardless of whether we have fallback logic for some older
> switches. Essentially the fact that some switches have the fallback to
> not use phylink will remain an undocumented easter egg as far as the
> dt-schema is concerned.

dsa-port.yaml is only applied when some other schema references it
which is probably based on some compatible. If you want to apply this
under some other condition, then you need a custom 'select' schema to
define when.

Rob
