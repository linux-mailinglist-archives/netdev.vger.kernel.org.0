Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3959C5812E0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiGZMMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiGZMMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:12:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4852DD9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:12:01 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t22so15950599lfg.1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRdMkVO45kt5SUq2iTSwOTuiugVw1ePTDCKNo3/Lr2Q=;
        b=PWpNy38u+kmxcyNOBTsonapbCAkL3cJaMR4mqtXCM6PBsg1pnSlLojXIouR2HEm4gc
         nQGRcdQhBEPSk7FemlfLMu2vuyGtyK9kGUQqImx3Jjqtd7THFBIPliuzj9VeIUclriS4
         pKb7YBTkwl30kCjGoqQ6zki5lcHDMdlsHMpwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRdMkVO45kt5SUq2iTSwOTuiugVw1ePTDCKNo3/Lr2Q=;
        b=uJdvkswGU3RPYLq4xyV2avDBc2F3zjbZ+G6TlbGPpVV67pDfHe5xSMCIDJpn/nfqYS
         Wuq3ZyEdunF3+RrrAMjZvNFX0lD2PDZUMGIV8xQcRpgvySDwK/CbkZ4GDRE6r1+ZzC6D
         n9ShXtR+Y0bdzX4r2I6dFCutZJ6Q/nVsGpt99VG4jSc3gRJdpKnT4RiYXKlp+df0bNqO
         uo8Gy8K93IKimsPaB+4N7GaYDYiytium8C5ATgqtd8PmIwekc5YOvCeJEak1mNIejvrg
         tHjxwRZyD3bmRf+tMyuMZyMltgYKoFfD3sRBs9QHkV9eaIbc9mIQjtzo7nPJPZLbFpLi
         rRuQ==
X-Gm-Message-State: AJIora+Rbv7QUU/P2mXK3jMKuodrWbvu/XlF4d/kPob0abqEy9nT7YLX
        BM3BY1BfyM9CRX5Ni8k08sNz1b/m849VnJYlN5rLyg==
X-Google-Smtp-Source: AGRyM1tMgbLOF7GIEOIivn9Jp8KvbfU4Z7Vy7FS2Xgg2x+pv0vH3AwCgePCUcgeP86HEVM/iUvSYHNnU6CaDrCpYSvA=
X-Received: by 2002:a05:6512:32c2:b0:48a:9822:ca2c with SMTP id
 f2-20020a05651232c200b0048a9822ca2cmr2540199lfg.117.1658837519793; Tue, 26
 Jul 2022 05:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
 <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com>
 <20220725123804.ofqpq4j467qkbtzn@pengutronix.de> <CABGWkvrBrTqWQPBWKuKzuwQzgvc-iuWJPXt2utb60MOfych09A@mail.gmail.com>
 <20220726115845.4ywgubfpqfbl7qa3@pengutronix.de>
In-Reply-To: <20220726115845.4ywgubfpqfbl7qa3@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 26 Jul 2022 14:11:48 +0200
Message-ID: <CABGWkvrknM0VS2V1TAjyjeoE0n2yXGLvv6ucvO-z23nL=EXvXQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] can: slcan: remove legacy infrastructure
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 1:58 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 26.07.2022 12:11:33, Dario Binacchi wrote:
> > Hello Marc,
> >
> > On Mon, Jul 25, 2022 at 2:38 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > >
> > > On 25.07.2022 08:54:15, Dario Binacchi wrote:
> > > > Taking inspiration from the drivers/net/can/can327.c driver and at the
> > > > suggestion of its author Max Staudt, I removed legacy stuff like
> > > > `SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
> > > > and its maintainability.
> > > >
> > > > The use of slcan_devs is derived from a very old kernel, since slip.c
> > > > is about 30 years old, so today's kernel allows us to remove it.
> > > >
> > > > The .hangup() ldisc function, which only called the ldisc .close(), has
> > > > been removed since the ldisc layer calls .close() in a good place
> > > > anyway.
> > > >
> > > > The old slcanX name has been dropped in order to use the standard canX
> > > > interface naming. It has been assumed that this change does not break
> > > > the user space as the slcan driver provides an ioctl to resolve from tty
> > > > fd to netdev name.
> > >
> > > Is there a man page that documents this iotcl? Please add it and/or the
> > > IOCTL name.
> >
> > I have not found documentation of the SIOCGIFNAME ioctl for the line discipline,
> > but only for netdev (i. e.
> > https://man7.org/linux/man-pages/man7/netdevice.7.html),
>
> Ok - What about:
>
> The old slcanX name has been dropped in order to use the standard canX
> interface naming. The ioctl SIOCGIFNAME can be used to query the name of
> the created interface. Further There are several ways to get stable
> interfaces names in user space, e.g. udev or systemd-networkd.

Good! I will update the commit message in the next version I will submit.
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
