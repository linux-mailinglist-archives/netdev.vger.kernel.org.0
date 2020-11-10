Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CA2ADC69
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgKJQvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJQvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:51:00 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343FFC0613CF;
        Tue, 10 Nov 2020 08:51:00 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id h26so4147575uan.10;
        Tue, 10 Nov 2020 08:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2fke6SNE78arONNLo03LN6tLXiq8mc1yC6giNIagFQ=;
        b=bA5uUF19oRrzOd4oaigCdDwfRWwrBXT5aFHXFJm34rrPM5gbHB29KKq2lbq43n8TkD
         kRvoaPoBOP1TyxPSAPdCbNYynt0Xlzkm5KJwdHhB+TTk4TEyJLa3+vaXi6yaYKnPjY+M
         TdYUVmfb7ESvi4HgmbFjIQ+ip9jAYnRI4X1qe+T9r7NBLFoH+x29ha20qtrDZ6X0U0ft
         T5UvjXPr+R0qddTL8qPoG5fl8aWJR8m0wsVS8k73a1DjpdA3tc5diJgHXoYEfW48DDfV
         5MQSaWvCcq6vizH/vCHHa+DlsC3BurwvH9dybwkriTcWxl6b+kUteHUMgoGPsG6xdrsL
         zZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2fke6SNE78arONNLo03LN6tLXiq8mc1yC6giNIagFQ=;
        b=pkjzgqpTsfvGTPmOO25amyVabz4zBvYv27wzXG21eRzrw2nquz+o6m4eWTjoz+WQTF
         UcVlte/ckIWPROe4sMeGbRNvp52dP8RbmG+DOG3s27vgMvTfxEDZBMwYUeeXGxU5jZgJ
         bKrQ5CTv3vN/kjPcuoOPHQGxs8LhFgGgERQRPEaImUb1OvaOZMpcNU5/JIoRNEaUB/x+
         zzrOQPoqMnVv4lCKwWl3QVMjsULjGr5gwhXgudP2+tNtVziEPOnjhX9gEtZyYzBp11Mu
         z7BFz/eyj0lTgjJGyoc+/emQUKgttMrpISvjYFr249HrInNil9VWoVVL+M7Z+b73Mfkj
         v+aQ==
X-Gm-Message-State: AOAM530GC4dGKSrKCxVrb0YvCVFQuAaRO9RVyz/WKEMuR+/EC2NxS42p
        gqQmlOVEJsKjAgAQOic1hkW6EKy9/rbgolLnZYU=
X-Google-Smtp-Source: ABdhPJyzMHeIx4nPgOzA6O0HRgI3ylVtWtGxTNPsxoW2CGjovQvP3LRzfRdi2urV5of0+I/bG62rU18AdBBEHru1cNI=
X-Received: by 2002:ab0:380d:: with SMTP id x13mr10663454uav.41.1605027059205;
 Tue, 10 Nov 2020 08:50:59 -0800 (PST)
MIME-Version: 1.0
References: <20201110142032.24071-1-TheSven73@gmail.com> <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
In-Reply-To: <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 10 Nov 2020 11:50:48 -0500
Message-ID: <CAGngYiVxca29mPoGxP11QpaXxegLGCVL7Boe_AqS9nnujRcZ+Q@mail.gmail.com>
Subject: Re: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode flags
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Frederic LAMBERT <frdrc66@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, thank you for the feedback.

On Tue, Nov 10, 2020 at 11:30 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> I see that this is a fix for backporing, but maybe you can send a
> patches on top of this to:
>   1) introduce
>  #define SPI_MODE_MASK  (SPI_CPHA | SPI_CPOL)
>        spi->mode &= ~SPI_MODE_MASK;
>

Andrew Lunn suggested that a spi helper function would
probably fit the bill. I am planning to submit that to net-next
after this patch is accepted in next (and next is merged into
net-next).

I am learning that net is only for the most minimal of fixes.

See the previous discussion here:
https://patchwork.ozlabs.org/project/netdev/patch/20201109193117.2017-1-TheSven73@gmail.com/
