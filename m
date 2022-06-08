Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7B2543925
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245155AbiFHQeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiFHQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:33:23 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F152307216
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:33:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a2so27929563lfg.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nczzxga2VzTI61hjMGVwlFiToqM1MiMF50/6VC0BnkQ=;
        b=HI9q91KmJnodakEMkkvIcxiYFhZNvzMEhXQFmkw2A+WEQNB2WvWMTR52zXEbtXiGC7
         Eb8G/wOjNPG4o+Zf4VOC/PTnskLo2rvM/HO2McFqvH3VOfDwp1F73zj3kj2H8Y2Ty1Np
         GOEiXuyyi8OiCcRkDb3E4hU5I8sGAQia/RdhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nczzxga2VzTI61hjMGVwlFiToqM1MiMF50/6VC0BnkQ=;
        b=e55cRT/PEDT29eBbqMktCx5SeFNUNrofMyAbpcw4Z+5nA8ZZ4najfBiPYi1ANSy+dq
         Ke+qGnnEmJ3HihW4tPFnB1v69ZelYfIL5tZ/yksMTQmsIdWkzDSy7MOwL1FuXEA7jaBW
         IyjejvCSBIpmvX9uNZ1KyWxUrAZzivKwhQMzRtBquxRrWuWmePoevk09fuuYJkMf4pso
         fjjQmSlnhsebABrq6NtfHfvSgTB9jq7F3r6Xqp/0PDSmLrq+oXE7/Tg5WHQDjM79bP3H
         WD6aJ2WANUNkIbuwAk6I3tUgT640OL1IrRHvAcri71j6kUhW8Ptkc0rwTgKa1u8e20XQ
         UacQ==
X-Gm-Message-State: AOAM532v1WibrfZSJ3Lygp41dbXoNsHgYJFoK2OTZWmA0P7577QghxYW
        EY8ZiflGRae8+GgbMMTdP8YCN/dXY4Ce+T9YF3rx2Q==
X-Google-Smtp-Source: ABdhPJzFy7nO2qnr5fKv1EOnBJmnn8JMOGWwCMrZHyWK3WGmMlta2rubmQComAvKJH2Vek8siCSqG/+MbMYHJs8DBgA=
X-Received: by 2002:a05:6512:3a89:b0:479:52fc:f80a with SMTP id
 q9-20020a0565123a8900b0047952fcf80amr8910198lfu.120.1654705999913; Wed, 08
 Jun 2022 09:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com> <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
In-Reply-To: <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Wed, 8 Jun 2022 18:33:08 +0200
Message-ID: <CABGWkvozX51zeQt16bdh+edsjwqST5A11qtfxYjTvP030DnToQ@mail.gmail.com>
Subject: Re: [RFC PATCH 11/13] can: slcan: add ethtool support to reset
 adapter errors
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Jun 7, 2022 at 12:52 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 07.06.2022 11:47:50, Dario Binacchi wrote:
> > This patch adds a private flag to the slcan driver to switch the
> > "err-rst-on-open" setting on and off.
> >
> > "err-rst-on-open" on  - Reset error states on opening command
> >
> > "err-rst-on-open" off - Don't reset error states on opening command
> >                         (default)
> >
> > The setting can only be changed if the interface is down:
> >
> >     ip link set dev can0 down
> >     ethtool --set-priv-flags can0 err-rst-on-open {off|on}
> >     ip link set dev can0 up
> >
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>
> I'm a big fan of bringing the device into a well known good state during
> ifup. What would be the reasons/use cases to not reset the device?

Because by default either slcand and slcan_attach don't reset the error states,
but you must use the `-f' option to do so. So,  I followed this use case.

Thanks and regards,
Dario
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
