Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F46943FB27
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhJ2LCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhJ2LCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:02:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14348C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 04:00:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so1162935wmb.5
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 04:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O3oaDN2gpxryQcZbqbv+wyWbmX+dh9L0V5UJG38mn1g=;
        b=flCgF7AmI58fDgqUzP7e4Us8VWrnow4KebbSQzVnOxr3F4YNjpk6Dg3qW+/Ai9684t
         34KwUB9oajdImvPjBsMcI6ELBoaouFdO+cE/Sg/CC+vyED7hIxMbV0iSqHZrUdMOUWvr
         anJRwKMkR2CzHG2Si5Fq1FlkUIjR10rO9IkAEPdZr2u4OD+e8flAPehf+BjYz4r8t7ux
         puvaj0ySwfkm+UPyNWORajjj1FEL68PRsyxEdw6YWZqe+Z3NRrplCdBPL8d5CCaYTLLy
         w7VhccfNk78AcIZeuBa61O0uHgiD2icuurk2qs6irkHFMQBAVWkyYxgV4q9Fqb9i58K1
         gJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O3oaDN2gpxryQcZbqbv+wyWbmX+dh9L0V5UJG38mn1g=;
        b=At1PbvJI6esGQlZeRWgLkoSJU6nU8rv+RRODo4aca2QoObJ96kVolq/+d2yHVLiJZV
         ezf+//dqT022AxU40ukfU2JQ5gE2fQO9JaQswm6QAd/oVM0pxYE5J1afNH5kReFL/NsL
         kd8GB5eTOXOPuo3yVeC1yl+ZOAWatKOCSXXWMXjCIJFBO06w2q+Fcrq1VTOeMcJxdvcW
         enGLx0k/MeDZS2n3gSzJmcidnwFwGxcVW0ZO8khdL40koDo5xRFhOWJvQqEHlHM/FnSD
         EiarEA3rP9ttQoUiQLZs+NLTgi45+35oPrxmGnEgIXY0m+6Lo1uuQ3ZFnE9nIKKAjQJj
         modw==
X-Gm-Message-State: AOAM532fxTbEHHge5JbU5woe9TYBO/1qTMSGlGVhMvYWRs2EqPucGB8/
        aSKYm7Ww0ubofiDbASgsc1xHNbtF/WyA9b5f215aQQ==
X-Google-Smtp-Source: ABdhPJzp3HpqOSlplACd7S5Zr4Q/rHXMCrVSWbXT+dp44F1UF8VRvaixwQVERUzCgLKyBTopiL0CGIgZ7KCJwEzyXZg=
X-Received: by 2002:a1c:158:: with SMTP id 85mr11988175wmb.182.1635505210272;
 Fri, 29 Oct 2021 04:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
 <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org> <CABBYNZKpcXGD6=RrVRGiAtHM+cfKEOL=-_tER1ow_VPrm6fFhQ@mail.gmail.com>
 <CAJQfnxH=hN7ZzqNzyKqzb=wSCNktUiSnMeh77fghsudvzJyVvg@mail.gmail.com>
 <E68EB205-8B05-4A44-933A-06C5955F561A@holtmann.org> <CAJQfnxHn51XRywv68xcL4u=qERyi2S0boLBOGBnBbUfu9pQWGQ@mail.gmail.com>
 <BEAEDCF9-75D7-4D34-B272-AD044533B311@holtmann.org>
In-Reply-To: <BEAEDCF9-75D7-4D34-B272-AD044533B311@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Fri, 29 Oct 2021 18:59:59 +0800
Message-ID: <CAJQfnxEyd54v=CJTwE6rdZ7a0Hbh4A1cK=VUYSqteU9f8hpWrw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Limit duration of Remote Name Resolve
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,


On Fri, 29 Oct 2021 at 18:11, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> >>>>>> When doing remote name request, we cannot scan. In the normal case=
 it's
> >>>>>> OK since we can expect it to finish within a short amount of time.
> >>>>>> However, there is a possibility to scan lots of devices that
> >>>>>> (1) requires Remote Name Resolve
> >>>>>> (2) is unresponsive to Remote Name Resolve
> >>>>>> When this happens, we are stuck to do Remote Name Resolve until al=
l is
> >>>>>> done before continue scanning.
> >>>>>>
> >>>>>> This patch adds a time limit to stop us spending too long on remot=
e
> >>>>>> name request. The limit is increased for every iteration where we =
fail
> >>>>>> to complete the RNR in order to eventually solve all names.
> >>>>>>
> >>>>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> >>>>>> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> >>>>>>
> >>>>>> ---
> >>>>>> Hi maintainers, we found one instance where a test device spends ~=
90
> >>>>>> seconds to do Remote Name Resolving, hence this patch.
> >>>>>> I think it's better if we reset the time limit to the default valu=
e
> >>>>>> at some point, but I don't have a good proposal where to do that, =
so
> >>>>>> in the end I didn't.
> >>>>>
> >>>>> do you have a btmon trace for this as well?
> >>>>>
> >>> Yes, but only from the scanning device side. It's all lined up with
> >>> your expectation (e.g. receiving Page Timeout in RNR Complete event).
> >>>
> >>>>> The HCI Remote Name Request is essentially a paging procedure and t=
hen a few LMP messages. It is fundamentally a connection request inside BR/=
EDR and if you have a remote device that has page scan disabled, but inquir=
y scan enabled, then you get into this funky situation. Sadly, the BR/EDR p=
arts don=E2=80=99t give you any hint on this weird combination. You can't c=
onfigure BlueZ that way since it is really stupid setup and I remember that=
 GAP doesn=E2=80=99t have this case either, but it can happen. So we might =
