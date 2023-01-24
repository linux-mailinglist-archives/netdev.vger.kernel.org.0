Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C177B6790A4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjAXGDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjAXGDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:03:25 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE462B60B
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:03:21 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id b1so12335978ybn.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcfXNg574weh8H8rGqRZyuWxwCIxVeur/VRtOdRJB8g=;
        b=DIzEZx3qF6AlCsqfpVZQIxLHEbUr2+D7r45lbaHlU8JCd4F5fKF5uwxCB+GUY7t8xS
         rh4FC2HvPoQwE9ifqcHI5GecGlvTSc4vgy4UuWH7olwnjm+ok3eSiQbSNB9zx9DsmCxQ
         igVppOdvvqLBaItWSiDOCGxWvxDLwLMBUX1boqgKmR9bDoOIjIt1yvDfyNMRHM1ZF0Ce
         9/jRsigoM14Pa7f2jJWCRB2LqOb4ELENvfc0stH0Umi64I+bEqBjZyzVzDkmJt/WJCvZ
         M/KFI/yeBZEbR6/0w+DsKfJ9cL4leIx//lACdR0g3z4SZTv2O728QpmKKwYmotgM4/VV
         BPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcfXNg574weh8H8rGqRZyuWxwCIxVeur/VRtOdRJB8g=;
        b=vurmT+zuP13sPdfsx2uovnZKNyPV73DbyvX3Eq1k3IXcvBcpM+sFVUb6WghWizyVYZ
         YSZcKuWaZLcHNsuI3Hb1EQdlAnrgr6LOd+Fka8OVSADeHXQ0+yP0BS/p8Ya5+pH/fGR/
         HoLVrfahc8ZorJcI6gvFsOMKMJisUm2tnjGzUYBYAMEVUSZwD+YxK2/SOaK70kpsSiGq
         nnrBYcBRfzVc0kx5zJ1pmxOyWELiBi312xmoNbiRXXLMnJZmlbCxinbIgdo5wZg3HDsE
         TN7nkCwbBEBKbk+y7BBFAcXIy59vvKlcbmHZxQcxxBU4q5DceNAAS/PHf7YeEVGVvu/g
         NMPg==
X-Gm-Message-State: AFqh2kpGc3Lj2u3yKJplo2F9DHiczFpuqCR952gZl5Jrsk/cbOhdVrGt
        nzqXutvOw3FW5ZAhYOG6x/YArG/jfou4TB3PerXxUSJrkHqIwDYYafs=
X-Google-Smtp-Source: AMrXdXuIyxyfiokvpdbuw3GT+VP5iA6FE9Fh4genecpvdOKBrDgqnqaOj5ZDxGFrMeqlOVxq86UsjtNmdCWO19lb2YQ=
X-Received: by 2002:a25:9012:0:b0:7b8:a0b8:f7ec with SMTP id
 s18-20020a259012000000b007b8a0b8f7ecmr3579173ybl.36.1674540200819; Mon, 23
 Jan 2023 22:03:20 -0800 (PST)
MIME-Version: 1.0
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com> <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com> <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
 <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com>
In-Reply-To: <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 07:03:09 +0100
Message-ID: <CANn89iLV3NDiEA4tPWUxjqoHNx1pv=SEpXd1b38NXU=TK13=tg@mail.gmail.com>
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

