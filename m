Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D7F51B90F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 09:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344862AbiEEHdr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 03:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344950AbiEEHdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:33:41 -0400
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A1488B6;
        Thu,  5 May 2022 00:29:57 -0700 (PDT)
Received: by mail-qv1-f41.google.com with SMTP id l1so66440qvh.1;
        Thu, 05 May 2022 00:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KzAVmzBQmEO2JBPDtZGXfDmIQ4cQijhB1DuSyb01WrU=;
        b=5N1IWr6m0gkJR6vW9nBddzzvBXN+oEycvKSnnLRyVOzjlyQPbi2YCFVm/czc6ACrL2
         UGmXp/XMODp/Bcx1hviy0ymkXrfWDQ7W3od7TZmaJDRyolpAEGYs9aRvcXdjBFU8mIMN
         3T8973Jz/f+BbCy9mSU7Ju+ol0szF9n0BqW0iSTi8ApHnErTAIFgMzTnwdLjAI8r/q7Q
         HMBAgNmxTsLszBr32TxYY2bdl/39thCIvx8uVGyXTGc+Dyu1xT/w+41W4jJckuZWsLvS
         /8YISqIKmqBd4DMxCLOx29ML/EeoUvbVlZ7REiK1dgvv9w7quxrbbBX8Uf705J+SnYx2
         L3mQ==
X-Gm-Message-State: AOAM532h3xpTaI++bz2r6ojWutXyDXJ8uXZd1yGyH8smpopYsx81Cjc9
        0vGCzRntqwdvNNM5CCOnp9yfv8njaPO/yw==
X-Google-Smtp-Source: ABdhPJwckh3gPol9EtZ060BLIaj2kVITp/R4+Z33r1y8JyoJObQRTAhGAD9QZtHxqiK0A5Sy5emKqw==
X-Received: by 2002:a05:6214:2a82:b0:443:a395:cc23 with SMTP id jr2-20020a0562142a8200b00443a395cc23mr20705112qvb.67.1651735795912;
        Thu, 05 May 2022 00:29:55 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id j186-20020a3755c3000000b0069fc13ce20asm424674qkb.59.2022.05.05.00.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 00:29:55 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2ef5380669cso39197047b3.9;
        Thu, 05 May 2022 00:29:55 -0700 (PDT)
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr22448044ywj.47.1651735794998; Thu, 05
 May 2022 00:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220504093000.132579-1-clement.leger@bootlin.com>
In-Reply-To: <20220504093000.132579-1-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 5 May 2022 09:29:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXdGCebeGiDj-4hYH24tBVRVqGsHbPfEqfUGT88GZKZrw@mail.gmail.com>
Message-ID: <CAMuHMdXdGCebeGiDj-4hYH24tBVRVqGsHbPfEqfUGT88GZKZrw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

Hi Clément,

On Wed, May 4, 2022 at 11:31 AM Clément Léger <clement.leger@bootlin.com> wrote:
> This series needs commits bcfb459b25b8 and 542d5835e4f6 which are on
> the renesas-devel tree in order to enable generic power domain on
> RZ/N1.

-ENOENT

I assume you mean:
14f11da778ff6421 ("soc: renesas: rzn1: Select PM and
PM_GENERIC_DOMAINS configs")
ed66b37f916ee23b ("ARM: dts: r9a06g032: Add missing '#power-domain-cells'")

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
