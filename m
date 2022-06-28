Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A955E66E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346244AbiF1P24 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 11:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345696AbiF1P2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:28:55 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4FBBF9;
        Tue, 28 Jun 2022 08:28:54 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id q4so20506459qvq.8;
        Tue, 28 Jun 2022 08:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rWGuKnx4Ujs9MkjGuIowwwhdvBAe4X1vSQOEKzeoNPs=;
        b=4DCbD1rF0scov5Ko7iDju9vfgg7rLsjW7qsJGtC8D6jre+pPsBC78/VT9hv3JGZOAt
         34wSXyjcaeQwKqfBk81e8P4l+7PQ2q8QUxmcrBBn4gXrpgESafmFXlySYvuULJf0mxF1
         tsVkNNxN8S7PMOo/6TULTnOHdDKxF/bF65JXC7e1g558pzmNdw5uQZCJh6KT+pwfLeCR
         zh+vFHzhZFjVBzBbUetd+BxoFLq5qk2Q6N9j0/IpU4ulKe+UmChiU+bKe8tZNkje2yPw
         ocje7m++kHyNCGrWFr8gJknXDGZbgEIzd+ueJgZltbtQ0BCpXAHZjHQqgw5Bi88Foqdw
         JvQA==
X-Gm-Message-State: AJIora+Ia7iN9nC1l+uansP/0g+kOmd8RmPF2bhIwI1n2XulP1/PrTEB
        az5bSLIuee1Yj/XMQBoConNUcMxllDfxRQ==
X-Google-Smtp-Source: AGRyM1tqwjvQCLtYoNT4ij+Qnjr0uI8ehRX4sKRW0KViu46Vu9lNJtAIA8G+uJH5CjOBrnraFMRByw==
X-Received: by 2002:a05:622a:1108:b0:305:3092:b831 with SMTP id e8-20020a05622a110800b003053092b831mr13808695qty.624.1656430133241;
        Tue, 28 Jun 2022 08:28:53 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id m14-20020a05620a290e00b006a6b498e23esm12226163qkp.81.2022.06.28.08.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:28:52 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id r3so22838484ybr.6;
        Tue, 28 Jun 2022 08:28:52 -0700 (PDT)
X-Received: by 2002:a05:6902:1141:b0:669:3f2a:c6bb with SMTP id
 p1-20020a056902114100b006693f2ac6bbmr18971911ybu.365.1656430131905; Tue, 28
 Jun 2022 08:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-13-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-13-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 17:28:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWDL7k9m_ephLsFtsfceKPkO5WF=bbp6iQMaU+608H-Ew@mail.gmail.com>
Message-ID: <CAMuHMdWDL7k9m_ephLsFtsfceKPkO5WF=bbp6iQMaU+608H-Ew@mail.gmail.com>
Subject: Re: [PATCH net-next v9 12/16] ARM: dts: r9a06g032: describe MII converter
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
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

On Fri, Jun 24, 2022 at 4:41 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add the MII converter node which describes the MII converter that is
> present on the RZ/N1 SoC.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
