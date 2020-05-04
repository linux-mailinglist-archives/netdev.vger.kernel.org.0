Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449BF1C3E97
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgEDPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728021AbgEDPeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:34:10 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55DC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 08:34:09 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id l5so9406186ybf.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AqCoxUzdE89qnyCXOrkhVny+gL5fdx3VG/+BXPHdf4=;
        b=FF8a5aBxdEQyeHfLh8f77nhUb+OzDy51voMFRcxKB8pIag4cVu1tuJU2efqXVachMG
         BSH1i+D5k+4oLIXlRhd8pAjDf8SUCkFmSOzzHlvi1v0twHRd1sh/kW/aBqKLTNCep4LN
         uTQ4W5s25wm0rGirqOLcE289ecA7ZRhLcXgAcGD5/afM7z2BZ7sjKQ//dHLeEIhEgd0U
         /++b1eF+aOKrnPG0pfsCoLONF0oFSNFSSDWYXicSvRQPLBUnBl7zJEk+p4o/mZaNYy0O
         GFdN51+eklZiFnqnEsNp84Ajw//YuluUNil6lxDipcjglXM9gk/AUeZGZdCfTh6Y2jK0
         WSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AqCoxUzdE89qnyCXOrkhVny+gL5fdx3VG/+BXPHdf4=;
        b=ovUs2SG2xO233A5UOwdPfF757Lsui3VEUr3vjGFoJDbVeFGDbuFsqbH+J4bgWcpBoe
         Hb2jwjh14/lRWBaAgWBsj/GTumTWC3gWcYKx6t6WTFgN3wOQE3deH/qCuYFzr0xzYLoq
         ezIv0HY27sty5UKjeR8HqT2t8YquRW2gZ1tdCmRylyaJDzGrljVBPDvZV9zj0+NxJl1V
         vzVrYwMPlr37GK3hiOpC60U9VvZ5P8QT4dNbJzCyKkFzyfj04mAhRf2U5+xpfoztLH0O
         lur2P68Ln0hin/zxeTOlr3NkwFSSSC2sXaCnqfY0S8hcoWIHqAk2rZLMztsjZ39eDpeX
         gmhQ==
X-Gm-Message-State: AGi0PubbOanN+elgh46HSZOZp2lx+DzrXBcgTYfe6pLgfgRfoyLcPl9x
        eGmIgbLK2CazjERizaYb+8JePO/VcWxgD9qhccsvUQ==
X-Google-Smtp-Source: APiQypKv12pO+Obs+wSf5rxqtasjbJCZQfFy/QAYcTcSu+HlUo0TsLQ4AwL0oVn/3zxEzgsWBjSllXOAX2SKGLY82sg=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr26524524ybc.520.1588606448678;
 Mon, 04 May 2020 08:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200422161329.56026-1-edumazet@google.com> <20200422161329.56026-2-edumazet@google.com>
 <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com> <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
 <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com> <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
 <dd7d271f-ce45-5783-45a0-e89a6c428428@linux.ibm.com>
In-Reply-To: <dd7d271f-ce45-5783-45a0-e89a6c428428@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 4 May 2020 08:33:57 -0700
Message-ID: <CANn89iJu8CtdQrDSoRA1cS1VCLge7nNamXT7X2TYxG8E0_FquQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 8:28 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> On 02.05.20 18:24, Eric Dumazet wrote:
> >
> >
> > On 5/2/20 9:10 AM, Julian Wiedmann wrote:
> >> On 02.05.20 17:40, Eric Dumazet wrote:
> >>> On Sat, May 2, 2020 at 7:56 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
> >>>>
> >>>> On 22.04.20 18:13, Eric Dumazet wrote:
>
> [...]
>
> >>>>
> >>>>
> >>>>> By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
> >>>>>
> >>>>> This patch does not change the prior behavior of gro_flush_timeout
> >>>>> if used alone : NIC hard irqs should be rearmed as before.
> >>>>>
> >>>>> One concrete usage can be :
> >>>>>
> >>>>> echo 20000 >/sys/class/net/eth1/gro_flush_timeout
> >>>>> echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
> >>>>>
> >>>>> If at least one packet is retired, then we will reset napi counter
> >>>>> to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
> >>>>> of the queue.
> >>>>>
> >>>>> On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
> >>>>> avoidance was only possible if napi->poll() was exhausting its budget
> >>>>> and not call napi_complete_done().
> >>>>>
> >>>>
> >>>> I was confused here for a second, so let me just clarify how this is intended
> >>>> to look like for pure TX completion IRQs:
> >>>>
> >>>> napi->poll() calls napi_complete_done() with an accurate work_done value, but
> >>>> then still returns 0 because TX completion work doesn't consume NAPI budget.
> >>>
> >>>
> >>> If the napi budget was consumed, the driver does _not_ call
> >>> napi_complete() or napi_complete_done() anyway.
> >>>
> >>
> >> I was thinking of "TX completions are cheap and don't consume _any_ NAPI budget, ever"
> >> as the current consensus, but looking at the mlx4 code that evidently isn't true
> >> for all drivers.
> >
> > TX completions are not cheap in many cases.
> >
> > Doing the unmap stuff can be costly in IOMMU world, and freeing skb
> > can be also expensive.
> > Add to this that TCP stack might be called back (via skb->destructor()) to add more packets to the qdisc/device.
> >
> > So using effectively the budget as a limit might help in some stress situations,
> > by not re-enabling NIC interrupts, even before napi_defer_hard_irqs addition.
> >
>
> Neat, thanks for sharing this. Now I also see the tricks that mlx4 plays to still
> get netpoll working.... fun.
>

This is generic napi stuff :)

https://netdevconf.info/2.1/papers/BusyPollingNextGen.pdf

Drivers authors are welcomed to adapt their code, if not already updated.
