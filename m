Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680A7264596
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgIJL4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730474AbgIJLxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:53:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF47C061795;
        Thu, 10 Sep 2020 04:28:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f2so2062225pgd.3;
        Thu, 10 Sep 2020 04:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJV3WNyaxrzsPvTQXCjdL06gQE6s3VLAjqwsh5YtZqk=;
        b=HLZJoPgVtada0k+w1Vlw/QLgbERepcdMoG+DxIvIFv3PKXozfpFlpSnx7jhG3wpKbX
         1Sk+GNgSzf33FKosgqOnB4m0NL7hj6vdEfWsQNmzZ0OAODJt4BXR6/q6oNz4Dy4anWu2
         XW4593ULZa56fABgR41HUf79lnU4yu9KiO5tBiPVPOgYs423FLhlIFsb2uw3y95R2jtZ
         wsXLmBu1xKqGwFu5WzlgrJJKot41DNWTVAOWMlM3imFDl3g5QSorIN/vboPGQLZi1mOu
         Zui06kRkTckKo1HX9AoJT0GxxTC10s1EgrzMexLBXwZDbzLWz1Ua1qT2T7sAix/QmYCm
         U5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJV3WNyaxrzsPvTQXCjdL06gQE6s3VLAjqwsh5YtZqk=;
        b=k3x91Z0CofGl2AvzYo4JqyY2KdlYTjg5hHeex0mxqxZyjykuWb+m//lVbaV9T+qxNA
         Pymcu1AyQPQLRVW2zdip/Y2vOruCyhSth0hTj5JF/5QWpHO3Gxs0ygVIpQ4qm7WQx49+
         BqiXSl5AZhglQN/CZeT0tSJSk0OCmGq7kIlYxLDnGSt2WuOmd3+Ds1Q26NpjXsWYzoHe
         FeWL7J3suQC/Daf4EQI1Wqh0QyKrk058oh5AvSGNcYGZtAhgzPeNr9Gy3cQj/QETnZLw
         vmkF+YQJ1lBBCWMs2si476n6pJu+bWOrlB3VWyDUt3iRR84OsgOwM5kCsddlWLCHC/sZ
         wL/g==
X-Gm-Message-State: AOAM530bFBTl/qB0Ncg9iXDjLXza52T/wKfw+pNSdbERbxqf482KzFOB
        4N4buT36W6mCI9BgEzLcn3fyuB3726FtZaempx7JpI6Ri7gqfg==
X-Google-Smtp-Source: ABdhPJw59PgWYSINH/x1vfIB1iJzf2BJ0ZGlPsG3JS8wXt6v/msJq5KIv5VXRTlwElVmtZP+ooDW8H8U6+oXO3hnm9c=
X-Received: by 2002:a63:c543:: with SMTP id g3mr4194253pgd.203.1599737333085;
 Thu, 10 Sep 2020 04:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu> <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200910082512.GE20411@plvision.eu>
In-Reply-To: <20200910082512.GE20411@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 10 Sep 2020 14:28:35 +0300
Message-ID: <CAHp75Vf9DJZhOMcaAebtQoz_biY1kFS34W1Fp0kdDFiDm4T7vg@mail.gmail.com>
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

On Thu, Sep 10, 2020 at 11:25 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:


> > > +               .param = {.admin_state = admin_state}
> >
> > + white spaces? Whatever you choose, just be consistent among all
> > similar definitions.
> >
>
> Can I use following format for one-liner embedded struct ?

Of course. It's just a style matter.
My point that you need to be consistent over all similar cases in the code.

>         .param = {
>                 .admin_state = admin_state,
>         }
> > ...
> >
>
> I think it looks better when all of the members filled looks similar
> (even if it requires 2 additional lines) instead of having:
>
>     .member = { E } ?

I like the former one (as you do), but in some cases when you have one
member or an array it's convenient to have them one one line.

-- 
With Best Regards,
Andy Shevchenko
