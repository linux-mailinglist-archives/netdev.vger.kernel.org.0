Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3150D60DC45
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiJZHkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiJZHkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:40:31 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62CB2FC19;
        Wed, 26 Oct 2022 00:40:22 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id bb5so9327100qtb.11;
        Wed, 26 Oct 2022 00:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHRQt+Zpb7FZyHHkqxk7rEuqUhLqeuOhbQbiY4XuYX8=;
        b=G/BbkkZqY4YtuXzpJ18PvV6tapWNncQ/lQjKXiXz7x/LdcUl7AKhEBLOOYalZ2Fw8q
         9AcR4Ef7jYhaNBBcVwMjIkflX1u7t+D2mzaMcrLVkBnVVvMpiERWsTJgTxR4R3FtuljS
         Z6q4Rrk7vqeZQkv7UaEEqG4cvNBdu+bLTCm4GSqZPZ3RUnEDmLGgo5eeIdq9swsyyrCT
         cUOuOfCuUlTsPw93v07d/iCPI8IouGrijp08YzSZKCuSuOm1T075aHBGiL6S/3Pabh0N
         dVomgkDDRd169K7WOxuOp+Q2xE6g89ENUdctrnAvqG9wjA1K9ylqT3QrjQgXPzRqKSLd
         czKg==
X-Gm-Message-State: ACrzQf0TDf6lZ58KfiFHiYvCdid0QOKy9ROBFqGMHzgoHKk/APle6Jub
        fawAY16W0Hz6O1C5J1NpLEBF0e5gaaJ5jg==
X-Google-Smtp-Source: AMsMyM5yjBZ9VVTidsNkzqTG3z98tE3ZnXsj6HOD5DwTwMvBFYwfgpm69s3v2wgmQD41jT8Tzsn7gg==
X-Received: by 2002:ac8:5d8a:0:b0:39c:d3a8:3f91 with SMTP id d10-20020ac85d8a000000b0039cd3a83f91mr35256496qtx.324.1666770021297;
        Wed, 26 Oct 2022 00:40:21 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id l10-20020ac84cca000000b0039d0366af44sm2856878qtv.1.2022.10.26.00.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 00:40:19 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-369c2f83697so131745127b3.3;
        Wed, 26 Oct 2022 00:40:19 -0700 (PDT)
X-Received: by 2002:a81:3d2:0:b0:36b:6772:75a3 with SMTP id
 201-20020a8103d2000000b0036b677275a3mr18653884ywd.383.1666770019103; Wed, 26
 Oct 2022 00:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com> <20221025155657.1426948-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221025155657.1426948-4-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Oct 2022 09:40:07 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVk+o3Sx-2uu=ApH8Mj_EWEDN0r1Hed9FtpP3y_VStNrg@mail.gmail.com>
Message-ID: <CAMuHMdVk+o3Sx-2uu=ApH8Mj_EWEDN0r1Hed9FtpP3y_VStNrg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 6:03 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Replace devm_reset_control_get_exclusive->devm_reset_control_
> get_optional_exclusive so that we can avoid unnecessary
> SoC specific check in probe().
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
