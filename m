Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588AD1B674F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDWW5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgDWW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:57:15 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A386EC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:57:15 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di6so3791885qvb.10
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pT2ykMTeONTH09TSdsRTzByEaXpcBuIQ0FJ9WYHabE0=;
        b=jIdQuV84cTUBOLIJv8bO5ihnQggdaCStmt5tmKnLEVLb6ddn9FXpZVRwiUTCBJp1ZQ
         eeZiYegWcbVCfL+vBu+DZowB9Ffwf3ZPPPfvv5esFdPrkb848G0mE6Zz549OgqNjmDvG
         OhiqB62OHvFpwL9D9wC14zjQe++nJPzQ2BTIj4PqddrD0SB9Yrq8ZGGA1uESjX2zWNaJ
         QOKIBR5aXewh3mOlKhKImqwA/7PM70nMuJGwqGYQbKT7dq+anPd63kJeJw7v5yArjKpW
         2QP7+5tP8zANOFD8fzFgT+E1icJG0xB5pZTD015AnuTsyTL4Lhw0IQ/zPSv07RkHjcaK
         /jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pT2ykMTeONTH09TSdsRTzByEaXpcBuIQ0FJ9WYHabE0=;
        b=Oi3V1vT4wwEO7yds/HlBINZhDUb+9tkluPv546a278TgcfCxD/PPviF8UfnvY98SUo
         3HrcIxbI8ZA2z70gLSZshbur/Y5PNbuqcO+VDITyBaOxDBvKmAo1gY/+Fwg0RJJR9Mt3
         EKTU9g/KICgup1XwrJMmulep20W6Z6LpgsTn/iC8AJHzq2K4wIsjbkStARVD8TONqRan
         JMoHQ91I9zcuFxaA2o+fnMNGywXfS1B/xwvfU6UUvSHYX1V4VS0EDjYIXKTr/LAvDScy
         5OuwmTqEZcax96ZTW7axO7SOHDnmi56bz92MlPQd3T2/Ue4aIUwynUuuE8C4JFzZhBf2
         rRyw==
X-Gm-Message-State: AGi0PuaQMmod1VkohUjyY+pw1UuenhObw2A6G7w6rQLvyeRgKQa4c+JF
        EEgxNXZw9MntnvbEqB48oToDRUwMDVBc7bD2hxQHTw==
X-Google-Smtp-Source: APiQypKgw4jU3MeeEDcYAYcsrY18O6Ei6sdaELC/4Fl4krcZ+z85XuiQbCVDkMlLsvi5eCMGh3TTc3osByZAEojS3YA=
X-Received: by 2002:a0c:b651:: with SMTP id q17mr6155351qvf.135.1587682634954;
 Thu, 23 Apr 2020 15:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20200423.124529.2287319111918165506.davem@davemloft.net> <20200423.124951.960742785788699585.davem@davemloft.net>
In-Reply-To: <20200423.124951.960742785788699585.davem@davemloft.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 24 Apr 2020 06:56:39 +0800
Message-ID: <CAMDZJNWEOrRivTYonRWR9DEm7XJHHF=yXCiqOcYvfew3HBNWyA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/5] expand meter tables and fix bug
To:     David Miller <davem@davemloft.net>
Cc:     Pravin Shelar <pshelar@ovn.org>, Andy Zhou <azhou@ovn.org>,
        Ben Pfaff <blp@ovn.org>, William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 3:49 AM David Miller <davem@davemloft.net> wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Thu, 23 Apr 2020 12:45:29 -0700 (PDT)
>
> > From: xiangxia.m.yue@gmail.com
> > Date: Thu, 23 Apr 2020 01:08:55 +0800
> >
> >> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> The patch set expand or shrink the meter table when necessary.
> >> and other patches fix bug or improve codes.
> >
> > Series applied, thanks.
>
> Actually I had to revert, this adds build warnings:
>
> In file included from ./include/linux/uio.h:8,
>                  from ./include/linux/socket.h:8,
>                  from ./include/uapi/linux/if.h:25,
>                  from net/openvswitch/meter.c:8:
> net/openvswitch/meter.c: In function =E2=80=98ovs_meters_init=E2=80=99:
> ./include/linux/kernel.h:842:29: warning: comparison of distinct pointer =
types lacks a cast
>    (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
>                              ^~
> ./include/linux/kernel.h:856:4: note: in expansion of macro =E2=80=98__ty=
pecheck=E2=80=99
>    (__typecheck(x, y) && __no_side_effects(x, y))
>     ^~~~~~~~~~~
> ./include/linux/kernel.h:866:24: note: in expansion of macro =E2=80=98__s=
afe_cmp=E2=80=99
>   __builtin_choose_expr(__safe_cmp(x, y), \
>                         ^~~~~~~~~~
> ./include/linux/kernel.h:875:19: note: in expansion of macro =E2=80=98__c=
areful_cmp=E2=80=99
>  #define min(x, y) __careful_cmp(x, y, <)
>                    ^~~~~~~~~~~~~
> net/openvswitch/meter.c:733:28: note: in expansion of macro =E2=80=98min=
=E2=80=99
>   tbl->max_meters_allowed =3D min(free_mem_bytes / sizeof(struct dp_meter=
),
>                             ^~~
The gcc compiler is tool old(4.8), and I did not found that building warnin=
g,
Then I use 9.3 gcc to build kernel and fix that warning. min function
checks the type of vars.
The patch 2 introduced that. v4 version will be sent, Thanks.
--=20
Best regards, Tonghao
