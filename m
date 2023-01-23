Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38500678687
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjAWTiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjAWTh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:37:59 -0500
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CFEEFAD;
        Mon, 23 Jan 2023 11:37:54 -0800 (PST)
Received: by mail-qv1-f43.google.com with SMTP id y8so9860713qvn.11;
        Mon, 23 Jan 2023 11:37:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EETY68yoLxveEOtuKaWLmvNjFo4bmFiVe2JWu/xgnSs=;
        b=IUiA2f3r79C5cFX5PLhZMah9Ino8OCRhcVqPuYXtIiCMdq/7/yqpKSKonV+Topax+4
         tcjjdg2hiv1a0MLM6u7syFP9jNymmXuZ/DSSXqzN/Ti0cVy76l/6S6Yb+8MxnYGcOEN4
         Sskx8GgI7AR6v1Z8bnzufE1aP7eu1QRRD4NjgUDWVOnLExfpwZGYekd32+IkzImTLEhx
         e9CuEaniZCt/bVpOng54eoS7Pnlwjtu975p8I+ZjwxHVgQc/psDAn7SWeRhfDmdKtoL1
         OzT/VlORIrwYb4OO3WWxlFRP3wNiEm1rVMylpDGwiUOgoM0G6oNuKIlKzZGM5i5DVCF1
         9xGw==
X-Gm-Message-State: AFqh2koMrEOZbvcVgURfyYzWEvpDiKUmN9YE7WSShEVqZx/ivMk2LVpW
        8qhIsRY/cv1kPl3pWmTax+3adWJoQ6ffIw==
X-Google-Smtp-Source: AMrXdXvBRSmEoqf6VZPO06csQBhxNNiwgq5sdcIYDHn8DlIOzyRi3+ju0ZC9vLwzPfwUji/KYWqrNQ==
X-Received: by 2002:ad4:44b1:0:b0:534:b991:26cf with SMTP id n17-20020ad444b1000000b00534b99126cfmr37419036qvt.39.1674502673341;
        Mon, 23 Jan 2023 11:37:53 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id j129-20020a378787000000b00706a1551428sm77957qkd.6.2023.01.23.11.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:37:52 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id m199so503376ybm.4;
        Mon, 23 Jan 2023 11:37:52 -0800 (PST)
X-Received: by 2002:a25:d88c:0:b0:77a:b5f3:d0ac with SMTP id
 p134-20020a25d88c000000b0077ab5f3d0acmr2416932ybg.202.1674502672667; Mon, 23
 Jan 2023 11:37:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674499048.git.geert+renesas@glider.be> <Y87f7BPchIcT2BQa@shikoro>
In-Reply-To: <Y87f7BPchIcT2BQa@shikoro>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 23 Jan 2023 20:37:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUF3ZAyp44wagw5vPGy5Qd8+1hF9bt9JwrascmXtLC8Zg@mail.gmail.com>
Message-ID: <CAMuHMdUF3ZAyp44wagw5vPGy5Qd8+1hF9bt9JwrascmXtLC8Zg@mail.gmail.com>
Subject: Re: [PATCH 00/12] can: rcar_canfd: Add support for R-Car V4H systems
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Mon, Jan 23, 2023 at 8:29 PM Wolfram Sang <wsa@kernel.org> wrote:
> > Hence despite the new fixes, the test results are similar to what Ulrich
> > Hecht reported for R-Car V3U on the Falcon development board before,
> > i.e. only channels 0 and 1 work (FTR, [2] does not help).
>
> IIRC Ulrich reported that the other channels did not even work with the
> BSP on V3U.

Same on V4H.  In fact I'm not surprised, due to lingering bugs like the one
fixed by "can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
