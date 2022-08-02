Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93B7587950
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiHBIrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 04:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbiHBIro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 04:47:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748884AD68;
        Tue,  2 Aug 2022 01:47:42 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id p5so16693768edi.12;
        Tue, 02 Aug 2022 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=puv0wVuinbvGk6m24vnUVnaprr7raVy2FnF9iWxEgDg=;
        b=fy5pI89/qCZ86uVbKjW1FbiRmxM4/rk48gHhb5LLNd4ecu1hOXK11Bu6Tqe56E8SCc
         L+dn3ij2RF2voqhgeBbzUbxLQg7JN163YvlnaVDWvbcWnPQdF1TWTlyT8PXCuqH00Lvm
         DrdI20Ny5s59MM5bja2VRJh7aCgXmoyjGp+yjUW1oGqUKfrLt/+d9v2zzWabwi1ahTcD
         v2KEFubO/bSqP+pSSdA8l+JL2juWuynwaDJ9hLm9s73id+pzr7uz+4bfEykNpFdRY+Di
         ARlOTr78VjUnYKOIsRrPOKKS8ciEY6GOh/Tg08sXeeh6BoVRjGlUJcA8w38BG6PDjgKV
         LVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=puv0wVuinbvGk6m24vnUVnaprr7raVy2FnF9iWxEgDg=;
        b=WALBNPzd9Y/Of8T1l8uI9X/SI1skbkH/DJy3AqtdkcCCU7MVPwCa5eDfxocM9fNb6v
         w7flqbzL8NSCQOxOCUOGFXSJHW4pykAe6d1G4OlVGOxrEW774FkF5ZjOtDst/IXlmFLf
         7GqHP3swgYiupcFcJbzngeRvF0JRS/9Gi/+V+cdmCFoGRt2KSCFMpy9KuzwhgfqWR7eN
         Ylr6U9ID6n5qUl/VA1HCidHbhrrb20IZ+da3jJqmERhcwRMLlsw43VpZrS9G4MdvMVqO
         pGLLyEAvK9VJqpA0EQENfJMGmGLub066oEMBUSvcEuFoy8k06/0SdfTc72mSgSRWkutG
         tWNA==
X-Gm-Message-State: AJIora/aiYnoWCNbF/AJXY3bX4U53raq+tXCfZ6DTAHeueaSuKQzo4kh
        W7b3faLnDL4Gk38jM5DdPrLCvkGFOCJ8QAtUXmc=
X-Google-Smtp-Source: AGRyM1utu3QImD9qsURFVtD1OVuARwXFkxr7OiAFJHxCnYpy3UfDVTZIG13xhWJHGIVUaL4XC+zI1ao29MiGikA0TLE=
X-Received: by 2002:a05:6402:84a:b0:426:262d:967e with SMTP id
 b10-20020a056402084a00b00426262d967emr18807129edz.286.1659430060844; Tue, 02
 Aug 2022 01:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
 <20220722040609.91703-10-colin.foster@in-advantage.com> <CAHp75Ve-pqgb56punEL=p=PnEtjRnqTBSqgs+vVn1Zv8F94g9Q@mail.gmail.com>
 <YuiJLK8ncbHH3OhE@euler>
In-Reply-To: <YuiJLK8ncbHH3OhE@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 2 Aug 2022 10:47:04 +0200
Message-ID: <CAHp75VcHU+Rh2ROjMcK+Yuyu1Ty9C0Dcx2SjrnrM4BV9NuMZig@mail.gmail.com>
Subject: Re: [PATCH v14 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
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

On Tue, Aug 2, 2022 at 4:17 AM Colin Foster
<colin.foster@in-advantage.com> wrote:

...

> > I'm wondering if you can use in both cases
> > spi_message_init_with_transfers().
>
> > > +static int ocelot_spi_regmap_bus_read(void *context, const void *reg, size_t reg_size,
> > > +                                     void *val, size_t val_size)
> > > +{
> > > +       struct spi_transfer tx, padding, rx;
>
> struct spi_transfer xfers[3] = {0};
> struct spi_transfer *xfer_tok = xfers;

unsigned int index;

> > > +       struct device *dev = context;
> > > +       struct ocelot_ddata *ddata;
> > > +       struct spi_device *spi;
> > > +       struct spi_message msg;
> > > +
> > > +       ddata = dev_get_drvdata(dev);
> > > +       spi = to_spi_device(dev);
> > > +
> > > +       spi_message_init(&msg);
> > > +
> > > +       memset(&tx, 0, sizeof(tx));
> > > +
> > > +       tx.tx_buf = reg;
> > > +       tx.len = reg_size;

index = 0;

> xfer_tok->tx_buf = reg;
> xfer_tok->len = reg_size;

tok[index] = ...;
index++;

> xfer_tok++;
>
> > > +       spi_message_add_tail(&tx, &msg);
> > > +
> > > +       if (ddata->spi_padding_bytes) {
> > > +               memset(&padding, 0, sizeof(padding));
> > > +
> > > +               padding.len = ddata->spi_padding_bytes;
> > > +               padding.tx_buf = ddata->dummy_buf;
> > > +               padding.dummy_data = 1;
>
> xfer_tok->len
> xfer_tok->tx_buf
> xfer_tok->dummy_data

tok[index] = ...

> xfer_tok++;

index++;

> > > +               spi_message_add_tail(&padding, &msg);
> > > +       }
> > > +
> > > +       memset(&rx, 0, sizeof(rx));
> > > +       rx.rx_buf = val;
> > > +       rx.len = val_size;
>
> xfer_tok->rx_buf
> xfer_tok->len

tok[index] = ...

> xfer_tok++;

index++;

> > > +       spi_message_add_tail(&rx, &msg);
>
> spi_message_init_with_transfers(&msg, xfers, xfer_tok - xfers);

..., index);

> > I'm wondering if you can use in both cases
> > spi_message_init_with_transfers().
>
> I could see that implementation getting the response of "what the heck
> were you thinking" or "that looks alright" and I honestly have no idea
> which pool it will fall into.

See above. I.o.w. use index based assignments.

> > > +       return spi_sync(spi, &msg);
> > > +}

-- 
With Best Regards,
Andy Shevchenko
