Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3753D1A077E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgDGGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 02:43:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38297 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgDGGnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 02:43:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id l11so1459474lfc.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 23:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OivOvN/o8gD1CI0/RRvNf9QuUqmaxYvN8Wf6SB8cHhk=;
        b=mxhMTlXaTWQOfj6UOAJK4K+XlKKUSLakafb8CAFJsq1PQC/hBcA34JiOdrRqMJnEGY
         ZgjnmOq44EvutBSgvMEnI95N8byxPCRJrAQFbIeKRQJu/Qq7syLFZ5eeo/mkoJ0xiomK
         sroYl33qPbntRAwCjfoihnS4GB4I3d7CCYOLRvo34xM5Vig70FEiQ06yE4gHt1fn+Qi6
         j6YiDyx3W5KTvI6MfhE/HaT0Dh54hpqJOxM2y/n3BlNZ/SrYsHSspdl0LwTFTUtJNNyw
         atB/jqPqTClkM282cfExVVnAxn5RwZfRtKpZKLMyq61mPupJy7ebVlNytIawKcZrxDCl
         uS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OivOvN/o8gD1CI0/RRvNf9QuUqmaxYvN8Wf6SB8cHhk=;
        b=LWCSiGp2a8psu1NC8f9eCKOJ0NCt64ohYMm7KGg5NtlCszRYoWiQPvipQWMjX6oh1L
         8shoL6U9w+VDQ5s/6ECeywZNtTdKLlnotmkM9sWK/o5vy6VhG/2mU83Tsv0l82FXdPyL
         scuONOTkkc1S+6ipzi/uJgYVhVPpvcv7IICmZnRD82ZoGy6whViHL1JO5Mq33PtRK6Vi
         dkkf36xoIgPHVaSSn5knoI2FbKNrdcg0coHSdvCIUZjiST3aoIU+0hRa32bm8rCVuP6A
         ikLL/MZF9myQaCDP76ZN4SvbNEhLTTeEN4xVz6r8fhK5eokq8iTsZVpQ7mrWmh3rRRjI
         4Opw==
X-Gm-Message-State: AGi0PubRAC92pXx2F1pcUS7+m9PXauVhO84MxYCpDEx8NbN7Ali9xokx
        c6toNEP4F4X0zounr+CBYCQEvJ5I9XX/PSmtb3cSFQ==
X-Google-Smtp-Source: APiQypKqAs223KGZqI3lkqdz0fRZjxubri09ud5p1UeeKehXNEZpq92ZBMf2CClMn4Xvs7o3el1+N//5NbPGVdrLbJs=
X-Received: by 2002:ac2:5c07:: with SMTP id r7mr552282lfp.160.1586241786676;
 Mon, 06 Apr 2020 23:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
 <87ftdgokao.fsf@tynnyri.adurom.net> <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
 <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com> <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
 <87imiczrwm.fsf@kamboji.qca.qualcomm.com> <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
 <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
 <87v9mcycbf.fsf@kamboji.qca.qualcomm.com> <CABPxzYKs3nj0AUX4L-j87Db8v3WnM4uGif9nRTGgx1m2HNN8Rg@mail.gmail.com>
 <35cadbaff1239378c955014f9ad491bc68dda028.camel@sipsolutions.net>
 <CABPxzY++YMBPTV4quAkYvEAMfULjMXLkVfNzwocwubno5HO2Bw@mail.gmail.com>
 <5575dfe84aa745a3c2a61e240c3d150dc8d9446f.camel@sipsolutions.net> <CABPxzYJHjaLH+ozyFZx1hwXrNxdHgJaardk-kn7d72y7RC-=hw@mail.gmail.com>
In-Reply-To: <CABPxzYJHjaLH+ozyFZx1hwXrNxdHgJaardk-kn7d72y7RC-=hw@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 7 Apr 2020 12:12:54 +0530
Message-ID: <CAFA6WYP1Os46sh8-PTyDp0ztK2e6cbCoATVX5HN-ojG7bNxeOw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Apr 2020 at 23:39, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
>
> On Mon, Apr 6, 2020 at 8:36 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > On Mon, 2020-04-06 at 19:55 +0530, Krishna Chaitanya wrote:
> >
> > > > iw phy0 interface add wlan0 type station
> > > > ip link set wlan0 up
> > > Ah okay, got it, thanks. Very narrow window though :-) as the
> > > alloc_ordered_workqueue
> > > doesn't need RTNL and there is a long way to go to do if_add() from
> > > user and setup
> > > the driver for interrupts.
> >
> > True, I do wonder how this is hit. Maybe something with no preempt and a
> > uevent triggering things?

The crash is reproducible while working with iwd [1] which is
basically a wireless daemon. It can be started as "iwd.service" during
boot that can detect wiphy registration events and configure
interfaces. Have a look at this text [2] from iwd manager.

To have a simple reproducer, please have a look at this trigger script
[3] from Matthias in CC. With this script I am able to reproduce the
kernel crash with approx. frequency of 1/10 across reboots on
dragonboard 410c.

There is nothing special like no preempt.

[1] https://wiki.archlinux.org/index.php/Iwd
[2] https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/manager.c#n563
[3] https://github.com/DasRoteSkelett/meta-iwd/blob/master/recipes-trigger/trigger/trigger/trigger.sh

> Probably, it might be specific to the dragonboard410c configuration
>

As described above, it isn't specific to any dragonboard 410c
configuration and one should be able to reproduce it on other boards
too using iwd depending on how long it takes to start corresponding
wiphy device.

> > > Again depends on the driver though, it
> > > should properly handle
> > > pending ieee80211_register_hw() with start().
>
> > It could, but it'd be really tricky. Much better to fix mac80211.

+1

-Sumit

> Sure, anyways it is a good change.
