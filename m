Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF71563B36
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiGAUm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiGAUmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:42:24 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6983D5A2F6;
        Fri,  1 Jul 2022 13:42:23 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id d145so2757156ybh.1;
        Fri, 01 Jul 2022 13:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yp9XN4S+Opt5OiPcD1GcnJhSinyAA39zjfk4/yaqO8s=;
        b=SSa3GZ+C8FrgSyg1dfnwW60dlyF0osSJcGZGmfieTSZO8LN1tTnuBZvrpmznVl6l5B
         IgQmQe4055mdbiFozpxMvnggCiMyc7NOrvfm29fp9LbuZ5i5ON/B8m2J5GXb5vWVA6c0
         RewnXDqM8bApuZzbq6JtS4ZDUAhrXph9cYmjL7knYaBXHm/BBAXDwNZa1cdzz/6Ej2IG
         Nz7sdgqorS24+OA2LMNycsTyc5r3QxbSzQCNOBWWKXmM0MNeZkST886/Rkqe5ab/udOX
         y+NeJom41Oze0ooJeXmmFQBDfTWqcBjfimdSVuFjjTTbaXAuFIg3+jp92fXuR96azOE4
         e51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yp9XN4S+Opt5OiPcD1GcnJhSinyAA39zjfk4/yaqO8s=;
        b=3kmXpcnAPO8TLXIAZG2/bOiI5Ax9fmc76lE3ztVEsoS82Vu9ngW4oDDBWJL7RZdum1
         iBL53yxOu6F7V4+3J30WDx7sZIoHwbjYfEPbQqjVFFrl8a8FTcTYx6pQvNPhWngSHdxD
         g1oybV9ym5KtC3WhHecJMkGbTl/a+hjP/o79Xr3gb4jQPiKpX7bS/iJR7Rm9JNqJzokJ
         0boBA6yZXXL0B4F3vBpWAuBl2uNqYtub8lGl8KEY+1K3pYNyMdmZOCWH1TSfdf8MCRlx
         nHd6z8Tpyz0x8kgKzbgTo64ClHb2ATWB4v4byXdNkgRCOKKiQKQiC0DyG7b8omGh2VZz
         lWdw==
X-Gm-Message-State: AJIora8rAQge/vk2uq3brrtRSmSCU2kDk51BDz7KrmQ33Pu851+TVBSa
        7225rCYsNnAVn2RxLjQiIkReX4dniGd+tb8TMf4=
X-Google-Smtp-Source: AGRyM1ubWJCx0SPiTeTHy1XH1UrTXqKhbiuskgaTbILYM9h0vFVUsY93Ykxv678H610M89IRqGuslFj82aLn/+EiSQg=
X-Received: by 2002:a05:6902:1142:b0:66d:999a:81a7 with SMTP id
 p2-20020a056902114200b0066d999a81a7mr13475371ybu.460.1656708142638; Fri, 01
 Jul 2022 13:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-2-colin.foster@in-advantage.com> <CAHp75Vf0FPrUPK8F=9gMuZPUsuTbSO+AB3zfh1=uAKu6L2eemA@mail.gmail.com>
 <20220701203453.GB3327062@euler>
In-Reply-To: <20220701203453.GB3327062@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 22:41:43 +0200
Message-ID: <CAHp75Ve1AVtNsmCrBr8XCcm2fJnKYQhF98v49OD8Y4kBUzb0-w@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
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

On Fri, Jul 1, 2022 at 10:35 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
> On Fri, Jul 01, 2022 at 10:23:36PM +0200, Andy Shevchenko wrote:
> > On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
> > <colin.foster@in-advantage.com> wrote:

...

> > > +       res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> > > +       if (res) {
> > > +               regs = devm_ioremap_resource(dev, res);
> > > +               if (IS_ERR(regs))
> > > +                       return ERR_CAST(regs);
> >
> > Why can't it be devm_platform_get_and_ioremap_resource() here?
>
> It can... but it invokes prints of "invalid resource" during
> initialization.
>
> Here it was implied that I should break the function call out:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220628081709.829811-2-colin.foster@in-advantage.com/#24917551

Perhaps a comment in the code, so nobody will try to optimize this in
the future.

> > > +               return devm_regmap_init_mmio(dev, regs, config);
> > > +       }

...

> > > +       return (map) ? map : ERR_PTR(-ENOENT);
> >
> > Too many parentheses.
> >
> > Also you may use short form of ternary operator:
> >
> >        return map ?: ERR_PTR(-ENOENT);
>
> Agreed, and I didn't know about that operator. When Vladimir suggested
> it I thought it was a typo. I should've known better.

It's easy to remember by thinking of

"X ?: Y" as "X _or_ Y".

-- 
With Best Regards,
Andy Shevchenko
