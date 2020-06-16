Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1014C1FAE81
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgFPKtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbgFPKtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:49:15 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A236C08C5C2
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:49:14 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id i3so18387311ljg.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlZV8M0wLLmNtMjp3g91fZK/2EEbjdOhUQarQurS12g=;
        b=uZe0RcUrTSt+S0m6WRkZ9jBpvQUtcsDlGnTdYycb4KalYcMCaer6L2x8wQGvC7TUrC
         WRrBLhj4BxV87iwPzNN6SlsjP65n+fLyq8Sm+THLBe9QH1All7VkIFY0g7HarCJpLoXY
         AxSUQ2xUbJiwtZBZ0OeYL8XQWGDoqv9uHY7J9x1S8cDW9WnV5jn0hAund/mwpZK8gWVw
         o/Y/vLpiiR8lwOqoaGrBVuQzxllmE318rdTYe42noQAynVZ5Kj+aEiJVvRSYqffTkkB3
         LN+tnFSgm4ALiKXo+9xWwNLzDMDWOQ4tMhpXXG87xF26jKaDFBaq808YQw6CLBQ4RpK0
         IrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlZV8M0wLLmNtMjp3g91fZK/2EEbjdOhUQarQurS12g=;
        b=lZs4BZVmb8QazpTp4v7qSsTi5QEX1jsduZCag3k5zIxykFWQM+MNX+l0a1lup6EYud
         x0Osmf6/6FDr1NVgdQ4JEKJBvhduzKddM23K61vD0KzHzoodz5kl4EfSN4fid5PUtCfA
         YsgSk7Zodvg2fKvUKXU6GsM7qH6Hav722htDIbOF7I1c2qkEX809G5bUcNumuU0USrku
         NUNQwC9Cj/Q9eNO6PdWkuLE2PJ3wHSWs2bKQGVhJ91iMiOeojW/JWWofJIQ8WF/awq9p
         RFUFUCNNxdaiq73mZ7jk56Mni30FU2rmFS6sGsISmIzMIxNDFFRoo/PtPcvCjMlG1rc9
         8blA==
X-Gm-Message-State: AOAM53231neHr7IdtytPHhwDdbvOScEJ8gzhLDg+Zp5Ag6ORPXzNnZG+
        GV1mtQ6Gk/MZp5gEXqoHb9p5q41HMhf5YZyhTOPaMsa+//A=
X-Google-Smtp-Source: ABdhPJxaVSeTWFDuQqGHhl2dY8xaO/LXzArJOvtGS7nPO8xMudS6r4IO8cBojQT0/J48BUjAxkgy7+90jpf+0eYglZ8=
X-Received: by 2002:a2e:5c2:: with SMTP id 185mr1051189ljf.260.1592304552689;
 Tue, 16 Jun 2020 03:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200615150037.21529-1-ap420073@gmail.com> <20200615152148.GE16460@breakpoint.cc>
In-Reply-To: <20200615152148.GE16460@breakpoint.cc>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 16 Jun 2020 19:49:00 +0900
Message-ID: <CAMArcTWXDb3RX3NjkU22Q9J417XKOt5ghzmQw5Yt0w=UGzH-nQ@mail.gmail.com>
Subject: Re: [PATCH net] net: core: reduce recursion limit value
To:     Florian Westphal <fw@strlen.de>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 00:21, Florian Westphal <fw@strlen.de> wrote:
>

Hi Florian,
Thank you for the review!

> Taehee Yoo <ap420073@gmail.com> wrote:
> > In the current code, ->ndo_start_xmit() can be executed recursively only
> > 10 times because of stack memory.
> > But, in the case of the vxlan, 10 recursion limit value results in
> > a stack overflow.
> [..]
>
> > Fixes: 97cdcf37b57e ("net: place xmit recursion in softnet data")
>
> That commit did not change the recursion limit,
> 11a766ce915fc9f86 ("net: Increase xmit RECURSION_LIMIT to 10.") did?

You're right.
I will send a v2 patch.

Thanks!
