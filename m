Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6436A0583
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjBWKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBWKB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:01:56 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B3367DF;
        Thu, 23 Feb 2023 02:01:55 -0800 (PST)
Received: by mail-qt1-f179.google.com with SMTP id ay9so10073470qtb.9;
        Thu, 23 Feb 2023 02:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Zuo7qB/6Pm2hZ5xTIIOYL1BFZmQfayG3dDusY4IBCQ=;
        b=p9do/6M70VKfa/TwODfI4v+i681/rI0L2qiWYbMisuRkcxc8XjAl95n3RUYwBwPUfp
         +p1TYmBX3azFqo8AoLW/CYsN5vDHHbME/wiBpza65C3kD9FYizRMVTUkP7zA7UURNzTm
         65kTzgNor7AQja3G/Hm8KMAkeXCcx6Tj4zZf+tgddhb3yoKytuuzjaqJ4QiUWF73DW+m
         vh9qcKwTMGh10mxrUOJko1kWo5iwiXTihac/yNIyyUAB8vAWJ+Y1tP7pKg8qaQOkzFa5
         V/xab5kZCAP/YObcKsMtRRxLcVCgn+l0ad9t9Zjg7KD5fGtYYEhzL9MKyAI0utCWsP8S
         fmfQ==
X-Gm-Message-State: AO0yUKXNwaG1VSM437H0PGlBYaylnd85BD6X7Ey5b3vF6gy4pPZHrv/z
        5AoSg1QVIO4fsMH6MfGsFQTj/3XEuzhzytyv
X-Google-Smtp-Source: AK7set8+fxsTjrmmzvE/W26vgYAEZCBk3cro5FsSAsb5GjgdWY5rkICvsqUwSjIysbFoaEoSe1Kf+g==
X-Received: by 2002:ac8:5a50:0:b0:3b9:b6e8:8670 with SMTP id o16-20020ac85a50000000b003b9b6e88670mr5852801qta.51.1677146514083;
        Thu, 23 Feb 2023 02:01:54 -0800 (PST)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id cn6-20020a05622a248600b003b85ed59fa2sm4738357qtb.50.2023.02.23.02.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 02:01:53 -0800 (PST)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-536c02eea4dso167616387b3.4;
        Thu, 23 Feb 2023 02:01:53 -0800 (PST)
X-Received: by 2002:a5b:d4e:0:b0:967:f8b2:7a42 with SMTP id
 f14-20020a5b0d4e000000b00967f8b27a42mr1647939ybr.7.1677146512794; Thu, 23 Feb
 2023 02:01:52 -0800 (PST)
MIME-Version: 1.0
References: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Feb 2023 11:01:39 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVzzzztNU6dNFN30k4h4FheD2-439vaiY4AnGJz4EuwoQ@mail.gmail.com>
Message-ID: <CAMuHMdVzzzztNU6dNFN30k4h4FheD2-439vaiY4AnGJz4EuwoQ@mail.gmail.com>
Subject: Re: [REGRESSION PATCH RFC] net: phy: don't resume PHY via MDIO when
 iface is not up
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

Thanks for your report!

On Thu, Feb 23, 2023 at 8:36 AM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> TLDR; Commit 96fb2077a517 ("net: phy: consider that suspend2ram may cut
> off PHY power") caused regressions for us when resuming an interface

That is actually an LTS commit.  Upstream is commit 4c0d2e96ba055bd8
("net: phy: consider that suspend2ram may cut off PHY power") in
v5.12-rc1.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
