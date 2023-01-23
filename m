Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8066B678ABD
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjAWW0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjAWW0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:26:18 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD80E30194
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:26:12 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 123so16738568ybv.6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLjCmAfLBivtOyrHhvyjjkBPFBID3GxfKn43SuKSOCo=;
        b=JR+GQEL9TzdIPscb+jPvC4lsfikWxrVuOxBbE+D5PH04yKebOzjWz+kt7RTiGdu8JU
         8s8CMIdUY5otiBk8PbVHM79+IhhAJa0YBXhLCSZ/Mu4D8NsEboTvehkbQVFpOXss1m6U
         csHAMnsdJBx2PMAWW5AQuZ3rdjM4pxxW+iOGSVt4ZrkSim6rU9Dr3r511DpdtKEiQ1y1
         WsYXqOoAmTJh3APj/Rlq0jeM5wFO1TzKmcUq063df+05CpKKzvw6IL6+EtELG0OoxJGa
         JxuhAORqNFKAk9tnwNG0hhHRHt77Mbl1nlCyw6LLcS8SQArkfe8ul7gMX+PYszO9xk9/
         ugfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qLjCmAfLBivtOyrHhvyjjkBPFBID3GxfKn43SuKSOCo=;
        b=ku+H0m1zRQLyNQy+yxFdBWx8uVx3xWqT7Gs6mUG6VXZkZp33hf1v/dgomITeF/3F9i
         /l4uA640P1/CIgFKp1G5rkRit38/+8PUtj7/MvZprXlQZoAJT9ockYTg5GH1TCBPx0xT
         HUFIfDi1qsL4ZQwPvPV0d6hQk1mvd5T6YZwJEkQMC3Rt5dSLay9yy8Fq10+duhwmI9n5
         lmWz+P2dbvF7qhQSy894OJ7BGDz/NyYy04HkpcDMcZRMqB7IKPisyzjunuG8GZwE/gOg
         tVq+ACvn3ZVda4pchw1MZ5D76UREY5hGJ409SZXgHJfQZ7ebo5rkJP4AxBvVTgDaBAfE
         Ef3A==
X-Gm-Message-State: AO0yUKXwgpm2HMx5jglkP+lem6ZIlwZT/yi9ZZYb+GRuAeHCz2Ln3hyB
        TRaWA90zY75f4uZgHMbAfUgFVLSgn0U3zYvmP1L0iF/N9vozoAYlhI8=
X-Google-Smtp-Source: AK7set+GAMTyy4wyKvUNcoOIk4uEGhZ61pmoBvcJrbxNu5rRDcE4FFKnllj8Be5kXJIWmzojbSuhRMkFl38WF6XN0C0=
X-Received: by 2002:a25:4004:0:b0:80b:5b3f:3aae with SMTP id
 n4-20020a254004000000b0080b5b3f3aaemr75772yba.387.1674512771604; Mon, 23 Jan
 2023 14:26:11 -0800 (PST)
