Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A835A1FC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDIP2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIP2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:28:41 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D832C061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 08:28:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l9so7059720ybm.0
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zleea9l7WU5nIFs3y2MAhyxIzowCXZxmN6tPXtz4+GU=;
        b=uDST1pGQuNqyx6jV9FiXrLG2RPRQN8fEfAonoR43DleWUKCgca4VnykgQXhYlwmnwN
         fkXV5ZasQrIWbvqLHSrRKxBZc5TS/9pal8WP515XrZcxLVGFfuXASejohYs/8ezovynL
         NXZSDiD3+3Vsx7Dh9mA/dvALk+Rontzi/lqqWHP/oCxCTth9AJVYz2E4TaMPIvgoXBLM
         z0Rw8rk8l77Ov5FNc/s4K+VV1VYct4g2WIQ4V36bKv46kYuzfZ0s2lx09l8AwmbDttn9
         Of53ukjr2+io0UWT7U3TaVe9VXMjLPvQrWNN919d5KZYig7JAmd8RR+R8ppCBRxUNAK5
         vPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zleea9l7WU5nIFs3y2MAhyxIzowCXZxmN6tPXtz4+GU=;
        b=USyP1RdqjWMyaLSWvcTyEXRfFY7LSNpWDfIQfs6JeEb/BvMsmln4XhZ3p7lzHtBENq
         JQh7F9CrGbslPUAvFj50zH6Unpo+fJm0R3Jp8Vsoms70AICuuvCH5oaLHzd+51r+C58s
         tIB39r7W98szL8JnA6gM9wi3kOYYWL+rEz41TGPYBjZYOPv/lX9tKV68ckx1fS8xcJj4
         IPj6shJGOmXYwC6VIDyTFGY4UpWjV8NaZ3HJ1BDvvZpIHugPsFGk0kV28lcwRtvTeEfm
         c3v8LmwoLESqWacqsWJfpXiYne3pE0Jb40CHRo9gjFzaSeDkf++Uclx5iZXOinZcDNbP
         eKJg==
X-Gm-Message-State: AOAM5313DUjTEVYVVEn5fzbfm+DLMhEGWyp7lpB9RhBv4qcAERwH5+Tw
        0aoeiqNJ0OdhBhRh6cC4Ra1alI5bOFEM9asRLeBQQQ==
X-Google-Smtp-Source: ABdhPJz/u3U5RtgDiRggbBkzSaY3oxYCqQKocUp7KlVwu62BbqqNoqyh+QlbG0g5lfjNEawgx9bxyCXdvhqoxwq0O4M=
X-Received: by 2002:a25:b906:: with SMTP id x6mr18343864ybj.504.1617982106774;
 Fri, 09 Apr 2021 08:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
In-Reply-To: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Apr 2021 17:28:15 +0200
Message-ID: <CANn89i+gc6nL05VukOFLTW5KQqhFjx1YxD77x-Db=-uDAhNJ2Q@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix hangup on napi_disable for threaded napi
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 5:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> napi_disable() is subject to an hangup, when the threaded
> mode is enabled and the napi is under heavy traffic.
>
> If the relevant napi has been scheduled and the napi_disable()
> kicks in before the next napi_threaded_wait() completes - so
> that the latter quits due to the napi_disable_pending() condition,
> the existing code leaves the NAPI_STATE_SCHED bit set and the
> napi_disable() loop waiting for such bit will hang.
>
> This patch addresses the issue by dropping the NAPI_STATE_DISABLE
> bit test in napi_thread_wait(). The later napi_threaded_poll()
> iteration will take care of clearing the NAPI_STATE_SCHED.
>
> This also addresses a related problem reported by Jakub:
> before this patch a napi_disable()/napi_enable() pair killed
> the napi thread, effectively disabling the threaded mode.
> On the patched kernel napi_disable() simply stops scheduling
> the relevant thread.
>
> v1 -> v2:
>   - let the main napi_thread_poll() loop clear the SCHED bit
>
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
