Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FA22A4D9C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgKCR5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCR5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:57:10 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2277DC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:57:10 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id f7so4170410vsh.10
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cmd/vHU2XpWN9RrkikP/uwzcHGztQHriQenbhifoFws=;
        b=W0iZ2ViLtWiGtTh4tYyeDJSlRjuWrEiPeo9pyaiaeroAkDmBc1BIpf8HUF6uOc3PEv
         L80UWx65jnFxKYYMS2SWdtr5iLvO3OjvhUduWd0TrBSB93wqKTMdoZBBIoBmcoTurlUa
         uyLfEY5nW5an1PxqHpGCXvwavubfMieQmbi19LkWDEwqY9B39nMXnUxASOljucw3uQH4
         VUdDQGs4YMuI/aI2731nXHL7al3f4uWSCy2/uy+j5yxVMnkDw/sJSmOR6SINVeOjQTWN
         5wQKJy6ogYLCsidNhzl2MTBYahMH+niyTiYdeerSnzuOvXOEcI9bICh6HvlEI9hIpY3R
         pErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cmd/vHU2XpWN9RrkikP/uwzcHGztQHriQenbhifoFws=;
        b=VferuKgv3oFKnCJbJT3kX4MO9tm/wB1+MRYcHhOOyuuQLgEKQ/B6zmuEJCGR4vohMc
         Zoo+4bdSiYIOd+GajEcgEdWVQ8oDQu9IWMSItkbj0HyF3rtY1Gt8PRtmSjZyZEKJORXL
         5GgDYnuC2QHCCC+rv2K2Qp0rHwuG+w7trHvlIbJUovm2ewTKm5SLNpoCFCOOk2qtU/Wj
         ghxk+Aldri7x4eUGDbrYi3OipsZ+Jn6rwT6XoIPCAASKQ4kQnTEqSd4QOlmo3p+L3Iyu
         AreqsMwgCT5s4UNBxPwhvuniH3teinzij6eNiIcq3xvCcEVG5Skt7ACguknJxVR9KuKh
         r/yA==
X-Gm-Message-State: AOAM532l/WDfabw01CH4PSTgr4wo4p6o/ymoFDQYEj8mh3YecVQqGfVW
        OIIoMBPm41NZzMHgVFrYaShNOVOcfNc=
X-Google-Smtp-Source: ABdhPJxeZavHEgzzVAnU/tPws1Es0L1TyMv6kLgaLMuKvZVAvINjzFgAKqtzGCfums8AwRtkCKYUaQ==
X-Received: by 2002:a67:de03:: with SMTP id q3mr16643836vsk.40.1604426227824;
        Tue, 03 Nov 2020 09:57:07 -0800 (PST)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id g7sm1510314vsp.25.2020.11.03.09.57.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:57:04 -0800 (PST)
Received: by mail-vs1-f47.google.com with SMTP id x11so7330183vsx.12
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:57:02 -0800 (PST)
X-Received: by 2002:a67:c981:: with SMTP id y1mr17877861vsk.14.1604426222523;
 Tue, 03 Nov 2020 09:57:02 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR18MB2679A2F3A2CE18CFA2427EEDC5110@BYAPR18MB2679.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2679A2F3A2CE18CFA2427EEDC5110@BYAPR18MB2679.namprd18.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Nov 2020 12:56:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTScwuWvbdZgAyVSzGnqsF=EzOMYwj4RbwjxCFoAQKG19OQ@mail.gmail.com>
Message-ID: <CA+FuTScwuWvbdZgAyVSzGnqsF=EzOMYwj4RbwjxCFoAQKG19OQ@mail.gmail.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
To:     George Cherian <gcherian@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 12:43 PM George Cherian <gcherian@marvell.com> wrote:
>
> Hi Willem,
>
>
> > -----Original Message-----
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Sent: Tuesday, November 3, 2020 7:21 PM
> > To: George Cherian <gcherian@marvell.com>
> > Cc: Network Development <netdev@vger.kernel.org>; linux-kernel <linux-
> > kernel@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>; David Miller
> > <davem@davemloft.net>; Sunil Kovvuri Goutham
> > <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> > Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org
> > Subject: [EXT] Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health
> > reporters for NPA
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > > > >  static int rvu_devlink_info_get(struct devlink *devlink, struct
> > > > devlink_info_req *req,
> > > > >                                 struct netlink_ext_ack *extack)  { @@
> > > > > -53,7 +483,8 @@ int rvu_register_dl(struct rvu *rvu)
> > > > >         rvu_dl->dl = dl;
> > > > >         rvu_dl->rvu = rvu;
> > > > >         rvu->rvu_dl = rvu_dl;
> > > > > -       return 0;
> > > > > +
> > > > > +       return rvu_health_reporters_create(rvu);
> > > >
> > > > when would this be called with rvu->rvu_dl == NULL?
> > >
> > > During initialization.
> >
> > This is the only caller, and it is only reached if rvu_dl is non-zero.
>
> Did you mean to ask, where is it de-initialized?
> If so, it should be done in rvu_unregister_dl() after freeing rvu_dl.

No, I meant that rvu_health_reporters_create does not need an
!rvu->rvu_dl precondition test, as the only callers calls with with a
non-zero rvu_dl.
