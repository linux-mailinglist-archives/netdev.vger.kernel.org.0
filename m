Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04CE446D04
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 09:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKFIpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 04:45:04 -0400
Received: from mail-vk1-f174.google.com ([209.85.221.174]:38763 "EHLO
        mail-vk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhKFIpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 04:45:03 -0400
Received: by mail-vk1-f174.google.com with SMTP id f78so3627463vka.5;
        Sat, 06 Nov 2021 01:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1pVKA7dyjDYxY6i7LUX+t0P9FEAxjV5dYpHvfaksXU=;
        b=3Rfg4OkDpVEYNiqozLj9GgzA7Sz/ejXp/trynZ42yMJBubt0VagVml/0FLknl+qaJ/
         8aOsf65BYEm7aYTdecMrLYGqO2G9eLOYvd1ILhJAXle0l/OFv52r9yDUOv+JNvwQiHdc
         RdHjPBNqX/VNL5F5q4PSZcelV/tD4AwxhPn0A/cli28jUO2/z85kfZbUSvJ2YcfRrRHk
         L5YF3hCe3Vjg9/l3SUHs+yXTfiH/YRzrMmL7Znb7TfTz07MIO+NSbjzLvO3ximaqHJGd
         BVgIyJxh2W69ThG2fascEUxEFSSd1+w7+DdCX3PDf+yEQxkZv6Vnp11ZinxYYUadvQGJ
         hh2A==
X-Gm-Message-State: AOAM5324J/WW/ejmww2llLbKLcIkrrQmJaHKato242p/pB7zhh+1tVl2
        mmQA1kRt+LNFb5LGMDFml3jCuanP2cBtug==
X-Google-Smtp-Source: ABdhPJzrAy0WGAJuRH1q8aFvB9upFzkjgQ2vCJkh/gETu4gAWWv81cnmT9TtLSRTG0STV+uEctmqYQ==
X-Received: by 2002:a05:6122:2201:: with SMTP id bb1mr77887769vkb.19.1636188142239;
        Sat, 06 Nov 2021 01:42:22 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id az30sm1590176vkb.53.2021.11.06.01.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 01:42:21 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id d130so5757767vke.0;
        Sat, 06 Nov 2021 01:42:21 -0700 (PDT)
X-Received: by 2002:a05:6122:1350:: with SMTP id f16mr8804047vkp.11.1636188141461;
 Sat, 06 Nov 2021 01:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <8a5d8e0c-730e-0426-37f1-180c78f7d402@roeck-us.net> <VI1P190MB0734F38F35521218A02CF2048F8E9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
In-Reply-To: <VI1P190MB0734F38F35521218A02CF2048F8E9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 6 Nov 2021 09:42:09 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWXLU64wxnJe82ede0ALrQM6ie+7czy4WtUfGLDufWX4g@mail.gmail.com>
Message-ID: <CAMuHMdWXLU64wxnJe82ede0ALrQM6ie+7czy4WtUfGLDufWX4g@mail.gmail.com>
Subject: Re: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Volodymyr,

On Fri, Nov 5, 2021 at 11:42 PM Volodymyr Mytnyk
<volodymyr.mytnyk@plvision.eu> wrote:
> > > From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> > >
> > > The prestera FW v4.0 support commit has been merged
> > > accidentally w/o review comments addressed and waiting
> > > for the final patch set to be uploaded. So, fix the remaining
> > > comments related to structure laid out and build issues.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
> > > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> >
> > The patch does not apply to the mainline kernel, so I can not test it there.
> > It does apply to linux-next, and m68k:allmodconfig builds there with the patch
> > applied. However, m68k:allmodconfig also builds in -next with this patch _not_
> > applied, so I can not really say if it does any good or bad.
> > In the meantime, the mainline kernel (as of v5.15-10643-gfe91c4725aee)
> > still fails to build.

>         The mainline kernel doesn't have the base ("net: marvell: prestera: add firmware v4.0 support") commit yet, so the patch will not be applied.

Mainline has this broken commit as of Nov 2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
