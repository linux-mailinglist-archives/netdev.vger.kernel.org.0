Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB274D42D1
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiCJIrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240487AbiCJIrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:47:08 -0500
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEC9CB650;
        Thu, 10 Mar 2022 00:46:04 -0800 (PST)
Received: by mail-qk1-f174.google.com with SMTP id q4so3820853qki.11;
        Thu, 10 Mar 2022 00:46:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7GSNPJ4GM9l2nh+oqbBhxcVq5NkjrY7b8iiK6Um5AI=;
        b=MzkE3T+aQX2jYRy+q8flgPYAFk3GVMz5SRWgKc5cTEIIOFe7QM5Ieaz2OjN4voUEmD
         BBLb9OP+uyGIj/WfS4UabMfOAoyNF5NSVgCWmhCBV5IXRTNAVMcd5a4vepntTnkD0TX2
         jmFKONaIFD73fVcBEuCpnjeVBKE9ikOuZGb7EXwK10dEKd+ny57zye6BLSB7MRt797LL
         DM46JWGDhNRg4qRKdNRJzPEm6Mi6Z3YlzmFMlx/VH+BItQr4Q5w7eraQCxgwrTs5u9fk
         k1yn9qdF4hdEifJr2FoQszJ0mVEa9qmykHMjgsX4DHOdLlBvxifMcs6Dsvv4V87XwYQc
         Yqfw==
X-Gm-Message-State: AOAM532xlTSQVcV88jeq/X6m9YmigOFC8kUKmPygZ4FJ4RrI0WhtVqvx
        cfo+KfPM2whPesOQpUnWkQitvFsNHzzq/Q==
X-Google-Smtp-Source: ABdhPJxYd3kTrw239ed2Dte664Bd68svX4CS3BVdHXuVNwGLSZGdU2pX3jRcbVs/dybjfviY5V/FxA==
X-Received: by 2002:a05:620a:240a:b0:67d:5514:eec6 with SMTP id d10-20020a05620a240a00b0067d5514eec6mr858108qkn.324.1646901963132;
        Thu, 10 Mar 2022 00:46:03 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id d26-20020a05620a159a00b0067d4f5637d7sm678945qkk.14.2022.03.10.00.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 00:46:02 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2d07ae0b1c4so49774057b3.11;
        Thu, 10 Mar 2022 00:46:01 -0800 (PST)
X-Received: by 2002:a81:c703:0:b0:2d0:cc6b:3092 with SMTP id
 m3-20020a81c703000000b002d0cc6b3092mr2975365ywi.449.1646901961623; Thu, 10
 Mar 2022 00:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20220309162609.3726306-1-uli+renesas@fpond.eu> <20220310082545.rt6yp3wqsig52qoi@pengutronix.de>
In-Reply-To: <20220310082545.rt6yp3wqsig52qoi@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Mar 2022 09:45:50 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVoEm+0MZS-wMChS45YfPamfnBdM0CH5Rv-F_C4uAx0Kw@mail.gmail.com>
Message-ID: <CAMuHMdVoEm+0MZS-wMChS45YfPamfnBdM0CH5Rv-F_C4uAx0Kw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] can: rcar_canfd: Add support for V3U flavor
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Thu, Mar 10, 2022 at 9:26 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 09.03.2022 17:26:05, Ulrich Hecht wrote:
> > This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up
> > to eight channels and has some other minor differences to the Gen3 variety:
> >
> > - changes to some register offsets and layouts
> > - absence of "classic CAN" registers, both modes are handled through the
> >   CANFD register set
> >
> > This patch set tries to accommodate these changes in a minimally intrusive
> > way.
> >
> > This revision tries to address the remaining style issues raised by
> > reviewers. Thanks to Vincent, Marc and Simon for their reviews and
> > suggestions.
> >
> > It has been successfully tested remotely on a V3U Falcon board, but only
> > with channels 0 and 1. We were not able to get higher channels to work in
> > both directions yet. It is not currently clear if this is an issue with the
> > driver, the board or the silicon, but the BSP vendor driver only works with
> > channels 0 and 1 as well, so my bet is on one of the latter. For this
> > reason, this series only enables known-working channels 0 and 1 on Falcon.
>
> Should I take the whole series via linux-can/next?

Please don't take the DTS changes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
