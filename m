Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C52055ED8A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiF1TFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiF1TFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:05:00 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CB32AC62;
        Tue, 28 Jun 2022 12:05:00 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o19so17288304ybg.2;
        Tue, 28 Jun 2022 12:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Zl+moasg9AqPTPegEICVFTHtbVUjAEJPFk3onwrXBw=;
        b=pcNJ8YCPNqwvLMCdGbtF3YyVMVobSrYBI9yPpbm1TjbRifyIrilXR5jsUPkapDyw+t
         Gww+xRZZ6oC3EpAVOSLPZt33iXTFeYtzR+s0DFJh+c+e5TZR9jxLxIdWJYC8rr7T73Pt
         AUsXsJ4gRrWsW1cqnWY0l6LST31H7ZX8mFTMzm7S7vF7ytQtwRsiHcEG0/4sAy1b8607
         ct0jFspvMILYdSTH6Oayc8BvaUdzUJwgKWYSxw4O7ny7++Cr2+y3stKQ/F/hKJk2JFnH
         FBK3ZfD3jTviYLk91lIb6dn21MB/wGBB1Ur+MCEQAl/rhx8lodnJD/TxRbzG6ka+EnNf
         MyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Zl+moasg9AqPTPegEICVFTHtbVUjAEJPFk3onwrXBw=;
        b=vpXItwhI9WMFmXv0n5aX0Aea5oZIr1p9YqCO4KoS8PLyJ1YyZhLnSvkW/0+fk3KMxX
         v65ZBvx9dJAAuuwowFpnHpztlXHpj4CL1uAGfDAkBWy0QNw4+jINpsbVG9GQ39RfKrF/
         yIi56VlUi1KAW6pvQdaGaBYOiXtfMtcnBjqmY+2KoO39NOOGUzrkjS1eq2MFnmCuAFJi
         KV1qB88rESdFPtx8i2e4xeVRKP7y/vq/wKi0OvcwDIiPZj5v2yNdKC9ttZz1/BIQ9BSu
         dzDsEUu5dQqjIrwYn1GSSa1ZD+5ievw3jo/Y0GI5+qEJG6+skFFgG+0c4aCpd0fuTvTp
         BAYw==
X-Gm-Message-State: AJIora/S6OB5TUK3oMtG5FppWOgSN8niFHMmf03dETsXKB15tWoKqg/J
        SAIE7SNKIqkR9wykE7YQ/PCqBwsMI2BUkrfd+Y4=
X-Google-Smtp-Source: AGRyM1vbAwF4/Bjc2ysiCNPEvFlv4daP3qklzpaXvWMPvBhblbbJEY7NeSnW3JizEN7YOw+vtRMIn0+G4wYCyvCjaXw=
X-Received: by 2002:a05:6902:c4:b0:64b:4677:331b with SMTP id
 i4-20020a05690200c400b0064b4677331bmr21369611ybs.93.1656443099200; Tue, 28
 Jun 2022 12:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com> <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler> <20220628184659.sel4kfvrm2z6rwx6@skbuf> <20220628185638.dpm2w2rfc3xls7xd@skbuf>
In-Reply-To: <20220628185638.dpm2w2rfc3xls7xd@skbuf>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jun 2022 21:04:21 +0200
Message-ID: <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
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

On Tue, Jun 28, 2022 at 8:56 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Tue, Jun 28, 2022 at 09:46:59PM +0300, Vladimir Oltean wrote:
> > I searched for 5 minutes or so, and I noticed regmap_attach_dev() and
> > dev_get_regmap(), maybe those could be of help?
>
> ah, I see I haven't really brought anything of value to the table,
> dev_get_regmap() was discussed around v1 or so. I'll read the
> discussions again in a couple of hours to remember what was wrong with
> it such that you aren't using it anymore.

It would be nice if you can comment after here to clarify that.
Because in another series (not related to this anyhow) somebody
insisted to use dev_get_regmap().

-- 
With Best Regards,
Andy Shevchenko
