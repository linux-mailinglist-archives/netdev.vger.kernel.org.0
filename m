Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C37C52BF08
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiERPjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiERPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:39:04 -0400
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB489A99C;
        Wed, 18 May 2022 08:39:03 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2ff53d86abbso9657537b3.8;
        Wed, 18 May 2022 08:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmfnjDJeouFUy0aiSyOEBgewGf2fEkharBOYDbsVzWw=;
        b=MJS6aUYxTKmY0QylJ42zztW9uY95TJaoJufM+QZXnDzsXJq5yX9Wrx91q7ejGijq3d
         r6k/8QzqFG+IDi7FPCeZuttWEqCsJwxCpkMCnHsZNXSQsO03uCXGD37d81j6isi6FHBn
         DGP5Lvf2Z6CIgyEDoJwji78N/3sZNhgKDaQ/ekJtDg52iKp5EjBb4srgZOuT4h1oBkxN
         BQSiUw7+ARmo6l1agaBbnNSS8/fw23yzfjP95f+KNuG51Gms1WKSh86EQ7i6StO+bAmq
         UwoHw7OMi7KwHHYYnVZiYiwnvlip1lvVp6sfOK9oOv7OA2cAfwFazp4zxsD/sU7GLTWS
         5SPA==
X-Gm-Message-State: AOAM531fG+7moMqBHNVZK9IlMyL5619spAdIKUD6XXXzftlf7W5sr+es
        CrNMbmgdK58poTRquwRhUpAye0NLQ8lBvKvDBWLGxZTNWxw=
X-Google-Smtp-Source: ABdhPJyD2v0szDdFGjtMjxD8lRX+sOvcEUPPfS3ZoeX2qjjtty1M72FsFwqC/nBQBaUOH0qwfAvh0aYuC4xb/o7kqu0=
X-Received: by 2002:a81:ff12:0:b0:2db:2d8a:9769 with SMTP id
 k18-20020a81ff12000000b002db2d8a9769mr7443ywn.172.1652888342678; Wed, 18 May
 2022 08:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org> <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org> <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net> <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
 <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
 <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net> <20220518143613.2a7alnw6vtkw7ct2@pengutronix.de>
 <482fd87a-df5a-08f7-522b-898d68c3b04a@hartkopp.net> <899706c6-0aac-b039-4b67-4e509ff0930d@hartkopp.net>
In-Reply-To: <899706c6-0aac-b039-4b67-4e509ff0930d@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 19 May 2022 00:38:51 +0900
Message-ID: <CAMZ6RqJ5hXwE5skJLxRVAH4-RB8UkXmQdZWW_z=jj+bXzJZY=Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, Max Staudt <max@enpas.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 18 May 2022 at 23:59, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 18.05.22 16:38, Oliver Hartkopp wrote:
> > On 18.05.22 16:36, Marc Kleine-Budde wrote:
> >> On 18.05.2022 16:33:58, Oliver Hartkopp wrote:
> >
> >>> I would suggest to remove the Kconfig entry but not all the code
> >>> inside the
> >>> drivers, so that a volunteer can convert the LED support based on the
> >>> existing trigger points in the drivers code later.
> >>
> >> The generic netdev LED trigger code doesn't need any support in the
> >> netdev driver.
> >
> > Oh! Yes, then it could be removed. Sorry for not looking that deep into it.
>
> I can send a patch for this removal too. That's an easy step which might
> get into 5.19 then.

OK, go ahead. On my side, I will start to work on the other changes
either next week or next next week, depending on my mood.
