Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24422F9037
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbhAQC3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:29:31 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46806 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbhAQC32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 21:29:28 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by linux.microsoft.com (Postfix) with ESMTPSA id B668520B7192;
        Sat, 16 Jan 2021 18:28:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B668520B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610850527;
        bh=6RIemJ4l8/3wJ6SX05saF7CMsgpEJ0TYYmSMtM9G4zw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gzZAlA7mLXfV2QZddQIaFc1MN+yXu11kyUfxqSYpJPmsL+YisZbaYr/VqaSmYUKkb
         L9LEErYKpKMjZ5mDUAUA4XsDK39WjdQwpLvpJ1L2VoSRTMxE7G9mPzB6MiCHq+VObj
         olqwOVKHvLYPia/TsTTMAGIZYHcL23kRmkvEqgIc=
Received: by mail-pj1-f47.google.com with SMTP id l23so7483985pjg.1;
        Sat, 16 Jan 2021 18:28:47 -0800 (PST)
X-Gm-Message-State: AOAM530wzKZzeHXZWInnqc2dqF1KAp7UzB5fQwbKvexPG+jLMX/+Flg3
        EnrU2L4pfaHqBaQ6w5HQqofnvayr/Ur7hwoVax4=
X-Google-Smtp-Source: ABdhPJyLqnk4RHPHBp8nrp9Tux1U0yVwK67ccs2a3IrcrK0VHqN1VJEzAblaBCcdwnykpfhP0DD05ov3KUyzodU/tSk=
X-Received: by 2002:a17:90a:5d8d:: with SMTP id t13mr18692894pji.39.1610850527239;
 Sat, 16 Jan 2021 18:28:47 -0800 (PST)
MIME-Version: 1.0
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
 <20210115145028.3cb6997f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFnufp2DLgmO_paMoTGPUAGHbp9=hVgWR5UxmYbQQE=n642Ejw@mail.gmail.com> <989d8413-469d-9d80-1a80-15868af24de6@gmail.com>
In-Reply-To: <989d8413-469d-9d80-1a80-15868af24de6@gmail.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sun, 17 Jan 2021 03:28:11 +0100
X-Gmail-Original-Message-ID: <CAFnufp01QNMq5WQ_K_OMFNuQJTv7YPzn2wCC7L65zErWnj+a9A@mail.gmail.com>
Message-ID: <CAFnufp01QNMq5WQ_K_OMFNuQJTv7YPzn2wCC7L65zErWnj+a9A@mail.gmail.com>
Subject: Re: [PATCH net 0/2] ipv6: fixes for the multicast routes
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Graf <tgraf@suug.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 5:41 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/15/21 4:12 PM, Matteo Croce wrote:
> > On Fri, Jan 15, 2021 at 11:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Fri, 15 Jan 2021 19:42:07 +0100 Matteo Croce wrote:
> >>> From: Matteo Croce <mcroce@microsoft.com>
> >>>
> >>> Fix two wrong flags in the IPv6 multicast routes created
> >>> by the autoconf code.
> >>
> >> Any chance for Fixes tags here?
> >
> > Right.
> > For 1/2 I don't know exactly, that code was touched last time in
> > 86872cb57925 ("[IPv6] route: FIB6 configuration using struct
> > fib6_config"), but it was only refactored. Before 86872cb57925, it was
> > pushed in the git import commit by Linus: 1da177e4c3f4
> > ("Linux-2.6.12-rc2").
> > BTW, according the history repo, it entered the tree in the 2.4.0
> > import, so I'd say it's here since the beginning.
> >
> > While for 2/2 I'd say:
> >
> > Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
> >
>
> As I recall (memory jogging from commit description) my patch only moved
> the setting from ip6_route_info_create default to here.
>
> The change is correct, just thinking it goes back beyond 4.16. If
> someone has a system running a 4.14 or earlier kernel it should be easy
> to know if this was the default prior.

Indeed, it was the same long before 4.14:

# uname -a
Linux ubuntu 4.4.0-142-generic #168~14.04.1-Ubuntu SMP Sat Jan 19
11:26:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
# ip -6 -d route show table local dev eth0
unicast ff00::/8 proto boot scope global metric 256 pref medium

Regards,
-- 
per aspera ad upstream
