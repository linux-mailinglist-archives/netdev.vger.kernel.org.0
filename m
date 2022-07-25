Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E8A58046C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiGYTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGYTV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:21:26 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8531CB849
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:21:25 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-31bf3656517so120660457b3.12
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hn2H0iVej6Wh/Yog/voUukpZbEj+hGvX+0JEDLt42s=;
        b=KsMmnlTZUHunNcw7VBpuZz//FWKBY5kK79Ly0GRYD+i7aVM3CpIaQjn8fY1viqfitO
         U2THJkKUet9eAOTF/pEUxSR0OrniX6sJp8zSDBEGkPibxlNNX8tHooW0Z/sFidZsWqY2
         3R7nUQIloSz6YONbgok/lg0D5qLirAnE1A+EMs8MpUqwpSDTMGMnOZVuOEPH9gjWfB2A
         eQqZPYVUvBj7BKj363UFdGGhW0d3706XtlFXP8OIdux5gs+3kzEXXUpJjvuHMQvjR28Q
         IjlUYjvq412Mb8KBBxxco+cLYVZCMsuNvHWjQhFc6t1kSL6elNHQxYMXabTxtElEyXLQ
         Yi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hn2H0iVej6Wh/Yog/voUukpZbEj+hGvX+0JEDLt42s=;
        b=COdpEY3/BpnXI/C4/eZ+Twq+2vfxtRcdYx9GzXBBOZh2SXqmTaUxlCLA1Kq3na+d1v
         EPDPVHZYmB4P1UfWWIvNs7JyegEVkZ8chCtDfPGqXQW6BewpKgyvfC93N4rDqvfqURDo
         MUbxerueAVZyzUt8CVvhrzWe3vqJDoNXwqcJOalrhfX4Ly2Tk3T4ePBqCqyewEnui+sB
         /zYMxqAAKg/74nhPW0NfTPK2DUv4N4GJPQgZPPsQu30sQyzJbrkAH3MQtYe6PyiK0gay
         gTWiLtSU6mOsPHAW6HEDZT4499/kH5qo1Er4FUH7xQcb1PtINJCYJ9waaJ3kodnrLfus
         JX2Q==
X-Gm-Message-State: AJIora+60ui617oh5QD+0gKCDCsogSQzpx/CCNLjMdjFkINxlwo72Y+I
        SOajvU+M0EuN3MGsH6SaoEKqFZakHrXuYiz4rWA=
X-Google-Smtp-Source: AGRyM1vjqsGTuA7iLMZ2dIuxBXysjVswliMlBDNhpZmesMRDB5PilYsJ+E2QHT/EoQ7lwQ0hDaEN/ikaOtDFF/qgxGs=
X-Received: by 2002:a81:3608:0:b0:31e:7204:4021 with SMTP id
 d8-20020a813608000000b0031e72044021mr11254414ywa.1.1658776884697; Mon, 25 Jul
 2022 12:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 25 Jul 2022 21:21:13 +0200
Message-ID: <CAFBinCCVwOipoxnLYQZ3-q6dR5ZOPg3Ay1nxu8Ya+OeNN8+9kw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Jul 23, 2022 at 6:47 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
[...]
> lantiq_gswip
> ~~~~~~~~~~~~
>
>     compatible strings:
>     - lantiq,xrx200-gswip
>     - lantiq,xrx300-gswip
>     - lantiq,xrx330-gswip
>
>     No occurrences in mainline device trees.
>
>     Verdict: opt out of validation, because we don't know.
Downstream OpenWrt uses the same format as documented in
Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
A fixed-link is not present, meaning that it's good to opt out for now.

I added a TODO so we can fix the .dts downstream in OpenWrt.
Upstreaming the .dts files from downstream is also on this ever growing list...


Best regards,
Martin
