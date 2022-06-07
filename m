Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520B653FB6D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbiFGKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241214AbiFGKf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:35:59 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9D0ED3E8;
        Tue,  7 Jun 2022 03:35:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f34so30414458ybj.6;
        Tue, 07 Jun 2022 03:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z0ZozeEuIbZiflGhi9tRrNZpoPtpA/EvsLsniAdD5yU=;
        b=OrMz7uNrq51Yp3MfnX4W+nb8tJbgAfPzI96E70/Joq+KygueECNGvmQFuBumtKJNyd
         xeX2oCOuPwZPXKfSw1mY6IXel31cF2/8A0HaVNjX9Dxzd6ds7BxZYmdyaM8ksNH800J+
         UQmtnPck5+fTaLrcy2wTxOuuexWXCrfFIxPFZokL0R1rAtS8XwOOo/MCkWllv68LRi5n
         wfadNFiLtCzihFIygtm8YYBmHElvF1WSURU0PlsNfSnWpXO54x0OUFOIGrDei81CixFO
         6wzY9LLvWmAfqLfCPsRuDHVK8jtr+rLhcwHeHgYY5yCmwRxLl0lptka5tb9FUuusqDBL
         MmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z0ZozeEuIbZiflGhi9tRrNZpoPtpA/EvsLsniAdD5yU=;
        b=z63RCte1tZOYM+TRonPShmxTAHXfmKXU/qZrdfDuILEX7uO0gwmm8/AbgtF7bnbcNv
         bIOGaAdx87/xsPsDIt0GQ8+XPPYr/HgDXuYD5+zw+erMGvkBFLljZJfBK4ggQm73pZsK
         PXtx7ptRLTlt12Yf6l8gDC6EYt+pY53j+aY54mEYDRce0uvlbtvrn2OTqd55Q3DdcurB
         WQ6I/PPHm2NHwOsUrtua/JABhtUBDsD/6kP8hA9soIvKVNBbnk7Qz4QE+OTyyzmB1E+6
         rfMg8ddNNu/7D4nDc6PPBoPzUUbBP0TLG4WeBdy76SjremZeh6ZJPjrb7ME+CJkC9iI8
         4W8A==
X-Gm-Message-State: AOAM533J6Sl6tJFlONE90+CSEJbobJeb/3qp9jG7aKQ7G4kjlacqrgQ/
        oHhCWVEnAZUreAIyPp+JHNluYCrWraC5VtNl5/c=
X-Google-Smtp-Source: ABdhPJwKFYylw0Y6L+dxIpzj0rWIiZ2w2G9OUdgFwmnLKdPL9DGzBgcbM6IwwOuC+ZMI1bJzTTDCWU+4FeVcB7sOXlQ=
X-Received: by 2002:a25:7795:0:b0:662:666b:f927 with SMTP id
 s143-20020a257795000000b00662666bf927mr20533999ybc.100.1654598151081; Tue, 07
 Jun 2022 03:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220607090206.19830-1-arnd@kernel.org>
In-Reply-To: <20220607090206.19830-1-arnd@kernel.org>
From:   Manuel Lauss <manuel.lauss@gmail.com>
Date:   Tue, 7 Jun 2022 12:35:15 +0200
Message-ID: <CAOLZvyFvSJ_+SJCY6T5zBTetf-oezm+A9w6gR+cnLOC4T+8HwA@mail.gmail.com>
Subject: Re: [PATCH] au1000_eth: stop using virt_to_bus()
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 11:02 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The conversion to the dma-mapping API in linux-2.6.11 was incomplete
> and left a virt_to_bus() call around. There have been a number of
> fixes for DMA mapping API abuse in this driver, but this one always
> slipped through.
>
> Change it to just use the existing dma_addr_t pointer, and make it
> use the correct types throughout the driver to make it easier to
> understand the virtual vs dma address spaces.
>
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

lightly tested on a DB1500 board, without issues.

Tested-by: Manuel Lauss <manuel.lauss@gmail.com>

Thanks!
