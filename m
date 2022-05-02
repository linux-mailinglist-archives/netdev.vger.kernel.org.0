Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13674517A05
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 00:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiEBWgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 18:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356883AbiEBWgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 18:36:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA3A101CB;
        Mon,  2 May 2022 15:33:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so562951pjm.1;
        Mon, 02 May 2022 15:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RN7iPKfXiI0ODvO6fiRKvCIYJ/S4B8bkSMPoiaNiTU=;
        b=ek6vYhim/PWLQ2hXUsh6x4WaScNf16eAWZ8nzuBUJvCPfbcnXZrn8isQmhj2r9DziJ
         UT4QJibAAfUZI6QsIZZPFy8gV9sJXhucXcrlv2z/TwuRAQZOkX2zgLgJoolXftmnhUrG
         CsGB78AnbDdcbs+vrL+jBZF9+VTzeqBH1rFqEA1iViyInnNu7MrvDC2X3eo7Z11lJpSB
         VqnO2SUVuUcxxYce+L4EVUuQTKYVj+6bTVHgNsGpSVQGfsipbTzIWMfsfRaZXAaev+rV
         jjbvgmFB0H+ISw1dvnKV7wF9SJ2hdN+OHNXlGt87ABJDfDQ92BnH1zgVtI1S5q62WAEA
         if+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RN7iPKfXiI0ODvO6fiRKvCIYJ/S4B8bkSMPoiaNiTU=;
        b=njb04eqza5nsiMNrnxYfU5Roortf/50/+HDsd2M5s6BJz0+NZJS4kLMznV+HNseSTr
         2qlkwlJUeGayAfwxgw/5Jyy6+QNCva5jICR3yAiAqyZl/pEWCC/OG/fPbLlK/UF+vC0X
         rRi0FNAHzJzDx2CL/g144TfaH2Y4KFFaJa1o9PCWcVcwigMe7ttBVh5m/wMRYzX93d86
         Fqxc6pYiMriy9Zkm1b6cynqC1KMs96dbiPNcnwgVlBwDrFrqQg9bwGkxT1eVD68YwBIF
         qxB5gGe9O1seQjER6gKsrkZd4dRzyfBYrn5j84ZH31Zd0A4xsDUVAH5/t/4pmvKlMdN3
         BUSg==
X-Gm-Message-State: AOAM531GL2EVVR1gTuv3gEbMyELD8EVRtW49GbJX/xsWO6FkqFrxVUZg
        MSrW6LuyX+HbsH3TfSCgs/NaM7gdIS0SsR3Sj/E=
X-Google-Smtp-Source: ABdhPJy6XehrLW6wVnUG9BbFa9uuiZkoB7Bnzi3oTcFmeZf1t/7Gt2CgNdE0jYMhNK5AXysIWlNFNMjSnYWkQWjyeHw=
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id
 s16-20020a17090302d000b0014d8a8d0cb1mr13872488plk.50.1651530782937; Mon, 02
 May 2022 15:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220430124803.1165005-1-mnhagan88@gmail.com> <YnAlBvWyyJ9oDcpz@lunn.ch>
In-Reply-To: <YnAlBvWyyJ9oDcpz@lunn.ch>
From:   Matthew Hagan <mnhagan88@gmail.com>
Date:   Mon, 2 May 2022 23:32:51 +0100
Message-ID: <CAL3BVdq-OkoJM8LEXvJLW8HS3n8-VH3KrM-A8CbjUm9SC3r3vw@mail.gmail.com>
Subject: Re: [PATCH] net: sfp: Add tx-fault quirk for Huawei MA5671A SFP ONT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 May 2022 at 19:37, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +     if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
> > +         !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
> > +             sfp->tx_fault_ignore = true;
> > +     else
> > +             sfp->tx_fault_ignore = false;
> > +
> > +     return 0;
> > +
> >       return 0;
>
> Why do we need two return 0; Probably a merged conflict gone wrong.
>
Apologies for the oversight. Will submit a v2 shortly.
>     Andrew

Matthew
