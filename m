Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6860220FEA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgF3VYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgF3VX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:23:57 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21037C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:23:57 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 187so10831078ybq.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U30OFkrejSXAU09n9FsbqbkjUpt98e9QYxgvQQIe3VE=;
        b=KDvS/FCwcnss0qNhjm0NpFuNqkT7h3+EZ/xTBejWNC8QggWOPRJWUE8lGjmgzgV4F6
         CKf3p9gg6ckn82XV/hd/V6dkDn08v8XcOCSJNKHFSXuHZNiKaGjrHXGn9sSJe5aHXe/Q
         D63Zq9xMzVygOREvAxd6d6vzeRwiewKn26ZbEYxBhF4Q03S4e1eGmpulMnWYQXIqJash
         L6mFduHsYhmW8O6cCcAtlc8hH/CUI6t++Qs3AdOOw2bnPAejcIGYeXT3CVGzGOHseQMo
         igumKYVCtgwRFuysW54R/kDb77jbtnUaDF2s95dLKfDnxwIx9NYnkdJedHJHsAu+jU02
         Rhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U30OFkrejSXAU09n9FsbqbkjUpt98e9QYxgvQQIe3VE=;
        b=idL6EtEYd9JKz+NF1v82FZK4r0ZU2dL1x0/upCAgxlkpwMzK4SCUWbqtPUuiqqHPuR
         gn2El+/xwI7iRrq+rbbrBSUpcS7QN2bdmbjVAN1aheZhmtbUiaM9NuSFlTECzSgoWdHv
         0b3YDIXf8v78pR0qvD3ncIYzMvRiHpYya53aY6UnWC+j0Nixi+GzVbUxeWhkkXpA6+S1
         Z2+OC33Nmy5Hpfv4Ri1A0O62fc4QIzbDbP5jtp0emvOSNx0yXGGy1h6jtrNwLrDrLoPH
         JIkCehnBuQAgAtumJdcPIFuuUXDcTyVXY2iE0IoWwwsRb3ftbUB3BU9cOz0a3S7Sci4w
         /lFw==
X-Gm-Message-State: AOAM5328DoGzUfd9+2KWFxUhva8gKTqgm727wYpJy+42GqP1ak9LUKCp
        e/JZpJmilyUB95bm8veQfLy8xlccB3JkUsjuB1cKsAxM
X-Google-Smtp-Source: ABdhPJwvRiGn2p72OxM41uEpcwGeHq27tY+8sROq1FeyItQfz0F+5TMDBnzWOnk7yXafVjj9vG5ep+wApKq2Y25+RlU=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr34790409ybh.364.1593552235823;
 Tue, 30 Jun 2020 14:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
 <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
 <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com>
 <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
 <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com>
In-Reply-To: <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 14:23:44 -0700
Message-ID: <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 2:17 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jun 30, 2020, at 4:56 PM, Eric Dumazet edumazet@google.com wrote:
>
> > On Tue, Jun 30, 2020 at 1:44 PM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Eric Dumazet <edumazet@google.com>
> >> Date: Tue, 30 Jun 2020 13:39:27 -0700
> >>
> >> > The (C) & (B) case are certainly doable.
> >> >
> >> > A) case is more complex, I have no idea of breakages of various TCP
> >> > stacks if a flow got SACK
> >> > at some point (in 3WHS) but suddenly becomes Reno.
> >>
> >> I agree that C and B are the easiest to implement without having to
> >> add complicated code to handle various negotiated TCP option
> >> scenerios.
> >>
> >> It does seem to be that some entities do A, or did I misread your
> >> behavioral analysis of various implementations Mathieu?
> >>
> >> Thanks.
> >
> > Yes, another question about Mathieu cases is do determine the behavior
> > of all these stacks vs :
> > SACK option
> > TCP TS option.
>
> I will ask my customer's networking team to investigate these behaviors,
> which will allow me to prepare a thorough reply to the questions raised
> by Eric and David. I expect to have an answer within 2-3 weeks at most.
>
> Thank you!


Great, I am working on adding back support for (B) & (C) by the end of
this week.
