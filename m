Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEB3D1D6D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 07:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhGVEwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 00:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhGVEwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 00:52:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633E5C061575;
        Wed, 21 Jul 2021 22:33:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bu12so6703522ejb.0;
        Wed, 21 Jul 2021 22:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wajVtjGABFDUKxNLKfh9CloL7wxGObanG71oWdTUF4M=;
        b=KMV60N8z5YNGPotnOptoz6aw0xldbnMJhf/7liV1fh84eYcgAQf1iiuYo2uCJSezIe
         ANxsCrSdEQWWlgqaTuoCNWApQNjncjfuUmfIg3GvkQegX+qDReNhUgbeK5k66svV1AkP
         K+F9qzRSq5ykkabgck9ym2YZ8sMHbci9DVNgRkZvcyDGucesQnQg9MD+ui0X4DpeN6Ka
         aglyj0KkthQpjI2qnKDuBXMB7z6t7LJHQiPZCxSubUqCruXsag4G2qQxTnahWMMZGpto
         L+OYz19E0IFDdleBDzPSGlZLEg/Bc7r5+sAmFF8nz2KlGOwB7rwruEvzLkDDPE0FAgm2
         Sd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wajVtjGABFDUKxNLKfh9CloL7wxGObanG71oWdTUF4M=;
        b=YJBYzw6lUZkokv1VSQWGX2QZwEBC/xIvbOIM6O5NDzIcp2tpBzG4IIor/u0FAbx8F1
         N/5rq1uiO1i7tiP/NKVk6S6As/6vEVdcbsr1G+7qMsDhEXLy6310wdjACsVSIwD0GDtW
         M6nnC4k3jyTAktkVFD1ja2S3xRY89N+poYAyB1vJy8Dz8cg4aJtvSmc52ovvcITF+r9H
         9JMyVCvu013ZmwmzVIG6ZnCbO59B7Oc3dypi51dzFLSJWpoO25i20dB3JZF9VzoWoTTw
         Ucyx84asgGCFWTtiJtFRb8/b3JTMAeRoR0K/P6vmlvMayB5LLtpsqkpud5TRQehxgigF
         LZZA==
X-Gm-Message-State: AOAM530ckSc2FT7+xFr6Iy0sCuiPMS6EO39gLy+HlETP3CzXJrB089ic
        IXyK4yrFvl35i5p6PzuXCX27evopg33EF0/3kV4=
X-Google-Smtp-Source: ABdhPJxBLoBiwG5Awfr1+0qDm2vFHNKgb4Y+Ubh6+refGNbI7Y0LYl6WK2ClzlzZVtP+ZpBQuemUDuc6ubDJ29O0uVM=
X-Received: by 2002:a17:906:13d4:: with SMTP id g20mr41601099ejc.337.1626931994007;
 Wed, 21 Jul 2021 22:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210714091327.677458-1-mudongliangabcd@gmail.com>
 <YPfOZp7YoagbE+Mh@kroah.com> <CAD-N9QVi=TvS6sM+jcOf=Y5esECtRgTMgdFW+dqB-R_BuNv6AQ@mail.gmail.com>
 <YPgwkEHzmxSPSLVA@hovoldconsulting.com> <YPhOcwiEUW+cchJ1@hovoldconsulting.com>
In-Reply-To: <YPhOcwiEUW+cchJ1@hovoldconsulting.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 22 Jul 2021 13:32:48 +0800
Message-ID: <CAD-N9QVD6BcWVRbsXJ8AV0nMmCetpE6ke0wWxogXpwihnjTvRA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] usb: hso: fix error handling code of hso_create_net_device
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 12:42 AM Johan Hovold <johan@kernel.org> wrote:
>
> On Wed, Jul 21, 2021 at 04:34:56PM +0200, Johan Hovold wrote:
> > On Wed, Jul 21, 2021 at 04:17:01PM +0800, Dongliang Mu wrote:
> > > On Wed, Jul 21, 2021 at 3:36 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Jul 14, 2021 at 05:13:22PM +0800, Dongliang Mu wrote:
> > > > > The current error handling code of hso_create_net_device is
> > > > > hso_free_net_device, no matter which errors lead to. For example,
> > > > > WARNING in hso_free_net_device [1].
> > > > >
> > > > > Fix this by refactoring the error handling code of
> > > > > hso_create_net_device by handling different errors by different code.
> > > > >
> > > > > [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
> > > > >
> > > > > Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> > > > > Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> > > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > > ---
> > > > > v1->v2: change labels according to the comment of Dan Carpenter
> > > > > v2->v3: change the style of error handling labels
> > > > >  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
> > > > >  1 file changed, 23 insertions(+), 10 deletions(-)
> > > >
> > > > Please resend the whole series, not just one patch of the series.
> > > > Otherwise it makes it impossible to determine what patch from what
> > > > series should be applied in what order.
> > > >
> > >
> > > Done. Please review the resend v3 patches.
> > >
> > > > All of these are now dropped from my queue, please fix up and resend.
> >
> > A version of this patch has already been applied to net-next.
>
> That was apparently net (not net-next).
>
> > No idea which version that was or why the second patch hasn't been
> > applied yet.

It seems because I only sent the 1/2 patch in the v3. Also due to
this, gregkh asked me to resend the whole patchset again.

> >
> > Dongliang, if you're resending something here it should first be rebased
> > on linux-next (net-next).
>
> And the resend of v3 of both patches has now also been applied to
> net-next.
>
> Hopefully there are no conflicts between v2 and v3 but we'll see soon.

You mean you apply a v2 patch into one tree? This thread already
contains the v3 patch, and there is no v2 patch in the mailing list
due to one incomplete email subject.

BTW, v2->v3 only some label change due to naming style.

>
> Johan
