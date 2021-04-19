Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6C363F0A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhDSJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhDSJn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:43:56 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C97C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 02:43:27 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 82so38008420yby.7
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 02:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hEAKW4iWFa+USstysB5tOBW8HzTKZWfxo7ADRmj7wg=;
        b=owVh6mDaIHLJm+OB/qUJsaVBKrp4P2SnV1talcOgO7MAXS27Nj/QhBD0+MLd11xMlZ
         upZEMWu4Ycj7YgTwk7dEPegp7la99Ka155uH0n72eB3aU/pWEAnlE+aX7Ky17PeNRMm7
         IeyVcT+TBRlnzqMuKS0YuiurLomF4s98dB7Y42CdNDEDU82igJ91e8pHiU9jwNwtVk8m
         2z7XTMGrXhBK8XhjGt4E2EB/UbYtc/Kmti6JjHd+PlEAre0AkJPK4qxh9imam1X8ecmT
         G4Q39znlzTdi0RX/gxz1Wikke9/+aJTj6ICLea2HKvB5aVcMTmvW8SWk34QG/+RJGDtl
         CSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hEAKW4iWFa+USstysB5tOBW8HzTKZWfxo7ADRmj7wg=;
        b=MwHNTYP6jzo07srhLXEt6muvqTGSetNOhu4df3THK/lAQDSEL4MIg4sP/Y626QYUYy
         ODHhcUXi503KKtsvHTs5Q3WJkaT5iysvjseFda7oMzXNbW4rmlCf+B7vvrrdsvwKUZAr
         mDBOOTTBNJORLv+UHnI+dz29h0aMCbCAWVDU+BQXpOuFxeIPnXdQSbRrbaVeb2/B89F2
         GeRKDMZJKRnOaMZanVxcIhcMzQbqhHFmaa709xfWDoPJtVZ/BQ8M5ZQhQiE+H2/dCB5T
         66rjlpevwZOSNNF5J/dKNsSqQh3NzPdn1sdRvIIENiS9k/UDKxUp1hrtCW/SUFtiBTmD
         aOMA==
X-Gm-Message-State: AOAM531JjJnb1KHvT0XrqUER6BvBCZ+qzP8iFIzrHaqLcdW4zoVMnLhx
        4Ldg9THdhoNfzLlN/Ypz0rKyNrYusIsnVS8CCiLUmw==
X-Google-Smtp-Source: ABdhPJz7LXGS9oOrvhq94orBUWWqsP7hCGGspsQja+soG35GAYBflk24+LxvgXnR2xp0uNF68WRbP6VNCFD2Q/Pilh8=
X-Received: by 2002:a25:4244:: with SMTP id p65mr15973709yba.452.1618825406298;
 Mon, 19 Apr 2021 02:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com> <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu> <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu> <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
 <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
 <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me> <20210418043933.GB18896@1wt.eu>
 <9e2966be-d210-edf9-4f3c-5681f0d07c5f@bluematt.me>
In-Reply-To: <9e2966be-d210-edf9-4f3c-5681f0d07c5f@bluematt.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 19 Apr 2021 11:43:15 +0200
Message-ID: <CANn89iKXYutm20oi-rCwch0eL1Oo9rq1W=ex6+NzvPitq_jX0Q@mail.gmail.com>
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 4:31 PM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
> Should the default, though, be so low? If someone is still using a old modem they can crank up the sysctl, it does seem
> like such things are pretty rare these days :). Its rather trivial to, without any kind of attack, hit 1Mbps of lost
> fragments in today's networks, at which point all fragments are dropped. After all, I submitted the patch to "scratch my
> own itch" :).

Again, even if you increase the values by 1000x, it is trivial for an
attacker to use all the memory you allowed.

And allowing a significant portion of memory to be eaten like that
might cause OOM on hosts where jobs are consuming all physical memory.

It is a sysctl, I changed things so that one could really reserve/use
16GB of memory if she/he is desperate about frags.

>
> Matt
>
> On 4/18/21 00:39, Willy Tarreau wrote:
> > I do agree that we shouldn't keep them that long nowadays, we can't go
> > too low without risking to break some slow transmission stacks (SLIP/PPP
> > over modems for example).
