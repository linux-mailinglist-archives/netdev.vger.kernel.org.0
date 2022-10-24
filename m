Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78254609D0B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJXIpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiJXIpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:45:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EE445076;
        Mon, 24 Oct 2022 01:45:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b12so28549078edd.6;
        Mon, 24 Oct 2022 01:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1PI6YXl38ZK2V0beNEuf7h7mikagmruTjea1nZRYjm8=;
        b=CiDYLQrhxuOQwlWa5h3fy+Gmyh8KwbyHZLnSQ8U1Rh8NwgBSfwCytGQ8ZoGLf7Ir4M
         PAm63EIWVAcBBFIZoOhRi1XwY+NePgWbXLuuAgQDTfCX2OGtzOi7YtqwnaD7Osg1EFLe
         D/lmQx54SaJLsthbTv7o4NbNoQZD8spZ4pBg1KwnTgjDMx8iY6TMTc+p1uVbM58WcLAD
         pTYi8soLgxMgz8nWtFvA+G71mYiZJm2lnWSGNDNJp9f1WA0g6DLL1sG/Zy3IyO/vQRi1
         5a+8vVivrQUH8Bleo87r3EibsvjTgTUV8mOdD7+HF7Kx+oXywgQkJVDkXeZVuQwv3cum
         cvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1PI6YXl38ZK2V0beNEuf7h7mikagmruTjea1nZRYjm8=;
        b=SHgKdjv5d4Noy+kwIj5/ZwZuORfTMvYLU1XwhYrIqsVe1Fsr+3Tb1//SoFiup+9xtB
         ZsHWfHsxhO2zK2Oi2rsx9m/BlbYfeqo8Q52Ps714dV9pq4KeJcp7MFItdokNq00q/sqR
         FicesipkzNvU2Piq7ruZ9Mxp1uBBsYH+1BLm/IF3EZhfawBUcG+vzOmTebjiMKrjFrVx
         uzvHett/l8XGUA9t8TnmG3gDqhLtzvlTztsmDfrzCz1+38kM8oE2NscGjXo8e0/qHrqw
         beJkW+02GKrSfN2m+OYoiBcWmoPDMk/Vt2W/h2vf5f9ikRJ2moNmOXF73uDaDvaeyxAR
         JI7Q==
X-Gm-Message-State: ACrzQf0egTnDUoLLw5smKGrRj0Z9Bd6OaoC0PK37Mj9WZMu8RFH7hcKn
        mj3eBJdmn/28vwYAAxFhJnYLocwITw0g3pYnaUo=
X-Google-Smtp-Source: AMsMyM4lQxPO5NaPH2GmuBPZCAvfIjfJoWedY6F6nBTib6CcAtkKQcVwkQogg3KrVqF+jyfQ5OKDK4dQWdm7o9ejUP0=
X-Received: by 2002:a17:906:fd8d:b0:780:997:8b7b with SMTP id
 xa13-20020a170906fd8d00b0078009978b7bmr27005280ejb.635.1666601144530; Mon, 24
 Oct 2022 01:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221024053711.696124-1-dzm91@hust.edu.cn> <Y1ZIc51hxE4iV70a@smile.fi.intel.com>
In-Reply-To: <Y1ZIc51hxE4iV70a@smile.fi.intel.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 24 Oct 2022 16:43:37 +0800
Message-ID: <CAD-N9QWhXWNjuzf+f+bOup2GF_HRzSvRDiajdsHDKu1yke+qgg@mail.gmail.com>
Subject: Re: [PATCH] can: mcp251x: fix error handling code in mcp251x_can_probe
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?Q?Sebastian_W=C3=BCrl?= <sebastian.wuerl@ororatech.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 4:16 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Mon, Oct 24, 2022 at 01:37:07PM +0800, Dongliang Mu wrote:
> > In mcp251x_can_probe, if mcp251x_gpio_setup fails, it forgets to
> > unregister the can device.
> >
> > Fix this by unregistering can device in mcp251x_can_probe.
>
> Fixes tag?

Fixes: 2d52dabbef60 ("can: mcp251x: add GPIO support")

This commit adds the mcp251x_gpio_setup function, but with an incorrect label.

>
> --
> With Best Regards,
> Andy Shevchenko
>
>
