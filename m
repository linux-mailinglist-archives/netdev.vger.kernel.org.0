Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783419F0FA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbfH0Q7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:59:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40489 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0Q7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 12:59:03 -0400
Received: by mail-io1-f65.google.com with SMTP id t6so47965658ios.7
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 09:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AU23rJrpWxaQe0Lvlg67p/mVHxJweGfUbsKOXuMYuSQ=;
        b=fb47w54vPBVaku9NPHHIZeCOACdDEiWUYeq7BRK91GzCmGIAMSXIACefMihAHUUk14
         SHZtuAwPCmbju/gNyM4LCobqwh/R9WxEqV1kWNjKnznaPRFFr3ckf8eq46DUe5hWqoFs
         2lcwkaG0HO0RvjWsCimEYaLE1iiwb1Auksg4CJmTQ+Sdp4/LfiN5as0vzR4IQVjspyRo
         +sFLZJsmZuMzvv9HqX7E7P6+hKsOIF+XqAKCuWB9HjcuTf1bceJUVINeOQmbtQZH0xR6
         9tnFnQyNqEtc+9KmN55qGlvgxppxYZ2oc68zGwOfJ/SGtyc/O8NxS8NUXtM6aSytfLvJ
         p3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AU23rJrpWxaQe0Lvlg67p/mVHxJweGfUbsKOXuMYuSQ=;
        b=CRzPgDYkwMe8fYE66HDdpjkLYOwzCSQe912g8xtSXOYpPpMs9X3ZGKCBj8RhS6lIOK
         wUArre70XvMfGOdCZC3D7NbY3euHWDkqjy1Ne5n0PInQIPRgnGx7Q+0+vIx29fZ9ZPHN
         FvLAW/cRW0oxpd9Q+yljTz59uAPs6WOxE44zE4vM+dEprmGPy/eSdOy7AYgfT/N4cwUG
         AwkO7jK2MlfznKH9MkSLil3hipsyADCVCw4/DIGm1apE9be/B0g0e+AMisGNx6Is/Llu
         zMYdsfS9Vf5slo450c21YjhV/NKnkQCS6EpDHujuRIbOPxe+ibvCd7sdTcCCeLcaOyp+
         HU3g==
X-Gm-Message-State: APjAAAV+u4SxAOhdmjI6fG6+AmvdZ0bVQG0scq5Mz7wFtjhdqoFGXTFn
        X7XBPf32y01Z/jvYAg2u9A4UyVrmBzBwYLXRA/wFgNewx3Y=
X-Google-Smtp-Source: APXvYqz4tRSHm+3pXQ6J77t0h9FXrqqjuMjlwdXUwu0DX+Mq8HyYCcCzvcF0ZKf4Uig2s+aaDQHlXjEEFj/0fI0nGdQ=
X-Received: by 2002:a5e:9818:: with SMTP id s24mr34454775ioj.0.1566925142388;
 Tue, 27 Aug 2019 09:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190827141938.23483-1-gautamramk@gmail.com> <316fdac3-5fa9-35d5-ad74-94072f19c5fc@gmail.com>
In-Reply-To: <316fdac3-5fa9-35d5-ad74-94072f19c5fc@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 27 Aug 2019 09:58:50 -0700
Message-ID: <CAA93jw6PJXsG++0c+mE8REUb0cD4PU2Xck-J9fD1miuKfxS6BQ@mail.gmail.com>
Subject: Re: [net-next] net: sched: pie: enable timestamp based delay calculation
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 8:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
>
>
> On 8/27/19 4:19 PM, Gautam Ramakrishnan wrote:
> > RFC 8033 suggests an alternative approach to calculate the queue
> > delay in PIE by using per packet timestamps. This patch enables the
> > PIE implementation to do this.
> >
> > The calculation of queue delay is as follows:
> >       qdelay =3D now - packet_enqueue_time
> >
> > To enable the use of timestamps:
> >       modprobe sch_pie use_timestamps=3D1
>
>
> No module parameter is accepted these days.
>
> Please add a new attribute instead,
> so that pie can be used in both mode on the same host.

I note that I think (but lack independent data) this improvement to
the rate estimator in pie should improve its usability and accuracy
in low rate or hw mq situations, and with some benchmarking to
show the cpu impact (at high and low rates) of this improvement as
well as the network
impact, the old way should probably be dropped and new way adopted without
needing a new variable to control it.

A commit showing the before/after cpu and network impact with a whole
bunch of flent benchmarks would be great.

(I'd also love to know if pie can be run with a lower target - like 5ms -
 with this mod in place)

>
> For a typical example of attribute addition, please take
> a look at commit 48872c11b77271ef9b070bdc50afe6655c4eb9aa
> ("net_sched: sch_fq: add dctcp-like marking")

utilizing ce_threshold in this way is actually independent of whether or
not you are using dctcp-style or rfc3168 style ecn marking.

It's "I'm self congesting... Dooo something! Anything, to reduce the load!"




--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
