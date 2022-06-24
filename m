Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9FA559AB1
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiFXNvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 09:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiFXNvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 09:51:55 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733D4CD4E
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:51:53 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 184so2406877vsz.2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+Pg6eN4YBw2V6KWEmR9iHst163BJiNHOV9Nh2jxubpU=;
        b=EXxOIh1mmtjxZd/xrBTtqwZWm49pox2pKpzVL5a02T1l+u9+pAUqHtjWNCBfzpV1HE
         80xFf4UoRpV1uxEoha2BooJpr/gnrOiPFoHCyMfx6HB/YzXLcVv2CF4rvGLd2FBDrnkt
         rYvTIQC4t+ybjdHPCavctYM8bDdU0pKtCGeIQ3sPlUTKCG+CRNV98OhgYID42vL5DNIW
         syYfjfRCdLd9vHbBcCHaf06QvIJfKOqC87tP5P7xDak/j6vSbKtp/wrAtEgbtL7h6q77
         pgMe1GjbSd2f4U/HYiGFvvKQ9i1RfUNhhTGUOmk8PqwMvqI3iKzT4M6h2eAgc7rPVu8W
         7GDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+Pg6eN4YBw2V6KWEmR9iHst163BJiNHOV9Nh2jxubpU=;
        b=7RN4y8BkNAlpTPfzIlwRYk8Zn8S6tGrJwukgm1n4Qh66CVkOFY0yELu6X3Q4tRns4Q
         rvBGAZQFwGe70d86Q1QV9m1Kze9BKEgrX4aAvBa2b/dFogq4aiH5F6P7MX9urJ6O/ehW
         EPjU+g+EIiRreH/itYcuOR6OG+CBHexP5lRRYuUSLnedxFXBeUYPzTl6rd6HGSYFksnf
         9G0ib4W0MzzcJ/n57CXa4vqWrfdMA49swIEfRORKd7tKhNAdK1jEm7zCWUTBPe/CXdbQ
         xw4ysVnPhueQpHcd6bHXch9gRoUW6c10HBr7ZKA5yyIU0hAnVQqaCuPnWsvQp+gwqAJB
         N5/A==
X-Gm-Message-State: AJIora/zQozlPlo3+L3vfXjE5Mfeu0NqIq/CFckPezbqr+1bwZ9t8a8l
        KJL2Mgycu2aVIfiSqasZuWpUn9uojznVwS6tkQs=
X-Google-Smtp-Source: AGRyM1uF0xkUVhBDTvniiJvkfP+2dwz5IlwGruKe/RlV49x3ibNc9CaPv36KaGaWEkSux8RF2oD5CtkzA0Zd4qdC+Pg=
X-Received: by 2002:a67:6fc3:0:b0:356:18:32ba with SMTP id k186-20020a676fc3000000b00356001832bamr4387268vsc.43.1656078712567;
 Fri, 24 Jun 2022 06:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org> <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
 <20220623202602.650ed2e6@kernel.org>
In-Reply-To: <20220623202602.650ed2e6@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Fri, 24 Jun 2022 16:51:41 +0300
Message-ID: <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, xeb@mail.ru
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

On Fri, Jun 24, 2022 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > What socket type is the ping you have using?
> >
> > I use SOCK_DGRAM
>
> Strange.

Why is it strange?

> > I want to find out, the creation of gre and ip header twice, is it a
> > feature or a bug?
>
> I can't think why that'd be a feature. Could add this case to selftests
> to show how to repro and catch regressions?

I don't really know how to do it, but I'll try
If we just talk about selftests/net, then everything has passed

> > I did everything according to the instructions, hope everything is
> > correct this time.
>
> Nope, still mangled.

Strangely, everything works fine for me
