Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62D33A26C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhCNCsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNCsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 21:48:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F31FC061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 18:48:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id c10so60551028ejx.9
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 18:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9DnLp27InHAd5OO9vshNYPunKr8XtyB6O0rodvYcKE=;
        b=nGdzKJ5rMUyecp+DIMrh02adSdlC1ih8+Dk3asYaRbsUD8/QjjgFzAd352MbQ9fN1i
         s/7MkM+GfcosO4DN1zxCGxAth715pmTYgNJDoTNxOLWjUPrVfI0uQUNX0AGd6VoM4HhR
         xPOL3mbJ0kf/3jIwE0UGxNoqsXYPLLDr5o5xXZ0ZqPC84IRAyqRfUp0AEU5setgk3EZV
         cr1olmT8JTN9A9/EKrCK1ieLMAPjuFXSbMFXX9nAIPSY1PRAcRVf4MxJW2phAxz3rmjU
         vbilE7PKJAjqdTyZIMJd7BrtVKIhDqEll+/ZGtFk4OP5R1ZV1UZAhmEeCVihMWNkfJMP
         u8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+9DnLp27InHAd5OO9vshNYPunKr8XtyB6O0rodvYcKE=;
        b=WNTZtkKgC3aYeFc9FZx6kNAItzn5eJSkvZ7Xe3zrVZof+gVSAft4XBFsRrSiStVvLO
         bwwvkCIRftZCoPPCKyrigMLu+nGgyjorIeH04fJY388fLLBOsCzDacoMD+C1HGU56Chc
         hSXKecB1NJU3Eu6GQFpDvRHW0aSoHB1VjUqveNOECFwBtkDX5mlTgZcFPoEs+UtYL7Mz
         2AdeIeh+zTYcACmKHj8mMPkGAkEinErGTa9n5PzugnZTiaSkIOzQoRpLbgUwUsJ0Bygx
         gOr2yGjrtbUSgHRY2BzuVF7DZHtI5disaCHZlLxplI2T1YZh0SVmWly9pnTWfttooAnF
         /vIA==
X-Gm-Message-State: AOAM532PPnzdd0aTJI+4QFxxrEDor41wFUkVa0tcPdFZ7h15vhsFDjco
        7y6POS6GsrQedEApMGbyZ6N9kvt01BoGzROGXzOAX1xf
X-Google-Smtp-Source: ABdhPJxSMRMQg1GazNONK+P590M2zuvgRGNQZc3Dk0QwCk1Bxi1T7vDVeg14P0pcJrNO9/fj4oNqbPf304cuZsWt3s4=
X-Received: by 2002:a17:906:3444:: with SMTP id d4mr16537663ejb.410.1615690116676;
 Sat, 13 Mar 2021 18:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20210311025736.77235-1-xiangxia.m.yue@gmail.com>
 <161550780854.9767.12432124529018963233.git-patchwork-notify@kernel.org> <30bd9ce2-24b7-d643-17aa-7a687652d30d@gmail.com>
In-Reply-To: <30bd9ce2-24b7-d643-17aa-7a687652d30d@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sun, 14 Mar 2021 10:44:07 +0800
Message-ID: <CAMDZJNWFu5S-4J0pfq=YodX1rf8hL_0DwMnFPxEJkz=qOgUqcg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: sock: simplify tw proto registration
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 3/12/21 1:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This patch was applied to netdev/net.git (refs/heads/master):
> >
> > On Thu, 11 Mar 2021 10:57:36 +0800 you wrote:
> >> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> Introduce the new function tw_prot_init (inspired by
> >> req_prot_init) to simplify "proto_register" function.
> >>
> >> tw_prot_cleanup will take care of a partially initialized
> >> timewait_sock_ops.
> >>
> >> [...]
> >
> > Here is the summary with links:
> >   - [net-next,v2] net: sock: simplify tw proto registration
> >     https://git.kernel.org/netdev/net/c/b80350f39370
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
>
> For some reason I see the patch in net tree, not in net-next
>
> I wonder what happened.
my mistake, In the patch v1, I use the "net" as prefix, and v2 using "net-nextt"


-- 
Best regards, Tonghao
