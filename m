Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC81C281EF6
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBXPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBXPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:15:47 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE33C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 16:15:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id b22so3776886lfs.13
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hGGIeWF8yv9Z6dh0RlPbVdcoNWvyQvdlDGUDwF+vsjg=;
        b=byLqHggn7qv551FO9ypsVqWXCyIlDezZ3M31aQ6vQQXhTTm/kpXh1lEvYOXY5/79C/
         +t6FFa860fUZ08kCfW4hhU/2qaotIVvb2iUxmJgT2sQhjf39ALmqg0r8n2myBqDBycrh
         hLJupw3wRPRhD8YMs9VBvx8DJ+ibGBIE7qJMyjtm3PIUu5J3c3N0joxbUTzRPbLZ7YP3
         cDwf+6uDORx89f7le9Hwq6GW/ch/APQjxeDH6uC2QbOntqx4f3578fcKT6mq76Sy2MDN
         OUHFRTWC7A5mThfn9palDEF39h/ovk7jM8DdoAYGJm5Eug999sQ3Y6si7n+ShY9TJlQT
         NA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hGGIeWF8yv9Z6dh0RlPbVdcoNWvyQvdlDGUDwF+vsjg=;
        b=Ud5vQRkaLSyzezi+5l9quPtNIYg+r9oT6SdW0NyLOoApm0ita5m0F2q60tv9pnAp3z
         Fwxy4yG6QXa+Bmg8WFKIH2aNb2h3FWHwIQ7tj/TOSnPWXNMNVzxLC34Xoun3+R6dmuyW
         im//Mfko1HF/JojHK4oEgIFP6pIiQT3QSWS2ZHkuLGUYFygugwMXDyCoUEf8JOCbCltK
         11ZcOsrhqM2jTWQPWx9viXI4MqCdV4m/QeH4B0AOTXQlNT0PBWi12g/24A+JSKjmnSWe
         ZDvZ9UPW0dNonsjwQ710LigHHDhWxxuUjHpgwNmxUxEHu+ouxWJ8AytAd9D4FEovP+bZ
         eflQ==
X-Gm-Message-State: AOAM533T3RB5lsDDRjmXUWaluJ/0Kqd76y9H64ItMG7ZCfkzy5fvOWOm
        aWmFo62BqvFEjzOlCrRo3mdQ5dNb7XSrNmHaLuCCqF43
X-Google-Smtp-Source: ABdhPJxRjDxXOQ1zWRy+pboXYQsPXJKYcEWbRWsnnqkcZOXYi13z/WCm9KUOZFaeOUGIJ4RzrQkAyFo/vAWVfRB1tIE=
X-Received: by 2002:a19:50d:: with SMTP id 13mr1469519lff.500.1601680545706;
 Fri, 02 Oct 2020 16:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20201002.160042.621154959486835359.davem@davemloft.net>
In-Reply-To: <20201002.160042.621154959486835359.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Oct 2020 16:15:33 -0700
Message-ID: <CAADnVQKdwB9ZnBnyqJG7kysBnwFr+BYBAEF=sqHj-=VRr-j34Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
To:     David Miller <davem@davemloft.net>
Cc:     Wei Wang <weiwan@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 4:02 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wei Wang <weiwan@google.com>
> Date: Wed, 30 Sep 2020 12:21:35 -0700
>
>  ...
> > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > entity per host, is that kthread is more configurable than workqueue,
> > and we could leverage existing tuning tools for threads, like taskset,
> > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > if we eventually want to provide busy poll feature using kernel threads
> > for napi poll, kthread seems to be more suitable than workqueue.
> ...
>
> I think we still need to discuss this some more.
>
> Jakub has some ideas and I honestly think the whole workqueue
> approach hasn't been fully considered yet.

I want to point out that it's not kthread vs wq. I think the mechanism
has to be pluggable. The kernel needs to support both kthread and wq.
Or maybe even the 3rd option. Whatever it might be.
Via sysctl or something.
I suspect for some production workloads wq will perform better.
For the others it will be kthread.
Clearly kthread is more tunable, but not everyone would have
knowledge and desire to do the tunning.
We can argue what should be the default, but that's secondary.

> If this wan't urgent years ago (when it was NACK'd btw), it isn't
> urgent for 5.10 so I don't know why we are pushing so hard for
> this patch series to go in as-is right now.
>
> Please be patient and let's have a full discussion on this.

+1. This is the biggest change to the kernel networking in years.
Let's make it right.
