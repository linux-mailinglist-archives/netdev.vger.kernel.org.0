Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AED843CCB7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhJ0OwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhJ0OwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:52:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E94C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 07:49:51 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o133so2946308pfg.7
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWaBnHyQW7q37eNBjfiwEECGOKbcVPNHhjU6WSDK5SM=;
        b=nmUbO2txIl48wppUIGFjHOKU2ibUQk62VsI9GleAHTnEInIf3vZzwKFzFX6ytVEnus
         qgY7ZpT5GPjT3wgXcbco+0KayxZ9LCKQxdJyu6KA7VP+jeZVKGWwyIIUCss6fH1fHfWG
         BPZQMbgp04b/ofrQ6K8LhXEFvo8pIvsEFjmojXGe5ciBbpQKls9aUNXEpEKtStQSl4LX
         qGKMOuCPZV4+VrsQDfIJ5P2TDDkwgi1f5MqOS4NumpHEdB/TEm6ALc9aRfOhiHQMGCPt
         y14eUbmx4LNCusWDzn50/d19KAjAi7rghjA4i8QspqdtBnSKoR+xj1mnBj83q6J3qzCK
         KJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWaBnHyQW7q37eNBjfiwEECGOKbcVPNHhjU6WSDK5SM=;
        b=XpXOqEfKZmJ/yvJ/RnI45W/SCsg4uhGtCLsCuMnKwIM/DlVr2thiNye1duI5O5RFFk
         2UkWmRrDaj85cWXXAOPGvqbnqV1qhjaYuTfKu8GP9iHTJmhwXGhozJDzBcBNcr9gJRVS
         44qniCpoMaWe4mUpUBr+UfAkWl1D/iGA8elHIbZ9Tj+7pbETfpuZeV/oLrYRzmHDHsYS
         9ZvfxAWDPMXcSeb0Ho9bU/Mj4Kf6v661T2Q34zvM8ZjPpPCb05KFVqMniNNVQOxXqBgG
         qOvxa68rWJa/sUGdSG827Fq1tZ0JyiMM6vMYuOTTidoRTKufB7SQEVMRDJX3w9csZriC
         J0qg==
X-Gm-Message-State: AOAM533Sl55yvRrBTGdJsLOBE/mBZHXWvsBHRobE0399n32UZqas039J
        d9Vu1m8dtDp9VpLZXi/6k/roKhxgNv6z476tnEM=
X-Google-Smtp-Source: ABdhPJxBjJqAxpu0AZGzlsYgkurELQkdd1x37fIVtdVs7mgUpPqerpf2BZ+BFIkc4vJAPatbZr7qQlUgSA/Av2ijb3Q=
X-Received: by 2002:a62:2cc2:0:b0:47b:b52e:c6d8 with SMTP id
 s185-20020a622cc2000000b0047bb52ec6d8mr33520649pfs.12.1635346190856; Wed, 27
 Oct 2021 07:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <163534560950.729.5232614315067836341.git-patchwork-notify@kernel.org>
 <c9da923f-42b8-8771-8867-9ea35f10da91@nvidia.com> <CA+h21hoYXvATh5_MCDvCUYit11T9Za9DvRnLeNs3yeRRRQ+H=A@mail.gmail.com>
In-Reply-To: <CA+h21hoYXvATh5_MCDvCUYit11T9Za9DvRnLeNs3yeRRRQ+H=A@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 27 Oct 2021 17:49:39 +0300
Message-ID: <CA+h21hpgA8_0iMqQ03BhgnBeB8-nTxHo3LiF16VKj3A5yMaSQg@mail.gmail.com>
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

On Wed, 27 Oct 2021 at 17:46, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 27 Oct 2021 at 17:44, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> >
> > On 27/10/2021 17:40, patchwork-bot+netdevbpf@kernel.org wrote:
> > > Hello:
> > >
> > > This series was applied to netdev/net-next.git (master)
> > > by David S. Miller <davem@davemloft.net>:
> > >
> > > On Tue, 26 Oct 2021 17:27:35 +0300 you wrote:
> > >> This series refactors the br_fdb.c, br_switchdev.c and switchdev.c files
> > >> to offer the same level of functionality with a bit less code, and to
> > >> clarify the purpose of some functions.
> > >>
> > >> No functional change intended.
> > >>
> > >> Vladimir Oltean (8):
> > >>   net: bridge: remove fdb_notify forward declaration
> > >>   net: bridge: remove fdb_insert forward declaration
> > >>   net: bridge: rename fdb_insert to fdb_add_local
> > >>   net: bridge: rename br_fdb_insert to br_fdb_add_local
> > >>   net: bridge: reduce indentation level in fdb_create
> > >>   net: bridge: move br_fdb_replay inside br_switchdev.c
> > >>   net: bridge: create a common function for populating switchdev FDB
> > >>     entries
> > >>   net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> > >>
> > >> [...]
> > >
> > > Here is the summary with links:
> > >   - [net-next,1/8] net: bridge: remove fdb_notify forward declaration
> > >     https://git.kernel.org/netdev/net-next/c/4682048af0c8
> > >   - [net-next,2/8] net: bridge: remove fdb_insert forward declaration
> > >     https://git.kernel.org/netdev/net-next/c/5f94a5e276ae
> > >   - [net-next,3/8] net: bridge: rename fdb_insert to fdb_add_local
> > >     https://git.kernel.org/netdev/net-next/c/4731b6d6b257
> > >   - [net-next,4/8] net: bridge: rename br_fdb_insert to br_fdb_add_local
> > >     https://git.kernel.org/netdev/net-next/c/f6814fdcfe1b
> > >   - [net-next,5/8] net: bridge: reduce indentation level in fdb_create
> > >     https://git.kernel.org/netdev/net-next/c/9574fb558044
> > >   - [net-next,6/8] net: bridge: move br_fdb_replay inside br_switchdev.c
> > >     https://git.kernel.org/netdev/net-next/c/5cda5272a460
> > >   - [net-next,7/8] net: bridge: create a common function for populating switchdev FDB entries
> > >     https://git.kernel.org/netdev/net-next/c/fab9eca88410
> > >   - [net-next,8/8] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> > >     https://git.kernel.org/netdev/net-next/c/716a30a97a52
> > >
> > > You are awesome, thank you!
> > >
> >
> > There was a discussion about patch 06 which we agreed have to turn into its own series
> > with more changes. Vladimir, since the set got applied please send a follow-up to
> > finish those changes.
>
> Wait a minute, even I got the impression that the next series I'll be
> sending would be completely separate from this one...

To be clear, what I'm preparing for that second series is to:
- move all of br_vlan_replay, br_mdb_replay into br_switchdev.c
- consistently name all functions to br_switchdev_*
- refactor the switchdev logic from br_mdb_notify into a new
br_switchdev_mdb_notify for symmetry with fdb_notify and
br_switchdev_fdb_notify
But I'm still working on it, because the VLAN and IGMP snooping code
is conditionally compiled, making it a bit harder :)

So the current placement of the br_fdb_replay function is not bad,
according to the follow-up changes I am going to make.
