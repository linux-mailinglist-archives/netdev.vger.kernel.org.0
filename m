Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F6A540199
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245695AbiFGOjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbiFGOjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:39:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83F8F506B;
        Tue,  7 Jun 2022 07:39:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso3825045pjk.5;
        Tue, 07 Jun 2022 07:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ozbriDqzGnba5gPXVBR9TBC6OCr/vyebDOAR8cywEs=;
        b=bfaLX3DYZvTT4vKd74pHAXoCSj+aJNBkq1Tf3Wtqqxhi5dQi7+6FUHEvqHknh68S8Q
         f/NYgV8yrZ2bPEwY0yRzPSXue4tR9p+rD39eH4dHztdrmjUIXmWoqsELMkHqF5V5Od2D
         bQ2GbHPB/ia78K9aKOBsIwblxr3aHRkpRCPfpL/IRNKaOCfPzYaR35ypHcqH3v/jYDSN
         Iujh0GKIjNKs+fEEAC1qTi39Kvn23dyqP0/2DDTF6iMTlGP1WM0gJbN/pvAd8GKc/yOL
         ivw+6nzFPdjEJMsIbq0ig8dgzpb2llmqF3UTstenQHiPHI8U8s0Pvu1B3siBOlbIFasa
         AT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ozbriDqzGnba5gPXVBR9TBC6OCr/vyebDOAR8cywEs=;
        b=Uw3H207AtWZSsAed6kVk+Fk4xa4YBfPQ8K+8AhBBu8JQkgxBNySUN4n+vxPyZ/xX31
         pv1PsoFU8hAxj3Bx0AHUX197AqRtAQaHiBVSd0fJ+EMCkPYK5w/MQQU/EnrnCULQZRwm
         Tomyqdf0tnu52Pk4w29l88GYiY7p2sXy+NyKc5kGoxRtlLzRSix4lsd0A4TCMt+1T5Dh
         lS48kORO4R7Zy669WzAOlvNylYuCYpO7Hqva+beYsMwQFVEd5QUigD1DDW+AAHE+QcIG
         Mt00SvwbktmCxS7bqs0cTmsD3yBK3Wt3AeZkAD9UrP4mA0jm//JJDoAp+R/x9NFv4wLD
         nJ3Q==
X-Gm-Message-State: AOAM531mECdbAozbfSpu2TUuarwlcEWco29O5VID5CXM9FhRz9kfSpTe
        4ol5jzQZ8UXq78TUOIn1aiuTFqUBHCt/ANZcaRg=
X-Google-Smtp-Source: ABdhPJxz8T+IGcaNvAmxjxmTqVmYj44iqVyhsTtOp6StfriUV87zUZG6wcUfIh81/sq051k3r0/yl0hoVwuZiYitvdU=
X-Received: by 2002:a17:90b:4f41:b0:1e4:9081:6aa with SMTP id
 pj1-20020a17090b4f4100b001e4908106aamr32004733pjb.183.1654612753048; Tue, 07
 Jun 2022 07:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-6-alvin@pqrs.dk>
 <CAJq09z7gRosx0uBRCyP6xc0GUFMgnKCdry3BL-iB13M=JEY3hQ@mail.gmail.com> <20220607142938.u2alfq52wojb327d@bang-olufsen.dk>
In-Reply-To: <20220607142938.u2alfq52wojb327d@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 11:39:01 -0300
Message-ID: <CAJq09z4SSsG_SgDp6RSuLjHzqviaiiz8GK8tjbhLOLi6=5eAXg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

> > That's a nice patch. But while dealing with ext interfaces, wouldn't
> > it be nice to also add
> > a mask for user ports? We could easily validate if a declared dsa port
> > really exists.
>
> At best this will be useful to emit a warning for the device tree author.
> Can you see any other benefit?

No, that's it. It might avoid some headaches when someone simply
assumes that ports are sequential.
All models have holes in port sequences but it will get worse once we
support a variant like RTL8363SC that port_id starts at 2.

Regards,

Luiz