On Tue, Jan 24, 2023 at 6:34 AM Mantas Mikul=C4=97nas <grawity@gmail.com> w=
rote:
>
>
>
> On 24/01/2023 00.26, Eric Dumazet wrote:
> > On Mon, Jan 23, 2023 at 10:45 PM Mantas Mikul=C4=97nas <grawity@gmail.c=
om> wrote:
> >>
> >> On 23/01/2023 22.56, Eric Dumazet wrote:
> >>> On Mon, Jan 23, 2023 at 8:25 PM Mantas Mikul=C4=97nas <grawity@gmail.=
com> wrote:
> >>>>
> >>>> On 2023-01-23 17:21, Eric Dumazet wrote:
> >>>>> On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikul=C4=97nas <grawity@gmai=
l.com> wrote:
> >>>>>>
> >>>>>> Hello,
> >>>>>>
> >>>>>> Not sure whether this has been reported, but:
> >>>>>>
> >>>>>> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivil=
eged
> >>>>>> ICMP traceroute using the `traceroute -I` tool stopped working =E2=
=80=93 it very
> >>>>>> reliably fails with a "No route to host" at some point:
> >>>>>>
> >>>>>>            myth> traceroute -I 83.171.33.188
> >>>>>>            traceroute to 83.171.33.188 (83.171.33.188), 30 hops ma=
x, 60
> >>>>>>            byte packets
> >>>>>>             1  _gateway (192.168.1.1)  0.819 ms
> >>>>>>            send: No route to host
> >>>>>>            [exited with 1]
> >>>>>>
> >>>>>> while it still works for root:
> >>>>>>
> >>>>>>            myth> sudo traceroute -I 83.171.33.188
> >>>>>>            traceroute to 83.171.33.188 (83.171.33.188), 30 hops ma=
x, 60
> >>>>>>            byte packets
> >>>>>>             1  _gateway (192.168.1.1)  0.771 ms
> >>>>>>             2  * * *
> >>>>>>             3  10.69.21.145 (10.69.21.145)  47.194 ms
> >>>>>>             4  82-135-179-168.static.zebra.lt (82.135.179.168)  49=
.124 ms
> >>>>>>             5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.2=
11 ms
> >>>>>>             6  193.219.153.25 (193.219.153.25)  77.171 ms
> >>>>>>             7  83.171.33.188 (83.171.33.188)  78.198 ms
> >>>>>>
> >>>>>> According to `git bisect`, this started with:
> >>>>>>
> >>>>>>            commit 0d24148bd276ead5708ef56a4725580555bb48a3
> >>>>>>            Author: Eric Dumazet <edumazet@google.com>
> >>>>>>            Date:   Tue Oct 11 14:27:29 2022 -0700
> >>>>>>
> >>>>>>                inet: ping: fix recent breakage
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> It still happens with a fresh 6.2rc build, unless I revert that co=
mmit.
> >>>>>>
> >>>>>> The /bin/traceroute is the one that calls itself "Modern tracerout=
e for
> >>>>>> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_IN=
ET,
> >>>>>> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilitie=
s.
> >>>>>> (The problem does not occur if I run it as root.)
> >>>>>>
> >>>>>> This version of `traceroute` sends multiple probes at once (with T=
TLs
> >>>>>> 1..16); according to strace, the first approx. 8-12 probes are sen=
t
> >>>>>> successfully, but eventually sendto() fails with EHOSTUNREACH. (Th=
ough
> >>>>>> if I run it on local tty as opposed to SSH, it fails earlier.) If =
I use
> >>>>>> -N1 to have it only send one probe at a time, the problem doesn't =
seem
> >>>>>> to occur.
> >>>>>
> >>>>>
> >>>>>
> >>>>> I was not able to reproduce the issue (downloading
> >>>>> https://sourceforge.net/projects/traceroute/files/latest/download)
> >>>>>
> >>>>> I suspect some kind of bug in this traceroute, when/if some ICMP er=
ror
> >>>>> comes back.
> >>>>>
> >>>>> Double check by
> >>>>>
> >>>>> tcpdump -i ethXXXX icmp
> >>>>>
> >>>>> While you run traceroute -I ....
> >>>>
> >>>> Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in
> >>>> transit", which is expected for traceroute. Nothing else shows up.
> >>>>
> >>>> (But when I test against an address that causes *real* ICMP "Host
> >>>> unreachable" errors, it seems to handle those correctly and prints "=
!H"
> >>>> as usual -- that is, if it reaches that point without dying.)
> >>>>
> >>>> I was able to reproduce this on a fresh Linode 1G instance (starting
> >>>> with their Arch image), where it also happens immediately:
> >>>>
> >>>>           # pacman -Sy archlinux-keyring
> >>>>           # pacman -Syu
> >>>>           # pacman -Sy traceroute strace
> >>>>           # reboot
> >>>>           # uname -r
> >>>>           6.1.7-arch1-1
> >>>>           # useradd foo
> >>>>           # su -c "traceroute -I 8.8.8.8" foo
> >>>>           traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte pack=
ets
> >>>>            1  10.210.1.195 (10.210.1.195)  0.209 ms
> >>>>           send: No route to host
> >>>>
> >>>> So now I'm fairly sure it is not something caused by my own network,=
 either.
> >>>>
> >>>> On one system, it seems to work properly about half the time, if I k=
eep
> >>>> re-running the same command.
> >>>>
> >>>
> >>> Here, running the latest  upstream tree and latest traceroute, I have=
 no issue.
> >>>
> >>> Send us :
> >>>
> >>> 1) strace output
> >>> 2) icmp packet capture.
> >>>
> >>> Thanks.
> >>
> >> Attached both.
> >
> > Thanks.
> >
> > I think it is a bug in this traceroute version, pushing too many
> > sendmsg() at once and hitting socket SNDBUF limit
> >
> > If the sendmsg() is blocked in sock_alloc_send_pskb, it might abort
> > because an incoming ICMP message sets sk->sk_err
> >
> > It might have worked in the past, by pure luck.
> >
> > Try to increase /proc/sys/net/core/wmem_default
> >
> > If this solves the issue, I would advise sending a patch to traceroute =
to :
> >
> > 1) attempt to increase SO_SNDBUF accordingly
> > 2) use non blocking sendmsg() api to sense how many packets can be
> > queued in qdisc/NIC queues
> > 3) reduce number of parallel messages (current traceroute behavior
> > looks like a flood to me)
>
> It doesn't solve the issue; I tried bumping it from the default of
> 212992 to 4096-times-that, with exactly the same results.
>
> The amount of packets it's able to send is variable, For example, right
> now, on my regular VM (which is smaller than the PC that yesterday's
> trace was done on), the program very consistently fails on the *second*
> sendto() call -- I don't think two packets is an unreasonable amount.
>
> The program has -q and -N options to reduce the number of simultaneous
> probes, but the only effect it has is if I reduce the packets all the
> way down to just one at a time.

Problem is : if we revert the patch, unpriv users can trivially crash a hos=
t.

Also, sent ICMP packets  look just fine to me, and the patch is
changing tx path.

The reported issue seems more like rx path related to me.
Like IP_RECVERR being not handled correctly.

I think more investigations are needed. Maybe contact Pavel Begunkov
<asml.silence@gmail.com>
because the initial crash issue came with
47cf88993c91 ("net: unify alloclen calculation for paged requests")
