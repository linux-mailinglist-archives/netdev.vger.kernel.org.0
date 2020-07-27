Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8936722F3E8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgG0PeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgG0PeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:34:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E999C061794;
        Mon, 27 Jul 2020 08:34:00 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k71so9617485pje.0;
        Mon, 27 Jul 2020 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcY0A56aPSXRoinZe6gcqtnoZNboGx9+nJBDiq4Vbx4=;
        b=oX9WXK5+2EvvTcwgfnjjqmWJEGAJFSDR+6Y+PALc3mZWl6t1xf36+ZokY1jfxLY7Qx
         vTu998n7s3xDkI9n/LSZS0dMqffhKSJKb0hFh7pcle5RV5Std2H1RZ0r4v04vaJrnhzu
         BRE3xUNHmeKVI2lsgqw+dSq9Rsmm3SHV+jCO3Kya+2LiTdlGvTzXMwtFZmNIgY420cJ3
         e3W1GcEpIkCg0b79rAC+Ylq0CRIBh/T6VaY5/tg2M4JsO55k3cZKtH4euSXLnN6zoNOB
         zG5Xhio5Ex4GeOLHwdwafmRKUSc4Ef25ch/lHKy5opAkEtNpwmCoowZSMZkkc/9Da2W5
         cG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcY0A56aPSXRoinZe6gcqtnoZNboGx9+nJBDiq4Vbx4=;
        b=jEz4G8DnIuFgy+X+sdCt3j7ThdhloA1yBGB/BNXvSXGsi4WA1xSxlK4J2qz870pXc2
         jbw8XllfRDeTXpGLIxVt+jyJGQ2ou3B9q8Vx46dUuK8YBAWEKlIAltieK/WCXpeapIt5
         BYMmq/3HSnQM04AlRsRcrPOD4u65D1icwmQPMs1rSkVdbftbQrNhyA0cvNvz21hcnZNm
         PpWl/Af29FTbtmos0ddC1514Ld7n3wzbvWvistdqOwTMV6tIjVIH18MOtVr5Agwqd4Kt
         UhSgYEh59Vzy/P/KcXpSg7JWgOXCufR5Ak1znH5ETgpwXXACbXC5PNxOwmbmgYfLYryF
         Oqjw==
X-Gm-Message-State: AOAM531HyZZUfuPuXn4slX2uC92CkJdXI51RkFTLP7HpaQtE9pT9TRaq
        LY/cNyg7Ad0sKQSpLIsMS53cj/9+1PZHc0HNDtU=
X-Google-Smtp-Source: ABdhPJwFOUmxIDqsOSd+NVchInvYpDQG+Iuwpt2fmGBMHos1KdESwfZEZIwNlqyS+wub10WN3LvGw7Njhl8UDVddk08=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr17086062pjp.228.1595864040131;
 Mon, 27 Jul 2020 08:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-3-vadym.kochan@plvision.eu> <CAHp75VeWGUB8izyHptfsXXv4GbsDu6_4rr9EaRR9wooXywaP+g@mail.gmail.com>
 <20200727141152.GM2216@nanopsycho>
In-Reply-To: <20200727141152.GM2216@nanopsycho>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 18:33:45 +0300
Message-ID: <CAHp75Vemcp1y3S09PVTQoyB10goZfhb1HYmeMxqiReQdQJ3JBw@mail.gmail.com>
Subject: Re: [net-next v4 2/6] net: marvell: prestera: Add PCI interface support
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 5:11 PM Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, Jul 27, 2020 at 03:29:17PM CEST, andy.shevchenko@gmail.com wrote:
> >On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> >> +err_prestera_dev_register:
> >> +       free_irq(pci_irq_vector(pdev, 0), fw);
> >> +err_request_irq:
> >> +       pci_free_irq_vectors(pdev);
> >> +err_irq_alloc:
> >> +       destroy_workqueue(fw->wq);
> >> +err_wq_alloc:
> >> +       prestera_fw_uninit(fw);
> >
> >> +err_prestera_fw_init:
> >> +err_pci_dev_alloc:
> >> +err_dma_mask:
> >
> >All three are useless.
>
> This is okay. It is symmetrical with init. err_what_you_init. It is all
> over the place.

We use multi-point return and these are inconsistent with the
approach. They simple LOCs without value.

-- 
With Best Regards,
Andy Shevchenko
