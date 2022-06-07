Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9575417FA
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351844AbiFGVHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379801AbiFGVG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:06:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EDD210FBA
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:50:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x5so19074035edi.2
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 11:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lxgwqXrTE5CS81OOTZfgrmr4rRv5j2bUa4aaRbpCvDQ=;
        b=UIn4bvZhXW7AF2rT52jP/vHIPjI8XyKoA3dn2Q+Bi0s2HH11YyOvGVEVe86JVSoGKI
         BaaWsQh6OrE4aTrQmY6fkIGKtAYybadmY8CgsBkfKkdrn9/E2Hw2YgipoxbbIFvguJ8i
         wugGZSlCqni+gcqC9Yso1tIQl10wVmmIOsHm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lxgwqXrTE5CS81OOTZfgrmr4rRv5j2bUa4aaRbpCvDQ=;
        b=r6WaP9StutttFitW6coTRXAvx8Jc6GNiKDbhhVrp6ruMtNnTjLy7jHFd55OAiw/V0a
         yDlTp66H8rYw/DVrPf5tG+ipMo1ipDTQhIlweB+W/QMes9tFY6HRFXIhrWMnHcMnjFxK
         Ccph55/2M7hLdIxQtImTaLjHXwfrxAZVGd0IvaP0Byf+HvPDsJzZ1Tls4EbEM8TorDZf
         Z+jLd8HPBHllGwEVMzYUrzUeMSgBppOwke4FqkrAaLlfEKF5INcyQFPx7l4EAU0nn1xC
         o75QyOianRBmiv/U71cw/A5M93dKzGjQlDaupncZZ3e7bceBLxLRRBxMIt4uV6dwUhGO
         /YeQ==
X-Gm-Message-State: AOAM530WC1XRRzlEy0+jQflEl0P0kz5vhcvxutYYJBZZRS7D9ouKkumy
        kaqtZMPD+Q3BzO1LvL9cCYBnYFX7R9RkkDhO7Js=
X-Google-Smtp-Source: ABdhPJy0SdrlUqPn2ERMWUUm3NPX1uFkG9V5vO0seQp58uHUbg/KCbavwWYoJ+7v7INAllMSfWH00w==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr35371704edb.273.1654627814796;
        Tue, 07 Jun 2022 11:50:14 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id e18-20020a1709062d5200b006f3ef214da6sm8110841eji.12.2022.06.07.11.50.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 11:50:14 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id k16so25376558wrg.7
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 11:50:13 -0700 (PDT)
X-Received: by 2002:a05:6000:1b0f:b0:210:313a:ef2a with SMTP id
 f15-20020a0560001b0f00b00210313aef2amr28815309wrz.281.1654627813569; Tue, 07
 Jun 2022 11:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220605162537.1604762-1-yury.norov@gmail.com>
 <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
 <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com>
 <CAHk-=wicWxvuaL7GCj+1uEvpvpntdcB=AHot_h3j4wpenwyZ2Q@mail.gmail.com> <CABBYNZJfqAU-o7f9HhLCgTmL46WfwNQbM5NsCACsVVDLACMLYw@mail.gmail.com>
In-Reply-To: <CABBYNZJfqAU-o7f9HhLCgTmL46WfwNQbM5NsCACsVVDLACMLYw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Jun 2022 11:49:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whcV=BE6bkyd50eZZnggaczKdpU_PevFRWw_hjJS72UPw@mail.gmail.com>
Message-ID: <CAHk-=whcV=BE6bkyd50eZZnggaczKdpU_PevFRWw_hjJS72UPw@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Guo Ren <guoren@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-csky@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 11:00 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Right, thanks for fixing it. About some of the changes perhaps we
> should use BIT when declaring values in enum hci_conn_flags?

That sounds sane, although with just two flag values I'm not sure it matters.

But I guess it would document the fact that it's a bitmask, not an
ordinal value, and it looks like that header is already using BIT()
elsewhere so there are no new header file dependencies..

              Linus
