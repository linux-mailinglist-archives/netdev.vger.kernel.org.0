Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DA6CD23A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjC2GnQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Mar 2023 02:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2GnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:43:11 -0400
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C82D4D;
        Tue, 28 Mar 2023 23:43:10 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id j7so18106989ybg.4;
        Tue, 28 Mar 2023 23:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680072189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKFJjwMfkc1/i71R2HfxUaDA6jy7XV8Sy9Jf1rC4YBY=;
        b=MWcCTSt3gv13Jubt66Ok3Xmn5i/us8Ig7NcpmeBhAFZOeFs60F0pDKeUTTtBFY14qK
         60RPOonl1SSFBGL0YEMrgWF1rpj6v5t6qGw0s1qJKsdzRBG0vM8oDXORswHzIKmx4/uL
         fGyThI6mhY4+bsHR5OlR6VXt5CWL/BLdKZyU6/qHMHImxJMSBHwDDIgv513Xmcw2S2ZS
         PA6nywxEmIrB9Ux5XXrKgLqkVU+JacvB6eoT3wC5bBoTQX9ozpWRgVBPNASacU/pn4TL
         EnhHg+k7N49y3DvtlxLMpq9ZY28Vz/0uUh9KQ3R/D13D6gFRS+NUl5cULapw57Ovx7ob
         TU8Q==
X-Gm-Message-State: AAQBX9cq0k0c6wK2XShLnXs37EGuxDOha1ioTpwVfWl4oE09XJH98ShV
        v/97WrYv4jOrvX/JK3zfA1wSwOWphCotdg==
X-Google-Smtp-Source: AKy350bfboB61yZRzgrYHyfbM5JQZBOpONbhLqoQk09etk6lxeglvAy3G/XUwgytopdXOaSrerWe4w==
X-Received: by 2002:a25:2584:0:b0:997:e3f5:d0cd with SMTP id l126-20020a252584000000b00997e3f5d0cdmr17049991ybl.45.1680072189399;
        Tue, 28 Mar 2023 23:43:09 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id b32-20020a25aea0000000b00b7767ca749csm3308052ybj.57.2023.03.28.23.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 23:43:08 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id n125so18066316ybg.7;
        Tue, 28 Mar 2023 23:43:08 -0700 (PDT)
X-Received: by 2002:a05:6902:722:b0:a09:314f:a3ef with SMTP id
 l2-20020a056902072200b00a09314fa3efmr11737007ybt.12.1680072188117; Tue, 28
 Mar 2023 23:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230327073354.1003134-1-mkl@pengutronix.de> <20230327073354.1003134-2-mkl@pengutronix.de>
 <20230328145658.7fdbc394@kernel.org>
In-Reply-To: <20230328145658.7fdbc394@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Mar 2023 08:42:56 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVsPZS=40+02=msy7bqYE6w41xbPjLKWRR2J43eMWYOxQ@mail.gmail.com>
Message-ID: <CAMuHMdVsPZS=40+02=msy7bqYE6w41xbPjLKWRR2J43eMWYOxQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] can: rcar_canfd: Add transceiver support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <simon.horman@corigine.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Mar 28, 2023 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 27 Mar 2023 09:33:44 +0200 Marc Kleine-Budde wrote:
> > @@ -1836,6 +1849,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
> >
> >  static int rcar_canfd_probe(struct platform_device *pdev)
> >  {
> > +     struct phy *transceivers[RCANFD_NUM_CHANNELS] = { 0, };
> >       const struct rcar_canfd_hw_info *info;
> >       struct device *dev = &pdev->dev;
> >       void __iomem *addr;
>
> [somehow this got stuck in my outgoing mail]
>
> drivers/net/can/rcar/rcar_canfd.c:1852:59: warning: Using plain integer as NULL pointer
>
> Could you follow up with a fix fix?

Sure (that one was well hidden in the sparse output)

https://lore.kernel.org/r/7f7b0dde0caa2d2977b4fb5b65b63036e75f5022.1680071972.git.geert+renesas@glider.be
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
