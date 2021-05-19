Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD14388AD5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344597AbhESJlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhESJlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:41:31 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E9C06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 02:40:11 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id d21so12539779oic.11
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 02:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tE7mS40xiDAuFn3suWIPM6V7UsgaYqY2fuvjVbDU1V0=;
        b=mi4qrZsKPm8r4Z6SnsszRZw/9ewz+cT1OoCwq0rjThxu5xsozm+zZad+RVRQyI9V+0
         K+e7MlR8rIZeS2R2RNj6/sQmO8D7Bmfh5fkznbEudwcd1toPaI6D5k8cgafjzpHK6ndn
         NfcbENcro/4haJ+xySN7lL16jQTltIX8w0ygCj3FHViPUSdZfK0vUnPFr6nYsy/ED3Pb
         GxGarfpuTyc/DcdatlZGf9yjs3ILKfy1IrQYR8sbHvCLI28zOfi+5Ff86I9jkhr7yozF
         fZei6h6DgWdyq78kOMFR/16WJ9Qs/bgKCjMXWdRloqCHGa3XcwkUyInBrJ2PZAkUHMDZ
         DdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tE7mS40xiDAuFn3suWIPM6V7UsgaYqY2fuvjVbDU1V0=;
        b=O3OxZzFTlAGYXJxMa9rMpNGlCJB9uhSoMLr8xKptaDSInZPSWZnstOmNEzn9k+Mx+W
         w2fJ8BfUGukwTlNupdyCz6pkEHrjZ8+qOTCaU6aLhkehDyiVb2X3bfH4M/WEjuTOtXYV
         dJLbQt7BjAcejnll8spCXT3o4VimJQCFFIoV5IClZBeksWhEgTITY/m7mHG/E/1cIfqR
         +z1OBX5RU39TiAervc5cxWj87XL007prajlu86+CYFCOrbhCS2jzJGvO5QPsCYvd9qtn
         fctaoNdEpIkfezxtELqwng2L27aWTwNz6BsIT1BFX36zcgo/CDvhT61m7yusY5yu/WNH
         9YYA==
X-Gm-Message-State: AOAM531rRa6pFYNgkVwzYx5wo7YJ2ZZ9Dwqo/shV3wsXwU6SQFh0FjFa
        OIDWWAKL3Z+8RWXhyiTeuKdxjuroNBQKi0Px9Y3dcw==
X-Google-Smtp-Source: ABdhPJx3A8NMCJRqqdNev4DpNtcI+FOVjaBa5GAVrAEHY3GWOiIpE+d9Cwjc+aO8KOdZkmuA5OKsyEMaf1yyYMxg9Cc=
X-Received: by 2002:aca:2818:: with SMTP id 24mr7273685oix.67.1621417211183;
 Wed, 19 May 2021 02:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
 <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
 <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com>
 <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com>
 <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
 <CAMZdPi9zABtXoKiUuE9mmbnYsSmZoVWR+nLAdq0O5b7=Ghh-rg@mail.gmail.com>
 <45436a3b8904d08a0835f9a7973c28bc46010f20.camel@gapps.redhat.com> <CAMZdPi-p13nk8OES-Fdc2hjTak8Ywk-TabYaeJBhS=kF0QFyag@mail.gmail.com>
In-Reply-To: <CAMZdPi-p13nk8OES-Fdc2hjTak8Ywk-TabYaeJBhS=kF0QFyag@mail.gmail.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed, 19 May 2021 11:40:00 +0200
Message-ID: <CAAP7ucKrQeXhxuva_QA_M8us1Vp+EfAAHjCv80Ouh7XZi4Ma0w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Dan Williams <dcbw@gapps.redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > But another thought: why couldn't wwan_create_port() take a devname
> > template like alloc_netdev() does and cdc-wdm can just pass "cdc-
> > wdm%d"? eg, why do we need to change the name?
> > Tools that care about
> > finding WWAN devices should be looking at sysfs attributes/links and
> > TYPE=XXXX in uevent, not at the device name. Nothing should be looking
> > at device name really.
>
> Right, passing the legacy cdc-wdm dev-name as a parameter seems to be
> a fair solution, making the transition smoother.
>

Reusing the cdc-wdm name is indeed a good compromise; plus then
reading port type (QMI, MBIM...) via sysfs attributes as you suggested
in your last patch would make it work perfectly fine in userspace.

-- 
Aleksander
https://aleksander.es
