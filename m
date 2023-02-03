Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA50689ADA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjBCN7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjBCN6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:58:42 -0500
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AE2A2A45;
        Fri,  3 Feb 2023 05:55:47 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id f10so5472656qtv.1;
        Fri, 03 Feb 2023 05:55:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nbKgXRRhHOsf8b2qFYqubarXiD/2JOI3CXyxQSetlOo=;
        b=HlEDPXIokd/UDyTtc0FxQNaDH0ZU/iUhw74FrRW24qFU+x/UvHrM3GvgjU6XYoPfK4
         2a2wgRqkfLi1xDl5PSBd5UkwLYsdlnwlmZvc5sMXnZVOKO0ld5QsKfMM4Xta/ms5CNxS
         ppXL+O3ObR9qo8Vq45mIVyXo+YcXgreGnvBUUWGiX/vXsD14bkYewuWgtd2COS54VdSy
         KUKU9eEw5Wp39brBfUJYMOM/S6kXT2FUwFn4y6EgyrZO/Pm8GUtPRNZ4nQee+mT+NH8Z
         kX+5LCYAEVVGBYc2Zw2vGRC3e6C9SSXL77LKPQVWLKskZTa4XqQmh9orAtTSvVK3EXoP
         CEEA==
X-Gm-Message-State: AO0yUKVcLrFdcEncIeo8DCv1VeOvmBlSU4e1lgl6i+PjpTk7oXrN7eCy
        /8MGYFvKOvbzHC1alr44Fi3raKccTgAn8Q==
X-Google-Smtp-Source: AK7set/VrH2W/hF5htoK/wyjMPPVEuFk9wCswUkXu2hSgQiBOpjFpUlZY44JgVrrob1RrSq8KnXVeA==
X-Received: by 2002:ac8:57d6:0:b0:3b8:4bb8:5aa5 with SMTP id w22-20020ac857d6000000b003b84bb85aa5mr20729191qta.54.1675432441314;
        Fri, 03 Feb 2023 05:54:01 -0800 (PST)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com. [209.85.128.170])
        by smtp.gmail.com with ESMTPSA id n3-20020ac86743000000b003b80a69d353sm1577481qtp.49.2023.02.03.05.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 05:54:00 -0800 (PST)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-5254e8994e8so23778007b3.6;
        Fri, 03 Feb 2023 05:54:00 -0800 (PST)
X-Received: by 2002:a0d:c2c4:0:b0:514:a90f:10ea with SMTP id
 e187-20020a0dc2c4000000b00514a90f10eamr1025067ywd.316.1675432440139; Fri, 03
 Feb 2023 05:54:00 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-2-hch@lst.de>
 <Y8EMZ0GI5rtor9xr@pendragon.ideasonboard.com> <20230203071506.GB24833@lst.de> <Y90Q73ykVEHRNII4@pendragon.ideasonboard.com>
In-Reply-To: <Y90Q73ykVEHRNII4@pendragon.ideasonboard.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 14:53:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVi1DPqYNbB5xWeG+1kK4x=8zQ0y57WSJ_j2xENCjQREQ@mail.gmail.com>
Message-ID: <CAMuHMdVi1DPqYNbB5xWeG+1kK4x=8zQ0y57WSJ_j2xENCjQREQ@mail.gmail.com>
Subject: Re: [PATCH 01/22] gpu/drm: remove the shmobile drm driver
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Laurent,

On Fri, Feb 3, 2023 at 2:49 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Fri, Feb 03, 2023 at 08:15:06AM +0100, Christoph Hellwig wrote:
> > So given that the big series doesn't go in, can we get this removal
> > picked up through the drm tree?
>
> Geert has a board with an ARM-based SoC compatible with this driver, and
> he expressed interest in taking over maintainership. Geert, could you
> share your plans ? Should the shmobile_drm driver be dropped now, or
> will you revive it in a relatively near future ?

(Trying to) get it working on that board is on my list...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
