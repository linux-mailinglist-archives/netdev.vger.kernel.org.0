Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F71260EC9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgIHJi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgIHJi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:38:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02874C061573;
        Tue,  8 Sep 2020 02:38:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u3so4513709pjr.3;
        Tue, 08 Sep 2020 02:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jApnbaGdNy0XZvmrHRfVLH08NM0ISkHskFMyba/3Dz8=;
        b=MJgUDYj8lMeog10h/pcRqjqbqd4X6zcLeZsrh/MY0BGBr/BLaGO/3pkJz37iAaPw7O
         OKhZsUpuQ2bIXXpe9BNkGpRexLHz10IX4Pa1nflggIzhohPRQmZzpDSo0CSz+x/ap6D8
         2y8YaVq1RHfwDSZ3pYjVMWqanp5hDxiIRqmXANxRiAaeSoxxHpCFxIxXistH/ZCdro4L
         JJ20dsUOKC3/2LZjn2zl6a3T9LEZmIIEX35TFizLxw1yTErjuHlmGmEKMVQXGbfA3vZZ
         6D3AucxfnJP7UApg9bsullWCQBoQGs2Fi8iq8w5RRA9jkDeeMTonTWpEjbf6Q6THXiK6
         s9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jApnbaGdNy0XZvmrHRfVLH08NM0ISkHskFMyba/3Dz8=;
        b=r152M3A7NeNPMJvwp8R0RUSdQWTtdrgJntrgUt2wEbBgEwpsf6tJGsrgFoLtsWUcXV
         b9m+68WRQkIy7VWu+PWv4j2a2KI0l/q7d1Ly4S/M9TdKf3gyOemTowqYCs9EF/TeUHol
         9zXwNXN2hKigwQZKjAgDY5k7LwS4f3c91/ASWgfvqU7NffU9iVe0uofDdQTKPgS1UiVZ
         vKtAsg4gtXM1XA0+TpwsYxOKzk93O94hC5VLB8SyDcyOmGD08c+3Kkv8QPd7YZxf2A4S
         pVI3TLWIaj5krdA74tYNI7yBtUkRuA5stv+D1lYW2kuqMINWtGZvhkye4bmnX5I8/9n/
         aQyg==
X-Gm-Message-State: AOAM531O6QZOPEx/fO86+lwHtBjPbZU9B6GuP7vAh+20lW5Z6bI7vfRB
        +0JpnDI2YyiIW3MMoVCxc816B8jvdf+7JacDkpY=
X-Google-Smtp-Source: ABdhPJyxAbCwnDQR7EXhbAKVRK/L1mgougVfa4ksNuqH1dcnUnGkAUwBxsj7BOSjmWVm1lw4MgxRSvmwQq4xy2GW4u4=
X-Received: by 2002:a17:90a:fd98:: with SMTP id cx24mr3015644pjb.181.1599557902306;
 Tue, 08 Sep 2020 02:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu> <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200908083514.GB3562@plvision.eu>
In-Reply-To: <20200908083514.GB3562@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 8 Sep 2020 12:38:04 +0300
Message-ID: <CAHp75VdyahsNyOK9_7mFGHFg_O47jVQWro-mhU0n=1K17Eeg8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
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

On Tue, Sep 8, 2020 at 11:35 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> > > +       words[3] |= FIELD_PREP(PRESTERA_W3_HW_DEV_NUM, (dsa->hw_dev_num >> 5));
> >
> > Ditto.
> >
> I am not sure 5 needs to be defined as macro as it just moves
> hw_dev_num's higher bits into the last word.

And why 5? I want 6, for example!

...

> > > +       err = prestera_switch_init(sw);
> > > +       if (err) {
> > > +               kfree(sw);
> >
> > > +               return err;
> > > +       }
> > > +
> > > +       return 0;
> >
> > return err;
> >
> why not keep 'return 0' as indication of success point ?

Simple longer, but I'm not insisting. Your choice.

...

> > > +                       if (b == 0)
> > > +                               continue;
> > > +
> > > +                       prestera_sdma_rx_desc_set_next(sdma,
> > > +                                                      ring->bufs[b - 1].desc,
> > > +                                                      buf->desc_dma);
> > > +
> > > +                       if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
> > > +                               prestera_sdma_rx_desc_set_next(sdma, buf->desc,
> > > +                                                              head->desc_dma);
> >
> > I guess knowing what the allowed range of bnum the above can be optimized.
> >
> You mean to replace PRESTERA_SDMA_RX_DESC_PER_Q by bnum ?

I don't know what you meant in above. It might be a bug, it might be
that bnum is redundant and this definition may be used everywhere...
But I believe there is room for improvement when I see pattern like

  for (i < X) {
    ...
    if (i == 0) {
      ...
    } else if (i == X - 1) {
      ...
    }
  }

Either it can be while-loop (or do-while) with better semantics for
the first and last item to handle or something else.
Example from another review [1] in case you wonder how changes can be
made. Just think about it.

[1]: https://www.spinics.net/lists/linux-pci/msg60826.html (before)
https://www.spinics.net/lists/linux-pci/msg62043.html (after)

-- 
With Best Regards,
Andy Shevchenko
