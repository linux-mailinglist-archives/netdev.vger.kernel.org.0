Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E05B66DF2E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjAQNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjAQNqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:46:00 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E5A3B654;
        Tue, 17 Jan 2023 05:45:29 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id h21so26995249qta.12;
        Tue, 17 Jan 2023 05:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CY8Y0zis5qUpg3nfk67Qr9BPzezMCgU4r+fl3VnxC2w=;
        b=kPhfoccFpDIAEKaZwmZDVzsWH6XlapmKd5DJjQK1bUNk5FRNeUz6CXPit2oBuBT4v+
         beI1g8T5SKp5s91/+crun3BHrc3meGRIndWTazUUJYihPsteEQYBN/5xom9/XcBHMYpC
         7czWewJU1RtHm4DFir/yuhSgBnBldvXJvZAPAurcmbki4Mo7ax+sOMyG5mQaY8AnRx/P
         Kxa37LyRTiX1t53HUJjzzxgh7/C8btRa7GC1R0s8phNKejRiT5iHMBTyeu8pYOUA9u8h
         5lS0cCaL6lDoH5tY8E//oyNDwuY6WbiBlo7O/ZEz6UUuc8d/4pvHCes8Ey7Pn6vsmEjM
         LSxQ==
X-Gm-Message-State: AFqh2kr0XzP9VPVpLVlRru+8kzrAriAdXY2ZzqHHvooeK9/GALuESQJh
        PLMjxM6CLPlIgKTmKo1eaRDvYaBoYKre9A==
X-Google-Smtp-Source: AMrXdXt0WWyhc8kOgq3baH66P8D4zxaoECfhB+f5n78vIqX5yZBd2Py+WcieYKP52w82eYPdWPie/A==
X-Received: by 2002:ac8:1019:0:b0:3b0:87a5:c1e0 with SMTP id z25-20020ac81019000000b003b087a5c1e0mr29570435qti.13.1673963128064;
        Tue, 17 Jan 2023 05:45:28 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id w26-20020a05620a0e9a00b006fa22f0494bsm650825qkm.117.2023.01.17.05.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 05:45:27 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id e130so4529023yba.7;
        Tue, 17 Jan 2023 05:45:26 -0800 (PST)
X-Received: by 2002:a25:d88c:0:b0:77a:b5f3:d0ac with SMTP id
 p134-20020a25d88c000000b0077ab5f3d0acmr345604ybg.202.1673963126656; Tue, 17
 Jan 2023 05:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20230104103432.1126403-1-s-vadapalli@ti.com> <20230104103432.1126403-2-s-vadapalli@ti.com>
In-Reply-To: <20230104103432.1126403-2-s-vadapalli@ti.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 17 Jan 2023 14:45:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com>
Message-ID: <CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Add J721e CPSW9G support
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
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

Hi Siddharth,

On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
> ports) CPSW9G module and add compatible for it.
>
> Changes made:
>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 8 for new compatible.
>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Thanks for your patch, which is now commit c85b53e32c8ecfe6
("dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G
support") in net-next.

You forgot to document the presence of the new optional
"serdes-phy" PHY.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
