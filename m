Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3243CCA6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhJ0Osn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhJ0Osm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:48:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890C9C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 07:46:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so2144475plk.10
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 07:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XaUSvr3/x1+Ala/XD44HspA4x9rtAlNiOAlDlZGFuXQ=;
        b=GDr2DOrGgkd7Bwn2ytMtDjP1kyAfbgSk8sikD3kv9tY7rELRvCc4uBgj5nesKJewJl
         r7ItLe5nEiGWp2BvjgEV+cQC+BIXy9GOgImIxA/4GsqsXDesfFLA/XRyhLEl7nYxe3Ab
         LUxEeFs2qqd3DKAF1N7LW8Wcx3m6lEtbSgSMJjcvs0R2pfh0xG6nijDkw+k361g9AiFj
         bn4GFv7u1JLURKfxJHKG49nxuIjrns7Lt9MrMPnOkv3FzG/7Zdbxk/7wPqlsU3bi5hsY
         kkv1ZbwElxTQceIHGf0udjA1/G4BRebMQg8o6XNIswR8c0EOAMouL5hw+9QZEuaS0WcO
         kO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XaUSvr3/x1+Ala/XD44HspA4x9rtAlNiOAlDlZGFuXQ=;
        b=21yF4TyS9bMqj4pCUbpEpDnLPR5XYZ6oLEYID77YF4q/Iq32J3gHIfaw8xUHnxit3k
         MBk/mZXk3oWug/rfS0ZrhzDyyGtwb4TpvyGRFLF5mCbbCFmAetg2nPl5ZpZA3OSPB/HH
         S9XvN+iCRU7uC/kfRKRMi8mmxwLtD1IJqwh8jORtKX7Z5JDVI+AKlnKzlqkWz++8jGA2
         uNe3f03sswqW4ev4a4jUMBm3u5sRTgypg4kPVMfYs2W1GqyhrEa6QUUPufC2QlQ/i4QH
         sR/Kr1nyGXDx25lmNCurYMlENzTIqxYSlfjn/FvGYukOBY99agx/QryLLA1f88o+n6V8
         prfQ==
X-Gm-Message-State: AOAM533U4SjtY9eME5c+Fs/HF8nvkpezRGgiwt3+qrTNiWowpXKkDyDb
        eXbitf1w9AubHoJ+aNEvd0DSnvWCUFXiNokreiI=
X-Google-Smtp-Source: ABdhPJzRFwUuj6uWO/6+ez8Y834qViB2l8W4v17Nj6YfH9KJVaietg9ax6Z9OT3UO1x9CdQCKB0Xt0kDkpMH3YbqVdI=
X-Received: by 2002:a17:90a:bc85:: with SMTP id x5mr6230396pjr.166.1635345976929;
 Wed, 27 Oct 2021 07:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <163534560950.729.5232614315067836341.git-patchwork-notify@kernel.org> <c9da923f-42b8-8771-8867-9ea35f10da91@nvidia.com>
In-Reply-To: <c9da923f-42b8-8771-8867-9ea35f10da91@nvidia.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 27 Oct 2021 17:46:05 +0300
Message-ID: <CA+h21hoYXvATh5_MCDvCUYit11T9Za9DvRnLeNs3yeRRRQ+H=A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] Bridge FDB refactoring
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 at 17:44, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>
> On 27/10/2021 17:40, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This series was applied to netdev/net-next.git (master)
> > by David S. Miller <davem@davemloft.net>:
> >
> > On Tue, 26 Oct 2021 17:27:35 +0300 you wrote:
> >> This series refactors the br_fdb.c, br_switchdev.c and switchdev.c files
> >> to offer the same level of functionality with a bit less code, and to
> >> clarify the purpose of some functions.
> >>
> >> No functional change intended.
> >>
> >> Vladimir Oltean (8):
> >>   net: bridge: remove fdb_notify forward declaration
> >>   net: bridge: remove fdb_insert forward declaration
> >>   net: bridge: rename fdb_insert to fdb_add_local
> >>   net: bridge: rename br_fdb_insert to br_fdb_add_local
> >>   net: bridge: reduce indentation level in fdb_create
> >>   net: bridge: move br_fdb_replay inside br_switchdev.c
> >>   net: bridge: create a common function for populating switchdev FDB
> >>     entries
> >>   net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> >>
> >> [...]
> >
> > Here is the summary with links:
> >   - [net-next,1/8] net: bridge: remove fdb_notify forward declaration
> >     https://git.kernel.org/netdev/net-next/c/4682048af0c8
> >   - [net-next,2/8] net: bridge: remove fdb_insert forward declaration
> >     https://git.kernel.org/netdev/net-next/c/5f94a5e276ae
> >   - [net-next,3/8] net: bridge: rename fdb_insert to fdb_add_local
> >     https://git.kernel.org/netdev/net-next/c/4731b6d6b257
> >   - [net-next,4/8] net: bridge: rename br_fdb_insert to br_fdb_add_local
> >     https://git.kernel.org/netdev/net-next/c/f6814fdcfe1b
> >   - [net-next,5/8] net: bridge: reduce indentation level in fdb_create
> >     https://git.kernel.org/netdev/net-next/c/9574fb558044
> >   - [net-next,6/8] net: bridge: move br_fdb_replay inside br_switchdev.c
> >     https://git.kernel.org/netdev/net-next/c/5cda5272a460
> >   - [net-next,7/8] net: bridge: create a common function for populating switchdev FDB entries
> >     https://git.kernel.org/netdev/net-next/c/fab9eca88410
> >   - [net-next,8/8] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> >     https://git.kernel.org/netdev/net-next/c/716a30a97a52
> >
> > You are awesome, thank you!
> >
>
> There was a discussion about patch 06 which we agreed have to turn into its own series
> with more changes. Vladimir, since the set got applied please send a follow-up to
> finish those changes.

Wait a minute, even I got the impression that the next series I'll be
sending would be completely separate from this one...

>
> Thanks,
>  Nik
>