MIME-Version: 1.0
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com> <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com>
In-Reply-To: <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Jan 2023 23:26:00 +0100
Message-ID: <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
Subject: Re: traceroute failure in kernel 6.1 and 6.2
To:     =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:45 PM Mantas Mikul=C4=97nas <grawity@gmail.com> =
wrote:
>
> On 23/01/2023 22.56, Eric Dumazet wrote:
> > On Mon, Jan 23, 2023 at 8:25 PM Mantas Mikul=C4=97nas <grawity@gmail.co=
m> wrote:
> >>
> >> On 2023-01-23 17:21, Eric Dumazet wrote:
> >>> On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikul=C4=97nas <grawity@gmail.=
com> wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> Not sure whether this has been reported, but:
> >>>>
> >>>> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileg=
ed
> >>>> ICMP traceroute using the `traceroute -I` tool stopped working =E2=
=80=93 it very
> >>>> reliably fails with a "No route to host" at some point:
> >>>>
> >>>>           myth> traceroute -I 83.171.33.188
> >>>>           traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, =
60
> >>>>           byte packets
> >>>>            1  _gateway (192.168.1.1)  0.819 ms
> >>>>           send: No route to host
> >>>>           [exited with 1]
> >>>>
> >>>> while it still works for root:
> >>>>
> >>>>           myth> sudo traceroute -I 83.171.33.188
> >>>>           traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, =
60
> >>>>           byte packets
> >>>>            1  _gateway (192.168.1.1)  0.771 ms
> >>>>            2  * * *
> >>>>            3  10.69.21.145 (10.69.21.145)  47.194 ms
> >>>>            4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.12=
4 ms
> >>>>            5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 =
ms
> >>>>            6  193.219.153.25 (193.219.153.25)  77.171 ms
> >>>>            7  83.171.33.188 (83.171.33.188)  78.198 ms
> >>>>
> >>>> According to `git bisect`, this started with:
> >>>>
> >>>>           commit 0d24148bd276ead5708ef56a4725580555bb48a3
> >>>>           Author: Eric Dumazet <edumazet@google.com>
> >>>>           Date:   Tue Oct 11 14:27:29 2022 -0700
> >>>>
> >>>>               inet: ping: fix recent breakage
> >>>>
> >>>>
> >>>>
> >>>>
> >>>> It still happens with a fresh 6.2rc build, unless I revert that comm=
it.
> >>>>
> >>>> The /bin/traceroute is the one that calls itself "Modern traceroute =
for
> >>>> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET=
,
> >>>> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
> >>>> (The problem does not occur if I run it as root.)
> >>>>
> >>>> This version of `traceroute` sends multiple probes at once (with TTL=
s
> >>>> 1..16); according to strace, the first approx. 8-12 probes are sent
> >>>> successfully, but eventually sendto() fails with EHOSTUNREACH. (Thou=
gh
> >>>> if I run it on local tty as opposed to SSH, it fails earlier.) If I =
use
> >>>> -N1 to have it only send one probe at a time, the problem doesn't se=
em
> >>>> to occur.
> >>>
> >>>
> >>>
> >>> I was not able to reproduce the issue (downloading
> >>> https://sourceforge.net/projects/traceroute/files/latest/download)
> >>>
> >>> I suspect some kind of bug in this traceroute, when/if some ICMP erro=
r
> >>> comes back.
> >>>
> >>> Double check by
> >>>
> >>> tcpdump -i ethXXXX icmp
> >>>
> >>> While you run traceroute -I ....
> >>
> >> Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in
> >> transit", which is expected for traceroute. Nothing else shows up.
> >>
> >> (But when I test against an address that causes *real* ICMP "Host
> >> unreachable" errors, it seems to handle those correctly and prints "!H=
"
> >> as usual -- that is, if it reaches that point without dying.)
> >>
> >> I was able to reproduce this on a fresh Linode 1G instance (starting
> >> with their Arch image), where it also happens immediately:
> >>
> >>          # pacman -Sy archlinux-keyring
> >>          # pacman -Syu
> >>          # pacman -Sy traceroute strace
> >>          # reboot
> >>          # uname -r
> >>          6.1.7-arch1-1
> >>          # useradd foo
> >>          # su -c "traceroute -I 8.8.8.8" foo
> >>          traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
> >>           1  10.210.1.195 (10.210.1.195)  0.209 ms
> >>          send: No route to host
> >>
> >> So now I'm fairly sure it is not something caused by my own network, e=
ither.
> >>
> >> On one system, it seems to work properly about half the time, if I kee=
p
> >> re-running the same command.
> >>
> >
> > Here, running the latest  upstream tree and latest traceroute, I have n=
o issue.
> >
> > Send us :
> >
> > 1) strace output
> > 2) icmp packet capture.
> >
> > Thanks.
>
> Attached both.

Thanks.

I think it is a bug in this traceroute version, pushing too many
sendmsg() at once and hitting socket SNDBUF limit

If the sendmsg() is blocked in sock_alloc_send_pskb, it might abort
because an incoming ICMP message sets sk->sk_err

It might have worked in the past, by pure luck.

Try to increase /proc/sys/net/core/wmem_default

If this solves the issue, I would advise sending a patch to traceroute to :

1) attempt to increase SO_SNDBUF accordingly
2) use non blocking sendmsg() api to sense how many packets can be
queued in qdisc/NIC queues
3) reduce number of parallel messages (current traceroute behavior
looks like a flood to me)
