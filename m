Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E646951FB36
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiEIL0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiEIL0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:26:19 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019DF1AF8EF;
        Mon,  9 May 2022 04:22:23 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2f7c57ee6feso140409107b3.2;
        Mon, 09 May 2022 04:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHcyRb0A9TdQ3ZPZeebW28t674FP8onCU6WazLElK4U=;
        b=Cg6+le4ubJ1hcAxrmpylHiTdhVQUuoVW9aEA+iFxxELX6T+A4h3sE6HzJqz6D1834F
         Vx852sLUvU75YM1EVCdR4NV8kKrypKVn92RyNlAOS9M/o44QTnUE20FPvKpm1XQxUYJW
         g//yWu3fDYLTb3vTadJXQak2SIfU1HZVuqSYA+8SMRH0lJUUni9hHCXB+GiXgxj30JQY
         MPMpNGvS1vf3cEx7wxeGs6k9pFp1EISW9qGofMa6X6OK8pYs754hPRo/DOu9uAAaW7jG
         NgZlSz7Ib0BwyYgSAhHCydm2MqJkySpOzsONRp9HWwW6epPyZkaSeuT7JdHX8TdYf29i
         NHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHcyRb0A9TdQ3ZPZeebW28t674FP8onCU6WazLElK4U=;
        b=THmvn6kXYdofFrj4qm8fQwp5y0YmBbeXk8JFdgXKhbAjztLpacIzRCZbV6c4Lqi2cy
         0jKzvNNW5L7jMQPEf2/ZkZmq7sJhc+XUgEzUqkt15sahWYnzNsbP1OSO9BcsTE4Ts1ob
         lBAhMc3Z83B64rmHlY4j50lwQYRmKk4KisfgjrRepys9sgpUANW5zIu4c2PV2WidvwCw
         yOCbgq4abS9gfSelI/yp+YBKwWxMtqZbPCPTCdNcMWU4a9C63HJegtrP8xfUneyjhdTF
         1iEwjz63do/vRQdxPqQ07+8Voy9fR0HZS6yfJ/h4ui6Uw3HblKBiAbez6vl/nlf6V3FZ
         CWdA==
X-Gm-Message-State: AOAM531AD7NPx3E82HyC6mRERZy8/Tjk4JIxvfdo+JsF9EskP72XhM1a
        XU7dLV5Uys/b8vp1a4DD6wdYjZ+BnSpUbaJpuDQ=
X-Google-Smtp-Source: ABdhPJz3TmYnVu7MVB0CYjUmpfm9sDvGiFsAxvCb7o+aew79C34oQx2aF8SKyaY9aCiZum4rKA8OI5Xm2KcEiO3AYls=
X-Received: by 2002:a05:690c:89:b0:2d7:fb7d:db7 with SMTP id
 be9-20020a05690c008900b002d7fb7d0db7mr14793757ywb.219.1652095341920; Mon, 09
 May 2022 04:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220507170440.64005-1-linux@fw-web.de> <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
 <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de> <2509116.Lt9SDvczpP@phil>
 <trinity-7f04b598-0300-4f3c-80e7-0c2145e8ba8f-1652011928036@3c-app-gmx-bap68>
 <CAMdYzYrG8bK-Yo15RjhhCQKS4ZQW53ePu1q4gbGxVVNKPJHBWg@mail.gmail.com> <41d6b00f-d8ac-ca54-99db-ea99c9049e0a@linaro.org>
In-Reply-To: <41d6b00f-d8ac-ca54-99db-ea99c9049e0a@linaro.org>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Mon, 9 May 2022 07:22:11 -0400
Message-ID: <CAMdYzYomJPxQ7cnUuP_T7-rVbYPeZwr13Dy6b=PP4ijqQfh5gg@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add
 rgmii-mode to mt7531
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 2:48 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 08/05/2022 19:04, Peter Geis wrote:
> > On Sun, May 8, 2022 at 8:12 AM Frank Wunderlich <frank-w@public-files.de> wrote:
> >>>
> >>> I think the issue is more for the description itself.
> >>>
> >>> Devicetree is only meant to describe the hardware and does in general don't
> >>> care how any firmware (Linux-kernel, *BSD, etc) handles it. So going with
> >>> "the kernel does it this way" is not a valid reason for a binding change ;-) .
>
> Exactly. The argument in commit msg was not matching the change, because
> driver implementation should not be (mostly) a reason for such changes.
>
> >>>
> >>> Instead in general want to reason that there are boards without this reset
> >>> facility and thus make it optional for those.
> >>
> >> if only the wording is the problem i try to rephrase it from hardware PoV.
> >>
> >> maybe something like this?
> >>
> >> https://github.com/frank-w/BPI-R2-4.14/commits/5.18-mt7531-mainline2/Documentation/devicetree/bindings/net/dsa/mediatek%2Cmt7530.yaml
>
> Looks ok.
>
> >>
> >> Another way is maybe increasing the delay after the reset (to give more time all
> >> come up again), but imho it is no good idea resetting the gmac/mdio-bus from the
> >> child device.
> >>
> >> have not looked into the gmac driver if this always  does the initial reset to
> >> have a "clean state". In this initial reset the switch will be resetted too
> >> and does not need an additional one which needs the gmac/mdio initialization
> >> to be done again.
> >
> > For clarification, the reset gpio line is purely to reset the phy.
> > If having the switch driver own the reset gpio instead of the gmac
> > breaks initialization that means there's a bug in the gmac driver
> > handling phy init.
> > In testing I've seen issues moving the reset line to the mdio node
> > with other phys and the stmmac gmac driver, so I do believe this is
> > the case.
>
> Yes, this seems reasonable, although Frank mentioned that reset is
> shared with gmac, so it resets some part of it as well?

No, the gpio-reset line is purely to reset the phy. The stmmac gmac
driver handles it because it seems initialization failures occur if
it's handled by the mdio drivers. I suspect this is due to a
difference between when the driver initializes the phy vs when the
driver triggers the reset.
They had tried to attach the gpio binding to both the gmac node and
the mdio node at the same time when only one can own it. Having it
owned by the switch driver on the mdio node leads to the same
initialization failures we see in other mdio drivers.

>
>
>
>
> Best regards,
> Krzysztof
