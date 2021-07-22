Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F373D1F53
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhGVHLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhGVHK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 03:10:59 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E8C061575;
        Thu, 22 Jul 2021 00:51:34 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id go30so7036961ejc.8;
        Thu, 22 Jul 2021 00:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2noPHN0haXlARQkg/tGKzb2uM4Y3gCiHNA7qDTlXfyo=;
        b=pbFGT6/W3D6oTEjUmTUNMAZVcGkKHHGPJGIxsAKi2W/KE/53BzEOR48WBnKLHRxx0T
         5cpChCs8kWcy0l4nburBp4ejZyqV/SiicqNnYioQfwShFeE9ey6QI1ql9kjzgdptH6Ce
         zb8uDjZegSmLRiW8UfgpRFBjm0RaSc52sHS4Bagn3tTxJf5ix1zjlErxnVcG7stSlE9O
         wO14bmI9ao1Q3P9f0zp1A2XgMg0nZEiJWOS5/gliE1ct3yaPX8i+ajVkLI9rtU5qLRI8
         d6Hg0uZyxuRbq2nmUNlu7Kh957POHQFdEGj0LE5OFYI7RWEU/rV2m73YlepY2ifJ3ewF
         JWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2noPHN0haXlARQkg/tGKzb2uM4Y3gCiHNA7qDTlXfyo=;
        b=BgSThmplSDIp1xJCRe+4C0phDUJ1svRv47oA6HiGax094eHkajLh2/kwdNmiDpX3V7
         kf43jl0kW0BHOODav9Y+huiG9N9gtj2pNAXjO2JZCy2PPpefLwChRnXdOkN5FvvZ0SUU
         uU+4zn+heiw4sa/qAX0h6gd5cWDwfnd8crwt8d7mBULW57b2UXWvw9eSIKA5fA1NcI7s
         OfjJIOCQIWPuxwrQ8sVAaRtxTUrAQz4yhvW4dsznJfoi/ThKkcyxFK1T10jbVyHR37hH
         rOZOo+zcAOF7BFfrmcEobsMXQie6i3ndXONfZCeSN2qIenMKowSuYYa+oMWOngHkNs70
         X1CQ==
X-Gm-Message-State: AOAM532E3X8PsA8UZB8FKpUjqZH6+BoMnhcWluho0MLvup3f4Kd3KSbP
        ErXl4AduDqjBU6KrOcxehlkeVP+PsMql8XIHoDw=
X-Google-Smtp-Source: ABdhPJwKUTPjAgRWOjcv6DezHEwxcnyFFHWDfwJEXo6OHUIJ08kIo0NihGUIVhcR+A6/33AM4/lYtIrzNdE38wHJVKw=
X-Received: by 2002:a17:906:3006:: with SMTP id 6mr43290801ejz.73.1626940292576;
 Thu, 22 Jul 2021 00:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210714091327.677458-1-mudongliangabcd@gmail.com>
 <YPfOZp7YoagbE+Mh@kroah.com> <CAD-N9QVi=TvS6sM+jcOf=Y5esECtRgTMgdFW+dqB-R_BuNv6AQ@mail.gmail.com>
 <YPgwkEHzmxSPSLVA@hovoldconsulting.com> <YPhOcwiEUW+cchJ1@hovoldconsulting.com>
 <CAD-N9QVD6BcWVRbsXJ8AV0nMmCetpE6ke0wWxogXpwihnjTvRA@mail.gmail.com> <YPkc+HNUPcXQglpG@hovoldconsulting.com>
In-Reply-To: <YPkc+HNUPcXQglpG@hovoldconsulting.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 22 Jul 2021 15:51:06 +0800
Message-ID: <CAD-N9QWgXCSn9Wd6V2kvT501Zx_iz2uboApy6tO=wvWOnMY-6A@mail.gmail.com>
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

On Thu, Jul 22, 2021 at 3:24 PM Johan Hovold <johan@kernel.org> wrote:
>
> On Thu, Jul 22, 2021 at 01:32:48PM +0800, Dongliang Mu wrote:
> > On Thu, Jul 22, 2021 at 12:42 AM Johan Hovold <johan@kernel.org> wrote:
>
> > > > A version of this patch has already been applied to net-next.
> > >
> > > That was apparently net (not net-next).
> > >
> > > > No idea which version that was or why the second patch hasn't been
> > > > applied yet.
> >
> > It seems because I only sent the 1/2 patch in the v3. Also due to
> > this, gregkh asked me to resend the whole patchset again.
>
> Yeah, it's hard to keep track of submissions sometimes, especially if
> not updating the whole series.
>
> > > > Dongliang, if you're resending something here it should first be rebased
> > > > on linux-next (net-next).
> > >
> > > And the resend of v3 of both patches has now also been applied to
> > > net-next.
> > >
> > > Hopefully there are no conflicts between v2 and v3 but we'll see soon.
> >
> > You mean you apply a v2 patch into one tree? This thread already
> > contains the v3 patch, and there is no v2 patch in the mailing list
> > due to one incomplete email subject.
> >
> > BTW, v2->v3 only some label change due to naming style.
>
> Ok, I can't keep track of this either. I just noticed that this patch
> shows up in both net (for 5.14):
>
>         https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a6ecfb39ba9d7316057cea823b196b734f6b18ca
>
> and net-next (for 5.15):
>
>         https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=788e67f18d797abbd48a96143511261f4f3b4f21
>
> The net one was applied on the 15th and the net-next one yesterday.

I did not get any notification about this merge operation. So I cannot
help with this. Any chance to notify the developers the patch is
merged? In some subsystems, I will get notified by robots.

In the future, I will keep in mind updating the whole patch set. This
is easier for developers to follow.

>
> Judging from a quick look it appears to be the same diff so no damage
> done.

That's great.

>
> Johan