want to check if that is what happens. And of course it needs to be a Bluet=
ooth 2.0 device or a device that doesn=E2=80=99t support Secure Simple Pair=
ing. There is a chance of really bad radio interference, but that is then j=
ust bad luck and is only going to happen every once in a blue moon.
> >>>>
> >>> It might be the case. I don't know the peer device, but it looks like
> >>> the user has a lot of these exact peer devices sitting in the same
> >>> room.
> >>> Or another possibility would be the user just turned bluetooth off fo=
r
> >>> these devices just after we scan them, such that they don't answer th=
e
> >>> RNR.
> >>>
> >>>> I wonder what does the remote sets as Page_Scan_Repetition_Mode in t=
he
> >>>> Inquiry Result, it seems quite weird that the specs allows such stag=
e
> >>>> but it doesn't have a value to represent in the inquiry result, anyw=
ay
> >>>> I guess changing that now wouldn't really make any different given
> >>>> such device is probably never gonna update.
> >>>>
> >>> The page scan repetition mode is R1
> >>
> >> not sure if this actually matters if your clock drifted too much apart=
.
> >>
> >>>>> That said, you should receive a Page Timeout in the Remote Name Req=
uest Complete event for what you describe. Or you just use HCI Remote Name =
Request Cancel to abort the paging. If I remember correctly then the settin=
g for Page Timeout is also applied to Remote Name resolving procedure. So w=
e could tweak that value. Actually once we get the =E2=80=9Csync=E2=80=9D w=
ork merged, we could configure different Page Timeout for connection reques=
ts and name resolving if that would help. Not sure if this is worth it, sin=
ce we could as simple just cancel the request.
> >>>>
> >>>> If I recall this correctly we used to have something like that back =
in
> >>>> the days the daemon had control over the discovery, the logic was th=
at
> >>>> each round of discovery including the name resolving had a fixed tim=
e
> >>>> e.g. 10 sec, so if not all device found had their name resolved we
> >>>> would stop and proceed to the next round that way we avoid this
> >>>> problem of devices not resolving and nothing being discovered either=
.
> >>>> Luckily today there might not be many devices around without EIR
> >>>> including their names but still I think it would be better to limit
> >>>> the amount time we spend resolving names, also it looks like it sets
> >>>> NAME_NOT_KNOWN when RNR fails and it never proceeds to request the
> >>>> name again so I wonder why would it be waiting ~90 seconds, we don't
> >>>> seem to change the page timeout so it should be using the default
> >>>> which is 5.12s so I think there is something else at play.
> >>>>
> >>> Yeah, we received the Page Timeout after 5s, but then we proceed to
> >>> continue RNR the next device, which takes another 5s, and so on.
> >>> A couple of these devices can push waiting time over 90s.
> >>> Looking at this, I don't think cancelling RNR would help much.
> >>> This patch would like to reintroduce the time limit, but I decided to
> >>> make the time limit grow, otherwise the bad RNR might take the whole
> >>> time limit and we can't resolve any names.
> >>
> >> I am wondering if we should add a new flag to Device Found that will i=
ndicate Name Resolving Failed after the first Page Timeout and then bluetoo=
thd can decide via Confirm Name mgmt command to trigger the resolving or no=
t. We can even add a 0x02 for Don=E2=80=99t Care About The Name.
> >>
> > This is a great idea.
> > However I checked that we remove the discovered device cache after
> > every scan iteration.
> > While I am not clear about the purpose of the cache cleanup, I had
> > assumed that keeping a list of devices with bad RNR record would go
> > against the intention of cleaning up the cache.
> >
> > If we are to bookkeep the list of bad devices, we might as well take
> > this record into account when sorting the RNR queue, so the bad
> > devices will be sent to the back of the queue regardless how good the
> > RSSI is.
>
> the inquiry cache is solely for name resolving and connection request so =
that you are able to fill in the right values to speed up the paging.
>
> I think it is just enough to include a flag hinting the resolving failure=
 into the Device Found message. We are sending two Device Found anyway on s=
uccess. So now we get one on failure as well. And then lets bluetoothd do a=
ll the caching if it wants to.
>
Oh, I see what you mean.
Then I shall implement this solution.

> Regards
>
> Marcel
>

Thanks,
Archie
