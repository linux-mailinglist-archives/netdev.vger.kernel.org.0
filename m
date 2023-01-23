Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4516788D0
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjAWU5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjAWU47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:56:59 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7669925E2D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:56:31 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id a9so16511338ybb.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9+FEXw0qBCjIeqW7mLSS6WnTDQUOZZxkZwCQyiUALQ=;
        b=KSLoQsp/0fLBQYyIxyaR5RpLcWAWaB9ggV73wVAoMwJuuaar9m5n/eLwI+xqnnetcg
         2piIF4HdpUxqT9LgxWLoHRwpgl0VKdEd0Hw4HFQeF52OuLF91a1Ie1Ravq3shxfXFjbS
         r501Ijw/Usj0fCL1vBfd/NSzEjtpAP5uP/DOAXHVatle+Y+SrpiKr0gCxkVtsXjiF0iV
         ogrfvEYi8un/LDVKyl+uVHEMseVx+Ax9L9l511aebXQlaxQsDpVgEBWN5jFDrB8oOl9g
         RkGZqxCe8tOOQuIAv0idBPwkZWpYnPnjRELSQTwpH86lD2VICO8ECf80LmmioPsk+QXP
         UFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9+FEXw0qBCjIeqW7mLSS6WnTDQUOZZxkZwCQyiUALQ=;
        b=kP8bxyzV+XYzHg+eaPiy+E/5SfS/iXMWKNHtX76TxgWMk7U7HcK2dqAw52UlmWCmTe
         EXf1UtEGT72VA/TxM+MH6p2gSfQi8/F0nwvUsJNYlMPEPDrXFIM36KUaj8gdZNtvCTcM
         t0r85c+UJuzYy8r/rIvyl4A54wUcWS5q/dwG25SccDNdGbFXOc/YwfAWu6LG4uOJu6Hg
         K5aLaxN/A73+PMPr3j/lWdLvDa02YSFNtsOWIkAbzyri1ZgApjGETPW91yGc76XzsIjf
         tRMQr+ID2oQP0J1XvgEvNdMRmQXabm5cJRm6nNUJauqFfx/r8I/2ZRP9C/XcAfPQn6AL
         VaYQ==
X-Gm-Message-State: AFqh2kqmlMHDQC87vK0NtgRIYkZfwYvjruyPMpXvInhcDkZi9phSStth
        P3HGYwB1hxG5eV7FNQUbKTsQcAaSmZjS6io/461ldg==
X-Google-Smtp-Source: AMrXdXtMNYC+LpaJUOSP/OIK+AsxDQhcHxpvie673rMGk0jSJElmTftJCfZ6b95Q5970Juau6KiCr058g9u3ZcNqYHY=
X-Received: by 2002:a25:9012:0:b0:7b8:a0b8:f7ec with SMTP id
 s18-20020a259012000000b007b8a0b8f7ecmr3423668ybl.36.1674507381194; Mon, 23
 Jan 2023 12:56:21 -0800 (PST)
MIME-Version: 1.0
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com> <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
In-Reply-To: <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Jan 2023 21:56:09 +0100
Message-ID: <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
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

On Mon, Jan 23, 2023 at 8:25 PM Mantas Mikul=C4=97nas <grawity@gmail.com> w=
rote:
>
> On 2023-01-23 17:21, Eric Dumazet wrote:
> > On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikul=C4=97nas <grawity@gmail.co=
m> wrote:
> >>
> >> Hello,
> >>
> >> Not sure whether this has been reported, but:
> >>
> >> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged
> >> ICMP traceroute using the `traceroute -I` tool stopped working =E2=80=
=93 it very
> >> reliably fails with a "No route to host" at some point:
> >>
> >>          myth> traceroute -I 83.171.33.188
> >>          traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
> >>          byte packets
> >>           1  _gateway (192.168.1.1)  0.819 ms
> >>          send: No route to host
> >>          [exited with 1]
> >>
> >> while it still works for root:
> >>
> >>          myth> sudo traceroute -I 83.171.33.188
> >>          traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
> >>          byte packets
> >>           1  _gateway (192.168.1.1)  0.771 ms
> >>           2  * * *
> >>           3  10.69.21.145 (10.69.21.145)  47.194 ms
> >>           4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 m=
s
> >>           5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
> >>           6  193.219.153.25 (193.219.153.25)  77.171 ms
> >>           7  83.171.33.188 (83.171.33.188)  78.198 ms
> >>
> >> According to `git bisect`, this started with:
> >>
> >>          commit 0d24148bd276ead5708ef56a4725580555bb48a3
> >>          Author: Eric Dumazet <edumazet@google.com>
> >>          Date:   Tue Oct 11 14:27:29 2022 -0700
> >>
> >>              inet: ping: fix recent breakage
> >>
> >>
> >>
> >>
> >> It still happens with a fresh 6.2rc build, unless I revert that commit=
.
> >>
> >> The /bin/traceroute is the one that calls itself "Modern traceroute fo=
r
> >> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET,
> >> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
> >> (The problem does not occur if I run it as root.)
> >>
> >> This version of `traceroute` sends multiple probes at once (with TTLs
> >> 1..16); according to strace, the first approx. 8-12 probes are sent
> >> successfully, but eventually sendto() fails with EHOSTUNREACH. (Though
> >> if I run it on local tty as opposed to SSH, it fails earlier.) If I us=
e
> >> -N1 to have it only send one probe at a time, the problem doesn't seem
> >> to occur.
> >
> >
> >
> > I was not able to reproduce the issue (downloading
> > https://sourceforge.net/projects/traceroute/files/latest/download)
> >
> > I suspect some kind of bug in this traceroute, when/if some ICMP error
> > comes back.
> >
> > Double check by
> >
> > tcpdump -i ethXXXX icmp
> >
> > While you run traceroute -I ....
>
> Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in
> transit", which is expected for traceroute. Nothing else shows up.
>
> (But when I test against an address that causes *real* ICMP "Host
> unreachable" errors, it seems to handle those correctly and prints "!H"
> as usual -- that is, if it reaches that point without dying.)
>
> I was able to reproduce this on a fresh Linode 1G instance (starting
> with their Arch image), where it also happens immediately:
>
>         # pacman -Sy archlinux-keyring
>         # pacman -Syu
>         # pacman -Sy traceroute strace
>         # reboot
>         # uname -r
>         6.1.7-arch1-1
>         # useradd foo
>         # su -c "traceroute -I 8.8.8.8" foo
>         traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>          1  10.210.1.195 (10.210.1.195)  0.209 ms
>         send: No route to host
>
> So now I'm fairly sure it is not something caused by my own network, eith=
er.
>
> On one system, it seems to work properly about half the time, if I keep
> re-running the same command.
>

Here, running the latest  upstream tree and latest traceroute, I have no is=
sue.

Send us :

1) strace output
2) icmp packet capture.

Thanks.
