Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF141454E57
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 21:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhKQUTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 15:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhKQUT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 15:19:27 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DFAC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 12:16:28 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y196so3320450wmc.3
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 12:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e9JDDLKXHuTFcM3z4ga/Fn/jg+Jax3mIc77wfm2nPxs=;
        b=Dvcju6C3WygfJz6QeJnbBGDjTrMr4IH+kHUVR7Qy/vROOk5MznKc0vDkinoliKTKX7
         sa0e1VEM6WP4QuJacHy2ANqTJCgx1lr5RO6TKbgW75bMW1j81c8Gm7c1+ebV7PzXwc5B
         8WCSyCznzF240zzenC780jnZ2AF0BiC7CzPo0q9YQqKug1ymhYJnDp3AHxZSOMEmfOWU
         49SGxSofibhAK97r9IYqVKqgkEZpjd591LG/EQ874GGo9D4gftPZlT5Q/youiWuVMKBx
         cRqYLn7WwSta4BD38ML7p9d7MQOmh/nthKKo83L5WckPCKzoMJeIa6uPHn8Q0aM8UCET
         SL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e9JDDLKXHuTFcM3z4ga/Fn/jg+Jax3mIc77wfm2nPxs=;
        b=ki7RGk+1p2B9qJw5CtM93MNpEjkC8TMvMlfABToQWs4iVgiGx7UiCHANmYQm7L2kTI
         Luau0KoYi0m9a1WZhDjw//r9/iy28f8UgglutqNkMS2e8Fp81Dl9ZdHehGD4u4XCKuwa
         B+ysiCRnxM+crlC7U3SONJtsr8ME6ckOTjZ4AwfH853sLme5VA0ilHubzTnKUw/98FeF
         A0OfWH6DjDOgH5qOJQeL7PBt7+rXUkBM9szMmhcrAk7o5A7R7Y57+r3wBKg1tEV0Cw7B
         RRqauYp7sLpF8Kl4Tb64TUWOhJdDPUF12JZxGnQWdbDB70ER0UzGgfF5HIrrIfCvxxsV
         glpw==
X-Gm-Message-State: AOAM530N2+v82RXwIqwWYWSGQxmKBIJYEHjm3uIbpAIV33bNhA2II2B1
        5xOrxMG0qBl27BRpT5I68/z4vkVzD/Pm1Jb5+ccueinqKHOaWQ==
X-Google-Smtp-Source: ABdhPJwyYo57voaCpsKYwyZxrZ+khtyLLx4426NOaOrQkD45PzbE9Wr+akSc14AzeqrLFMOQGH7oSUDYh6gwsWnnZRk=
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr2914539wml.49.1637180186622;
 Wed, 17 Nov 2021 12:16:26 -0800 (PST)
MIME-Version: 1.0
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
 <20211117192031.3906502-2-eric.dumazet@gmail.com> <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Nov 2021 12:16:15 -0800
Message-ID: <CANn89iJ8HLjjpBPyFOn3xTXSnOJCbOGq5gORgPnsws-+sB8ipA@mail.gmail.com>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 11:20:30 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > It can be hard to track where references are taken and released.
> >
> > In networking, we have annoying issues at device dismantles,
> > and we had various proposals to ease root causing them.
> >
> > This patch adds new infrastructure pairing refcount increases
> > and decreases. This will self document code, because programmer
> > will have to associate increments/decrements.
> >
> > This is controled by CONFIG_REF_TRACKER which can be selected
> > by users of this feature.
> >
> > This adds both cpu and memory costs, and thus should be reserved
> > for debug kernel builds, or be enabled on demand with a static key.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Looks great, this is what I had in mind when I said:
>
> | In the future we can extend this structure to also catch those
> | who fail to release the ref on unregistering notification.
>
> I realized today we can get quite a lot of coverage by just plugging
> in object debug infra.
>
> The main differences I see:
>  - do we ever want to use this in prod? - if not why allocate the
>    tracker itself dynamically? The double pointer interface seems
>    harder to compile out completely

I think that maintaining the tracking state in separate storage would
detect cases
where the object has been freed, without the help of KASAN.

>  - whether one stored netdev ptr can hold multiple refs

For a same stack depot then ?

Problem is that at the time of dev_hold(), we do not know if
there is one associated dev_put() or multiple ones (different stack depot)


>  - do we want to wrap the pointer itself or have the "tracker" object
>    be a separate entity
>  - do we want to catch "use after free" when ref is accessed after
>    it was already released
>
> No strong preference either way.

BTW my current suspicion about reported leaks is in
rt6_uncached_list_flush_dev()

I was considering something like

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5e8f2f15607db7e6589b8bdb984e62512ad30589..233931b7c547d852ed3adeaa15f0a48f437b6596
100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -163,9 +163,6 @@ static void rt6_uncached_list_flush_dev(struct net
*net, struct net_device *dev)
        struct net_device *loopback_dev = net->loopback_dev;
        int cpu;

-       if (dev == loopback_dev)
-               return;
-
        for_each_possible_cpu(cpu) {
                struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
                struct rt6_info *rt;
@@ -175,7 +172,7 @@ static void rt6_uncached_list_flush_dev(struct net
*net, struct net_device *dev)
                        struct inet6_dev *rt_idev = rt->rt6i_idev;
                        struct net_device *rt_dev = rt->dst.dev;

-                       if (rt_idev->dev == dev) {
+                       if (rt_idev->dev == dev && dev != loopback_dev) {
                                rt->rt6i_idev = in6_dev_get(loopback_dev);
                                in6_dev_put(rt_idev);
                        }
