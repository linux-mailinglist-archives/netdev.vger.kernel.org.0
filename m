Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D544D3E9C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbiCJBP4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Mar 2022 20:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbiCJBP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 20:15:56 -0500
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800E71216AF;
        Wed,  9 Mar 2022 17:14:55 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id z30so7985947ybi.2;
        Wed, 09 Mar 2022 17:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+InUruY8tQ2+BAFaImHW4QdOeZX6IYvHbk4u3vv089s=;
        b=Kx2LJ2xM9XepM89x5VhJdml/ZhjSKuhS9A3iUgEAp0MFVQki4WIZSKslR8cbFZ93vJ
         NALXcA9g0vYvD5dXmzqpKCALzQodHyDEclIalpxaX9b26SrqU1mW41ZuS5tR4giliZwO
         nRg4bXw+NLWfMS4wwQ1hxQxNRQxWPn5CMp51PizHNENnzrXI39bCjAMgt4OUKeYaimy3
         +PjjHfcdO8AiK5O4vJmQ6d+vOkxvAUmTnAkDKEOyR7acZw/QXqNvdxSquzUj8LFr/jFY
         X+gkPClNmKdrfbZ+taUds54F+2j9kDAj4h3LnSQ5vFhVNklJDByjxdMKMXnSpIvMbNXQ
         N28A==
X-Gm-Message-State: AOAM532sgDuVy5udbd0YDRmj9tWrH78EwpuaqcGIuaa4aVu7GwLFubq5
        6JS8iZZUKW9O7Rs0MRLMOd8gz8wBAmYUtyVNeOA=
X-Google-Smtp-Source: ABdhPJxdzwCvqhe15mU55+WEmQC8lyFUp+DeQqi9+c00ZVfOhM3o/Yy5zp9ZivzeCqX6yGaNBKgDPrzBp9Oi7p72G6g=
X-Received: by 2002:a25:9f8a:0:b0:628:b9f3:6d2f with SMTP id
 u10-20020a259f8a000000b00628b9f36d2fmr1981622ybq.151.1646874894636; Wed, 09
 Mar 2022 17:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20220309162609.3726306-1-uli+renesas@fpond.eu> <20220309162609.3726306-2-uli+renesas@fpond.eu>
In-Reply-To: <20220309162609.3726306-2-uli+renesas@fpond.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 10 Mar 2022 10:14:43 +0900
Message-ID: <CAMZ6RqK=PFOWd++cLzua7R8mGRB1hbwLVrn5t_Mpkr0Tat_frg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] can: rcar_canfd: Add support for r8a779a0 SoC
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, socketcan@hartkopp.net,
        geert@linux-m68k.org, kieran.bingham@ideasonboard.com,
        horms@verge.net.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 10 mars 2022 à 01:26, Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
>
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
>
> Inspired by BSP patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for addressing my comments! v4 looks good to me.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
