Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60552A3EA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbiEQNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiEQNz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:55:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365566240;
        Tue, 17 May 2022 06:55:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j6so16916173pfe.13;
        Tue, 17 May 2022 06:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K+LAqDD+F6fRsWPFZvzdAiO5ZgIytUys9dztE+gfcQQ=;
        b=EOdbgtl34ixbVgAJLZc8ETdro9gjQwVKZazi4979GABOOWX4rwBHIx2i6CPKx9/XM2
         6KfXpc5sUiVI5f2wE4knvYRB05sP/3c1wY2Sm2vp8YLKxkANB8Tz5aSOhwv/x1L2Hja7
         zwOOjz2+KlvKC8ouKFkfs+iaroRl/pk1GUcnorLKmr39NxEzIzxzTHyl8rv4m9WH5AAX
         j1W9N+LtcMKOFXYm994W5TlbPBrvUj4PCmJXzQ0dY9z/pjMPI5GBkD//TjIrW5+nBdHS
         zqzzlEAgsNQMcS7DjMfOEwErOxOJ1FHKBnvT5poPKAfxmGNB3XbuqJKvSL9IuAhpFwUv
         543A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K+LAqDD+F6fRsWPFZvzdAiO5ZgIytUys9dztE+gfcQQ=;
        b=a/XJD8XKTYKcvNUPV/seCWwmSc0ZekgGHWvx8DCDIlXbmMj2k2BmgeQaM9nbAT4BmF
         Nds0MI3LySaZEIAndFsh4g9xzVzCX0BWmON+/Rd4P5PBv0/aVhX1P0gXkrV+ts+GW6Nz
         Vu7jpATX3eXZwqNc3PaU64RgXI5vGPYMKdvUwCpFufx4R6pGi6yZk052zN4moxxGETFF
         y31bljHl+tEY3yVV+f8MvmLr3njR68IIRPgipAmDck9B4NXeBxMUp+WhFnIbOGSlP0PN
         xjQ362jO3z7FA179amjt1rdbgkKsZhbR4HvUpLYe7BZrfAabanEHK3kOlhy3mpRCH5/0
         85ug==
X-Gm-Message-State: AOAM533franGvr5ddCQ7Yz/TqBtEonxmsVL6uzaxEkrJh5ALaQv5spU3
        hS5Vexe0BfCQRjLzNBa/hjs=
X-Google-Smtp-Source: ABdhPJyiQbjNdbnR+v3TO+EAqzoeftLu9wLP2lz6DZD/fQHUw1AAz+vzuC2sSl/oS/kxI3aU9hOVpw==
X-Received: by 2002:a62:d155:0:b0:50d:3c4e:37ec with SMTP id t21-20020a62d155000000b0050d3c4e37ecmr22512611pfl.60.1652795727713;
        Tue, 17 May 2022 06:55:27 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x27-20020aa7941b000000b005181133ff2dsm735292pfo.176.2022.05.17.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 06:55:27 -0700 (PDT)
Date:   Tue, 17 May 2022 06:55:25 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH 0/3] Macb PTP updates
Message-ID: <20220517135525.GC3344@hoboy.vegasvil.org>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517073259.23476-1-harini.katakam@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 01:02:56PM +0530, Harini Katakam wrote:
> Macb PTP updates to handle PTP one step sync support and other minor
> enhancements.
> 
> Harini Katakam (3):
>   net: macb: Fix PTP one step sync support
>   net: macb: Enable PTP unicast
>   net: macb: Optimize reading HW timestamp
> 
>  drivers/net/ethernet/cadence/macb.h      |  4 ++
>  drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
>  drivers/net/ethernet/cadence/macb_ptp.c  | 12 +++--
>  3 files changed, 63 insertions(+), 14 deletions(-)

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
