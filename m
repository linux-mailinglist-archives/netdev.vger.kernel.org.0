Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E2E6D640F
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbjDDNzI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Apr 2023 09:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbjDDNy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:54:58 -0400
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1B34C21;
        Tue,  4 Apr 2023 06:54:39 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5456249756bso614801747b3.5;
        Tue, 04 Apr 2023 06:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3M2LXzJQFG/OPsbte88DPWda3vmr3kZtIOno67qR5y4=;
        b=q4A6JGoQ+DMemFF2Ier6fGOfqH8UCQFJLE8sxmRmCsYk/XQ6ahTWZgTSPNvZL8orao
         2brD42+s6SqCYJ5BDJ3OfsBbqkxR152h2rIbo+2nbRQ45+5jtJpZ+m3UtD3l8jC6nzw1
         IbTdRSuS7vt7weslsIjkenVKgfExMBstYXEY/3UGSN6op8A12V+33nDzEPVzBX8RmKWL
         GSzs/KORH8SjeiF9qQozThJfBrPO0Zgm8c769ZaMewSqs3TREs6pArCWc2FnDoENODHr
         q+Ck6jZr/ZfILOvD/Xf0EPOC0ZVUCoy2O/2JYB9w9TX44ddegAU30IE9MrN37thpLKfV
         Fb5A==
X-Gm-Message-State: AAQBX9eM8w3uqmuyOGDghkyYuDnDnpKYQaFDJbNPQlmOWVXehwkiHp7K
        3k9NHVzpgmjcfto24FlOtpka8HtSU+qJHAMV
X-Google-Smtp-Source: AKy350YY2ViyM9y1tEm3lIVNKzMDh0sv3sOzvO5w1tIOQ574Kp4L4i0F21IaNyqu4wvJF9cQl81Vpg==
X-Received: by 2002:a81:4f90:0:b0:536:509a:a6a with SMTP id d138-20020a814f90000000b00536509a0a6amr2361825ywb.25.1680616478404;
        Tue, 04 Apr 2023 06:54:38 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id 186-20020a8117c3000000b00545a08184acsm3177229ywx.60.2023.04.04.06.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 06:54:37 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id p203so38710148ybb.13;
        Tue, 04 Apr 2023 06:54:37 -0700 (PDT)
X-Received: by 2002:a25:ca4b:0:b0:b77:d2db:5f8f with SMTP id
 a72-20020a25ca4b000000b00b77d2db5f8fmr1866265ybg.12.1680616477481; Tue, 04
 Apr 2023 06:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230404113429.1590300-1-mkl@pengutronix.de> <20230404113429.1590300-8-mkl@pengutronix.de>
In-Reply-To: <20230404113429.1590300-8-mkl@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Apr 2023 15:54:25 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWwLHYsbjvKuJ6M3an0nQWdcd9M8Y8io5wg0fAcgL9XDg@mail.gmail.com>
Message-ID: <CAMuHMdWwLHYsbjvKuJ6M3an0nQWdcd9M8Y8io5wg0fAcgL9XDg@mail.gmail.com>
Subject: Re: [PATCH net-next 07/10] can: rcar_canfd: ircar_canfd_probe(): fix
 plain integer in transceivers[] init
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
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

Hi Marc,

On Tue, Apr 4, 2023 at 1:34 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Fix the following compile warning with C=1:
>
> | drivers/net/can/rcar/rcar_canfd.c:1852:59: warning: Using plain integer as NULL pointer

s/ircar_canfd_probe/rcar_canfd_probe/ in the patch summary.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
